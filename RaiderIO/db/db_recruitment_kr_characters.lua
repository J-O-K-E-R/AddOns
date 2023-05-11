--
-- Copyright (c) 2023 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="kr",date="2023-05-11T08:19:41Z",numCharacters=34279,db={}}
local F

F = function() provider.db["아즈샤라"]={0,"Maxava","Maxxava"} end F()

F = nil
RaiderIO.AddProvider(provider)
