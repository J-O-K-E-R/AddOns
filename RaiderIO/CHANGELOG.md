# Raider.IO Mythic Plus, Raiding, and Recruitment

## [v202305110600](https://github.com/RaiderIO/raiderio-addon/tree/v202305110600) (2023-05-11)
[Full Changelog](https://github.com/RaiderIO/raiderio-addon/compare/v202305100600...v202305110600) [Previous Releases](https://github.com/RaiderIO/raiderio-addon/releases)

- [Raider.IO] Database Refresh  
- The keystone data can be out of order, so we extract it using the field IDs to ensure we read the correct parts of the link.  
- Instead of relying on a complex pattern with many capture groups, we instead match the relevant item, then extract the contents using strsplit. This fixes the issue with the super long pattern matching being way too costly on the CPU cycles and causing a moment of frame drops when hovering item links. This only happened in some cases, but this fix should eliminate the issue from happening again.  
