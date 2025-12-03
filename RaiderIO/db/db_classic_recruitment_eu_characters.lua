--
-- Copyright (c) 2025 by RaiderIO, Inc.
-- All rights reserved.
--
local provider={name=...,data=3,region="eu",date="2025-12-02T06:12:01Z",numCharacters=43,db={}}
local F

F = function() provider.db["MirageRaceway"]={0,"Sanshein"} end F()
F = function() provider.db["Everlook"]={2,"Anyruok","Anýmonk","Anýrogue","Bélga","Xìania","Ânydk","Ânyrogue"} end F()
F = function() provider.db["Auberdine"]={16,"Agrou","Amelyss","Beurbz","Birbichette","Lihya","Lomyah","Nylâh","Pinocchio","Pylaf","Shalanore","Shaopao","Wabe","Ïllythras"} end F()
F = function() provider.db["Giantstalker"]={42,"Anaralia","Baldnutsack"} end F()
F = function() provider.db["Hoptallus"]={46,"Arizara","Drbuckshot","Feronya","Ludidoktor","Ludidoktorr","Ludidokttor","Nacugivara","Nazorathi","Nikotako","Noshecant","Palladan","Psyvise","Rualan"} end F()
F = function() provider.db["Flamegor"]={72,"Байрамов","Эритропоетин"} end F()
F = function() provider.db["Garalon"]={76,"Mcfat"} end F()

F = nil
RaiderIO.AddProvider(provider)
