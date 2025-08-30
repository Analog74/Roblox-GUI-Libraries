--!strict
local Button = require(script.Parent.Parent.Components.Button)
local Stack = require(script.Parent.Parent.Components.Stack)
local Tokens = require(script.Parent.Parent.Tokens)

return function(parent: Instance)
    local root = Instance.new("Frame")
    root.BackgroundTransparency = 1
    root.Size = UDim2.new(1,0,1,0)
    root.Parent = parent

    local stack = Stack{parent = root, gap = Tokens.spacing.sm, padding = Tokens.spacing.sm}
    stack.Size = UDim2.new(0, 200, 0, 200)

    Button{ text = "Primary", onActivated = function() print("Primary clicked") end }.Parent = stack
    Button{ text = "Another" }.Parent = stack

    return root
end
