#!/usr/bin/env bash
#
# install.sh — one-command bootstrap for this Neovim config.
#
# What it does (all steps are idempotent, safe to re-run):
#   1. Detects OS / arch / package manager.
#   2. Installs Neovim (>= 0.11, the version this config targets).
#   3. Installs the external CLI tools the config drives:
#        ripgrep, fd        (telescope)
#        ruff, ty           (python: astral, via uv)
#        prettier, biome    (web/markdown/json/yaml, via npm)
#        shfmt              (shell formatting)
#        stylua             (lua formatting)
#   4. Links this repo into ~/.config/nvim (backing up anything already there).
#   5. Headlessly syncs lazy.nvim plugins and Mason LSP servers.
#
# Per-tool installs are best-effort: a failure warns and continues so one
# missing tool never aborts the whole bootstrap.
#
# Usage:
#   ./scripts/install.sh [options]
#     --nvim-version <tag>   Neovim release to install (default: stable)
#     --branch <name>        Config branch to clone (default: nightly)
#     --no-clone             Use the current checkout as-is; don't clone/link
#     --no-sync              Skip the headless plugin/Mason sync
#     --skip-nvim            Don't install Neovim (assume it's already present)
#     -h, --help             Show this help
#
# Remote install (no checkout yet):
#   curl -fsSL https://raw.githubusercontent.com/ChihshengJ/neovim-config/nightly/scripts/install.sh | bash

set -euo pipefail

# ---------------------------------------------------------------------------
# Config / defaults
# ---------------------------------------------------------------------------
REPO_URL="${NVIM_CONFIG_REPO:-https://github.com/ChihshengJ/neovim-config.git}"
BRANCH="nightly"
NVIM_VERSION="stable"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
PREFIX="$HOME/.local"
BIN_DIR="$PREFIX/bin"
DO_CLONE=true
DO_SYNC=true
DO_NVIM=true

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
	c_blue=$'\033[34m'; c_green=$'\033[32m'; c_yellow=$'\033[33m'
	c_red=$'\033[31m'; c_dim=$'\033[2m'; c_reset=$'\033[0m'
else
	c_blue=""; c_green=""; c_yellow=""; c_red=""; c_dim=""; c_reset=""
fi
info()  { printf '%s==>%s %s\n' "$c_blue"   "$c_reset" "$*"; }
ok()    { printf '%s  ✓%s %s\n' "$c_green"  "$c_reset" "$*"; }
warn()  { printf '%s  !%s %s\n' "$c_yellow" "$c_reset" "$*" >&2; }
err()   { printf '%s  ✗%s %s\n' "$c_red"    "$c_reset" "$*" >&2; }
step()  { printf '\n%s%s%s\n' "$c_dim" "$*" "$c_reset"; }

have() { command -v "$1" >/dev/null 2>&1; }

# Run a best-effort step: on failure, warn and keep going.
try() {
	if "$@"; then return 0; fi
	warn "step failed (continuing): $*"
	return 0
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
usage() { sed -n '3,30p' "$0" | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
	case "$1" in
		--nvim-version) NVIM_VERSION="$2"; shift 2 ;;
		--branch)       BRANCH="$2"; shift 2 ;;
		--no-clone)     DO_CLONE=false; shift ;;
		--no-sync)      DO_SYNC=false; shift ;;
		--skip-nvim)    DO_NVIM=false; shift ;;
		-h|--help)      usage; exit 0 ;;
		*) err "unknown option: $1"; usage; exit 1 ;;
	esac
done

# ---------------------------------------------------------------------------
# Platform detection
# ---------------------------------------------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
	Linux)  PLATFORM=linux ;;
	Darwin) PLATFORM=macos ;;
	*) err "unsupported OS: $OS"; exit 1 ;;
esac

# Normalised arch tokens used below (different projects spell these differently).
case "$ARCH" in
	x86_64|amd64)  ARCH_GNU=x86_64; ARCH_GO=amd64; ARCH_ALT=x86_64 ;;
	arm64|aarch64) ARCH_GNU=arm64;  ARCH_GO=arm64; ARCH_ALT=aarch64 ;;
	*) err "unsupported arch: $ARCH"; exit 1 ;;
esac

# Pick a package manager (used for base deps; tools have their own installers).
PM=""
PM_INSTALL=""
SUDO=""
[ "$(id -u)" -ne 0 ] && have sudo && SUDO="sudo"
if   have brew;    then PM=brew;    PM_INSTALL="brew install"
elif have apt-get; then PM=apt;     PM_INSTALL="$SUDO apt-get install -y"
elif have dnf;     then PM=dnf;     PM_INSTALL="$SUDO dnf install -y"
elif have pacman;  then PM=pacman;  PM_INSTALL="$SUDO pacman -S --noconfirm --needed"
elif have zypper;  then PM=zypper;  PM_INSTALL="$SUDO zypper install -y"
elif have apk;     then PM=apk;     PM_INSTALL="$SUDO apk add"
fi

mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

info "platform: $PLATFORM/$ARCH   package manager: ${PM:-none}"

# Install one or more package-manager packages, best effort.
pm() {
	[ -n "$PM_INSTALL" ] || { warn "no package manager; skipping: $*"; return 0; }
	# shellcheck disable=SC2086
	$PM_INSTALL "$@"
}

# Resolve the latest release tag of a GitHub repo without an API token
# (follows the /releases/latest redirect).
gh_latest_tag() {
	local repo="$1" url
	url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
		"https://github.com/$repo/releases/latest")" || return 1
	printf '%s\n' "${url##*/}"
}

# Download $1 to $2.
dl() { curl -fsSL "$1" -o "$2"; }

# ---------------------------------------------------------------------------
# 1. Base dependencies
# ---------------------------------------------------------------------------
step "[1/6] base dependencies"
for need in git curl tar unzip; do
	have "$need" || try pm "$need"
done

# ripgrep + fd power telescope. Package names differ across distros.
if ! have rg; then
	case "$PM" in
		apt) try pm ripgrep ;;
		*)   try pm ripgrep ;;
	esac
fi
if ! have fd && ! have fdfind; then
	case "$PM" in
		apt) try pm fd-find ;;     # binary is `fdfind` on Debian/Ubuntu
		*)   try pm fd ;;
	esac
fi
# A C toolchain is needed for nvim-treesitter parser compilation.
have cc || have gcc || have clang || case "$PM" in
	apt)         try pm build-essential ;;
	dnf|zypper)  try pm gcc make ;;
	pacman)      try pm base-devel ;;
	apk)         try pm build-base ;;
	brew)        : ;;  # Xcode CLT provides cc on macOS
esac
ok "base deps done"

# ---------------------------------------------------------------------------
# 2. Neovim
# ---------------------------------------------------------------------------
install_neovim() {
	if have nvim; then
		ok "neovim already installed: $(nvim --version | head -1)"
		return 0
	fi
	if [ "$PLATFORM" = macos ] && [ "$PM" = brew ]; then
		try brew install neovim && { have nvim && return 0; }
	fi

	# Official release tarball -> ~/.local/nvim, symlinked into ~/.local/bin.
	local asset tarball dest
	asset="nvim-${PLATFORM}-${ARCH_GNU}.tar.gz"
	info "downloading Neovim $NVIM_VERSION ($asset)"
	tarball="$(mktemp)"
	if ! dl "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${asset}" "$tarball"; then
		err "could not download $asset (check --nvim-version / arch)"
		rm -f "$tarball"; return 1
	fi
	dest="$PREFIX/nvim"
	rm -rf "$dest"; mkdir -p "$dest"
	tar -xzf "$tarball" -C "$dest" --strip-components=1
	rm -f "$tarball"
	ln -sf "$dest/bin/nvim" "$BIN_DIR/nvim"
	ok "neovim installed: $("$BIN_DIR/nvim" --version | head -1)"
}

step "[2/6] neovim"
if $DO_NVIM; then try install_neovim; else info "skipping neovim (--skip-nvim)"; fi

# ---------------------------------------------------------------------------
# 3. CLI tools
# ---------------------------------------------------------------------------
step "[3/6] cli tools"

# --- python: ruff + ty via uv (astral) --------------------------------------
install_uv_tools() {
	if ! have uv; then
		info "installing uv (astral)"
		curl -fsSL https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$BIN_DIR" sh -s -- -q \
			|| { warn "uv install failed; skipping ruff/ty"; return 0; }
	fi
	have ruff || try uv tool install ruff
	have ty   || try uv tool install ty
	# uv tools land in ~/.local/bin via `uv tool`'s default; make sure they link.
	uv tool update-shell >/dev/null 2>&1 || true
}
try install_uv_tools

# --- node: prettier + biome via npm (no sudo: global prefix -> ~/.local) -----
install_node_tools() {
	if ! have node || ! have npm; then
		info "installing node"
		case "$PM" in
			brew)        try brew install node ;;
			apt)         try pm nodejs npm ;;
			dnf|zypper)  try pm nodejs npm ;;
			pacman)      try pm nodejs npm ;;
			apk)         try pm nodejs npm ;;
			*)           warn "no package manager for node; skipping prettier/biome"; return 0 ;;
		esac
	fi
	have npm || { warn "npm unavailable; skipping prettier/biome"; return 0; }
	npm config set prefix "$PREFIX" >/dev/null 2>&1 || true
	have prettier || try npm install -g prettier
	have biome    || try npm install -g @biomejs/biome
}
try install_node_tools

# --- shfmt (mvdan/sh) -------------------------------------------------------
install_shfmt() {
	have shfmt && return 0
	case "$PM" in
		brew|pacman|apk) try pm shfmt && have shfmt && return 0 ;;
	esac
	if have go; then try go install mvdan.cc/sh/v3/cmd/shfmt@latest && have shfmt && return 0; fi
	local tag
	tag="$(gh_latest_tag mvdan/sh)" || { warn "shfmt: tag lookup failed"; return 0; }
	info "downloading shfmt $tag"
	dl "https://github.com/mvdan/sh/releases/download/${tag}/shfmt_${tag}_${PLATFORM/macos/darwin}_${ARCH_GO}" \
		"$BIN_DIR/shfmt" && chmod +x "$BIN_DIR/shfmt"
}
try install_shfmt

# --- stylua (JohnnyMorganz/StyLua) ------------------------------------------
install_stylua() {
	have stylua && return 0
	case "$PM" in
		brew) try pm stylua && have stylua && return 0 ;;
	esac
	if have cargo; then try cargo install stylua && have stylua && return 0; fi
	local tag zip
	tag="$(gh_latest_tag JohnnyMorganz/StyLua)" || { warn "stylua: tag lookup failed"; return 0; }
	info "downloading stylua $tag"
	zip="$(mktemp)"
	if dl "https://github.com/JohnnyMorganz/StyLua/releases/download/${tag}/stylua-${PLATFORM}-${ARCH_ALT}.zip" "$zip"; then
		unzip -oq "$zip" -d "$BIN_DIR" && chmod +x "$BIN_DIR/stylua"
	fi
	rm -f "$zip"
}
try install_stylua

# ---------------------------------------------------------------------------
# 4. Link the config into place
# ---------------------------------------------------------------------------
step "[4/6] config"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)"

place_config() {
	# If we're already running from inside the live config dir, nothing to do.
	if [ "$REPO_ROOT" = "$NVIM_CONFIG_DIR" ]; then
		ok "running from $NVIM_CONFIG_DIR; leaving in place"
		return 0
	fi
	if [ -e "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
		local backup="${NVIM_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
		warn "backing up existing config -> $backup"
		mv "$NVIM_CONFIG_DIR" "$backup"
	fi
	mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
	# If this script lives inside a checkout of the repo, symlink that checkout;
	# otherwise clone fresh.
	if [ -f "$REPO_ROOT/init.lua" ]; then
		ln -sfn "$REPO_ROOT" "$NVIM_CONFIG_DIR"
		ok "linked $REPO_ROOT -> $NVIM_CONFIG_DIR"
	else
		info "cloning $REPO_URL ($BRANCH)"
		git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$NVIM_CONFIG_DIR"
		ok "cloned into $NVIM_CONFIG_DIR"
	fi
}
if $DO_CLONE; then try place_config; else info "skipping config link (--no-clone)"; fi

# ---------------------------------------------------------------------------
# 5. Sync plugins + Mason servers headlessly
# ---------------------------------------------------------------------------
step "[5/6] plugin + LSP sync"
sync_editor() {
	have nvim || { warn "nvim not on PATH; skipping sync"; return 0; }
	info "lazy.nvim sync (first run downloads everything; be patient)"
	nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5 || true
	info "Mason: installing LSP servers"
	nvim --headless \
		"+lua require('mason-lspconfig')" \
		"+MasonInstall lua-language-server json-lsp clangd harper-ls ltex-ls-plus texlab" \
		+qa 2>&1 | tail -5 || true
	ok "sync complete"
}
if $DO_SYNC; then try sync_editor; else info "skipping sync (--no-sync)"; fi

# ---------------------------------------------------------------------------
# 6. Report
# ---------------------------------------------------------------------------
step "[6/6] summary"
printf '\n%sTool status:%s\n' "$c_blue" "$c_reset"
for t in nvim rg fd fdfind uv ruff ty node npm prettier biome shfmt stylua; do
	if have "$t"; then
		printf '  %s✓%s %-9s %s\n' "$c_green" "$c_reset" "$t" "$(command -v "$t")"
	else
		printf '  %s–%s %-9s %s(not found)%s\n' "$c_yellow" "$c_reset" "$t" "$c_dim" "$c_reset"
	fi
done

case ":$PATH:" in
	*":$BIN_DIR:"*) ;;
	*) printf '\n%sAdd %s to your PATH (e.g. in ~/.zshrc or ~/.bashrc):%s\n  export PATH="%s:$PATH"\n' \
		"$c_yellow" "$BIN_DIR" "$c_reset" "$BIN_DIR" ;;
esac

printf '\n%sDone.%s Open Neovim with: nvim\n' "$c_green" "$c_reset"
