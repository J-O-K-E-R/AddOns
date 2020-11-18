local E, L, V, P, G, _ =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local lastPanel
local displayString = "---"
local _hex
local Lang = GetLocale()
local red = "|cffc74040"
local orange = "|cffda8c4f"
local version = GetAddOnMetadata("ElvUI_CurrenciesDatatext", "Version")

local currencies = {
--		[1155] = true, 
1155, 1275, 1299, 1356, 1357, 1355, 1342, 1226, 1220, 1273, 1154, 1149, 1268,	-- Legion
823, 944, 980, 824, 1101, 1129, 994, 											-- Warlords of Draenor - 1
614, 615, 1166, 1191, 															-- Dungeon & Raid - 8
390, 392, 391, 																	-- Player v. Player - 12
789, 697, 738, 752, 777, 776, 													-- Mists of Pandaria - 15
361, 																			-- Cataclysm - 21
241, 61, 515, 81, 402, 416, 													-- Miscellaneous - 22
384, 398, 393, 394, 400, 397, 401, 385, 399, 754, 676, 677, 829, 821, 828} 		-- Archaeology - 28

local elvProfileDB = ElvPrivateDB["profiles"][E.myname.." - "..E.myrealm]
if elvProfileDB["ElvUI_Currencies"] ~= nil then
	local s = elvProfileDB["ElvUI_Currencies"]["setup_complete"]
	if s or s ~= nil then
		if ElvCharacterDB["ElvUI_Currencies"]["locale"] ~= Lang then
			ElvCharacterDB["ElvUI_Currencies"] = {}
		else
			ElvCharacterDB["ElvUI_Currencies"] = ElvCharacterDB["ElvUI_Currencies"] or {}
		end
		-- misc
		ElvCharacterDB["ElvUI_Currencies"]["icons"]  = elvProfileDB["ElvUI_Currencies"]["icons"] or true 
		ElvCharacterDB["ElvUI_Currencies"]["hidett"] = elvProfileDB["ElvUI_Currencies"]["hidett"] or false
		-- headers
		ElvCharacterDB["ElvUI_Currencies"]["Legion"] = elvProfileDB["ElvUI_Currencies"][L["Legion"]]["visible"] or false 
		ElvCharacterDB["ElvUI_Currencies"]["WoD"]    = elvProfileDB["ElvUI_Currencies"][L["WoD"]]["visible"] or false 
		ElvCharacterDB["ElvUI_Currencies"]["D&R"]    = elvProfileDB["ElvUI_Currencies"][L["D&R"]]["visible"] or false
		ElvCharacterDB["ElvUI_Currencies"]["PvP"]    = elvProfileDB["ElvUI_Currencies"][L["PvP"]]["visible"] or false 
		ElvCharacterDB["ElvUI_Currencies"]["MoP"]    = elvProfileDB["ElvUI_Currencies"][L["MoP"]]["visible"]  or false
		ElvCharacterDB["ElvUI_Currencies"]["Cata"]   = elvProfileDB["ElvUI_Currencies"][L["Cata"]]["visible"] or false
		ElvCharacterDB["ElvUI_Currencies"]["Misc"]   = elvProfileDB["ElvUI_Currencies"][L["Misc"]]["visible"] or false
		ElvCharacterDB["ElvUI_Currencies"]["Arch"]   = elvProfileDB["ElvUI_Currencies"][L["Arch"]]["visible"] or false
		-- currencies
		-- legion
		ElvCharacterDB["ElvUI_Currencies"][1155]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1155]["visible"]  or true -- Ancient Mana
		ElvCharacterDB["ElvUI_Currencies"][1275]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1275]["visible"]  or true -- Curious Coin
		ElvCharacterDB["ElvUI_Currencies"][1299]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1299]["visible"]  or true -- Brawler's Gold
		ElvCharacterDB["ElvUI_Currencies"][1356]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1356]["visible"]  or true -- Echoes of Battle
		ElvCharacterDB["ElvUI_Currencies"][1357]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1357]["visible"]  or true -- Echoes of Domination
		ElvCharacterDB["ElvUI_Currencies"][1355]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1355]["visible"]  or true -- Felessence
		ElvCharacterDB["ElvUI_Currencies"][1342]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1342]["visible"]  or true -- Legionfall War Supplies
		ElvCharacterDB["ElvUI_Currencies"][1226]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1226]["visible"]  or true -- Nethershard
		ElvCharacterDB["ElvUI_Currencies"][1220]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1220]["visible"]  or true -- Order Resources
		ElvCharacterDB["ElvUI_Currencies"][1273]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1273]["visible"]  or true -- Seal of Broken fate
		ElvCharacterDB["ElvUI_Currencies"][1154]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1154]["visible"]  or true -- Shadowy Coin
		ElvCharacterDB["ElvUI_Currencies"][1149]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1149]["visible"]  or true -- Sightless Eye
		ElvCharacterDB["ElvUI_Currencies"][1268]  = elvProfileDB["ElvUI_Currencies"][L["Legion"]][1268]["visible"]  or true -- Timeworn Artifact
		-- wod
		ElvCharacterDB["ElvUI_Currencies"][823]  = elvProfileDB["ElvUI_Currencies"][L["WoD"]][823]["visible"]  or true -- Apexis Crystal
		ElvCharacterDB["ElvUI_Currencies"][944]  = elvProfileDB["ElvUI_Currencies"][L["WoD"]][944]["visible"]  or true -- Artifact Fragment
		ElvCharacterDB["ElvUI_Currencies"][980]  = elvProfileDB["ElvUI_Currencies"][L["WoD"]][980]["visible"]  or true -- Dingy Iron Coins
		ElvCharacterDB["ElvUI_Currencies"][824]  = elvProfileDB["ElvUI_Currencies"][L["WoD"]][824]["visible"]  or true -- Garrison Resources
		ElvCharacterDB["ElvUI_Currencies"][1101] = elvProfileDB["ElvUI_Currencies"][L["WoD"]][1101]["visible"] or true -- Oil
		ElvCharacterDB["ElvUI_Currencies"][1129] = elvProfileDB["ElvUI_Currencies"][L["WoD"]][1129]["visible"] or true -- Seal of Inevitable Fate
		ElvCharacterDB["ElvUI_Currencies"][994]  = elvProfileDB["ElvUI_Currencies"][L["WoD"]][994]["visible"]  or true -- Seal of Tempered Fate
		-- d&r
		ElvCharacterDB["ElvUI_Currencies"][1166] = elvProfileDB["ElvUI_Currencies"][L["D&R"]][1166]["visible"] or true -- Timewarped Badge
		ElvCharacterDB["ElvUI_Currencies"][1191] = elvProfileDB["ElvUI_Currencies"][L["D&R"]][1191]["visible"] or true -- Valor
		-- pvp
--		ElvCharacterDB["ElvUI_Currencies"][390]  = elvProfileDB["ElvUI_Currencies"][L["PvP"]][390]["visible"]  or true -- Conquest Points
--		ElvCharacterDB["ElvUI_Currencies"][392]  = elvProfileDB["ElvUI_Currencies"][L["PvP"]][392]["visible"]  or true -- Honor Points
		ElvCharacterDB["ElvUI_Currencies"][391]  = elvProfileDB["ElvUI_Currencies"][L["PvP"]][391]["visible"]  or true -- Tol Barad Commendation
		-- mop
		ElvCharacterDB["ElvUI_Currencies"][789]  = elvProfileDB["ElvUI_Currencies"][L["MoP"]][789]["visible"]  or true -- Bloody Coin
		ElvCharacterDB["ElvUI_Currencies"][697]  = elvProfileDB["ElvUI_Currencies"][L["MoP"]][697]["visible"]  or true -- Elder Charm of Good Fortune
		ElvCharacterDB["ElvUI_Currencies"][738]  = elvProfileDB["ElvUI_Currencies"][L["MoP"]][738]["visible"]  or true -- Lesser Charm of Good Fortune
		ElvCharacterDB["ElvUI_Currencies"][752]  = elvProfileDB["ElvUI_Currencies"][L["MoP"]][752]["visible"]  or true -- Mogu Rune of Fate
		ElvCharacterDB["ElvUI_Currencies"][777]  = elvProfileDB["ElvUI_Currencies"][L["MoP"]][777]["visible"]  or true -- Timeless Coin
		ElvCharacterDB["ElvUI_Currencies"][776]  = elvProfileDB["ElvUI_Currencies"][L["MoP"]][776]["visible"]  or true -- Warforged Seal
		-- cata
		ElvCharacterDB["ElvUI_Currencies"][615]  = elvProfileDB["ElvUI_Currencies"][L["D&R"]][615]["visible"]  or true -- Essence of Corrupted Deathwing
		ElvCharacterDB["ElvUI_Currencies"][614]  = elvProfileDB["ElvUI_Currencies"][L["D&R"]][614]["visible"]  or true -- Mote of Darkness
		ElvCharacterDB["ElvUI_Currencies"][361]  = elvProfileDB["ElvUI_Currencies"][L["Cata"]][361]["visible"] or true -- Illustrious Jewelcrafter's Token
		ElvCharacterDB["ElvUI_Currencies"][416]  = elvProfileDB["ElvUI_Currencies"][L["Misc"]][416]["visible"] or true -- Mark of the World Tree
		-- wotlk
		ElvCharacterDB["ElvUI_Currencies"][241]  = elvProfileDB["ElvUI_Currencies"][L["Misc"]][241]["visible"] or true -- Champion's Seal
		ElvCharacterDB["ElvUI_Currencies"][61]   = elvProfileDB["ElvUI_Currencies"][L["Misc"]][61]["visible"]  or true -- Dalaran Jewelcrafter's Token
		-- misc
		ElvCharacterDB["ElvUI_Currencies"][515]  = elvProfileDB["ElvUI_Currencies"][L["Misc"]][515]["visible"] or true -- Darkmoon Prize Ticket
		ElvCharacterDB["ElvUI_Currencies"][81]   = elvProfileDB["ElvUI_Currencies"][L["Misc"]][81]["visible"]  or true -- Epicurean's Award
		ElvCharacterDB["ElvUI_Currencies"][402]  = elvProfileDB["ElvUI_Currencies"][L["Misc"]][402]["visible"] or true -- Ironpaw Token
		-- arch
		ElvCharacterDB["ElvUI_Currencies"][384]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][384]["visible"] or true -- Dwarf Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][398]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][398]["visible"] or true -- Draenei Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][393]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][393]["visible"] or true -- Fossil Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][400]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][400]["visible"] or true -- Nerubian Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][394]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][394]["visible"] or true -- Night Elf Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][397]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][397]["visible"] or true -- Orc Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][401]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][401]["visible"] or true -- Tol'vir Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][385]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][385]["visible"] or true -- Troll Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][399]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][399]["visible"] or true -- Vrykul Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][754]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][754]["visible"] or true -- Mantid Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][677]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][677]["visible"] or true -- Mogu Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][676]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][676]["visible"] or true -- Pandaren Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][829]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][829]["visible"] or true -- Arakkoa Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][821]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][821]["visible"] or true -- Draenor Clans Archaeology Fragment
		ElvCharacterDB["ElvUI_Currencies"][828]  = elvProfileDB["ElvUI_Currencies"][L["Arch"]][828]["visible"] or true -- Ogre Archaeology Fragment
		-- clean-up
		elvProfileDB["ElvUI_Currencies"][L["WoD"]]  = nil
		elvProfileDB["ElvUI_Currencies"][L["D&R"]]  = nil
		elvProfileDB["ElvUI_Currencies"][L["PvP"]]  = nil
		elvProfileDB["ElvUI_Currencies"][L["MoP"]]  = nil
		elvProfileDB["ElvUI_Currencies"][L["Cata"]] = nil
		elvProfileDB["ElvUI_Currencies"][L["Misc"]] = nil
		elvProfileDB["ElvUI_Currencies"][L["Arch"]] = nil
		elvProfileDB["ElvUI_Currencies"]["setup_complete"] = nil
		elvProfileDB["ElvUI_Currencies"]["locale"] = nil
		ElvPrivateDB["profiles"][E.myname.." - "..E.myrealm]["ElvUI_Currencies"] = nil
	end
	ElvPrivateDB["profiles"][E.myname.." - "..E.myrealm]["ElvUI_Currencies"] = nil
end

if not ElvCharacterDB["ElvUI_Currencies"] then
	ElvCharacterDB["ElvUI_Currencies"] = {}
end

V["ElvUI_Currencies"] = {
	-- misc
	["icons"] = true,
	["hidett"] = false,
	-- headers
	["Legion"] = false,
	["WoD"] = false,
	["D&R"] = false,
	["PvP"] = false,
	["MoP"] = false,
	["Cata"] = false,
	["Misc"] = false,
	["Arch"] = false,
	-- currencies
	[1155] = true, -- Ancient Mana, 1155
	[1275] = true, -- Curious Coin, 1275
	[1299] = true, -- Brawlers Gold, 1299
	[1356] = true, -- Echoes of Battle, 1356
	[1357] = true, -- Echoes of Domination, 1357
	[1355] = true, -- Felessence, 1355
	[1342] = true, -- Legionfall War Supplies, 1342
	[1226] = true, -- Nethershard, 1226
	[1220] = true, -- Order Resources, 1220
	[1273] = true, -- Seal of Broken Fate, 1273
	[1154] = true, -- Shadowy Coins, 1154
	[1149] = true, -- Sightless Eye, 1149
	[1268] = true, -- Timeworn Artifact, 1268
	
	[823] = true, -- Apexis Crystal
	[944] = true, -- Artifact Fragment
	[980] = true, -- Dingy Iron Coins
	[824] = true, -- Garrison Resources
	[1101] = true, -- Oil
	[1129] = true, -- Seal of Inevitable Fate
	[994] = true, -- Seal of Tempered Fate
	[615] = true, -- Essence of Corrupted Deathwing
	[614] = true, -- Mote of Darkness
	[1166] = true, -- Timewarped Badge
	[1191] = true, -- Valor
	[390] = true, -- Conquest Points
	[392] = true, -- Honor Points
	[391] = true, -- Tol Barad Commendation
	[789] = true, -- Bloody Coin
	[697] = true, -- Elder Charm of Good Fortune
	[738] = true, -- Lesser Charm of Good Fortune
	[752] = true, -- Mogu Rune of Fate
	[777] = true, -- Timeless Coin
	[776] = true, -- Warforged Seal
	[361] = true, -- Illustrious Jewelcrafter's Token
	[241] = true, -- Champion's Seal
	[61] = true, -- Dalaran Jewelcrafter's Token
	[515] = true, -- Darkmoon Prize Ticket
	[81] = true, -- Epicurean's Award
	[402] = true, -- Ironpaw Token
	[416] = true, -- Mark of the World Tree
	[384] = true, -- Dwarf Archaeology Fragment
	[398] = true, -- Draenei Archaeology Fragment
	[393] = true, -- Fossil Archaeology Fragment
	[400] = true, -- Nerubian Archaeology Fragment
	[394] = true, -- Night Elf Archaeology Fragment
	[397] = true, -- Orc Archaeology Fragment
	[401] = true, -- Tol'vir Archaeology Fragment
	[385] = true, -- Troll Archaeology Fragment
	[399] = true, -- Vrykul Archaeology Fragment
	[754] = true, -- Mantid Archaeology Fragment
	[677] = true, -- Mogu Archaeology Fragment
	[676] = true, -- Pandaren Archaeology Fragment
	[829] = true, -- Arakkoa Archaeology Fragment
	[821] = true, -- Draenor Clans Archaeology Fragment
	[828] = true, -- Ogre Archaeology Fragment
}

StaticPopupDialogs["translatorsNeeded"] = {
	text = "To give full localization-support,\nI'm looking for translators for the following languages:\n \nChinese (zhCN), Korean (koKR),\nRussian (ruRU), Taiwanese (zhTW)\n \nIf you speak one or more of these languages fluently as well as English, please file an \"Enchancement\"-ticket at:",
	button1 = "Close",
	hasEditBox = 1,
	maxLetters = 120,
	editBoxWidth = 350,
	OnShow = function (self, data)
		self.editBox:SetText("http://www.wowace.com/addons/elvui-currencies-datatext/create-ticket/")
		self.editBox:SetFocus()
		self.editBox:HighlightText()
	end,
	OnAccept = function() StaticPopup_Hide(self) end,
	hasEditBox = true,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["CurrenciesReloadUI"] = {
	text = L["AskReloadNow"],
	button1 = L["Okay"],
	button2 = L["Cancel"],
	OnAccept = function() ReloadUI(); end,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["CurrenciesReset"] = {
	text = L["ResetConfirm"],
	button1 = L["Yes"],
	button2 = L["Cancel"],
	OnAccept = function() ResetCurrencies() end,
	timeout = 0,
	whileDead = false,
	hideOnEscape = true,
	preferredIndex = 3,
}

local function ToggleOption(name)
	if ElvCharacterDB["ElvUI_Currencies"][name] then
		ElvCharacterDB["ElvUI_Currencies"][name] = false
	else
		ElvCharacterDB["ElvUI_Currencies"][name] = true
	end
end

local function GetOption(name)
	if ElvCharacterDB["ElvUI_Currencies"][name] then
		return ElvCharacterDB["ElvUI_Currencies"][name]
	end
end

local menu = {
	{ text = L["menu header"], isTitle = true , notCheckable = true },
	{ text = L["Legion"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show Legion Currencies"], checked = function() return GetOption("Legion") end, func = function() ToggleOption("Legion") end },
			{ text = ' - '..L["Show"]..' '..L["Ancient Mana"], checked = function() return GetOption(1155) end, func = function() ToggleOption(1155) end },
			{ text = ' - '..L["Show"]..' '..L["Curious Coin"], checked = function() return GetOption(1275) end, func = function() ToggleOption(1275) end },
			{ text = ' - '..L["Show"]..' '..L["Bralwer's Gold"], checked = function() return GetOption(1299) end, func = function() ToggleOption(1299) end },
			{ text = ' - '..L["Show"]..' '..L["Echoes of Battle"], checked = function() return GetOption(1356) end, func = function() ToggleOption(1356) end },
			{ text = ' - '..L["Show"]..' '..L["Echoes of Domination"], checked = function() return GetOption(1357) end, func = function() ToggleOption(1357) end },
			{ text = ' - '..L["Show"]..' '..L["Felessence"], checked = function() return GetOption(1355) end, func = function() ToggleOption(1355) end },
			{ text = ' - '..L["Show"]..' '..L["Legionfall War Supplies"], checked = function() return GetOption(1342) end, func = function() ToggleOption(1342) end },
			{ text = ' - '..L["Show"]..' '..L["Nethershard"], checked = function() return GetOption(1226) end, func = function() ToggleOption(1226) end },
			{ text = ' - '..L["Show"]..' '..L["Order Resources"], checked = function() return GetOption(1220) end, func = function() ToggleOption(1220) end },
			{ text = ' - '..L["Show"]..' '..L["Seal of Broken Fate"], checked = function() return GetOption(1273) end, func = function() ToggleOption(1273) end },
			{ text = ' - '..L["Show"]..' '..L["Shadowy Coins"], checked = function() return GetOption(1154) end, func = function() ToggleOption(1154) end },
			{ text = ' - '..L["Show"]..' '..L["Sightless Eye"], checked = function() return GetOption(1149) end, func = function() ToggleOption(1149) end },
			{ text = ' - '..L["Show"]..' '..L["Timeworn Artifact"], checked = function() return GetOption(1268) end, func = function() ToggleOption(1268) end },
        } 
    },
	{ text = L["WoD"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show WoD Currencies"], checked = function() return GetOption("WoD") end, func = function() ToggleOption("WoD") end },
			{ text = ' - '..L["Show"]..' '..L["Apexis Crystal"], checked = function() return GetOption(823) end, func = function() ToggleOption(823) end },
			{ text = ' - '..L["Show"]..' '..L["Artifact Fragment"], checked = function()  return GetOption(944) end, func = function() ToggleOption(944) end },
			{ text = ' - '..L["Show"]..' '..L["Dingy Iron Coins"], checked = function() return GetOption(980) end, func = function() ToggleOption(980) end },
			{ text = ' - '..L["Show"]..' '..L["Garrison Resources"], checked = function() return GetOption(824) end, func = function() ToggleOption(824) end },
			{ text = ' - '..L["Show"]..' '..L["Oil"], checked = function() return GetOption(1101) end, func = function() ToggleOption(1101) end },
			{ text = ' - '..L["Show"]..' '..L["Seal of Tempered Fate"], checked = function() return GetOption(994) end, func = function() ToggleOption(994) end },
			{ text = ' - '..L["Show"]..' '..L["Seal of Inevitable Fate"], checked = function() return GetOption(1129) end, func = function() ToggleOption(1129) end },
        } 
    },
	{ text = L["D&R"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show D&R Currencies"], checked = function() return GetOption("D&R") end, func = function() ToggleOption("D&R") end },
			{ text = ' - '..L["Show"]..' '..L["Mote of Darkness"], checked = function() return GetOption(614) end, func = function() ToggleOption(614) end },
			{ text = ' - '..L["Show"]..' '..L["Essence of Corrupted Deathwing"], checked = function()  return GetOption(615) end, func = function() ToggleOption(615) end },
			{ text = ' - '..L["Show"]..' '..L["Timewarped Badge"], checked = function() return GetOption(1166) end, func = function() ToggleOption(1166) end },
			{ text = ' - '..L["Show"]..' '..L["Valor"], checked = function() return GetOption(1191) end, func = function() ToggleOption(1191) end },
		}
	},
	{ text = L["PvP"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show PvP Currencies"], checked = function() return GetOption("PvP") end, func = function() ToggleOption("PvP") end },
--			{ text = ' - '..L["Show"]..' '..L["Conquest Points"], checked = function() return GetOption(390) end, func = function() ToggleOption(390) end },
			{ text = ' - '..L["Show"]..' '..L["Tol Barad Commendation"], checked = function() return GetOption(391) end, func = function() ToggleOption(391) end },
--			{ text = ' - '..L["Show"]..' '..L["Honor Points"], checked = function() return GetOption(392) end, func = function() ToggleOption(392) end },
		}
	},
	{ text = L["MoP"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show MoP Currencies"], checked = function() return GetOption("MoP") end, func = function() ToggleOption("MoP") end },
			{ text = ' - '..L["Show"]..' '..L["Bloody Coin"], checked = function() return GetOption(789) end, func = function() ToggleOption(789) end },
			{ text = ' - '..L["Show"]..' '..L["Elder Charm of Good Fortune"], checked = function() return GetOption(697) end, func = function() ToggleOption(697) end },
			{ text = ' - '..L["Show"]..' '..L["Lesser Charm of Good Fortune"], checked = function() return GetOption(738) end, func = function() ToggleOption(738) end },
			{ text = ' - '..L["Show"]..' '..L["Mogu Rune of Fate"], checked = function() return GetOption(752) end, func = function() ToggleOption(752) end },
			{ text = ' - '..L["Show"]..' '..L["Timeless Coin"], checked = function() return GetOption(777) end, func = function() ToggleOption(777) end },
			{ text = ' - '..L["Show"]..' '..L["Warforged Seal"], checked = function() return GetOption(776) end, func = function() ToggleOption(776) end },
		}
	},
	{ text = L["Cata"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show Cata Currencies"], checked = function() return GetOption("Cata") end, func = function() ToggleOption("Cata") end },
			{ text = ' - '..L["Show"]..' '..L["Illustrious Jewelcrafter's Token"], checked = function() return GetOption(361) end, func = function() ToggleOption(361) end },	
		}
	},
	{ text = L["Misc"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show Misc Currencies"], checked = function() return GetOption("Misc") end, func = function() ToggleOption("Misc") end },
			{ text = ' - '..L["Show"]..' '..L["Champion's Seal"], checked = function() return GetOption(241) end, func = function() ToggleOption(241) end },
			{ text = ' - '..L["Show"]..' '..L["Dalaran Jewelcrafter's Token"], checked = function() return GetOption(61) end, func = function() ToggleOption(61) end },
			{ text = ' - '..L["Show"]..' '..L["Darkmoon Prize Ticket"], checked = function() return GetOption(515) end, func = function() ToggleOption(515) end },
			{ text = ' - '..L["Show"]..' '..L["Epicurean's Award"], checked = function() return GetOption(81) end, func = function() ToggleOption(81) end },
			{ text = ' - '..L["Show"]..' '..L["Ironpaw Token"], checked = function() return GetOption(402) end, func = function() ToggleOption(402) end },
			{ text = ' - '..L["Show"]..' '..L["Mark of the World Tree"], checked = function() return GetOption(416) end, func = function() ToggleOption(416) end },
		}
	},
	{ text = L["Arch"], hasArrow = true, notCheckable = true,
        menuList = {
			{ text = L["Show Arch Fragments"], checked = function() return GetOption("Arch") end, func = function() ToggleOption("Arch") end },
			{ text = ' - '..L["Show"]..' '..L["Dwarf Archaeology Fragment"], checked = function() return GetOption(384) end, func = function() ToggleOption(384) end },
			{ text = ' - '..L["Show"]..' '..L["Draenei Archaeology Fragment"], checked = function() return GetOption(398) end, func = function() ToggleOption(398) end },
			{ text = ' - '..L["Show"]..' '..L["Fossil Archaeology Fragment"], checked = function() return GetOption(393) end, func = function() ToggleOption(393) end },
			{ text = ' - '..L["Show"]..' '..L["Night Elf Archaeology Fragment"], checked = function() return GetOption(394) end, func = function() ToggleOption(394) end },
			{ text = ' - '..L["Show"]..' '..L["Nerubian Archaeology Fragment"], checked = function() return GetOption(400) end, func = function() ToggleOption(400) end },
			{ text = ' - '..L["Show"]..' '..L["Orc Archaeology Fragment"], checked = function() return GetOption(397) end, func = function() ToggleOption(397) end },
			{ text = ' - '..L["Show"]..' '..L["Tol\'vir Archaeology Fragment"], checked = function() return GetOption(401) end, func = function() ToggleOption(401) end },
			{ text = ' - '..L["Show"]..' '..L["Troll Archaeology Fragment"], checked = function() return GetOption(385) end, func = function() ToggleOption(385) end },
			{ text = ' - '..L["Show"]..' '..L["Vrykul Archaeology Fragment"], checked = function() return GetOption(399) end, func = function() ToggleOption(399) end },
			{ text = ' - '..L["Show"]..' '..L["Mantid Archaeology Fragment"], checked = function() return GetOption(754) end, func = function() ToggleOption(754) end },
			{ text = ' - '..L["Show"]..' '..L["Pandaren Archaeology Fragment"], checked = function() return GetOption(676) end, func = function() ToggleOption(676) end },
			{ text = ' - '..L["Show"]..' '..L["Mogu Archaeology Fragment"], checked = function() return GetOption(677) end, func = function() ToggleOption(677) end },
			{ text = ' - '..L["Show"]..' '..L["Arakkoa Archaeology Fragment"], checked = function() return GetOption(829) end, func = function() ToggleOption(829) end },
			{ text = ' - '..L["Show"]..' '..L["Draenor Clans Archaeology Fragment"], checked = function() return GetOption(821) end, func = function() ToggleOption(821) end },
			{ text = ' - '..L["Show"]..' '..L["Ogre Archaeology Fragment"], checked = function() return GetOption(828) end, func = function() ToggleOption(828) end },
		}
	},
	{ text = L["Show Icons"], checked = function() return GetOption("icons") end, func = function() ToggleOption("icons") end },
	{ text = L["Hide TT"], checked = function() return GetOption("hidett") end, func = function() ToggleOption("hidett") end },
	{ text = " ", isTitle = true , notCheckable = true },
	{ text = "I need translators, click for info.", notCheckable = true, func = function() StaticPopup_Show("translatorsNeeded") end },
}
local menuFrame = CreateFrame("Frame", "ElvUI_CurrenciesDatatextMenuFrame", E.UIParent, 'UIDropDownMenuTemplate')

local function ColorValue(cap, currency)
	local color, percent
	if cap ~= 0 then
		percent = currency * (100 / cap)
	else
		percent = 0
	end
	if percent < 70 then color = _hex
	elseif percent >= 70 and percent < 90 then color = orange
	elseif percent >= 90 then color = red end
	if cap == 0 then return _hex
	else return color end 
	return _hex
end

local function OnEvent(self, event, ...)
	lastPanel = self
	local _text = "---"
	local name, count, icon, earnedThisWeek, weeklyMax, totalMax, isDiscovered
	if not _hex then return end
	for i = 1, #(currencies) do
		if i == 1 then displayString = '' end
		local index = currencies[i]
		--local name, count, icon, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(index)
		local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(index)
	    if currencyInfo ~= nil then
	      	name = currencyInfo.name
	      	count = currencyInfo.quantity
	      	icon = currencyInfo.iconFileID
	     	earnedThisWeek = currencyInfo.quantityEarnedThisWeek
	      	weeklyMax = currencyInfo.maxWeeklyQuantity
	      	totalMax = currencyInfo.maxQuantity
	      	isDiscovered = currencyInfo.discovered
			if isDiscovered then
				if(i ~= 1) then _text = "  " else _text = "" end
				local texture = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', icon)
				if index == 1155 and (GetOption(1155) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1275 and (GetOption(1275) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				
				if index == 1299 and (GetOption(1299) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1356 and (GetOption(1356) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1357 and (GetOption(1357) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1355 and (GetOption(1355) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1342 and (GetOption(1342) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end

				if index == 1226 and (GetOption(1226) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1220 and (GetOption(1220) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1273 and (GetOption(1273) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1154 and (GetOption(1154) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1149 and (GetOption(1149) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1268 and (GetOption(1268) and GetOption("Legion")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end

				if index == 823 and (GetOption(823) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 944 and (GetOption(944) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 980 and (GetOption(980) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 824 and (GetOption(824) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1101 and (GetOption(1101) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1129 and (GetOption(1129) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 994 and (GetOption(994) and GetOption("WoD")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 614 and (GetOption(614) and GetOption("D&R")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 615 and (GetOption(615) and GetOption("D&R")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1166 and (GetOption(1166) and GetOption("D&R")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 1191 and (GetOption(1191) and GetOption("D&R")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 390 and (GetOption(390) and GetOption("PvP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(weeklyMax, earnedThisWeek)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 392 and (GetOption(392) and GetOption("PvP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 391 and (GetOption(391) and GetOption("PvP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 789 and (GetOption(789) and GetOption("MoP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 697 and (GetOption(697) and GetOption("MoP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 738 and (GetOption(738) and GetOption("MoP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 752 and (GetOption(752) and GetOption("MoP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 777 and (GetOption(777) and GetOption("MoP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 776 and (GetOption(776) and GetOption("MoP")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 361 and (GetOption(361) and GetOption("Cata")) then 
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 241 and (GetOption(241) and GetOption("Misc")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 61 and (GetOption(61) and GetOption("Misc")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 515 and (GetOption(515) and GetOption("Misc")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 81 and (GetOption(81) and GetOption("Misc")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 402 and (GetOption(402) and GetOption("Misc")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 416 and (GetOption(416) and GetOption("Misc")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 384 and (GetOption(384) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 398 and (GetOption(398) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 393 and (GetOption(393) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 394 and (GetOption(394) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 400 and (GetOption(400) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 397 and (GetOption(397) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 401 and (GetOption(401) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 385 and (GetOption(385) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 399 and (GetOption(399) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 754 and (GetOption(754) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 676 and (GetOption(676) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 677 and (GetOption(677) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 829 and (GetOption(829) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 821 and (GetOption(821) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
				if index == 828 and (GetOption(828) and GetOption("Arch")) then
					local str
					if GetOption("icons") then
						str = tostring(_text..texture..":"..ColorValue(totalMax, count)..count.."|r")
					else
						words = { strsplit(" ", name) }
						for _, word in ipairs(words) do _text = _text..string.sub(word,1,1) end
						str = tostring(_text..":"..ColorValue(totalMax, count)..count.."|r")
					end
					displayString = displayString..str
				end
			end
		end
	end	
	if self then
		if displayString == '' or (not GetOption("Legion") and not GetOption("WoD") and not GetOption("D&R") and not GetOption("PvP") and not GetOption("MoP") and not GetOption("Cata") and not GetOption("Misc") and not GetOption("Arch")) then 
			displayString = tostring("ElvUI ".._hex..L["Currencies"].."|r") end
		self.text:SetFormattedText(displayString)
	end
end

local function getCurinfo(curID)
	local Name, Amount, Icon, WeeklyEarned, WeeklyMax, TotalMax, IsDiscovered = GetCurrencyInfo(curID)
	return {Name, Icon, Amount, WeeklyEarned, WeeklyMax, TotalMax, IsDiscovered}
end		

local function OnEnter(self)
	local hideTT = ElvCharacterDB["ElvUI_Currencies"]["hidett"]
	if hideTT then
		DT.tooltip:Hide()
	else
		local r1, g1, b1, r2, g2, b2 = HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b;
		DT:SetupTooltip(self)
		if UnitLevel('player') >= 100 then -- Legion
			if not GetOption("Legion") or (not GetOption(1155) and getCurinfo(1155)[7]) or (not GetOption(1275) and getCurinfo(1275)[7]) or (not GetOption(1299) and getCurinfo(1299)[7]) or (not GetOption(1356) and getCurinfo(1356)[7]) or (not GetOption(1357) and getCurinfo(1357)[7]) or (not GetOption(1355) and getCurinfo(1355)[7]) or (not GetOption(1342) and getCurinfo(1342)[7]) or (not GetOption(1226) and getCurinfo(1226)[7]) or (not GetOption(1220) and getCurinfo(1220)[7]) or (not GetOption(1273) and getCurinfo(1273)[7]) or (not GetOption(1154) and getCurinfo(1154)[7]) or (not GetOption(1149) and getCurinfo(1149)[7]) or (not GetOption(1268) and getCurinfo(1268)[7]) then
				DT.tooltip:AddLine(L["Legion"], r2, g2, b2)
			end
			if not GetOption("Legion") or not GetOption(1155) then
				if getCurinfo(1155)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1155)[2]).." "..getCurinfo(1155)[1], getCurinfo(1155)[3].."/"..getCurinfo(1155)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1275) then
				if getCurinfo(1275)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1275)[2]).." "..getCurinfo(1275)[1], getCurinfo(1275)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			
			if not GetOption("Legion") or not GetOption(1299) then
				if getCurinfo(1299)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1299)[2]).." "..getCurinfo(1299)[1], getCurinfo(1299)[3].."/"..getCurinfo(1299)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1356) then
				if getCurinfo(1356)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1356)[2]).." "..getCurinfo(1356)[1], getCurinfo(1356)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1357) then
				if getCurinfo(1357)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1357)[2]).." "..getCurinfo(1357)[1], getCurinfo(1357)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1355) then
				if getCurinfo(1355)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1355)[2]).." "..getCurinfo(1355)[1], getCurinfo(1355)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1342) then
				if getCurinfo(1342)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1342)[2]).." "..getCurinfo(1342)[1], getCurinfo(1342)[3].."/"..getCurinfo(1342)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			
			if not GetOption("Legion") or not GetOption(1226) then
				if getCurinfo(1226)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1226)[2]).." "..getCurinfo(1226)[1], getCurinfo(1226)[3].."/"..getCurinfo(1226)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1220) then
				if getCurinfo(1220)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1220)[2]).." "..getCurinfo(1220)[1], getCurinfo(1220)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1273) then
				if getCurinfo(1273)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1273)[2]).." "..getCurinfo(1273)[1], getCurinfo(1273)[3].."/"..getCurinfo(1273)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1154) then
				if getCurinfo(1154)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1154)[2]).." "..getCurinfo(1154)[1], getCurinfo(1154)[3].."/"..getCurinfo(1154)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1149) then
				if getCurinfo(1149)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1149)[2]).." "..getCurinfo(1149)[1], getCurinfo(1149)[3].."/"..getCurinfo(1149)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or not GetOption(1268) then
				if getCurinfo(1268)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1268)[2]).." "..getCurinfo(1268)[1], getCurinfo(1268)[3].."/"..getCurinfo(1268)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Legion") or (not GetOption(1155) and getCurinfo(1155)[7]) or (not GetOption(1275) and getCurinfo(1275)[7]) or (not GetOption(1299) and getCurinfo(1299)[7]) or (not GetOption(1356) and getCurinfo(1356)[7]) or (not GetOption(1357) and getCurinfo(1357)[7]) or (not GetOption(1355) and getCurinfo(1355)[7]) or (not GetOption(1342) and getCurinfo(1342)[7]) or (not GetOption(1226) and getCurinfo(1226)[7]) or (not GetOption(1220) and getCurinfo(1220)[7]) or (not GetOption(1273) and getCurinfo(1273)[7]) or (not GetOption(1154) and getCurinfo(1154)[7]) or (not GetOption(1149) and getCurinfo(1149)[7]) or (not GetOption(1268) and getCurinfo(1268)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		
		if UnitLevel('player') >= 90 then -- WoD
			if not GetOption("WoD") or (not GetOption(823) and getCurinfo(823)[7]) or (not GetOption(944) and getCurinfo(944)[7]) or (not GetOption(980) and getCurinfo(980)[7]) or (not GetOption(824) and getCurinfo(824)[7]) or (not GetOption(1101) and getCurinfo(1101)[7]) or (not GetOption(1129) and getCurinfo(1129)[7]) or (not GetOption(994) and getCurinfo(994)[7]) then
				DT.tooltip:AddLine(L["WoD"], r2, g2, b2)
			end
			if not GetOption("WoD") or not GetOption(823) then
				if getCurinfo(823)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(823)[2]).." "..getCurinfo(823)[1], getCurinfo(823)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or not GetOption(944) then
				if getCurinfo(944)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(944)[2]).." "..getCurinfo(944)[1], getCurinfo(944)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or not GetOption(980) then
				if getCurinfo(980)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(980)[2]).." "..getCurinfo(980)[1], getCurinfo(980)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or not GetOption(824) then
				if getCurinfo(824)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(824)[2]).." "..getCurinfo(824)[1], getCurinfo(824)[3].."/"..getCurinfo(824)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or not GetOption(1101) then
				if getCurinfo(1101)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1101)[2]).." "..getCurinfo(1101)[1], getCurinfo(1101)[3].."/"..getCurinfo(1101)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or not GetOption(1129) then
				if getCurinfo(1129)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1129)[2]).." "..getCurinfo(1129)[1], getCurinfo(1129)[3].."/"..getCurinfo(1129)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or not GetOption(994) then
				if getCurinfo(994)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(994)[2]).." "..getCurinfo(994)[1], getCurinfo(994)[3].."/"..getCurinfo(994)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("WoD") or (not GetOption(823) and getCurinfo(823)[7]) or (not GetOption(944) and getCurinfo(944)[7]) or (not GetOption(980) and getCurinfo(980)[7]) or (not GetOption(824) and getCurinfo(824)[7]) or (not GetOption(1101) and getCurinfo(1101)[7]) or (not GetOption(1129) and getCurinfo(1129)[7]) or (not GetOption(994) and getCurinfo(994)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		if UnitLevel("player") >= 15 then -- D&R
			if not GetOption("D&R") or (not GetOption(614) and getCurinfo(614)[7]) or (not GetOption(615) and getCurinfo(615)[7]) or (not GetOption(1166) and getCurinfo(1166)[7]) or (not GetOption(1191) and getCurinfo(1191)[7]) then
				DT.tooltip:AddLine(L["D&R"], r2, g2, b2)
			end
			if not GetOption("D&R") or not GetOption(614) then
				if getCurinfo(614)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(614)[2]).." "..getCurinfo(614)[1], getCurinfo(614)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("D&R") or not GetOption(615) then
				if getCurinfo(615)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(615)[2]).." "..getCurinfo(615)[1], getCurinfo(615)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("D&R") or not GetOption(1166) then
				if getCurinfo(1166)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1166)[2]).." "..getCurinfo(1166)[1], getCurinfo(1166)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("D&R") or not GetOption(1191) then
				if getCurinfo(1191)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(1191)[2]).." "..getCurinfo(1191)[1], getCurinfo(1191)[3].."/"..getCurinfo(1191)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("D&R") or (not GetOption(614) and getCurinfo(614)[7]) or (not GetOption(615) and getCurinfo(615)[7]) or (not GetOption(1166) and getCurinfo(1166)[7]) or (not GetOption(1191) and getCurinfo(1191)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		if UnitLevel("player") >= 10 then -- PvP
			if not GetOption("PvP") or (not GetOption(390) and getCurinfo(390)[7]) or (not GetOption(392) and getCurinfo(392)[7]) or (not GetOption(391) and getCurinfo(391)[7]) then
				DT.tooltip:AddLine(L["PvP"], r2, g2, b2)
			end
			if not GetOption("PvP") or not GetOption(390) then
				if getCurinfo(390)[7] then -- conquest points
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(390)[2]).." "..getCurinfo(390)[1], L["Weekly"]..": "..getCurinfo(390)[4].."/"..getCurinfo(390)[5].." | "..L["Total"]..": "..getCurinfo(390)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("PvP") or not GetOption(392) then
				if getCurinfo(392)[7] then -- honor points
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(392)[2]).." "..getCurinfo(392)[1], getCurinfo(392)[3].."/"..getCurinfo(392)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("PvP") or not GetOption(391) then
				if getCurinfo(391)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(391)[2]).." "..getCurinfo(391)[1], getCurinfo(391)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("PvP") or (not GetOption(390) and getCurinfo(390)[7]) or (not GetOption(392) and getCurinfo(392)[7]) or (not GetOption(391) and getCurinfo(391)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		if UnitLevel("player") >= 85 then -- MoP
			if not GetOption("MoP") or (not GetOption(789) and getCurinfo(789)[7]) or (not GetOption(697) and getCurinfo(697)[7]) or (not GetOption(738) and getCurinfo(738)[7]) or (not GetOption(752) and getCurinfo(752)[7]) or (not GetOption(777) and getCurinfo(777)[7]) or (not GetOption(776) and getCurinfo(776)[7]) then
				DT.tooltip:AddLine(L["MoP"], r2, g2, b2)
			end
			if not GetOption("MoP") or not GetOption(789) then
				if getCurinfo(789)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(789)[2]).." "..getCurinfo(789)[1], getCurinfo(789)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("MoP") or not GetOption(697) then
				if getCurinfo(697)[7] then -- Elder charm
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(697)[2]).." "..getCurinfo(697)[1], getCurinfo(697)[3].."/"..getCurinfo(697)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("MoP") or not GetOption(738) then
				if getCurinfo(738)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(738)[2]).." "..getCurinfo(738)[1], getCurinfo(738)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("MoP") or not GetOption(752) then
				if getCurinfo(752)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(752)[2]).." "..getCurinfo(752)[1], getCurinfo(752)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("MoP") or not GetOption(777) then
				if getCurinfo(777)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(777)[2]).." "..getCurinfo(777)[1], getCurinfo(777)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("MoP") or not GetOption(776) then
				if getCurinfo(776)[7] then -- warforged seal
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(776)[2]).." "..getCurinfo(776)[1], getCurinfo(776)[3].."/"..getCurinfo(776)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("MoP") or (not GetOption(789) and getCurinfo(789)[7]) or (not GetOption(697) and getCurinfo(697)[7]) or (not GetOption(738) and getCurinfo(738)[7]) or (not GetOption(752) and getCurinfo(752)[7]) or (not GetOption(777) and getCurinfo(777)[7]) or (not GetOption(776) and getCurinfo(776)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		if UnitLevel("player") >= 80 then -- Cata
--			if not GetOption("Cata") or (not GetOption(361) and getCurinfo(361)[7]) then
			if getCurinfo(361)[7] then
				if not GetOption("Cata") or not GetOption(361) and getCurinfo(361)[7] then
					DT.tooltip:AddLine(L["Cata"], r2, g2, b2)
				end
				if not GetOption("Cata") or not GetOption(361) then
					if getCurinfo(361)[7] then
						DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(361)[2]).." "..getCurinfo(361)[1], getCurinfo(361)[3], r1, g1, b1, r1, g1, b1)
					end
				end
				if not GetOption("Cata") or (not GetOption(361) and getCurinfo(361)[7]) then
					DT.tooltip:AddLine("  ")
				end
			end
		end
		if UnitLevel("player") >= 1 then  -- Misc
			if not GetOption("Misc") or (not GetOption(241) and getCurinfo(241)[7]) or (not GetOption(61) and getCurinfo(61)[7]) or (not GetOption(515) and getCurinfo(515)[7]) or (not GetOption(81) and getCurinfo(81)[7]) or (not GetOption(402) and getCurinfo(402)[7]) or (not GetOption(416) and getCurinfo(416)[7]) then
				DT.tooltip:AddLine(L["Misc"], r2, g2, b2)
			end
			if not GetOption("Misc") or not GetOption(241) then
				if getCurinfo(241)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(241)[2]).." "..getCurinfo(241)[1], getCurinfo(241)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Misc") or not GetOption(61) then
				if getCurinfo(61)[7] then -- Elder charm
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(61)[2]).." "..getCurinfo(61)[1], getCurinfo(61)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Misc") or not GetOption(515) then
				if getCurinfo(515)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(515)[2]).." "..getCurinfo(515)[1], getCurinfo(515)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Misc") or not GetOption(81) then
				if getCurinfo(81)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(81)[2]).." "..getCurinfo(81)[1], getCurinfo(81)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Misc") or not GetOption(402) then
				if getCurinfo(402)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(402)[2]).." "..getCurinfo(402)[1], getCurinfo(402)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Misc") or not GetOption(416) then
				if getCurinfo(416)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(416)[2]).." "..getCurinfo(416)[1], getCurinfo(416)[3], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Misc") or (not GetOption(241) and getCurinfo(241)[7]) or (not GetOption(61) and getCurinfo(61)[7]) or (not GetOption(515) and getCurinfo(515)[7]) or (not GetOption(81) and getCurinfo(81)[7]) or (not GetOption(402) and getCurinfo(402)[7]) or (not GetOption(416) and getCurinfo(416)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		if UnitLevel("player") >= 1 then  -- Arch
			if not GetOption("Arch") or (not GetOption(384) and getCurinfo(384)[7]) or (not GetOption(398) and getCurinfo(398)[7]) or (not GetOption(393) and getCurinfo(393)[7]) or (not GetOption(394) and getCurinfo(394)[7]) or (not GetOption(400) and getCurinfo(400)[7]) or (not GetOption(397) and getCurinfo(397)[7]) or (not GetOption(401) and getCurinfo(401)[7]) or (not GetOption(385) and getCurinfo(385)[7]) or (not GetOption(399) and getCurinfo(399)[7]) or (not GetOption(754) and getCurinfo(754)[7]) or (not GetOption(676) and getCurinfo(676)[7]) or (not GetOption(677) and getCurinfo(677)[7]) or (not GetOption(829) and getCurinfo(829)[7]) or (not GetOption(821) and getCurinfo(821)[7]) or (not GetOption(828) and getCurinfo(828)[7]) then
				DT.tooltip:AddLine(L["Arch"], r2, g2, b2)
			end
			if not GetOption("Arch") or not GetOption(384) then
				if getCurinfo(384)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(384)[2]).." "..getCurinfo(384)[1], getCurinfo(384)[3].."/"..getCurinfo(384)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(398) then
				if getCurinfo(398)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(398)[2]).." "..getCurinfo(398)[1], getCurinfo(398)[3].."/"..getCurinfo(398)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(393) then
				if getCurinfo(393)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(393)[2]).." "..getCurinfo(393)[1], getCurinfo(393)[3].."/"..getCurinfo(393)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(394) then
				if getCurinfo(394)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(394)[2]).." "..getCurinfo(394)[1], getCurinfo(394)[3].."/"..getCurinfo(394)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(400) then
				if getCurinfo(400)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(400)[2]).." "..getCurinfo(400)[1], getCurinfo(400)[3].."/"..getCurinfo(400)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(397) then
				if getCurinfo(397)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(397)[2]).." "..getCurinfo(397)[1], getCurinfo(397)[3].."/"..getCurinfo(397)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(401) then
				if getCurinfo(401)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(401)[2]).." "..getCurinfo(401)[1], getCurinfo(401)[3].."/"..getCurinfo(401)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(385) then
				if getCurinfo(385)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(385)[2]).." "..getCurinfo(385)[1], getCurinfo(385)[3].."/"..getCurinfo(385)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(399) then
				if getCurinfo(399)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(399)[2]).." "..getCurinfo(399)[1], getCurinfo(399)[3].."/"..getCurinfo(399)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(754) then
				if getCurinfo(754)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(754)[2]).." "..getCurinfo(754)[1], getCurinfo(754)[3].."/"..getCurinfo(754)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(676) then
				if getCurinfo(676)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(676)[2]).." "..getCurinfo(676)[1], getCurinfo(676)[3].."/"..getCurinfo(676)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(677) then
				if getCurinfo(677)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(677)[2]).." "..getCurinfo(677)[1], getCurinfo(677)[3].."/"..getCurinfo(677)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(829) then
				if getCurinfo(829)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(829)[2]).." "..getCurinfo(829)[1], getCurinfo(829)[3].."/"..getCurinfo(829)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(821) then
				if getCurinfo(821)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(821)[2]).." "..getCurinfo(821)[1], getCurinfo(821)[3].."/"..getCurinfo(821)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or not GetOption(828) then
				if getCurinfo(828)[7] then
					DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t', getCurinfo(828)[2]).." "..getCurinfo(828)[1], getCurinfo(828)[3].."/"..getCurinfo(828)[6], r1, g1, b1, r1, g1, b1)
				end
			end
			if not GetOption("Arch") or (not GetOption(384) and getCurinfo(384)[7]) or (not GetOption(398) and getCurinfo(398)[7]) or (not GetOption(393) and getCurinfo(393)[7]) or (not GetOption(394) and getCurinfo(394)[7]) or (not GetOption(400) and getCurinfo(400)[7]) or (not GetOption(397) and getCurinfo(397)[7]) or (not GetOption(401) and getCurinfo(401)[7]) or (not GetOption(385) and getCurinfo(385)[7]) or (not GetOption(399) and getCurinfo(399)[7]) or (not GetOption(754) and getCurinfo(754)[7]) or (not GetOption(676) and getCurinfo(676)[7]) or (not GetOption(677) and getCurinfo(677)[7]) or (not GetOption(829) and getCurinfo(829)[7]) or (not GetOption(821) and getCurinfo(821)[7]) or (not GetOption(828) and getCurinfo(828)[7]) then
				DT.tooltip:AddLine("  ")
			end
		end
		DT.tooltip:AddDoubleLine(L["leftM"], L["reloadui"], r1, g1, b1, r2, g2, b2)
		DT.tooltip:AddDoubleLine(L["middleM"], L["reset"], r1, g1, b1, r2, g2, b2)
		DT.tooltip:AddDoubleLine(L["rightM"], L["options"], r1, g1, b1, r2, g2, b2)
		DT.tooltip:Show()
	end 
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

local function OnClick(self, btn)
	if btn == "RightButton" then
		DT.tooltip:Hide();
		EasyMenu(menu, menuFrame, self, 0, 110, 'MENU', 3)
	elseif btn == "LeftButton" then
		StaticPopup_Show("CurrenciesReloadUI")
--		ReloadUI()
	elseif btn == "MiddleButton" then
		StaticPopup_Show("CurrenciesReset")
	end
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

local function ValueColorUpdate(hex, r, g, b)
	_hex = hex
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E["valueColorUpdateFuncs"][ValueColorUpdate] = true

--[[DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc)
	name - name of the datatext (required)
	events - must be a table with string values of event names to register
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter]]
DT:RegisterDatatext('Currencies', {'PLAYER_LOGIN', 'PLAYER_ENTERING_WORLD', 'PLAYER_MONEY', 'PLAYER_TRADE_MONEY', 'TRADE_MONEY_CHANGED', 'SPELLS_CHANGED'}, OnEvent, nil, OnClick, OnEnter) hooksecurefunc("BackpackTokenFrame_Update", function(...) OnEvent(lastPanel) end)

--[[
Legion
Ancient Mana							Legion 300 (can be increased in-game)
Curious Coin							Legion 
Nethershard								Legion 2000
Order Resources							Legion 
Seal of Broken Fate						Legion 10
Shadowy Coins							Legion 500
Sightless Eye							Legion 5000
Timeworn Artifact						Legion 1000

Warlords of Draenor
Apexis Crystal							Warlords of Draenor
Artifact Fragment						Warlords of Draenor	1000
Dingy Iron Coins						Warlords of Draenor	20000
Garrison Resources						Warlords of Draenor	10000
Seal of Tempered Fate					Warlords of Draenor	20
Seal of Inevitable Fate					Warlords of Draenor	10
Oil										Warlords of Draenor	100000

Mists of Pandaria
Bloody Coin								Mists of Pandaria
Elder Charm of Good Fortune				Mists of Pandaria	20
Lesser Charm of Good Fortune			Mists of Pandaria
Mogu Rune of Fate						Mists of Pandaria	20
Timeless Coin							Mists of Pandaria
Warforged Seal							Mists of Pandaria	20

Cataclysm
Illustrious Jewelcrafter's Token		Cataclysm

Dungeon & Raid
Essence of Corrupted Deathwing			Dungeon and Raid
Mote of Darkness						Dungeon and Raid
Timewarped Bagde						Dungeon and Raid
Valor									Dungeon and Raid	5000

Miscellaneous
Champion's Seal							Miscellaneous
Dalaran Jewelcrafter's Token			Miscellaneous
Darkmoon Prize Ticket					Miscellaneous
Epicurean's Award						Miscellaneous
Ironpaw Token							Miscellaneous
Mark of the World Tree					Miscellaneous

Player v. Player
Conquest Points							Player vs. Player	31700 weekly
Honor Points							Player vs. Player	4000
Tol Barad Commendation					Player vs. Player

Archaeology
Arakkoa Archaeology Fragment			Archaeology			250
Draenei Archaeology Fragment			Archaeology			200
Draenor Clans Archaeology Fragment		Archaeology			250
Dwarf Archaeology Fragment				Archaeology			200
Fossil Archaeology Fragment				Archaeology			200
Mantid Archaeology Fragment				Archaeology			200
Mogu Archaeology Fragment				Archaeology			200
Nerubian Archaeology Fragment			Archaeology			200
Night Elf Archaeology Fragment			Archaeology			200
Ogre Archaeology Fragment				Archaeology			250
Orc Archaeology Fragment				Archaeology			200
Pandaren Archaeology Fragment			Archaeology			200
Tol'vir Archaeology Fragment			Archaeology			200
Troll Archaeology Fragment				Archaeology			200
Vrykul Archaeology Fragment				Archaeology			200
]]
