--
-- Copyright (c) 2024 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2024-09-10T06:14:08Z",numCharacters=15,db={}}
local F

F = function() provider.db["Arugal"]={0,"Careface","Chubs","Harrock"} end F()
F = function() provider.db["Benediction"]={6,"Clutchkyro","Myboiblue"} end F()
F = function() provider.db["Faerlina"]={10,"Kicketh"} end F()
F = function() provider.db["Atiesh"]={12,"Elrith"} end F()

F = nil
RaiderIO.AddProvider(provider)
