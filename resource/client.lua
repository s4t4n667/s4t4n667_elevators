lib.locale()
local config = require('config')
local menuOpen = false

if config.useQBCore then
    QBCore = exports["qb-core"]:GetCoreObject()
else
    ESX = exports["es_extended"]:getSharedObject()
end

local function handleTarget(id, floor, info)
    local coords, heading = floor.coords.xyz, floor.coords.w
    local label = locale('targetElevator')
    local icon = config.target.icon
    local distance = config.target.distance
    local debug = config.target.debug

    local function onSelect()
        TriggerEvent('s4t4n667_elevators:showOptions', info)
    end

    if config.interaction == 'ox_target' then
        exports.ox_target:addBoxZone({
            coords = coords,
            size = vec3(3.0, 3.0, 3.0),
            rotation = heading,
            debug = debug,
            options = {{
                name = id,
                label = label,
                icon = icon,
                iconColor = config.target.iconColor,
                distance = distance,
                onSelect = onSelect,
            }},
        })
        return
    end

    exports['qb-target']:AddBoxZone(id, coords, 3.0, 3.0, {
        name = id,
        heading = heading,
        debugPoly = debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    }, {
        options = {{
            label = label,
            icon = icon,
            action = onSelect,
        }},
        distance = distance,
    })
end

CreateThread(function()
    for elevatorName, elevatorFloors in pairs(config.elevators) do
        for floorIndex, floor in pairs(elevatorFloors) do
            local info = {elevator = elevatorName, floortitle = floorIndex}

            if config.interaction ~= 'text' then
                handleTarget(('%s_%s'):format(elevatorName, floorIndex), floor, info)
            else
                local point = lib.points.new({
                    coords = floor.coords.xyz,
                    distance = config.text.distance,
                })
                local textCoords = floor.coords.xyz + vec3(0.0, 0.0, 1.0)

                function point:nearby()
                    if menuOpen then return end

                    Draw3DText(textCoords, locale('textElevator'))

                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('s4t4n667_elevators:showOptions', info)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("s4t4n667_elevators:showOptions", function(data)
    local elevator = {}
    local PlayerData = nil

	if config.elevators and config.elevators[data.elevator] then
		for index, floor in pairs(config.elevators[data.elevator]) do
			table.insert(elevator, {
				title = floor.title,
				description = floor.description,
                icon = floor.icon,
                iconColor = floor.iconColor,
				disabled = isDisabled(index, floor, data),
				onSelect = function()
					menuOpen = false
					TriggerEvent("s4t4n667_elevator:UseElevator", floor)
				end
			})
		end
		lib.registerContext({
			id = 'mainMenu',
			options = elevator,
			title = data.elevator,
			position = 'top-right',
			onExit = function()
				menuOpen = false
			end,
		})
		lib.showContext('mainMenu')
		menuOpen = true
	end
end)

RegisterNetEvent("s4t4n667_elevator:UseElevator", function(arg)
    local floor = arg
    local ped = PlayerPedId()

    ExecuteCommand(config.travel.animation)
    Wait(2000)
    ExecuteCommand('e c')
    DoScreenFadeOut(100)
    Wait(1000)
    SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z -1)
    SetEntityHeading(ped, floor.coords.w)
    Wait(100)
	
    lib.progressBar({
		duration = config.travel.time,
		label = locale('Travelling'),
		useWhileDead = false,
		canCancel = false,
	})
    
    DoScreenFadeIn(1500)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", config.sound.distance, config.sound.name, config.sound.volume)

    lib.notify({title = locale('notify'), description = locale('notify_desc') .. floor.title, type = "success"})
end)

local function getPlayerData()
    if config.useQBCore then
        return QBCore.Functions.GetPlayerData(), true
    end
    
    return ESX.GetPlayerData(), false
end

local function hasRequiredJob(playerData, jobs, isQB)
    if not jobs or not next(jobs) then
        return true
    end

    for jobName, gradeLevel in pairs(jobs) do
        local job = playerData.job

        if job.name == jobName then
            if isQB then
                if job.grade.level >= gradeLevel and job.onduty then
                    return true
                end
            else
                if job.grade >= gradeLevel then
                    return true
                end
            end
        end
    end

    return false
end

local function hasRequiredItem(items)
    if not items or not next(items) then
        return true
    end

    for _, itemName in ipairs(items) do
        if exports.ox_inventory:Search("count", itemName) > 0 then
            return true
        end
    end

    return false
end

function isDisabled(index, floor, data)
    if index == data.floortitle then
        return true
    end

    local playerData, isQB = getPlayerData()

    local hasJob = hasRequiredJob(playerData, floor.jobs, isQB)
    local hasItem = hasRequiredItem(floor.items)

    return not (hasJob and hasItem)
end

function Draw3DText(coords, text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    SetTextFont(4)
    SetTextScale(config.text.scale, config.text.scale)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end