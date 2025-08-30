--!strict
-- Metrics overlay: FPS + simple memory (approx) updated every second
local Theme = require(script.Parent.Theme)

return function(parent: Instance)
	local label = Instance.new("TextLabel")
	label.Name = "Metrics"
	label.BackgroundTransparency = 0.2
	label.BackgroundColor3 = Theme.tokens.colors.panel
	label.BorderColor3 = Theme.tokens.colors.border
	label.TextColor3 = Theme.tokens.colors.muted
	label.Font = Theme.tokens.font
	label.TextSize = 14
	label.Position = UDim2.new(1,-180,1,-60)
	label.Size = UDim2.fromOffset(170,50)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextWrapped = true
	label.Parent = parent

	local corner = Instance.new("UICorner"); corner.CornerRadius = Theme.tokens.corner; corner.Parent = label
	local stroke = Instance.new("UIStroke"); stroke.Color = Theme.tokens.colors.border; stroke.Thickness = 1; stroke.Parent = label

	local frames = 0
	local last = os.clock()

	game:GetService("RunService").Heartbeat:Connect(function()
		frames += 1
		local now = os.clock()
		if now - last >= 1 then
			local fps = frames / (now-last)
			frames = 0
			last = now
			local mem = collectgarbage("count")/1024 -- MB approx
			label.Text = string.format("FPS: %.1f\nLua Mem: %.2fMB", fps, mem)
		end
	end)

	return label
end
