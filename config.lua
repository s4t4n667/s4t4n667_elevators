return {
	useQBCore = true,

	interaction = 'text', -- 'text', 'ox_target' or 'qb-target'

	target = {
		distance = 2.0,
		icon = 'fa-solid fa-bell',
		iconColor = '',
		debug = false, -- show zone outlines
	},

	text = {
		distance = 5.0,
		scale = 0.35,
	},

	travel = {
		animation = 'e atm', -- emote played after picking a floor
		time = 2000, -- milliseconds
	},

	sound = {
		name = 'doorbell', -- file in interact-sound/client/html/sounds
		distance = 5.0,
		volume = 0.2,
	},

	elevators = {
		['Mission Row Police Station'] = {
			{
				title = 'Ground Floor',
				description = 'Access the ground floor.',
				coords = vec4(463.72, -985.37, 34.3, 87.83),
				jobs = { police = 0 }, -- job = minimum grade
			},
			{
				title = 'Level 1',
				description = 'Access the helicopter pad.',
				coords = vec4(468.49, -983.95, 43.69, 91.48),
				jobs = { police = 0 },
			},
		},

		['Mount Zonah Hospital'] = {
			{
				title = 'Main Floor',
				description = 'Access the main hospital floor.',
				icon = 'fa-solid fa-hospital',
				coords = vec4(-444.6125, -362.1514, 33.4912, 185.9959),
			},
			{
				title = 'Car Park',
				description = 'Access the hospital car park.',
				icon = 'fa-solid fa-car',
				coords = vec4(-418.9, -344.81, 24.23, 106.67),
				items = { 'water' }, -- needs any one of these
			},
		},
	},
}
