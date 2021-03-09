# [3.2.0](https://github.com/WeakAuras/WeakAuras2/tree/3.2.0) (2021-03-09)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/3.1.9...3.2.0)

## Highlights

 - Merge ZoneID/GroupID load options
- Add "Duplicate Conditions"
- Add script and update model paths from wow.tools
- Add searchbox to model picker
- Add more time formatting options
- Bug fixes! 

## Commits

Anssi Mäkinen (1):

- Fix Modernize for time format with non-dynamic decimal precision

Casey Raethke (1):

- Add 'Mine' affilation to combat log flag prototype (#2923)

InfusOnWoW (34):

- Fix creating Model Aura from Template for a Ability
- Fix issue with infinite auras and multi tragging
- Fix new Auras with BuffTrigger2 trigger
- Trigger Templates Classic: Fix two errors in last round
- Don't clear region.states/region.state to early
- Text: Slightly simplify code
- Fix ContainsPlaceHolder considering \n a placeholder
- Fix Texts not being displayed
- Fix Modernize to not modify data while iterating over it
- Fix nil errors in dynamic conditions
- Make BuffTrigger 2 hide the per match checks if not applicable
- Weapon Enchant: Hide remaining time/stacks option if they don't work
- Don't pretend texts with \n contain placeholders
- Fix small issue in Conditions custom error description
- Remove region.justCreated which is unused
- Fix some errors in Templates on Classic
- Make Time Formats more flexible
- Icon/AuraBar: Make thumbnail icon resilent against certain data
- Fixup misleading text
- Fix remaining time check event to extra clones for nameplate trigger
- Fix Crit Chance in Character Stats trigger
- Improve Talent Load Option
- Improve Talent trigger
- Add a "Alive" load option
- Fix the merged zone id load option
- Improve layout around Item Load Option
- Fix number load options with strings
- Add Duplicate conditions feature
- Merge zone id and zone group id load options
- Fix typo in Stop Motion description
- Workaround UnitStagger returning nil
- Slight improvement in readable trigger function
- Change trigger ui categorization
- Fix matching of strings which include --

Kevin Krol (1):

- Fix target type check to compare against a string

Ryan Delk (1):

- docs: fix broken links to extensions

Stanzilla (2):

- Update TOC for Patch 9.0.5
- Update WeakAurasModelPaths from wow.tools

mrbuds (8):

- fix combat log trigger's icon for classic
- delete update-modelpaths branch after closing PR
- fix CancelClose
- add rotation slider and mouse interaction for preview
- add a searchbox to model picker
- Update WeakAurasModelPaths from wow.tools
- WeakAurasModelPaths update script from wow.tools
- Cast trigger: add latency overlay (#2900)

