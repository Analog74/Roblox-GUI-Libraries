--!strict
-- TopBar controls: theme toggle, rebuild panels, metrics area
local Theme = require(script.Parent.Theme)
local ThemeManager = require(script.Parent.Theme.Manager)
local Registry = require(script.Parent.Registry)

export type Rebuilder = () -> ()

return function(parent: Instance, rebuild: Rebuilder)
	local bar = Instance.new("Frame")
	bar.Name = "TopBar"
	bar.Size = UDim2.new(1,0,0,36)
	bar.BackgroundColor3 = Theme.tokens.colors.panel
	bar.BorderColor3 = Theme.tokens.colors.border
	bar.Parent = parent

	local list = Instance.new("UIListLayout")
	list.FillDirection = Enum.FillDirection.Horizontal
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0,8)
	list.VerticalAlignment = Enum.VerticalAlignment.Center
	list.Parent = bar

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0,8)
	padding.PaddingRight = UDim.new(0,8)
	padding.Parent = bar

	local function makeButton(name: string, onClick: () -> ())
		local btn = Instance.new("TextButton")
		btn.Name = name .. "Button"
		btn.Size = UDim2.fromOffset(110,26)
		btn.Text = name
		btn.BackgroundColor3 = Theme.tokens.colors.accent
		btn.TextColor3 = Theme.tokens.colors.text
		btn.AutoButtonColor = true
		btn.Parent = bar
		local corner = Instance.new("UICorner"); corner.CornerRadius = Theme.tokens.corner; corner.Parent = btn
		btn.Activated:Connect(onClick)
		return btn
	end

	makeButton("Next Theme", function()
		if ThemeManager.nextVariant then
			ThemeManager.nextVariant()
		else
			-- fallback for older manager versions
			if ThemeManager.toggle then
				ThemeManager.toggle()
			end
		end
	end)

	makeButton("Rebuild", function()
		rebuild()
	end)

	-- Variant label
	local variantLabel = Instance.new("TextLabel")
	variantLabel.Size = UDim2.fromOffset(120,26)
	variantLabel.BackgroundTransparency = 1
	variantLabel.TextXAlignment = Enum.TextXAlignment.Left
	variantLabel.TextColor3 = Theme.tokens.colors.text
	variantLabel.Text = "Variant: "..ThemeManager.getVariant()
	variantLabel.Parent = bar

	ThemeManager.onChanged(function(v)
		variantLabel.Text = "Variant: "..v
		-- update accent backgrounds
		for _, child in bar:GetChildren() do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Theme.tokens.colors.accent
			end
		end
		bar.BackgroundColor3 = Theme.tokens.colors.panel
		bar.BorderColor3 = Theme.tokens.colors.border
	end)

	-- Panel count label
	local countLabel = Instance.new("TextLabel")
	countLabel.Size = UDim2.fromOffset(90,26)
	countLabel.BackgroundTransparency = 1
	countLabel.TextColor3 = Theme.tokens.colors.muted
	countLabel.Text = "Panels:"..tostring(#Registry.getPanels())
	countLabel.Parent = bar

	return bar
end
