local addonName = ...
local addon = _G[addonName]
local addonVersion = GetAddOnMetadata(addonName, "Version")

local GFICache = {}
function addon:C_Garrison_GetFollowerInfo(garrFollowerID)
    if GFICache[garrFollowerID] then
        return CopyTable(GFICache[garrFollowerID])
    end
    
    GFICache[garrFollowerID] = C_Garrison.GetFollowerInfo(garrFollowerID)
    if GFICache[garrFollowerID] then
        return CopyTable(GFICache[garrFollowerID])
    end
end

local function getGarrFollowerID(followerID)
    if GFICache[followerID] then
        return GFICache[followerID].garrFollowerID
    end
    GFICache[followerID] = C_Garrison.GetFollowerInfo(followerID)
    if GFICache[followerID] then
        return GFICache[followerID].garrFollowerID
    end
end

local function getKey(follower1, follower2, follower3, follower4, follower5)
    local lineup = {follower1, follower2, follower3, follower4, follower5}
    
    local function sort_func(a, b)
        if a == nil then return false end
        if b == nil then return true end
        return getGarrFollowerID(a) < getGarrFollowerID(b)
    end
    
    table.sort(lineup, sort_func)
    
    local key = ""
    for _, follower in pairs(lineup) do
        if key ~= "" then
            key = key .. "--"
        end
        
        local info = addon:C_Garrison_GetFollowerInfo(follower)
        key = key..info.garrFollowerID.."-"
        
        info = addon:C_Garrison_GetFollowerAutoCombatStats(follower)
        key = key..info.attack.."-"
        key = key..info.currentHealth
    end
    
    return key
end

function addon:isResultCacheGuaranteedFailure(missionID, follower1, follower2, follower3, follower4, follower5)
    local key = getKey(follower1, follower2, follower3, follower4, follower5)
    local missionLevel = C_Garrison.GetBasicMissionInfo(missionID).missionScalar
    
    if TLDRMissionsCache[addonVersion][missionID] then
        if TLDRMissionsCache[addonVersion][missionID][missionLevel] then
            if TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"] then
                return TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"][key]
            end
        end
    end
end

-- the keys should be followers only. no matter what troops we set, the mission will fail
function addon:setResultCacheGuaranteedFailure(missionID, follower1, follower2, follower3, follower4, follower5)
    local key = getKey(follower1, follower2, follower3, follower4, follower5)
    local missionLevel = C_Garrison.GetBasicMissionInfo(missionID).missionScalar
    
    if TLDRMissionsCache[addonVersion][missionID] then
        if TLDRMissionsCache[addonVersion][missionID][missionLevel] then
            if TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"] then
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"][key] = true
            else
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"] = {}
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"][key] = true
            end
        else
            TLDRMissionsCache[addonVersion][missionID][missionLevel] = {}
            TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"] = {}
            TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"][key] = true
        end
    else
        TLDRMissionsCache[addonVersion][missionID] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel]["g"][key] = true
    end
end

function addon:isResultCacheCombinationKnown(missionID, follower1, follower2, follower3, follower4, follower5)
    local key = getKey(follower1, follower2, follower3, follower4, follower5)
    local missionLevel = C_Garrison.GetBasicMissionInfo(missionID).missionScalar
    
    if TLDRMissionsCache[addonVersion][missionID] then
        if TLDRMissionsCache[addonVersion][missionID][missionLevel] then
            if TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] then
                local cache = TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key]
                
                if cache == nil then
                    return
                elseif cache == false then
                    return false 
                else
                    local cacheCopy = CopyTable(cache.combination)
                    local lineup = {follower1, follower2, follower3, follower4, follower5}
                    
                    -- cache will have garrFollowerIDs in the order frontleft, frontmid, frontright, backleft, backright
                    -- need to convert them to followerIDs
                    for l, c in pairs(cacheCopy) do
                        for k, v in pairs(lineup) do
                            local garrFollowerID = getGarrFollowerID(v)
                            if c then
                                if c == garrFollowerID then
                                    cacheCopy[l] = v
                                end
                            end
                        end
                    end
                    
                    return {
                        ["defeats"] = 0,
                        ["victories"] = 1,
                        ["missionID"] = missionID,
                        ["finalHealth"] = cache.finalHealth,
                        ["combination"] = cacheCopy,
                        ["incompletes"] = 0,
                    }
                end
            end
        end
    end
end

function addon:setResultCacheCombinationUnknown(missionID, follower1, follower2, follower3, follower4, follower5)
    local key = getKey(follower1, follower2, follower3, follower4, follower5)
    local missionLevel = C_Garrison.GetBasicMissionInfo(missionID).missionScalar
    
    if TLDRMissionsCache[addonVersion][missionID] then
        if TLDRMissionsCache[addonVersion][missionID][missionLevel] then
            if TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] then
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = false
            else
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] = {}
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = false
            end
        else
            TLDRMissionsCache[addonVersion][missionID][missionLevel] = {}
            TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] = {}
            TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = false
        end
    else
        TLDRMissionsCache[addonVersion][missionID] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = false
    end
end

function addon:setResultCacheCombinationKnown(missionID, follower1, follower2, follower3, follower4, follower5, results)
    local key = getKey(follower1, follower2, follower3, follower4, follower5)
    local missionLevel = C_Garrison.GetBasicMissionInfo(missionID).missionScalar
    local combination = CopyTable(results.combination)
    local lineup = {follower1, follower2, follower3, follower4, follower5}
    
    -- need to convert them to followerIDs
    for k, v in pairs(combination) do
        local garrFollowerID = getGarrFollowerID(v)
        for l, c in pairs(lineup) do
            if c then
                if c == v then
                    combination[k] = garrFollowerID
                end
            end
        end
    end
    
    local cache = {
        ["finalHealth"] = results.finalHealth,
        ["combination"] = combination,
    }
    
    if TLDRMissionsCache[addonVersion][missionID] then
        if TLDRMissionsCache[addonVersion][missionID][missionLevel] then
            if TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] then
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = cache
            else
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] = {}
                TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = cache
            end
        else
            TLDRMissionsCache[addonVersion][missionID][missionLevel] = {}
            TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] = {}
            TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = cache
        end
    else
        TLDRMissionsCache[addonVersion][missionID] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"] = {}
        TLDRMissionsCache[addonVersion][missionID][missionLevel]["c"][key] = cache
    end
end

-- https://github.com/teelolws/TLDRMissions/issues/68
local ACSCache = {}
function addon:C_Garrison_GetFollowerAutoCombatStats(garrFollowerID)
    local cache = C_Garrison.GetFollowerAutoCombatStats(garrFollowerID)
    if cache then
        ACSCache[garrFollowerID] = cache
        return CopyTable(cache)
    end
    
    if ACSCache[garrFollowerID] then
        return CopyTable(ACSCache[garrFollowerID])
    end
end