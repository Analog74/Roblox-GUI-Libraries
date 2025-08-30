--!strict
local Tokens = require(script.Parent.Parent.Tokens)
local Util = require(script.Parent.Util)

export type ButtonProps = { text: string, onActivated: (() -> ())?, size: UDim2? }

return function(props: ButtonProps): TextButton
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = props.size or UDim2.fromOffset(140,32)
    btn.AutoButtonColor = false
    btn.Text = props.text
    btn.Font = Tokens.font
    btn.TextSize = 14
    btn.TextColor3 = Tokens.colors.text
    btn.BackgroundColor3 = Tokens.colors.accent
    btn.BorderSizePixel = 0
    Util.applyCorner(btn)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Tokens.colors.accentHover
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Tokens.colors.accent
    end)
    if props.onActivated then
        btn.Activated:Connect(props.onActivated)
    end
    return btn
end
