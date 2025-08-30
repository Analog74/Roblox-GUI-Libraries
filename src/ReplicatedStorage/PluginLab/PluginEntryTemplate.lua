--!strict
-- TEMPLATE: Example plugin entry integration with DesignLab panels (pseudo-code)
-- Copy this file into a real plugin repository and adapt. Requires a Plugin object context.

--[[
local toolbar = plugin:CreateToolbar("DesignLab")
local button = toolbar:CreateButton("OpenLab", "Open DesignLab DockWidget", "")

local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, true, false, 480, 600, 320, 400)
local widget = plugin:CreateDockWidgetPluginGui("DesignLabDock", info)
widget.Title = "DesignLab"

-- Mount panels inside widget
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DesignLab = require(ReplicatedStorage:WaitForChild("DesignLab"))
DesignLab.mount(widget)
]]

return {}
