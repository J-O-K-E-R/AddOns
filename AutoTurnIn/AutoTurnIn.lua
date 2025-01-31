--[[
Feel free to use this source code for any purpose ( except developing nuclear weapon! :)
Please keep original author statement.
@author Alex Shubert (alex.shubert@gmail.com)
]]--
local addonName, ptable = ...
local L, C = ptable.L, ptable.CONST
local Q_DAILY, Q_EXCEPTDAILY = 2, 3
local questNPCName = nil

AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")

-- TODO: REFACTOR INTO A SINGLE 'OPTION' OBJECT
AutoTurnIn.ldb, AutoTurnIn.allowed = nil, nil
AutoTurnIn.funcList = {[1] = function() return false end, [2]=IsAltKeyDown, [3]=IsControlKeyDown, [4]=IsShiftKeyDown}
AutoTurnIn.autoEquipList={}
AutoTurnIn.questCache={}	-- daily quest cache. Initially is built from player's quest log
AutoTurnIn.knownGossips={}
AutoTurnIn.ERRORVALUE = nil
AutoTurnIn.IgnoreButton = {["quest"] = nil, ["gossip"] = nil}

--[[
	INIT: INITIALIZE
--]]
local db
local defaults = CopyTable(ptable.defaults)
local function makeWeaponToggle(index, _order)
	return {
		type = "toggle",
		name = C.weapon[index],
		arg = ("weapon;".. C.weapon[index]),
		order = _order,
	}
end
local function createToggle(_name, _arg, _order)
	return {
		type = "toggle",
		name = _name,
		arg = _arg,
		order = _order,
	}
end
local options = {
	type = "group",
	name = "AutoTurnIn",
	desc = C_AddOns.GetAddOnMetadata(addonName, "Notes-" .. GetLocale()) or C_AddOns.GetAddOnMetadata(addonName, "Notes"),
	args = {
		enabled = {
			type = "toggle",
			name = L["enabled"].." (version "..C_AddOns.GetAddOnMetadata(addonName, "Version") .. ")",
			desc = L["usage1"],
			order = 1,
			width  = 1.5,
			get = function(_) return db.enabled end,
			set = function(_, v)
				db.enabled = v
				AutoTurnIn:SetEnabled(v)
			end,
			disabled = false,
		},
		debug = {
			type = "toggle",
			name = L["debug"],
			arg = "debug",
			width  = "double",
			order = 2,
			hidden = function() return not db.admin end,
			get = function(_) return db.debug end,
			set = function(_, v) db.debug = v end,
		},
		overall_settings = {
			type = "group",
			name = L["global settings"],
			order = 10,
			disabled = function() return not db.enabled end,
			get = function(info) return db[info.arg] end,
			set = function(info, v) db[info.arg] = v end,
			args = {
				q_title = {
					type = "header",
					name = "General Settings",
					order = 1
				},
				QuestDropDown = {
					type = "select",
					style  = "dropdown",
					name = L["questTypeLabel"],
					values =  {[1] = L["questTypeAll"], [2]=L["questTypeList"],[3]=L["questTypeExceptDaily"]},
					arg = "all",
					width  = "double",
					order = 10,
				},
				trivial = {
					type = "toggle",
					name = L["TrivialQuests"],
					arg = "trivial",
					width  = "double",
					order = 20,
				},
				completeonly = {
					type = "toggle",
					name = L["CompleteOnly"],
					arg = "completeonly",
					width  = "double",
					order = 30,
				},
				ToggleKeyDropDown = {
					type = "select",
					style  = "dropdown",
					name = L["togglekey"],
					values = {[1]=NONE_KEY, [2]=ALT_KEY, [3]=CTRL_KEY, [4]=SHIFT_KEY},
					arg = "togglekey",
					width  = "double",
					order = 40,
				},
				reward_title = {
					type = "header",
					name = "Rewards",
					order = 45
				},
				LootDropDown = {
					type = "select",
					style  = "dropdown",
					name = L["lootTypeLabel"],
					values = {[1]=L["lootTypeFalse"], [2]=L["lootTypeGreed"], [3]=L["lootTypeNeed"]},
					arg = "lootreward",
					width  = "double",
					order = 50,
				},
				rewardtext = {
					type = "toggle",
					name = L["rewardtext"],
					arg = "showrewardtext",
					width  = "full",
					order = 60,
				},
				autoequip = {
					type = "toggle",
					name = L["autoequip"],
					arg = "autoequip",
					order = 70,
				},
				TournamentDropDown = {
					type = "select",
					style  = "dropdown",
					name = L["tournamentLabel"],
					values = {[1]=L["tournamentWrit"], [2]=L["tournamentPurse"]},
					arg = "tournament",
					width  = "double",
					order = 80,
				},
				gossip_opts = {
					type = "group",
					name = "Gossips",
					desc = "Gossip options",
					order = 100,
					args = {
						darkmoon_title = {
							type = "header",
							name = "Darkmoon",
							order = 1
						},
						todarkmoon = {
							type = "toggle",
							name = L["ToDarkmoonLabel"],
							arg = "todarkmoon",
							width  = "full",
							order = 140,
						},
						darkmoonteleport = {
							type = "toggle",
							name = L["DarkmoonTeleLabel"],
							arg = "darkmoonteleport",
							width  = "full",
							order = 150,
						},
						darkmoonautostart = {
							type = "toggle",
							name = L["DarkmoonAutoLabel"],
							arg = "darkmoonautostart",
							width  = "full",
							order = 160,
						},
						batllepets_title = {
							type = "header",
							name = "Battle pets",
							order = 165
						},
						reviveBattlePet = {
							type = "toggle",
							name = L["ReviveBattlePetLabel"],
							arg = "reviveBattlePet",
							width  = "full",
							order = 170,
						},
						shadowlands_title = {
							type = "header",
							name = "Shadowlands",
							order = 175
						},
						dismisskyriansteward = {
							type = "toggle",
							name = L["DismissKyrianStewardLabel"],
							arg = "dismisskyriansteward",
							width  = "full",
							order = 180,
						},
						covenantswapgossipcompletion = {
							type = "toggle",
							name = L["CovenantSwapGossipCompletion"],
							arg = "covenantswapgossipcompletion",
							width  = "full",
							order = 190,
						},
					}
				},
				ui_opts = {
					type = "group",
					name = "UI addons",
					desc = "UI tweaks",
					order = 120,
					args = {
						questlevel = {
							type = "toggle",
							name = L["questlevel"],
							arg = "questlevel",
							width  = "full",
							order = 10,
						},
						watchlevel = {
							type = "toggle",
							name = L["watchlevel"],
							arg = "watchlevel",
							width  = "full",
							order = 20,
							confirm = function() return "This thing taints the UI. Use on your own risk" end,
						},
						questshare = {
							type = "toggle",
							name = L["ShareQuestsLabel"],
							arg = "questshare",
							width  = "full",
							order = 30,
						},
						sell_junk = {
							type = "select",
							name = "Sell junk functionality",
							values = {[1]=L["Don't do anything"], [2]=L["Autosell junk"], [3]=L["Add sell button"]},
							width  = "full",
							get = function(info) return db[info.arg] end,
							set = function(info, v) AutoTurnIn:SwitchSellJunk(v); db[info.arg] = v end,
							arg = "sell_junk",
							order = 40,
						},
						auto_repair = {
							type = "toggle",
							name = "Auto repair",
							width  = "full",
							arg = "auto_repair",
							order = 50,
						},
						skip_cinematics = {
							type = "select",
							name = "Skip cinematics",
							values = {[1]=L["Do not skip"], [2]=L["Skip in instances only"], [3]=L["Skip everywhere"]},
							width  = "full",
							arg = "skip_cinematics",
							order = 60,
						},
						skip_movies = {
							type = "select",
							name = "Skip movies",
							values = {[1]=L["Do not skip"], [2]=L["Skip in instances only"], [3]=L["Skip everywhere"]},
							width  = "full",
							arg = "skip_movies",
							order = 60,
						},
						map_coords = {
							type = "toggle",
							name = "Display player coordinates on world map",
							arg = "map_coords",
							width  = "full",
							get = function(info) return db[info.arg] end,
							set = function(info, v) AutoTurnIn:SwitchMapCoords(v); db[info.arg] = v end,
							order = 70,
						},
						-- unsafe_item_wipe = {
						-- 	type = "toggle",
						-- 	name = "Wipe item in the bag by ALT + Click",
						-- 	arg = "unsafe_item_wipe",
						-- 	confirm = function() return "Wiping ANY item in your bag if clicked with ALT key pressed" end,
						-- 	width  = "full",
						-- 	order = 200,
						-- },
					}
				},
				relic_opts = {
					type = "group",
					name = "Relic/Artifact",
					order = 130,
					args = {
						relictoggle = {
							type = "toggle",
							name = L["relictoggle"],
							arg = "relictoggle",
							width  = "full",
							order = 130,
						},
						artifactpowertoggle = {
							type = "toggle",
							name = L["artifactpowertoggle"],
							arg = "artifactpowertoggle",
							width  = "full",
							order = 140,
						}
					}
				},
				rewards = {
					type = "group",
					name = "Rewards",
					desc = L["rewardlootoptions"],
					order = 2000,
					hidden  = function() return db.lootreward~=3 end,
					get = function(info) local t,st = strsplit(";", info.arg) local v = db[t][st] return v == nil and false or v end,
					set = function(info, v) local t,st = strsplit(";", info.arg) db[t][st] = (v or nil) end,
					args = {
						greedifnothing = {
							type = "toggle",
							name = L["greedifnothing"],
							get = function(info) return db.greedifnothingfound end,
							set = function(info,val) db.greedifnothingfound = val end,
							order = 10,
						},
						weapon_title = {
							type = "header",
							name = C.WEAPONLABEL,
							order = 20
						},
						wp1 = makeWeaponToggle(0, 30),
						wp2 = makeWeaponToggle(1, 31),
						wp3 = makeWeaponToggle(4, 32),
						wp4 = makeWeaponToggle(5, 33),
						
						wp7 = makeWeaponToggle(7, 34),
						wp6 = makeWeaponToggle(8, 35),
						wp5 = makeWeaponToggle(6, 36),						
						wp8 = makeWeaponToggle(9, 37),
						
						wp10 = makeWeaponToggle(10, 39),
						wp11 = makeWeaponToggle(15, 40),
						-- TODO INVTYPE_RANGED
						wp13 = createToggle(string.format("%s, %s, %s", C.weapon[2], C.weapon[3], C.weapon[18]), "weapon;Ranged", 42),
						armor_title = {
							type = "header",
							name = C.ARMORLABEL,
							order = 50
						},
						armor_reward = {
							type = "select",
							style  = "dropdown",
							name = "",
							values =  {[-1] = NONE_KEY, [1]=C.armor[1], [2]=C.armor[2], [3]=C.armor[3], [4]=C.armor[4]},
							get = function() return db["armorType"] end,
							set = function(_, v) db["armorType"] = v end,
							width  = "double",
							order = 60,
						},
						armor7 = createToggle(C.armor[6], "armor;SHIELD", 61),
						armor8 = createToggle(L['Jewelry'], "armor;Jewelry", 62),
						armor9 = createToggle(INVTYPE_HOLDABLE, "armor;HOLDABLE", 63),
						armor10 = createToggle(INVTYPE_CLOAK, "armor;CLOAK", 64),
						-- STATS 
						stat_title = {
							type = "header",
							name = STAT_CATEGORY_ATTRIBUTES,
							order = 70
						},
						stat1 = createToggle(SPELL_STAT1_NAME, "stat;ITEM_MOD_STRENGTH_SHORT", 71),
						stat2 = createToggle(SPELL_STAT2_NAME, "stat;ITEM_MOD_AGILITY_SHORT", 72),
						stat3 = createToggle(SPELL_STAT4_NAME, "stat;ITEM_MOD_INTELLECT_SHORT", 73),
						sec_stat_title = {
							type = "header",
							name = STAT_CATEGORY_ENHANCEMENTS,
							order = 80
						},
						secstat1 = createToggle(ITEM_MOD_CRIT_RATING_SHORT, "secondary;ITEM_MOD_CRIT_RATING_SHORT", 81),
						secstat2 = createToggle(ITEM_MOD_CR_LIFESTEAL_SHORT, "secondary;ITEM_MOD_CR_LIFESTEAL_SHORT", 82),
						secstat3 = createToggle(ITEM_MOD_HASTE_RATING_SHORT, "secondary;ITEM_MOD_HASTE_RATING_SHORT", 83),
						secstat4 = createToggle(ITEM_MOD_CR_MULTISTRIKE_SHORT, "secondary;ITEM_MOD_CR_MULTISTRIKE_SHORT", 84),
						secstat5 = createToggle(ITEM_MOD_MASTERY_RATING_SHORT, "secondary;ITEM_MOD_MASTERY_RATING_SHORT", 85),
						secstat6 = createToggle(ITEM_MOD_VERSATILITY, "secondary;ITEM_MOD_VERSATILITY", 86),
						secstat7 = createToggle(ITEM_MOD_SPELL_POWER_SHORT, "secondary;ITEM_MOD_SPELL_POWER_SHORT", 85),
						-- secstat8 = createToggle(ITEM_MOD_SPIRIT_SHORT, "secondary;ITEM_MOD_SPIRIT_SHORT", 86),
					},
				},
			}
		},
	},
}


-- Option DB https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial
-- Option GUI https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
function AutoTurnIn:OnInitialize()
	-- set up options db
	self.db = LibStub("AceDB-3.0"):New("AutoTurnInDB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("AutoTurnIn", options)
	_, self.optionCategory =  LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoTurnIn", "AutoTurnIn")
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self:RegisterChatCommand("au", "ShowOptions")
	self:LibDataStructure()

	self:CinematickHooks()
	-- See no way tp fix taint issues with quest special items.
	-- TODO : THE WAR WITHIN HAS BROKEN BOTH THINGS
	-- hooksecurefunc("ObjectiveTracker_Update", AutoTurnIn.ShowQuestLevelInWatchFrame)
	-- hooksecurefunc("QuestLogQuests_Update", AutoTurnIn.ShowQuestLevelInLog)
end

function AutoTurnIn:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
end

-- reuse :Enable() / :Disable() ?  https://www.wowace.com/projects/ace3/pages/api/ace-addon-3-0
function AutoTurnIn:SetEnabled(enabled)
	db.enabled = not not enabled

	if self.ldb then
		self.ldb.text = (db.enabled) and '|cff00ff00on|r' or '|cffff0000off|r'
	end

	if (db.enabled) then
		self:SwitchMapCoords(db.enabled and db.map_coords)
		self:SwitchSellJunk(db.enabled and db.sell_junk)
		self:RegisterForEvents()
	else
		self:UnregisterAllEvents()
	end
end

--[[
	INIT: ENABLE quest autocomplete handlers and functions
--]]
function AutoTurnIn:OnEnable()
	self:SetEnabled(db.enabled)
end

-- actually never called, but still
function AutoTurnIn:OnDisable()
	db.enabled = false	
	self:SetEnabled(db.enabled)
end

--[[
	INIT: Register for events
--]]
function AutoTurnIn:RegisterForEvents()
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("QUEST_LOG_UPDATE")
	self:RegisterEvent("QUEST_ACCEPTED")
	if db.reviveBattlePet --[[ and select(2, UnitClass("player")) == "HUNTER" ]] then
		self:RegisterEvent("GOSSIP_CONFIRM")
	end

	self:RegisterGossipOptionClicker()
end

function AutoTurnIn:RegisterGossipOptionClicker()
	local function __getGossipId(index)
		-- SOmetimes quest comletition removes the options. SelectOption does not throws exception on unavailable index
		return #C_GossipInfo.GetOptions() > 0 and C_GossipInfo.GetOptions()[index].gossipOptionID or -1
	end
	local gossipFunc1 = function()
		C_GossipInfo.SelectOption( __getGossipId(1) )
	end
	local gossipFunc2 = function()
		if (C_GossipInfo.GetNumOptions and C_GossipInfo.GetNumOptions() == 2) then C_GossipInfo.SelectOption(__getGossipId(1)) end
	end
	local gossipFunc3 = function()
		if (db.todarkmoon and GetRealZoneText() ~= L["Darkmoon Island"] and C_GossipInfo.GetNumAvailableQuests() == 0) then
			--accept available quest first, then teleport
			AutoTurnIn:Print("Teleporting to " .. L["Darkmoon Island"])
			C_GossipInfo.SelectOption(__getGossipId(1))
			StaticPopup1Button1:Click()
		end
	end
	local gossipFunc4 = function()
		if db.darkmoonteleport then
			AutoTurnIn:Print("Teleporting to cannon")
			C_GossipInfo.SelectOption(__getGossipId(1))
			StaticPopup1Button1:Click()
		end
	end
	local gossipFunc5 = function()
		if db.dismisskyriansteward then
			AutoTurnIn:Print(L["ivechosenfive"])
			C_GossipInfo.SelectOption(__getGossipId(5))
		end
	end
	local gossipFunc6 = function()
		if db.covenantswapgossipcompletion then
			C_GossipInfo.SelectOption(__getGossipId(1))
			C_GossipInfo.SelectOption(__getGossipId(1))
			StaticPopup1Button1:Click()
		end
	end
	AutoTurnIn.knownGossips = {
		["171787"]=gossipFunc6, -- Polemarch Adrestes (Kyrian)
		["171795"]=gossipFunc6, -- Lady Moonberry (Night Fae)
		["171589"]=gossipFunc6, -- General Draven (Venthyr)
		["171821"]=gossipFunc6, -- Secutor Mevix (Necrolord)
		["93188"]=gossipFunc1, -- Mongar
		["96782"]=gossipFunc1, -- Lucian Trias
		["97004"]=gossipFunc1, -- "Red" Jack Findle
		["55267"]=gossipFunc1, -- YoungPandaren
		["79815"]=gossipFunc2, -- Grunlek, free seals Alliance
		["77377"]=gossipFunc2, -- Kristen Stoneforge, free seals Horde
		["54334"]=gossipFunc3, -- travel to Darkmoon
		["55382"]=gossipFunc3, -- travel to Darkmoon
		["57850"]=gossipFunc4, -- DarkmoonFaireTeleportologist
		["166663"]=gossipFunc5, -- Kyrian Steward
		["20142"]=gossipFunc1, -- Caverns of Time:Steward of Time
		["42391"]=gossipFunc1, -- West Plains Drifter [Lieutenant Horatio Laine]
		["42384"]=gossipFunc1, -- Homeless Stormwind [Lieutenant Horatio Laine]
		["42383"]=gossipFunc1, -- Transient [Lieutenant Horatio Laine]
	}
end

function AutoTurnIn:QUEST_LOG_UPDATE()
	if ( C_QuestLog.GetNumQuestLogEntries() > 0 ) then
		for index=1, C_QuestLog.GetNumQuestLogEntries() do
			local questInfo = C_QuestLog.GetInfo(index)			
			if (questInfo and not questInfo.isHeader and self:_isDaily(questInfo)) then
				self.questCache[questInfo.title] = true
			end
		end
		self:UnregisterEvent("QUEST_LOG_UPDATE")
	end
end

function AutoTurnIn:_isDaily(questInfo)
	return questInfo and
	(questInfo.frequency == Enum.QuestFrequency.Daily or
		questInfo.frequency == Enum.QuestFrequency.Weekly or
		questInfo.repeatable)
end

-- Available check requires cache
-- Active check query API function Returns true if quest matches options
function AutoTurnIn:isAppropriateQuest(questname, byCache)
    local daily
    if byCache then
        daily = (not not self.questCache[questname])
    else
    	-- for some reason questInfo in gossip table return data different from one from QuestCache
    	local questID = GetQuestID()
    	local qn = questname or (questID and QuestCache:Get(questID).title or "");
        daily = QuestIsDaily() or QuestIsWeekly() or (not not self.questCache[qn])
    end

    return self:_isAppropriate(daily)
end

-- 'private' function
function AutoTurnIn:_isAppropriate(daily)
    if daily then
        return (db.all ~= Q_EXCEPTDAILY)
    else
        return (db.all ~= Q_DAILY)
    end
end

-- caches offered by gossip quest as daily
function AutoTurnIn:CacheAsDaily(questname)
	self.questCache[questname] = true
end

function AutoTurnIn:IsIgnoredQuest(quest, questId)
	local function startsWith(str,template)
		return (string.len(str) >= string.len(template)) and (string.sub(str,1,string.len(template))==template)
	end

	if db.IGNORED_QUEST[questId] then return true end

	for q in pairs(L.ignoreList) do
		if (startsWith(quest, q)) then
			return true
		end
	end

	return false
end

-- returns specified item count on player character. It may be some sort of currency or present in inventory as real items.
function AutoTurnIn:GetItemAmount(isCurrency, item)
	local amount = isCurrency and C_CurrencyInfo.GetCurrencyInfo(item).quantity or GetItemCount(item, nil, true)
	return amount and amount or 0
end

-- returns set 'self.allowed' to true if addon is allowed to handle current gossip conversation
-- Cases when it may not : (addon is enabled and toggle key was pressed) or (addon is disabled and toggle key is not pressed)
-- 'forcecheck' does what it name says: forces check
function AutoTurnIn:AllowedToHandle(forcecheck)
	-- workaround for https://zygorguides.com/forum/forum/technical-support/zygor-guide-viewer/190851-new-lua-error-addon_action-blocked
	-- Currently, blizzard UI fails to properly check in-combat. This is to enforce the checks (hopefully)
	-- TODO: it is not clear why would I need global "self.allowed"
	if ( InCombatLockdown() ) then
		return false
	end

	if ( self.allowed == nil or forcecheck ) then
		-- Double 'not' converts possible 'nil' to boolean representation
		local IsModifiedClick = not not self.funcList[db.togglekey]()
		-- it's a simple xor implementation (a ~= b)
		self.allowed = (not not db.enabled) ~= (IsModifiedClick)
	end
	return self.allowed and (not AutoTurnIn:IsIgnoredNPC())
end

-- Old 'Quest NPC' interaction system. See http://wowprogramming.com/docs/events/QUEST_GREETING
function AutoTurnIn:QUEST_GREETING()
	if (not self:AllowedToHandle(true)) then
		return
	end

	for index=1, GetNumActiveQuests() do
		local quest, isComplete = GetActiveTitle(index)
		if isComplete and (self:isAppropriateQuest(quest, true)) then
			SelectActiveQuest(index)
		end
	end

    if not db.completeonly then
        for index=1, GetNumAvailableQuests() do
            local isTrivial, isDaily, isRepeatable, isIgnored = GetAvailableQuestInfo(index)
			if (isIgnored) then return end -- Legion functionality
			
            local triviaAndAllowedOrNotTrivia = (not isTrivial) or db.trivial
            local title = GetAvailableTitle(index)
            local quest = L.quests[title]
            local notBlackListed = not (quest and (quest.donotaccept or AutoTurnIn:IsIgnoredQuest(title, nil)))

			-- isDaily was a boolean, but is a number now. but maybe it's still a boolean somewhere
			if (type(isDaily) == "number" and isDaily ~= 0) then isDaily = true else isDaily = false end
			
            if isDaily then
                self:CacheAsDaily(GetAvailableTitle(index))
            end
			
            if (triviaAndAllowedOrNotTrivia and notBlackListed and self:_isAppropriate(isDaily)) then
                if quest and quest.amount then
                    if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
                        SelectAvailableQuest(index)
                    end
                else
                    SelectAvailableQuest(index)
                end
            end
        end
    end
end

function AutoTurnIn:VarArgForActiveQuests(gossipInfos)
	for _, questInfo in ipairs(gossipInfos) do
		if (questInfo.isComplete) then
			local questname = questInfo.title
			if self:isAppropriateQuest(questname, true) then
				local quest = L.quests[questname]
				if quest and quest.amount then
					if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
						C_GossipInfo.SelectActiveQuest(questInfo.questID)
						self.DarkmoonAllowToProceed = false
					end
				else
					C_GossipInfo.SelectActiveQuest(questInfo.questID)
					self.DarkmoonAllowToProceed = false
				end
			end
		end
	end
end

function AutoTurnIn:VarArgForAvailableQuests(gossipInfos)
	for i,questInfo in ipairs(gossipInfos) do		
		local triviaAndAllowedOrNotTrivial = (not questInfo.isTrivial) or db.trivial
		local quest = L.quests[questInfo.title] -- this quest exists in addons quest DB. There are mostly daily quests
		local notBlackListed = not (quest and (quest.donotaccept or AutoTurnIn:IsIgnoredQuest(questInfo.title, questInfo.questID)))
		local isDaily = self:_isDaily(questInfo)		
		-- for unknown reason the questInfo is different from what is seen in QuestCache:Get(questID);
		if isDaily then
			self:CacheAsDaily(questInfo.title)
		end
		-- Quest is appropriate if: (it is trivial and trivial are accepted) and (any quest accepted or (it is daily quest that is not in ignore list))		
		if (triviaAndAllowedOrNotTrivial and notBlackListed and self:_isAppropriate(isDaily)) then			
			if quest and quest.amount then
				if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
					C_GossipInfo.SelectAvailableQuest(questInfo.questID)
				end
			else
				C_GossipInfo.SelectAvailableQuest(questInfo.questID)
			end
		end
	end
end

-- Extracts GUID from the NPC which dialog window is currenty displayed
function AutoTurnIn:GetNPCGUID()
	local a = UnitGUID("npc")
	return a and select(3, a:find("Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")) or nil
end

function AutoTurnIn:isDarkmoonAndAllowed(questCount)
	return (self.DarkmoonAllowToProceed and questCount) and
			db.darkmoonautostart and
			(GetZoneText() == L["Darkmoon Island"])
end

function AutoTurnIn:GOSSIP_CONFIRM(event, _, message, cost)
	if message == L["ReviveBattlePetA"] and cost == 1000 then
		local dialog = StaticPopup_FindVisible("GOSSIP_CONFIRM")
		if dialog then
			StaticPopup_OnClick(dialog, 1)
		end
	end
end

function AutoTurnIn:GOSSIP_SHOW()
	self:DebugPrint("GOSSIP_SHOW")
	if (not self:AllowedToHandle(true)) then
		return
	end

	-- darkmoon fairy gossip sometime turns in quest too fast so I can't relay only on quest number count. It often lie.
	-- this flag is set in VarArgForActiveQuests if any quest may be turned in
	self.DarkmoonAllowToProceed = true	
	local questCount = C_GossipInfo.GetNumActiveQuests() > 0

	self:VarArgForActiveQuests(C_GossipInfo.GetActiveQuests())
    if not db.completeonly then
	    self:VarArgForAvailableQuests(C_GossipInfo.GetAvailableQuests())
	end

	if self:isDarkmoonAndAllowed(questCount) then
		local options = C_GossipInfo.GetOptions()
		for _, gossipInfo in ipairs(options) do
			if ((gossipInfo.type == "gossip") and strfind(gossipInfo.name, "|cFF0008E8%(")) then
				return C_GossipInfo.SelectOption(gossipInfo.gossipOptionID)
			end
		end
	end

	self:HandleGossip()
end

local trivialNoText = {}
function AutoTurnIn:QUEST_DETAIL()
	if (QuestIsDaily() or QuestIsWeekly()) then
		self:CacheAsDaily(GetTitleText())
	end
	if QuestGetAutoAccept() then
		CloseQuest()
	else
		if self:AllowedToHandle() and self:isAppropriateQuest() and (not db.completeonly) then
			--ignore trivial quests
			if (not C_QuestLog.IsQuestTrivial(GetQuestID()) or db.trivial) then
				QuestInfoDescriptionText:SetAlphaGradient(0, 5000)
				QuestInfoDescriptionText:SetAlpha(1)
				AcceptQuest()
				return
			end
		end
		--quest level on detail frame
		if db.questlevel then
			local qid = GetQuestID()
			local level = C_QuestLog.GetQuestDifficultyLevel(qid)
			--sometimes it returns 0, but that's wrong
			if level and level > 0 then 			
				local text = QuestInfoTitleHeader:GetText()
				if text then -- there are reports (unconfirmed) that some trivial quests return nil for text
					local levelFormat = "[%d] %s"
					--trivial display
					if C_QuestLog.IsQuestTrivial(qid) then text = TRIVIAL_QUEST_DISPLAY:format(text) end
					QuestInfoTitleHeader:SetText(levelFormat:format(level, text))
				else
					if (not not trivialNoText[qid]) then
						trivialNoText[qid] = true
						self:Print("[AutoTurnIn] Quest has nil title [" .. qid .. "]. Could you please report it to AutoTurnIn author?")						
					end
				end
			end
		end
	end
end

-- TODO: needs testing with another player
function AutoTurnIn:QUEST_ACCEPTED(event, index)
	if db.questshare and C_QuestLog.IsPushableQuest(index) and GetNumGroupMembers() >= 1 then
		C_QuestLog.SetSelectedQuest(index);
		QuestLogPushQuest();
	end
end

function AutoTurnIn:QUEST_PROGRESS()
    if  (self:AllowedToHandle() and IsQuestCompletable() and (self:isAppropriateQuest() or self:IsWantedQuest(GetQuestID()))) then
		CompleteQuest()
    end
end

function AutoTurnIn:HandleGossip()
	local guid = AutoTurnIn:GetNPCGUID()
	local func = AutoTurnIn.knownGossips[guid]
	if func then
		func()
	else
		-- https://www.wowinterface.com/forums/showthread.php?t=49210 adaptation
		if db.reviveBattlePet then
			local options = C_GossipInfo.GetOptions()
			for _, gossipInfo in ipairs(options) do
				if gossipInfo.name == L["ReviveBattlePetQ"] then
					return C_GossipInfo.SelectOption(gossipInfo.gossipOptionID)
				end
			end
		end
	end
end

-- return true if an item is of `Jewelry` type and is suitable with current options
function AutoTurnIn:IsJewelryAndRequired(equipSlot)
	return db.armor['Jewelry'] and (C.JEWELRY[equipSlot])
end

-- initiated in AutoTurnIn:TurnInQuest PLAYER_LEAVE_COMBAT ? PLAYER_REGEN_ENABLED ?
AutoTurnIn.delayFrame = CreateFrame('Frame')
AutoTurnIn.delayFrame:Hide()
AutoTurnIn.delayFrame:SetScript('OnUpdate', function()
	if not next(AutoTurnIn.autoEquipList) then
		AutoTurnIn:DebugPrint("AutoEquip has no registered items to equip")
		AutoTurnIn.delayFrame:Hide()
		return
	end

	if (InCombatLockdown()) then
		return
	end

	if (time() < AutoTurnIn.delayFrame.delay) then
		return
	end

	for bag=0, NUM_BAG_SLOTS do
		for slot=1, ContainerFrame_GetContainerNumSlots(bag), 1 do
			local link = C_Container.GetContainerItemLink (bag, slot)
			if ( link ) then
				local name = GetItemInfo(link)
				if ( name and AutoTurnIn.autoEquipList[name] ) then
					AutoTurnIn:Print(L["equipping reward"], link)
					EquipItemByName(name, AutoTurnIn.autoEquipList[name])
					AutoTurnIn.autoEquipList[name]=nil
				end
			end
		end
	end
end)

-- return 0 if itemlink is null, item level is math.huge if the item is heirloom
function AutoTurnIn:ItemLevel(itemLink)
	if (not itemLink) then
		return 0
	end
	-- 7 for heirloom https://wowpedia.fandom.com/wiki/Enum.ItemQuality
	local invQuality, invLevel = select(3, GetItemInfo(itemLink))
	return (invQuality == 7) and math.huge or invLevel
end

function AutoTurnIn:swapEquip(itemLink)
	local name = GetItemInfo(itemLink)
	if (self.autoEquipList[name]) then
		self.delayFrame.delay = time() + 2
		self.delayFrame:Show()
	end
end

-- rewardIndex is calculated in AutoTurnIn:QUEST_COMPLETE, ot just '1' if there is just a single reward
-- turns in the quest and prints reward text if `showrewardtext` option is set.
-- equips received reward if such option selected
function AutoTurnIn:TurnInQuest(rewardIndex)
	if (db.showrewardtext) then
		self:Print((UnitName("target") and UnitName("target") or '')..'\n', GetRewardText())
	end

	if (self.forceGreed) then
		if  (GetNumQuestChoices() > 1) then
			self:Print(L["gogreedy"])
		end
	else
		if db.autoequip then
			-- this is a 'CHOICE'
			local itemLink1 = GetQuestItemLink("choice", (GetNumQuestChoices() == 1) and 1 or rewardIndex)

			-- this is 'REWARD' - the unconditional item given for quest completition, it is different from the 'CHOICE'
			local itemLink2 = GetNumQuestRewards() > 0 and GetQuestItemLink("reward", 1) or nil

			-- if we have 2 items for same slot check which one is better
			if (not not itemLink1 and (not not itemLink2)) then
				local lootLevel1, _, _, _, _, equipSlot1 = select(4, GetItemInfo(itemLink1))
				local lootLevel2, _, _, _, _, equipSlot2 = select(4, GetItemInfo(itemLink2))
				if (equipSlot1 == equipSlot2) then
					if lootLevel1 > lootLevel2 then
						itemLink2 = nil
					else
						itemLink1 = nil
					end
				end
			end
			-- 'CHOICE' item is preferred
			if (not not itemLink1) then
				-- Could be already added to the equip frame by the AutoTurnIn:COMPLETE_QUEST funciton
				local name = GetItemInfo(itemLink1)
				if (self.autoEquipList[name] or (not not self:isSuitableItem(itemLink1))) then
					self:DebugPrint("register item for Auto-Equip", itemLink1)
					-- side effect, may register the item as non-equipable
					self:swapEquip(itemLink1)
				end
			end

			if (not not itemLink2 and not not self:isSuitableItem(itemLink2)) then
				self:swapEquip(itemLink2)
			end
		end
	end

	if (db.debug) then
		local link = GetQuestItemLink("choice", rewardIndex)
		if (link) then
			self:DebugPrint("Looting item: ", link)
		elseif (GetNumQuestChoices() == 0) then
			self:DebugPrint("turning quest in, no choice required")
		end
    else
		GetQuestReward(rewardIndex)
	end
end

function AutoTurnIn:LootMostExpensive()
	local index, money = 0, 0;

	self:DebugPrint("looting most expensive")
	for i=1, GetNumQuestChoices() do
		local link = GetQuestItemLink("choice", i)
		if ( link == nil ) then
			return
		end
		local m = select(11, GetItemInfo(link))
		if m > money then
			money = m
			index = i
		end
	end

	if money > 0 then  -- some quests, like tournament ones, offer reputation rewards and they have no cost.
		self.forceGreed = true
		self:TurnInQuest(index)
	end
end

--[[
iterates all rewards and compares with chosen stats and types. If only one appropriate item found then it accepted and quest is turned in.
if more than one suitable item found then item list is shown in a chat window and addons return control to player.

@returns 'true' if one or more suitable reward is found, 'false' otherwise ]]--
-- tables are declared here to optimize memory model. Said that in current implementation it's cheaper to wipe than to create.

AutoTurnIn.found, AutoTurnIn.stattable = {}, {}
function AutoTurnIn:CompleteQuestLootingNeeded()
	wipe(self.found)
	for i=1, GetNumQuestChoices() do
		local checkResult = AutoTurnIn:isSuitableItem(GetQuestItemLink("choice", i))
		if checkResult == nil then
			-- not suitable item
		elseif checkResult == false then
			-- Error getting item or trinket was found
			return true
		else
			tinsert(self.found, {index=i, points=checkResult})
		end
	end

	-- HANDLE RESULT
	local foundCount = #self.found
	if foundCount > 1 then
		-- sorting found items by relevance (count of attributes that concidence)
		table.sort(self.found, function(a,b) return a.points > b.points end)

		if (self.found[1].points == self.found[2].points) then
			self:Print(L["multiplefound"])
			for _, reward in pairs(self.found) do
				-- show only top points items
				if reward.points ~= self.found[1].points then break end
				self:Print(GetQuestItemLink("choice", reward.index))
			end
		else
			self:TurnInQuest(self.found[1].index)
		end
	elseif(foundCount == 1) then
		self:TurnInQuest(self.found[1].index)
	elseif  ( foundCount == 0 and GetNumQuestChoices() > 0 ) and ( not db.greedifnothingfound ) then
		self:Print(L["nosuitablefound"])
	end

	return ( foundCount ~= 0 )
end

function AutoTurnIn:isSuitableItem(link)
	if ( link == nil ) then
		self:Print(L["rewardlag"])
		return false
	end

	local name, _, _, _, _, class, subclass, _, invType = GetItemInfo(link)
	--effective loot level
	local lootLevel = GetDetailedItemLevelInfo(link)
	-- non equippable items
	if (invType == "") then
		return nil
	end

	--trinkets are out of autoloot--
	if  ( 'INVTYPE_TRINKET' == invType )then
		self:Print(L["stopitemfound"]:format(_G[invType]))
		return false
	end

	-- User may not choose any options hence any item became 'ok'. That situation is undoubtedly incorrect.
	local SettingsExists = (class == C.WEAPONLABEL and next(db.weapon) or next(db.armor)) or next(db.stat)
	if (not SettingsExists) then
		self:Print(L["norewardsettings"])
		return nil
	end

	local points, lvl = self:itemPoints(link)
	-- points > 0 means that particular options section is empty or item meets requirements
	if (points > 0) then
		-- comparing with currently equipped item
		local slot = C.SLOTS[invType]
		if (slot) then
			local firstSlot = GetInventorySlotInfo(slot[1])
			local invLink = GetInventoryItemLink("player", firstSlot)
			-- nothing equipped
			if invLink == nil then
				if slot[1] == "SecondaryHandSlot" then
					-- will not equip offhand if main hand has 2h-weapon
					local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
					local mainHandType = select(9, GetItemInfo(mainHandLink))
					if mainHandType == "INVTYPE_2HWEAPON" then						
						self:DebugPrint(link, "can not be equipped over", mainHandLink)
						return nil
					end
				end
				self:DebugPrint(link, "can be equipped to empty slot")
				if db.autoequip then
					self.autoEquipList[name] = firstSlot
				end
				return points
			end

			local eqLevel = self:ItemLevel(invLink)
			local invPoints = self:itemPoints(invLink)
			local equipInvType = select(9, GetItemInfo(invLink))
			-- If reward is a ring, trinket or one-handed weapon all slots must be checked in order to swap one with a lesser item-level
			if (invType == equipInvType and #slot > 1) then
				local secondSlot = GetInventorySlotInfo(slot[2])
				invLink = GetInventoryItemLink("player", secondSlot)
				if invLink == nil then
					self:DebugPrint(link, "can be equipped to empty slot")
					if db.autoequip then
						self.autoEquipList[name] = secondSlot
					end
					return points
				else
					local eq2Level = self:ItemLevel(invLink)
					local inv2Points = self:itemPoints(invLink)
					-- 2nd slot item is worse then 1st slot
					if inv2Points < invPoints then
						firstSlot = secondSlot
						eqLevel = eq2Level
						invPoints = inv2Points
					end
				end
			end

			-- comparing lowest equipped item level with reward's item level and points
			self:DebugPrint( link, "level points:", lootLevel, invLink, "level points:", eqLevel)
			if (points >= invPoints and lootLevel >= eqLevel) then
				self:DebugPrint("New", link, "is better then ", invLink, ". Equipping!")
				if db.autoequip then
					self.autoEquipList[name] = firstSlot
				end
				return points
			else
				self:DebugPrint("New", link, "is worse than ", invLink, ". Skipping!")
				return nil
			end
		end

		return points
	end
	return nil
end

-- Item levels are compared in AutoTurnIn:ItemLevel
function AutoTurnIn:itemPoints(link)
	local points = 0
	if (link == nil) then
		return points
	end

	local subclass, _, invType, _, _, classId, subclassId = select(7, GetItemInfo(link))
	if (invType == "") then
		return points
	end

	local info = {}
	tinsert(info, "Item: " .. link)
	-- TYPE: item is suitable if there are no type specified at all or item type is chosen
	local OkByType = false
	if classId == Enum.ItemClass.Weapon then
		OkByType = (not next(db.weapon)) or (db.weapon[subclass] or (invType == INVTYPE_RANGED or invType == INVTYPE_RANGEDRIGHT))
	else
		OkByType = ( not next(db.armor) ) -- armor is not selected at all
		    or ( db.armor[subclass] -- armor piece by the name (shield, Cloak, off-hand, Jewelry)
			or ( classId == Enum.ItemClass.Armor and db.armorType == subclassId) -- particular armor class
			or db.armor[invType] or self:IsJewelryAndRequired(invType) ) -- todo find the inv_type for jewelry
	end
	tinsert(info, "Type: " .. subclass .. ((not not OkByType) and " => YES" or " => NO"))
	if OkByType then
		points = 1000
		--STAT+SECONDARY: Same here: if no stat specified or item stat is chosen then item is wanted
		-- true if table is empty. Sadlt, it is no longer needed. Loot is lways of appropriate main stat
		local OkByStat = not next(db.stat)
		local OkBySecondary = not next(db.secondary) -- true if table is empty
		if (not (OkByStat and OkBySecondary)) then
			wipe(self.stattable)
			GetItemStats(link, self.stattable)
			for stat, value in pairs(self.stattable) do
				if (db.stat[stat]) then
					points = points + (5 * value)
					tinsert(info, "Stat: " .. _G[stat] .. " => YES")
				end
				if (db.secondary[stat]) then
					points = points + value
					tinsert(info, _G[stat])
				end
			end
		end
	end

	tinsert(info, "Points: " .. points)
	self:DebugPrint(table.concat(info, ", "))
	return points
end

-- I was forced to make decision on offhand, cloak and shields separate from armor but I can't pick up my mind about the reason...
function AutoTurnIn:QUEST_COMPLETE()
	-- blasted Lands citadel wonderful NPCs. They do not trigger any events except quest_complete.
	if not self:AllowedToHandle() then
		return
	end

	--/script faction = (GameTooltip:NumLines() > 2 and not UnitIsPlayer(select(2,GameTooltip:GetUnit()))) and
    -- getglobal("GameTooltipTextLeft"..GameTooltip:NumLines()):GetText() DEFAULT_CHAT_FRAME:AddMessage(faction or "NIL")
    if self:isAppropriateQuest() then
		local numOptions = GetNumQuestChoices()

		if numOptions > 1 then
			--get itemId for the first item. It is enough to detect that we either can not proceeed
			-- or this is one of known quests that require alternative handling 
			local function getItemId(typeStr, index)
				local link = GetQuestItemLink(typeStr, index)
				return link and link:match("%b::"):gsub(":", "") or self.ERRORVALUE
			end

			local itemID = getItemId("choice", 1)
			if (not itemID) then
				self:Print("Can't read reward link from server. Close NPC dialogue and open it again.");
				return
			end
			-- Tournament quest found
			if (itemID == "46114" or itemID == "45724") then
				self:TurnInQuest(db.tournament)
				return
			end

			-- Code for ignoring Relics if turned on.
			if (db.relictoggle or db.artifactpowertoggle) then
				for i=1, numOptions do					
					local link = GetQuestItemLink("choice", i)
					local itemID = link and link:match("%b::"):gsub(":", "") or self.ERRORVALUE

					if (link and db.artifactpowertoggle and IsArtifactPowerItem(itemID)) then
						self:Print(L["You chose not to complete quests with Artifact Powers among rewards"], link)
						return
					end
					if (link and db.relictoggle and IsArtifactRelicItem(itemID)) then
						self:Print(L["You chose not to complete quests with Artifact relics among rewards"], link)
						return
					end
				end
			end

			-- Decide whther quest is allowed to be completed and what reward should be looted
			if (db.lootreward > 1) then -- Auto Loot enabled!
				self.forceGreed = false
				if (db.lootreward == 3) then -- 3 == Need
					self.forceGreed = ( not self:CompleteQuestLootingNeeded() ) and db.greedifnothingfound
				end
				if (db.lootreward == 2 or self.forceGreed) then -- 2 == Greed					
					self:LootMostExpensive()
				end
			end
		else
			self:TurnInQuest(1) -- for autoequip to work index must be greater that 0. That's required by Blizzard API
		end
    end
end


function AutoTurnIn:IsIgnoredNPC()
	local guid = AutoTurnIn:GetNPCGUID()
	return (db.IGNORED_NPC and db.IGNORED_NPC[guid])
		or ptable.defaults.profile.IGNORED_NPC[guid]
end
function AutoTurnIn:IsDefaultIgnoredNPC()
	return ptable.defaults.profile.IGNORED_NPC[AutoTurnIn:GetNPCGUID()]
end

function AutoTurnIn:ShowIgnoreButton(frame)
	questNPCName = UnitName("target")

	local GlobalFrame = nil
	if (frame == "quest") then
		GlobalFrame = QuestFrame 
	elseif (frame == "gossip") then
		GlobalFrame = GossipFrame
	end
	if GlobalFrame == nil then
		return
	end

	--reusing existing button
	if (not self.IgnoreButton[frame]) then
		self.IgnoreButton[frame] = CreateFrame("CheckButton", "NPCIgnoreButton" .. frame,
												GlobalFrame,
												ptable.interface10 and "UICheckButtonTemplate" or "OptionsCheckButtonTemplate")
		_G["NPCIgnoreButton" .. frame.."Text"]:SetText("AutoTurnIn: " .. L["ignorenpc"])
		self.IgnoreButton[frame]:SetPoint("TOPLEFT", 90, -18)
	end

	local IgnoreButton = self.IgnoreButton[frame]
	IgnoreButton:SetChecked(not not AutoTurnIn:IsIgnoredNPC())
	IgnoreButton:SetScript("OnClick", function(self)
		local guid = AutoTurnIn:GetNPCGUID()
		db.IGNORED_NPC[guid] = self:GetChecked() and questNPCName or nil
	end)
	if (AutoTurnIn:IsDefaultIgnoredNPC()) then
		IgnoreButton:Disable()
		GameTooltip:SetOwner(IgnoreButton, "ANCHOR_RIGHT");
		GameTooltip:SetText(L["cantstopignore"]);
		GameTooltip:Show()
	else
		IgnoreButton:Enable()
	end
end

function AutoTurnIn:IsWantedQuest(questId)
       return not not ptable.defaults.profile.WANTED_QUESTS[questId]
end

-- gossip and quest interaction goes through a sequence of windows: gossip [shows a list of available quests] - quest[describes specified quest]
-- sometimes some parts of this chain is skipped. For example, priest in Honor Hold show quest window directly. This is a trick to handle 'toggle key'
hooksecurefunc(QuestFrame, "Hide", function()
	AutoTurnIn.allowed = nil
	GameTooltip:Hide()
end)
--GossipFrame sets allowed to true, after that 'toggle key' doesn't work
hooksecurefunc(GossipFrame, "Hide", function()
	AutoTurnIn.allowed = nil
	GameTooltip:Hide()
end)
--GossipFrame should show ignore button too
hooksecurefunc(QuestFrame, "Show", function() AutoTurnIn:ShowIgnoreButton("quest") end)
hooksecurefunc(GossipFrame, "Show", function() AutoTurnIn:ShowIgnoreButton("gossip") end)


--[[
----------------------------------------------------------------------------------------------------------------------------
H E L P E R S 
--]]
function AutoTurnIn:dump(o)
	DevTools_Dump(o, "value");
	-- self:Print(self:_dump(o))
end

function AutoTurnIn:_dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. self:_dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function AutoTurnIn:DebugPrint(...)
	if (db.debug) then
		local msg = ""
		for i = 1, select("#", ...) do
			local mbvalue = select(i, ...)
			msg = (i > 1 and (msg .. " ") or msg) .. (mbvalue and mbvalue or "nil")
		end
		self:Print("|cfff23ff4", "DEBUG: ", msg, "|r")
	end
end

-- /run local a=UnitGUID("npc"); for word in a:gmatch("Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-") do print(word) end
-- https://www.townlong-yak.com/


--[[
	DATA BROKER STRUCTURES
--]]
-- see https://github.com/tekkub/libdatabroker-1-1/wiki/api
function AutoTurnIn:LibDataStructure()
	if not AutoTurnIn.ldb then
		local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if LDB then
			AutoTurnIn.ldb = LDB:NewDataObject("AutoTurnIn", {
				type = "data source",
				icon = "Interface\\AddOns\\AutoTurnIn\\Icon",
				text =  (AutoTurnIn.db.profile.enabled) and '|cff00ff00on|r' or '|cffff0000off|r',
				label = addonName,
				OnClick = function(clickedframe, button)
					if (button == "LeftButton") then
						AutoTurnIn:ShowOptions("")
					else
						AutoTurnIn:SetEnabled(not db.enabled)
					end
				end,
				OnTooltipShow = function(tooltip)
					tooltip:AddLine(addonName .. " quest helper", 1, 1, 1)
					tooltip:AddLine("Left mouse button shows options.")
					tooltip:AddLine("Right mouse button toggle addon on/off.")
				end
			})
		end
	end
end

function AutoTurnIn:ShowOptions(args)
	-- too much things became tainted if called in combat.
	if InCombatLockdown() then return end

	local arg1 = AutoTurnIn:GetArgs(args, 1)
	if arg1 == nil or arg1 == "" then
		LibStub("AceConfigDialog-3.0"):Open(self.optionCategory)
	end

	if arg1 == "on" and not db.enabled then
		AutoTurnIn:SetEnabled(true)
		self:Print(arg1)
	end

	if arg1 == "off" and db.enabled then
		AutoTurnIn:SetEnabled(false)
		self:Print(arg1)
	end

	if arg1 == "replay" then
		if AutoTurnIn.db.skippedMovieId > 0 then
			MovieFrame_PlayMovie(MovieFrame, AutoTurnIn.db.skippedMovieId)
		else
			self:Print("Nothing to replay")
		end		
	end

	-- update from May 2024: now there is sort of Settings.OpenToCategory() and "See Blizzard_ImplementationReadme.lua for recommended setup."
	-- if (InterfaceOptionsFrame:IsVisible() and InterfaceOptionsFrameAddOns.selection) then
	-- 	if (InterfaceOptionsFrameAddOns.selection:GetName() == AutoTurnIn.OptionsPanel:GetName()) then --"AutoTurnInOptionsPanel"
	-- 		InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.RewardPanel)
	-- 	elseif (InterfaceOptionsFrameAddOns.selection:GetName() == AutoTurnIn.RewardPanel:GetName() ) then --"AutoTurnInRewardPanel"
	-- 	-- it used to be a cancel. But BlizzardUI contains weird bug which taints all the interface if InterfaceOptionsFrameCancel:Click() called
	-- 		InterfaceOptionsFrameOkay:Click()
	-- 	end
	-- else
	-- 	-- http://wowpedia.org/Patch_5.3.0/API_changes double call is a workaround
	-- 	InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)
	-- 	InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)
	-- end
end
-- DevTools_DumpCommand("C_GossipInfo.GetAvailableQuests()")
