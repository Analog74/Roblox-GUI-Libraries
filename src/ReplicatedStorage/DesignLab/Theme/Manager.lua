--!strict
-- Theme Manager: runtime switchable variants & change notifications

local Theme = require(script.Parent)

local Manager = {}

local variants = {
	dark = Theme.tokens.colors, -- existing default as dark
	light = {
		panel = Color3.fromRGB(245,245,248),
		background = Color3.fromRGB(255,255,255),
		border = Color3.fromRGB(210,210,215),
		accent = Color3.fromRGB(0,120,255),
		text = Color3.fromRGB(20,20,25),
		muted = Color3.fromRGB(90,90,100),
		success = Color3.fromRGB(0,170,90),
		warning = Color3.fromRGB(210,140,0),
		error = Color3.fromRGB(210,60,60),
	},
	high_contrast = {
		panel = Color3.fromRGB(18,18,18),
		background = Color3.fromRGB(0,0,0),
		border = Color3.fromRGB(255,255,255),
		accent = Color3.fromRGB(255,210,0),
		text = Color3.fromRGB(255,255,255),
		muted = Color3.fromRGB(200,200,200),
		success = Color3.fromRGB(0,255,130),
		warning = Color3.fromRGB(255,200,0),
		error = Color3.fromRGB(255,90,90),
	}
}

local currentVariant = "dark"
local changed = Instance.new("BindableEvent")

function Manager.getVariant(): string
	return currentVariant
end

function Manager.setVariant(name: string)
	local nextVariant = variants[name]
	if not nextVariant then
		warn("Theme variant not found:", name)
		return
	end
	currentVariant = name
	-- mutate in-place so existing references update
	for k, _ in Theme.tokens.colors do
		Theme.tokens.colors[k] = nextVariant[k]
	end
	changed:Fire(currentVariant)
end

function Manager.nextVariant()
	local order = {"dark","light","high_contrast"}
	for i, name in ipairs(order) do
		if name == currentVariant then
			local nxt = order[(i % #order)+1]
			Manager.setVariant(nxt)
			return nxt
		end
	end
end

function Manager.onChanged(cb: (string) -> ())
	return changed.Event:Connect(cb)
end

function Manager.listVariants(): {string}
	local names = {}
	for name, _ in variants do
		names[#names+1] = name
	end
	return names
end

return Manager
