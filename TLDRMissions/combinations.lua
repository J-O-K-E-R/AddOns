local addonName = ...
local addon = _G[addonName]

local function startSimulation(combination, missionID, callback)        
    addon:Simulate(combination[1], combination[3], combination[5], combination[2], combination[4], missionID, function(results)
        results.combination = {combination[1], combination[3], combination[5], combination[2], combination[4]}
        results.missionID = missionID
    
        if results.incompletes > 0 then
            print("A simulation did not complete. Investigate")
            addon:pauseWorker()
            return
        end
        
        if (results.defeats == 0) and (results.victories > 0) then
            addon:clearWork()
            addon:setResultCacheCombinationKnown(missionID, combination[1], combination[3], combination[5], combination[2], combination[4], results)
            callback(results)
            return
        end
        
        if addon:isCurrentWorkBatchEmpty() then
            callback(results)
        end
    end)
end
    
function addon:arrangeAllFollowerPositions(follower1, follower2, follower3, follower4, follower5, missionID, callback)
    
    local followers = {follower1, follower2, follower3, follower4, follower5}
    
    local cache = addon:isResultCacheCombinationKnown(missionID, follower1, follower2, follower3, follower4, follower5)
    if cache == false then
        return
    elseif cache then
        callback(cache)
        return
    end
    
    addon:pauseWorker()
    
    local combinations = {}
    --[[
        structure should look like:
        [1] = {1 = followerID1, 2 = followerID2, 3 = followerID3, etc},
        [2] = {1 = followerID1, 2 = followerID2, 4 = followerID3}, etc
        [...]
        [25] = { stuff }
        covering all possible places each follower could be positioned
        should be 120 combinations O(n!) because all nils are still included
    --]]
    
    -- setup table with every possible arrangement of the 5 followers
    for a = 1, 5 do
        for b = 1, 5 do
            if b ~= a then
                for c = 1, 5 do
                    if (c ~= b) and (c ~= a) then
                        for d = 1, 5 do
                            if (d ~= c) and (d ~= b) and (d ~= a) then
                                for e = 1, 5 do
                                    if (e ~= d) and (e ~= c) and (e ~= b) and (e ~= a) then
                                        table.insert(combinations, {[a]=followers[1], [b]=followers[2], [c]=followers[3], [d]=followers[4], [e]=followers[5]})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- ok now lets get rid of any identical combinations, from where nils and troops were interchanged
    local function recursion()
        for k1, v1 in ipairs(combinations) do
            for k2, v2 in ipairs(combinations) do
                if k1 ~= k2 then
                    local match = true
                    for i = 1, 5 do
                        if v1[i] ~= v2[i] then
                            match = false
                            break
                        end
                    end
                    if match then
                        table.remove(combinations, k2)
                        recursion()
                        return
                    end
                end
            end
        end
    end

    recursion()
    
    local batch = addon:createWorkBatch(2)
    for _, combination in ipairs(combinations) do
        addon:addWork(batch, startSimulation, combination, missionID, callback)
    end
    
    addon:addWork(batch, addon.setResultCacheCombinationUnknown, addon, missionID, follower1, follower2, follower3, follower4, follower5)
    
    addon:unpauseWorker()
end

function addon:sortFollowers(followers, sortBy)
   if sortBy == "lowestLevel" then
        local function sort_func(a, b)
            local c, d = C_Garrison.GetFollowerInfo(a).level, C_Garrison.GetFollowerInfo(b).level 
            if c == d then
                return C_Garrison.GetFollowerInfo(a).portraitIconID > C_Garrison.GetFollowerInfo(b).portraitIconID
            end
            return c < d  
        end
        
        table.sort(followers, sort_func)
    elseif sortBy == "highestLevel" then
        local function sort_func(a, b)
            local c, d = C_Garrison.GetFollowerInfo(a).level, C_Garrison.GetFollowerInfo(b).level 
            if c == d then
                return C_Garrison.GetFollowerInfo(a).portraitIconID > C_Garrison.GetFollowerInfo(b).portraitIconID
            end
            return c > d
        end
        
        table.sort(followers, sort_func)
    end
    
    return followers
end

-- for trying to farm experience using the fewest missions
function addon:arrangeFollowerCombinationsByMostFollowersPlusTroops(followers, missionID, callback, sortBy, troopsSetting)
    addon:pauseWorker()

    followers = addon:sortFollowers(followers, sortBy)
    
    local troop = {}
    troop[1] = C_Garrison.GetAutoTroops(123)[1].followerID
    troop[2] = C_Garrison.GetAutoTroops(123)[2].followerID 
    
    local lineup = {}
    
    local function report(results)
        addon:pauseWorker()
        callback(results)
        addon:unpauseWorker()
    end
    
    local batch = addon:createWorkBatch(4)
    
    local function testEachTroop(callback, highPriorityBatch)
        for troopType = 1, 2 do
            table.insert(lineup, troop[troopType])
            if callback then
                callback(nil, highPriorityBatch)
            else
                highPriorityBatch = highPriorityBatch or addon:createWorkBatch(3) 
                addon:addWork(highPriorityBatch, addon.arrangeAllFollowerPositions, addon, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5], missionID, report)
            end
            table.remove(lineup)
        end
    end
    
    local function testFollower(follower, callback)
        table.insert(lineup, follower)
        local highPriorityBatch = addon:createWorkBatch(3)
        
        if not addon:isResultCacheGuaranteedFailure(missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5]) then
            if (callback and (troopsSetting ~= "more")) or (not callback) then
                addon:addWork(highPriorityBatch, addon.arrangeAllFollowerPositions, addon, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5], missionID, report)
            end
            if callback then
                callback(nil, highPriorityBatch)
            end
            
            addon:addWork(highPriorityBatch, addon.setResultCacheGuaranteedFailure, addon, missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5])
        end
        table.remove(lineup)
    end
    
    -- test 5 followers
    addon:addWork(batch, function()
        for _, follower1 in pairs(followers) do
            table.insert(lineup, follower1)
            for _, follower2 in pairs(followers) do
                if follower1 ~= follower2 then
                    table.insert(lineup, follower2)
                    for _, follower3 in pairs(followers) do
                        if (follower1 ~= follower3) and (follower2 ~= follower3) then
                            table.insert(lineup, follower3)
                            for _, follower4 in pairs(followers) do
                                if (follower4 ~= follower1) and (follower4 ~= follower2) and (follower4 ~= follower3) then
                                    table.insert(lineup, follower4)
                                    for _, follower5 in pairs(followers) do
                                        if (follower5 ~= follower1) and (follower5 ~= follower2) and (follower5 ~= follower3) and (follower5 ~= follower4) then
                                            table.insert(lineup, follower5)
                                            local highPriorityBatch = addon:createWorkBatch(3)
                                            addon:addWork(highPriorityBatch, function(missionID, lineup1, lineup2, lineup3, lineup4, lineup5)
                                                if not addon:isResultCacheGuaranteedFailure(missionID, lineup1, lineup2, lineup3, lineup4, lineup5) then
                                                    addon:addWork(highPriorityBatch, addon.arrangeAllFollowerPositions, addon, lineup1, lineup2, lineup3, lineup4, lineup5, missionID, report)
                                                    addon:addWork(highPriorityBatch, addon.setResultCacheGuaranteedFailure, addon, missionID, lineup1, lineup2, lineup3, lineup4, lineup5)
                                                end
                                            end, missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5])
                                            table.remove(lineup)
                                        end
                                    end
                                    table.remove(lineup)
                                end
                            end
                            table.remove(lineup)
                        end
                    end
                    table.remove(lineup)
                end
            end
            table.remove(lineup)
        end
    end)

    -- test 4 followers
    addon:addWork(batch, function()
        for _, follower1 in pairs(followers) do
            table.insert(lineup, follower1)
            for _, follower2 in pairs(followers) do
                if follower1 ~= follower2 then
                    table.insert(lineup, follower2)
                    for _, follower3 in pairs(followers) do
                        if (follower1 ~= follower3) and (follower2 ~= follower3) then
                            table.insert(lineup, follower3)
                            for _, follower4 in pairs(followers) do
                                if (follower4 ~= follower1) and (follower4 ~= follower2) and (follower4 ~= follower3) then
                                    testFollower(follower4, function(...)
                                        -- test the followers + 1 troop
                                        testEachTroop(...)
                                    end)
                                end
                            end
                            table.remove(lineup)
                        end
                    end
                    table.remove(lineup)
                end
            end
            table.remove(lineup)
        end
    end)
        
    -- test 3 followers
    addon:addWork(batch, function()
        for _, follower1 in pairs(followers) do
            table.insert(lineup, follower1)
            for _, follower2 in pairs(followers) do
                if follower1 ~= follower2 then
                    table.insert(lineup, follower2)
                    for _, follower3 in pairs(followers) do
                        if (follower1 ~= follower3) and (follower2 ~= follower3) then
                            testFollower(follower3, function(callback, batch)
                                -- test the followers + 1 troop
                                if (troopsSetting ~= "more") then
                                    testEachTroop(nil, batch)
                                end
                                
                                -- test the follower + 2 troops
                                testEachTroop(testEachTroop, batch)
                            end)
                        end
                    end
                    table.remove(lineup)
                end
            end
            table.remove(lineup)
        end
    end)
    
    -- test 2 followers
    addon:addWork(batch, function()
        for _, follower1 in pairs(followers) do
            table.insert(lineup, follower1)
            for _, follower2 in pairs(followers) do
                if follower1 ~= follower2 then
                    testFollower(follower2, function(callback, batch)
                        if troopsSetting ~= "more" then
                            -- test the followers + 1 troop
                            testEachTroop(nil, batch)
                        
                            -- test the follower + 2 troops
                            testEachTroop(testEachTroop, batch)
                        end
                
                        -- test the follower + 3 troops
                        testEachTroop(function(callback, batch) testEachTroop(testEachTroop, batch) end, batch)
                    end)
                end
            end
            table.remove(lineup)
        end
    end)
    
    addon:addWork(batch, function()
        for _, follower1 in pairs(followers) do
            table.insert(lineup, follower1)

            if not addon:isResultCacheGuaranteedFailure(missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5]) then
                local highPriorityBatch = addon:createWorkBatch(3)

                if troopsSetting ~= "more" then
                    -- test the follower + 1 troop
                    testEachTroop(nil, highPriorityBatch)
                    
                    -- test the follower + 2 troops
                    testEachTroop(testEachTroop, highPriorityBatch)
                    
                    -- test the follower + 3 troops
                    testEachTroop(function() testEachTroop(testEachTroop, highPriorityBatch) end, highPriorityBatch)
                end
                
                -- test the follower + 4 troops
                testEachTroop(function() testEachTroop(function() testEachTroop(testEachTroop, highPriorityBatch) end, highPriorityBatch) end, highPriorityBatch)
                
                addon:addWork(highPriorityBatch, addon.setResultCacheGuaranteedFailure, addon, missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5])
            end
            
            table.remove(lineup)
        end
    end)
    
    -- all combinations failed
    addon:addWork(batch, function()
        addon:clearWork()
        report({["defeats"] = 1, ["victories"] = 0})
    end)
    
    addon:unpauseWorker()
end

function addon:arrangeFollowerCombinationsByFewestFollowersPlusTroops(followers, missionID, callback, sortBy, troopsSetting)
    addon:pauseWorker()
    
    followers = addon:sortFollowers(followers, sortBy)
    
    local troop = {}
    troop[1] = C_Garrison.GetAutoTroops(123)[1].followerID
    troop[2] = C_Garrison.GetAutoTroops(123)[2].followerID 
    
    local lineup = {}
    
    local function report(results)
        addon:pauseWorker()
        callback(results)
        addon:unpauseWorker()
    end
    
    local batch = addon:createWorkBatch(4)
    
    local function testEachTroop(callback, highPriorityBatch)
        for troopType = 1, 2 do
            table.insert(lineup, troop[troopType])
            if callback then
                callback(nil, highPriorityBatch)
            else
                highPriorityBatch = highPriorityBatch or addon:createWorkBatch(3) 
                addon:addWork(highPriorityBatch, addon.arrangeAllFollowerPositions, addon, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5], missionID, report)
            end
            table.remove(lineup)
        end
    end
    
    local function testFollower(follower, callback)
        table.insert(lineup, follower)
        local highPriorityBatch = addon:createWorkBatch(3)
        
        if not addon:isResultCacheGuaranteedFailure(missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5]) then
            if (callback and (troopsSetting ~= "more")) or (not callback) then
                addon:addWork(highPriorityBatch, addon.arrangeAllFollowerPositions, addon, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5], missionID, report)
            end
            if callback then
                callback(nil, highPriorityBatch)
            end
            
            addon:addWork(highPriorityBatch, addon.setResultCacheGuaranteedFailure, addon, missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5])
        end
        table.remove(lineup)
    end
    
    addon:addWork(batch, function()
        for _, follower1 in pairs(followers) do
            table.insert(lineup, follower1)

            if not addon:isResultCacheGuaranteedFailure(missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5]) then
                local highPriorityBatch = addon:createWorkBatch(3)

                if troopsSetting ~= "more" then
                    -- test the follower + 1 troop
                    testEachTroop(nil, highPriorityBatch)
                    
                    -- test the follower + 2 troops
                    testEachTroop(testEachTroop, highPriorityBatch)
                    
                    -- test the follower + 3 troops
                    testEachTroop(function() testEachTroop(testEachTroop, highPriorityBatch) end, highPriorityBatch)
                end
                
                -- test the follower + 4 troops
                testEachTroop(function() testEachTroop(function() testEachTroop(testEachTroop, highPriorityBatch) end, highPriorityBatch) end, highPriorityBatch)
                
                addon:addWork(highPriorityBatch, addon.setResultCacheGuaranteedFailure, addon, missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5])
            end
            
            table.remove(lineup)
        end
    end)

    -- test 2 followers
    addon:addWork(batch, function()
        for i = 1, #followers do --_, follower1 in pairs(followers) do
            local follower1 = followers[i]
            table.insert(lineup, follower1)
            for j = (i+1), #followers do --_, follower2 in pairs(followers) do
                local follower2 = followers[j]
                testFollower(follower2, function(_, batch)
                    if troopsSetting ~= "more" then
                        -- test the followers + 1 troop
                        testEachTroop(nil, batch)
                    
                        -- test the follower + 2 troops
                        testEachTroop(testEachTroop, batch)
                    end
            
                    -- test the follower + 3 troops
                    testEachTroop(function(_, batch) testEachTroop(testEachTroop, batch) end, batch)
                end)
            end
            table.remove(lineup)
        end
    end)
        
    -- test 3 followers
    addon:addWork(batch, function()
        for i = 1, #followers do --_, follower1 in pairs(followers) do
            local follower1 = followers[i]
            table.insert(lineup, follower1)
            for j = (i+1), #followers do --_, follower2 in pairs(followers) do
                local follower2 = followers[j]
                table.insert(lineup, follower2)
                for k = (j+1), #followers do --_, follower3 in pairs(followers) do
                    local follower3 = followers[k]
                    testFollower(follower3, function(callback, batch)
                        -- test the followers + 1 troop
                        if (troopsSetting ~= "more") then
                            testEachTroop(nil, batch)
                        end
                        
                        -- test the follower + 2 troops
                        testEachTroop(testEachTroop, batch)
                    end)
                end
                table.remove(lineup)
            end
            table.remove(lineup)
        end
    end)
    
    -- test 4 followers
    addon:addWork(batch, function()
        for i = 1, #followers do --_, follower1 in pairs(followers) do
            local follower1 = followers[i]
            table.insert(lineup, follower1)
            for j = (i+1), #followers do --_, follower2 in pairs(followers) do
                local follower2 = followers[j]
                table.insert(lineup, follower2)
                for k = (j+1), #followers do --_, follower3 in pairs(followers) do
                    local follower3 = followers[k]
                    table.insert(lineup, follower3)
                    for l = (k+1), #followers do --_, follower4 in pairs(followers) do
                        local follower4 = followers[l]
                        testFollower(follower4, function(...)
                            -- test the followers + 1 troop
                            testEachTroop(...)
                        end)
                    end
                    table.remove(lineup)
                end
                table.remove(lineup)
            end
            table.remove(lineup)
        end
    end)
    
    -- test 5 followers
    addon:addWork(batch, function()
        for i = 1, #followers do --_, follower1 in pairs(followers) do
            local follower1 = followers[i]
            table.insert(lineup, follower1)
            for j = (i+1), #followers do --_, follower2 in pairs(followers) do
                local follower2 = followers[j]
                table.insert(lineup, follower2)
                for k = (j+1), #followers do --_, follower3 in pairs(followers) do
                    local follower3 = followers[k]
                    table.insert(lineup, follower3)
                    for l = (k+1), #followers do --_, follower4 in pairs(followers) do
                        local follower4 = followers[l]
                        table.insert(lineup, follower4)
                        for _, follower5 in pairs(followers) do
                            if (follower5 ~= follower1) and (follower5 ~= follower2) and (follower5 ~= follower3) and (follower5 ~= follower4) then
                                table.insert(lineup, follower5)
                                if not addon:isResultCacheGuaranteedFailure(missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5]) then
                                    local highPriorityBatch = addon:createWorkBatch(3)
                                    addon:addWork(highPriorityBatch, addon.arrangeAllFollowerPositions, addon, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5], missionID, report)
                                    addon:addWork(highPriorityBatch, addon.setResultCacheGuaranteedFailure, addon, missionID, lineup[1], lineup[2], lineup[3], lineup[4], lineup[5])
                                end
                                table.remove(lineup)
                            end
                        end
                        table.remove(lineup)
                    end
                    table.remove(lineup)
                end
                table.remove(lineup)
            end
            table.remove(lineup)
        end
    end)
                    
    -- all combinations failed
    addon:addWork(batch, function()
        addon:clearWork()
        report({["defeats"] = 1, ["victories"] = 0})
    end)
    
    addon:unpauseWorker()
end

