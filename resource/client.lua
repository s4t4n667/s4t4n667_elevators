local QBCore = exports["qb-core"]:GetCoreObject()
local config = require('config')
lib.locale()

CreateThread(function()
	for elevatorName, elevatorFloors in pairs(config.elevators) do
		for index, floor in pairs(elevatorFloors) do
			local string = tostring(elevatorName .. index)
			local info = {
				elevator = elevatorName,
				floortitle = index
			}
			if config.useTarget then
				exports.ox_target:addBoxZone({
					coords = vec3(floor.coords.x, floor.coords.y, floor.coords.z),
					size = vec3(3, 3, 3),
					rotation = floor.heading,
					debug = drawZones,
					options = {
						{
							name = string,
							icon = config.targeticon,
							label = locale('UseElevator'),
							onSelect = function()
								TriggerEvent("s4t4n667_elevators:showOptions", info)
							end
						}
					}
				})
			else
				CreateThread(function()
					while true do
						Wait(0)
						local playerCoords = GetEntityCoords(PlayerPedId())
						local distance = #(playerCoords - floor.coords)
						if distance < config.viewdistance then
							Draw3DText(floor.coords.x, floor.coords.y, floor.coords.z + 1.0, config.text)
							if IsControlJustPressed(0, 38) then
								TriggerEvent("s4t4n667_elevators:showOptions", info)
							end
						end
					end
				end)
			end
		end
	end
end)


RegisterNetEvent("s4t4n667_elevators:showOptions", function(data)
	local elevator = {}
	local PlayerData = QBCore.Functions.GetPlayerData()

	if config.elevators and config.elevators[data.elevator] then
		for index, floor in pairs(config.elevators[data.elevator]) do
			table.insert(elevator, {
				title = floor.floortitle,
				description = floor.label,
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

    ExecuteCommand(config.animation)
    Wait(2000)
    ExecuteCommand('e c')
    DoScreenFadeOut(100)
    Wait(1000)
    SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z)
    SetEntityHeading(ped, floor.heading)
    local client = GetPlayerServerId(PlayerId())
    Wait(100)
	lib.progressBar({
		duration = config.journeytime,
		label = locale('Travelling'),
		useWhileDead = false,
		canCancel = false,
	})
    DoScreenFadeIn(1500)
    lib.notify({
        title = locale('notify'),
        description = locale('notify_desc') .. floor.floortitle,
        type = "success"
    })
end)


function isDisabled(index, floor, data)
	local PlayerData = QBCore.Functions.GetPlayerData()
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
    if floor.joblock == nil then 
        return false 
    end
	return not hasJob
end


function Draw3DText(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
