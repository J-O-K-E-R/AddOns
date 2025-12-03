--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="us",date="2025-12-02T06:12:01Z",numCharacters=43,db={}}
local F

F = function() provider.db["Pagle"]={0,"Bussifistr","Daemonheart","Grizznos"} end F()
F = function() provider.db["Nazgrim"]={6,"Edinhunter"} end F()

F = nil
RaiderIO.AddProvider(provider)
