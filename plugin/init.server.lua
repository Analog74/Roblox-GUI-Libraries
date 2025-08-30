--!strict
-- Basic design plugin entry: opens a dock widget to host storybook (requires test place with DesignSystem present if using live sync)
local toolbar = plugin:CreateToolbar("Design System")
local button = toolbar:CreateButton("DesignStorybook", "Open Design Storybook", "")

local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, false, 600, 400, 400, 300)
local widget = plugin:CreateDockWidgetPluginGui("DesignStorybookWidget", widgetInfo)
widget.Title = "Design Storybook"

local mounted = false

local function mount()
    if mounted then return end
    mounted = true
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Ds = ReplicatedStorage:FindFirstChild("DesignSystem")
    if not Ds then
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.fromScale(1,1)
        msg.BackgroundTransparency = 1
        msg.TextWrapped = true
        msg.Text = "DesignSystem not found (ensure Rojo sync running)."
        msg.Parent = widget
        return
    end
    local Registry = require(Ds:WaitForChild("StoryRegistry"))
    local Theme = require(Ds:WaitForChild("Theme"))
    -- panel mount reused from client loader for parity
    local holder = Instance.new("Frame"); holder.Size = UDim2.fromScale(1,1); holder.BackgroundTransparency = 1; holder.Parent = widget
    local themeBtn = Instance.new("TextButton")
    themeBtn.Size = UDim2.fromOffset(120,28)
    themeBtn.Position = UDim2.fromOffset(0,0)
    themeBtn.Text = "Theme: " .. Theme.getVariant()
    themeBtn.BackgroundColor3 = Color3.fromRGB(90,90,95)
    themeBtn.TextColor3 = Color3.fromRGB(240,240,245)
    themeBtn.Parent = holder
    themeBtn.Activated:Connect(function()
        local nxt = Theme.nextVariant()
        themeBtn.Text = "Theme: " .. nxt
    end)

    local offset = 1
    for _, story in Registry.get() do
        -- build buttons across top for quick jump
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(120,28)
        btn.Position = UDim2.fromOffset((offset)*124,0)
        btn.Text = story.name
        btn.BackgroundColor3 = Color3.fromRGB(60,60,64)
        btn.TextColor3 = Color3.fromRGB(240,240,245)
        btn.Parent = holder
        btn.Activated:Connect(function()
            for _, c in holder:GetChildren() do if c.Name == "StoryRoot" then c:Destroy() end end
            local root = Instance.new("Frame"); root.Name = "StoryRoot"; root.BackgroundTransparency = 1; root.Position = UDim2.new(0,0,0,32); root.Size = UDim2.new(1,0,1,-32); root.Parent = holder
            story.factory(root)
        end)
        offset += 1
    end
end

button.Click:Connect(function()
    widget.Enabled = not widget.Enabled
    if widget.Enabled then mount() end
end)
