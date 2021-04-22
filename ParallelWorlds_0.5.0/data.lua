-- taken and modified from surfaces_transport mod

-- Temporary function to quickly copy prototypes
local function create_entity(new_name, category, name, ingredients)
    local entity = table.deepcopy(data.raw[category][name])
    entity.name = new_name
    entity.minable.result = new_name

    local entity_item = table.deepcopy(data.raw.item[name])
    entity_item.name = new_name
    entity_item.place_result = new_name
    entity_item.subgroup = "other"

    local entity_recipe = table.deepcopy(data.raw.recipe[name]) or {}
    entity_recipe.type = "recipe"
    entity_recipe.enabled = true
    entity_recipe.name = new_name
    entity_recipe.result = new_name
    entity_recipe.ingredients = ingredients

    data:extend{entity, entity_item, entity_recipe}
end

local players = {"World-B3", "World-B2", "World-B1", "World-0", "World-1", "World-2", "World-3"}

for _, player in pairs(players) do
    create_entity("to-"..player, "gate", "gate", {{'wood',2}})
    create_entity("arrival-"..player, "gate", "gate", {{'wood',2}})
end

create_entity("shaft-down", "gate", "gate", {{'wood',2}})
create_entity("shaft-up", "gate", "gate", {{'wood',2}})

create_entity("chest-down", "container", "steel-chest", {{"electronic-circuit", 5}, {"steel-chest", 1}})
create_entity("chest-up", "container", "steel-chest", {{"electronic-circuit", 5}, {"steel-chest", 1}})

create_entity("accumulator-up", "accumulator", "accumulator", {{"electronic-circuit", 5}, {"accumulator", 1}})
create_entity("accumulator-down", "accumulator", "accumulator", {{"electronic-circuit", 5}, {"accumulator", 1}})

create_entity("storage-tank-up", "storage-tank", "storage-tank", {{"electronic-circuit", 5}, {"storage-tank", 1}})
create_entity("storage-tank-down", "storage-tank", "storage-tank", {{"electronic-circuit", 5}, {"storage-tank", 1}})

create_entity("linked-belt-up", "linked-belt", "linked-belt", {{"electronic-circuit", 5}, {"transport-belt", 1}})
create_entity("linked-belt-down", "linked-belt", "linked-belt", {{"electronic-circuit", 5}, {"transport-belt", 1}})
