-- Placeholder for future StudioComponents integration
-- Provides a simple static preview so layout & search/perf badge systems can exercise it.
local Theme = require(script.Parent.Parent.Theme)

return function(parent: Instance)
	local frame = Instance.new("Frame")
	frame.Name = "StudioComponentsPanel"
	frame.Size = UDim2.fromOffset(260, 160)
	frame.BackgroundColor3 = Theme.tokens.colors.panel
	frame.BorderColor3 = Theme.tokens.colors.border
	frame.Parent = parent

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -12, 0, 20)
	title.Position = UDim2.fromOffset(6,6)
	title.BackgroundTransparency = 1
	title.Font = Theme.tokens.font
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = Theme.tokens.colors.text
	title.Text = "StudioComponents (Soon)"
	title.Parent = frame

	local body = Instance.new("TextLabel")
	body.Size = UDim2.new(1, -12, 0, 60)
	body.Position = UDim2.fromOffset(6,32)
	body.BackgroundTransparency = 1
	body.Font = Theme.tokens.font
	body.TextWrapped = true
	body.TextSize = 14
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.TextColor3 = Theme.tokens.colors.muted
	body.Text = "Will showcase native-like Studio themed components with adaptive styling & interaction states."
	body.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = Theme.tokens.corner
	corner.Parent = frame

	return frame
end
