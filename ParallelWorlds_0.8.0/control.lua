-- much of this mod was taken from the surfaces mods by Danacus
-- I've mainly compiled the relevant surface mods together here and added a couple things

local players = { --player, surface index. Imported names from settings.lua
        {settings.startup["World-B3-Name"].value, -3},        
        {settings.startup['World-B2-Name'].value, -2},
        {settings.startup['World-B1-Name'].value, -1},
        {settings.startup['World-0-Name'].value, 0},
        {settings.startup['World-1-Name'].value, 1},
        {settings.startup['World-2-Name'].value, 2},
        {settings.startup['World-3-Name'].value, 3}
    }

local function setup_interface()	-- create interface for duplication of seed
    remote.add_interface("Seed",{
        create_surface = function(name, layer)
            local surface = game.create_surface(name..":"..layer)
            return surface
        end,
        generate_chunk = function(name, surface, layer, event)
		end
    })
end

--taken and modified from surfaces_transport mod. Sets up portals for use.
local function setup_portals(itemType, prototype1, prototype2, tableArgs)        
    if tableArgs.targetSurface then
        remote.call("SurfacesAPI", "register_portal", {
            type = itemType, -- Types: entity, energy, item, fluid
            type_params = {}, -- Parameters depending on the type, used to add restrictions
            absolute_target = tableArgs.targetSurface, -- define a surface to teleport to
            relative_target = tableArgs.relativeTarget,
            from = {
                prototype = prototype1, -- Prototype of from portal
                restrictions = {}
            },
            to = {
                prototype = prototype2, -- Prototype of portal on other side
                clear_radius = tableArgs.clearRadius
            },
            allow_reverse = tableArgs.reverse -- Can this portal be used in 2 directions?
        })
    end
end

local function register_portals() -- initializes portals
    -- arguments = type, prototype1, prototype2, tableArgs.relativeTarget
    setup_portals('entity', 'shaft-up', 'shaft-down', {relativeTarget = 1, reverse = true})
    setup_portals('entity', 'shaft-down', 'shaft-up', {relativeTarget = -1, reverse = true})

    setup_portals('itemchest', 'chest-up', 'chest-down', {relativeTarget = 1, clearRadius = 0, reverse = true})
    setup_portals('itemchest', 'chest-down', 'chest-up', {relativeTarget = -1, clearRadius = 0, reverse = true})
    
    setup_portals('energy', 'accumulator-up', 'accumulator-down', {relativeTarget = 1, clearRadius = 0, reverse = true})
    setup_portals('energy', 'accumulator-down', 'accumulator-up', {relativeTarget = -1, clearRadius = 0, reverse = true})
    
    setup_portals('fluid', 'storage-tank-up', 'storage-tank-down', {relativeTarget = 1, clearRadius = 0, reverse = true})
    setup_portals('fluid', 'storage-tank-down', 'storage-tank-up', {relativeTarget = -1, clearRadius = 0, reverse = true})
    
    setup_portals('linked_belt', 'linked-belt-up', 'linked-belt-down', {relativeTarget = 1, clearRadius = 0})    
    setup_portals('linked_belt', 'linked-belt-down', 'linked-belt-up', {relativeTarget = -1, clearRadius = 0})

    for _,player in pairs(players) do -- setup portals for each player
        -- arguments = type, prototype1, prototype2, tableArgs.targetSurface
        setup_portals('entity', 'to-'..player[1], 'arrival-'..player[1], {targetSurface = player[2], reverse = true})
        setup_portals('entity', 'arrival-'..player[1], 'to-'..player[1], {targetSurface = player[2], reverse = true})

        setup_portals('itemchest', 'chest-to-'..player[1], 'receiving-chest-('..player[1]..')', {targetSurface = player[2], clearRadius = 0, reverse = true})
        setup_portals('itemchest', 'receiving-chest-('..player[1]..')', 'chest-to-'..player[1], {targetSurface = player[2], clearRadius = 0, reverse = true})
        
        setup_portals('energy', 'accumulator-to-'..player[1], 'receiving-accumulator-('..player[1]..')', {targetSurface = player[2], clearRadius = 0, reverse = true})
        setup_portals('energy', 'receiving-accumulator-('..player[1]..')', 'accumulator-to-'..player[1], {targetSurface = player[2], clearRadius = 0, reverse = true})
        
        setup_portals('fluid', 'storage-tank-to-'..player[1], 'receiving-tank-('..player[1]..')', {targetSurface = player[2], clearRadius = 0, reverse = true})
        setup_portals('fluid', 'receiving-tank-('..player[1]..')', 'storage-tank-to-'..player[1], {targetSurface = player[2], clearRadius = 0, reverse = true})
        
        setup_portals('linked_belt', 'belt-to-'..player[1], 'receiving-belt-('..player[1]..')', {targetSurface = player[2], clearRadius = 0})
        setup_portals('linked_belt', 'receiving-belt-('..player[1]..')', 'belt-to-'..player[1], {targetSurface = player[2], clearRadius = 0})
    end
end

local function config_surfaces()    
    -- Names of players and index of surfaces, 0 = nauvis, the spawn surface

    for _, item in pairs(players) do    
        remote.call(
            "SurfacesAPI", "register_surface", -- Call the register_surface function
            item[1], -- Name of the surfaces. We include the main surface name to make sure they are all unique
            'nauvis', -- Name of the main surface
            {item[2]},
            "Seed" -- Selection of layers, we want all the layers below the main surface
        )        
    end

    -- Spawn shafts to other worlds at game start. Will need to pick up and place for them to work. 
    local xnumber = 4
    for _, player in pairs(players) do            
        xnumber = xnumber+1
        for ynumber = 5, 11, 1 do
            game.surfaces['nauvis'].create_entity{name="to-"..player[1], position={xnumber,ynumber}, force = 'neutral'}
        end
    end
end


---- Shows chat to all forces, taken from 'always-shout' mod
script.on_event(defines.events.on_console_chat, function(event)
    if not event.message then return end
    if not event.player_index then return end
    local player = game.players[event.player_index]
    if not player then return end
  
    local name = player.name
    if name == '' then name = {"command-output.player"} end
    local force = player.force
    local color = player.chat_color
    local tag = player.tag
    if tag ~= '' then tag = ' ' .. tag .. ' ' end
  
    for _, otherforce in pairs(game.forces) do
      if otherforce ~= force then
        otherforce.print({"", name, tag, ": ", event.message}, color)
      end
    end
  
end)

--- Put text on placed gates.
script.on_event(defines.events.on_built_entity, function(event)
    if event.item ~= nil then
        local placedItem = event.item.name
        local entity = event.created_entity.name
        
        -- Put text on placed portal
        for _, player in pairs(players) do
            if placedItem == 'to-'..player[1] then
                newText = placedItem:gsub("-", " ") -- replace '-' with space. e.g. 'to-World-B3' -> 'to World B3'
                rendering.draw_text{text= newText, surface = event.created_entity.surface, target = event.created_entity, alignment = 'center', color = {r=1,g=1,b=0}}
            end
        end
    end
        
end)

script.on_init(function()
    -- Called when creating a new save file
    config_surfaces()  
    global.generator = game.create_random_generator()
    register_portals()    
end)

script.on_event(defines.events.on_player_created, function(event) 
    -- Creates force for player, makes friendly to other forces and shares vision
    local plyr = game.players[event.player_index]
    plyr.force = game.create_force(plyr.name)

    for _, force in pairs(game.forces) do
        if not (force == game.forces["enemy"] or force == game.forces["neutral"]) then
            for _, otherForce in pairs(game.forces) do
                if not (otherForce == game.forces["enemy"] or otherForce == game.forces["neutral"]) then
                    force.set_friend(otherForce, true)
                    force.share_chart=true
                end
            end
        end
    end
end)

script.on_event(defines.events.on_player_changed_force, function(event) -- puts player in their own force
    local player = game.players[event.player_index]
    if player.force == game.forces.player then
        player.force=player.name
    end
end)

script.on_configuration_changed(function()
    -- Called when mods are updated
    config_surfaces()
    register_portals()
end)

setup_interface()