--!strict
-- Mounts a lightweight storybook UI listing registered stories
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ds = ReplicatedStorage:WaitForChild("DesignSystem")
local Registry = require(Ds:WaitForChild("StoryRegistry"))
local Theme = require(Ds:WaitForChild("Theme"))

-- Auto-register bundled stories
Registry.register("Buttons", require(Ds.Stories.ButtonGallery))
Registry.register("Layout", require(Ds.Stories.LayoutDemo))

local screen = Instance.new("ScreenGui")
screen.Name = "Storybook"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0,160,1,0)
sidebar.BackgroundColor3 = Theme.getVariant() == "light" and Color3.fromRGB(235,235,240) or Color3.fromRGB(25,25,26)
sidebar.BorderSizePixel = 0
sidebar.Parent = screen
local list = Instance.new("UIListLayout"); list.Parent = sidebar; list.Padding = UDim.new(0,4); list.FillDirection = Enum.FillDirection.Vertical
local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0,8); pad.PaddingLeft = UDim.new(0,8); pad.Parent = sidebar

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0,160,0,0)
content.Size = UDim2.new(1,-160,1,0)
content.BackgroundColor3 = Theme.getVariant() == "light" and Color3.fromRGB(250,250,252) or Color3.fromRGB(34,34,36)
content.BorderSizePixel = 0
content.Parent = screen

local current: Instance? = nil
local function show(factory)
    if current then current:Destroy(); current = nil end
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1,0,1,0)
    holder.Parent = content
    factory(holder)
    current = holder
end

-- Theme cycle button
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1,-8,0,28)
themeBtn.Text = "Theme: " .. Theme.getVariant()
themeBtn.BackgroundColor3 = Color3.fromRGB(90,90,95)
themeBtn.TextColor3 = Color3.fromRGB(240,240,245)
themeBtn.BorderSizePixel = 0
themeBtn.Parent = sidebar
themeBtn.Activated:Connect(function()
    local nxt = Theme.nextVariant()
    themeBtn.Text = "Theme: " .. nxt
end)

Theme.onChanged(function(v)
    -- crude recolor (storybook elements not fully tokenized yet)
    sidebar.BackgroundColor3 = (v == "light") and Color3.fromRGB(235,235,240) or (v == "high_contrast" and Color3.fromRGB(0,0,0) or Color3.fromRGB(25,25,26))
    content.BackgroundColor3 = (v == "light") and Color3.fromRGB(250,250,252) or (v == "high_contrast" and Color3.fromRGB(18,18,18) or Color3.fromRGB(34,34,36))
    -- refresh current story to re-pull token colors
    if current then
        for _, c in content:GetChildren() do c:Destroy() end
        current = nil
        local first = Registry.get()[1]
        if first then show(first.factory) end
    end
end)

for _, story in Registry.get() do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-8,0,32)
    btn.Text = story.name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,64)
    btn.TextColor3 = Color3.fromRGB(240,240,245)
    btn.BorderSizePixel = 0
    btn.Parent = sidebar
    btn.Activated:Connect(function()
        show(story.factory)
    end)
end

-- Auto-open first
local first = Registry.get()[1]
if first then show(first.factory) end
