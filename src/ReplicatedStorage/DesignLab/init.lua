--!strict
-- DesignLab bootstrap: create a screen space container and mount demo panels
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(script.Theme)
local ThemeManager = require(script.Theme.Manager)
local Registry = require(script.Registry)
local TopBar = require(script.TopBar)
local Metrics = require(script.Metrics)

-- Panels
local FusionPanel = require(script.Demos.FusionPanel)
local RoactPanel = require(script.Demos.RoactPanel)
local AegisPanel = require(script.Demos.AegisPanel)
local RexPanel = require(script.Demos.RexPanel)
local BenchmarkPanel = require(script.Demos.BenchmarkPanel)
local StudioComponentsPanel = require(script.Demos.StudioComponentsPanel)

-- Optional TS panel
local TsPanelModule do
	local ok, mod = pcall(function()
		return require(ReplicatedStorage:FindFirstChild("TS") and ReplicatedStorage.TS:FindFirstChild("DesignLabTsPanel"))
	end)
	if ok and type(mod) == "function" then TsPanelModule = mod end
end

-- Register panels (idempotent)
Registry.register("Fusion", FusionPanel, {category="framework"})
Registry.register("Roact", function(parent)
	local container = Instance.new("Folder"); container.Name = "RoactHost"; container.Parent = parent; RoactPanel(container); return container
end, {category="framework"})
Registry.register("Aegis", AegisPanel, {category="framework"})
Registry.register("Rex", RexPanel, {category="framework"})
Registry.register("Bench", BenchmarkPanel, {category="metrics"})
Registry.register("StudioComponents", StudioComponentsPanel, {category="framework", tags={"placeholder"}})
if TsPanelModule then
	Registry.register("TypeScript", TsPanelModule, {category="framework", tags={"ts"}})
end

local DesignLab = {}

local function attachPerfBadge(root: Instance, ms: number)
	if root:IsA("GuiObject") then
		local label = Instance.new("TextLabel")
		label.Name = "__Perf"
		label.BackgroundTransparency = 0.4
		label.BackgroundColor3 = Theme.tokens.colors.panel
		label.BorderSizePixel = 0
		label.Text = string.format("%.1fms", ms)
		label.TextSize = 10
		label.Font = Theme.tokens.font
		label.TextColor3 = Theme.tokens.colors.muted
		label.Size = UDim2.fromOffset(50,14)
		label.Position = UDim2.new(1,-52,0,2)
		label.Parent = root
	end
end

local currentFilter: string? = nil
local categoryFilter: string? = nil

local function mountPanels(container: Instance)
	for _, child in container:GetChildren() do child:Destroy() end
	for _, rec in Registry.getPanels() do
		if currentFilter == nil or string.find(string.lower(rec.name), string.lower(currentFilter)) then
			if not categoryFilter or rec.category == categoryFilter then
			local t0 = os.clock()
			local ok, res = pcall(function()
				return rec.factory(container)
			end)
			local dt = (os.clock()-t0)*1000
			if not ok then
				warn("Panel failed:", rec.name, res)
			else
				if typeof(res) == "Instance" and res then
					attachPerfBadge(res :: Instance, dt)
				end
			end
			end
		end
	end
end

function DesignLab.mount(parent: Instance)
	local folder = Instance.new("Folder")
	folder.Name = "DesignLab"
	folder.Parent = parent

	local screen = Instance.new("ScreenGui")
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false
	screen.Name = "DesignLabUI"
	screen.Parent = folder

	local contentHolder = Instance.new("Frame")
	contentHolder.Name = "Content"
	contentHolder.AnchorPoint = Vector2.new(0,1)
	contentHolder.Position = UDim2.new(0,0,1,0)
	contentHolder.Size = UDim2.new(1,0,1,-36) -- leave space for top bar
	contentHolder.BackgroundColor3 = Theme.tokens.colors.background
	contentHolder.BorderSizePixel = 0
	contentHolder.Parent = screen

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.fromOffset(280,180)
	grid.CellPadding = UDim2.fromOffset(12,12)
	grid.SortOrder = Enum.SortOrder.LayoutOrder
	grid.Parent = contentHolder

	local function rebuild()
		mountPanels(contentHolder)
	end

	TopBar(screen, function()
		rebuild()
	end)
	-- Search bar + category filter
	local searchHolder = Instance.new("Frame")
	searchHolder.Name = "SearchBar"
	searchHolder.Size = UDim2.new(1,0,0,28)
	searchHolder.Position = UDim2.new(0,0,0,36)
	searchHolder.BackgroundColor3 = Theme.tokens.colors.panel
	searchHolder.BorderColor3 = Theme.tokens.colors.border
	searchHolder.Parent = screen
	local box = Instance.new("TextBox")
	box.PlaceholderText = "Search panels..."
	box.ClearTextOnFocus = false
	box.Font = Theme.tokens.font
	box.TextSize = 14
	box.BackgroundColor3 = Theme.tokens.colors.background
	box.TextColor3 = Theme.tokens.colors.text
	box.Size = UDim2.new(0,220,1,-6)
	box.Position = UDim2.fromOffset(6,3)
	box.Parent = searchHolder
	local corner = Instance.new("UICorner"); corner.CornerRadius = Theme.tokens.corner; corner.Parent = box
	box:GetPropertyChangedSignal("Text"):Connect(function()
		currentFilter = box.Text ~= "" and box.Text or nil
		rebuild()
	end)

	-- Category dropdown (simple cycle button)
	local catBtn = Instance.new("TextButton")
	catBtn.Name = "CategoryButton"
	catBtn.Text = "Category: ALL"
	catBtn.Font = Theme.tokens.font
	catBtn.TextSize = 14
	catBtn.Size = UDim2.fromOffset(140,22)
	catBtn.Position = UDim2.fromOffset(240,3)
	catBtn.BackgroundColor3 = Theme.tokens.colors.background
	catBtn.TextColor3 = Theme.tokens.colors.text
	catBtn.Parent = searchHolder
	local catCorner = Instance.new("UICorner"); catCorner.CornerRadius = Theme.tokens.corner; catCorner.Parent = catBtn
	local categories = {"ALL"}
	-- build unique categories
	local seen = {}
	for _, rec in Registry.getPanels() do
		if not seen[rec.category] then
			seen[rec.category] = true
			table.insert(categories, rec.category)
		end
	end
	local catIndex = 1
	catBtn.Activated:Connect(function()
		catIndex = (catIndex % #categories) + 1
		local picked = categories[catIndex]
		if picked == "ALL" then categoryFilter = nil else categoryFilter = picked end
		catBtn.Text = "Category: "..picked
		rebuild()
	end)

	contentHolder.Position = UDim2.new(0,0,0,36+28)
	contentHolder.Size = UDim2.new(1,0,1,-(36+28))

	Metrics(screen)
	mountPanels(contentHolder)

	ThemeManager.onChanged(function()
		contentHolder.BackgroundColor3 = Theme.tokens.colors.background
	end)

	return folder
end

return DesignLab
