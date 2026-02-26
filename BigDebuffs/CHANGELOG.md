# BigDebuffs

## [v59](https://github.com/jordonwow/bigdebuffs/tree/v59) (2026-02-20)
[Full Changelog](https://github.com/jordonwow/bigdebuffs/compare/v58...v59) [Previous Releases](https://github.com/jordonwow/bigdebuffs/releases)

- Refactor parent assignment logic for frame anchor  
     - Updated the Blizzard unit-frame attachment logic to detect when the chosen anchor is a CompactUnitFrame and parent the BigDebuffs overlay directly to that frame instead of the container, falling back safely for texture anchors (BigDebuffs/BigDebuffs.lua#L1286-L1315). This keeps the overlay out of CompactPartyFrame’s immediate children so FrameSort no longer mistakes it for a unit frame, eliminating the extra slot/gap that appeared between raid-style party members.  
    - Kept all other anchoring and frame-level handling unchanged so existing behavior on normal party, raid, and third-party frames is preserved.  