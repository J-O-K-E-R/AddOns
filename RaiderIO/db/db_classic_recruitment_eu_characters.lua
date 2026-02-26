--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2026-02-25T06:06:55Z",numCharacters=39,db={}}
local F

F = function() provider.db["Everlook"]={0,"Bâînê","Büffelhüftè","Czarodejnica","Dosy","Drangosh","Draufgehn","Drride","Hamulcvr","Jommey","Kaelthoras","Littentilly","Mallamalla","Molax","Naeq","Shokie","Siqras","Vylariana","Wildgulasch","Wildhearts","Wototem"} end F()
F = function() provider.db["Hoptallus"]={40,"Arizara","Drdottington","Eruveena","Feronya","Ludidoktor","Ludidoktorr","Ludidokttor","Nacugivara","Nikotako","Noshecant","Psyvise","Rualan"} end F()
F = function() provider.db["Norushen"]={64,"Doybear","Dythu","Synomnomnom","Taibalt"} end F()
F = function() provider.db["Garalon"]={72,"Nylock"} end F()

F = nil
RaiderIO.AddProvider(provider)
