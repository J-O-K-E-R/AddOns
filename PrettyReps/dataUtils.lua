--[[	

    $$$$$$$\             $$\                     $$\   $$\   $$\     $$\ $$\           
    $$  __$$\            $$ |                    $$ |  $$ |  $$ |    \__|$$ |          
    $$ |  $$ | $$$$$$\ $$$$$$\    $$$$$$\        $$ |  $$ |$$$$$$\   $$\ $$ | $$$$$$$\ 
    $$ |  $$ | \____$$\\_$$  _|   \____$$\       $$ |  $$ |\_$$  _|  $$ |$$ |$$  _____|
    $$ |  $$ | $$$$$$$ | $$ |     $$$$$$$ |      $$ |  $$ |  $$ |    $$ |$$ |\$$$$$$\  
    $$ |  $$ |$$  __$$ | $$ |$$\ $$  __$$ |      $$ |  $$ |  $$ |$$\ $$ |$$ | \____$$\ 
    $$$$$$$  |\$$$$$$$ | \$$$$  |\$$$$$$$ |      \$$$$$$  |  \$$$$  |$$ |$$ |$$$$$$$  |
    \_______/  \_______|  \____/  \_______|       \______/    \____/ \__|\__|\_______/ 

--]]

local DataUtils = {}

---------------------------------------------------------------------------------------------
--								Vars
---------------------------------------------------------------------------------------------

PrettyRepsDB = {Structure = {}, Options = {}}
local characterDB

local playerOptions = {}
local fakeHeadersCollapsedStatus = {}
local guildRep = {}
local EXALTED_STANDING_ID = 8
local isHorde, isAlliance
local playerName, playerRealm
local selectedFaction = {}

---------------------------------------------------------------------------------------------
--								Exports
---------------------------------------------------------------------------------------------
_G.PrettyReps.DataUtils = {}

function _G.PrettyReps.DataUtils.Init()
    DataUtils:Init()
end

function _G.PrettyReps.DataUtils.RebuildPanelData(options)
	if options and options.refreshServerData then
		local characterData = DataUtils:ReloadCharacterData();
		DataUtils:MergeRepData(PrettyRepsDB, characterData);    
		characterDb = characterData
	end

    return DataUtils:FlattenStructure(characterDb)
end

function _G.PrettyReps.DataUtils.Save()
    DataUtils:Save()
end

function _G.PrettyReps.DataUtils.SetOption(name, value)
    playerOptions[name] = value
    _G.PrettyReps.Callbacks.Trigger("OnOptionChanged")
end

function _G.PrettyReps.DataUtils.GetOption(name, default)
    if playerOptions[name] ~= nil then
        return playerOptions[name]
    else
        return default
    end
end

function _G.PrettyReps.DataUtils.ExpandAll(expand)
    DataUtils:ExpandAll(expand)
	DataUtils:Save()
	_G.PrettyReps.Callbacks.Trigger("OnDbStructureChanged")
end

function _G.PrettyReps.DataUtils:ToggleCollapsed(factionData)
	DataUtils:ToggleCollapsed(factionData)
	DataUtils:Save()
	_G.PrettyReps.Callbacks.Trigger("OnDbStructureChanged")
end

function _G.PrettyReps.DataUtils.SetSelectedFaction(factionData)
	selectedFaction = factionData
	_G.PrettyReps.Callbacks.Trigger("OnSelectedFactionChanged", factionData)
end

function _G.PrettyReps.DataUtils.GetSelectedFaction()
	return selectedFaction
end

function _G.PrettyReps.DataUtils.ClearSelectedFaction()
	selectedFaction = {}
end

function _G.PrettyReps.DataUtils.ToggleFavourite(isFavourite)
	selectedFaction.isInactive = false
	selectedFaction.isFavourite = isFavourite
	DataUtils:Save()
	_G.PrettyReps.Callbacks.Trigger("OnDbStructureChanged")
	_G.PrettyReps.Callbacks.Trigger("OnSelectedFactionChanged", selectedFaction)
end

function _G.PrettyReps.DataUtils.ToggleInactive(inactive)
	selectedFaction.isInactive = inactive
	selectedFaction.isFavourite = false
	DataUtils:Save()
	_G.PrettyReps.Callbacks.Trigger("OnDbStructureChanged")
	_G.PrettyReps.Callbacks.Trigger("OnSelectedFactionChanged", selectedFaction)
end

function _G.PrettyReps.DataUtils.ToggleWatched(isWatched)
	selectedFaction.isWatched = isWatched
	SetWatchedFactionIndex(isWatched and selectedFaction.internalIndex or 0)
	DataUtils:Save()
	_G.PrettyReps.Callbacks.Trigger("OnDbStructureChanged")
	_G.PrettyReps.Callbacks.Trigger("OnSelectedFactionChanged", selectedFaction)
end

---------------------------------------------------------------------------------------------
--								Functions
---------------------------------------------------------------------------------------------

function DataUtils:Init()
    playerOptions = PrettyRepsDB.Options or playerOptions
    fakeHeadersCollapsedStatus = PrettyRepsDB.Headers or fakeHeadersCollapsedStatus
    playerOptions.Enabled = true
    isAlliance = UnitFactionGroup("player") == "Alliance"
    isHorde = UnitFactionGroup("player") == "Horde"
	playerName, playerRealm = UnitName("player"), GetRealmName()
end

function DataUtils:Save()
	if characterDb then
		PrettyRepsDB.Structure = characterDb
		PrettyRepsDB.Options = playerOptions
		PrettyRepsDB.Headers = fakeHeadersCollapsedStatus
	end
end

-- This function will first make a copy of the entire empty structured database
-- It will then load all reps known to this character and populate the database with server values
function DataUtils:ReloadCharacterData()

	local characterRepStructure = CopyTable(_G.PrettyReps.Data.Structure)
	local guildName = GetGuildInfo("player")

	for i = 1, 230, 1 do
		local name, description, standingID, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canSetInactive = GetFactionInfo(i)
		if standingID then
			local rep

			if guildName ~= nil and name == guildName then
				rep = guildRep
				rep.isGuild = true
			else
				rep = self:ExtractRepData(characterRepStructure, factionID)
			end
			
			if rep then
				rep.internalIndex = i
				rep.isActive = true
				rep.hasEncountered = true
				rep.playerName = playerName
				rep.playerRealm = playerRealm
				rep.name = name
				rep.description = description
				rep.standingID = standingID
				rep.bottomValue = bottomValue
				rep.topValue = topValue
				rep.earnedValue = earnedValue
				rep.atWarWith = atWarWith
				rep.canToggleAtWar = canToggleAtWar
				rep.hasRep = hasRep
				rep.isWatched = isWatched
				rep.factionID = factionID
				rep.canSetInactive = canSetInactive
				rep.hasBonusRepGain = hasBonusRepGain
				rep.isMaxed = standingID == EXALTED_STANDING_ID

				-- Friendship
				local repInfo = factionID and C_GossipInfo.GetFriendshipReputation(factionID);
				if repInfo and repInfo.friendshipFactionID > 0 then
					rep.isFriendship = true
					rep.friendshipData = repInfo
					rep.friendshipRanks = C_GossipInfo.GetFriendshipReputationRanks(repInfo.friendshipFactionID)
				end

				-- Renown
				local isMajorFaction = factionID and C_Reputation.IsMajorFaction(factionID)
				if isMajorFaction then
					rep.isMajorFaction = isMajorFaction
					rep.majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
					rep.hasMaximumRenown = C_MajorFactions.HasMaximumRenown(factionID)
				end
			end

		end
	end

    return characterRepStructure
end

-- This function will merge the source database into the destination database,
-- overwriting factions where the source has a higher reputation than the destination
-- or the destination has no data for that faction
function DataUtils:MergeRepData(source, dest)
	local function Merge(characterFaction)
		local dbFaction = self:ExtractRepData(source.Structure, characterFaction.factionID)
		if dbFaction then
			if characterFaction.children then
				for i, child in ipairs(characterFaction.children) do
					Merge(child)
				end
			end

			if dbFaction.isActive then
				local overwriteRep = not characterFaction.earnedValue or dbFaction.earnedValue > characterFaction.earnedValue
			
				if dbFaction.isMajorFaction and dbFaction.majorFactionData then
					if 	not characterFaction.majorFactionData 
						or dbFaction.majorFactionData.renownLevel > characterFaction.majorFactionData.renownLevel
						or (dbFaction.majorFactionData.renownLevel == characterFaction.majorFactionData.renownLevel
							and dbFaction.majorFactionData.renownReputationEarned > characterFaction.majorFactionData.renownReputationEarned) then
								overwriteRep = true
					end
				end

				if overwriteRep then
					self:CopyData(dbFaction, characterFaction)
				end
			end
			characterFaction.isInactive = dbFaction.isInactive
			characterFaction.isCollapsed = dbFaction.isCollapsed
			characterFaction.isFavourite = dbFaction.isFavourite
		end
	end

	for i, characterExpansion in ipairs(dest) do
		Merge(characterExpansion)
	end
end

-- This function will flatten a structured database into a single level table
-- that can be used to build the reputation window
function DataUtils:FlattenStructure(db)
	local reps = {}
	local inactives = {}
	local unobtainable = {}
	local favourites = {}
	local function Flatten(parent, child)
		if child.isActive then
			child.isHeader = child.children and true or false
			child.parent = parent
			child.isChild = child ~= parent and true or false
			child.isExpansion = child == parent and true or false
			child.isLayoutChild = (not parent.isExpansion or (child.isHeader and child.isChild)) and true or false

			if selectedFaction and selectedFaction.factionID == child.factionID then
				selectedFaction = child
			end

			if child.isFavourite then
				child.isLayoutChild = false
				table.insert(favourites, child)
			elseif child.isInactive then
				child.isLayoutChild = false
				table.insert(inactives, child)
			elseif playerOptions["UseUnobtainableGroup"] and child.isUnobtainable and child.standingID < EXALTED_STANDING_ID then
				table.insert(unobtainable, child)
			elseif not playerOptions["HideOppositeFaction"] or self:IsSameFaction(child) then

				if child.isHeader then
					child.exaltedCount, child.exaltedTotal = 0, 0
				end

				if child.isChild and parent.exaltedCount and not child.isHeader then
					parent.exaltedTotal = parent.exaltedTotal + 1
					parent.exaltedCount = child.isMaxed and parent.exaltedCount + 1 or parent.exaltedCount
				end

				local insertIndex
				if (not parent.isCollapsed and (not parent.parent or not parent.parent.isCollapsed)) or child.isExpansion then
					table.insert(reps, child)
					insertIndex = #reps
				end
				if child.isHeader then
					for _, _child in ipairs(child.children) do
						Flatten(child, _child)
					end
				end

				if child.isChild and child.exaltedCount and parent.exaltedCount then
					parent.exaltedTotal = parent.exaltedTotal + child.exaltedTotal
					parent.exaltedCount = parent.exaltedCount + child.exaltedCount
				end

				if child.exaltedTotal == 0 then
					table.remove(reps, insertIndex)
				end
			end
		end
	end

	-- Guild
	if guildRep.factionID and playerOptions["ShowGuild"] then
		local guildHeader = self:CreateFakeHeader(db, "Guild")
		guildHeader.exaltedTotal, guildHeader.exaltedCount = 1, guildRep.standingID == EXALTED_STANDING_ID and 1 or 0
		table.insert(reps, guildHeader)
		if not guildHeader.isCollapsed then
			guildRep.parent = guildHeader
			table.insert(reps, guildRep)
		end
	end

	-- All Reps
	for _, expansion in ipairs(db) do
		Flatten(expansion, expansion)
	end

	-- Favourites
	if #favourites > 0 then
		local favouritesHeader = self:CreateFakeHeader(db, "Favourites")
		table.insert(reps, 1, favouritesHeader)
		if not favouritesHeader.isCollapsed then
			for i = 1, #favourites do
				local fav = favourites[i]
				fav.parent = favouritesHeader
				table.insert(reps, i + 1, fav)
			end
		end
	end

	-- Unobtainable
	if not playerOptions["HideUnobtainableGroup"] and #unobtainable > 0 then
		local unobtainableHeader = self:CreateFakeHeader(db, "Unobtainable")
		table.insert(reps, unobtainableHeader)
		if not unobtainableHeader.isCollapsed then
			for _, unobtainableRep in ipairs(unobtainable) do
				unobtainableRep.parent = unobtainableHeader
				table.insert(reps, unobtainableRep)
			end
		end
	end

	-- Inactive
	if not playerOptions["HideInactiveGroup"] and #inactives > 0 then
		local inactiveHeader = self:CreateFakeHeader(db, "Inactive")
		table.insert(reps, inactiveHeader)
		if not inactiveHeader.isCollapsed then
			for _, inactiveRep in ipairs(inactives) do
				inactiveRep.parent = inactiveHeader
				table.insert(reps, inactiveRep)
			end
		end
	end

	return reps
end


-- This function will search for the given faction in the given database
function DataUtils:ExtractRepData(repStructure, factionID)
	local function Get(parent)
		if parent.factionID == factionID then
			return parent
		elseif parent.children then
			for _, child in ipairs(parent.children) do
				local result = Get(child)
				if result then
					return result
				end
			end
		end
	end

	for _, expansion in ipairs(repStructure) do
		local result = Get(expansion)
		if result then
			return result
		end
	end
end

local lastFakeId = 0
local fakes = {}
function DataUtils:CreateFakeHeader(db, name)
	if fakes[name] then
		fakes[name].isCollapsed = fakeHeadersCollapsedStatus[name]
		return fakes[name]
	end

	local fakeHeader = self:CopyData(self:ExtractRepData(db, 1118), {})
	fakeHeader.isCollapsed = fakeHeadersCollapsedStatus[name] and true or false
	fakeHeader.name = name
	fakeHeader.isHeader = true
	lastFakeId = lastFakeId - 1
	fakeHeader.factionID = lastFakeId
	fakeHeader.exaltedTotal, fakeHeader.exaltedCount = nil, nil
	fakeHeadersCollapsedStatus[name] = fakeHeader.isCollapsed and true or false
	fakes[name] = fakeHeader
	return fakeHeader
end

function DataUtils:IsSameFaction(factionData)
	if not factionData.isHorde and not factionData.isAlliance then
		return true
	elseif factionData.isHorde and isHorde then
		return true
	elseif factionData.isAlliance and isAlliance then
		return true
	end
end

-- Copy data from one database to another
function DataUtils:CopyData(from, to)
	local dontOverwrite = {["internalIndex"] = true, ["hasEncountered"] = true, ["canToggleAtWar"] = true, ["isWatched"] = true }
	local tableKeys = {["majorFactionData"] = true, ["friendshipData"] = true, ["friendshipRanks"] = true}

	for key, value in pairs(from) do
		if type(value) ~= "table" and type(value) ~= "userdata" and not dontOverwrite[key] then
			to[key] = value
		end

		if type(value) == "table" and tableKeys[key] then
			to[key] = value
		end
	end
	return to
end

function DataUtils:ExpandAll(expand)
	local function Expand(parent)
		if parent.isHeader then
			parent.isCollapsed = not expand
		end

		if parent.children then
			for _, child in ipairs(parent.children) do
				Expand(child)
			end
		end
	end

	for _, expansion in ipairs(characterDb) do
		expansion.isCollapsed = not expand
		Expand(expansion)
	end

	for _, fakeHeader in pairs(fakes) do
		fakeHeadersCollapsedStatus[fakeHeader.name] = not expand
	end
end

function DataUtils:ToggleCollapsed(factionData)
	if fakeHeadersCollapsedStatus[factionData.name] ~= nil then
		fakeHeadersCollapsedStatus[factionData.name] = not fakeHeadersCollapsedStatus[factionData.name]
	elseif factionData.isHeader then
		factionData.isCollapsed = not factionData.isCollapsed
	end
end