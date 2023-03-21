--
-- Copyright (c) 2023 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="kr",date="2023-02-14T07:42:39Z",numCharacters=38394,db={}}
local F

F = function() provider.db["데스윙"]={0,"죽음의전사내"} end F()

F = nil
RaiderIO.AddProvider(provider)
