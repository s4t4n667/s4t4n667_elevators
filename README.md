# s4t4n667_elevators
Fully customisable elevator system using ox_lib menus - allowing for many different locations and floors. Elevators can also be locked to job roles or to an item if desired.

## 🔐 Dependencies
- any framework
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)

## ⚙️ How to install:
1) Download the latest release
2) Add `s4t4n667_elevators` to your server's `resource` folder
3) Adjust the `config.lua` to your liking
4) Restart your server

## 🔗 Useful links
- [Preview video](https://youtu.be/96q8vfx50SA?si=Mc0Ix0J2iIUAZBqE)
- [Documentation](https://s4t4n667.gitbook.io/asgaard-developments/free-scripts/s4t4n667_elevators)

## 📝 Example of an elevator locked to an item:
```lua
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
					"burger"
				},
			},
		},
```
## 📝 Example of an elevator locked to a job:
```lua
		['Mount Zonah Hospital'] = {
			{
				floorTitle = 'Main Floor', 
				label = 'Access the main Hospital floor',
				icon = 'fa-hospital',
				iconColor = '',
				coords = vec4(-436.0963, -359.8023, 34.9475, 356.0672),
				joblock = { 
					["ambulance"] = 0,
				},
				itemlock = nil,
			},
			{
				floorTitle = 'Car Park', 
				label = 'Access the Hospital car park.',
				icon = 'fa-solid fa-car',
				iconColor = '',
				coords = vec4(-418.9, -344.81, 24.23, 106.67), 
				joblock = { 
					["ambulance"] = 0,
				},
				itemlock = nil,
			},
		},
```

## 📌 Asgaard Developments
I’m a solo FiveM developer creating custom clothing, logos and graphics, liveries, MLO retextures and Discord servers. Lots of different packages available, along with plenty of free assets and scripts for the community to enjoy. 

Join the Discord: [here](https://discord.gg/eFsB5ZFxeq)
