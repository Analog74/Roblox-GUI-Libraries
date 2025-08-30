--!strict
local Theme = require(script.Parent.Parent.Theme)

-- Rex core location (curated copy)
local ok, RexCore = pcall(function()
	return require(game:GetService("ReplicatedStorage").External.Rex.Core.Rex)
end)

return function(parent: Instance)
	if not ok then
		local frame = Instance.new("Frame")
		frame.Name = "RexPanel"
		frame.Size = UDim2.fromOffset(260,160)
		frame.BackgroundColor3 = Theme.tokens.colors.panel
		frame.BorderColor3 = Theme.tokens.colors.border
		frame.Parent = parent
		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Size = UDim2.new(1,0,0,20)
		title.Font = Theme.tokens.font
		title.Text = "Rex Missing"
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.TextColor3 = Theme.tokens.colors.text
		title.Parent = frame
		return frame
	end

	local Rex = RexCore

	local function Panel()
		local count = Rex.useState(0)
		local colorState = Rex.useAutoComputed(function()
			local value = count:get()
			local t = (value % 10)/10
			return Theme.tokens.colors.accent:lerp(Color3.fromRGB(255,128,0), t)
		end)

		return Rex("Frame") {
			Name = "RexPanel",
			Size = UDim2.fromOffset(260,160),
			BackgroundColor3 = Theme.tokens.colors.panel,
			BorderColor3 = Theme.tokens.colors.border,

			Rex("UICorner") { CornerRadius = Theme.tokens.corner },
			Rex("UIStroke") { Color = Theme.tokens.colors.border, Thickness = 1 },
			Rex("UIPadding") {
				PaddingLeft = UDim.new(0, Theme.tokens.padding),
				PaddingRight = UDim.new(0, Theme.tokens.padding),
				PaddingTop = UDim.new(0, Theme.tokens.padding),
				PaddingBottom = UDim.new(0, Theme.tokens.padding)
			},
			Rex("TextLabel") {
				Text = "Rex Demo",
				Font = Theme.tokens.font,
				TextColor3 = Theme.tokens.colors.text,
				Size = UDim2.new(1,0,0,20),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
			Rex("Frame") {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0,28),
				Size = UDim2.new(1,0,1,-28),

				Rex("UIListLayout") { Padding = UDim.new(0,6), FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder },
				Rex("TextButton") {
					LayoutOrder = 1,
					Size = UDim2.new(1,0,0,30),
					Text = Rex.useAutoComputed(function()
						return "Increment: " .. tostring(count:get())
					end),
					Font = Theme.tokens.font,
					TextColor3 = Theme.tokens.colors.text,
					BackgroundColor3 = colorState,
					onClick = function()
						count:set(count:get()+1)
					end,
					Rex("UICorner") { CornerRadius = Theme.tokens.corner },
					Rex("UIStroke") { Color = Theme.tokens.colors.border, Thickness = 1 },
				},
				Rex("TextLabel") {
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
	end

	-- Render into container host frame
	local host = Instance.new("Folder")
	host.Name = "RexHost"
	host.Parent = parent
	local cleanup = Rex.render(Panel, host, { mode = "reactive" })

	return host
end
