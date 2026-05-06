return {

	settings = {
		useQBCore = true,

		target = true, -- true uses ox_target, falses uses 3dtext
		targetDistance = 2.0, 
		targetIcon = 'fa-solid fa-bell',
		targetIconColor = '',

		textDistance = 5.0,
		textSize = 0.35,

		animation = 'e atm', -- animation after selecting floor
		travelTime = 2000, -- 1000 is 1 second
	},

	elevatorSound = {
		sound = 'doorbell', -- interact-sound/client/html/sounds
		distance = 5,
		volume = 0.2,
	},

	elevators = {
		['Mission Row Police Station'] = {
			{
				floorTitle = 'Ground Floor', 
				label = 'Access the ground floor.',				
				coords = vector3(463.72, -985.37, 34.3), 
				heading = 87.83,
				joblock = { 
					["police"] = 0,
				},
				itemlock = nil,
			},
			{
				floorTitle = 'Level 1', 
				label = 'Access the Helicopter pad.',				
				coords = vector3(468.49, -983.95, 43.69), 
				heading = 91.48,
				joblock = { 
					["police"] = 0,
				},
				itemlock = nil,
			},
		},
		['Mount Zonah Hospital'] = {
			{
				floorTitle = 'Main Floor', 
				label = 'Access the main Hospital floor',
				icon = 'fa-hospital',
				iconColor = '',
				coords = vec4(-436.0963, -359.8023, 34.9475, 356.0672),
				joblock = nil,
				itemlock = {
					"water",
				},
			},
			{
				floorTitle = 'Car Park', 
				label = 'Access the Hospital car park.',
				icon = 'fa-solid fa-car',
				iconColor = '',
				coords = vec4(-418.9, -344.81, 24.23, 106.67), 
				joblock = nil,
				itemlock = {
					"water",
				},
			},
		},
	},
}