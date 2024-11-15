return {

	useTarget = false, -- true uses ox_target, false uses 3dtext
	targeticon = 'fa-solid fa-arrow-up-right-from-square', -- FontAwesome https://fontawesome.com/search?o=r&m=free
	text = '~g~[E] ~w~Use Elevator', -- text for 3dtext
	viewdistance = 5.0, -- for 3dtext

	journeytime = 2000, -- 1000 is 1 second
	animation = 'e atm', -- animation after selecting floor

	elevators = {
		['Mission Row Police Station'] = {
			{
				floortitle = 'Ground Floor', 
				label = 'Access the ground floor.',				
				coords = vector3(463.72, -985.37, 34.3), 
				heading = 87.83,
				joblock = { ["police"] = 0,},
			},
			{
				floortitle = 'Level 1', 
				label = 'Access the Helicopter pad.',				
				coords = vector3(468.49, -983.95, 43.69), 
				heading = 91.48,
				joblock = { ["police"] = 0,},
			},
		},
		['Pillbox Hospital'] = {
			{
				floortitle = 'Main Floor', 
				label = 'Access the main Hospital floor',				
				coords = vector3(-436.09, -359.8, 34.95), 
				heading = 355.05,
			},
			{
				floortitle = 'Car Park', 
				label = 'Access the Hospital car park.',				
				coords = vector3(-418.9, -344.81, 24.23), 
				heading = 106.67,
			},
		},
	},
}