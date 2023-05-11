--
-- Copyright (c) 2023 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="kr",date="2023-05-11T08:19:41Z",numCharacters=34279,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 4
F = function() provider.lookup[1] = ";\8;\8" end F()

F = nil
RaiderIO.AddProvider(provider)
