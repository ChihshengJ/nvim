return {
	filetypes = { "tex", "bib" },
	settings = {
		ltex = {
			language = "en-US",
			checkFrequency = "onEdit",
			disabledRules = {
				["en-US"] = { "DOUBLE_PUNCTUATION", "UPPERCASE_SENTENCE_START" },
			},
		},
	},
}
