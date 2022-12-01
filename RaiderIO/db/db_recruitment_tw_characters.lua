--
-- Copyright (c) 2022 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2022-12-01T07:59:30Z",numCharacters=8151,db={}}
local F

F = function() provider.db["暗影之月"]={0,"Virgil","娜雅妮","御煌","絕版小嗚"} end F()
F = function() provider.db["語風"]={8,"Gnomehowler"} end F()
F = function() provider.db["冰風崗哨"]={10,"盧十三","破日","美特菈"} end F()
F = function() provider.db["夜空之歌"]={16,"Alyssa","Hygieia","廣島胖丁","東京胖丁","眸眸"} end F()

F = nil
RaiderIO.AddProvider(provider)
