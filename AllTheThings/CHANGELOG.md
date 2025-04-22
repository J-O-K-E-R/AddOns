# AllTheThings

## [4.3.12](https://github.com/ATTWoWAddon/AllTheThings/tree/4.3.12) (2025-04-21)
[Full Changelog](https://github.com/ATTWoWAddon/AllTheThings/compare/4.3.11...4.3.12) [Previous Releases](https://github.com/ATTWoWAddon/AllTheThings/releases)

- PTR: stuff that was in logged in discord but wasn't added  
- [Logic] Title can use CACHE  
- Add new Noblegarden cosmetics  
- Fix some minor errors  
- Kalimdor/Tanaris: Refactor code to eliminate duplicate keys  
    - Added/Updated some descriptions and coordinates  
    - Hopefully I didn't scuff any preprocessor as there were a few hairy ones...  
- Undermine Cartel Rep Items  
    Correct item levels in list now  
- [Cata Classic] Wintergrasp item fixes for Cata Classic (#1960)  
    * Set WG shoulder vendor to Ros'slai and Magruder for Cata Classic, unsure when these are actually moved or added to the other NPCs...  
    * Wintergrasp jewelry is still present on the vendor in Cata Classic  
- The Shadowguard quests are Troll only, not Undead.  
- [Logic] Retail: Simplified some CharacterUnlock structuring  
- [Logic] Retail: Fixed an issue where Item Recipes which no longer exist would never resolve with a default name  
- [Logic] Removed automatic source harvest when unknown sources lookup an itemID  
- small fixes  
- Fix some reported errors, consolidate some Delve pets  
- Fix some 11.1.5 stuff  
- Cata: Fixed objectives for Taragaman the Hungerer.  
- [Locale] Update esES/esMX (#1959)  
    More Es / MX translations  
- Add Beetriz pet, ignore some objects  
- [Logic] Retail: Pedantic logic review of Quest completion code...  
    * Fixed dirty quests adding values when no actual change to the player's quest state has changed for a given questID  
    * Fixed quests performing updates on questID's which are already completed if they are set again  
    * Fixed potentially reporting more than 50 quest completions at a time due to change in how quest print is being tracked  
    * Fixed large amounts of unflagged quests being reported with a negative number  
- Sort and source rares, mounts, pets and toys from 11.1.5 Horrific Visions  
- [Logic] Retail: The 'No entries found' row no longer appears in empty ATT popouts when the popout is of an actual 'Thing' already  
- [Logic] Retail: Fixed PrimeData being cached when not accurate & PrimeData cache not being used in minimap tooltip prior to an update on the Main list (fixes #1923)  
- Sort and restructure some 11.1.5 rewards  
- Cata: Rebuilt the DB. Also added a Clear Button.  
- Cata: Updated ItemDB. Also updated the ItemDB Harvester to work more efficiently.  
- Fix some reported errors  
- Wago Retail file update  
- Wago PTR file update  
- [DB] Added coords to 'Servitor Interface'  
- [DB] Couple Ritual Offerings coords  
- [Logic] Transmog: Don't show the force refresh text on Things explicitly-marked as non-collectible  
- [Locale] Update esES/esMX: Lore.  
    * update lore tbc-shadowlands in es-es /es-mx  
    * Add missing lore entrys of worldsoul saga to multiple languages  
- Timeline event banners correctly, fix some reported errors  
- Kalimdor/Thousand Needles: Refactor code to eliminate duplicate keys  
    - Added/Updated some descriptions and coordinates  
    - Move "Two If By Boat" from Feralas (It's a part of the Needles introductory quest chain)  
- [Locale] Update esES/esMX. (#1957)  
- [DB] Reparsed all Classic databases.  
- Cata: Added back Living Branch's ignore source state.  
- [Logic] Bad parentheses  
- [DB} Minor spelling/description adjustment for LIITA  
- [Logic] Consolidated more Shared Appearance rendering in tooltips  
    * Fixed inifinite Retrieving data when Blizzard returns unknown appearance information  
    * Fixed indent of Item links in conjunction with other possible indicators  
    * Classic: Fixed CreateItemSource exploding when used without an itemID  
- [Logic] CanRetry now sets HasRetried when the timer expires [Some cases end up with multiple inherited triggers of CanRetry meaning that the initial reason for retrying may not ever resolve CanRetry == false to know it should stop]  
- Correct LoU Glory requirement, fix many reported quest errors  
- [Logic] Retail: Adjusted Spell/RecipeWithItem to utilize the Item-based cache instead of doing basic Item data resolving itself  
- [Logic] Fixed a Lua error when tooltips referenced characters who never had any spells cached  
- [Logic] Known Toys can now be used in lockCriteria  
    [DB] Light Camera Action & Crystal Clarity are now properly marked as unavailable if the S.E.L.F.I.E. Camera MkII is learned on the account  
- Remove some unneeded DF intro sourcequests  
- Clean up some WoD/BFA alt tmog  
- [Contrib] Added note for how to properly determine values for MapPrecisionOverrides  
- [Contrib] Added another attempted protection for checking quests when turned in instead of prior to accepting  
- [Logic] Simplified default search by value comparison  
    [Logic] Moved & adjusted trade skill window search by value comparison (should now properly show learnable Recipes even when under an opposite faction Source)  
- Updated some indents and fixed a missing comma  
- Update Brewfest.lua  
- Update WoW Anniversary.lua  
- [DB] Added learnedAt for couple Ironforge BS quests  
- [Logic] Improved the Known By / Completed By handling & certain Things which are typically account-wide but are instead learned per Character now show Known By  
- [Parser] Illusions no longer include unnecessary 'type' field  
- [Logic] Fixed some Things with SpellID's showing up again in "Known By" tooltips  
- Add guide for Bounty of the Elements treasure (obj: 233973) (#1956)  
    Add guide for Bounty of the Elements treasure  
- [Logic] Event logic now uses for loops instead of ipairs  
- [Logic] Retail: Refactored handling of the visibility checks after an Update & simplified a few pieces of logic [This seems to perform slightly better from my testing and allows for much cleaner control of visibility checks]  
    [Logic] Retail: Loot Mode visibility check can now be added/removed from the set of active checks instead of always processed even when the setting is not active  
    [Logic] Retail: Caching setting data within data handling now happens only when settings actually change/refresh  
- [Logic] Retail: Converted data handling ipairs to for loops  
    [Logic] Retail: Fixed some redundant logic being performed when updating search results in ATT windows  
- [Test] Added a test method to confirm that for loops are an order of magnitude faster than ipairs/pairs lmao  
- [Logic] Fixed a bug introduced 16 months via the CharacterClass module which prevented spec-based Class headers from being visible unless in Account/Debug modes  
- Classic: Fixed a missing variable.  
