return {
	filetypes = { "tex", "bib", "html" },
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
