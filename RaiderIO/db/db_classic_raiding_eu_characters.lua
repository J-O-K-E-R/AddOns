--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={["name"]=...,["data"]=2,["region"]="eu",["date"]="2025-07-31T06:00:57Z",["numCharacters"]=46,["recordSizeInBytes"]=26,["encodingOrder"]={1,4},["currentRaids"]={{["id"]=6067,["mapId"]=996,["name"]="Terrace of Endless Spring",["shortName"]="ToES",["bossCount"]=4,["ordinal"]=1},{["id"]=6297,["mapId"]=1009,["name"]="Heart of Fear",["shortName"]="HOF",["bossCount"]=6,["ordinal"]=2},{["id"]=6125,["mapId"]=1008,["name"]="Mogu'shan Vaults",["shortName"]="MSV",["bossCount"]=6,["ordinal"]=3}},["previousRaids"]={},["db"]={}}
local F

F = function() provider.db["Golemagg"]={0,"Rohäc"} end F()
F = function() provider.db["Gehennas"]={26,"Palepally","Ragexd","Shockzey","Valamist"} end F()
F = function() provider.db["Firemaw"]={130,"Aergwyn","Kedrikx","Lolodina","Miljàn"} end F()
F = function() provider.db["PyrewoodVillage"]={234,"Caazblast","Caazmage","Caaztiv","Flickpriest","Flickshams","Kítten","Shamren"} end F()
F = function() provider.db["Everlook"]={416,"Béòrn","Kumihô","Yukårii"} end F()
F = function() provider.db["Venoxis"]={494,"Arguwar","Kuhano"} end F()
F = function() provider.db["Lakeshire"]={546,"Shambulánce"} end F()
F = function() provider.db["MirageRaceway"]={572,"Rëxxor"} end F()

F = nil
RaiderIO.AddProvider(provider)
