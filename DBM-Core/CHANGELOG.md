# Deadly Boss Mods Core

## [9.1.0](https://github.com/DeadlyBossMods/DeadlyBossMods/tree/9.1.0) (2021-06-29)
[Full Changelog](https://github.com/DeadlyBossMods/DeadlyBossMods/compare/9.0.30...9.1.0) [Previous Releases](https://github.com/DeadlyBossMods/DeadlyBossMods/releases)

- Fix two mistakes  
- Full trash mod for new dungeon now drycoded  
    Prep for release with toc bumps  
- Kill off instance lockout feature, it uses a lot of local variable and literally no one uses that feature. Also fixed a bug where a lot of the other sync handlers got in middle of the do/end of instance feature over years.  
- Improve sync security by making guild syncs use their own handler similar to how whispers are handled, preventing any troll syncs sent to guild that don't belong there to be rejected.  
- Oh yeah, an add this for "hard" mode  
- So'leah drycode  
- Even retail benefits from this, add range 28  
- Add another public facing stage api, this time one that lets mods or weak auras request current stage a mod is in (if applicable) for either specific mod by mod id OR by simply doing request without modId, and having DBM just give a return for first mod in combat table  
- Fix function name  
- Fulfil request to prio melee over ranged for threat icons. This is very ugly but should work.  
- closing ends are apparently hard  
- fixed missing closing end  
- Update painsmith from mythic testing, which i apparently forgot to do after testing do to all the BCC stuff.  
    ALso did a pass on other stuff from hotfixes and my testing notes I never finished gong through.  
- Switch most of painsmiths spells back to combat log events that were corrected  
- Time Capn drycode  
- dumb  
- Another boss drycode, including it's hard mode. obviously as a drycode though it's not done/fully functional yet  
- Added drycode for Mailroom  
    Added drycode for  Oasis  
    Preliminary hard mode support for encounders drycoded so far  
- Update localization.cn.lua (#597)  
- Dumb shit  
- Not used to report actually reporting more than one issue, so i didn't even check if there was a second one.  
- Fix bad copy/paste  
- Two spell renames  
    Two Tazavesh drycodes  
- bump alpha  
