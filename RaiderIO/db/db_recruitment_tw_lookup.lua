--
-- Copyright (c) 2022 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2022-10-26T07:03:04Z",numCharacters=15063,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 14
F = function() provider.lookup[1] = "t\29\10\4t\29t\29t\29t\29t\29" end F()

F = nil
RaiderIO.AddProvider(provider)
