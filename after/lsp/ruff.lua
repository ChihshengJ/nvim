return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	-- Defer hover to ty; ruff handles linting/formatting/code actions.
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
}
