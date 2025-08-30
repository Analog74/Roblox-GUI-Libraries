--!strict
export type StoryFactory = (parent: Instance) -> ()
local stories: { {name: string, factory: StoryFactory} } = {}

local Registry = {}

function Registry.register(name: string, factory: StoryFactory)
    for _, s in stories do if s.name == name then return end end
    table.insert(stories, {name=name, factory=factory})
end

function Registry.get(): { {name: string, factory: StoryFactory} }
    return table.clone(stories)
end

return Registry
