# AllTheThings

## [4.2.14](https://github.com/ATTWoWAddon/AllTheThings/tree/4.2.14) (2025-02-23)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.2.13...4.2.14) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- [Parser] Classic: Fixed parser due to bizarre null coalesce sequence with implicit operators  
- [DB] Update Karazhan Crypts.  
    Use sharedDescription instead of bubbleDown Description.  
- [DB] Fix typo.  
- [Timeline] Add MoP Classic.  
- [DB] Fix syntax.  
- PTR: rip delve ensembles  
- Wago retail files update  
- Dun Morogh: Molkree, The Public Servant  
- Added Gallagio Loyalty Rewards Club reputation itself.  
- Changed Undermine reputation to classic reputations listing to add the reputation requirements.  
- Changed Undermine faction headers to actual headers instead of using pure faction (this removes duplicating of the reputation)  
- Fixed wrong comma in MountDB.  
- added classic mop stuff for preorder  
- correct order  
- found flying spectral tiger spell ID  
    corrected timelines since they are only wotlk and CN servers are still on wotlk c,assjc  
- streamlined gobo rep names in 11.1  
    WIP on undermine raid renown  
- [Parser] Added a special function for HQT content to prevent timelines from spreading where unexpected (May adjust this handling in the future)  
    [Parser] The 'u' field is now part of the HierarchicalPropagationFields  
- More BFA Horde Contrib updates  
- correct header  
- sorted all 11.1 mounts  
- scrubber deluxe  
- 6 more mounts, many more to go  
- [Misc] (previous commit) Removed unnecessary tooltip function param  
    [Logic] Adjusted some event sequencing  
    * OnUpdateWindows is forced to be the first event after OnRefreshComplete  
    * Recalculate account data and check bound source items now handled during OnRecalculateDone instead of OnRefreshCollectionsDone  
- Missing bracket...  
- GLRC is now a thingits the new raid faction  
- added all 5 paragon mount  
- adding all 11.1 mounts  
    starting with scrap, bilgewater & blackwater  
- Add goodie bag promotion ensemble  
- Dun Morogh: The Unflagging Servant  
- EK/Eastern Plaguelands: Some tweaks, followup to 8f5beb5a3173cad5760a140d6eec32a179cc6cc3  
- EK/Eastern Plaguelands: Update coordinates, descriptions, MobileDB, Vendor Symlinks  
- [Logic] Retail: Revert the change to update windows [WIP]  
- [Logic] Retail: BattlePets now use the same account recalculate logic as Mounts [some are character-specific while most are account-wide]  
    [Logic] Retail: Battle Pet cache is now wiped when refreshing to ensure any bad cached data is cleared  
- [Logic] Added a 'WipeCached' method to wipe a specific cache for ATT  
- [Logic] Retail: Windows now update during the OnRefreshCollectionsDone event instead of OnRecalculateDone since some updates can still take place following OnRecalculateDone (account data sync)  
- [Logic] Retail: Removed manual assignment of CollectedSpeciesHelper just in case there's some way to trigger that logic incorrectly to mark unlearned battle pets as learned in ATT...  
- [Logic] Fixed Transmog collection reporting for both Completionist/Unique added/removed and to always report when missing in ATT as intended  
- Terokkar Forest: Zone Drops  
- Crafted Items/TBC: Rest of the skinned reagents.  
- Legion: Remove Consumable flag from Krokul Flute  
    Followup to cea1061e0be36d3f076ee3473f77db025b2044be  
- Legion: Added Krokul Flute into Character Unlocks  
- [DB] Another coord for pile of bones  
- Add Plunderstorm HQT, fix Hodir item  
- TBC: Karazhan descriptions  
- Update collector goodies and fix some reported errors  
- [Logic] Quest prints now use a callback system based on actually receiving server quest data before printing. [This should make quest prints typically have more accurate names when printed in chat if server data is actually available]  
- [DB] Few updates to Korthia HQTs/Objects  
- [Parser] Improve post-processing checks slightly  
- [Parser] More Parser adjustments...  
    * Simplified a lot of CustomConfiguration properties  
    * CustomConfiguration now logs an error if it is not parsed as JSON  
    * CustomConfiguration accessed by Key which does not exist now returns an empty configuration container to prevent unexpected errors  
    * Fixed AQD/HQD data not being cleaned properly before export  
    * Config now supports SimplifyStructures (int[]) to define the SimplifyStructures performance values [max structures, min replacements each]  
    * Revised SimplifyStructures logic to better-account for expected memory footprint reduction due to the simplification of each structure (table)  
- [Parser] Hierarchical Field Adjustments only need to run once after Consolidation pass  
- [Logic] Retail: Added missing patch for /att awp tbc  
- [DB] Fixed a bunch of timelines missing 'added' entries  
- [Parser] More Hierarchical processing types  
    * HierarchicalForceConsolidationFields - works like HierarchicalConsolidationFields except it will replace or remove the parent value based on the children values  
    * HierarchicalMinimumFields - copies the minimum value of a field from all children into the parent  
    * HierarchicalMaximumFields - copies the maximum value of a field from all children into the parent  
    [Parser] HierarchicalFieldAdjustments are now stored in a list so that the order of processing can be ensured  
    [Parser] Retail : awp/rwp are now handled using HierarchicalForceConsolidationFields, thus ensuring that a given awp/rwp on a group represents the accurate values for all content within that group as well  
    [Parser] Now provides a WARN log for all content timelined after 8.0 which has a non-adding (created/added) timeline change as the earliest change  
    [Parser] 'rwp' value is now removed when it preceeds a current 'awp' value  
- [TOC] Remove outdated version.  
- Add Tock twitch drop  
- Removed recently sorted map from NYI.  
- [DB] Add Midnight header.  
- [Locale] Update zhTW: MoP Classic Sha-Infused Heroic Pack.  
- Timeline out Turbulent Timeways Timewalking achievements, tabs  
- Second fix, I did not catch this one first time.  
- Fixed timeline for season 2 delve achievements.  
    Added the new rewards for season 2 delve boss.  
- Add MoP Classic Heroic Pack goodies  
- updated delves based on what blizzard said will be removed (there is probably more)  
    everything s1 that will be removed is now under the head of "tempered (pve tww s1 name)  
    same with season 2 and "enterprising"  
    boss delve will remain available, thus are listed seperatedly, but under each respective season (tempered=>zekvir=>enterprising=>demolition dome)  
- Cata: Added the previously missing Satchel of the Flickering Shoulderpads and adjusted costs for the satchels.  
- Sort some HQTs and add objects to some SL world quests  
- Update Contributor.lua  
    and found a spelling error  
- Update Contributor.lua  
    Should be numerical now..  
- Horde War Campaign -- Added Headers  
    Contrib mode objects and error corrections going thru horde campaign  
- [DB] Couple other error reports  
- Cata: Added Crystallized Firestone to the Protocol Twilight vendor.  
- PTR: new build, some undermine stuff, figure out delve hqts  
- fix reporting of new items when report option unchecked (#1906)  
    just added a conditional around the print statements  
- Cata: Updated Protocol Twilight last boss drops and vendor items.  
- Swapped the order of Baron Geddon and Shazzrah in Molten Core. You generally kill Baron Geddon before Shazzrah.  
- Cata: The End Time doesn't have a faction reputation level. (Does it in retail?)  
- Update 11.1 MountDB  
- PB/Quests: Hiding Anniversary coords + additions  
- Update Incognitro with clarified information  
- [Logic] Breadcrumbs which lead to account-wide Quests should now properly be considered locked account-wide  
- [Locale] Update: Nightmare Incursions.  
- [Locale] Update: Blackrock Eruption.  
- [DB] Fixed mapID for some Azj-Kahet city vendors  
- [DB] Reharvested Appearances on Retail  
    * (somehow one of the PTR harvests botched up various BFA dungeon items and turned them all into Normal difficulty items)  
- [Logic] Classic: Now supports ATT ChatCommands as defined within various Modules (as they become used in Classic versions)  
- [DB] Some Account-wide trading post quests  
- [Parser] Refactored the design of Hierarchical Field Adjustments into a standalone class to make it far simpler to add future adjustments and logic types  
- [Misc.] Fix typo.  
- [DB] SoD: Update loot table: Karazhan Crypts.  
    Move Rattlechain Helm from Kharon to Opera of Malediction.  
    Add a note to all loot item.  
- Add map to Pond Nettle, sort some HQTs  
- [Locale] Update: Real Money.  
    Except for English, which uses "Real Money", other languages ​​use the localized name of "Battle.net Balance".  
- [DB] Removed obsolete and broken timeline handling for ZA items  
- Nazmir - Horde runthru with contrib  
    Playing on a Monk / Leather  
- Vol'dun - Horde runthru with contrib  
    Stupid me getting my HoA and didn't get the "non-HoA" items.. grr  
- [DB] Various error reports  
- Add missed Plunderstore HQT  
- [DB] 'Murkblood Invaders' seems to be fixed, huzzah! Go do it!  
