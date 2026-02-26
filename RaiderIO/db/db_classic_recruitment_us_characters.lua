--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2026-02-25T06:06:55Z",numCharacters=39,db={}}
local F

F = function() provider.db["Pagle"]={0,"Kísara","Reáven"} end F()

F = nil
RaiderIO.AddProvider(provider)
