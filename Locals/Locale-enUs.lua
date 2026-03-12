--[[
MultiTool English language localization

Author: DigitalSorceress
Date: 2026/03/11
Version: 10.0.4.001
]]

-- Sets up the AceLocale for this addon with enUS as default localisation
local L = LibStub("AceLocale-3.0"):NewLocale("MultiTool", "enUS", true)

--------------------------------------------------------------------------------
-- Chat commands
--------------------------------------------------------------------------------
L["FULL_SLASH_CMD"] = "multitool"
L["SHORT_SLASH_CMD"] = "mtool"
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Debugging stuff
--------------------------------------------------------------------------------
L["DEBUG_OPTIONS_LABEL"] = "Debugging Options"

L["DEBUG_LABEL"] = "Show Debug Level"
L["DEBUG_DESC"] = "Toggles whether to output debugging messages or not."

L["BLATHER_LABEL"] = "Show Blather Level"
L["BLATHER_DESC"] = "Toggles whether to output massively chatty debugging messages or not."

L["COMM_LABEL"] = "Show Communications Debug"
L["COMM_DESC"] = "Toggles whether to output communication debug only."
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Sound Picker
--------------------------------------------------------------------------------
L["DEFAULT_SOUND_GROUP_LABEL"] = "Default Warning Sound"
L["DEFAULT_SOUND_GROUP_DESC"] = [[
This is the sound that will play by default when certain important events happen within MultiTool.

By default, any options with specific sounds will be set to use this sound as well, but may have overrides on their config pages.
]]

L["PICK_SOUND_LABEL"] = "Pick a Sound"
L["PICK_SOUND_DESC"] = "Choose a sound to accompany this option."
L["PICK_SOUND_TEST"] = "Test Chosen Sound"
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Dueling
--------------------------------------------------------------------------------
L["DUEL_GROUP_LABEL"] = "Duel Request Handling"
L["DUEL_GROUP_DESC"] = [[
Unsolicited duel requests annoy a LOT of people. So much so that several have downloaded this addon becuase of the auto duel reject feature.

This section has options for auto cancelling duels and for NOT auto cancelling duel requests from those on your friends list.
]]

L["DUEL_LABEL"] = "Auto Cancel Duels"
L["DUEL_DESC"] = "Toggles whether to automatically cancel all incoming duel requests."

L["DUEL_ACCEPT_LABEL"] = "Allow White List"
L["DUEL_ACCEPT_DESC"] = "Toggles whether to allow duel requests from those on your white list."
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Following
--------------------------------------------------------------------------------
L["FOLLOW_GROUP_LABEL"] = "AutoFollow Handling"
L["FOLLOW_GROUP_DESC"] = [[
Configuration options for the handling of auto follow
]]

L["FOLLOW_WARN_LABEL"] = "Warn On Follow Lost"
L["FOLLOW_WARN_DESC"] = "Toggles whether to warn when someone on autofollow stops/loses following"

L["FOLLOW_WARN_WHITELIST_LABEL"] = "Only For Whitelist"
L["FOLLOW_WARN_WHITELIST_DESC"] = [[
Toggles whether to restrict warnings of lost autofollow to those in your whiteList
]]

L["FOLLOW_WARN_MSG"] = "%s has stopped following you"

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
-- Resurrection
--------------------------------------------------------------------------------
L["RESURRECT_GROUP_LABEL"] = "Auto Accept Resurrection"
L["RESURRECT_GROUP_DESC"] = [[
Options for configuring the auto accept resurrection feature

Be careful about having this on if you are in a raid group. Immediately accepting a battle rez in the wrong place during Thaddius could be deadly.
]]

L["RESURRECT_LABEL"] = "Accept Resurrection"
L["RESURRECT_DESC"] = "Toggles whether to automatically accept resurrections."

L["RESURRECT_WHITELIST_LABEL"] = "Only For White List"
L["RESURRECT_WHITELIST_DESC"] = "Toggles whether to ONLY auto accept from those on your white list."

L["RESURRECT_WARN_MSG"] = "Accepting Resurrection from %s"
--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
-- Inventory
--------------------------------------------------------------------------------
L["INVENTORY_OPTIONS_LABEL"] = "Merchant and Bags"

------------
-- Merchant
------------

-- Auto VEND
L["VENDOR_GROUP_LABEL"] = "Merchant Auto Sell Options"

L["VEND_JUNK_LABEL"] = "Auto Sell Junk"
L["VEND_JUNK_DESC"] = "Toggle this to have your toon automatically sell all gray items (poor quality junk) to vendors. (note: this is not at all discriminating to its defaulted to off)"


-- Auto REPAIR
L["REPAIR_GROUP_LABEL"] = "Automatic Repair at Vendor"
L["REPAIR_GROUP_DESC"] = [[
Enable the auto repair to have your toon automatically repair whenever you open a vendor dialog with a vendor who has the repair capability. 

You can choose whether and how the repair activity is announced with the warning options.
]]

L["REPAIR_FLAG_LABEL"] = "Auto Repair"
L["REPAIR_FLAG_DESC"] = "Toggle this to have your toon automatically repair all when at repair-enabled vendor."

L["REPAIR_GUILD_FLAG_LABEL"] = "Use Guild Funds"
L["REPAIR_GUILD_FLAG_DESC"] = "Toggle this to have your toon try to use guild funds when it auto repairs."

L["REPAIR_WARN_LABEL"] = "Announce Repairs"
L["REPAIR_WARN_DESC"] = "Toggle this to enable/disable announcement of your repairs... use the included options for self/group and associated sound"

L["REPAIR_WHISPER_FLAG_LABEL"] = "Self Only"
L["REPAIR_WHISPER_FLAG_DESC"] = "Only report on your own repairs... ignore incoming and do not send repair status messages"

-- where first %s is repairee's name and second %s is a formatted string of the gold amount
L["REPAIR_WARN_MSG"] = "AUTO REPAIR NOTICE: %s's repair bill: %s\n( use guild funds: %s )"

-----------
-- Trading
-----------
L["TRADE_GROUP_LABEL"] = "Trading Transactions (Not yet implemented)"

L["TRADE_LABEL"] = "Auto Accept Trade"
L["TRADE_DESC"] = "Toggle this to have your toon automatically accept trades from those on your white list."


------------------
-- Bag Monitoring
------------------
L["BAG_MONITOR_LABEL"] = "Bag Space Monitoring"
L["BAG_MONITOR_DESC"] = [[
When enabled, Bag Space Monitoring provides an on-screen warning message when your bags are full or only have a number of slots remaining.

This number of slots is controlled by the Bag Space Warning Threshold.

This feature is still in development.
]]

L["BAG_FLAG_LABEL"] = "Enable Monitoring"
L["BAG_FLAG_DESC"] = "Toggles monitoring / warning of bag space of group users with MultiTool."

L["BAG_WHISPER_FLAG_LABEL"] = "Self Only"
L["BAG_WHISPER_FLAG_DESC"] = "Only report on your own bag space... ignore incoming and do not send bag status messages"


L["BAG_WARN_LABEL"] = "Bag Space Warning Threshold"
L["BAG_WARN_DESC"] = "Number of free slots left before displaying warning"

-- where %s will be sender and %u will be number of slots
L["BAG_WARN_MSG"] = "BAG SPACE WARNING: %s has %u bag slots left"
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Party / Group
--------------------------------------------------------------------------------
L["PARTY_OPTIONS_LABEL"] = "Party-related Options"
L["PARTY_OPTIONS_DESC"] = "Options relating to party activities (accepting groups, summonses, etc)"

L["PARTY_GROUP_LABEL"] = "Group Accept Options"
L["PARTY_GROUP_DESC"] = "Options for auto accept / reject group invites"

L["PARTY_AUTOACCEPT_LABEL"] = "Auto Accept Group"
L["PARTY_AUTOACCEPT_DESC"] = "Toggle this to have your toon automatically accept group invites from others on your white list"

L["PARTY_GUILD_LABEL"] = "Accept From My Guild"
L["PARTY_GUILD_DESC"] = "Override to always auto accept invites from guild mates"

L["PARTY_BNET_LABEL"] = "Accept From BNet Friend"
L["PARTY_BNET_DESC"] = "Override to always auto accept invites from Battlenet Friends"

L["PARTY_BNET_FAVE_LABEL"] = "Only if Bnet Favorite"
L["PARTY_BNET_FAVE_DESC"] = "Only apply the Battlenet Accept Override to Battlnenet Favorites"

L["PARTY_GROUP_REJECT_LABEL"] = "Reject Strangers"
L["PARTY_GROUP_REJECT_DESC"] = "Toggle this to have your toon automatically reject group invites from others NOT on your white list"


--------
-- Taxi
--------
L["TAXI_GROUP_LABEL"] = "Taxi (Flight Path) Options"
L["TAXI_GROUP_DESC"] = [[
Options relating to automatically following others in group when they take a flight path.

For this to work, all toons planning on riding must have a flight master dialog open. They can be at different flight masters from one another, but this will only work if they have the appropriate connecting paths to make the chosen destination valid (they also have to be on the same continent).
]]

L["TAXI_LABEL"] = "Auto Flight Path"
L["TAXI_DESC"] = "Toggles whether or not to try to follow the flight path taken by others in the party with MultiTool."

L["TAXI_WHITE_LIST_ONLY_LABEL"] = "Only For White List"
L["TAXI_WHITE_LIST_ONLY_DESC"] = "Only follow requests coming from those in your white list"


L["TAXI_CANT_FOLLOW"] = "Unable to take taxi to %s ... \nDo you have that flight point?"
L["TAXI_NO_FLIGHTMASTER"] = "TAKETAXI: Unable to take taxi... not at flight master"


----------
-- summon
----------
L["SUMMON_GROUP_LABEL"] = "Summons Accept Options"
L["SUMMON_GROUP_DESC"] = "Options for auto accept / reject summons. (Warlock and Summoning stone)"

L["SUMMON_LABEL"] = "Auto Accept Summons"
L["SUMMON_DESC"] = "Automatically accept summonses."

L["SUMMON_WHITE_LIST_ONLY_LABEL"] = "Only For White List"
L["SUMMON_WHITE_LIST_ONLY_DESC"] = "Only auto-accept summonses from those in your white list"

L["SUMMON_WARN_MSG"] = "ALERT: Auto Accepted Summons to %s from %s"

L["MAIN_DESCRIPTION"] = [[
MultiTool is a collection of small utilities that were designed with the Multi Boxer in mind, but are also useful for friends who quest together regularly.

There are options for automatically cancelling duels (because many find duel spam to be very annoying), automatic repair, automatic selling of gray junk from your inventory, and more.
]]
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Questing
--------------------------------------------------------------------------------
L["QUEST_OPTIONS_LABEL"] = "Quest Options"

----------------
-- Quest Gossip
----------------

L["QUEST_GOSSIP_GROUP_LABEL"] = "Quest Gossip Cloning"
L["QUEST_GOSSIP_GROUP_DESC"] = "MultiTool can copy 'quest gossip' from one toon to another.\n\nIf all toons in the party open the same quest dialog at the same time, actions taken by one will be followed by all.\n\nCopying rewards is a separate option which must be individually enabled so that folks can choose their own rewards rather than do what everyone else does."

L["GOSSIP_LABEL"] = "Quest Gossip Broadcast"
L["GOSSIP_DESC"] = "Toggles whether or not to share quest gossip choices with others in the party with MultiTool"

L["REWARD_CLONE_LABEL"] = "Clone Reward Choices"
L["REWARD_CLONE_DESC"] = "Toggles whether or not quest gossip broadcast clones your reward choices. (Must also have gossip broadcast on to work)"


----------------------
-- Auto Accept Escort
----------------------
L["ESCORT_GROUP_LABEL"] = "Escort Quest Handling"

L["ESCORT_FLAG_LABEL"] = "Auto Accept Escort Quests"
L["ESCORT_FLAG_DESC"] = "Toggles whether or not you will automatically accept escort quests started by another in the group. (no whitelist restriction)"
L["ESCORT_WARN_MSG"] = "ALERT: You have auto Accepted %s (started by $s)"

------------------------
-- Quest Log Monitoring
------------------------
L["QUEST_LOG_MONITOR_LABEL"] = "Quest Log Monitoring"
L["QUEST_LOG_MONITOR_DESC"] = [[
When enabled, Quest Log Monitoring provides an on-screen warning message when the quest log is full or only has a number of slots remaining.
]]

L["QUEST_LOG_FLAG_LABEL"] = "Enable Monitoring"
L["QUEST_LOG_FLAG_DESC"] = "Toggles monitoring / warning of quest log fullness of group users with MultiTool."

L["QUEST_LOG_WHISPER_FLAG_LABEL"] = "Self Only"
L["QUEST_LOG_WHISPER_FLAG_DESC"] = "Toggles whether to report to self only or to all in group with MultiTool"

L["QUEST_LOG_WARN_LABEL"] = "Quest Log Warning Threshold"
L["QUEST_LOG_WARN_DESC"] = "Number of free quest log slots left before displaying warning"

-- where %s will be sender and %u will be number of slots
L["QUEST_LOG_WARN_MSG"] = "QUEST LOG WARNING: %s has %u free quest slots"
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- White List
--------------------------------------------------------------------------------
L["WHITE_LIST_OPTIONS_LABEL"] = "White List Setup"
L["WHITE_LIST_OPTIONS_DESC"] = [[
The White List is like the in-game friends list, but specific to MultiTool. Used to limit certain security-sensitive actions to specific players

It is not possible to check for the existence of a player unless they are online, and in the interest of making this as efficient as possible, no checks are done against the entered names. This means that you really want to be sure to type the exact name of each character you want to appear in your white list.
]]

L["WHITE_LIST_VIEW_GROUP_LABEL"] = "Current White List"

L["WHITE_LIST_ADD_PLAYER_GROUP_LABEL"] = "Add Players"

L["WHITE_LIST_ADD_LABEL"] = "Type Player Name"
L["WHITE_LIST_ADD_DESC"] = "Enter a single EXACT player name to be added to the white list"

L["WHITE_LIST_SELECT_LABEL"] = "White List"
L["WHITE_LIST_SELECT_DESC"] = "Select ACTIVE players for your white list."


L["WHITE_LIST_DELETE_GROUP_LABEL"] = "Remove Players"

L["WHITE_LIST_DELETE_SELECT_LABEL"] = "Player to Delete"
L["WHITE_LIST_DELETE_SELECT_DESC"] = "Select a member of your white list to delete and click the Delete button"

L["WHITE_LIST_DELETE_ACTION_LABEL"] = "Delete"
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- fnord
--------------------------------------------------------------------------------
L["FNORD"] = "fnord"
--------------------------------------------------------------------------------

