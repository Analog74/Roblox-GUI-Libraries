--!strict
local Tokens = require(script.Parent.Parent.Tokens)
local Util = require(script.Parent.Util)

return function(props: {title: string?, size: UDim2?, parent: Instance?}): Frame
    local frame = Instance.new("Frame")
    frame.Name = "Panel"
    frame.Size = props.size or UDim2.fromOffset(320,200)
    frame.BackgroundColor3 = Tokens.colors.surface
    frame.BorderColor3 = Tokens.colors.border
    frame.Parent = props.parent
    Util.applyCorner(frame)
    local titleBar = Instance.new("TextLabel")
    titleBar.BackgroundTransparency = 1
    titleBar.Size = UDim2.new(1,-16,0,24)
    titleBar.Position = UDim2.fromOffset(8,6)
    titleBar.Font = Tokens.font
    titleBar.TextSize = 18
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.TextColor3 = Tokens.colors.text
    titleBar.Text = props.title or "Panel"
    titleBar.Parent = frame
    return frame
end
