--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2025-03-05T07:29:11Z",numCharacters=32832,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 40
F = function() provider.lookup[1] = "?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29?\29" end F()

F = nil
RaiderIO.AddProvider(provider)
