--!strict
-- Central theme tokens for all framework demos
local Theme = {}

Theme.tokens = {
	font = Enum.Font.SourceSans,
	padding = 8,
	corner = UDim.new(0, 4),
	colors = {
		background = Color3.fromRGB(32, 32, 32),
		panel = Color3.fromRGB(45, 45, 45),
		border = Color3.fromRGB(70, 70, 70),
		accent = Color3.fromRGB(0, 170, 255),
		text = Color3.fromRGB(235, 235, 235),
		muted = Color3.fromRGB(160, 160, 160),
		success = Color3.fromRGB(80, 200, 120),
		warning = Color3.fromRGB(255, 180, 0),
		error = Color3.fromRGB(220, 70, 70),
	},
}

return Theme
