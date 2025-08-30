--!strict
-- Optionally replicate DesignLab UI to players when they join (for test environments)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ok, DesignLab = pcall(function()
	return require(ReplicatedStorage:WaitForChild("DesignLab"))
end)

if not ok then
	warn("DesignLab not found; ensure it is under ReplicatedStorage/DesignLab")
	return
end

local function onPlayerAdded(player: Player)
	task.defer(function()
		local guiParent = player:WaitForChild("PlayerGui")
		DesignLab.mount(guiParent)
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, pl in ipairs(Players:GetPlayers()) do
	onPlayerAdded(pl)
end
