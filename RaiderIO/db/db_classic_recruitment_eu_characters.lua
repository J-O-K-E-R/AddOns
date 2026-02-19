--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2026-02-18T06:09:01Z",numCharacters=45,db={}}
local F

F = function() provider.db["Everlook"]={0,"Bâînê","Büffelhüftè","Czarodejnica","Dosy","Drangosh","Draufgehn","Drride","Duisha","Hamulcvr","Hyriu","Jommey","Kaelthoras","Littentilly","Mallamalla","Molax","Naeq","Shokie","Siqras","Vylariana","Wildgulasch","Wildhearts","Wototem"} end F()
F = function() provider.db["Hoptallus"]={44,"Arizara","Drdottington","Eruveena","Feronya","Ludidoktor","Nikotako","Palladan","Psyvise","Rualan"} end F()
F = function() provider.db["MirageRaceway"]={62,"Leanaa"} end F()

F = nil
RaiderIO.AddProvider(provider)
