--!strict
local Roact = require(game:GetService("ReplicatedStorage").Packages.Roact)
local Theme = require(script.Parent.Parent.Theme)

local Panel = Roact.Component:extend("RoactPanel")

function Panel:init()
	self:setState({ count = 0 })
end

function Panel:render()
	return Roact.createElement("Frame", {
		BackgroundColor3 = Theme.tokens.colors.panel,
		BorderColor3 = Theme.tokens.colors.border,
		Size = UDim2.fromOffset(260,160),
		Name = "RoactPanel",
	}, {
		Corner = Roact.createElement("UICorner", { CornerRadius = Theme.tokens.corner }),
		Stroke = Roact.createElement("UIStroke", { Color = Theme.tokens.colors.border, Thickness = 1 }),
		Padding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0,Theme.tokens.padding), PaddingRight=UDim.new(0,Theme.tokens.padding), PaddingTop=UDim.new(0,Theme.tokens.padding), PaddingBottom=UDim.new(0,Theme.tokens.padding)}),
		Title = Roact.createElement("TextLabel", {
			Text = "Roact Demo",
			Font = Theme.tokens.font,
			TextColor3 = Theme.tokens.colors.text,
			Size = UDim2.new(1,0,0,20),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		Body = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0,28),
			Size = UDim2.new(1,0,1,-28),
		}, {
			Layout = Roact.createElement("UIListLayout", { Padding = UDim.new(0,6), FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder }),
			Button = Roact.createElement("TextButton", {
				LayoutOrder = 1,
				Size = UDim2.new(1,0,0,30),
				Text = "Increment: " .. self.state.count,
				Font = Theme.tokens.font,
				TextColor3 = Theme.tokens.colors.text,
				BackgroundColor3 = Theme.tokens.colors.accent:lerp(Color3.fromRGB(255,128,0), (self.state.count % 10)/10),
				["Activated"] = function()
					self:setState(function(prev) return { count = prev.count + 1 } end)
				end
			}, {
				Corner = Roact.createElement("UICorner", { CornerRadius = Theme.tokens.corner }),
				Stroke = Roact.createElement("UIStroke", { Color = Theme.tokens.colors.border, Thickness = 1 }),
			}),
			Info = Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				Size = UDim2.new(1,0,0,24),
				BackgroundTransparency = 1,
				Text = "Color animates with count",
				TextColor3 = Theme.tokens.colors.muted,
				Font = Theme.tokens.font,
				TextSize = 14,
				TextWrapped = true,
			})
		})
	})
end

return function(parent: Instance)
	local handle = Roact.mount(Roact.createElement(Panel), parent, "RoactPanel")
	return function()
		Roact.unmount(handle)
	end
end
