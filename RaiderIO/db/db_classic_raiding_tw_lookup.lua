--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={["name"]=...,["data"]=2,["region"]="tw",["date"]="2025-07-31T06:00:57Z",["numCharacters"]=46,["recordSizeInBytes"]=26,["encodingOrder"]={1,4},["currentRaids"]={{["id"]=6067,["mapId"]=996,["name"]="Terrace of Endless Spring",["shortName"]="ToES",["bossCount"]=4,["ordinal"]=1},{["id"]=6297,["mapId"]=1009,["name"]="Heart of Fear",["shortName"]="HOF",["bossCount"]=6,["ordinal"]=2},{["id"]=6125,["mapId"]=1008,["name"]="Mogu'shan Vaults",["shortName"]="MSV",["bossCount"]=6,["ordinal"]=3}},["previousRaids"]={},["lookup"]={}}
local F

F = function() provider.lookup[1] = "" end F()

F = nil
RaiderIO.AddProvider(provider)
