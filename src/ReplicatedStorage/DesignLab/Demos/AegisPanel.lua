-- Real Aegis reactive demo panel
local Theme = require(script.Parent.Parent.Theme)

local ok, Aegis = pcall(function()
	return require(game:GetService("ReplicatedStorage").Packages.Aegis)
end)

return function(parent: Instance)
	if not ok then
		warn("Aegis not available; ensure dependency is installed.")
		return nil
	end

	-- Reactive state
	local count = Aegis.state(0)

	-- Root frame (using normal Instance.new because Aegis focuses on property helpers, not a virtual tree)
	local frame = Instance.new("Frame")
	frame.Name = "AegisPanel"
	frame.Size = UDim2.fromOffset(260,160)
	frame.BackgroundColor3 = Theme.tokens.colors.panel
	frame.BorderColor3 = Theme.tokens.colors.border
	frame.Parent = parent

	local corner = Instance.new("UICorner"); corner.CornerRadius = Theme.tokens.corner; corner.Parent = frame
	local stroke = Instance.new("UIStroke"); stroke.Color = Theme.tokens.colors.border; stroke.Thickness = 1; stroke.Parent = frame
	local padding = Instance.new("UIPadding");
	padding.PaddingLeft = UDim.new(0, Theme.tokens.padding)
	padding.PaddingRight = UDim.new(0, Theme.tokens.padding)
	padding.PaddingTop = UDim.new(0, Theme.tokens.padding)
	padding.PaddingBottom = UDim.new(0, Theme.tokens.padding)
	padding.Parent = frame

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1,0,0,20)
	title.Font = Theme.tokens.font
	title.Text = "Aegis Demo"
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextColor3 = Theme.tokens.colors.text
	title.Parent = frame

	local body = Instance.new("Frame")
	body.BackgroundTransparency = 1
	body.Position = UDim2.fromOffset(0,28)
	body.Size = UDim2.new(1,0,1,-28)
	body.Parent = frame

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0,6)
	list.FillDirection = Enum.FillDirection.Vertical
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = body

	-- Button created with Aegis.new so we can bind reactive properties in future
	local button = Aegis.new("TextButton", {
		LayoutOrder = 1,
		Size = UDim2.new(1,0,0,30),
		Text = "Increment: 0",
		Font = Theme.tokens.font,
		TextColor3 = Theme.tokens.colors.text,
		BackgroundColor3 = Theme.tokens.colors.accent,
		Parent = body,
	})

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = Theme.tokens.corner
	bCorner.Parent = button
	local bStroke = Instance.new("UIStroke")
	bStroke.Color = Theme.tokens.colors.border
	bStroke.Thickness = 1
	bStroke.Parent = button

	button.Activated:Connect(function()
		count:Set(count:Get()+1)
	end)

	-- React to count changes
	count:Listen(function(value: number)
		button.Text = "Increment: "..tostring(value)
		local t = (value % 10)/10
		button.BackgroundColor3 = Theme.tokens.colors.accent:lerp(Color3.fromRGB(255,128,0), t)
	end)

	local info = Instance.new("TextLabel")
	info.LayoutOrder = 2
	info.Size = UDim2.new(1,0,0,24)
	info.BackgroundTransparency = 1
	info.TextWrapped = true
	info.Font = Theme.tokens.font
	info.TextColor3 = Theme.tokens.colors.muted
	info.Text = "State + dynamic color via Aegis.state"
	info.Parent = body

	return frame
end
