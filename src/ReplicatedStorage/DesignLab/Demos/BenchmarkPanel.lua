--!strict
-- Simple micro-benchmark comparing mount + 25 increment updates for each framework
local Theme = require(script.Parent.Parent.Theme)

local okFusion, Fusion = pcall(function()
    return require(game:GetService("ReplicatedStorage").Packages.Fusion)
end)
local okRoact, Roact = pcall(function()
    return require(game:GetService("ReplicatedStorage").Packages.Roact)
end)
local okAegis, Aegis = pcall(function()
    return require(game:GetService("ReplicatedStorage").Packages.Aegis)
end)
local okRex, Rex = pcall(function()
    return require(game:GetService("ReplicatedStorage").External.Rex.Core.Rex)
end)

local function time(label: string, fn: () -> ())
    local start = os.clock()
    debug.profilebegin(label)
    fn()
    debug.profileend()
    return (os.clock()-start)*1000 -- ms
end

local function benchFusion()
    if not okFusion then return nil end
    local New = Fusion.New
    local Value = Fusion.Value
    local counter = Value(0)
    local gui
    local mountMs = time("fusion_mount", function()
        gui = New "Frame" { Size = UDim2.fromOffset(0,0), [Fusion.Children] = { New "TextLabel" { Text = counter } } }
    end)
    local updateMs = time("fusion_updates", function()
        for i=1,25 do counter:set(i) end
    end)
    if gui then gui:Destroy() end
    return mountMs, updateMs
end

local function benchRoact()
    if not okRoact then return nil end
    local component = Roact.Component:extend("Bench")
    function component:init() self:setState({count=0}) end
    function component:render()
        return Roact.createElement("Frame", {Size=UDim2.fromOffset(0,0)}, {
            L = Roact.createElement("TextLabel", {Text = tostring(self.state.count)})
        })
    end
    local handle
    local mountMs = time("roact_mount", function()
        handle = Roact.mount(Roact.createElement(component))
    end)
    local updateMs = time("roact_updates", function()
        for i=1,25 do
            Roact.update(handle, Roact.createElement(component, {count=i}))
        end
    end)
    Roact.unmount(handle)
    return mountMs, updateMs
end

local function benchAegis()
    if not okAegis then return nil end
    local state = Aegis.state(0)
    local frame
    local mountMs = time("aegis_mount", function()
        frame = Aegis.new("Frame", { Size = UDim2.fromOffset(0,0) })
    end)
    local updateMs = time("aegis_updates", function()
        for i=1,25 do state:Set(i) end
    end)
    if frame then frame:Destroy() end
    return mountMs, updateMs
end

local function benchRex()
    if not okRex then return nil end
    local host = Instance.new("Folder")
    local countState
    local function App()
        countState = Rex.useState(0)
        return Rex("Frame") {}
    end
    local mountMs = time("rex_mount", function()
        Rex.render(App, host, {mode="reactive"})
    end)
    local updateMs = time("rex_updates", function()
        for i=1,25 do countState:set(i) end
    end)
    host:Destroy()
    return mountMs, updateMs
end

return function(parent: Instance)
    local frame = Instance.new("Frame")
    frame.Name = "BenchmarkPanel"
    frame.Size = UDim2.fromOffset(260,160)
    frame.BackgroundColor3 = Theme.tokens.colors.panel
    frame.BorderColor3 = Theme.tokens.colors.border
    frame.Parent = parent

    local corner = Instance.new("UICorner"); corner.CornerRadius = Theme.tokens.corner; corner.Parent = frame
    local stroke = Instance.new("UIStroke"); stroke.Color = Theme.tokens.colors.border; stroke.Thickness = 1; stroke.Parent = frame
    local padding = Instance.new("UIPadding"); padding.PaddingLeft = UDim.new(0,Theme.tokens.padding); padding.PaddingRight = UDim.new(0,Theme.tokens.padding); padding.PaddingTop = UDim.new(0,Theme.tokens.padding); padding.PaddingBottom = UDim.new(0,Theme.tokens.padding); padding.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1,0,0,20)
    title.Font = Theme.tokens.font
    title.Text = "Benchmarks (ms)"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Theme.tokens.colors.text
    title.Parent = frame

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(0,28)
    body.Size = UDim2.new(1,0,1,-28)
    body.Font = Theme.tokens.font
    body.TextWrapped = true
    body.TextColor3 = Theme.tokens.colors.muted
    body.Text = "Running..."
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.RichText = true
    body.Parent = frame

    local function runOnce()
        local lines = {}
        local fM,fU = benchFusion() if fM then table.insert(lines, string.format("Fusion: %.2f / %.2f", fM, fU or 0)) end
        local rM,rU = benchRoact() if rM then table.insert(lines, string.format("Roact: %.2f / %.2f", rM, rU or 0)) end
        local aM,aU = benchAegis() if aM then table.insert(lines, string.format("Aegis: %.2f / %.2f", aM, aU or 0)) end
        local xM,xU = benchRex() if xM then table.insert(lines, string.format("Rex: %.2f / %.2f", xM, xU or 0)) end
        if #lines == 0 then
            body.Text = "No frameworks available."
        else
            body.Text = "<b>mount / updates</b>\n" .. table.concat(lines, "\n")
        end
    end
    task.spawn(function()
        while frame.Parent do
            runOnce()
            task.wait(5) -- refresh every 5s
        end
    end)

    return frame
end
