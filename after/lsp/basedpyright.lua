return {
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				autoSearchPaths = true,
				autoImportCompletions = true,
				autoFormatStrings = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "standard",
				diagnosticSeverityOverrides = {
					reportAny = false,
					reportMissingTypeArgument = false,
					reportMissingTypeStubs = false,
					reportUnknownArgumentType = false,
					reportUnknownMemberType = false,
					reportUnknownParameterType = false,
					reportUnknownVariableType = false,
				},
				inlayHints = {
					genericTypes = false,
				},
			},
		},
		python = {},
	},
}
