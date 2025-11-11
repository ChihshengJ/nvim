return {
	"chrisgrieser/nvim-early-retirement",
	config = true,
	event = "VeryLazy",
	opts = {
		retirementAgeMins = 15,
		minimumBufferNum = 3,
		ignoreVisibleBufs = true,
	},
}
