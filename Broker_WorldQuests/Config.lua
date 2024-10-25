local _, addon = ...
local CONSTANTS = addon.CONSTANTS
--==========================================================
-- Configuration and related utility functions
--==========================================================
function BWQ:C(k)
	if BWQcfg.usePerCharacterSettings then
		return BWQcfgPerCharacter[k]
	else
		return BWQcfg[k]
	end
end

--==========================================================
-- Configuration Menu
--==========================================================
BWQ.configMenu = nil
function BWQ:SetupConfigMenu()
	local info = {}
	local options = {
		{ text = "Attach list frame to world map", check = "attachToWorldMap" },
		{ text = "Show list frame on click instead of mouse-over", check = "showOnClick" },
		{ text = "Auto switch expansions based on current zone", check = "autoChooseExpansionOnZone" },
		{ text = "Use per-character settings", check = "usePerCharacterSettings" },
		{ text = "" },
		{ text = "Always show |cffa335eeepic|r world quests (e.g. world bosses)", check = "alwaysShowEpicQuests" },
		{ text = "Only show world quests with |cff0070ddrare|r or above quality", check = "onlyShowRareOrAbove" },
		{ text = "Don't filter quests for active bounties", check = "alwaysShowBountyQuests" },
		{ text = "Show total counts in broker text", check = "showTotalsInBrokerText", submenu = {
				{ text = ("|T%1$s:16:16|t  Bronze Celebration Token"):format("Interface\\Icons\\inv_10_dungeonjewelry_dragon_necklace_1_bronze"), check = "brokerShowBronzeCelebrationToken" },
				{ text = ("|T%1$s:16:16|t  Polished Pet Charms"):format("Interface\\Icons\\inv_currency_petbattle"), check = "brokerShowPolishedPetCharms" },
				{ text = ("|T%1$s:16:16|t  Artifact Power"):format("Interface\\Icons\\inv_smallazeriteshard"), check = "brokerShowAP" },
				{ text = ("|T%1$s:16:16|t  Service Medals"):format(self.isHorde and "Interface\\Icons\\ui_horde_honorboundmedal" or "Interface\\Icons\\ui_alliance_7legionmedal"), check = "brokerShowServiceMedals" },
				{ text = ("|T%1$s:16:16|t  Wakening Essences"):format("Interface\\Icons\\achievement_dungeon_ulduar80_25man"), check = "brokerShowWakeningEssences" },
				{ text = ("|T%1$s:16:16|t  Prismatic Manapearls"):format("Interface\\Icons\\Inv_misc_enchantedpearlf"), check = "brokerShowPrismaticManapearl" },
				{ text = ("|T%1$s:16:16|t  Cyphers of the First Ones"):format("Interface\\Icons\\inv_trinket_progenitorraid_02_blue"), check = "brokerShowCyphersOfTheFirstOnes" },
				{ text = ("|T%1$s:16:16|t  Grateful Offerings"):format("Interface\\Icons\\inv_misc_ornatebox"), check = "brokerShowGratefulOffering" },
				{ text = ("|T%1$s:16:16|t  War Resources"):format("Interface\\Icons\\inv__faction_warresources"), check = "brokerShowWarResources" },
				{ text = ("|T%1$s:16:16|t  Order Hall Resources"):format("Interface\\Icons\\inv_orderhall_orderresources"), check = "brokerShowResources" },
				{ text = ("|T%1$s:16:16|t  Legionfall War Supplies"):format("Interface\\Icons\\inv_misc_summonable_boss_token"), check = "brokerShowLegionfallSupplies" },
				{ text = ("|T%1$s:16:16|t  XP Only Quests"):format("Interface\\Icons\\xp_icon"), check = "brokerShowXP" },
				{ text = ("|T%1$s:16:16|t  Honor"):format("Interface\\Icons\\Achievement_LegionPVPTier4"), check = "brokerShowHonor" },
				{ text = ("|T%1$s:16:16|t  Bloody Tokens"):format("Interface\\Icons\\inv_10_dungeonjewelry_titan_trinket_2_color2"), check = "brokerShowBloodyTokens" },
				{ text = ("|T%1$s:16:16|t  Gold"):format("Interface\\GossipFrame\\auctioneerGossipIcon"), check = "brokerShowGold" },
				{ text = ("|T%1$s:16:16|t  Gear"):format("Interface\\Icons\\Inv_chest_plate_legionendgame_c_01"), check = "brokerShowGear" },
				{ text = ("|T%1$s:16:16|t  Mark Of Honor"):format("Interface\\Icons\\ability_pvp_gladiatormedallion"), check = "brokerShowMarkOfHonor" },
				{ text = ("|T%1$s:16:16|t  Herbalism Quests"):format("Interface\\Icons\\Trade_Herbalism"), check = "brokerShowHerbalism" },
				{ text = ("|T%1$s:16:16|t  Mining Quests"):format("Interface\\Icons\\Trade_Mining"), check = "brokerShowMining" },
				{ text = ("|T%1$s:16:16|t  Fishing Quests"):format("Interface\\Icons\\Trade_Fishing"), check = "brokerShowFishing" },
				{ text = ("|T%1$s:16:16|t  Skinning Quests"):format("Interface\\Icons\\inv_misc_pelt_wolf_01"), check = "brokerShowSkinning" },
				{ text = ("|T%s$s:16:16|t  Blood of Sargeras"):format("1417744"), check = "brokerShowBloodOfSargeras" },
				{ text = ("|T%1$s:16:16|t  Dragon Isles Supplies"):format("Interface\\Icons\\inv_faction_warresources"), check = "brokerShowDragonIslesSupplies" },
				{ text = ("|T%1$s:16:16|t  Elemental Overflow"):format("Interface\\Icons\\inv_misc_powder_thorium"), check = "brokerShowElementalOverflow" },
				{ text = ("|T%1$s:16:16|t  Flightstones"):format("Interface\\Icons\\flightstone-dragonflight"), check = "brokerShowFlightstones" },
				{ text = ("|T%1$s:16:16|t  Whelplings Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsdreamingcrest"), check = "brokerShowWhelplingsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesdreamingcrest"), check = "brokerShowDrakesDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsdreamingcrest"), check = "brokerShowWyrmsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsdreamingcrest"), check = "brokerShowAspectsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Whelplings Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsAwakenedcrest"), check = "brokerShowWhelplingsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesAwakenedcrest"), check = "brokerShowDrakesAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsAwakenedcrest"), check = "brokerShowWyrmsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsAwakenedcrest"), check = "brokerShowAspectsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Mysterious Fragment"):format("Interface\\Icons\\Inv_7_0raid_trinket_05a"), check = "brokerShowMysteriousFragment" },
				{ text = ("|T%1$s:16:16|t  Resonance Crystals"):format("Interface\\Icons\\spell_azerite_essence14"), check = "brokerShowResonanceCrystals" },
				{ text = ("|T%1$s:16:16|t  The Assembly of the Deeps"):format("Interface\\Icons\\ui_majorfactions_candle"), check = "brokerShowTheAssemblyoftheDeeps" },
				{ text = ("|T%1$s:16:16|t  Hallowfall Arathi"):format("Interface\\Icons\\ui_majorfactions_flame"), check = "brokerShowHallowfallArathi" },
				{ text = ("|T%1$s:16:16|t  Valorstones"):format("Interface\\Icons\\inv_valorstone_base"), check = "brokerShowValorstones" },
				{ text = ("|T%1$s:16:16|t  Kej"):format("Interface\\Icons\\inv_10_tailoring_silkrare_color3"), check = "brokerShowKej" },
				{ text = ("|T%1$s:16:16|t  Council of Dornogal"):format("Interface\\Icons\\ui_majorfactions_storm"), check = "brokerShowCouncilofDornogal" },
				{ text = ("|T%1$s:16:16|t  The Weaver"):format("Interface\\Icons\\ui_notoriety_theweaver"), check = "brokerShowTheWeaver" },
				{ text = ("|T%1$s:16:16|t  The General"):format("Interface\\Icons\\ui_notoriety_thegeneral"), check = "brokerShowTheGeneral" },
				{ text = ("|T%1$s:16:16|t  The Vizier"):format("Interface\\Icons\\ui_notoriety_thevizier"), check = "brokerShowTheVizier" },
			}
		},
		{ text = "Sort list by time remaining instead of reward type", check = "sortByTimeRemaining" },
		{ text = "Show 'NEW' text for recently found world quests", check = "showNEWTextWhenAppropriate" },
		{ text = "" },
		{ text = "Filter by reward...", isTitle = true },
		{ text = ("|T%1$s:16:16|t  Items"):format("Interface\\Minimap\\Tracking\\Banker"), check = "showItems", submenu = {
				{ text = ("|T%1$s:16:16|t  Gear"):format("Interface\\Icons\\Inv_chest_plate_legionendgame_c_01"), check = "showGear" },
				{ text = ("|T%s$s:16:16|t  Crafting Materials"):format("1417744"), check = "showCraftingMaterials" },
				{ text = ("|T%1$s:16:16|t  Mark Of Honor"):format("Interface\\Icons\\ability_pvp_gladiatormedallion"), check = "showMarkOfHonor" },
				{ text = ("|T%1$s:16:16|t  Bronze Celebration Token"):format("Interface\\Icons\\inv_10_dungeonjewelry_dragon_necklace_1_bronze"), check = "showBronzeCelebrationToken" },
				{ text = "Other", check = "showOtherItems" },
			}
		},
		{ text = ("|T%1$s:16:16|t  XP Only Quests"):format("Interface\\Icons\\xp_icon"), check = "showXP" },
		{ text = ("|T%1$s:16:16|t  Honor"):format("Interface\\Icons\\Achievement_LegionPVPTier4"), check = "showHonor" },
		{ text = ("|T%1$s:16:16|t  Bloody Tokens"):format("Interface\\Icons\\inv_10_dungeonjewelry_titan_trinket_2_color2"), check = "showBloodyTokens" },
		{ text = ("|T%1$s:16:16|t  Low gold reward"):format("Interface\\GossipFrame\\auctioneerGossipIcon"), check = "showLowGold" },
		{ text = ("|T%1$s:16:16|t  High gold reward"):format("Interface\\GossipFrame\\auctioneerGossipIcon"), check = "showHighGold" },
		{ text = "      The War Within", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showTWWReputation" },
				{ text = ("|T%s$s:16:16|t  Resonance Crystals"):format("Interface\\Icons\\spell_azerite_essence14"), check = "showResonanceCrystals" },
				{ text = ("|T%s$s:16:16|t  The Assembly of the Deeps"):format("Interface\\Icons\\ui_majorfactions_candle"), check = "showTheAssemblyoftheDeeps" },
				{ text = ("|T%s$s:16:16|t  Hallowfall Arathi"):format("Interface\\Icons\\ui_majorfactions_flame"), check = "showHallowfallArathi" },
				{ text = ("|T%1$s:16:16|t  Valorstones"):format("Interface\\Icons\\inv_valorstone_base"), check = "showValorstones" },
				{ text = ("|T%1$s:16:16|t  Kej"):format("Interface\\Icons\\inv_10_tailoring_silkrare_color3"), check = "showKej" },
				{ text = ("|T%1$s:16:16|t  Council of Dornogal"):format("Interface\\Icons\\ui_majorfactions_storm"), check = "showCouncilofDornogal" },
				{ text = ("|T%1$s:16:16|t  The Weaver"):format("Interface\\Icons\\ui_notoriety_theweaver"), check = "showTheWeaver" },
				{ text = ("|T%1$s:16:16|t  The General"):format("Interface\\Icons\\ui_notoriety_thegeneral"), check = "showTheGeneral" },
				{ text = ("|T%1$s:16:16|t  The Vizier"):format("Interface\\Icons\\ui_notoriety_thevizier"), check = "showTheVizier" },
			}
		},
		{ text = "      Dragonflight", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showDFReputation" },
				{ text = ("|T%1$s:16:16|t  Dragon Isles Supplies"):format("Interface\\Icons\\inv_faction_warresources"), check = "showDragonIslesSupplies" },
				{ text = ("|T%1$s:16:16|t  Elemental Overflow"):format("Interface\\Icons\\inv_misc_powder_thorium"), check = "ShowElementalOverflow" },
				{ text = ("|T%1$s:16:16|t  Flightstones"):format("Interface\\Icons\\flightstone-dragonflight"), check = "showFlightstones" },
				{ text = ("|T%1$s:16:16|t  Whelplings Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsdreamingcrest"), check = "showWhelplingsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesdreamingcrest"), check = "showDrakesDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsdreamingcrest"), check = "showWyrmsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsdreamingcrest"), check = "showAspectsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Whelplings Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsAwakenedcrest"), check = "showWhelplingsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesAwakenedcrest"), check = "showDrakesAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsAwakenedcrest"), check = "showWyrmsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsAwakenedcrest"), check = "showAspectsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Mysterious Fragment"):format("Interface\\Icons\\Inv_7_0raid_trinket_05a"), check = "showMysteriousFragment" },
			}
		},
		{ text = "      Shadowlands", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showSLReputation" },
				{ text = ("|T%s$s:16:16|t  Anima Item"):format("3528288"), check = "showAnima" },
				{ text = ("|T%s$s:16:16|t  Conduits"):format("3586269"), check = "showConduits" },
				{ text = ("|T%1$s:16:16|t  Cyphers of the First Ones"):format("Interface\\Icons\\inv_trinket_progenitorraid_02_blue"), check = "showCyphersOfTheFirstOnes" },
				{ text = ("|T%1$s:16:16|t  Grateful Offerings"):format("Interface\\Icons\\inv_misc_ornatebox"), check = "showGratefulOffering" },
			}
		},
		{ text = "      Battle for Azeroth", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showBFAReputation" },
				{ text = ("|T%1$s:16:16|t  War Resources"):format("Interface\\Icons\\inv__faction_warresources"), check = "showWarResources" },
				{ text = ("|T%1$s:16:16|t  Azerite"):format("Interface\\Icons\\inv_smallazeriteshard"), check = "showArtifactPower" },
				{ text = ("|T%1$s:16:16|t  Service Medals"):format(self.isHorde and "Interface\\Icons\\ui_horde_honorboundmedal" or "Interface\\Icons\\ui_alliance_7legionmedal"), check = "showBFAServiceMedals" },
				{ text = ("|T%1$s:16:16|t  Prismatic Manapearl"):format("Interface\\Icons\\Inv_misc_enchantedpearlf"), check = "showPrismaticManapearl" },
			}
		},
		{ text = "      Legion", submenu = {
				{ text = ("|T%1$s:16:16|t  Order Hall Resources"):format("Interface\\Icons\\inv_orderhall_orderresources"), check = "showResources" },
				{ text = ("|T%1$s:16:16|t  Legionfall War Supplies"):format("Interface\\Icons\\inv_misc_summonable_boss_token"), check = "showLegionfallSupplies" },
				{ text = ("|T%1$s:16:16|t  Nethershard"):format("Interface\\Icons\\inv_datacrystal01"), check = "showNethershards" },
				{ text = ("|T%1$s:16:16|t  Veiled Argunite"):format("Interface\\Icons\\oshugun_crystalfragments"), check = "showArgunite" },
				{ text = ("|T%1$s:16:16|t  Wakening Essences"):format("Interface\\Icons\\achievement_dungeon_ulduar80_25man"), check = "showWakeningEssences" },
			}
		},
		{ text = "" },
		{ text = "Filter by type...", isTitle = true },
		{ text = "Profession Quests", check = "showProfession", submenu = {
				{ text = "Alchemy", check="showProfessionAlchemy" },
				{ text = "Blacksmithing", check="showProfessionBlacksmithing" },
				{ text = "Inscription", check="showProfessionInscription" },
				{ text = "Jewelcrafting", check="showProfessionJewelcrafting" },
				{ text = "Leatherworking", check="showProfessionLeatherworking" },
				{ text = "Tailoring", check="showProfessionTailoring" },
				{ text = "Enchanting", check="showProfessionEnchanting" },
				{ text = "Engineering", check="showProfessionEngineering" },
				{ text = "" },
				{ text = "Herbalism", check="showProfessionHerbalism" },
				{ text = "Mining", check="showProfessionMining" },
				{ text = "Skinning", check="showProfessionSkinning" },
				{ text = "" },
				{ text = "Cooking", check="showProfessionCooking" },
				{ text = "Archaeology", check="showProfessionArchaeology" },
				{ text = "Fishing", check="showProfessionFishing" },
			}
		},
		{ text = "Dragon Rider Racing", check = "showDragonRiderRacing" },
		{ text = "Dungeon Quests", check = "showDungeon" },
		{ text = "PvP Quests", check = "showPvP" },
		{ text = "Pet Battle Quests", check = "showPetBattle", submenu = {
				{ text = "Hide Pet Battle Quests even when active bounty", check = "hidePetBattleBountyQuests" },
				{ text = "Always show quests for \"Family Familiar\" achievement", check = "alwaysShowPetBattleFamilyFamiliar" },
			}
		},
		{ text = "" },
		{ text = "Hide faction column", check="hideFactionColumn" },
		{ text = "Hide faction paragon bars", check="hideFactionParagonBars" },
		{ text = "" },
		{ text = "Always show quests for faction...", isTitle = true },
		{ text = "       Dragonflight", submenu = {
				{ text = "Dragonscale Expedition", check="alwaysShowDragonscaleExpedition" },
				{ text = "Iskaara Tuskarr", check="alwaysShowIskaaraTuskarr" },
				{ text = "Maruuk Centaur", check="alwaysShowMaruukCentaur" },
				{ text = "Valdrakken Accord", check="alwaysShowValdrakkenAccord" },
				{ text = "Loamm Niffen", check="alwaysShowLoammNiffen" },
				{ text = "Dream Wardens", check="alwaysShowDreamWardens" },
			}
		},
		{ text = "       Shadowlands", submenu = {
				{ text = "The Avowed", check="alwaysShowAvowed" },
				{ text = "The Wild Hunt", check="alwaysShowWildHunt" },
				{ text = "Court of Harvesters", check="alwaysShowCourtofHarvesters" },
				{ text = "The Undying Army", check="alwaysShowUndyingArmy" },
				{ text = "The Ascended", check="alwaysShowAscended" },
				{ text = "Death's Advance", check="alwaysShowDeathsAdvance" },
				{ text = "The Enlightened", check="alwaysShowEnlightened" },
			}
		},
		{ text = "       Battle for Azeroth", submenu = {
				{ text = "Rustbolt Resistance", check="alwaysShowRustboltResistance" },
				{ text = "Tortollan Seekers", check="alwaysShowTortollanSeekers" },
				{ text = "Champions of Azeroth", check="alwaysShowChampionsOfAzeroth" },
				{ text = ("|T%1$s:16:16|t  7th Legion"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShow7thLegion" },
				{ text = ("|T%1$s:16:16|t  Storm's Wake"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowStormsWake" },
				{ text = ("|T%1$s:16:16|t  Order of Embers"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowOrderOfEmbers" },
				{ text = ("|T%1$s:16:16|t  Proudmoore Admiralty"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowProudmooreAdmiralty" },
				{ text = ("|T%1$s:16:16|t  Waveblade Ankoan"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowWavebladeAnkoan" },
				{ text = ("|T%1$s:16:16|t  The Honorbound"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowTheHonorbound" },
				{ text = ("|T%1$s:16:16|t  Zandalari Empire"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowZandalariEmpire" },
				{ text = ("|T%1$s:16:16|t  Talanji's Expedition"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowTalanjisExpedition" },
				{ text = ("|T%1$s:16:16|t  Voldunai"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowVoldunai" },
				{ text = ("|T%1$s:16:16|t  The Unshackled"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowTheUnshackled" },
			}
		},
		{ text = "       Legion", submenu = {
				{ text = "Court of Farondis", check="alwaysShowCourtOfFarondis" },
				{ text = "Dreamweavers", check="alwaysShowDreamweavers" },
				{ text = "Highmountain Tribe", check="alwaysShowHighmountainTribe" },
				{ text = "The Nightfallen", check="alwaysShowNightfallen" },
				{ text = "The Wardens", check="alwaysShowWardens" },
				{ text = "Valarjar", check="alwaysShowValarjar" },
				{ text = "Armies of Legionfall", check="alwaysShowArmiesOfLegionfall" },
				{ text = "Army of the Light", check="alwaysShowArmyOfTheLight" },
				{ text = "Argussian Reach", check="alwaysShowArgussianReach" },
			}
		},
	}
	if TomTom then
		table.insert(options, { text = "" })
		table.insert(options, { text = "Add TomTom waypoint on row click", check = "enableTomTomWaypointsOnClick" })
	end
	table.insert(options, { text = "" })
	table.insert(options, { text = "Spew Debug Information", check = "spewDebugInfo" })

	BWQ.configMenu = CreateFrame("Frame", "BWQ_ConfigMenu")
	BWQ.configMenu.displayMode = "MENU"

	local SetOption = function(bt, var, val)
		if var == "usePerCharacterSettings" or not BWQcfg.usePerCharacterSettings then
			BWQcfg[var] = val or not BWQcfg[var]
		else
			BWQcfgPerCharacter[var] = val or not BWQcfgPerCharacter[var]
		end

		-- refresh radio buttons
		if val then
			local sub = bt:GetName():sub(1, 19).."%i"
			for i = 1, bt:GetParent().numButtons do
				local subi = sub:format(i)
				if _G[subi] == bt then
					_G[subi.."Check"]:Show()
				else
					_G[subi.."Check"]:Hide()
					_G[subi.."UnCheck"]:Show()
				end
			end
		end

		if var == "expansion" then
			BWQ.expansion = BWQ:C("expansion")
			BWQ:HideRowsOfInactiveExpansions()
			BWQ.hasUnlockedWorldQuests = false
		end

		if var == "hideFactionParagonBars" then
			BWQ:UpdateFactionDisplayVisible()
		end

		BWQ:UpdateBlock()

		-- toggle block when changing attach setting
		if var == "attachToWorldMap" then
			BWQ:Hide()
			if BWQ:C(var) == true and WorldMapFrame:IsShown() then
				BWQ:AttachToWorldMap()
			end
		end

		if var == "usePerCharacterSettings" then
			CloseDropDownMenus()
			ToggleDropDownMenu(1, nil, BWQ.configMenu, BWQ.configMenu.anchor, 0, 0)
		end

		if var == "autoChooseExpansionOnZone" then
			if BWQ:C("autoChooseExpansionOnZone") then 
				--print(string.format("[BWQ] Registering Zone Change Events"))
				BWQ:RegisterEvent("ZONE_CHANGED_NEW_AREA")
				BWQ:RegisterEvent("NEW_WMO_CHUNK")
			else
				--print(string.format("[BWQ] UnRegistering Zone Change Events"))
				BWQ:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
				BWQ:UnregisterEvent("NEW_WMO_CHUNK")
			end
		end
	end

	BWQ.configMenu.initialize = function(self, level)
		if not level then return end
		local opt = level > 1 and UIDROPDOWNMENU_MENU_VALUE or options
		for i, v in ipairs(opt) do
			info = wipe(info)
			info.text = v.text
			info.isTitle = v.isTitle

			if v.check then
				if (v.check == "usePerCharacterSettings") then info.checked = BWQcfg[v.check]
				elseif v.radio then info.checked = BWQ:C(v.check) == v.val
				else info.checked = BWQ:C(v.check)
				end
				info.func, info.arg1 = SetOption, v.check 
				if v.radio then info.arg2 = v.val end
				info.isNotRadio = not v.radio
				info.keepShownOnClick = true
			elseif v.submenu then
				info.notCheckable = true
			else
				info.notCheckable = true
				info.disabled = true
			end
			info.hasArrow, info.value = v.submenu, v.submenu
			UIDropDownMenu_AddButton( info, level )
		end
	end

	BWQ.SetupConfigMenu = nil
end

function BWQ:OpenConfigMenu(anchor)
	if not BWQ.configMenu and anchor then
		BWQ:SetupConfigMenu()
	end
	BWQ.configMenu.anchor = anchor
	ToggleDropDownMenu(1, nil, BWQ.configMenu, BWQ.configMenu.anchor, 0, 0)
end

--==========================================================
-- Default Configuration
--==========================================================
BWQ.defaultConfig = {
	-- general
	attachToWorldMap = false,
	showOnClick = false,
	autoChooseExpansionOnZone = true,
	usePerCharacterSettings = false,
	enableClickToOpenMap = false,
	enableTomTomWaypointsOnClick = true,
	spewDebugInfo = false,
	alwaysShowBountyQuests = true,
	alwaysShowEpicQuests = true,
	onlyShowRareOrAbove = false,
	showTotalsInBrokerText = true,
		brokerShowAP = true,
		brokerShowServiceMedals = true,
		brokerShowWakeningEssences = true,
		brokerShowWarResources = true,
		brokerShowPrismaticManapearl = true,
		brokerShowCyphersOfTheFirstOnes = true,
		brokerGratefulOffering = true,
		brokerShowResources = true,
		brokerShowLegionfallSupplies = true,
		brokerShowXP = true,
		brokerShowHonor = true,
		brokerShowGold = false,
		brokerShowGear = false,
		brokerShowMarkOfHonor = false,
		brokerShowHerbalism = false,
		brokerShowMining = false,
		brokerShowFishing = false,
		brokerShowSkinning = false,
		brokerShowBloodOfSargeras = false,
		brokerShowDragonIslesSupplies = true,
		brokerShowElementalOverflow = true,
		brokerShowFlightstones = true,
		brokerShowWhelplingsDreamingCrest = true,
		brokerShowDrakesDreamingCrest = true,
		brokerShowWyrmsDreamingCrest = true,
		brokerShowAspectsDreamingCrest = true,
		brokerShowWhelplingsAwakenedCrest = true,
		brokerShowDrakesAwakenedCrest = true,
		brokerShowWyrmsAwakenedCrest = true,
		brokerShowAspectsAwakenedCrest = true,
		brokerShowMysteriousFragment = true,
		brokerShowResonanceCrystals = true,
		brokerShowTheAssemblyoftheDeeps = true,
		brokerShowValorstones = true,
		brokerShowKej = true,
		brokerShowCouncilofDornogal = true,
		brokerShowHallowfallArathi = true,
		brokerShowTheWeaver = true,
		brokerShowTheGeneral = true,
		brokerShowTheVizier = true,
		brokerShowBloodyTokens = true,
		brokerShowPolishedPetCharms = true,
		brokerShowBronzeCelebrationToken = true,
	sortByTimeRemaining = false,
	showNEWTextWhenAppropriate = true,
	-- reward type
	showDragonIslesSupplies = true,
	showElementalOverflow = true,
	showFlightstones = true,
	showWhelplingsDreamingCrest = true,
	showDrakesDreamingCrest = true,
	showWyrmsDreamingCrest = true,
	showAspectsDreamingCrest = true,
	showWhelplingsAwakenedCrest = true,
	showDrakesAwakenedCrest = true,
	showWyrmsAwakenedCrest = true,
	showAspectsAwakenedCrest = true,
	showMysteriousFragment = true,
	showResonanceCrystals = true,
	showCouncilofDornogal = true,
	showTheAssemblyoftheDeeps = true,
	showHallowfallArathi = true,
	showTheWeaver = true,
	showTheGeneral = true,
	showTheVizier = true,
	showValorstones = true,
	showBronzeCelebrationToken = true,
	showKej = true,
	showBloodyTokens = true,
	showArtifactPower = true,
	showPrismaticManapearl = true,
	showCyphersOfTheFirstOnes = true,
	showGratefulOffering = true,
	showItems = true,
		showGear = true,
		showRelics = true,
		showCraftingMaterials = true,
		showConduits = true,
		showMarkOfHonor = true,
		showOtherItems = true,
	showTWWReputation = true,
	showDFReputation = true,
	showSLReputation = true,
	showBFAReputation = true,
	showBFAServiceMedals = true,
	showXP = true,
	showHonor = true,
	showLowGold = true,
	showHighGold = true,
	showWarResources = true,
	showAnima = true,
	showResources = true,
	showLegionfallSupplies = true,
	showNethershards = true,
	showArgunite = true,
	showWakeningEssences = true,
	-- quest type
	showProfession = true,
		showProfessionAlchemy = true,
		showProfessionBlacksmithing = true,
		showProfessionInscription = true,
		showProfessionJewelcrafting = true,
		showProfessionLeatherworking = true,
		showProfessionTailoring = true,
		showProfessionEnchanting = true,
		showProfessionEngineering = true,
		showProfessionHerbalism = true,
		showProfessionMining = true,
		showProfessionSkinning = true,
		showProfessionCooking = true,
		showProfessionArchaeology = true,
		showProfessionFishing = true,
	showDungeon = true,
	showDragonRiderRacing = true,
	showPvP = true,
	hideFactionColumn = false,
	hideFactionParagonBars = false,
		-- Dragonflight
		alwaysShowDragonscaleExpedition = false,
		alwaysShowIskaaraTuskarr = false,
		alwaysShowMaruukCentaur = false,
		alwaysShowValdrakkenAccord = false,
		alwaysShowLoammNiffen = false,
		alwaysShowDreamWardens = false,
		-- Shadowlands
		alwaysShowAscended = false,
		alwaysShowUndyingArmy = false,
		alwaysShowCourtofHarvesters = false,
		alwaysShowAvowed = false,
		alwaysShowWildHunt = false,
		alwaysShowDeathsAdvance = false,
		alwaysShowEnlightened = false,
		-- BFA
		alwaysShow7thLegion = false,
		alwaysShowStormsWake = false,
		alwaysShowOrderOfEmbers = false,
		alwaysShowProudmooreAdmiralty = false,
		alwaysShowWavebladeAnkoan = false,
		alwaysShowTheHonorbound = false,
		alwaysShowZandalariEmpire = false,
		alwaysShowTalanjisExpedition = false,
		alwaysShowVoldunai = false,
		alwaysShowTheUnshackled = false,
		alwaysShowRustboltResistance = false,
		alwaysShowTortollanSeekers = false,
		alwaysShowChampionsOfAzeroth = false,
		-- Legion
		alwaysShowCourtOfFarondis = false,
		alwaysShowDreamweavers = false,
		alwaysShowHighmountainTribe = false,
		alwaysShowNightfallen = false,
		alwaysShowWardens = false,
		alwaysShowValarjar = false,
		alwaysShowArmiesOfLegionfall = false,
		alwaysShowArmyOfTheLight = false,
		alwaysShowArgussianReach = false,
	showPetBattle = true,
	hidePetBattleBountyQuests = false,
	alwaysShowPetBattleFamilyFamiliar = true,

	collapsedZones = {},
}
