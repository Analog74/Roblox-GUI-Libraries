--!strict
local Tokens = require(script.Parent.Parent.Tokens)

local Util = {}

function Util.applyCorner(gui: GuiObject)
    local c = Instance.new("UICorner")
    c.CornerRadius = Tokens.radius
    c.Parent = gui
end

function Util.applyPadding(gui: GuiObject, pad: number?)
    local p = Instance.new("UIPadding")
    local v = UDim.new(0, pad or Tokens.spacing.sm)
    p.PaddingLeft, p.PaddingRight, p.PaddingTop, p.PaddingBottom = v, v, v, v
    p.Parent = gui
end

return Util
