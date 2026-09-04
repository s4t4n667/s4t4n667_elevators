lib.locale()
local config = require('config')

if config.settings.useQBCore then
    QBCore = exports["qb-core"]:GetCoreObject()
else
    ESX = exports["es_extended"]:getSharedObject()
end

local function handleTarget(id, floor, info)
    if config.settings.targetType == 'ox_target' then
        exports.ox_target:addBoxZone({
            coords = floor.coords,
            size = vec3(3.0, 3.0, 3.0),
            rotation = floor.heading,
            debug = drawZones,
            options = {
                {
                    name = id,
                    label = locale('targetElevator'),
                    icon = config.settings.targetIcon,
                    iconColor = config.settings.targetIconColor,
                    distance = config.settings.targetDistance,
                    onSelect = function()
                        TriggerEvent('s4t4n667_elevators:showOptions', info)
                    end
                }
            }
        })
    else
        exports['qb-target']:AddBoxZone(
            id,
            floor.coords,
            3.0,
            3.0,
            {
                name = id,
                heading = floor.heading,
                debugPoly = drawZones,
                minZ = floor.coords.z - 1.0,
                maxZ = floor.coords.z + 1.0
            },
            {
                options = {
                    {
                        event = 's4t4n667_elevators:showOptions',
                        icon = config.settings.targetIcon,
                        label = locale('targetElevator'),
                        elevator = info.elevator,
                        floortitle = info.floortitle
                    }
                },
                distance = config.settings.targetDistance
            }
        )
    end
end

CreateThread(function()
    for elevatorName, elevatorFloors in pairs(config.elevators) do
        for floorIndex, floor in pairs(elevatorFloors) do
            local id = ('%s_%s'):format(elevatorName, floorIndex)
            local info = {elevator = elevatorName, floortitle = floorIndex}

            if config.settings.target then
                handleTarget(id, floor, info)
            else
                CreateThread(function()
                    while true do
                        local sleep = 1000
                        local ped = PlayerPedId()
                        local playerCoords = GetEntityCoords(ped)
                        local distance = #(playerCoords - floor.coords)

                        if distance < config.settings.textDistance then
                            sleep = 0

                            Draw3DText(floor.coords.x, floor.coords.y, floor.coords.z + 1.0, locale('textElevator'))

                            if IsControlJustPressed(0, 38) then
                                TriggerEvent('s4t4n667_elevators:showOptions', info)
                            end
                        end

                        Wait(sleep)
                    end
                end)
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
				title = floor.floorTitle,
				description = floor.label,
                icon = floor.icon,
				disabled = isDisabled(index, floor, data),
				onSelect = function()
					TriggerEvent("s4t4n667_elevator:UseElevator", floor)
				end
			})
		end
		lib.registerContext({
			id = 'mainMenu',
			options = elevator,
			title = data.elevator,
			position = 'top-right',
		}) 
		lib.showContext('mainMenu')
	end
end)

RegisterNetEvent("s4t4n667_elevator:UseElevator", function(arg)
    local floor = arg
    local ped = PlayerPedId()

    ExecuteCommand(config.settings.animation)
    Wait(2000)
    ExecuteCommand('e c')
    DoScreenFadeOut(100)
    Wait(1000)
    SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z -1)
    SetEntityHeading(ped, floor.coords.w)
    Wait(100)
	
    lib.progressBar({
		duration = config.settings.travelTime,
		label = locale('Travelling'),
		useWhileDead = false,
		canCancel = false,
	})
    
    DoScreenFadeIn(1500)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", config.elevatorSound.distance, config.elevatorSound.sound, config.elevatorSound.volume)
    
    lib.notify({title = locale('notify'), description = locale('notify_desc') .. floor.floorTitle, type = "success"})
end)

local function getPlayerData()
    if config.settings.useQBCore then
        return QBCore.Functions.GetPlayerData(), true
    end
    
    return ESX.GetPlayerData(), false
end

local function hasRequiredJob(playerData, joblock, isQB)
    if not joblock or not next(joblock) then
        return true
    end

    for jobName, gradeLevel in pairs(joblock) do
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

local function hasRequiredItem(itemlock)
    if not itemlock or not next(itemlock) then
        return true
    end

    for _, itemName in ipairs(itemlock) do
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

    local hasJob = hasRequiredJob(playerData, floor.joblock, isQB)
    local hasItem = hasRequiredItem(floor.itemlock)

    return not (hasJob and hasItem)
end

function Draw3DText(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(config.settings.textSize, config.settings.textSize)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end