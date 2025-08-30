--!strict
local Fusion = require(game:GetService("ReplicatedStorage").Packages.Fusion)
local Theme = require(script.Parent.Parent.Theme)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed

return function(parent: Instance)
	local counter = Value(0)

	local buttonColor = Computed(function()
		return Theme.tokens.colors.accent:Lerp(Color3.fromRGB(255,128,0), (counter:get() % 10)/10)
	end)

	local gui = New "Frame" {
		Name = "FusionPanel",
		Parent = parent,
		BackgroundColor3 = Theme.tokens.colors.panel,
		BorderColor3 = Theme.tokens.colors.border,
		Size = UDim2.fromOffset(260, 160),
		[Children] = {
			New "UICorner" { CornerRadius = Theme.tokens.corner },
			New "UIStroke" { Color = Theme.tokens.colors.border, Thickness = 1 },
			New "UIPadding" { PaddingLeft = UDim.new(0, Theme.tokens.padding), PaddingRight = UDim.new(0, Theme.tokens.padding), PaddingTop = UDim.new(0, Theme.tokens.padding), PaddingBottom = UDim.new(0, Theme.tokens.padding) },
			New "TextLabel" {
				Text = "Fusion Demo",
				Font = Theme.tokens.font,
				TextColor3 = Theme.tokens.colors.text,
				Size = UDim2.new(1,0,0,20),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
			New "Frame" {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0,28),
				Size = UDim2.new(1,0,1,-28),
				[Children] = {
					New "UIListLayout" { Padding = UDim.new(0,6), FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder },
					New "TextButton" {
						LayoutOrder = 1,
						Size = UDim2.new(1,0,0,30),
						Text = Computed(function() return "Increment: "..counter:get() end),
						Font = Theme.tokens.font,
						TextColor3 = Theme.tokens.colors.text,
						BackgroundColor3 = buttonColor,
						[Children] = {
							New "UICorner" { CornerRadius = Theme.tokens.corner },
							New "UIStroke" { Color = Theme.tokens.colors.border, Thickness = 1 },
						},
						["Activated"] = function()
							counter:set(counter:get()+1)
						end
					},
					New "TextLabel" {
						LayoutOrder = 2,
						Size = UDim2.new(1,0,0,24),
						BackgroundTransparency = 1,
						Text = "Reactive color animates with count",
						TextColor3 = Theme.tokens.colors.muted,
						Font = Theme.tokens.font,
						TextWrapped = true,
						TextSize = 14,
					},
				}
			}
		}
	}

	return gui
end
