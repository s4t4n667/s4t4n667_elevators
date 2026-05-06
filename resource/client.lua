lib.locale()
local config = require('config')

CreateThread(function()
    for elevatorName, elevatorFloors in pairs(config.elevators) do
        for index, floor in pairs(elevatorFloors) do
            local id = ("%s_%s"):format(elevatorName, index)

            local info = {elevator = elevatorName, floortitle = index }

            if config.settings.target then
                exports.ox_target:addBoxZone({
                    coords = floor.coords,
                    size = vec3(3, 3, 3),
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
                                TriggerEvent("s4t4n667_elevators:showOptions", info)
                            end
                        }
                    }
                })
            else
                CreateThread(function()
                    while true do
                        local sleep = 1000
                        local ped = PlayerPedId()
                        local playerCoords = GetEntityCoords(ped)
                        local dist = #(playerCoords - vec3(floor.coords.x, floor.coords.y, floor.coords.z))

                        if dist < config.settings.textDistance then
                            sleep = 0
                            Draw3DText(floor.coords.x, floor.coords.y, floor.coords.z + 1.0, locale('textElevator'))

                            if IsControlJustPressed(0, 38) then
                                TriggerEvent("s4t4n667_elevators:showOptions", info)
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
		duration = config.travelTime,
		label = locale('Travelling'),
		useWhileDead = false,
		canCancel = false,
	})
    
    DoScreenFadeIn(1500)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", config.elevatorSound.distance, config.elevatorSound.sound, config.elevatorSound.volume)
    
    lib.notify({title = locale('notify'), description = locale('notify_desc') .. floor.floorTitle, type = "success"})
end)

function isDisabled(index, floor, data)
    if config.settings.useQBCore then
        QBCore = exports["qb-core"]:GetCoreObject()
        PlayerData = QBCore.Functions.GetPlayerData()
        if index == data.floortitle then
            return true
        end
        local hasJob = false
        if floor.joblock ~= nil and next(floor.joblock) then
            for jobName, gradeLevel in pairs(floor.joblock) do
                if PlayerData.job.name == jobName and PlayerData.job.grade.level >= gradeLevel and PlayerData.job.onduty then
                    hasJob = true
                    break
                end
            end
        end
        local hasItem = false
        if floor.itemlock ~= nil and next(floor.itemlock) then
            for _, itemName in ipairs(floor.itemlock) do
                if exports.ox_inventory:Search("count", itemName) > 0 then
                    hasItem = true
                    break
                end
            end
        end
        if floor.joblock == nil and floor.itemlock == nil then
            return false
        end
        return not (hasJob or hasItem)
    else 
        ESX = exports['es_extended']:getSharedObject()
        PlayerData = ESX.GetPlayerData()
        if index == data.floortitle then
            return true
        end
        local hasJob = false
        if floor.joblock ~= nil and next(floor.joblock) then
            for jobName, gradeLevel in pairs(floor.joblock) do
                if PlayerData.job.name == jobName and PlayerData.job.grade >= gradeLevel then
                    hasJob = true
                    break
                end
            end
        end
        local hasItem = false
        if floor.itemlock ~= nil and next(floor.itemlock) then
            for _, itemName in ipairs(floor.itemlock) do
                if exports.ox_inventory:Search("count", itemName) > 0 then
                    hasItem = true
                    break
                end
            end
        end
        if floor.joblock == nil then
            return false
        end
        return not hasJob
    end
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