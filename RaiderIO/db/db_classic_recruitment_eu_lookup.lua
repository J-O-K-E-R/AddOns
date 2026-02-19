--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2026-02-18T06:09:01Z",numCharacters=45,lookup={},recordSizeInBytes=2,encodingOrder={0,1,3}}
local F

-- chunk size: 64
F = function() provider.lookup[1] = "\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\21\10\17\10\5\10\17\10\17\10\17\10\17\10\5\10\17\10\17\4\4" end F()

F = nil
RaiderIO.AddProvider(provider)
