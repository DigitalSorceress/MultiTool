--[[
MultiTool Quality of LIfe utilities originally inspired by smurfys MultiBoxer addon

Shouts to http://old.wowace.com/wiki/WelcomeHome_-_Your_first_Ace3_Addon

Extra special shouts to Allara and OrionShock for pointing me in the right direction RE: AceComm-3.0

NOTE TO SELF
/console scriptErrors 0
/console scriptErrors 1

Author: DigitalSorceress
Date: 2026/03/07
Version: 10.0.2.000
]]

-- Some initialization of our happy local vars
local myVersion = "v10.0.2.000"

local cat = "empty"
local foo = "empty"


local totalBagSlots = 0
local totalFreeBagSlots = 0
local totalUsedBagSlots = 0
local totalFreeQuestLogSlots = 0
local whiteListDeleteCandidate = 0

local soundList = {
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
MultiTool = LibStub("AceAddon-3.0"):NewAddon("MultiTool", "AceConsole-3.0","AceComm-3.0","AceEvent-3.0","AceSerializer-3.0","AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("MultiTool")

-- ------------------------------------------------
-- CONFIGURATION STUFF
-- ------------------------------------------------
-- Holds our configuration options
local options = {
	name = "MultiTool",
	handler = MultiTool,
	type = "group",
	childGroups = "select",
	get = "getConfigOption",
	set = "setConfigOption",
	args = {
		mainDescription = {
			type = "description",
			name = L["MAIN_DESCRIPTION"],
			order = 1
		},
		defaultSoundGroupContainer = {
			type = "group",
			name = L["DEFAULT_SOUND_GROUP_LABEL"],
			inline = true,
			order = 2,
			args = {
				defaultSoundGroupDesc = {
					type = "description",
					name = L["DEFAULT_SOUND_GROUP_DESC"],
					order = 1
				},
				defaultWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 2,
					values = function(info) return MultiTool:getSoundSelectTable(true) end,
				},
				defaultWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("defaultWarnSound") end,
					order = 3,
				}
			}
		},
		duelGroupContainer = {
			type = "group",
			name = L["DUEL_GROUP_LABEL"],
			inline = true,
			order = 3,
			args = {
				duelGroupDesc = {
					type = "description",
					name = L["DUEL_GROUP_DESC"],
					order = 1
				},
				duelFlag = {
					type = "toggle",
					name = L["DUEL_LABEL"],
					desc = L["DUEL_DESC"],
					order = 2
				},
				duelAcceptFlag = {
					type = "toggle",
					name = L["DUEL_ACCEPT_LABEL"],
					desc = L["DUEL_ACCEPT_DESC"],
					order = 3
				}
			}
		}
	}
}

local partyOptions = {
	name = L["PARTY_OPTIONS_LABEL"],
	handler = MultiTool,
	type = "group",
	order = 1,
	get = "getConfigOption",
	set = "setConfigOption",
	args = {
		partyOptionsDesc = {
			type = "description",
			name = L["PARTY_OPTIONS_DESC"],
			order = 1
		},
		partyGroupContainer = {
			type = "group",
			inline = true,
			name = L["PARTY_GROUP_LABEL"],
			desc = L["PARTY_GROUP_DESC"],
			order = 2,
			args = {
				groupFlag = {
					type = "toggle",
					name = L["PARTY_AUTOACCEPT_LABEL"],
					desc = L["PARTY_AUTOACCEPT_DESC"],
					order = 1
				},
				groupGuildAutoAcceptFlag = {
					type = "toggle",
					name = L["PARTY_GUILD_LABEL"],
					desc = L["PARTY_GUILD_DESC"],
					order = 2
				},
				groupRejectFlag = {
					type = "toggle",
					name = L["PARTY_GROUP_REJECT_LABEL"],
					desc = L["PARTY_GROUP_REJECT_DESC"],
					order = 3
				}
			}
		},
		taxiGroupContainer = {
			type = "group",
			inline = true,
			name = L["TAXI_GROUP_LABEL"],
			order = 3,
			args = {
				taxiGroupDesc = {
					type = "description",
					name = L["TAXI_GROUP_DESC"]
				},
				taxiFlag = {
					type = "toggle",
					name = L["TAXI_LABEL"],
					desc = L["TAXI_DESC"],
					order = 1
				},
				taxiWhiteListOnlyFlag = {
					type = "toggle",
					name = L["TAXI_WHITE_LIST_ONLY_LABEL"],
					desc = L["TAXI_WHITE_LIST_ONLY_LABEL"],
					order = 2
				}
			}
		},
		summonsGroupContainer = {
			type = "group",
			inline = true,
			name = L["SUMMON_GROUP_LABEL"],
			order = 4,
			args = {
				summonFlag = {
					type = "toggle",
					name = L["SUMMON_LABEL"],
					desc = L["SUMMON_DESC"],
					order = 1
				},
				summonWhiteListOnlyFlag = {
					type = "toggle",
					name = L["SUMMON_WHITE_LIST_ONLY_LABEL"],
					desc = L["SUMMON_WHITE_LIST_ONLY_DESC"],
					order = 2
				},
				summonGroupDesc = {
					type = "description",
					name = L["SUMMON_GROUP_DESC"],
					order = 3
				},
				summonWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 4,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				summonWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("summonWarnSound") end,
					order = 5
				}
			}
		},
		resurrectGroupContainer = {
			type = "group",
			inline = true,
			name = L["RESURRECT_GROUP_LABEL"],
			order = 5,
			args = {
				resurrectFlag = {
					type = "toggle",
					name = L["RESURRECT_LABEL"],
					desc = L["RESURRECT_DESC"],
					order = 1
				},
				resurrectWhiteListOnlyFlag = {
					type = "toggle",
					name = L["RESURRECT_WHITELIST_LABEL"],
					desc = L["RESURRECT_WHITELIST_DESC"],
					order = 2
				},
				resurrectGroupDesc = {
					type = "description",
					name = L["RESURRECT_GROUP_DESC"],
					order = 3
				},
				resurrectWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 4,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				resurrectWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("resurrectWarnSound") end,
					order = 5,
				}
			}
		},
		followGroupContainer = {
			type = "group",
			inline = true,
			name = L["FOLLOW_GROUP_LABEL"],
			order = 5,
			args = {
				followWarnFlag = {
					type = "toggle",
					name = L["FOLLOW_WARN_LABEL"],
					desc = L["FOLLOW_WARN_DESC"],
					order = 1
				},
				followWarnWhiteListOnlyFlag = {
					type = "toggle",
					name = L["FOLLOW_WARN_WHITELIST_LABEL"],
					desc = L["FOLLOW_WARN_WHITELIST_DESC"],
					order = 2
				},
				followGroupDesc = {
					type = "description",
					name = L["FOLLOW_GROUP_DESC"],
					order = 3
				},
				followWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 4,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				followWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("followWarnSound") end,
					order = 5,
				}
			}
		},
	}
}


local debugOptions = {
	name = L["DEBUG_OPTIONS_LABEL"],
	handler = MultiTool,
	type = "group",
	order = 1,
	get = "getConfigOption",
	set = "setConfigOption",
	args = {
		debugFlag = {
			type = "toggle",
			name = L["DEBUG_LABEL"],
			desc = L["DEBUG_DESC"],
			order = 1,
		},
		blatherFlag = {
			type = "toggle",
			name = L["BLATHER_LABEL"],
			desc = L["BLATHER_DESC"],
			order = 2,
		},
		commFlag = {
			type = "toggle",
			name = L["COMM_LABEL"],
			desc = L["COMM_DESC"],
			order = 3,
		}
	}
}


local questOptions = {
	name = L["QUEST_OPTIONS_LABEL"],
	handler = MultiTool,
	type = "group",
	childGroups = "tab",
	order = 2,
	get = "getConfigOption",
	set = "setConfigOption",
	args = {
	questGossip = {
		name = L["QUEST_GOSSIP_GROUP_LABEL"],
		type = "group",
		inline = true,
		order = 1,
		args = {
				gossipFlag = {
					type = "toggle",
					name = L["GOSSIP_LABEL"],
					desc = L["GOSSIP_DESC"],
					order = 1
				},
				rewardFlag = {
					type = "toggle",
					name = L["REWARD_CLONE_LABEL"],
					desc = L["REWARD_CLONE_DESC"],
					order = 2
				},
				gossipDesc = {
					type = "description",
					name = L["QUEST_GOSSIP_GROUP_DESC"],
					order = 3
				}
			}
		},
		escortQuestAccept = {
			name = L["ESCORT_GROUP_LABEL"],
			type = "group",
			inline = true,
			order = 2,
			args = {
				escortFlag = {
					type = "toggle",
					name = L["ESCORT_FLAG_LABEL"],
					desc = L["ESCORT_FLAG_DESC"],
					order = 1,
					width = "full"
				},
				escortStartedSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 2,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				escortStartedSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("escortStartedSound") end,
					order = 3,
				},
			}
		},
		monitorQuestLog = {
			name = L["QUEST_LOG_MONITOR_LABEL"],
			type = "group",
			inline = true,
			order = 2,
			args = {
				questLogFlag = {
					type = "toggle",
					name = L["QUEST_LOG_FLAG_LABEL"],
					desc = L["QUEST_LOG_FLAG_DESC"],
					order = 1,
				},
				questLogWhisperFlag = {
					type = "toggle",
					name = L["QUEST_LOG_WHISPER_FLAG_LABEL"],
					desc = L["QUEST_LOG_WHISPER_FLAG_DESC"],
					order = 2,
				},
				questLogWarn = {
					type = "range",
					min = 0,
					max = 10,
					step = 1,
					bigStep = 1,
					name = L["QUEST_LOG_WARN_LABEL"],
					desc = L["QUEST_LOG_WARN_DESC"],
					order = 3,
					width = "full"
				},
				questLogWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 4,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				questLogWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("questLogWarnSound") end,
					order = 5,
				},
				monitorQuestLogDesc = {
					type = "description",
					name = L["QUEST_LOG_MONITOR_DESC"],
					order = 6
				}
			}
		}
	}
}


local inventoryOptions = {
	handler = MultiTool,
	name = L["INVENTORY_OPTIONS_LABEL"],
	type = "group",
	childGroups = "tab",
	order = 3,
	get = "getConfigOption",
	set = "setConfigOption",
	args = {
		autoRepairOptions = {
			name = L["REPAIR_GROUP_LABEL"],
			type = "group",
			order = 1,
			inline = true,
			args = {
				repairFlag= {
					type = "toggle",
					name = L["REPAIR_FLAG_LABEL"],
					desc = L["REPAIR_FLAG_DESC"],
					order = 1,
				},
				repairGuildFlag = {
					type = "toggle",
					name = L["REPAIR_GUILD_FLAG_LABEL"],
					desc = L["REPAIR_GUILD_FLAG_DESC"],
					order = 2,
				},
				repairWarnFlag= {
					type = "toggle",
					name = L["REPAIR_WARN_LABEL"],
					desc = L["REPAIR_WARN_DESC"],
					order = 3
				},
				repairWhisperFlag = {
					type = "toggle",
					name = L["REPAIR_WHISPER_FLAG_LABEL"],
					desc = L["REPAIR_WHISPER_FLAG_DESC"],
					order = 4,
				},
				repairWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 5,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				repairWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("repairWarnSound") end,
					order = 6
				},
				repairDesc = {
					type = "description",
					name = L["REPAIR_GROUP_DESC"],
					order = 7
				}
			}
		},
		vendorOptions = {
			name = L["VENDOR_GROUP_LABEL"],
			type = "group",
			order = 1,
			inline = true,
			args = {
				vendJunkFlag= {
					type = "toggle",
					name = L["VEND_JUNK_LABEL"],
					desc = L["VEND_JUNK_DESC"],
					order = 1,
					width = "full"
				}
			}
		},
		monitorBag = {
			type = "group",
			name = L["BAG_MONITOR_LABEL"],
			order = 2,
			inline = true,
			args = {
				bagFlag = {
					type = "toggle",
					name = L["BAG_FLAG_LABEL"],
					desc = L["BAG_FLAG_DESC"],
					order = 1,
				},
				bagWhisperFlag = {
					type = "toggle",
					name = L["BAG_WHISPER_FLAG_LABEL"],
					desc = L["BAG_WHISPER_FLAG_DESC"],
					order = 2,
					--width = "full"
				},
				bagWarn = {
					type = "range",
					min = 1,
					max = 10,
					step = 1,
					bigStep = 1,
					name = L["BAG_WARN_LABEL"],
					desc = L["BAG_WARN_DESC"],
					order = 3,
					width = "full"
				},
				bagWarnSound = {
					type = "select",
					name = L["PICK_SOUND_LABEL"],
					desc = L["PICK_SOUND_DESC"],
					order = 4,
					values = function(info) return MultiTool:getSoundSelectTable() end,
				},
				bagWarnSoundTest = {
					type = "execute",
					name = L["PICK_SOUND_TEST"],
					func = function(info) MultiTool:soundCheck("bagWarnSound") end,
					order = 5
				},
				monitorBagDesc = {
					type = "description",
					name = L["BAG_MONITOR_DESC"],
					order = 6
				}
			}
		},
	}
}

local whiteListOptions = {
	handler = MultiTool,
	name = L["WHITE_LIST_OPTIONS_LABEL"],
	type = "group",
	childGroups = "tab",
	order = 8,
	args = {
		whiteListInstructions = {
			type = "description",
			name = L["WHITE_LIST_OPTIONS_DESC"],
			order = 1
		},
		whiteListViewContainer = {
			type = "group",
			inline = true,
			name = L["WHITE_LIST_VIEW_GROUP_LABEL"],
			order = 2,
			args = {
				whiteListView = {
					type = "description",
					name = function(info) return MultiTool:displayWhiteList() end
				}
			}
		},
		whiteListAddContainer = {
			type = "group",
			name = L["WHITE_LIST_ADD_PLAYER_GROUP_LABEL"],
			inline = true,
			order = 3,
			args = {
				whiteListAdd = {
					type = "input",
					name = L["WHITE_LIST_ADD_LABEL"],
					desc = L["WHITE_LIST_ADD_DESC"],
					order = 1,
					set = "whiteListAddPlayer"
				}
			}
		},
		whiteListDeleteContainer = {
			type = "group",
			inline = true,
			name = L["WHITE_LIST_DELETE_GROUP_LABEL"],
			order = 3,
			args = {
				whiteListDeleteSelect = {
					type = "select",
					name = L["WHITE_LIST_DELETE_SELECT_LABEL"],
					desc=  L["WHITE_LIST_DELETE_SELECT_DESC"],
					order = 1,
					values = function(info) return MultiTool:getWhiteListTable() end,
					set = "setSelectWhiteListDeleteCandidate",
					get = function(info) return whiteListDeleteCandidate end
				},
				whiteListDeleteAction = {
					type = "execute",
					name = L["WHITE_LIST_DELETE_ACTION_LABEL"],
					order = 2,
					func = "setDeleteWhiteListCandidate"
				}
			}
		}
	}
}

--
-- Set the default profile if they don't have one
--
local defaults = {
	profile = {
		debugFlag = false,
		blatherFlag = false,
		commFlag = false,
		defaultWarnSound = 2,
		duelFlag = true,
		taxiFlag = true,
		taxiWhiteListOnlyFlag = false,
		gossipFlag = true,
		rewardFlag = false,
		escortFlag = true,
		escortStartedSound = #soundList,
		bagFlag = true,
		bagWhisperFlag = false,
		bagWarn = 5,
		bagWarnSound = #soundList,
		questLogFlag = true,
		questLogWhisperFlag = false,
		questLogWarn = 5,
		questLogWarnSound = #soundList,
		vendJunkFlag = false,
		repairFlag = true,
		repairGuildFlag = false,
		repairWhisperFlag = false,
		repairWarnSound = #soundList,
		tradeFlag = false,
		whiteList = {GetUnitName("player")},
		groupFlag = true,
		groupGuildAutoAcceptFlag = true,
		groupRejectFlag = false,
		summonFlag = true,
		summonWhiteListOnlyFlag = true,
		summonWarnSound = #soundList,
		resurrectFlag = true,
		resurrectWhiteListOnlyFlag = true,
		resurrectWarnSound = #soundList,
		followWarnFlag = true,
		followWarnWhiteListOnlyFlag = true,
		followWarnSound = #soundList,
	}
}


--
-- Field handlers
--

function MultiTool:getConfigOption(key)
	self:debugMsg("getConfigOption()", "blather")
	self:debugMsg("  key: "..tostring(key[#key]), "blather")
	return self.db.profile[key[#key]]
end


function MultiTool:setConfigOption(key, value)
	self:debugMsg("setConfigOption()", "debug")
	self:debugMsg("  key: "..tostring(key[#key]), "debug")
	self:debugMsg("  val: "..tostring(value), "debug")
	self.db.profile[key[#key]] = value
end


--
-- Special White List functionality
--
function MultiTool:setSelectWhiteListDeleteCandidate(key, value)
	self:debugMsg("setSelectWhiteListDeleteCandidate()", "debug")
	self:debugMsg("  key: "..tostring(key[#key]), "blather")
	self:debugMsg("  value: "..tostring(value), "blather")

	whiteListDeleteCandidate = value
end


function MultiTool:setDeleteWhiteListCandidate(key, value)
	self:debugMsg("setDeleteWhiteListCandidate(): "..tostring(whiteListDeleteCandidate), "debug")
	-- remove them
	local deletionIndex = whiteListDeleteCandidate
	if (deletionIndex) then
		-- reset the delete candidate first so we get an empty select after the update
		whiteListDeleteCandidate = 0
		self:debugMsg("  Removed candidate from whiteList", "blather")
		table.remove(self.db.profile.whiteList, deletionIndex)
	else
		self:debugMsg("  Candidate not found in white list - not attempting removal", "blather")
	end
end


function MultiTool:displayWhiteList()
	self:debugMsg("displayWhiteList()", "debug")
	--local rawTable = self.db.profile.whiteList
	local outString = ""
	for key,value in ipairs(self.db.profile.whiteList) do
		outString = outString..tostring(value).."\n"
	end
	return outString
end


function MultiTool:isInWhiteList(name)
	self:debugMsg("isInWhiteList(): "..tostring(name), "debug")
	local returnFlag = false

	if (name == UnitName("player")) then
		self:debugMsg("  name is current player - setting true", "debug")
		returnFlag = true
	else
		for k,v in ipairs(self.db.profile.whiteList) do
			self:debugMsg("  Evaluating "..tostring(v), "blather")
			if (string.lower(v) == string.lower(name)) then
				self:debugMsg("  Match Found", "blather")
				returnFlag = true
				break
			else
				self:debugMsg("  No Match", "blather")
			end
		end
	end
	self:debugMsg("  Check Complete. Result: "..tostring(returnFlag), "debug")
	return returnFlag
end


function MultiTool:whiteListAddPlayer(key, value)
	local candidate = strtrim(tostring(value))
	self:debugMsg("whiteListAddPlayer(): "..candidate, "debug")

	self:debugMsg("  Checking existing whiteList for duplicates...", "blather")
	-- someplace to store result of check
	local isDupe = self:isInWhiteList(candidate)

	self:debugMsg("  Duplicate check complete", "debug")
	self:debugMsg("    result: "..tostring(isDupe), "debug")

	if (isDupe) then
		self:debugMsg("isDupe is true, not adding "..candidate.." to whiteList", "blather")
	else
		-- do the actual add
		self:debugMsg("Adding "..candidate.." to white list", "blather")
		table.insert(self.db.profile.whiteList, candidate)
	end

--[[
	CANT do these on non-party members

	if (UnitExists(candidate)) then
		self:debugMsg("  Player exists", "debug")
	else
		self:debugMsg("  Player does not exist or currently not logged in", "debug")
	end

	if (UnitIsFriend(GetUnitName("player"), candidate)) then
		self:debugMsg("  Player is friendly", "debug")
	else
		self:debugMsg("  Player is either not logged in or is on opposite faction", "debug")
	end
]]

end


function MultiTool:getWhiteListTable()
	return self.db.profile.whiteList
end


--
-- Chat Command setup
--
function MultiTool:ChatCommand(input)
	if not input or input:trim() == "" then
		-- This would use the Ace config gui
		-- LibStub("AceConfigDialog-3.0"):Open("MultiTool")
		-- This uses the Bliz options pane instead
		-- InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		-- finally got annoyed that the chat command would not open to my options anymore
		-- found out it's a known bug in bliz code, but you can work around by calling twice
		-- This is VERY OUTDATED and does not work
		-- InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	-- this can work but not recommended
	--SettingsPanel:Open()

	-- I got the frame ID from the AddToBlizOptions second return below
	self:debugMsg("OptionsFrameId: ".. self.OptionsFrameId, "debug")
	-- as of 12.1 this is the proper way to open to my addon's main
	-- If I want to open to a subframe I need to get the ID
	C_SettingsUtil.OpenSettingsPanel(self.OptionsFrameId)

	else
		-- this was a test and it did not work
		--C_CombatAudioAlert.SpeakText("MultiTool", 0, true)
		self:debugMsg("MultiTool: chat command: ".. input, "debug")
		if (input == "guildInfo") then

		local shortform = self:IsGuildMemberByName("Kyo")
		self:debugMsg("shortform:" .. tostring(shortform), "debug")

		end
		--LibStub("AceConfigCmd-3.0").HandleCommand(MultiTool, L["SHORT_SLASH_CMD"], "MultiTool", input)
	end
end

-- ------------------------------------------------
-- BASIC REQUIRED FUNCTIONS
-- ------------------------------------------------

-- Called when the addon is loaded
function MultiTool:OnInitialize()
	-- Using the AceDB for storage of our info

	self.db = LibStub("AceDB-3.0"):New("MultiToolDB", defaults, "Default")

	-- main options table stuff
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("Main Options", options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MultiTool", options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Debug Options", debugOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Party Options", partyOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Quest Options", questOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Inventory Options", inventoryOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("White List", whiteListOptions)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))

	-- adding to Blizzard options configuration
	-- Note, we need to take the second return value for the ID so we can open to category later
	-- only really needed on the main category since thats the only one we have a slash command for
	self.optionsFrame, self.OptionsFrameId = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MultiTool", "MultiTool")
	self:debugMsg("optionsFrame: ".. self.OptionsFrameId, "blather")

	self.optionsFrame.debugOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Debug Options", L["DEBUG_OPTIONS_LABEL"], "MultiTool")
	self.optionsFrame.partyOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Party Options", L["PARTY_OPTIONS_LABEL"], "MultiTool")
	self.optionsFrame.questOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Quest Options", L["QUEST_OPTIONS_LABEL"], "MultiTool")
	self.optionsFrame.vendorOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Inventory Options", L["INVENTORY_OPTIONS_LABEL"], "MultiTool")
	self.optionsFrame.whiteListOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("White List", L["WHITE_LIST_OPTIONS_LABEL"], "MultiTool")
	self.optionsFrame.Profiles = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Profiles", "Profiles", "MultiTool")

	-- registering the slash commands
	self:RegisterChatCommand(L["FULL_SLASH_CMD"], "ChatCommand")
	self:RegisterChatCommand(L["SHORT_SLASH_CMD"], "ChatCommand")
	self:RegisterChatCommand("help", "helpDialog")

	-- Registering the base communications handler
	self:RegisterComm("MultiTool","OnCommReceived")
end


-- Called when the addon is enabled
function MultiTool:OnEnable()
	-------------------
	-- REGISTER EVENTS
	-------------------
	self:RegisterEvent("DUEL_REQUESTED", "duelRequested")
	self:RegisterEvent("MERCHANT_SHOW", "autoMerchant")
	self:RegisterEvent("ITEM_PUSH", "updateBagSpace")
	self:RegisterEvent("QUEST_LOG_UPDATE", "updateQuestLogSpace")
	self:RegisterEvent("CONFIRM_SUMMON", "confirmSummon")
	self:RegisterEvent("PARTY_INVITE_REQUEST", "confirmPartyInvite")
	self:RegisterEvent("QUEST_ACCEPT_CONFIRM", "confirmEscortQuest")
	self:RegisterEvent("RESURRECT_REQUEST", "resurrectRequest")
	self:RegisterEvent("AUTOFOLLOW_BEGIN", "followBegin")
	self:RegisterEvent("AUTOFOLLOW_END", "followEnd")
	self:RegisterEvent("GOSSIP_SHOW", "testGossipShow")
	self:RegisterEvent("QUEST_GREETING", "testQuestGreeting")
	self:RegisterEvent("QUEST_DETAIL", "testQuestDetail")


	-- Looks like AcceptTrade() is protected - may not be able to do this one
	--self:RegisterEvent("TRADE_ACCEPT_UPDATE", "tradeAcceptUpdate")
	--self:RegisterEvent("TRADE_SHOW", "tradeAcceptUpdate")

	-----------------------------
	-- SECUE HOOKS (post-hooking)
	-----------------------------
	-- Looks like AcceptTrade() is protected - may not be able to do this one
	-- hooksecurefunc("AcceptTrade", acceptTradeHook)

	-- Why is this here ?
	-- hooksecurefunc("AcceptGroup", acceptGroupHook)

	hooksecurefunc("TakeTaxiNode",takeTaxiNodeHook)

	-- Quest gossip hooks
	--hooksecurefunc("C_GossipInfo.SelectAvailableQuest", selectGossipAvailableQuestHook)
	--hooksecurefunc("C_GossipInfo.SelectActiveQuest", selectGossipActiveQuestHook)
	--hooksecurefunc("C_GossipInfo.GetNumOptions", selectGossipOptionHook)
	--hooksecurefunc("SelectAvailableQuest", selectAvailableQuestHook)
	hooksecurefunc("SelectActiveQuest", selectActiveQuestHook)
	hooksecurefunc("AcceptQuest", acceptQuestHook)
	hooksecurefunc("CompleteQuest", completeQuestHook)
	hooksecurefunc("GetQuestReward", getQuestRewardHook)
	hooksecurefunc("DeclineQuest", declineQuestHook)

	-- update our bag count (commented out because it was firing twice)
	--self:updateBagSpace("initial")

	-- update our quest log count (commented out because it was firing twice)
	-- self:updateQuestLogSpace()

	self:Print("MultiTool "..myVersion.." ENABLED!")
end


-- Called when the addon is disabled
function MultiTool:OnDisable()
	--
end


-- ------------------------------------------------
-- EVENT HANDLERS
-- ------------------------------------------------

function MultiTool:testQuestDetail( info, foo, bar )
	self:debugMsg("testQuestDetail()", "blather")
	self:debugMsg("  info:"..tostring(info), "blather")
	self:debugMsg("  foo:"..tostring(foo), "blather")
	self:debugMsg("  bar:"..tostring(bar), "blather")
end

function MultiTool:testQuestGreeting( info, foo )
	self:debugMsg("testQuestGreeting()", "blather")
	self:debugMsg("  info:"..tostring(info), "blather")
	self:debugMsg("  foo:"..tostring(foo), "blather")
end

function MultiTool:testGossipShow( info, foo )
	self:debugMsg("testGossipShow()", "debug")
	self:debugMsg("  info:"..tostring(info), "blather")
	self:debugMsg("  foo:"..tostring(foo), "blather")

	local availbleQuestsTable = self:getAvailableQuestsTable()
	self:debugMsg("  #availbleQuestsTable: "..tostring(#availbleQuestsTable), "blather")
	for i = 1, #availbleQuestsTable, 1 do
		self:debugMsg("    option: " ..tostring(i).." - "..tostring(availbleQuestsTable[i]), "blather")
	end

	-- this is useful for seeing PRECISELY what name is returned using | as a hard delimiter
	for index,title in ipairs(availbleQuestsTable) do
		self:debugMsg("    index: "..tostring(index), "blather")
		self:debugMsg("    title: |"..tostring(title).."|", "blather")
	end
end

-- Fires when autofollow started
function MultiTool:followBegin( info, followee )
	self:debugMsg("followBegin()", "debug")
	self:debugMsg("  info: "..tostring( info ), "debug")
	self:debugMsg("  followee: "..tostring( followee ), "debug")
	self:debugMsg("  oldFollowee: "..tostring( self.myFollowTarget ), "debug")

	-- This would be a good place to send an rpc message to the person you're following
	-- possible future use: to update the current "leader" as to who is following them

	if self.followWarnTimer then
		self:debugMsg("  followWarnTimer found... cancelling", "debug")
		local result = self:CancelTimer(self.followWarnTimer, true)
		self:debugMsg("  result: "..tostring(result), "result")
	end

	self.myFollowTarget = tostring(followee)
end


-- Fires when autofollow ends
function MultiTool:followEnd( info )
	self:debugMsg("followEnd()", "debug")
	self:debugMsg("  info: "..tostring( info ), "debug")
	self:debugMsg("  currentFollowee: "..tostring( self.myFollowTarget ), "debug")

	-- Send MultiTool message to myFollowTarget letting them know that I lost them

	local rpcArgs = {}

	rpcArgs.prefix = "MultiTool"
	local msg = {
		op = "FOLLOW_LOST",
		follower_name = UnitName("player"),
		followee_name = self.myFollowTarget
	}
	rpcArgs.text = self:Serialize(msg)

	rpcArgs.distribution = "WHISPER"
	rpcArgs.target = self.myFollowTarget
	rpcArgs.prio = "ALERT"
	rpcArgs.noComm = nil

	-- rpcCommandSender adds checking of the noComm value before sending
	--self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	if self.followWarnTimer then
		self:debugMsg("  followWarnTimer found... cancelling", "debug")
		local result = self:CancelTimer(self.followWarnTimer, true)
		self:debugMsg("    result: "..tostring( result ), "result")
	end
	self:debugMsg("  setting new followWarnTimer", "debug")
	--self.followWarnTimer = self:ScheduleTimer(rpcCommandSender, 1, prefix, text, distribution, target, prio, noComm)
	self.followWarnTimer = self:ScheduleTimer("rpcCommandSenderWrapper", 2, rpcArgs)
end


-- To make this compatible with AceCallback, I had to wrap it up with a table of args instead of discrete ones
function MultiTool:rpcCommandSenderWrapper( rpcArgs )
	self:debugMsg("rpcCommandSenderWrapper()", "rpc")
	self:debugMsg("  prefix: "..tostring( rpcArgs.prefix ), "rpc")
	self:debugMsg("  text: "..tostring( rpcArgs.text ), "rpc")
	self:debugMsg("  distribution: "..tostring( rpcArgs.distribution ), "rpc")
	self:debugMsg("  target: "..tostring( rpcArgs.target ), "rpc")
	self:debugMsg("  prio: "..tostring( rpcArgs.prio ), "rpc")
	self:debugMsg("  noComm: "..tostring( rpcArgs.noComm ), "rpc")

	self:rpcCommandSender(rpcArgs.prefix, rpcArgs.text, rpcArgs.distribution, rpcArgs.target, rpcArgs.prio, rpcArgs.noComm)
end


--
-- Need delayed accept resurrection
--
function MultiTool:delayedAcceptResurrect()
	self:debugMsg("delayedAcceptResurrect()", "debug")
	AcceptResurrect()
end


--
-- Auto Accept Resurrection
--
function MultiTool:resurrectRequest(info, name, foo, bar)
	self:debugMsg("resurrectRequest()", "debug")
	self:debugMsg("  info: "..tostring(info), "debug")
	self:debugMsg("  name: "..tostring(name), "debug")
	self:debugMsg("  foo: "..tostring(foo), "debug")
	self:debugMsg("  bar: "..tostring(bar), "debug")

	-- -- Apparently, don't need offerer as name seems to be passed
	--local offerer = ResurrectGetOfferer()
	--self:debugMsg("  name: "..tostring(offerer), "debug")

	-- Only procede if they've got "Auto Acccept Resurrection" option checked
	if ( self.db.profile.resurrectFlag ) then
		self:debugMsg("  resurrectFlag is true...", "debug")

		self:debugMsg("  checking resurrectWhiteListOnlyFlag...", "debug")
		if not self.db.profile.resurrectWhiteListOnlyFlag or ( self.db.profile.resurrectWhiteListOnlyFlag and self:isInWhiteList( name ) ) then
			self:debugMsg("    Conditions met... ACCEPTING", "debug")

			local tmp_msgText = string.format(L["RESURRECT_WARN_MSG"], name)
			self:debugMsg("  tmp_msgText: "..tmp_msgText, "blather")

			-- DO THE WARNING
			self:playSoundByIndex(self.db.profile.resurrectWarnSound)
			UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)

			-- AcceptResurrect()

			local recoveryDelay = GetCorpseRecoveryDelay()
			self:debugMsg("  recoveryDelay: "..tostring(recoveryDelay), "debug")

			if ( recoveryDelay and recoveryDelay > 0 ) then
				self:debugMsg("  Need to set up a timer to auto rez when ready", "debug")

				-- set up timer
				if self.resurrectTimer then
					self:debugMsg("  resurrectTimer found... cancelling", "debug")
					local cancelResult = self:CancelTimer( self.resurrectTimer, true )
					self:debugMsg("    cancelResult: "..tostring(cancelResult), "debug")
				end

				self.resurrectTimer = self:ScheduleTimer( "delayedAcceptResurrect", recoveryDelay + 1  )
				self:debugMsg("  Timer Set for "..tostring(recoveryDelay +1).." seconds", "debug")
			else
				self:debugMsg("  No delay needed... ACCEPTING", "debug")
				AcceptResurrect()
			end
		end -- whitelistCheck
	end -- if resurrectFlag
end -- function


--
-- Auto Accept Trades
--
-- NOTE: It appears that due to abuse, AcceptTrade() is protected (unavailable)
function MultiTool:tradeAcceptUpdate(info, player, target, foo)
	self:debugMsg("tradeAcceptUpdate()", "debug")
	self:debugMsg("  info: "..tostring(info), "debug")
	self:debugMsg("  player: "..tostring(player), "debug")
	self:debugMsg("  target: "..tostring(target), "debug")
	self:debugMsg("  foo: "..tostring(foo), "debug")

	if (self.db.profile.tradeFlag) then
		self:debugMsg("    tradeFlag is true... continuing", "debug")
		if (target == 1 and player == 0) then
			--AcceptTrade()
			self:debugMsg("    ACCEPTED", "debug")
		end
	end
end


--
-- Auto Accept Escort Quests
--
function MultiTool:confirmEscortQuest(info, name, quest)
	self:debugMsg("confirmEscortQuest()", "debug")
	self:debugMsg("  info: "..tostring(info), "debug")
	self:debugMsg("  name: "..tostring(name), "debug")
	self:debugMsg("  quest: "..tostring(quest), "debug")

	-- Only procede if they've got "Auto Acccept Escort Quests" option checked
	if (self.db.profile.escortFlag) then
		self:debugMsg("  escortFlag is true... ACCEPTING", "debug")

		-- need to localize this
		local tmp_msgText = string.format(L["ESCORT_WARN_MSG"], quest, name)
		self:debugMsg("  tmp_msgText: "..tmp_msgText, "blather")

		-- DO THE WARNING
		self:playSoundByIndex(self.db.profile.escortStartedSound)
		UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)

		-- Done with preprocessing, now accept and hide the confirm dialog
		ConfirmAcceptQuest()
		StaticPopup_Hide("QUEST_ACCEPT")
	end
end


--
-- Auto Accept Party
--
-- NOTE: Unlike some other auto accept features in MultiTool, this one is VERY
--       security-sensitive, so no auto accept at all without the sender in
--       whitelist. If the groupRejectFlag is set, then NOT being in the
--       whitelist means active rejection.
function MultiTool:confirmPartyInvite(info, sender)
	self:debugMsg("confirmPartyInvite()", "debug")
	self:debugMsg("  sender: "..tostring(sender), "debug")

	local isInMyGuild = self:IsGuildMemberByName(tostring(sender))
	self:debugMsg("  isInMyGuild: "..tostring(isInMyGuild), "debug")


	local actionTaken = false

	if (self.db.profile.groupRejectFlag and not self:isInWhiteList(sender)) then
		self:debugMsg("  DECLINED: groupRejectFlag is true and sender is not in white list", "blather")
		-- actively reject and get lost
		DeclineGroup()
		actionTaken = true
	elseif (self.db.profile.groupGuildAutoAcceptFlag) then
		self:debugMsg("  ACCEPTED: groupGuildAutoAcceptFlag is true (whitelist skipped)", "blather")
		AcceptGroup()
		actionTaken = true
	elseif (self.db.profile.groupFlag and self:isInWhiteList(sender)) then
		self:debugMsg("  ACCEPTED: groupFlag is true and sender in white list", "blather")
		AcceptGroup()
		actionTaken = true
	else
		self:debugMsg("  IGNORED: groupRejectFlag is false and either groupFlag is false or sender not in white list", "blather")
	end

	-- Had to move the hide popup here after 3.1 to keep the hide from causing a false decline
	-- Not sure if this is relevant in 12.1 but doing it anyway
	if actionTaken then
		self:debugMsg("  actionTaken handler... ", "blather")
		StaticPopup_Hide("PARTY_INVITE")
	end
end


--
-- Auto Accept Summons
--
function MultiTool:confirmSummon()
	if (self.db.profile.summonFlag) then
		self:debugMsg("confirmSummon()", "debug")

		local acceptFlag = false
		-- get summonor name
		local summoner = GetSummonConfirmSummoner()
		self:debugMsg("  summoner: ".. tostring(summoner), "debug")
		local location = GetSummonConfirmAreaName()
		self:debugMsg("  location: ".. tostring(location), "debug")

		local guildName, _, _ = GetGuildInfo(summoner)
		self:debugMsg("  guildName: ".. tostring(guildName), "debug")

		-- see if it's white list only
		if (self.db.profile.summonWhiteListOnlyFlag) then
			self:debugMsg("  summonWhiteListOnlyFlag is true... further checks needed", "blather")
			-- need another check since they asked for it
			if (self:isInWhiteList(summoner)) then
				self:debugMsg("    Summoner is in white list", "blather")
				-- accept
				acceptFlag = true
			else
				self:debugMsg("    Summoner is NOT in white list... manually confirm if you wish", "blather")
			end
		else
			-- not summonWhiteListOnlyFlag, so always accept since we have summonFlag on
			self:debugMsg("  summonFlag is true and not restricted to white list only", "blather")
			acceptFlag = true
		end

		self:debugMsg("  Seeing if we should accept", "blather")
		self:debugMsg("    acceptFlag: "..tostring(acceptFlag), "blather")

		if (acceptFlag) then
			self:debugMsg("  ACCEPTED: Confirming summons", "blather")

			-- need to localize this
			local tmp_msgText = string.format(L["SUMMON_WARN_MSG"], location, summoner)
			self:debugMsg("  tmp_msgText: "..tmp_msgText, "blather")

			-- DO THE WARNING
			self:playSoundByIndex(self.db.profile.summonWarnSound)
			UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)

			-- take the ride and then hide the dialog
			ConfirmSummon()
			StaticPopup_Hide("CONFIRM_SUMMON")
		end
	end
end


--
-- Auto Decline Duels
--
function MultiTool:duelRequested(info, challenger)
	self:debugMsg("duelRequested()", "debug")
	if (self.db.profile.duelAcceptFlag and self:isInWhiteList(challenger)) then
		-- don't do anything, thereby allowing choice to accept duel or not
		return
	elseif (self.db.profile.duelFlag) then
		self:debugMsg("Duel denied from challenger:"..tostring(challenger), "blather")

		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
	end -- if duelFlag
end -- function duelRequested()


--
-- Wrapper for auto repair and auto sell gray
--
function MultiTool:autoMerchant()
	self:debugMsg("autoMerchant()", "debug")
	-- let's sell first - just in case we need repair money
	self:autoSellJunk()
	-- Now, repair all
	self:autoRepair()
end


--
-- Auto Sell Junk - Inspired by CrapAway
--
function MultiTool:autoSellJunk()
	if (self.db.profile.vendJunkFlag) then
		self:debugMsg("autoSellJunk()", "debug")

		-- iterate through bags
		for bag = 0, 4 do
			self:debugMsg("  bag"..tostring(bag), "blather")
			-- need to know the number of slots we have to look in
			local numSlots = C_Container.GetContainerNumSlots(bag)
			self:debugMsg("  bag"..tostring(bag)..": "..numSlots.." total slots", "blather")

			-- we have slots
			if (numSlots > 0) then
				-- go through items in bag
				for slot = 1, numSlots + 1 do
					self:debugMsg("   slot: "..tostring(slot), "blather")
					local currentItem = C_Container.GetContainerItemLink(bag,slot)
					self:debugMsg("   currentItem: "..tostring(currentItem), "blather")

					if (currentItem ~= nil) then
						-- Gotta get the item info using the link

						-- local currentItemQuality = Select(3, GetItemInfo(currentItem))
						local currentItemQuality = nil
						GetItemInfo(currentItem)
						 _,_,currentItemQuality,_,_,_,_,_,_,_ = GetItemInfo(currentItem)
						 self:debugMsg("     currentItemQuality: "..tostring(currentItemQuality), "blather")
						if (currentItemQuality ~= nil and currentItemQuality == 0) then
							C_Container.UseContainerItem(bag,slot)
						end
					end
				end
			end
		end -- end for loop
	end -- if vendJunkFlag
end -- autoSellJunk()


--
-- Auto Repair All
--
function MultiTool:autoRepair()
	local localForceDebugFlag = false

	self:debugMsg("autoRepair()", MultiTool:forceDebug(localForceDebugFlag, "debug"))
	self:debugMsg("  auto repair flag: "..tostring(self.db.profile.repairFlag), MultiTool:forceDebug(localForceDebugFlag, MultiTool:forceDebug(localForceDebugFlag, "blather")))

	if (self.db.profile.repairFlag) then
		self:debugMsg("    auto repair junk enabled... ", MultiTool:forceDebug(localForceDebugFlag, "blather"))
		self:debugMsg("    checking if merchant can repair... ", MultiTool:forceDebug(localForceDebugFlag, "blather"))
		if (CanMerchantRepair()) then
			self:debugMsg("      YES merchant can repair", MultiTool:forceDebug(localForceDebugFlag, "blather"))
			local rawAmount = 0
			local needRepair = false
			-- this next value can no longer be retrieved due to 7.3 changes...
			-- going to comment it ouf now and likely fully remove later
			--local myWithdrawlLimit = 0
			local guildName = nil
			local guildRankIndex = 0

			-- Get the needed guildInfo to set our rank
			-- in wow 7.3 they decided to make the GuildContolSetRank protected
			-- this means I can no longer actually get the info I want/neeed to decide if I've hit my daily withdrawl
			-- so I need to redo the logic for using guild funds to something mroe simple
			-- check if guild funds allowed
			-- try repair WITH guild funds if the checkbox says yes
			-- try repair without guild funds after
			guildName, _, guildRankIndex = GetGuildInfo("player")
			self:debugMsg("  guildName: "..tostring(guildName), MultiTool:forceDebug(localForceDebugFlag, "blather"))
			self:debugMsg("  guildRankIndex: "..tostring(guildRankIndex), MultiTool:forceDebug(localForceDebugFlag, "blather"))
--			if (guildName ~= nil ) then
--				-- set the guildRank for use by GetGuildBankWithdrawGoldLimit()
--				GuildControlSetRank(guildRankIndex)
--				-- set the limit
--				myWithdrawlLimit = GetGuildBankWithdrawGoldLimit()
--				-- covert into copper
--				myWithdrawlLimit = myWithdrawlLimit * 1000
--			end

			-- Find out what the cost is and whether we need to repair or not
			rawAmount, needRepair = GetRepairAllCost()
			self:debugMsg("  rawAmount: "..tostring(rawAmount), MultiTool:forceDebug(localForceDebugFlag, "debug"))
			self:debugMsg("  needRepair: "..tostring(needRepair), MultiTool:forceDebug(localForceDebugFlag, "debug"))
			self:debugMsg("  repairGuildFlag: "..tostring(self.db.profile.repairGuildFlag), MultiTool:forceDebug(localForceDebugFlag, "debug"))
			self:debugMsg("  CanGuildBankRepair: "..tostring(CanGuildBankRepair()), MultiTool:forceDebug(localForceDebugFlag, "debug"))
			self:debugMsg("  GetGuildBankMoney: "..tostring(GetGuildBankMoney()),MultiTool:forceDebug(localForceDebugFlag, "debug"))
			--self:debugMsg("  myWithdrawlLimit: "..tostring(myWithdrawlLimit), MultiTool:forceDebug(localForceDebugFlag, "debug"))

			-- Only bother continuing if we need repairing
			if (needRepair) then
				self:debugMsg("REPAIR NEEDED...", MultiTool:forceDebug(localForceDebugFlag, "debug"))
				self:debugMsg("  Checking to see if we will be using Guild Funds...", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				-- set whether to try to use Guild Bank flag or not
				-- we default to true and then see if any of the many conditions would make it false
				local useGuildFunds = true

				-- Checking config option for Use Guild Funds
				if (not self.db.profile.repairGuildFlag) then
					-- Guild repair flag is false, so don't try and repair
					useGuildFunds = false
					self:debugMsg("    MultiTool config value set to not use guild funds", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				else
					self:debugMsg("    MultiTool config value set to to try and use guild funds", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				end

				-- Ensuring the guild allows using guild funds for repair
				if (CanGuildBankRepair()) then
					-- Guild Bank Repair Allowed by your guild
					self:debugMsg("    Guild settings allow repairs from guild funds", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				else
					-- Guild Bank Repair not allowd by your guild
					useGuildFunds = false
					self:debugMsg("    Guild settings do not allow repairs from guild funds", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				end

				-- Ensuring there's enough money in the guild coffers for repairs
				if (rawAmount > GetGuildBankMoney()) then
					-- Not enough guild bank money for repairs
					useGuildFunds = false
					self:debugMsg("    Not enough guild funds available for repairs", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				else
					self:debugMsg("    There are enough guild funds available", MultiTool:forceDebug(localForceDebugFlag, "blather"))
				end

--      	-- THIS SECCTION DISABLED DUE TO 7.3 RESTRICTION ON GUILD INFO
--      	-- Ensuring you're within your limit
--      	if (rawAmount > myWithdrawlLimit) then
--     		-- Repair cost above my personal repair limit
--      		useGuildFunds = false
--      		self:debugMsg("    Player repairs over guild repair limit", MultiTool:forceDebug(localForceDebugFlag, "blather"))
--      	else
--      		self:debugMsg("    Player repairs under guild repair limit", MultiTool:forceDebug(localForceDebugFlag, "blather"))
--      	end

			 -- Do the repair
				self:debugMsg("  Performing RepairAll", MultiTool:forceDebug(localForceDebugFlag, "debug"))
				self:debugMsg("    useGuildFunds: "..tostring(useGuildFunds), MultiTool:forceDebug(localForceDebugFlag, "debug"))
				RepairAllItems(useGuildFunds)

				if(localForceDebugFlag) then
					-- fix for issue with wow changing the function I needed to see if I could withdraw or Not
					local postRepairRawAmount = nil
					local postRepairNeedRepair = nil

					postRepairRawAmount, postRepairNeedRepair = GetRepairAllCost()
				    self:debugMsg("  Checking to see if Guild Repair worked or not: ", "notice")
				    self:debugMsg("    postRepairRawAmount: "..tostring(postRepairRawAmount), "notice")
				    self:debugMsg("    postRepairNeedRepair: "..tostring(postRepairNeedRepair), "notice")
				end
				self:debugMsg("  WORKAROUND for no withdrawl limit - try repair all with personal funds now", MultiTool:forceDebug(localForceDebugFlag, "debug"))

				RepairAllItems(nil)

				-- FINAL CHECK
				if(localForceDebugFlag) then
					local postPostRepairRawAmount = nil
					local postPostRepairNeedRepair = nil
					postPostRepairRawAmount, postPostRepairNeedRepair = GetRepairAllCost()
				 	self:debugMsg("  Checking to see if final repair worked or not: ", "notice")
				 	self:debugMsg("    postPostRepairRawAmount: "..tostring(postPostRepairRawAmount), "notice")
				 	self:debugMsg("    postPostRepairNeedRepair: "..tostring(postPostRepairNeedRepair), "notice")
				end

				-- Send a repair warning message if they've enabled repairWarnFlag
				if (self.db.profile.repairWarnFlag) then
					self:debugMsg("repairWarnFlag set... Preparing RPC message", MultiTool:forceDebug(localForceDebugFlag, "blather"))

					local prefix = "MultiTool"
					local msg = {
						op = "REPAIR_WARN",
						repair_cost = rawAmount,
						guild_funds = tostring(useGuildFunds)
					}
					local text = self:Serialize(msg)
					local distribution = "RAID"
					local target = UnitName("player")
					local prio = "ALERT"

					-- Change distribution if we're set to only whisper
					if (self.db.profile.repairWhisperFlag) then
						self:debugMsg("  repairWhisperFlag is true: Changing distribution to WHISPER", MultiTool:forceDebug(localForceDebugFlag, "blather"))
						distribution = "WHISPER"
					end

					self:debugMsg("  prefix: "..tostring(prefix), MultiTool:forceDebug(localForceDebugFlag, "blather"))
					self:debugMsg("  msg: "..tostring(msg), MultiTool:forceDebug(localForceDebugFlag, "blather"))
					self:debugMsg("  text: "..tostring(text), MultiTool:forceDebug(localForceDebugFlag, "blather"))
					self:debugMsg("  distribution: "..tostring(distribution), MultiTool:forceDebug(localForceDebugFlag, "blather"))
					self:debugMsg("  target: "..tostring(target), MultiTool:forceDebug(localForceDebugFlag, "blather"))
					self:debugMsg("  prio: "..tostring(prio), MultiTool:forceDebug(localForceDebugFlag, "blather"))

					-- rpcCommandSender adds checking of the noComm value before sending
					self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
				end -- if repairWarnFlag
			else
				self:debugMsg("NO REPAIR NEEDED", MultiTool:forceDebug(localForceDebugFlag, "debug"))
			end -- if needRepair)
		else
			self:debugMsg("NO REPAIR POSSIBLE: CanMerchantRepair == false", MultiTool:forceDebug(localForceDebugFlag, "blather"))
		end -- if CanMerchantRepair()
	else
		self:debugMsg("Auto Repair not enabled", MultiTool:forceDebug(localForceDebugFlag, "blather"))
	end -- if repairFlag
end -- function autoRepair()


--
-- Bag total/free updater  (Based on BagSlots addon)
--
function MultiTool:updateBagSpace(isInitial)
	-- to be efficient, only bother if we are flagged for it
	if (self.db.profile.bagFlag) then
		if (self.db.profile.debugFlag) then
			self:debugMsg("updateBagSpace():: ENGAGED", "debug")
			self:debugMsg("  bagWarn:"..tostring(self.db.profile.bagWarn), "debug")
			self:debugMsg("  bagWhisperFlag:"..tostring(self.db.profile.bagWhisperFlag), "debug")
			self:debugMsg("  totalBagSlots:"..tostring(totalBagSlots), "debug")
			self:debugMsg("  totalFreeBagSlots:"..tostring(totalFreeBagSlots), "debug")
			self:debugMsg("  totalUsedBagSlots:"..tostring(totalUsedBagSlots), "debug")
		end -- debug

		local sendWarning = false
		local tmp_totalBagSlots = 0
		local tmp_totalFreeBagSlots = 0
		local tmp_totalUsedBagSlots = 0

		-- go through bags and add each to the totals
		for bag = 0, 4 do
			self:debugMsg("Getting slots for bag "..tostring(bag), "blather")

			local numSlots = C_Container.GetContainerNumSlots(bag)

			if (numSlots > 0) then
				tmp_totalBagSlots = tmp_totalBagSlots + numSlots
				local freeSlots = C_Container.GetContainerNumFreeSlots(bag)
				tmp_totalFreeBagSlots = tmp_totalFreeBagSlots + freeSlots
				local usedSlots = numSlots - freeSlots
				tmp_totalUsedBagSlots = tmp_totalUsedBagSlots + usedSlots

				if (self.db.profile.debugFlag) then
					self:debugMsg("Bag "..tostring(bag)..": has slots", "blather")
					self:debugMsg("  numSlots:"..tostring(numSlots), "blather")
					self:debugMsg("  tmp_totalBagSlots:"..tostring(tmp_totalBagSlots), "blather")
					self:debugMsg("  freeSlots:"..tostring(freeSlots), "blather")
					self:debugMsg("  tmp_totalFreeBagSlots:"..tostring(tmp_totalFreeBagSlots), "blather")
					self:debugMsg("  tmp_totalUsedBagSlots:"..tostring(tmp_totalUsedBagSlots), "blather")
				end
			else
			  self:debugMsg("Bag "..tostring(bag)..": not present", "blather")
			end
		end -- end for loop

		--[[
		-- Adjusting by -1 because ITEM_PUSH seems to trigger BEFORE BAG_UPDATE runs
		if (tmp_totalFreeBagSlots > 0) then
		  tmp_totalFreeBagSlots = tmp_totalFreeBagSlots - 1
		end
		]]

		self:debugMsg("Done counting bags", "debug")
		self:debugMsg("  tmp_totalFreeBagSlots:"..tostring(tmp_totalFreeBagSlots), "debug")
		self:debugMsg("  bagWarn:"..tostring(self.db.profile.bagWarn), "debug")
		self:debugMsg("  bagWhisperFlag:"..tostring(self.db.profile.bagWhisperFlag), "debug")

		-- check to see if this update is gain or loss of free slots
		-- v0.2.03 - added totalFreeBagSlots == 0 to get on initial load
		if (totalFreeBagSlots == 0 or tmp_totalFreeBagSlots < totalFreeBagSlots) then
			self:debugMsg("Need to check agains thresholds", "debug")

			if (tmp_totalFreeBagSlots == 0) then
				self:debugMsg("  Bag Space EMPTY ... sendWarning = true", "debug")
				sendWarning = true
			elseif (tmp_totalFreeBagSlots < self.db.profile.bagWarn) then
				self:debugMsg("  Threshold met ... sendWarning = true", "debug")
				sendWarning = true
			else
			  self:debugMsg("  Threshold NOT met... sendWarning = false", "debug")
			end
		end

		if (isInitial == "initial") then
			sendWarning = false
			self:debugMsg("Initial call to updateBagSpace - overriding setWarning to false", "debug")
		end

		self:debugMsg("Checking to see if we need to warn about bag space", "debug")
		-- Send the warning message if we have one
		if (sendWarning == true) then
			self:debugMsg("  sendWarning is true: sending warning", "debug")

			local prefix = "MultiTool"
			local msg = {
				op = "BAG_WARN",
				free_slots = tmp_totalFreeBagSlots
			}
			local text = self:Serialize(msg)
			local distribution = "RAID"
			local target = UnitName("player")
			local prio = "ALERT"

			-- Change distribution if we're set to only whisper
			if (self.db.profile.bagWhisperFlag) then
				self:debugMsg("  bagWhisperFlag is true: Changing distribution to WHISPER", "debug")
				distribution = "WHISPER"
			end

			-- rpcCommandSender adds checking of the noComm value before sending
			self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
		else
			self:debugMsg("  sendWarning is false: not sending comms", "debug")
		end -- if sendWarning

		self:debugMsg("Updating master bag slot count values", "debug")
		-- Update the addon's copy of the bag levels
		totalBagSlots = tmp_totalBagSlots
		totalFreeBagSlots = tmp_totalFreeBagSlots
		totalUsedBagSlots = tmp_totalUsedBagSlots

		self:debugMsg("updateBagSpace() ... finalizing", "blather")
		self:debugMsg("  totalBagSlots:"..tostring(totalBagSlots), "blather")
		self:debugMsg("  totalFreeBagSlots:"..tostring(totalFreeBagSlots), "blather")
		self:debugMsg("  totalUsedBagSlots:"..tostring(totalUsedBagSlots), "blather")
	end -- end if bagFlag
end -- end of funcction


--
-- Quest Log total/free updater
--
function MultiTool:updateQuestLogSpace()
	-- to be efficient, only bother if we are flagged for it
	if (self.db.profile.questLogFlag) then
		self:debugMsg("updateQuestLogSpace()", "debug")
		self:debugMsg("  questLogWarn:"..tostring(self.db.profile.questLogWarn), "debug")
		self:debugMsg("  questLogWhisperFlag:"..tostring(self.db.profile.questLogWhisperFlag), "debug")

		-- if they ever up the num of quests available...
		local constant_questLogSize = 25

		local sendWarning = false
		local tmp_totalQuestLogEntries = 0
		local tmp_totalFreeQuestLogSlots = 0

		_,tmp_totalQuestLogEntries = C_QuestLog.GetNumQuestLogEntries()
		tmp_totalFreeQuestLogSlots = constant_questLogSize - tmp_totalQuestLogEntries
		self:debugMsg("  tmp_totalQuestLogEntries: "..tostring(tmp_totalQuestLogEntries), "debug")
		self:debugMsg("  tmp_totalFreeQuestLogSlots: "..tostring(tmp_totalFreeQuestLogSlots), "debug")

		-- check to see if this update is gain or loss of free slots
		if (tmp_totalFreeQuestLogSlots < totalFreeQuestLogSlots) then
			self:debugMsg("Free quest log slots DOWN... checking agains thresholds", "debug")

			if (tmp_totalFreeQuestLogSlots == 0) then
				self:debugMsg("  Quest Log FULL ... sendWarning = true", "debug")
				sendWarning = true
			elseif (tmp_totalFreeQuestLogSlots == self.db.profile.questLogWarn) then
				self:debugMsg("  Threshold met ... sendWarning = true", "debug")
				sendWarning = true
			else
				self:debugMsg("  Threshold NOT met... sendWarning = false", "debug")
			end
		end

		-- Send the warning message if we have one
		if (sendWarning) then
			local prefix = "MultiTool"
			local msg = {
				op = "QUEST_LOG_WARN",
				free_slots = tmp_totalFreeQuestLogSlots
			}
			local text = self:Serialize(msg)
			local distribution = "RAID"
			local target = UnitName("player")
			local prio = "NORMAL"

			-- Change distribution if we're set to only whisper
			if (self.db.profile.questLogWhisperFlag) then
				self:debugMsg("  questLogWhisperFlag is true: Changing distribution to WHISPER", "debug")
				distribution = "WHISPER"
			end

			-- rpcCommandSender adds checking of the noComm value before sending
			self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
		end -- if sendWarning

		-- last thing:: Update the addon's copy of the freeSlot levels
		totalFreeQuestLogSlots = tmp_totalFreeQuestLogSlots
	else
		self:debugMsg("questLogFlag is false... updateQuestLogSpace() skipped", "debug")
	end -- end if questLogFlag
end -- end of funcction


-- ------------------------------------------------
-- HOOKED FUNCTIONS
-- ------------------------------------------------

--
-- Trade Functions
--
-- NOTE: AcceptTrade() appears to be protected - may not be able to do this stuff
--[[
function acceptTradeHook(noComm)
	local self = MultiTool
	if (self.db.profile.tradeFlag) then

	end
end
]]

--
-- Group Functions
--
-- NOTE: Commented out as it appears unneeded
--[[
function acceptGroupHook(noComm)
	local self = MultiTool
	if (self.db.profile.groupFlag) then

	end
end
]]

-------------------
-- Quest Functions
-------------------
function selectGossipActiveQuestHook(index, noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("selectGossipActiveQuestHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "SELECT_GOSSIP_ACTIVE",
			index = index,
			title = self:myGetActiveTitle(index)
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function getQuestRewardHook(index, noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("getQuestRewardHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "GET_QUEST_REWARD",
			index = index,
			title = self:myGetActiveTitle(index)
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function selectAvailableQuestHook(index, noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("selectAvailableQuestHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "SELECT_AVAILABLE",
			index = index,
			title = self:myGetActiveTitle(index)
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function selectGossipAvailableQuestHook(index, noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("selectGossipAvailableQuestHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "debug")
		self:debugMsg("  noComm:"..tostring(noComm), "debug")



		local availbleQuestsTable = self:getAvailableQuestsTable()

		local questTitle = availbleQuestsTable[index]
		self:debugMsg("  questTitle:"..tostring(questTitle), "debug")

		local altQuestTitle = GetAvailableTitle(index)
		self:debugMsg("  altQuestTitle:"..tostring(altQuestTitle), "debug")

		local altAltQuestTitle =  self:myGetActiveTitle(index)
		self:debugMsg("   altAltQuestTitle"..tostring(altAltQuestTitle), "debug")

--		for index,title in ipairs(availbleQuestsTable) do
--			self:debugMsg("    index: "..tostring(index), "debug")
--			self:debugMsg("    title: |"..tostring(title).."|", "debug")
--		end

		local prefix = "MultiTool"
		local msg = {
		  op = "QUEST_GOSSIP",
		  sub_op = "SELECT_GOSSIP_AVAILABLE",
		  index = index,
		  title = questTitle
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function selectGossipOptionHook(index, noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("selectGossipOptionHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "SELECT_OPTION",
			index = index,
			title = self:myGetActiveTitle(index)
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function selectActiveQuestHook(index, noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("selectActiveQuestHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "SELECT_ACTIVE",
			index = index,
			title = self:myGetActiveTitle(index)
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function acceptQuestHook(noComm)
	local self = MultiTool
	self:debugMsg("acceptQuestHook():: ENGAGED", "debug")

	if (self.db.profile.gossipFlag) then
		self:debugMsg("acceptQuestHook():: ENGAGED", "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "ACCEPT_QUEST"
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function completeQuestHook(noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("completeQuestHook():: ENGAGED", "debug")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "COMPLETE_QUEST"
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


function declineQuestHook(noComm)
	local self = MultiTool

	if (self.db.profile.gossipFlag) then
		self:debugMsg("declineQuestHook():: ENGAGED", "debug")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "QUEST_GOSSIP",
			sub_op = "DECLINE_QUEST"
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("gossipFlag is false... not sending comms", "debug")
	end
end


------------------
-- Taxi following
------------------
function takeTaxiNodeHook(index, noComm)
	local self = MultiTool

	-- cancel followWarnTimer if active
	if self.followWarnTimer then
	  self:debugMsg("  followWarnTimer found... cancelling", "debug")
	  local result = self:CancelTimer(self.followWarnTimer, true)
	  self:debugMsg("    result: "..tostring( result ), "result")
	end

	-- Only use the additional functionality IF taxiFlag is true
	if (self.db.profile.taxiFlag) then
		self:debugMsg("takeTaxiNodeHook():: ENGAGED", "debug")
		self:debugMsg("  index:"..tostring(index), "blather")
		self:debugMsg("  noComm:"..tostring(noComm), "blather")

		local prefix = "MultiTool"
		local msg = {
			op = "TAKETAXI",
			node = index,
			nodeName = TaxiNodeName(index)
		}
		local text = self:Serialize(msg)

		local distribution = "RAID"
		local target = UnitName("player")
		local prio = "ALERT"

		-- rpcCommandSender adds checking of the noComm value before sending
		self:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
	else
		self:debugMsg("taxiFlag is false... not sending comms", "debug")
	end
end -- end function takeTaxiNodeHook


-- ------------------------------------------------
-- COMMUNICATIONS HANDLER
-- ------------------------------------------------

--
-- Handles received commands
--
-- NOTE: This should REALLY get broken up into separate items / tableize
--
function MultiTool:OnCommReceived(prefix, message, distribution, target,foo)
	-- Deserialize incoming message
	local success, o = self:Deserialize(message)
	if (self.db.profile.debugFlag or self.db.profile.blatherFlag or self.db.profile.commFlag) then
		self:debugMsg("OnCommReceived():: ENGAGED", "comm")
		self:debugMsg("  prefix:"..tostring(prefix), "comm")
		self:debugMsg("  message:"..tostring(message), "comm")
		self:debugMsg("  distribution:"..tostring(distribution), "comm")
		self:debugMsg("  target:"..tostring(target), "comm")
		self:debugMsg("  player:"..UnitName("player"), "comm")
		self:debugMsg("  Deserialize success:"..tostring(success), "comm")
		self:debugMsg("  Message Content:"..tostring(o), "comm")
	end -- end if debugFlag


	if (success == false) then
		-- don't do anyting if we could not deserialize
		self:debugMsg("Failed to deserialize the message - OnCommReceived can not process any further", "error")
		return -- Failure
	else
		--
		-- TEMPLATE - Not actually used
		--
		if (o["op"] == "foo") then
			if (self.db.profile.actionFlag) then
				self:debugMsg("FOO op ENGAGED", "debug")

				-- Put any extra conditions here
				if ("someCondition" == "some value") then
					self:debugMsg("debug_text_here", "comm")
					return -- do nothing
				else
					-- do the action
					self:debugMsg("debug_text_here", "comm")

					-- actual command such as TakeTaxiNode(o["node"], "noComm")
				end -- ending extra conditions
			end -- if gossipFlag
		end -- end if op == foo


		--
		-- FOLLOW LOST - Not actually used
		--
		if (o["op"] == "FOLLOW_LOST") then
			if (self.db.profile.followWarnFlag) then

				self:debugMsg("  target: "..tostring(target), "debug")
				self:debugMsg("  player: "..tostring(UnitName("player")), "debug")
				self:debugMsg("  followee_name: "..tostring(followee_name), "debug")
				self:debugMsg("  follower_name: "..tostring(follower_name), "debug")

				if ( o["followee_name"] ~= UnitName("player") ) then
					self:debugMsg("FOLLOW_LOST skipped ... they weren't talking to me", "blather")
					return -- do nothing
				elseif (self.db.profile.followWarnWhiteListOnlyFlag and not self:isInWhiteList(o["follower_name"])) then
					self:debugMsg("FOLLOW_LOST skipped ... "..tostring(o["follower_name"]).." not in whitelist", "blather")
					return -- do nothing
				else
					-- do the action
					self:debugMsg("FOLLOW_LOST op ENGAGED", "debug")
					self:debugMsg("  o.follower_name: "..tostring(o["follower_name"]), "debug")

					-- need to localize this
					local tmp_msgText = string.format(L["FOLLOW_WARN_MSG"], o["follower_name"])
					self:debugMsg("  tmp_msgText: "..tmp_msgText, "blather")

					-- DO THE WARNING
					self:playSoundByIndex(self.db.profile.followWarnSound)
					UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)

				end -- ending extra conditions
			end -- if followFlag
		end -- end if op == FOLLOW_LOST


		--
		-- Bag Space Warning
		--
		if (o["op"] == "BAG_WARN") then
			if (self.db.profile.bagFlag) then
				if (self.db.profile.bagWhisperFlag and target ~= UnitName("player")) then
					-- we're set to whisper but this came from someone else
					self:debugMsg("BAG_WARN skipped due to bagWhisperFlag", "debug")
					return -- do nothing
				else
					self:debugMsg("BAG_WARN op engaged", "debug")
					self:debugMsg("  o.free_slots: "..tostring(o["free_slots"]), "debug")

					-- need to localize this
					local tmp_msgText = string.format(L["BAG_WARN_MSG"], target, o["free_slots"])
					self:debugMsg("  tmp_msgText: "..tmp_msgText, "blather")

					-- DO THE WARNING
					self:playSoundByIndex(self.db.profile.bagWarnSound)
					UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)
				end
			end -- end of flagCheck
		end -- end if op == BAG_WARN


	--
	-- Repair Warning
	--
	if (o["op"] == "REPAIR_WARN") then
		if (self.db.profile.repairWarnFlag) then
			if (self.db.profile.repairWhisperFlag and target ~= UnitName("player")) then
				-- we're set to whisper but this came from someone else
				self:debugMsg("REPAIR_WARN skipped due to repairWhisperFlag", "debug")
				return -- do nothing
			else
				self:debugMsg("REPAIR_WARN op engaged", "debug")
				self:debugMsg("  o.repair_cost: "..tostring(o["repair_cost"]).."c", "debug")
				self:debugMsg("  o.guild_funds: "..tostring(o["guild_funds"]), "debug")

				if (o["repair_cost"] > 0) then
					local tmp_msgText = string.format(L["REPAIR_WARN_MSG"], target, self:copperToCurrency(o["repair_cost"], "text"), tostring(o["guild_funds"]))
					self:debugMsg("  tmp_msgText: "..tmp_msgText, "blather")

					-- DO THE WARNING
					self:playSoundByIndex(self.db.profile.repairWarnSound)
					UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)
				end -- if repair_cost > 0
			end -- if repairWhisperFlag
		end -- end of flagCheck
	end -- end if op == BAG_WARN


    --
    -- Quest Log Warning
    --
    if (o["op"] == "QUEST_LOG_WARN") then
      if (self.db.profile.questLogFlag) then
        if (self.db.profile.questLogWhisperFlag and target ~= UnitName("player")) then
          -- we're set to whisper but this came from someone else
          self:debugMsg("QUEST_LOG_WARN skipped due to questLogWhisperFlag", "debug")
          return -- do nothing
        else
          self:debugMsg("QUEST_LOG_WARN op engaged", "debug")
          self:debugMsg("  o.free_slots: "..tostring(o["free_slots"]), "debug")

          local tmp_msgText = string.format(L["QUEST_LOG_WARN_MSG"], target, o["free_slots"])
          self:debugMsg("  tmp_msgText: "..tmp_msgText, "debug")

          -- DO THE WARNING
          self:playSoundByIndex(self.db.profile.questLogWarnSound)
          UIErrorsFrame:AddMessage(tmp_msgText, 1.0, 1.0, 0.5, 5.0)
        end -- end whisper check
      end -- end of flagCheck
    end -- end if op == BAG_WARN

    --
    -- Quest Gossip handler for cloning actions at quest givers
    --
    if (o["op"] == "QUEST_GOSSIP") then
      if (self.db.profile.gossipFlag) then
        -- Put global quest gossip checks here
        if (tostring(target) == UnitName("player")) then
          -- The target (sender) is ME... only an idiot would believe their own gossip
          --
          -- Also, if we don't detect and block this situation, it messes with city guards
          -- and those new (as of 4.something) multi-profession trainers
          -- A big thanks to Nebby (my sweetheart) for helping me find this bug
          self:debugMsg("QUEST_GOSSIP target(sender)==player - not doing anything", "comm")
          return -- do nothing
        else
          -- do the action
          self:debugMsg("QUEST_GOSSIP global conditions succeded - parsing subcommands", "comm")

          if (o.sub_op == "SELECT_GOSSIP_AVAILABLE") then
            -- Get list of quests available
            local availableQuestsTable = self:getAvailableQuestsTable()
            local questTitleLocal = nil
            if o.index ~= nil then
              questTitleLocal = availableQuestsTable[o.index]
            end
            self:debugMsg("  questTitleLocal:"..tostring(questTitleLocal), "blather")

            if o.title == nil then
              -- should just fail outright, but this is here for backward comaptibility
              -- with previous versions of MultiTool that don't properly pass title
              -- tacking on noComm so we don't cause message storm
              self:debugMsg("  o.title is nil Engaging Backward compatible mode...", "blather")
              SelectGossipAvailableQuest(o.index, "noComm")
            elseif o["title"] == questTitle then
              -- All good... take this
              self:debugMsg("  o.title matches questTitle selecting index "..tostring(o.index), "blather")
              -- tacking on noComm so we don't cause message storm
              SelectGossipAvailableQuest(o.index, "noComm")
            else
              self:debugMsg("  questTitleLocal and o.title do not match... finding correct index", "blather")
              self:debugMsg("    originalIndex:"..tostring(o.index), "blather")
              -- uh-oh, not right - need to check more
              local correctIndex = self:findIndexOfText(availableQuestsTable, o.title)
              self:debugMsg("    correctIndex:"..tostring(correctIndex), "blather")

              if correctIndex ~= nil then
                self:debugMsg("    correctIndex found... engaging selection", "blather")
                SelectGossipAvailableQuest(o.index, "noComm")
              else
                self:debugMsg("Unable to find correct index for "..tostring(o.title), "warn")
              end
            end
          elseif (o.sub_op == "SELECT_AVAILABLE") then
            -- tacking on noComm so we don't cause message storm
            SelectAvailableQuest(o.index, "noComm")
          elseif (o.sub_op == "SELECT_OPTION") then
            -- tacking on noComm so we don't cause message storm
            SelectGossipOption(o.index, "noComm")
          elseif (o.sub_op == "SELECT_ACTIVE") then
            -- tacking on noComm so we don't cause message storm
            SelectActiveQuest(o.index, "noComm")
          elseif (o.sub_op == "ACCEPT_QUEST") then
            -- tacking on noComm so we don't cause message storm
            AcceptQuest("noComm")
          elseif (o.sub_op == "GET_QUEST_REWARD") then
            -- This one's special.. using logic from QuestGuru to make sure we
            -- don't allow cloning of reward choices
            if (self.db.profile.rewardFlag or GetNumQuestChoices() < 2) then
              self:debugMsg(tostring(GetNumQuestChoices()).." choice - ok to run", "debug")
              -- tacking on noComm so we don't cause message storm
              GetQuestReward(o.index,"noComm")
            else
              self:debugMsg(tostring(GetNumQuestChoices()).." choices - Blocking getQuestReward", "debug")
            end
          elseif (o.sub_op == "SELECT_GOSSIP_ACTIVE") then
            -- tacking on noComm so we don't cause message storm
            SelectGossipActiveQuest(o.index, "noComm")
          elseif (o.sub_op == "COMPLETE_QUEST") then
            -- tacking on noComm so we don't cause message storm
            CompleteQuest("noComm")
          elseif (o.sub_op == "DECLINE_QUEST") then
            -- tacking on noComm so we don't cause message storm
            DeclineQuest("noComm")
          end
        end -- ending extra conditions
      end -- if gossipFlag
    end -- end if op == foo

    --
    -- TAKETAXI
    --
    if (o["op"] == "TAKETAXI") then

      -- Only continue IF the taxiFlag is true
      if (self.db.profile.taxiFlag) then
        if (self.db.profile.taxiWhiteListOnlyFlag and not self:isInWhiteList(target)) then
          -- taxi reject flag set, but sender is NOT in white list
          self:debugMsg("Taxi request rejected.. "..tostring(target).."not in white list", "debug")
          return -- don't do anything
        end

        local numNodes = NumTaxiNodes()
        self:debugMsg("  numNodes: "..tostring(numNodes), "blather")

        -- see if we're at a flightmaster
        if (numNodes > 0) then

          -- Fix for ticket #1
          if (o["nodeName"] ~= "INVALID" and o["nodeName"] ~= TaxiNodeName(o["node"])) then
            self:debugMsg("TAKETAXI: Passed Index to NodeName mismatch... searching by name", "debug")
            self:debugMsg("  o.node: "..tostring(o["node"]), "debug")
            self:debugMsg("  o.nodeName: "..tostring(o["nodeName"]), "debug")
            self:debugMsg("  local nodeName: "..tostring(TaxiNodeName(o["node"])), "debug")

            --[[
            -- for one of a number of reasons, the requested node's name does not
            -- match the node name of the index we were passed. We will try to do
            -- a more intensive lookup and if we find the issue, we will replace
            -- the passed index with a local index value
            ]]

            local matchFoundFlag = false
            self:debugMsg("  numNodes: "..tostring(numNodes), "debug")

            self:debugMsg("Iterating through available nodes", "debug")
            local currentNode = 1
            local indexChanged = false

            --[[
            -- while (matchFoundFlag == false or currentNode < (numNodes +1) or currentNode < 50) do
            ]]
            for currentNode = 1, numNodes, 1 do
              local currentNodeName = TaxiNodeName(currentNode)
               self:debugMsg("  currentNode: "..tostring(currentNode), "blather")
               self:debugMsg("  currentNodeName: "..tostring(currentNodeName), "blather")

              if (currentNodeName == tostring(o["nodeName"])) then
                self:debugMsg("MATCH FOUND... setting new node index: "..tostring(currentNode), "blather")
                o["node"] = currentNode
                indexChanged = true
                break
              end -- if currentnodeName == o.nodeName
              currentNode = currentNode + 1
            end -- for loop

            if (indexChanged == false) then
              --failure
              msgString = string.format(L["TAXI_CANT_FOLLOW"], o["nodeName"])
              self:debugMsg(msgString, "warn")
              -- force invalid node so that we don't try to take one anyway
              o["node"] = 0
              self:debugMsg("setting o.node=0", "debug")
            end
          end -- nodename ~= INVALID and nodename ~TaxiNodeName(o.node)

          if (o["nodeName"] ~= TaxiNodeName(o["node"])
              or UnitOnTaxi("player")
              or o["nodeName"] == "INVALID"
              or target == UnitName("player")
          )
          then
            -- NoSend
            if (self.db.profile.debugFlag) then
              self:debugMsg("TAKETAXI op NOT engaged", "debug")
              self:debugMsg("  searchFailed "..tostring(searchFailed), "blather")
              self:debugMsg("  Am I on taxi? "..tostring(UnitOnTaxi("player")), "blather")
              self:debugMsg("  actual node requested: "..tostring(o["node"]).." ("..tostring(o["nodeName"])..")", "blather")
              self:debugMsg("  effective node requested: "..tostring(o["node"]).." ("..TaxiNodeName(o["node"])..")", "blather")
            end
            return -- DON'T DO ANYTHING: this stops a message storm
          else
            self:debugMsg("TAKETAXI op engaged", "debug")
            -- by passing the extra arg "noComm" to the takeTaxiNode, I think I solve the msg storms
            TakeTaxiNode(o["node"], "noComm")
          end -- big multiline block
        else
          -- taxiFlag set, but NOT at flightmaster
          self:debugMsg(L["TAXI_NO_FLIGHTMASTER"], "debug")
        end -- if numNodes
      else
        self:debugMsg("taxiFlag is false... ignoring TAKETAXI request", "debug")
      end -- end if taxiFlag
    end -- end if op==TAKETAXI
  end -- if success==false
end -- function OnCommReceived


--
-- Wraps up Remote procedure call commands with a "nocomm" throttler
--
function MultiTool:rpcCommandSender(prefix, text, distribution, target, prio, noComm)
  --debug
  if (self.db.profile.debugFlag or self.db.profile.blatherFlag or self.db.profile.commFlag) then
    self:debugMsg("rpcCommandSender()", "rpc")
    self:debugMsg("  prefix: "..tostring(prefix), "rpc")
    self:debugMsg("  text: "..tostring(text), "rpc")
    self:debugMsg("  distribution: "..tostring(distribution), "rpc")
    self:debugMsg("  target: "..tostring(target), "rpc")
    self:debugMsg("  prio: "..tostring(prio), "rpc")
    self:debugMsg("  noComm flag: "..tostring(noComm), "rpc")
  end

  -- New throttling - DO NOT send msg unless noComm is nil
  if (noComm) then
    self:debugMsg("noComm flag IS set, NOT sending command", "rpc")
    -- Teh Gogglez - They do NOTHING!
    return
  else
    self:debugMsg("noComm flag NOT set, sending command", "rpc")
    if (GetNumGroupMembers() == 0 and (distribution == "RAID" or distribution == "PARTY")) then
      -- NOT in party, but trying to send to party - modify distirbution and target
      distribution = "WHISPER"
      target = GetUnitName("player")
    end
    self:SendCommMessage(prefix, text, distribution, target, prio)
  end
end

-- ------------------------------------------------
-- UTILITY FUNCTIONS
-- ------------------------------------------------
function MultiTool:getAvailableQuestsTable()
  self:debugMsg("getAvailableQuestsTable()", "blather")
  -- use getQuestOptionsTable()  and GetGossipText(index) to build up a
  -- list of all currently available quest options and indexes,
  -- and return it

  local returnTable = {}

  local options = {C_GossipInfo.GetAvailableQuests()}
  self:debugMsg("  rawOptions: "..tostring(#options), "blather")
  for i=1, #options do
    self:debugMsg("    option: "..tostring(i).." - "..tostring(options[i]), "blather")
  end

  -- return from GetGossipAvailableQuests() is:
  --   title, Level, Trivial, so hop it in threes
  -- at some point when I wasn't looking, they changed it to
  --   name, level, isTrivial, frequency, isRepeatable, isLegendary, ... = GetGossipAvailableQuests()
  -- so instead of 3, we need to hop by 6 if we're jsut after names
  -- also fixing an issue where I was adding them to the table in a way that was ... bad
  self:debugMsg("  Building returnTable", "blather")
  for i = 1, #options, 6 do
    table.insert(returnTable, options[i])
    self:debugMsg("    added "..tostring(options[i]), "blather")
  end

  return returnTable

end


function MultiTool:findIndexOfText( targetTable, targetText)
  self:debugMsg("findIndexOfText()", "debug")
  self:debugMsg("  targetTable:"..tostring(targetTable), "debug")
  self:debugMsg("  targetText:"..tostring(targetText), "debug")

  local returnValue = nil

  if targetText ~= nil then
    for k,v in ipairs(targetTable) do
      if v == targetText then
        returnValue = k
        break
      end
    end
  end

  self:debugMsg("  returnValue:"..tostring(returnValue), "debug")
  return returnValue
end


function MultiTool:getGossipOptionsTable()
  self:debugMsg("getGossipOptionsTable()", "blather")
  -- use GetGossipOptions()  and GetGossipText(index) to build up a
  -- list of all currently available gossip options and indexes,
  -- and return it

  local returnTable = {}

  self:debugMsg("  numGossipOptins: "..tostring(GetNumGossipOptions()), "blather")


  local options = {GetGossipOptions()}
  for i = 1,GetNumGossipOptions() do
    returnTable[i] = options[i*2-1]
    self:debugMsg("    adding "..tostring(options[i*2-1]), "blather")
  end

  return returnTable

end

function MultiTool:helpCommand()
  self:Print("MultTool Help")
  self:Print("")
  self:Print("COMMANDS:")
  self:Print("  /MultiTool help - Show this help menu")
  self:Print("")
end

--
-- At some point, the GetActiveTitle(index) function stopped working
-- This is my replacement
--
function MultiTool:myGetActiveTitle( index )
	self:debugMsg("myGetActiveTitle()", "debug")
	local availbleQuestsTable = self:getAvailableQuestsTable()
	self:debugMsg("  #availableQuestsTable: "..#availbleQuestsTable, "debug")
    local questTitle = availbleQuestsTable[index]
    self:debugMsg("  questTitle: "..tostring(questTitle), "debug")
    return tostring(questTitle)
end

-- Theoretcially, isGuildMember = IsGuildMember( "name_of_inviter" )
-- would be what you want...  see-- https://warcraft.wiki.gg/wiki/API_IsGuildMember
-- However, it does not work as expected if you're not already in a party or raid
-- with the person inviting
-- since this addon needs to know ahead of time if you're in the same guild for some checks
-- this code is the workaround I wroge - see
-- see https://warcraft.wiki.gg/wiki/Talk:API_IsGuildMember
--
-- given a player name, it will check against the guild roster
-- returns false if player not in guild (or is offline if onlineOnly is true)
-- returns the index in the current roster if player is in guild
-- Most of the time what you really want is just IsGuildMemberByName("player_name_here")
function MultiTool:IsGuildMemberByName(playerName, onlineOnly)
	self:debugMsg("IsGuildMemberByName(playerName, onlineOnly) ...", "debug")
	self:debugMsg("  playerName: "..tostring(playerName), "debug")
	self:debugMsg("  onlineOnly: "..tostring(onlineOnly), "debug")

	-- first thing - am I in a guild
	-- if not we just return false
	local playerIsInGuild = IsInGuild()
	if (not playerIsInGuild) then
		self:debugMsg("  Player(self) is not in a guild returning false", "blather")
		return false
	else
		self:debugMsg("  Player(self) is in aguild returning false", "blather")
	end

	-- If we get to here we are in a guild
	-- get my own guild Info
	self:debugMsg("  Getting number in guild and online...", "blather")
	local numTotal, numOnline = GetNumGuildMembers()
	self:debugMsg("    numTotal: "..tostring(numTotal), "blather")
	self:debugMsg("    numOnline: "..tostring(numOnline), "blather")

	-- decide if we want to include all or just online members
	-- useful if we're doing an interactive check for something like
	-- someone just invited me, are they in my guild does not need to iterate
	-- a potentially large guild list
	local maxIndex = 0
	if (onlineOnly) then
		maxIndex = numOnline
		self:debugMsg("    Limited to Online Only: "..tostring(maxIndex), "blather")
	else
		maxIndex = numTotal
		self:debugMsg("    Using total guild count: "..tostring(maxIndex), "blather")
	end

	for index = 1, maxIndex do
		local name = GetGuildRosterInfo(index)
		self:debugMsg("  name: "..tostring(name), "blather")

		if (name == playerName) then
			self:debugMsg("  Match found - target player is in guild - returning true", "debug")
			return index
		else
			self:debugMsg("  No Match... checking next name", "blather")
		end
	end
	-- ultimate fallthrough if we had an error
	self:debugMsg("  No Match found.. returning false", "debug")
	return false
end

------------------
-- Sound handling
------------------

--
-- Plays a chosen sound from soundList by its MultiTool option
--
function MultiTool:soundCheck(key)
	self:debugMsg("soundCheck()", "debug")
	self:debugMsg("  key: "..tostring(key), "blather")
	-- need nil check to keep uglyness from happening
	if (key ~= nil) then
		self:playSoundByIndex(self.db.profile[key])
	end
end

--
-- Plays a chosen sound from soundList by its index (in soundList)
--
function MultiTool:playSoundByIndex(index)
	self:debugMsg("playSoundByIndex()", "debug")
	self:debugMsg("  index:"..tostring(index), "blather")
	-- check if USE DEFAULT
	if (index == #soundList) then
		self:debugMsg("  USE DEFAULT detected, altering choice...", "blather")
		-- alter the index to the default
		index = self.db.profile.defaultWarnSound
		self:debugMsg("    new index:"..tostring(index), "blather")
	end

	-- 1 will always be NONE, so only play if it's something else
	if (index > 1) then
		PlaySound(self:getSoundPathByIndex(index))
		self:debugMsg("Playing sound "..tostring(self:getSoundNameByIndex(index)), "blather")
	else
		self:debugMsg("  Not playing sound due to user selection", "blather")
	end
end

--
-- Returns the name of the item defined in soundList given the soundList index
--
function MultiTool:getSoundNameByIndex(index)
  return soundList[index].name
end

--
-- Returns the path of the item defined in soundList given the soundList index
--
function MultiTool:getSoundPathByIndex(index)
  return soundList[index].path
end

--
-- Wrapper for soundList to make the type of array needed by AceConfig select
--
-- NOTE: If passed any non-false value in skipDefault, then it removes the last
--       entry which should always be "USE DEFAULT". This is needed for the
--       config section of the default sound so it doesn't end up referring
--       to itself.
function MultiTool:getSoundSelectTable(skipDefault)
	self:debugMsg("getSoundSelectTable()", "debug")
	self:debugMsg("  skipDefault:"..tostring(skipDefault), "blather")

	local returnTable = {}
	-- turn the soundList into a flat table
	for k,v in ipairs(soundList) do
		--[[ -- not used
		self:debugMsg("adding to returnTable", "debug")
		self:debugMsg("  key: "..tostring(k), "debug")
		self:debugMsg("  val: "..tostring(v), "debug")
		self:debugMsg("  val.name: "..tostring(v.name), "debug")
		self:debugMsg("  val.path: "..tostring(v.path), "debug")
		]]
		table.insert(returnTable, k, v.name)
	end

	-- Handle removing the last entry (should always be "USE DEFAULT")
	if (skipDefault ~= nil and skipDefault ~= false) then
		self:debugMsg("  skipDefault set... removing index: "..tostring(#returnTable), "blather")
		-- we don't want the default sound to be able to use "USE DEFAULT"
		table.remove(returnTable, #returnTable)
	end

	-- Pass back the resulting table we created
	return returnTable
end


--
-- Takes a raw Amount of money (WOW always just passes costs in copper and
-- returns either formatted text "Xg Xs Xc" or three component values g,s,c
--
-- @param int rawAmount The amount of money (in copper) to parse
-- @param string outputType Controls the form of output (currently only text or default)
-- @return string  (if outputType == "text")
-- @return int,int,int  g,s,c  Values for Gold, Silver, and Copper respectively
function MultiTool:copperToCurrency(rawAmount, outputType)
	-- calculate amounts
	-- raw amount is copper - 1g = 10,000c, so just get raw/10,000 and discard remainder
	local g = math.floor( rawAmount / 10000 )
	-- raw amount is copper, 1s = 100 c... subtract g*10,000 copper and do division, discard remainder
	local s = math.floor( ( rawAmount - ( g * 10000 ) ) / 100 )
	-- by doing modulus of rawAmount and 100, we just get copper left
	local c = rawAmount % 100

	-- format return
	if (outputType == "text") then
		-- output will be string formatted as  Xg Xs Xc
		-- return tostring(g).."g "..tostring(s).."s "..tostring(c).."c"
		return string.format("%ug %us %uc", g,s,c)
	else
		-- three separate values returned by default... gold, silver, copper
		return g,s,c
	end
end


--
-- Debugging and console message handling
--
function MultiTool:debugMsg(text, level)
	if (level == nil) then
		return -- do nothing
	elseif (level == "error") then
		PlaySound("RauiWarning")
		UIErrorsFrame:AddMessage(text, 1.0, 0.5, 0.5, 5.0)
	elseif (level == "warn") then
		PlaySound(self:getSoundPathByIndex(self.db.profile.defaultWarnSound))
		UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0.5, 5.0)
	elseif (level == "notice") then
		self:Print(level..": "..text)
	elseif (level == "comm" and (self.db.profile.commFlag or self.db.profile.debugFlag or self.db.profile.blatherFlag)) then
		self:Print(level..": " ..text)
	elseif (level == "rpc" and (self.db.profile.commFlag or self.db.profile.debugFlag or self.db.profile.blatherFlag)) then
		self:Print(level..": " ..text)
	elseif (level == "debug" and (self.db.profile.debugFlag or self.db.profile.blatherFlag)) then
		self:Print(level..": "..text)
	elseif (level == "blather" and self.db.profile.blatherFlag) then
		self:Print(level..": "..text)
	end
end

--
-- Special debug overriding... 8.0.1.003 or something
--
function MultiTool:forceDebug(forceFlag, origLevel)
	if(forceFlag) then
		return "notice"
	else
		return origLevel
	end
end

function MultiTool:dumpTablee(t, indent)
	assert(type(t) == "table", "PrintTable() called for non-table!")

	local indentString = ""
	for i = 1, indent do
		indentString = indentString .. "  "
	end

	for k, v in pairs(t) do
		if type(v) ~= "table" then
			if type(v) == "string" then
				print(indentString, k, "=", v)
			end
		else
			print(indentString, k, "=")
			print(indentString, "  {")
			PrintTable(v, indent + 2)
			print(indentString, "  }")
		end
	end
end
