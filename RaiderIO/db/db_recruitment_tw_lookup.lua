--
-- Copyright (c) 2023 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2023-02-14T07:42:39Z",numCharacters=38394,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 114
F = function() provider.lookup[1] = "?\13?\29?\29?\29?\29?\13?\29?\29?\29?\29?\29?\29;\4?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13?\13;\16<\13\2\4<\13;\8;\4\4\4<\13\5\4<\13<\13;\16<\13<\13?\9?\9?\9;\8;\16\128\6;\16;\16\14\8;\16;\4;\4" end F()

F = nil
RaiderIO.AddProvider(provider)
