-- taken and modified from surfaces_transport mod
require("__ParallelWorlds__/prototypes/item-groups")

iconPath = "__ParallelWorlds__/graphics/icons/"

local function tintLayers(layers, newTint)
    for _, layer in pairs(layers) do
        if layer.filename then
            layer.tint=newTint
            if layer.hr_version then
                layer.hr_version.tint=newTint
            end
        else
            tintLayers(layer, newTint)
        end
    end
end
local function tintEntity(entity, newTint)
    local possible = {
        entity.belt_animation_set, entity.structure, entity.vertical_animation,
        entity.horizontal_animation, entity.picture, entity.pictures,
        entity.animation, entity.animations, }
    for _, anim in pairs(possible) do
        if anim then
            tintLayers(anim, newTint)
        end
    end
end

-- Temporary function to quickly copy prototypes
--new_name, category, name, ingredients, tableargs => subgroup, order, hidden, iconPic, tintPic, localisedName
local function create_entity(new_name, category, name, ingredients, tableArgs)
   
    if localisedName then -- replaces - to space in name
        localisedName = localisedName:gsub("-", " ")
    end

    local entity = table.deepcopy(data.raw[category][name]) -- for placed entity
    entity.name = new_name
    entity.minable.result = new_name
    entity.localised_name = tableArgs.localisedName
    tintEntity(entity, tableArgs.tintPic)

    local entity_item = table.deepcopy(data.raw.item[name]) -- for inventory item
    entity_item.name = new_name
    entity_item.place_result = new_name
    entity_item.order = tableArgs.order
    entity_item.group = 'portals'
    entity_item.subgroup = tableArgs.subgroup
    entity_item.icons = {
        {icon = tableArgs.iconPic,
         tint = tableArgs.tintPic}}
    entity_item.localised_name = tableArgs.localisedName


    local entity_recipe = table.deepcopy(data.raw.recipe[name]) or {} -- for recipe
    entity_recipe.type = "recipe"
    entity_recipe.enabled = true
    entity_recipe.subgroup = tableArgs.subgroup
    entity_recipe.order = tableArgs.order
    entity_recipe.hidden = tableArgs.hidden
    entity_recipe.name = new_name
    entity_recipe.result = new_name
    entity_recipe.ingredients = ingredients
    entity_recipe.icons = {
        {icon = tableArgs.iconPic,
         tint = tableArgs.tintPic}}
    entity_recipe.icon_size = 64
    entity_recipe.localised_name = tableArgs.localisedName

    data:extend{entity, entity_item, entity_recipe}
end

local players = { -- get values from player input settings
        settings.startup["World-B3-Name"].value,        
        settings.startup['World-B2-Name'].value,
        settings.startup['World-B1-Name'].value,
        settings.startup['World-0-Name'].value,
        settings.startup['World-1-Name'].value,
        settings.startup['World-2-Name'].value,
        settings.startup['World-3-Name'].value
    }

local tints = { -- define colours for tints of recipes/entities
    {r=255, g=0, b=0}, --red
    {r=255, g=127, b=0}, -- orange
    {r=255, g=255, b=0}, -- yellow
    {r=0, g=255, b=0}, --green
    {r=0, g=173, b=255}, --teal     
    {r=75, g=0, b=130}, -- indigo
    {r=148, g=0, b=211}, -- violet
    {r=0, g=0, b=0} --black
}

local order = {'aaaac','aaaad','aaaae','aaaaf','aaaag','aaaah','aaaai','aaaaj','aaaak'} -- define order for recipe tab

for _, player in pairs(players) do -- create prototypes for each set of items to each world
    create_entity("to-"..player, "gate", "gate", {{'wood',2}}, 
                    {subgroup = 'gates', order = order[_], hidden = false,
                    iconPic = iconPath..'gate.png', tintPic = tints[_],
                    localisedName = "to "..player})
    create_entity("arrival-"..player, "gate", "gate", {{'wood',2}},
                    {subgroup = 'gates' , order = order[_], hidden = true,
                    iconPic = iconPath..'gate.png', tintPic = tints[_],
                    localisedName =  "Arrival ("..player..')'})
              
    create_entity("chest-to-"..player, "container", "steel-chest", {{"electronic-circuit", 5}, {"steel-chest", 1}},
                 {subgroup = 'transportation-chest', order = order[_], hidden = false,
                 iconPic = iconPath..'chest.png', tintPic = tints[_],
                 localisedName = "Chest to "..player})        
    create_entity("receiving-chest-("..player..')', "container", "steel-chest", {{"electronic-circuit", 5}, {"steel-chest", 1}},
                {subgroup = 'transportation-chest', order = order[_], hidden = true,
                iconPic = iconPath..'chest.png', tintPic = tints[_],
                localisedName = "Receiving Chest ("..player..')'})        

    create_entity("accumulator-to-"..player, "accumulator", "accumulator", {{"electronic-circuit", 5}, {"accumulator", 1}},
                {subgroup = 'transportation-power', order = order[_], hidden = false,
                iconPic = iconPath..'acc.png', tintPic = tints[_],
                localisedName = "Accumulator to "..player})
    create_entity("receiving-accumulator-("..player..')', "accumulator", "accumulator", {{"electronic-circuit", 5}, {"accumulator", 1}},
                {subgroup = 'transportation-power', order = order[_], hidden = true,
                iconPic = iconPath..'acc.png', tintPic = tints[_],
                localisedName = "Receiving Accumulator ("..player..')'})

    create_entity("storage-tank-to-"..player, "storage-tank", "storage-tank", {{"electronic-circuit", 5}, {"storage-tank", 1}},
                {subgroup = 'transportation-fluid', order = order[_], hidden = false,
                iconPic = iconPath..'tank.png', tintPic = tints[_],
                localisedName = "Tank to "..player})
    create_entity("receiving-tank-("..player..')', "storage-tank", "storage-tank", {{"electronic-circuit", 5}, {"storage-tank", 1}},
                {subgroup = 'transportation-fluid', order = order[_], hidden = true,
                iconPic = iconPath..'tank.png', tintPic = tints[_],
                localisedName = "Receiving Tank ("..player..')'})

    create_entity("belt-to-"..player, "linked-belt", "linked-belt", {{"electronic-circuit", 5}, {"transport-belt", 1}},
                {subgroup = 'transportation-belt', order = order[_], hidden = false,
                iconPic = iconPath..'belt.png', tintPic = tints[_],
                localisedName = "Belt to "..player})
    create_entity("receiving-belt-("..player..')', "linked-belt", "linked-belt", {{"electronic-circuit", 5}, {"transport-belt", 1}},
                {subgroup = 'transportation-belt', order = order[_], hidden = true,
                iconPic = iconPath..'belt.png', tintPic = tints[_],
                localisedName = "Receiving Belt ("..player..')'})
end


--up/down items
create_entity("shaft-down", "gate", "gate", {{'wood',2}},
            {subgroup = 'gates', order =  'aaaab', hidden = false, iconPic = iconPath..'gate-down.png'})
create_entity("shaft-up", "gate", "gate", {{'wood',2}},
             {subgroup = 'gates', order = 'aaaaa', hidden =false, iconPic = iconPath..'gate-up.png'})

create_entity("chest-down", "container", "steel-chest", {{"electronic-circuit", 5}, {"steel-chest", 1}},
            {subgroup = 'transportation-chest', order = 'aaaab', hidden = false, iconPic = iconPath..'chest-down.png'})
create_entity("chest-up", "container", "steel-chest", {{"electronic-circuit", 5}, {"steel-chest", 1}},
            {subgroup = 'transportation-chest', order = 'aaaaa', hidden = false, iconPic = iconPath..'chest-up.png'})

create_entity("accumulator-up", "accumulator", "accumulator", {{"electronic-circuit", 5}, {"accumulator", 1}},
            {subgroup ='transportation-power', order = 'aaaaa', hidden = false, iconPic = iconPath..'acc-up.png'})
create_entity("accumulator-down", "accumulator", "accumulator", {{"electronic-circuit", 5}, {"accumulator", 1}},
            {subgroup = 'transportation-power', order = 'aaaab', hidden = false, iconPic = iconPath..'acc-down.png'})

create_entity("storage-tank-up", "storage-tank", "storage-tank", {{"electronic-circuit", 5}, {"storage-tank", 1}},
            {subgroup = 'transportation-fluid', order = 'aaaaa', hidden = false, iconPic = iconPath..'storage-tank-up.png'})
create_entity("storage-tank-down", "storage-tank", "storage-tank", {{"electronic-circuit", 5}, {"storage-tank", 1}},
            {subgroup = 'transportation-fluid', order = 'aaaab', hidden = false, iconPic = iconPath..'storage-tank-down.png'})

create_entity("linked-belt-up", "linked-belt", "linked-belt", {{"electronic-circuit", 5}, {"transport-belt", 1}},
            {subgroup = 'transportation-belt', order = 'aaaaa', hidden = false, iconPic = iconPath..'belt-up.png'})
create_entity("linked-belt-down", "linked-belt", "linked-belt", {{"electronic-circuit", 5}, {"transport-belt", 1}},
            {subgroup = 'transportation-belt', order = 'aaaab', hidden = false, iconPic = iconPath..'belt-down.png'})