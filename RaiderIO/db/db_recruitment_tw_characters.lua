--
-- Copyright (c) 2022 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="tw",date="2022-10-26T07:03:04Z",numCharacters=15063,db={}}
local F

F = function() provider.db["暗影之月"]={0,"Laxus","Spades","小青貚","緋鳳輓歌"} end F()
F = function() provider.db["眾星之子"]={8,"緋雪夜嵐","雪夜鶯歌"} end F()
F = function() provider.db["語風"]={12,"Lonelys"} end F()

F = nil
RaiderIO.AddProvider(provider)
