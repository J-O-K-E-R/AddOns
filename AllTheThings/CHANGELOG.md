# AllTheThings

## [4.5.9](https://github.com/ATTWoWAddon/AllTheThings/tree/4.5.9) (2025-07-13)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.5.8...4.5.9) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- [DB] Mists: add Goblin class quests in Kezan  
- [DB] Thought we did a good thing but did a bad thing instead  
- [DB] Mists: add some Tirisfal Glades quests that weren't previously available in Classic  
- [DB] Mists: putting applyclassicphase first*  
- [DB] Mists: apply Classic phases to Deepwind Gorge and Proving Grounds  
- [DB] Mists: Update Elwynn Forest.  
    Update coord of q 31139, 31140, 31142.  
    Update timeline of i 57254.  
    Update objective of q 31142.  
    Update annotated.  
- [Misc.] Fix typo.  
- [Logic] Current Game tooltip will now try to refresh itself after an ATT refresh completes (fixes situations where ATT is refreshed while an Item tooltip is open and the tooltip doesn't refresh)  
- [Logic] Retail: Improve npc search accuracy by directly searching npcID instead of creatureID  
- [DB] Add NYI 5.0 QA PVP Test plate gear  
- [DB] Add NYI QA Combat Test plate gear  
- [DB] Mists: remove new heirlooms from DMF vendor, a few of these are JP only in MoP Classic  
- [DB] Mists: add missing RFC quests and fix quest givers IDs  
- [Logic] Retail: Catalyst Filler adjustments  
    * Supports multiple returned Catalyst results  
    * Supports showing cross-class results for BoE/BoA items (if enabled in user settings)  
    * Some performance improvements WIP  
    * Possibly an issue with cross-class nested upgrades on Catalyzed-Cloaks... WIP  
- [DB] Adjusted 'Grimoire of the Xorothian Felhunter' to be more clear and obvious  
- [Misc] Retail: Moved fill scope check  
- [Logic] Retail: Including C\_Item.IsItemBindToAccountUntilEquip since some Items are base BoP but can drop as BoE/WuE based on the exact link  
- MOP: We still want to see "Known By" on certain elements  
- [DB] Add unnamed MoP Classic items to NYI SourceIDs  
- Classic: Fix for SetThingCollected being unable to figure out where to save sourceIDs.  
- PTR: 11.2.0 build 61871 updates  
    - added war mode gear  
    - added K'aresh zone drop  
    - added K'aresh zone reward  
    - added K'aresh WQs  
- [DB] Sorted NYI Armors up to and including Legion  
- [DB] Mists: undo a few NYI items in the 92xxx ID range, these are probably used for class boosts  
- [DB] Mists: clean up lvl 80 DK boost set for Classic, was never added  
- [DB] Mists: add proper timeline to Group Finder satchels  
- [DB] All the Monster NYI items (rawr xD) + some sorting in NYI file  
- [DB] Budget Bard is properly automated  
- [DB] Mists: apply classic phases for MoP PVP seasons  
- [DB] Mists: add some Classic only NYI items to our files  
- [DB] Free Stylin is automated properly  
- [Settings] Retail: Added a 'Popout List' scope for Fillers  
    * (It's nice to have separate toggles for minilist vs. popouts. Minilist is automatic as you move but popouts are intentional... I've found myself needing to constantly swap settings to see proper popout data -- figure that's probably a common issue)  
- [DB] Gave Lorewalking header a temporary icon  
- [Logic] Retail: Catalyst icon/text now shows in the tooltip/row similar to Upgrade/Cost/Reagent  
- [DB] Cata: add some missing NYI cloaks  
- [DB] Update Classic Missing DBs again :^)  
- PTR: 11.2.0 build 61871 updates  
    missing conquest/war mode gear  
- [DB] Mists: fix currently available Inscription recipes  
- [DB] Add Darkwalker Dagger and Shiv to NYI weapons  
- [DB] Iwen's Enchanting Rod (ach) is properly automated  
    [DB] Found a Healthy Elixir  
- [Parser] Correct timeline of WSG map (#2088)  
- [DB] Cata: update Missing DB  
- [DB] Wrath: update Missing DB  
- [DB] Mists: I lied, here's some more NYI stuff  
- [DB] Mists: add Frayfeather and Steelgrill NYI item sets  
- 2 ToT fixes (#2084)  
    Fixes the minilist of LFR of ToT where megaera is missing in the common drops parts  
    Removed redundant comment on LFR and normal because ra den does not exist on those difficulties  
- [DB] Mists: update Missing DB  
- [DB] Harvest 5.5.0.61916  
- [Wago] Update MoP data to 5.5.0.61916  
- Fixed some Tanaris objectives.  
- [DB] Mists: MORE NYI ARMOR (last one for now)  
- [DB] Mists: add Forestwalker NYI item set  
- [DB] Mists: add even more NYI armor pieces  
- [DB] WoD: put a proper timeline on Big Crate of Salvage  
- [DB] Classic: add WotLK Class Trial to database references and improve preprocessor wrapping for Level 80 Boost / Scroll of Resurrection  
- Deduplicate common drops in Legion raids ahead of InstanceHelper rework  
- Fix some reported errors  
- MOP: Updated Baron Silverlaine's loot table. They added back a bunch of removed from game stuff!  
- MOP: Updated Battleground mapIDs - They were all updated to use the mapID from Retail!  
- WoD gronnsbane treasure daily QI part 2  
- MOP: Apparently Blizzard is using the retail mapID for ARATHI\_BASIN now.  
- WoD gronnsbane treasure daily QIs  
- [DB] Add some more NYI staves found in Classic and improve header consistency in NYI Weapons file  
- [DB] Sorted NYI weapons until I got bored  
- [DB] Sort some NYI weapons  
- [DB] Add Enchanting Test Sword to NYI Weapons  
- [DB] Add more NYI items found in Classic  
- [DB] Add a few oddball NYI "weapons" lol  
- [DB] Mists: add a few NYI Contender's armor set items  
- portal descrip update  
- [Logic] Retail: Clean up some Heirloom stuff by relying fully on Item handling  
- MOP: The Lost Treasure quest was also fixed as a result.  
- MOP: The Cache of the Legion in the Mechanar has been fixed!  
- Update Midsummer Fire Festival.lua  
- [DB] Removed bad objective data  
- [Logic] ATT version-only check is now sent during OnReady & out-of-date notification message now includes the received Version  
- [Logic] Some Social fixes  
    * Social ATT messages no longer duplicate for the user when successfully sent via party/guild  
    * Retail: Now properly sends a Social update when the Main list receives an actual update  
- [Logic] Retail: Cleaned up using a parameter when local ref is available  
- [DB] Mists: add some NYI items I came across in tooltips and sort a few leather NYI items alphabetically  
- [DB] Order some NYI Plate gear  
- [DB] Mists: add some NYI items from common appearances at MH vendor for Mage  
- [Logic] Removed double registration for QUEST\_REMOVED  
- [Logic] Retail: Source(s) in popouts now properly accounts for Map-based Sources (now that Criteria is being automated directly into Zones)  
- [Logic] Classic: assign the appropriate "u" field value to NYI list items on addon load, causing them to show unobtainable status properly everywhere (thanks @ImUnicke!)  
- [DB] Mists: add rest of Galardell set to NYI Armors  
- [Misc] Added more notes about using MAPID\_MERGE\_REPLACEMENTS  
- [Parser] Added preprocessor conditions  
- [Parser] Added 'MAPID\_MERGE\_REPLACEMENTS' to redirect merging against certain mapIDs to other mapIDs (cases where the map is referenced only in 'maps' but no longer really exists, but we need to have automated data sourced under the map)  
    [Parser] Fixed various Criteria linked to maps being copied under HQT section  
- Classic: Added a single frame yield to the Refresh Collections call... Apparently this fixes Battle Pets coming back unlearned on startup.  
- [DB] Fixed some missing commas making VSC upsetti  
- added lucky tortollan charm to dornogal griftah per report  
- [Misc] Retail: Removed some unused locals  
- [Parser] Fixed Criteria getting duplicated under NYI maps used for organization  
    * Reduced some indentation  
- Bit of sorting  
- [Parser] Adjusted patch() so that we can properly show 0.0 patches  
- [DB] Fix baby mistake  
- [DB] Mists: fuck it new heirlooms are not available from AT in Classic at all until proven otherwise by Blizzard  
- [DB] Mists: treat Battle Pet Training as a recipe in Classic  
- Add new achievements for Season Three and K'aresh zone  
- [Logic] Retail: Repeatable quests can now be 'filled' even when temporarily-detected as saved  
- Fix some reported errors, parse  
- Add new WoD Timewalking items  
- Resort MoP T14 patterns under all difficulties, fixes #1929  
- CATA: Fixed the quest rewards for Twilight Falls.  
- [Logic] Retail: 'Total Cost' calculation now hooks the OnWindowUpdated for an ATT popout rather than needing to be hooked to multiple events and sometimes not properly scanning updated data  
- [Logic] Retail: ATT Lists now fire an OnWindowUpdated event after they perform an update, followed by a bool as to whether a full update was performed  
- MOP: Updated the Battle Pets library to use Retail's Battle Pet library.  
    Classic: Split the Battle Pets & Mounts library a bit to make that possible. Moved the new lib file (temporarily) after ATT-Classic.lua since there's a weird race condition going on due to the Spell lib being declared there instead of earlier.  
- [Logic] Retail: Refactored Item caching logic to be similar to most other class caching logic  
    * Item name/icon references now also trigger the Item retrieval from the server  
    [Logic] Retail: Use Colorize in Illusion class  
- [Logic] Retail: Moved async-refresh to ATT row population instead of as part of base class text (forgot there are many classes which define their own custom text)  
- Classic doesn't support AsyncRefreshFunc  
- Classic: Removed some unreferenced functions  
- Classic: Now using the Professions lib.  
- Classic: Fixed some missing references to "app" in ReferenceDB. (again)  
- Classic: Fixed some missing references to "app" in ReferenceDB.  
- C.H.E.T.T. cards do not drop outside of Undermine and Sluice  
- Changed 'Battle Pet Training' spell to Character Unlock.  
- [DB] Mists: add Battle Pet Training spell to the SW/Org trainers  
- added Zuldazar Hearthstone to nyi  
- [DB] Mists: add a few NYI items  
- [Logic] Retail: Revised some async refresh handling for Items/Quests/NPCs  
    * The trigger for an async refresh is now on the text field rather than whenever the Thing is cached initially. This greatly reduces situations where the Upgrade Filler would cache lots of content in the minilist, thereby also causing the minilist to refresh itself many times with no visible change  
    [Logic] Retail: Garrison building Recipes now import from Item instead of containing repeated Item lookups  
- [DB] Added Wandering Isle's Wind Stone object  
- Fixed an issue with the short mode string  
- [DB] Made all anniversary events NYI for Classic up until BfA  
- [Misc] Adjusted debugging comments for DirectGroupRefresh  
- [Logic] Retail: Fixed cost information type by using text instead of name  
- Cost defaulted to On.  
- Converted the cost field into an Information Type.  
- Retail: Removed unreferenced function.  
- Fix Yor ID in timewalking (#2082)  
- All references to app.Spell* and app.Skill have been converted to use the SkillDB provided in ReferenceDB.  
- Classic: Moved Mount & Battle Pet logic to its own file. (temporarily)  
    Classic: Now referencing the SKILL\_ID\_CONVERSION\_TABLE instead of a hardcoded table in ATT-Classic.lua for skill data.  
    BETA: Fixed the beta config.  
    Classic: Moved the Omarion's Handbook OnUpdate to the ExportDB.  
    SOD: Moved the Crafter's OnUpdate to the ExportDB.  
    Rebuilt all DBs to remove references to a helper function that no longer exists within the addon.  
- [DB] Couple treasures and uncollectible item  
- MOP: Battle Pet removal is now properly detected.  
- Retail: Added \_doautomation to all Loremaster achievements changed in 7.3.5 to allow their Story Criteria to be populated in the addon.  
- Update Mount/Pet/ToyDB for 11.2.0.61787  
- Update Timelines dates  
- Automated a couple more achievements  
- MOP: Removed non-existent storyline criteria from zones where they do not exist yet.  
    Pre-7.3.5 Loremaster achievements now show source quests as an alternative.  
- PTR: Delves & Dornogal stuff update  
- Deep into Deepholm didn't get achievement criteria until 7.3.5  
- [DB] Mists: add a few more NYI armors and weapons  
- [DB] Mists: moved some NYI staves from Poor Items to NYI Weapons  
- MOP: Illusions weren't added until 7.0.3.  
