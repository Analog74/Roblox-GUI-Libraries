--!strict
-- Simple vertical or horizontal stack layout
local Tokens = require(script.Parent.Parent.Tokens)

return function(props: {direction: "x"|"y"?, padding: number?, gap: number?, parent: Instance?}): Frame
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Name = "Stack"
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = (props.direction == "x") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, props.gap or Tokens.spacing.sm)
    layout.Parent = frame
    local pad = Instance.new("UIPadding")
    local v = UDim.new(0, props.padding or 0)
    pad.PaddingLeft, pad.PaddingRight, pad.PaddingTop, pad.PaddingBottom = v,v,v,v
    pad.Parent = frame
    if props.parent then frame.Parent = props.parent end
    return frame
end
