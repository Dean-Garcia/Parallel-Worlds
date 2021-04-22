-- much of this mod was taken from the surfaces mods by Danacus
-- I've mainly compiled the relevant surface mods together here and added a couple things


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

--taken and modified from surfaces_transport mod
local function register_portals()
    -- A portal to go down
    remote.call("SurfacesAPI", "register_portal", {
        type = "entity", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "shaft-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "shaft-up", -- Prototype of portal on other side
        },
        allow_reverse = true -- Can this portal be used in 2 directions?
    })

    -- The complementary portal for the previous one
    remote.call("SurfacesAPI", "register_portal", {
        type = "entity", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "shaft-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "shaft-down", -- Prototype of portal on other side
        },
        allow_reverse = true -- Can this portal be used in 2 directions?
    })

    local players = { --player, surface index. Can delete or change names accordingly. Numbers are surface numbers in respect to floor 0
        {'World-B3', -3},        
        {'World-B2', -2},
        {'World-B1', -1},
        {'World-0', 0},
        {'World-1', 1},
        {'World-2', 2},
        {'World-3', 3}
    }

    -- register portal for each set of portals
    for _, player in pairs(players) do
        remote.call("SurfacesAPI", "register_portal", {
            type = "entity", -- Types: entity, energy, item
            type_params = {}, -- Parameters depending on the type, used to add restrictions
            absolute_target = player[2], -- Interger, defines how many layers we should shift
            from = {
                prototype = "to-"..player[1], -- Prototype of from portal
                restrictions = {}
            },
            to = {
                prototype = "arrival-"..player[1], -- Prototype of portal on other side
            },
            allow_reverse = true -- Can this portal be used in 2 directions?
        })
    end
    

    -- Item portal
    remote.call("SurfacesAPI", "register_portal", {
        type = "itemchest", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "chest-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "chest-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "itemchest", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "chest-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "chest-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    -- Energy
    remote.call("SurfacesAPI", "register_portal", {
        type = "energy", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "accumulator-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "accumulator-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "energy", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "accumulator-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "accumulator-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    -- Fluid
    remote.call("SurfacesAPI", "register_portal", {
        type = "fluid", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "storage-tank-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "storage-tank-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "fluid", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "storage-tank-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "storage-tank-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "linked_belt", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = -1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "linked-belt-down", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "linked-belt-up", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })

    remote.call("SurfacesAPI", "register_portal", {
        type = "linked_belt", -- Types: entity, energy, item
        type_params = {}, -- Parameters depending on the type, used to add restrictions
        relative_target = 1, -- Interger, defines how many layers we should shift
        from = {
            prototype = "linked-belt-up", -- Prototype of from portal
            restrictions = {}
        },
        to = {
            prototype = "linked-belt-down", -- Prototype of portal on other side
            clear_radius = 0,
        },
    })
end

local function config_surfaces()    
    -- Names of players and index of surfaces, 0 = nauvis, the spawn surface
    surfaceArray = {
        {'World-B3', -3},        
        {'World-B2', -2},
        {'World-B1', -1},
        {'World-1', 1},
        {'World-2', 2},
        {'World-3', 3}
    }

    for _, item in pairs(surfaceArray) do    
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
    for _, player in pairs(surfaceArray) do            
        xnumber = xnumber+1
        for ynumber = 5, 12, 1 do
            game.surfaces['nauvis'].create_entity{name="to-"..player[1], position={xnumber,ynumber}, force = 'neutral'}
        end
    end

    for _, player in pairs(surfaceArray) do            
        xnumber = xnumber+1
        for ynumber = 5, 12, 1 do
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

        -- entityList strings to item name, created in data.lua
        local entityList = {'to-World-B3', 'to-World-B2', 'to-World-0', 'to-World-B1', 'to-World-1', 'to-World-2','to-World-3'}        
        
        -- Put text on placed portal
        for _, name in pairs(entityList) do
            if placedItem == name then
                newText = name:gsub("-", " ") -- replace '-' with space. e.g. 'to-World-B3' -> 'to World B3'
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

script.on_event(defines.events.on_player_created, function(event) -- Creates force for player, makes friendly to other forces and shares vision
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