--!strict
-- DesignSystem Tokens: central design primitives
local Tokens = {
    font = Enum.Font.Gotham,
    radius = UDim.new(0,6),
    spacing = { xs = 4, sm = 8, md = 12, lg = 16 },
    -- colors will be mutated by Theme manager variants
    colors = {
        background = Color3.fromRGB(30,30,32),
        surface = Color3.fromRGB(42,43,46),
        surfaceAlt = Color3.fromRGB(50,51,55),
        border = Color3.fromRGB(70,70,75),
        accent = Color3.fromRGB(0,160,255),
        accentHover = Color3.fromRGB(0,185,255),
        text = Color3.fromRGB(235,235,240),
        textMuted = Color3.fromRGB(160,160,170),
        danger = Color3.fromRGB(220,70,70),
    }
}
return Tokens
