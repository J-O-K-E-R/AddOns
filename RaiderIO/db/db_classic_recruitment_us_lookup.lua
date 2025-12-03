--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2025-12-02T06:12:01Z",numCharacters=43,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 8
F = function() provider.lookup[1] = "\10\13\10\13\10\13\4\4" end F()

F = nil
RaiderIO.AddProvider(provider)
