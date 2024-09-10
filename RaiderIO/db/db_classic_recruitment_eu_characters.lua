--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2024-09-10T06:14:08Z",numCharacters=15,db={}}
local F

F = function() provider.db["MirageRaceway"]={0,"Daloon","Dýnem","Loneta","Sanshein","Taala","Veznik"} end F()
F = function() provider.db["Gehennas"]={12,"Gillgahr"} end F()
F = function() provider.db["Lakeshire"]={14,"Rizzina"} end F()

F = nil
RaiderIO.AddProvider(provider)
