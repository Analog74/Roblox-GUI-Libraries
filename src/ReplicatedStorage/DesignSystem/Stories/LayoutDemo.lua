--!strict
local Stack = require(script.Parent.Parent.Components.Stack)
local Panel = require(script.Parent.Parent.Components.Panel)
local Button = require(script.Parent.Parent.Components.Button)
local Tokens = require(script.Parent.Parent.Tokens)

return function(parent: Instance)
    local panel = Panel{parent = parent, title = "Layout Demo", size = UDim2.fromOffset(360,220)}
    local inner = Stack{parent = panel, padding = Tokens.spacing.md, gap = Tokens.spacing.sm}
    inner.Size = UDim2.new(1,-20,1,-40)
    inner.Position = UDim2.fromOffset(10,34)
    for i=1,3 do
        Button{ text = "Action "..i }.Parent = inner
    end
    return panel
end
