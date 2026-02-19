--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2026-02-18T06:09:01Z",numCharacters=45,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 26
F = function() provider.lookup[1] = "\10\9\10\9\4\4\10\9\10\9\10\9\4\4\10\9\10\9\10\9\10\9\10\9\10\9" end F()

F = nil
RaiderIO.AddProvider(provider)
