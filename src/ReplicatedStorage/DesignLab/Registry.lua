--!strict
-- DesignLab Registry: central listing of demo panels/framework samples
-- Panels are registered as lightweight factories returning an Instance (root container)

export type PanelFactory = (parent: Instance) -> (Instance?)

export type PanelRecord = {
	name: string,
	factory: PanelFactory,
	category: string?,
	tags: {string}?,
}

local Registry = {}
local _panels: {PanelRecord} = {}

function Registry.register(name: string, factory: PanelFactory, opts: {category: string?, tags: {string}?}? )
	for _, rec in _panels do
		if rec.name == name then
			return -- avoid duplicate registration
		end
	end
	table.insert(_panels, {
		name = name,
		factory = factory,
		category = opts and opts.category or "general",
		tags = opts and opts.tags or {},
	})
end

function Registry.getPanels(filter: {category: string?}?): {PanelRecord}
	if not filter or not filter.category then
		return table.clone(_panels)
	end
	local out = {}
	for _, rec in _panels do
		if rec.category == filter.category then
			out[#out+1] = rec
		end
	end
	return out
end

function Registry.clear()
	table.clear(_panels)
end

return Registry
