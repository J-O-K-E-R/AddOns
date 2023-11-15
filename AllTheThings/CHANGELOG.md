# AllTheThings

## [DF-3.8.1](https://github.com/DFortun81/AllTheThings/tree/DF-3.8.1) (2023-11-12)
[Full Changelog](https://github.com/DFortun81/AllTheThings/compare/DF-3.8.0...DF-3.8.1) [Previous Releases](https://github.com/DFortun81/AllTheThings/releases)

- parser  
- Fixed Bloody Token currency being used as item instead.  
- Forest Lord's Antlers moved back to treasures achievement again.  
- moved grimoires to its own common boss drop headers for time rift as they didnt display on the mobs.  
    should now show properly  
- Fixed a tiny Parser logic issue that actually caused huge differences (that no one on Git noticed, sigh)  
- Added a special workaround for Achievement Criteria which use a sourceQuest to determine their name when the quest name doesn't exist  
- Retail: Attempted global ATT window refreshes will now be performed more quickly and allowed during combat (previously they incurred a 0.1 sec delay between attempts and only outside of combat, but Refresh is pretty cheap, so it should be fine)  
- 'Character Unlocks' is now tracked Account-Wide by default  
- shortened some names for amirdrassil, the dreams hope  
- Update Quests.lua  
- Moved Lifeblood and Toughness back to their respective profession files.  
- Sprout quest update  
- Retail Errors  
- Update 4 - Sepulcher of the First Ones.lua  
    You can not get achievement progress for heroic on mythic.  
- Added another DM from purse and prep for special lines in quests  
- Update Timewalking.lua  
    There ya go Runaway :)  
- Classic: Added souce ID to the tooltip  
- CLASSIC: SourceID data now gets exported with the database.  
- Classic: Added back AWP as a hierarchicalNonRepeatField.  
- First Skinning Elusive Blooming Brierhide  
- 10.2 errors cleanup  
- Merge branch 'master' of https://github.com/DFortun81/AllTheThings  
    * 'master' of https://github.com/DFortun81/AllTheThings:  
      Fixed Emerald Dream dragonracing providers and added coordinates to races  
- reversed default sound pack to NOT play report sounds  
    you can now pick the reporting soundpack if you wish so.  
    change is made for new wow patches, as the sound gets very spammy  
- Fixed Emerald Dream dragonracing providers and added coordinates to races  
- One more doti item.  
- reduced even more in tooltip length  
- reduced the monstrous size of dragon riding achievement tooltips due blizzard naming them this (no joke)  
    The Forbidden Reach Challenge Racing Completionist: Gold  
- First week of mythic doti mythic farming.  
- updated grand hunt.  
    Removed various symlinks & while there is some duplication, it should be more clear, especially when you didnt do any GH in the last 10 months  
    clairity & ease of acess should prio symlinking/number reduce  
- updated seedbloom  
- removed note from m+ crests as blizzard added them on the item baseline  
- Fixed a Lua bug when toggling settings after loading with Debug enabled and Show Trackable un-checked  
    Debug mode once again allows toggling Show Completed content  
- Fixed Dream Infusion Currency mixup  
- Update Emerald Bounty.lua  
- shipment recipes no longer show as learnable (they rotate)  
- Retail Errors and WOD TW Daily Bag  
- TryColorizeName now supports 'raceID'  
    Races in ATT tooltips will now be colorized according to their appropriate Faction when 'Show Colors' is enabled  
- Update Quests.lua  
    Auto-Accept quest from 10.1.7 removed with patch.  
- Big rares seems like have daily lockout  
- Use valid Quest name for Superbloom instead of a bad 'name' field  
- Unmangled the criteria for emerald dream challenge race achievements and quests  
- Classic: RWP now works correctly once again.  
- BNet API Harvest 10.2 (Items/Quests)  
- Another BNet API harvest down, another small set of consistency tweaks to the harvester  
- Partially reverted & fixed Triflesnatcher (Don't use q() if it isn't a real in-your-logs Quest. Just fix the creatureID since it was duped)  
- Emerald Dream fixes  
- didn't remove it from unsorted .-.  
- Raszageth's Last Breath actually make it to live, also some ru localisation update  
- Added lil'Wrathion  
- Added Runebound Firelord  
- my bad, it was actually dm qid  
- Fixed the itemID for Murloc Costume.  
- Wrath Classic: Added Lil’ Wrathion, Avatar of Flame, and Nightmarish Emerald Drake.  
- Superbloom - more DM, new weekly hqts?  
- Emerald Bounty - mounts are now listed at vendor, again.  
- Superbloom last cosmetic. May be.  
- More Superbloom cosmetic  
- i(204078), -- Aspect's Shadowflame Crest Fragment still drops, but useless  
- superbloom now returns a valid name and resorted some data the way its sorted in other locations  
- Headers which have a mapID matching the current map are again allowed to be the root of a minilist even if they aren't a 'fake' map (i.e Darkmoon Faire)  
- Fixed Nazjatar Pet Battle Items/Quests  
- Few more unnecessary 'Retrieving data' removed  
- Fixed a couple minor discrepancies on where 'Retrieving data' is used for quest names  
- #errors cleanup  
- Emerald Bounty now should stop yelling with missing qids  
- A bit more fixing hqts  
- Couple Timeless Isle & more Quest-Items converted  
- Updated max Item/Quest for BNet harvest  
- Future Parser builds will warn when data export fails to use a known export type  
    Future Parser builds will automatically convert & warn about any Item with Quest (with no groups or sym field) as a Character Unlock  
    Moved a lot of auto Character Unlocks into CharacterItemDB (maybe someone wants them categorized elsewhere? idk)  
    Converted a bunch of Items with Quests into proper Quests with provider Item [WIP]  
- Some hqt fixing  
- Rare loot and DM from dream racer purse  
- Item from a rare  
- More DMs  
- Fixed Manuscript timeline.  
    Fixed Time Rifts file.  
- Another DM for Superbloom, moved rare loot which was actually zone drop  
- Dreamsurge  & Time Rifts weekly have new itemID  
- Added Emerald Dream FP map  
- Update AchievementDB.lua  
- Update Achievements.lua  
    They changed pathfinder!  
- addded i(203344), -- Winding Slitherdrake: Single Jaw Horn (DM!)  
- PTR: added cloth/mail/plate armor rewards for ch.5  
- Retail: Fixed parser config current data patch  
- Various Parser Cleanup & Improvement  
    * Added a Debug-Warn logging method  
    * awp/rwp are parsed as long instead of string  
    * Cleaned up parsing of race-lists  
    * Added more efficient-collection comparison & fixed a possible logic gap  
    * Data Validator cleaning now performs Debug Warn logging  
    * Data Validator now performs Validation during Validation stage, and Cleaning during Consolidation stage (this way we can complain about contribs doing things wrong, but clean up when Blizzard does things wrong)  
    * Added parser.config 'HierarchicalNonRepeatFields' which will remove field values on child groups which match the same field value on their parent (added to classic version configs as well since they also included this functionality)  
    * Consolidated handling of hierarchically-persistant field values (lvl, modID, awp)  
    * Cleaned up format of data validation method  
    * Processing now uses a function assignment to perform the necessary processing rather than performing a conditional check for every processed piece of data  
    * Fixed lvl consolidation to actually consolidate lvl data  
    * awp is only applied when it's higher than the default (10000) (same as rwp)  
- PTR: chapter 5 is up now, only leather armor is sourced  
- Seat of the Triumvirate Ensemble contains mythic items too! (after relog)  
- DF winterpelt furbolg wrong npc for quest  
