--------------------------------------------
--- MultTool Local Vars for config
--------------------------------------------
local mt, mtvars = ...
-- mt = "MultiTool"
-- mtvars = {}

mtvars.L = LibStub("AceLocale-3.0"):GetLocale("MultiTool")


mtvars.soundList = {
	[1] =  { name = "none",        path = "" },
	[2] =  { name = "Raid Warn",   path = "8959" },
	[3] =  { name = "Oink",        path = "95175" },
	[4] =  { name = "Murloc",      path = "416" },
	[5] =  { name = "Baaah",       path = "43942" },
	[6] =  { name = "Tadpole",     path = "79646" },
	[7] =  { name = "Smack",       path = "71632" },
	[8] =  { name = "Murmur",      path = "10821" },
	[9] =  { name = "Turkey",      path = "15160" },
	[10] = { name = "Neigh",       path = "157404" },
	[11] = { name = "Baby",        path = "113517" },
	[12] = { name = "Bloodlust",   path = "10030" },
	[13] = { name = "Drum",        path = "53884" },
	[14] = { name = "Ding Ding",   path = "118491" },
	[15] = { name = "Boom",        path = "40091" },
	[16] = { name = "Klank",       path = "63959" },
	[17] = { name = "Thunk",       path = "972" },
	[18] = { name = "Ready Check", path = "8960" },
	[19] = { name = "USE DEFAULT", path = "" },
}

-- Holds our configuration options
mtvars.mainOptions = {
	name = "MultiTool",
	handler = MultiTool,
	type = "group",
	childGroups = "select",
	get = "getConfigOption",
	set = "setConfigOption",
	args = {
		mainDescription = {
			type = "description",
			name = mtvars.L["MAIN_DESCRIPTION"],
			order = 1
		},
		defaultSoundGroupContainer = {
			type = "group",
			name = mtvars.L["DEFAULT_SOUND_GROUP_LABEL"],
			inline = true,
			order = 2,
			args = {
				defaultSoundGroupDesc = {
					type = "description",
					name = mtvars.L["DEFAULT_SOUND_GROUP_DESC"],
					order = 1
				},
				defaultWarnSound = {
					type = "select",
					name = mtvars.L["PICK_SOUND_LABEL"],
					desc = mtvars.L["PICK_SOUND_DESC"],
					order = 2,
					values = function(info) return MultiTool:getSoundSelectTable(true) end,
				},
				defaultWarnSoundTest = {
					type = "execute",
					name = mtvars.L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("defaultWarnSound") end,
					order = 3,
				}
			}
		},
		duelGroupContainer = {
			type = "group",
			name = mtvars.L["DUEL_GROUP_LABEL"],
			inline = true,
			order = 3,
			args = {
				duelGroupDesc = {
					type = "description",
					name = mtvars.L["DUEL_GROUP_DESC"],
					order = 1
				},
				duelFlag = {
					type = "toggle",
					name = mtvars.L["DUEL_LABEL"],
					desc = mtvars.L["DUEL_DESC"],
					order = 2
				},
				duelAcceptFlag = {
					type = "toggle",
					name = mtvars.L["DUEL_ACCEPT_LABEL"],
					desc = mtvars.L["DUEL_ACCEPT_DESC"],
					order = 3
				}
			}
		}
	}
}

