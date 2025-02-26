--
-- Copyright (c) 2025 by Ludicrous Speed, LLC
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2025-02-21T06:15:40Z",numCharacters=62,db={}}
local F

F = function() provider.db["PyrewoodVillage"]={0,"Amoebozoa","Auam","Elfren","Hordemain","Mossmaster","Roberino"} end F()
F = function() provider.db["Flamegor"]={12,"Лилантифриз"} end F()
F = function() provider.db["Auberdine"]={14,"Comburstion","Drips","Judgeret","Opey","Pakololz","Ærròr"} end F()
F = function() provider.db["Lakeshire"]={26,"Tâhrox"} end F()

F = nil
RaiderIO.AddProvider(provider)
