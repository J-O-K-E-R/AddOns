--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2024-10-22T06:15:28Z",numCharacters=115,db={}}
local F

F = function() provider.db["Arugal"]={0,"Careface","Chubs","Harrock"} end F()
F = function() provider.db["Faerlina"]={6,"Bethones"} end F()

F = nil
RaiderIO.AddProvider(provider)
