-- tab size is 4
-- registrations for media from the client itself belongs in LibSharedMedia-3.0

local LSM = LibStub("LibSharedMedia-3.0")
local koKR, ruRU, zhCN, zhTW, western = LSM.LOCALE_BIT_koKR, LSM.LOCALE_BIT_ruRU, LSM.LOCALE_BIT_zhCN, LSM.LOCALE_BIT_zhTW, LSM.LOCALE_BIT_western

local MediaType_BACKGROUND = LSM.MediaType.BACKGROUND
local MediaType_BORDER = LSM.MediaType.BORDER
local MediaType_FONT = LSM.MediaType.FONT
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR 

-- ----- 
-- BACKGROUND 
-- ----- 
LSM:Register(MediaType_BACKGROUND, "Moo", [[Interface\Addons\SharedMedia_Naowh\background\moo.tga]])
LSM:Register(MediaType_BACKGROUND, "Bricks", [[Interface\Addons\SharedMedia_Naowh\background\bricks.tga]])
LSM:Register(MediaType_BACKGROUND, "Brushed Metal", [[Interface\Addons\SharedMedia_Naowh\background\brushedmetal.tga]])
LSM:Register(MediaType_BACKGROUND, "Copper", [[Interface\Addons\SharedMedia_Naowh\background\copper.tga]])
LSM:Register(MediaType_BACKGROUND, "Smoke", [[Interface\Addons\SharedMedia_Naowh\background\smoke.tga]])
LSM:Register(MediaType_BACKGROUND, "Naowh Arrow", [[Interface\Addons\SharedMedia_Naowh\background\NaowhArrow.tga]])
LSM:Register(MediaType_BACKGROUND, "Naowh Glow", [[Interface\Addons\SharedMedia_Naowh\background\NaowhGlow.tga]])
LSM:Register(MediaType_BACKGROUND, "Naowh Arrow Left", [[Interface\Addons\SharedMedia_Naowh\background\NaowhArrowLeft.tga]])
LSM:Register(MediaType_BACKGROUND, "Naowh Arrow Right", [[Interface\Addons\SharedMedia_Naowh\background\NaowhArrowRight.tga]])
LSM:Register(MediaType_BACKGROUND, "Naowh Arrow Glow", [[Interface\Addons\SharedMedia_Naowh\background\arrow_glow.tga]])

-- ----- 
--  BORDER 
-- ---- 
LSM:Register(MediaType_BORDER, "RothSquare", [[Interface\Addons\SharedMedia_Naowh\border\roth.tga]])
LSM:Register(MediaType_BORDER, "SeerahScalloped", [[Interface\Addons\SharedMedia_Naowh\border\SeerahScalloped.blp]])
LSM:Register(MediaType_BORDER, "Naowh1", [[Interface\Addons\SharedMedia_Naowh\border\Naowh1.tga]])
LSM:Register(MediaType_BORDER, "Naowh2", [[Interface\Addons\SharedMedia_Naowh\border\Naowh2.tga]])
LSM:Register(MediaType_BORDER, "Naowh3", [[Interface\Addons\SharedMedia_Naowh\border\Naowh3.tga]])

-- -----
--   FONT
-- -----
LSM:Register(MediaType_FONT, "Adventure",					[[Interface\Addons\SharedMedia_Naowh\fonts\adventure\Adventure.ttf]])
LSM:Register(MediaType_FONT, "All Hooked Up",				[[Interface\Addons\SharedMedia_Naowh\fonts\all_hooked_up\HookedUp.ttf]])
LSM:Register(MediaType_FONT, "Bazooka",						[[Interface\Addons\SharedMedia_Naowh\fonts\bazooka\Bazooka.ttf]])
LSM:Register(MediaType_FONT, "Black Chancery",				[[Interface\Addons\SharedMedia_Naowh\fonts\black_chancery\BlackChancery.ttf]])
LSM:Register(MediaType_FONT, "Celestia Medium Redux",		[[Interface\Addons\SharedMedia_Naowh\fonts\celestia_medium_redux\CelestiaMediumRedux1.55.ttf]])
LSM:Register(MediaType_FONT, "DejaVu Sans",					[[Interface\Addons\SharedMedia_Naowh\fonts\deja_vu\DejaVuLGCSans.ttf]],							ruRU + western)
LSM:Register(MediaType_FONT, "DejaVu Serif",				[[Interface\Addons\SharedMedia_Naowh\fonts\deja_vu\DejaVuLGCSerif.ttf]],							ruRU + western)
LSM:Register(MediaType_FONT, "DorisPP",						[[Interface\Addons\SharedMedia_Naowh\fonts\doris_pp\DorisPP.ttf]])
LSM:Register(MediaType_FONT, "Enigmatic",					[[Interface\Addons\SharedMedia_Naowh\fonts\enigmatic\EnigmaU_2.ttf]])
LSM:Register(MediaType_FONT, "Fitzgerald",					[[Interface\Addons\SharedMedia_Naowh\fonts\fitzgerald\Fitzgerald.ttf]])
LSM:Register(MediaType_FONT, "Gentium Plus",				[[Interface\Addons\SharedMedia_Naowh\fonts\gentium_plus\GentiumPlus-R.ttf]],						ruRU + western)
LSM:Register(MediaType_FONT, "Hack",						[[Interface\Addons\SharedMedia_Naowh\fonts\hack\Hack-Regular.ttf]])
LSM:Register(MediaType_FONT, "Liberation Sans",				[[Interface\Addons\SharedMedia_Naowh\fonts\liberation\LiberationSans-Regular.ttf]],				ruRU + western)
LSM:Register(MediaType_FONT, "Liberation Serif",			[[Interface\Addons\SharedMedia_Naowh\fonts\liberation\LiberationSerif-Regular.ttf]],				ruRU + western)
LSM:Register(MediaType_FONT, "SF Atarian System",			[[Interface\Addons\SharedMedia_Naowh\fonts\sf_atarian_system\SFAtarianSystem.ttf]])
LSM:Register(MediaType_FONT, "SF Covington",				[[Interface\Addons\SharedMedia_Naowh\fonts\sf_covington\SFCovington.ttf]])
LSM:Register(MediaType_FONT, "SF Movie Poster",				[[Interface\Addons\SharedMedia_Naowh\fonts\sf_movie_poster\SFMoviePoster-Bold.ttf]])
LSM:Register(MediaType_FONT, "SF Wonder Comic",				[[Interface\Addons\SharedMedia_Naowh\fonts\sf_wonder_comic\SFWonderComic.ttf]])
LSM:Register(MediaType_FONT, "swf!t",						[[Interface\Addons\SharedMedia_Naowh\fonts\swf!t\SWF!T___.ttf]])
LSM:Register(MediaType_FONT, "WenQuanYi Zen Hei",			[[Interface\Addons\SharedMedia_Naowh\fonts\wen_quan_yi_zen_hei\wqy-zenhei.ttf]],					koKR + ruRU + zhCN + zhTW + western)
LSM:Register(MediaType_FONT, "Yellowjacket",				[[Interface\Addons\SharedMedia_Naowh\fonts\yellowjacket\yellow.ttf]])
LSM:Register("font", "Naowh", [[Interface\Addons\SharedMedia_Naowh\font\Naowh.ttf]],					ruRU + western) 
LSM:Register("font", "GothamNarrowUltra", [[Interface\Addons\SharedMedia_Naowh\font\GothamNarrowUltra.ttf]],					ruRU + western)

-- -----
--   SOUND
-- -----
LSM:Register("sound", "|cff0091ed1 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\1 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed2 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\2 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed3 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\3 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed4 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\4 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed5 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\5 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed6 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\6 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed7 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\7 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed8 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\8 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed9 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\9 -Naowh.ogg]])
LSM:Register("sound", "|cff0091ed10 -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\10 -Naowh.ogg]])
LSM:Register("sound", "|cff0091edAdd -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Add -Naowh.ogg]])
LSM:Register("sound", "|cff0091edAdds -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Adds -Naowh.ogg]])
LSM:Register("sound", "|cff0091edAoE -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\AoE -Naowh.ogg]])
LSM:Register("sound", "|cff0091edAvoid -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Avoid -Naowh.ogg]])
LSM:Register("sound", "|cff0091edBait -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Bait -Naowh.ogg]])
LSM:Register("sound", "|cff0091edBehind -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Behind -Naowh.ogg]])
LSM:Register("sound", "|cff0091edBloodlust -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Bloodlust -Naowh.ogg]])
LSM:Register("sound", "|cff0091edBuff -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Buff -Naowh.ogg]])
LSM:Register("sound", "|cff0091edCC -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\CC -Naowh.ogg]])
LSM:Register("sound", "|cff0091edClear In -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Clear In -Naowh.ogg]])
LSM:Register("sound", "|cff0091edClear -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Clear -Naowh.ogg]])
LSM:Register("sound", "|cff0091edCollect -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Collect -Naowh.ogg]])
LSM:Register("sound", "|cff0091edCombat -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Combat -Naowh.ogg]])
LSM:Register("sound", "|cff0091edDance -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Dance -Naowh.ogg]])
LSM:Register("sound", "|cff0091edDebuff -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Debuff -Naowh.ogg]])
LSM:Register("sound", "|cff0091edDispell -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Dispell -Naowh.ogg]])
LSM:Register("sound", "|cff0091edDodge Inc -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Dodge Inc -Naowh.ogg]])
LSM:Register("sound", "|cff0091edDodge -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Dodge -Naowh.ogg]])
LSM:Register("sound", "|cff0091edDot -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Dot -Naowh.ogg]])
LSM:Register("sound", "|cff0091edFixate -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Fixate -Naowh.ogg]])
LSM:Register("sound", "|cff0091edFrontal -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Frontal -Naowh.ogg]])
LSM:Register("sound", "|cff0091edHide -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Hide -Naowh.ogg]])
LSM:Register("sound", "|cff0091edHigh Stacks -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\High Stacks -Naowh.ogg]])
LSM:Register("sound", "|cff0091edImmune -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Immune -Naowh.ogg]])
LSM:Register("sound", "|cff0091edIn -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\In -Naowh.ogg]])
LSM:Register("sound", "|cff0091edInc -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Inc -Naowh.ogg]])
LSM:Register("sound", "|cff0091edInside -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Inside -Naowh.ogg]])
LSM:Register("sound", "|cff0091edIntermission -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Intermission -Naowh.ogg]])
LSM:Register("sound", "|cff0091edKick -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Kick -Naowh.ogg]])
LSM:Register("sound", "|cff0091edKnock -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Knock -Naowh.ogg]])
LSM:Register("sound", "|cff0091edLeft -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Left -Naowh.ogg]])
LSM:Register("sound", "|cff0091edLinked -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Linked -Naowh.ogg]])
LSM:Register("sound", "|cff0091edLoS -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\LoS -Naowh.ogg]])
LSM:Register("sound", "|cff0091edLostVikings -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\LongboatRaid.ogg]])
LSM:Register("sound", "|cff0091edMelee -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Melee -Naowh.ogg]])
LSM:Register("sound", "|cff0091edMove -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Move -Naowh.ogg]])
LSM:Register("sound", "|cff0091edNext -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Next -Naowh.ogg]])
LSM:Register("sound", "|cff0091edNuke -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Nuke -Naowh.ogg]])
LSM:Register("sound", "|cff0091edOrb -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Orb -Naowh.ogg]])
LSM:Register("sound", "|cff0091edOut -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Out -Naowh.ogg]])
LSM:Register("sound", "|cff0091edPersonal -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Personal -Naowh.ogg]])
LSM:Register("sound", "|cff0091edPot -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Pot -Naowh.ogg]])
LSM:Register("sound", "|cff0091edPull -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Pull -Naowh.ogg]])
LSM:Register("sound", "|cff0091edPush -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Push -Naowh.ogg]])
LSM:Register("sound", "|cff0091edRanged -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Ranged -Naowh.ogg]])
LSM:Register("sound", "|cff0091edReady -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Ready -Naowh.ogg]])
LSM:Register("sound", "|cff0091edReflect -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Reflect -Naowh.ogg]])
LSM:Register("sound", "|cff0091edRight -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Right -Naowh.ogg]])
LSM:Register("sound", "|cff0091edRun -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Run -Naowh.ogg]])
LSM:Register("sound", "|cff0091edShield -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Shield -Naowh.ogg]])
LSM:Register("sound", "|cff0091edSoak -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Soak -Naowh.ogg]])
LSM:Register("sound", "|cff0091edSpread -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Spread -Naowh.ogg]])
LSM:Register("sound", "|cff0091edStack -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Stack -Naowh.ogg]])
LSM:Register("sound", "|cff0091edStop -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Stop -Naowh.ogg]])
LSM:Register("sound", "|cff0091edStopcast -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Stopcast -Naowh.ogg]])
LSM:Register("sound", "|cff0091edSwitch -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Switch -Naowh.ogg]])
LSM:Register("sound", "|cff0091edTaunt -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Taunt -Naowh.ogg]])
LSM:Register("sound", "|cff0091edTotem -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Totem -Naowh.ogg]])
LSM:Register("sound", "|cff0091edTrap -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Trap -Naowh.ogg]])
LSM:Register("sound", "|cff0091edTurn -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Turn -Naowh.ogg]])
LSM:Register("sound", "|cff0091edLorgok Boss Dmg -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_BossDmg.ogg]])
LSM:Register("sound", "|cff0091edLorgok Burp -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_Burp.ogg]])
LSM:Register("sound", "|cff0091edLorgok Doesnt Happen -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_DoesntHappen.ogg]])
LSM:Register("sound", "|cff0091edLorgok Ejaculate -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_Ejaculate.ogg]])
LSM:Register("sound", "|cff0091edLorgok Help -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_Help.ogg]])
LSM:Register("sound", "|cff0091edLorgok Noooo -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_Noooo.ogg]])
LSM:Register("sound", "|cff0091edLorgok Oh What -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_OhWhat.ogg]])
LSM:Register("sound", "|cff0091edLorgok Ok Bro -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_OkBro.ogg]])
LSM:Register("sound", "|cff0091edLorgok Oribole -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_Oribole.ogg]])
LSM:Register("sound", "|cff0091edLorgok Stupid Dude -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_StupidDude.ogg]])
LSM:Register("sound", "|cff0091edLorgok WTF -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_WTF.ogg]])
LSM:Register("sound", "|cff0091edLorgok Yeah -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_Yeah.ogg]])
LSM:Register("sound", "|cff0091edLorgok Boss Dmg -Naowh|r", [[Interface\Addons\SharedMedia_Naowh\sound\Lorgok_BossDmg.ogg]])


-- -----
--   STATUSBAR
-- -----
LSM:Register(MediaType_STATUSBAR, "Aluminium",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Aluminium]])
LSM:Register(MediaType_STATUSBAR, "Armory",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Armory]])
LSM:Register(MediaType_STATUSBAR, "BantoBar",			[[Interface\Addons\SharedMedia_Naowh\statusbar\BantoBar]])
LSM:Register(MediaType_STATUSBAR, "Bars",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Bars]])
LSM:Register(MediaType_STATUSBAR, "Bumps",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Bumps]])
LSM:Register(MediaType_STATUSBAR, "Button",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Button]])
LSM:Register(MediaType_STATUSBAR, "Charcoal",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Charcoal]])
LSM:Register(MediaType_STATUSBAR, "Cilo",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Cilo]])
LSM:Register(MediaType_STATUSBAR, "Cloud",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Cloud]])
LSM:Register(MediaType_STATUSBAR, "Comet",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Comet]])
LSM:Register(MediaType_STATUSBAR, "Dabs",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Dabs]])
LSM:Register(MediaType_STATUSBAR, "DarkBottom",			[[Interface\Addons\SharedMedia_Naowh\statusbar\DarkBottom]])
LSM:Register(MediaType_STATUSBAR, "Diagonal",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Diagonal]])
LSM:Register(MediaType_STATUSBAR, "Empty",			    [[Interface\Addons\SharedMedia_Naowh\statusbar\Empty]])
LSM:Register(MediaType_STATUSBAR, "Falumn",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Falumn]])
LSM:Register(MediaType_STATUSBAR, "Fifths",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Fifths]])
LSM:Register(MediaType_STATUSBAR, "Flat",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Flat]])
LSM:Register(MediaType_STATUSBAR, "Fourths",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Fourths]])
LSM:Register(MediaType_STATUSBAR, "Frost",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Frost]])
LSM:Register(MediaType_STATUSBAR, "Glamour",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour]])
LSM:Register(MediaType_STATUSBAR, "Glamour2",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour2]])
LSM:Register(MediaType_STATUSBAR, "Glamour3",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour3]])
LSM:Register(MediaType_STATUSBAR, "Glamour4",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour4]])
LSM:Register(MediaType_STATUSBAR, "Glamour5",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour5]])
LSM:Register(MediaType_STATUSBAR, "Glamour6",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour6]])
LSM:Register(MediaType_STATUSBAR, "Glamour7",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glamour7]])
LSM:Register(MediaType_STATUSBAR, "Glass",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Glass]])
LSM:Register(MediaType_STATUSBAR, "Glaze",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Glaze]])
LSM:Register(MediaType_STATUSBAR, "Glaze v2",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Glaze2]])
LSM:Register(MediaType_STATUSBAR, "Gloss",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Gloss]])
LSM:Register(MediaType_STATUSBAR, "Graphite",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Graphite]])
LSM:Register(MediaType_STATUSBAR, "Grid",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Grid]])
LSM:Register(MediaType_STATUSBAR, "Hatched",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Hatched]])
LSM:Register(MediaType_STATUSBAR, "Healbot",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Healbot]])
LSM:Register(MediaType_STATUSBAR, "Lyfe",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Lyfe]])
LSM:Register(MediaType_STATUSBAR, "LiteStep",			[[Interface\Addons\SharedMedia_Naowh\statusbar\LiteStep]])
LSM:Register(MediaType_STATUSBAR, "LiteStepLite",		[[Interface\Addons\SharedMedia_Naowh\statusbar\LiteStepLite]])
LSM:Register(MediaType_STATUSBAR, "Melli",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Melli]])
LSM:Register(MediaType_STATUSBAR, "Melli Dark",			[[Interface\Addons\SharedMedia_Naowh\statusbar\MelliDark]])
LSM:Register(MediaType_STATUSBAR, "Melli Dark Rough",	[[Interface\Addons\SharedMedia_Naowh\statusbar\MelliDarkRough]])
LSM:Register(MediaType_STATUSBAR, "Minimalist",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Minimalist]])
LSM:Register(MediaType_STATUSBAR, "Otravi",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Otravi]])
LSM:Register(MediaType_STATUSBAR, "Outline",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Outline]])
LSM:Register(MediaType_STATUSBAR, "Perl",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Perl]])
LSM:Register(MediaType_STATUSBAR, "Perl v2",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Perl2]])
LSM:Register(MediaType_STATUSBAR, "Pill",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Pill]])
LSM:Register(MediaType_STATUSBAR, "Rain",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Rain]])
LSM:Register(MediaType_STATUSBAR, "Rocks",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Rocks]])
LSM:Register(MediaType_STATUSBAR, "Round",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Round]])
LSM:Register(MediaType_STATUSBAR, "Ruben",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Ruben]])
LSM:Register(MediaType_STATUSBAR, "Runes",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Runes]])
LSM:Register(MediaType_STATUSBAR, "Skewed",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Skewed]])
LSM:Register(MediaType_STATUSBAR, "Smooth",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Smooth]])
LSM:Register(MediaType_STATUSBAR, "Smooth v2",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Smoothv2]])
LSM:Register(MediaType_STATUSBAR, "Smudge",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Smudge]])
LSM:Register(MediaType_STATUSBAR, "Steel",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Steel]])
LSM:Register(MediaType_STATUSBAR, "Striped",			[[Interface\Addons\SharedMedia_Naowh\statusbar\Striped]])
LSM:Register(MediaType_STATUSBAR, "Tube",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Tube]])
LSM:Register(MediaType_STATUSBAR, "Water",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Water]])
LSM:Register(MediaType_STATUSBAR, "Wglass",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Wglass]])
LSM:Register(MediaType_STATUSBAR, "Wisps",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Wisps]])
LSM:Register(MediaType_STATUSBAR, "Xeon",				[[Interface\Addons\SharedMedia_Naowh\statusbar\Xeon]])