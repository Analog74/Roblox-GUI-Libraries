--!strict
-- DesignSystem Theme Manager: variants + reactive mutation of Tokens.colors
local Tokens = require(script.Parent.Tokens)

local Theme = {}

local variants: {[string]: {[string]: any}} = {
    dark = {
        background = Color3.fromRGB(30,30,32),
        surface = Color3.fromRGB(42,43,46),
        surfaceAlt = Color3.fromRGB(50,51,55),
        border = Color3.fromRGB(70,70,75),
        accent = Color3.fromRGB(0,160,255),
        accentHover = Color3.fromRGB(0,185,255),
        text = Color3.fromRGB(235,235,240),
        textMuted = Color3.fromRGB(160,160,170),
        danger = Color3.fromRGB(220,70,70),
    },
    light = {
        background = Color3.fromRGB(250,250,252),
        surface = Color3.fromRGB(240,241,244),
        surfaceAlt = Color3.fromRGB(232,233,236),
        border = Color3.fromRGB(200,200,205),
        accent = Color3.fromRGB(0,120,255),
        accentHover = Color3.fromRGB(0,140,255),
        text = Color3.fromRGB(25,25,30),
        textMuted = Color3.fromRGB(90,90,100),
        danger = Color3.fromRGB(210,60,60),
    },
    high_contrast = {
        background = Color3.fromRGB(0,0,0),
        surface = Color3.fromRGB(18,18,18),
        surfaceAlt = Color3.fromRGB(28,28,28),
        border = Color3.fromRGB(255,255,255),
        accent = Color3.fromRGB(255,210,0),
        accentHover = Color3.fromRGB(255,235,0),
        text = Color3.fromRGB(255,255,255),
        textMuted = Color3.fromRGB(210,210,210),
        danger = Color3.fromRGB(255,90,90),
    },
}

local current = "dark"
local changed = Instance.new("BindableEvent")

local function applyVariant(name: string)
    local variant = variants[name]
    if not variant then return end
    for k,_ in Tokens.colors do Tokens.colors[k] = nil end
    for k,v in variant do Tokens.colors[k] = v end
    current = name
    changed:Fire(current)
end

function Theme.getVariant(): string
    return current
end

function Theme.setVariant(name: string)
    if variants[name] then
        applyVariant(name)
    else
        warn("Unknown theme variant", name)
    end
end

function Theme.nextVariant(): string
    local order = {"dark","light","high_contrast"}
    for i,n in order do
        if n == current then
            local nxt = order[(i % #order) + 1]
            applyVariant(nxt)
            return nxt
        end
    end
    return current
end

function Theme.onChanged(cb: (string)->())
    return changed.Event:Connect(cb)
end

function Theme.list(): {string}
    local names = {}
    for n,_ in variants do table.insert(names, n) end
    table.sort(names)
    return names
end

-- initialize dark already defined in Tokens.lua, so just ensure structure
applyVariant(current)

return Theme
