local E = select(2, ...):unpack()

if not E.isSL then return end

local BLANK = {}





E.spell_cdmod_talents = {
	[275699] = { 288848, 45 },
	[48707] = { 205727, 20 },
	[108199] = { 206970, 30 },
	[49576] = { 334724, 3 },
	[189110] = { 207550, 8 },
	[205629] = { 207550, 8 },
	[191427] = { 235893, 120 },

	[198793] = { 206476, 5 },
	[740] = { 197073, 60 },
	[50334] = { 339062, 30 },
	[102558] = { 339062, 30 },
	[77761] = { 213200, 60 },
	[288613] = { 203129, 20 },
	[5384] = { 336747, 5 },
	[342245] = { 342249, 30 },
	[108853] = { 205029, 2 },
	[110960] = { 210476, 45 },
	[109132] = { 115173, 5 },
	[119381] = { 264348, 10 },
	[116849] = { 202424, 45 },

	[322109] = { 337296, 120 },

	[31821] = { 199324, 60 },
	[62618] = { 197590, 90 },
	[8122] = { 196704, 30 },
	[15487] = { 263716, 15 },
	[15286] = { 199855, 45 },
	[47585] = { 288733, 30 },
	[32379] = { 336133, 12 },
	[32375] = { 341167, 30 },
	[195457] = { 256188, 15 },

	[2094] = { 256165, 30 },
	[51533] = { 262624, 30 },
	[51514] = { 204268, 19 },
	[108280] = { 353115, 90 },
	[79206] = { 192088, 60 },
	[51490] = { 204403, 15 },
	[30283] = { 264874, 15 },

	[113942] = { 248855, 30 },
	[17962] = { 337166, 3 },
	[100] = { 103827, 3 },
	[97462] = { 235941, 60 },
	[1160] = { 199023, 15 },
	[6544] = { 202163, 15 },
	[199086] = { 202163, 15 },
	[12975] = { 280001, 60 },
	[64382] = { 329033, 120 },
}





E.spell_cdmod_talents_mult = {
	[49028] = { 233412, .50 },
	[279302] = { 334692, .50 },
	[179057] = { 206477, .67 },
	[207684] = { 209281, .80, 211489, .75 },
	[202137] = { 209281, .80, 211489, .75 },
	[204596] = { 209281, .80, 211489, .75 },
	[202138] = { 211489, .75 },
	[195072] = { 337685, .7 },
	[22812] = { 203965, .67 },
	[61336] = { 203965, .67 },
	[323764] = { 354118, .50 },
	[186257] = { 266921, .80, 336742, .65, 203235, .50 },
	[186289] = { 266921, .80, 336742, .65 },
	[186265] = { 266921, .80, 336742, .65 },
	[288613] = { 336742, .65 },
	[193530] = { 336742, .65 },
	[266779] = { 336742, .65 },
	[322507] = { 325093, .80 },
	[119582] = { 325093, .80 },
	[115203] = { 202107, .50 },
	[115176] = { 202200, .25 },
	[115310] = { 353313, .50 },
	[642] = { 114154, .70 },
	[633] = { 114154, .70 },
	[498] = { 114154, .70 },
	[184662] = { 114154, .70 },
	[31850] = { 114154, .70 },
	[204018] = { 216853, .67 },
	[1022] = { 216853, .67 },
	[6940] = { 216853, .67 },
	[199452] = { 216853, .67 },
	[2050] = { 235587, .90 },
	[121471] = { 212081, .67 },
	[1856] = { 212081, .67 },
	[1966] = { 212081, .67 },
	[227847] = { 236308, .67 },
	[152277] = { 236308, .67 },
}

E.spell_chmod_talents = {
	[48265] = { 356367, 1 },
	[43265] = { 356367, 1 },
	[49576] = { 356367, 1 },
	[185123] = { 203556, 1 },
	[259495] = { 264332, 1 },
	[259489] = { 269737, 1 },
	[108853] = { 205029, 1 },
	[122] = { 205036, 1 },
	[121253] = { 337288, 1 },
	[109132] = { 115173, 1 },
	[1044] = { 199454, 1 },
	[1022] = { 199454, 1 },
	[190784] = { 230332, 1 },
	[2050] = { 235587, 1 },
	[73325] = { 336470, 1 },
	[527] = { 196162, 1 },
	[5394] = { 108283, 1 },
	[157153] = { 108283, 1 },
	[51505] = { 108283, 1 },
	[61295] = { 108283, 1 },
	[185313] = { 238104, 1 },
	[17962] = { 337166, 1 },
	[100] = { 103827, 1 },
	[6544] = { 335214, 2 },
	[7384] = { 262150, 1 },
	[871] = { 335629, 1 },

	[275779] = { 204023, 1 },
	[24275] = { 337638, 1 },
}

E.spell_cdmod_by_haste = {
	[203720] = true,
	[232893] = true,
	[342817] = true,
	[258920] = true,
	[185123] = true,
	[204157] = true,
	[22842] = true,
	[19434] = true,
	[259495] = true,
	[108853] = true,
	[319836] = true,
	[100784] = true,
	[113656] = true,
	[121253] = true,
	[119582] = true,
	[107428] = true,
	[152175] = true,
	[31935] = true,
	[204883] = true,
	[205385] = true,
	[32379] = true,
	[342240] = true,
	[196447] = true,
	[23922] = true,
	[2565] = true,
	[260643] = true,
	[317483] = true,
}





E.spell_noreset_onencounterend = {
	[20608] = true,
	[319217] = true,
}

E.spell_cdmod_by_aura_mult = {
	[22842] = { 0.25, "isBerserk" },
	[257044] = { 0.4, "isTrueShot" },
}






E.spell_linked = {
	[189110] = { 189110, 205629 },
	[205629] = { 189110, 205629 },
}

E.spell_merged = {

	[196770] = 287250,
	[30449] = 198100,
	[57934] = 221622,
	[6544] = 199086,
	[1725] = 354661,

	[199448] = 199452,
	[204361] = 193876,
	[204362] = 193876,
	[221527] = 217832,
	[202140] = 207684,
	[207682] = 202137,
	[204513] = 204596,
	[198149] = 84714,
	[204406] = 51490,
	[316593] = 5246,

	[215769] = 215982,

	[108291] = 319454,
	[108292] = 319454,
	[108293] = 319454,
	[108294] = 319454,

	[338035] = 338142,
	[338018] = 338142,
	[326462] = 338142,
	[326446] = 338142,
	[326647] = 338142,




	[274282] = 274281,
	[274283] = 274281,
	[77764] = 77761,
	[106898] = 77761,
	[102417] = 102401,
	[49376] = 102401,
	[16979] = 102401,
	[102383] = 102401,
	[53271] = 272651,
	[272682] = 272651,
	[264667] = 272651,
	[272678] = 272651,
	[264735] = 272651,
	[281195] = 272651,
	[272679] = 272651,
	[32182] = 2825,
	[211004] = 51514,
	[210873] = 51514,
	[211015] = 51514,
	[211010] = 51514,
	[277784] = 51514,
	[269352] = 51514,
	[277778] = 51514,
	[309328] = 51514,
	[19647] = 119898,
	[119910] = 119898,
	[132409] = 119898,
	[212623] = 119898,
	[6358] = 119898,
	[261589] = 119898,
	[89808] = 119898,
	[119905] = 119898,
	[132411] = 119898,
	[89766] = 119898,
	[119914] = 119898,
	[25046] = 129597,
	[28730] = 129597,
	[232633] = 129597,
	[50613] = 129597,
	[69179] = 129597,
	[80483] = 129597,
	[155145] = 129597,
	[202719] = 129597,
	[33697] = 20572,
	[33702] = 20572,
	[28880] = 59542,
	[121093] = 59542,
	[59547] = 59542,
	[59544] = 59542,
	[59543] = 59542,
	[59545] = 59542,
	[59548] = 59542,
	[328622] = 328278,
	[328282] = 328278,
	[328620] = 328278,
	[328281] = 328278,
	[317488] = 317483,
	[212641] = 86659,

	[93985] = 106839,
	[97547] = 78675,
	[220543] = 15487,
}

E.spell_merged_updateoncast = {
	[274281] = { 25, 1392543 },
	[274282] = { 25, 1392542 },
	[274283] = { 25, 1392545 },
	[19647] = { 24 },
	[119910] = { 24 },
	[132409] = { 24 },
	[212623] = { 15 },
	[6358] = { 30 },
	[261589] = { 30 },
	[89808] = { 15 },
	[119905] = { 15 },
	[132411] = { 15 },
	[89766] = { 30 },
	[119914] = { 30 },
	[53271] = { 45 },
	[272682] = { 45 },
	[264667] = { 360 },
	[272678] = { 360 },
	[264735] = { 180 },
	[281195] = { 180 },
	[272679] = { 180 },
	[328282] = { 45, 3636845 },
	[328620] = { 45, 3636843 },
	[328622] = { 45, 3636846 },
	[328281] = { 45, 3636844 },
}

for k, v in pairs(E.spell_merged_updateoncast) do
	if not v[2] then
		local _, icon = GetSpellTexture(k)
		v[2] = icon
	end
end

E.spellcast_shared_cdstart = {
	[336126] = { 265221, 30, 59752, 90, 20594, 30, 7744, 30 },
	[336135] = { 265221, 30, 59752, 90, 20594, 30, 7744, 30 },
	[59752] = { 336126, 90, 336135, 90 },
	[20594] = { 336126, 30, 336135, 30 },
	[7744] = { 336126, 30, 336135, 30 },
	[265221] = { 336126, 30, 336135, 30 },
}

E.spellcast_cdreset = {
	[235219] = { nil, 45438, 11426, 120, 122 },
	[122] = { 206431, 120 },
	[115399] = { nil, 119582, 119582 },
	[310454] = { nil, 121253 },
	[200183] = { nil, 88625, 34861, 2050 },
	[327193] = { nil, 31935 },
	[367241] = { nil, 300728, 310143 },
	[217200] = { 336830, 34026 },
}

E.spellcast_cdr = {
	[47541] = {
		{ nil, 1, 63560 },
		{ 276837, nil, { [275699]=1, [42650]=5, [288853]=1 } },
		{ 334898, nil, { [43265]=2, [152280]=2, [324128]=2 } },
	},
	[207317] = { 276837, nil, { [275699]=1, [42650]=5, [288853]=1 } },
	[49998] = { 334898, nil, { [43265]=2, [152280]=2, [324128]=2 } },
	[206930] = { 334580, 2.0, 55233 },
	[106785] = { 340053, nil, { [106951]=0.3, [102543]=0.3 } },
	[106830] = { 340053, nil, { [106951]=0.3, [102543]=0.3 } },
	[5221] = { 340053, nil, { [106951]=0.3, [102543]=0.3 } },
	[1822] = { 340053, nil, { [106951]=0.3, [102543]=0.3 } },
	[202028] = { 340053, nil, { [106951]=0.3, [102543]=0.3 } },
	[274837] = { 340053, nil, { [106951]=0.3, [102543]=0.3 } },
	[185358] = { 260404, 2.5, 288613 },
	[257620] = { 260404, 2.5, 288613 },
	[217200] = {
		{ nil, 12, 19574 },

	},
	[19434] = { 248443, nil, { [186265]=5, [109304]=5 } },
	[133] = { 203283, 2, 190319 },
	[115181] = { 196736, 3, 115181, nil, "isBlackoutCombo" },
	[121253] = {
		{ nil, nil, { [325216]=3, [115203]=3, [322507]=3, [119582]=3, [115399]=3 } },
		{ 196736, nil, { [325216]=2, [115203]=2, [322507]=2, [119582]=2, [115399]=2 }, nil, "isBlackoutCombo" },
	},
	[100780] = { 268, nil, { [325216]=1, [115203]=1, [322507]=1, [119582]=1, [115399]=1 } },
	[115151] = { 336773, nil, { [322118]=0.3, [325197]=0.3 } },
	[322101] = { 336773, nil, { [322118]=0.3, [325197]=0.3 } },
	[124682] = { 336773, nil, { [322118]=0.3, [325197]=0.3 } },
	[116670] = { 336773, nil, { [322118]=0.3, [325197]=0.3 } },
	[100784] = {
		{ nil, nil, { [107428]=1, [113656]=1 } },
		{ 321076, nil, { [107428]=1, [113656]=1 }, nil, "isWeaponsOfOrder" },
	},
	[585] = { nil, 4, 88625 },
	[139] = { nil, 2, 34861 },
	[596] = { nil, 6, 34861 },
	[2060] = { nil, 6, 2050 },
	[2061] = { nil, 6, 2050 },

	[2050] = { nil, 30, 265202 },
	[34861] = { nil, 30, 265202 },

	[204883] = { 336314, 4, 34861 },
	[33076] = { 336314, 4, 2050 },
	[14914] = { 336314, 4, 88625 },

	[1856] = { 340080, 20 },
	[323547] = { 340084, 0.33, 79140 },

	[328547] = { 340084, 0.5, 79140 },
	[328305] = { 340084, 0.83, 79140 },
	[200806] = { 340084, 0.83, 79140 },
	[121411] = { 340084, 1.17, 79140 },
	[269513] = { 340084, 0.83, 79140 },
	[206328] = { 340084, 0.83, 79140 },
	[8676] = { 340084, 1.67, 79140 },
	[1833] = { 340084, 1.33, 79140 },
	[185311] = { 340084, 0.67, 79140 },
	[1725] = { 340084, 1, 79140 },
	[1966] = { 340084, 1.17, 79140 },
	[408] = { 340084, 0.83, 79140 },
	[6770] = { 340084, 1.17, 79140 },
	[5938] = { 340084, 0.67, 79140 },
	[315496] = { 340084, 0.83, 79140 },
	[32645] = { 340084, 1.17, 79140 },
	[51723] = { 340084, 1.17, 79140 },
	[703] = { 340084, 1.5, 79140 },
	[1329] = { 340084, 1.67, 79140 },
	[185565] = { 340084, 1.33, 79140 },
	[1943] = { 340084, 0.83, 79140 },

	[51505] = { 262303, nil, { [198067]=6, [192249]=6 }, nil, "isSurgeOfPower" },
	[23922] = { 335239, 5.0, 871 },

	[211881] = { 363736, 0.16, 191427 },
	[342817] = { 363736, 0.5, 191427 },
	[179057] = { 363736, 0.5, 191427,  nil, nil, 258887 },
	[162794] = { 363736, 0.66, 191427 },
	[188499] = { 363736, 0.25, 191427 },
	[198013] = { 363736, 0.5, 191427 },
}

E.spellcast_cdr_powerspender = {

	[49998] = { 205723, 6.75, 55233 },
	[61999] = { 205723, 4.5, 55233 },
	[327574] = { 205723, 3, 55233 },
	[47541] = { 205723, 6, 55233 },

	[193455] = { 270581, 1.17, 109304 },
	[34026] = { 270581, { [253]=1 }, 109304 },
	[53351] = { 270581, { [253]=0.33, default=0.5 }, 109304 },
	[2643] = { 270581, 1.33, 109304 },
	[257620] = { 270581, 1.0, 109304 },
	[19434] = { 270581, 1.75, 109304 },
	[186387] = { 270581, 0.5, 109304 },
	[342049] = { 270581, 1, 109304 },
	[212431] = { 270581, 1, 109304 },
	[203155] = { 270581, 2, 109304 },
	[271788] = { 270581, 0.5, 109304 },
	[259491] = { 270581, 1, 109304 },
	[187708] = { 270581, 1.75, 109304 },
	[212436] = { 270581, 1.5, 109304 },
	[259391] = { 270581, 0.75, 109304 },
	[186270] = { 270581, 1.5, 109304 },
	[259387] = { 270581, 1.5, 109304 },
	[195645] = { 270581, 1, 109304 },
	[185358] = { 270581, { [253]=1.33, [254]=1, [255]=2 }, 109304 },
	[131894] = { 270581, { [255]=1.5, default=1 }, 109304 },
	[120360] = { 270581, { [253]=2, [254]=1.5 }, 109304 },
	[208652] = { 270581, 1, 109304 },
	[205691] = { 270581, 2, 109304 },
	[120679] = { 270581, 0.83, 109304 },
	[982] = { 270581, { [253]=1.17, [254]=1.75, [255]=0.5 }, 109304 },
	[1513] = { 270581, { [253]=0.83, default=1.25 }, 109304 },

	[100784] = { 280197, 0.5, 137639 },
	[107428] = { 280197, 1, 137639 },
	[101546] = { 280197, 1, 137639 },
	[113656] = { 280197, 1.5, 137639 },
	[116847] = { 280197, 0.5, 137639 },
	[53385] = {
		{ 234299, 6, 853 },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[343527] = {
		{ 234299, 6, 853 },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[215661] = {
		{ 234299, 10, 853 },
		{ 337600, 5, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[85222] = {
		{ 234299, 6, 853 },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[85256] = {
		{ 234299, 6, 853 },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[152262] = {
		{ 234299, 6, 853 },
		{ 204074, 3, { 31884, 86659, 228049 } },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[53600] = {
		{ 234299, 6, 853 },
		{ 204074, 3, { 31884, 86659, 228049 } },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},
	[85673] = {
		{ 234299, 6, 853 },
		{ 204074, 3, { 31884, 86659, 228049 } },
		{ 337600, 3, { 1022, 204018, 6940, 199452, 1044 } },
	},

	[315341] = {
		{ nil, 5, { 13750, 315341, 13877, 195457, 315508, 2983, 137619, 271877, 51690, 1856 } },
		{ 354897, 5, { 5277, 1966 } },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[2098] = {
		{ nil, 5, { 13750, 315341, 13877, 195457, 315508, 2983, 137619, 271877, 51690, 1856 } },
		{ 354897, 5, { 5277, 1966 } },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[269513] = {
		{ nil, { [260]=5 }, { 13750, 315341, 13877, 195457, 315508, 2983, 137619, 271877, 51690, 1856 } },
		{ 238104, 7.5, 185313, 5 },
		{ 280719, 5, 280719 },
		{ 354897, 5, { 5277, 1966 } },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[315496] = {
		{ nil, { [260]=5 }, { 13750, 315341, 13877, 195457, 315508, 2983, 137619, 271877, 51690, 1856 } },
		{ 238104, 7.5, 185313, 5 },
		{ 280719, 5, 280719 },
		{ 354897, 5, { 5277, 1966 } },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[408] = {
		{ nil, { [260]=5 }, { 13750, 315341, 13877, 195457, 315508, 2983, 137619, 271877, 51690, 1856 } },
		{ 238104, 7.5, 185313, 5 },
		{ 280719, 5, 280719 },
		{ 354897, 5, { 5277, 1966 } },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},

	[319175] = {
		{ 238104, 7.5, 185313, 5 },
		{ 280719, 5, 280719 },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[196819] = {
		{ 238104, 7.5, 185313, 5 },
		{ 280719, 5, 280719 },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[1943] = {
		{ 238104, 7.5, 185313, 5 },
		{ 280719, 5, 280719 },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},
	[280719] = {
		{ 238104, 7.5, 185313, 5 },
		{ 354703, 5, 323654, nil, "isFlagellation" },
	},

	[184367] = { 152278, 4, 1719 },
	[6572] = { 152278, 2, { 107574, 871}, nil, nil, "revenge" },
	[772] = { 152278, 1.5, { 262161, 167105, 227847 }, nil, nil, "deadlyCalm" },
	[12294] = { 152278, 1.5, { 262161, 167105, 227847 }, nil, nil, "deadlyCalm" },
	[1464] = { 152278, 1, { 262161, 167105, 227847, 1719 }, nil, nil, "deadlyCalm" },
	[1680] = { 152278, { [73]=3, default=1.5 }, { 262161, 167105, 227847, 107574, 871 }, nil, nil, "deadlyCalm" },
	[163201] = { 152278, { [73]=4, default=2.0 }, { 262161, 167105, 227847, 107574, 871 }, nil, nil, "deadlyCalm" },
	[317483] = { 152278, { [73]=4, default=2.0 }, { 262161, 167105, 227847, 107574, 871 }, nil, nil, "deadlyCalm" },
	[1715] = { 152278, { [73]=1, default=0.5 }, { 262161, 167105, 227847, 1719, 107574, 871 }, nil, nil, "deadlyCalm" },
	[190456] = { 152278, { [72]=3, [73]=4, default=2 }, { 262161, 167105, 227847, 1719, 107574, 871 }, nil, nil, "deadlyCalm" },
	[202168] = { 152278, { [73]=1, default=0.5 }, { 262161, 167105, 227847, 1719, 107574, 871 }, nil, nil, "deadlyCalm" },
	[2565] = { 152278, { [73]=3, default=1.5 }, { 262161, 167105, 227847, 1719, 107574, 871 }, nil, nil, "deadlyCalm" },

	[342601] = { 337020, { [265]=2, [266]=0.6, default=1.5 }, { 205180, 265187, 1122 } },
	[264106] = { 337020, 6.0, 205180 },
	[324536] = { 337020, 2.0, 205180 },
	[344566] = { 337020, 6.0, 205180 },
	[27243] = { 337020, 2.0, 205180 },
	[278350] = { 337020, 2.0, 205180 },
	[104316] = { 337020, 1.2, 265187 },
	[111898] = { 337020, 0.6, 265187 },
	[105174] = { 337020, 1.8, 265187 },
	[267217] = { 337020, 0.6, 265187 },
	[264119] = { 337020, 0.6, 265187 },
	[267211] = { 337020, 1.2, 265187 },
	[212459] = { 337020, 1.2, 265187 },
	[116858] = { 337020, 3.0, 1122 },
	[5740] = { 337020, 4.5, 1122 },
	[17877] = { 337020, 1.5, 1122 },

	[22568] = { 364416, 3.5, { 106951, 102543 } },
	[1079] = { 364416, 3.5, { 106951, 102543 } },
	[285381] = { 364416, 3.5, { 106951, 102543 } },
	[52610] = { 364416, 3.5, 106951 },
	[22570] = { 364416, 3.5, { 106951, 102543 } },
}


E.sync_cdr_by_powerconsumed = {







































}





E.spell_aura_freespender = {
	[5302] = "revenge",
	[262228] = "deadlyCalm",
}

E.spell_auraremoved_cdstart_preactive = {
	[188501] = 188501,
	[132158] = 132158,
	[202425] = 202425,
	[5215] = 5215,
	[199483] = 199483,
	[34477] = 34477,
	[248518] = 248518,
	[205025] = 205025,
	[116680] = 116680,
	[209584] = 209584,
	[210294] = 210294,
	[215652] = 215652,

	[210918] = 210918,
	[328774] = 328774,
	[198817] = 198817,
	[256948] = 256948,
	[320224] = 319217,

	[5384] = 0,
	[57934] = 0,
	[345251] = 0,
}

E.spell_auraapplied_processspell = {
	[123981] = 114556,
	[209261] = 209258,
	[342246] = 342245,
	[110909] = 108978,
	[87024] = 86949,
	[305395] = 1044,
	[45182] = 31230,
	[113942] = 113942,
	[283167] = 336135,
	[344907] = 344907,
	[313015] = 312916,
	[320224] = 319217,
}

E.spell_dispel_cdstart = {
	[88423] = true,
	[2782] = true,
	[115450] = true,
	[218164] = true,
	[4987] = true,
	[213644] = true,
	[527] = true,
	[213634] = true,
	[51886] = true,
	[77130] = true,

	[316262] = true,
	[31935] = true,
	[119996] = true,

	[323436] = true,
	[6262] = true,

}

E.spell_auraapplied_disablespell = {
	[25771] = {
		[1022] = 0,
		[204018] = 0,
		[642] = 30,
		[633] = 0,
	},

}

E.selfLimitedMinMaxReducer = {
	[192058] = true,
	[46968] = true,

	[307865] = true,
	[304971] = true,
	[308491] = true,
	[323547] = true,
	[325013] = true,
	[312202] = true,
	[324386] = true,
	[307443] = true,
	[312321] = true,
	[310454] = true,
	[338142] = true,
	[306830] = true,
}

E.spell_damage_cdr_totem = {
	[118905] = { 265046, 5, 192058, 4, nil },
}

E.spell_damage_cdr_pet = {
	[83381] = { 339704, 0, 193530, nil, nil, true },
}


E.spell_damage_cdr = {
	[325464] = { 207126, 4.0, 51271, nil, nil, true },
	[325461] = { 207126, 4.0, 51271, nil, nil, true },
	[222026] = { 207126, 4.0, 51271, nil, nil, true },
	[222024] = { 207126, 4.0, 51271, nil, nil, true },
	[133] = { 155148, 1.0, 190319, nil, nil, true },
	[11366] = { 155148, 1.0, 190319, nil, nil, true },
	[108853] = { 155148, 1.0, 190319, nil, nil, true },
	[257542] = { 155148, 1.0, 190319, nil, nil, true },
	[190357] = { nil, 0.25, 84714 },
	[121253] = { 337264, 0, 132578, nil, nil, nil, 0.1 },
	[107270] = { 337264, 0, 132578, nil, nil, nil, 0.1 },
	[205523] = { 337264, 0, 132578, nil, nil, nil, 0.1 },
	[185099] = { 337481, 5, 113656, nil, nil, true },
	[46968] = { 275339, 15, 46968, nil, 3 },
	[6343] = { 335229, 1.5, 1160, 3, nil },





	[188389] = { 356250, 1, 320674, nil, nil, true },


}

E.spell_energize_cdr = {
	[193840] = { 258887, 3, 198013 },
	[196911] = { 341559, 0, 121471, 0.5 },
}

E.spell_interrupt_cdr = {
	[93985] = { 205673, nil, { [5217]=10, [61336]=10, [1850]=10, [252216]=10 } },
	[2139] = { 336777, 0, 2139 },
	[1766] = { 341535, 0, 31224, 2 }
}

if E.isBFA then
	E.cdrr_heartstopaura_blackList = {
		[320137] = true,
	}
end





E.runeforge_bonus_to_descid = {
	[6948] = 334724,
	[6941] = 334525,
	[6943] = 334580,
	[6946] = 334692,
	[6951] = 334898,
	[7051] = 337685,
	[7048] = 337547,
	[7043] = 337534,
	[7046] = 337544,
	[7095] = 339062,
	[7109] = 340053,
	[7571] = 354118,
	[8121] = 354118,
	[7003] = 336742,
	[7006] = 336747,
	[7009] = 336830,
	[7012] = 336867,
	[7016] = 336901,
	[7476] = 354333,
	[8123] = 354333,
	[7081] = 337296,
	[7077] = 337288,
	[7070] = 337481,
	[7726] = 356818,
	[8124] = 356818,
	[7078] = 337290,
	[7079] = 337570,
	[7053] = 337600,
	[7701] = 355447,
	[8125] = 355447,
	[7060] = 337831,
	[7064] = 337247,
	[7065] = 337638,
	[7061] = 337838,
	[6972] = 336470,
	[6984] = 337477,
	[6979] = 336133,
	[6977] = 336314,
	[7728] = 356395,
	[7703] = 356391,
	[8126] = { 356395, 356391},
	[7114] = 340080,
	[7118] = 340084,
	[7572] = 354703,
	[8127] = 354703,
	[6995] = 335897,
	[6989] = 336734,
	[7708] = 356218,
	[7709] = 356250,
	[8128] = { 356218, 356250},
	[7025] = 337020,
	[7038] = 337166,
	[7028] = 337065,
	[6955] = 335214,
	[6956] = 335229,
	[6957] = 335239,
	[6967] = 335629,
	[6965] = 335582,

}

E.runeforge_specid = {
	[334724] = nil, [334525] = 250, [334580] = 250, [334692] = 251, [334898] = 252,
	[337685] = 577, [337547] = 581, [337534] = nil, [337544] = 581,
	[339062] = 104, [340053] = 103, [354118] = nil,
	[336742] = nil, [336747] = nil, [336830] = 253, [336867] = 254, [336901] = 255,
	[354333] = nil,
	[337296] = nil, [337288] = 268, [337481] = 269, [356818] = nil, [337290] = 268, [337570] = 268,
	[337600] = nil, [355447] = nil, [337831] = 70, [337247] = 70, [337638] = 70, [337838] = 66,
	[336470] = nil, [337477] = 257, [336133] = 256, [336314] = 257, [356395] = nil, [356391] = nil,
	[340080] = nil, [340084] = 259, [354703] = nil,
	[335897] = 263, [336734] = 262, [356218] = nil, [356250] = nil,
	[337020] = nil, [337166] = 267, [337065] = nil,
	[335214] = nil, [335229] = 73, [335239] = 73, [335629] = 73, [335582] = 72,
}

E.runeforge_desc_to_powerid = {
	[334724] = 33, [334525] = 35, [334580] = 36, [334692] = 40, [334898] = 44,
	[337685] = 24, [337547] = 29, [337534] = 20, [337544] = 27,
	[339062] = 61, [340053] = 54, [354118] = 226,
	[336742] = 66, [336747] = 69, [336830] = 72, [336867] = 75, [336901] = 79,
	[354333] = 222,
	[337296] = 85, [337288] = 87, [337481] = 94, [356818] = 259, [337290] = 88, [337570] = 89,
	[337600] = 98, [355447] = 240, [337831] = 106, [337247] = 113, [337638] = 112, [337838] = 107,
	[336470] = 149, [337477] = 154, [336133] = 152, [336314] = 155, [356395] = 261, [356391] = 242,
	[340080] = 114, [340084] = 121, [354703] = 229,
	[335897] = 140, [336734] = 134, [356218] = 246, [356250] = nil,
	[337020] = 162, [337166] = 175, [337065] = 165,
	[335214] = 178, [335229] = 190, [335239] = 191, [335629] = 192, [335582] = 188,
}

E.runeforge_unity = {
	[354118] = true,
	[354333] = true,
	[356395] = true,
	[356391] = true,
	[355447] = true,
	[356818] = true,
	[356250] = true,
	[356218] = true,
	[354703] = true,
}

E.covenant_to_spellid = {
	321076,
	321079,
	321077,
	321078,
}

E.covenant_abilities = {
	[324739] = 1,
	[323436] = 1,
	[312202] = 1,
	[306830] = 1,
	[326434] = 1,
	[338142] = 1,
	[338035] = 1,
	[338018] = 1,
	[326462] = 1,
	[326446] = 1,
	[326647] = 1,



	[308491] = 1,
	[307443] = 1,
	[310454] = 1,
	[304971] = 1,
	[325013] = 1,


	[323547] = 1,
	[324386] = 1,
	[312321] = 1,
	[307865] = 1,
	[300728] = 2,
	[311648] = 2,
	[317009] = 2,
	[323546] = 2,
	[324149] = 2,
	[314793] = 2,
	[326860] = 2,
	[316958] = 2,
	[323673] = 2,
	[323654] = 2,
	[320674] = 2,
	[321792] = 2,
	[317483] = 2,
	[317488] = 2,
	[310143] = 3,
	[324128] = 3,
	[323639] = 3,
	[323764] = 3,
	[328231] = 3,
	[314791] = 3,
	[327104] = 3,

	[328622] = 3,
	[328282] = 3,
	[328620] = 3,
	[328281] = 3,
	[327661] = 3,
	[328305] = 3,
	[328923] = 3,
	[325640] = 3,
	[325886] = 3,
	[319217] = 3,
	[324631] = 4,
	[315443] = 4,
	[329554] = 4,
	[325727] = 4,
	[325028] = 4,
	[324220] = 4,
	[325216] = 4,
	[328204] = 4,
	[324724] = 4,
	[328547] = 4,
	[326059] = 4,
	[325289] = 4,
	[324143] = 4,
}

E.spell_benevolent_faerie_majorcd = {
	[55233] = true,
	[47568] = true,
	[275699] = true,
	[191427] = true,
	[187827] = true,
	[194223] = true,
	[106951] = true,
	[50334] = true,
	[740] = true,
	[102560] = true,
	[102543] = true,
	[102558] = true,
	[193530] = true,
	[288613] = true,
	[266779] = true,
	[12042] = true,
	[190319] = true,
	[12472] = true,
	[115203] = true,
	[137639] = true,
	[152173] = true,
	[115310] = true,
	[31884] = true,
	[216331] = true,
	[231895] = true,
	[228260] = true,
	[47536] = true,
	[64843] = true,
	[79140] = true,
	[13750] = true,
	[121471] = true,
	[198067] = true,
	[192249] = true,
	[51533] = true,
	[108280] = true,
	[205180] = true,
	[265187] = true,
	[1122] = true,
	[227847] = true,
	[152277] = true,
	[1719] = true,
	[107574] = 73,
}

E.covenant_cdmod_conduits = {
	[310143] = { 320658, 15 },
	[300728] = { 336147, -30 },
}

E.covenant_chmod_conduits = {
	[300728] = { 336147, 1 },
}

E.covenant_cdmod_items_mult = {
	[300728] = { 184807, 0.8 },
	[310143] = { 184807, 0.8 },
	[324631] = { 184807, 0.8 },
	[323436] = { 184807, 0.8 },
}

E.soulbind_conduits_rank = {
	[337704] = { 20.0, 22.0, 24.0, 26.0, 28.0, 30.0, 32.0, 34.0, 36.0, 38.0, 40.0, 42.0, 44.0, 46.0, 48.0 },

	[338553] = { 1.0 },
	[338671] = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20 },
	[340028] = { 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5, 12.0 },
	[340550] = { .90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76 },
	[340529] = { .90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76 },
	[341451] = { .90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76 },
	[341378] = { .90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76 },
	[341440] = { 1.0 },
	[339377] = { 10, 11.5, 13, 14.5, 16, 17.5, 19, 20.5, 23, 24.5, 26, 27.5, 29, 30.5, 32 },
	[339558] = { 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0 },
	[339704] = { 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5, 2.7, 2.9, 3.1, 3.4, 3.6, 3.8, 4.0 },
	[346747] = { 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 1.0, 2.3, 2.4 },
	[340876] = { 5.0, 6.0, 6.0, 7.0, 7.0, 8.0, 8.0, 9.0, 9.0, 10.0, 10.0, 11.0, 11.0, 12.0, 12.0 },
	[336636] = { 2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4, 4.6, 4.8 },
	[336613] = { 25, 28, 30, 33, 35, 38, 40, 43, 45, 48, 50, 53, 55, 58, 60 },
	[336777] = { 2.5, 2.8, 3.0, 3.3, 3.5, 3.8, 4.0, 4.3, 4.5, 4.8, 5.0, 5.3, 5.5, 5.8, 6.0 },
	[336992] = { 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4 },
	[336873] = { 0.30, 0.33, 0.36, 0.39, 0.42, 0.45, 0.48, 0.51, 0.54, 0.57, 0.60, 0.63, 0.66, 0.69, 0.72 },
	[336522] = { 0.75, 0.83, 0.90, 0.98, 1.05, 1.13, 1.20, 1.28, 1.35, 1.43, 1.50, 1.58, 1.65, 1.73, 1.80 },
	[337099] = { 1.0 },
	[336773] = { 0.3 },
	[337264] = { 0.5 },
	[336616] = { 0.1 },
	[337295] = { 0.5 },
	[337084] = { 6.0, 6.6, 7.2, 7.8, 8.4, 9.0, 9.6, 10.2, 10.8, 11.4, 12.0, 12.6, 13.2, 13.8, 14.4 },
	[340030] = { 15.0, 16.5, 18.0, 19.5, 21.0, 22.5, 24.0, 25.5, 27.0, 28.5, 30.0, 31.5, 33.0, 34.5, 36.0 },
	[340023] = { 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0 },
	[338741] = { 48.0, 46.0, 44.0, 42.0, 40.0, 38.0, 36.0, 34.0, 32.0, 30.0, 28.0, 26.0, 24.0, 22.0, 20.0 },
	[337678] = { 20.0, 22.0, 24.0, 26.0, 28.0, 30.0, 32.0, 34.0, 36.0, 38.0, 40.0, 42.0, 44.0, 46.0, 48.0 },
	[338345] = { 1.06, 1.088, 1.096, 1.104, 1.112, 1.120, 1.128, 1.136, 1.144, 1.152, 1.160, 1.168, 1.176, 1.184, 1.192 },
	[337762] = { 6.0, 6.6, 7.2, 7.8, 8.4, 9.0, 9.6, 10.2, 10.8, 11.4, 12.0, 12.6, 13.2, 13.8, 14.4 },
	[341559] = { 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4 },
	[341535] = { 2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4, 4.6, 4.8 },
	[341531] = { .90 },
	[337964] = { 180, 210, 240, 270, 300, 330, 360, 390, 420, 450, 480, 510, 540, 570, 600 },
	[338042] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
	[339183] = { 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0 },
	[339186] = { 20, 21, 23, 24, 26, 27, 29, 30, 31, 33, 34, 36, 37, 39, 40 },
	[339130] = { 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90 },
	[339455] = { 3, 3.2, 3.4, 3.6, 3.8, 4, 4.2, 4.4, 4.6, 4.8, 5, 5.2, 5.4, 5.6, 5.8 },
	[339272] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
	[334993] = { 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48 },
	[339948] = { 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12 },
	[339939] = { 15 },
}

E.soulbind_abilities = {
	[319217] = true,
	[336147] = true,
	[328261] = true,
	[326507] = true,
	[320658] = true,
}

E.spell_cdmod_conduits = {
	[48792] = 337704,
	[317009] = 340028,
	[198589] = 338671,
	[204021] = 338671,
	[217200] = 341440,
	[186265] = 339377,
	[186257] = 339558,
	[1953] = 336636,
	[212653] = 336636,
	[45438] = 336613,
	[86659] = 340030,
	[228049] = 340030,
	[73325] = 337678,
	[328923] = 339183,
	[20608] = 337964,
	[8143] = 338042,
	[2484] = 338042,
	[192058] = 338042,
	[333889] = 339130,
	[325886] = 339939,
	[118038] = 334993,
	[184364] = 334993,
	[871] = 334993,
	[12323] = 339948,
	[46968] = 339948,
}

E.spell_cdmod_conduits_mult = {
	[132158] = 340550,
	[338142] = 341378,



	[22812] = 340529,
	[5211] = 341451,
	[102359] = 341451,
	[319454] = 341451,





	[195457] = 341531,
	[36554] = 341531,
}

E.spell_symbol_of_hope_majorcd = {
	[118038] = true,
	[184364] = true,
	[871] = true,
	[498] = 65,
	[31850] = true,
	[184662] = true,
	[109304] = true,
	[185311] = true,
	[19236] = true,
	[48792] = true,
	[108271] = true,
	[55342] = true,
	[104773] = true,
	[115203] = true,
	[243435] = true,
	[22812] = true,
	[198589] = true,
	[204021] = true,
}

E.spell_major_cd = {
	benevolent = E.spell_benevolent_faerie_majorcd,
	symbol = E.spell_symbol_of_hope_majorcd,
	intimidation = {
		[300728] = true
	},
}





E.item_merged = {

	[185304] = 181333, [185309] = 184052,
	[185306] = 181816, [185311] = 184054,
	[185305] = 181335, [185310] = 184053,
	[185282] = 178447, [185242] = 178334,
	[185197] = 175921, [185161] = 175884,

	[186869] = 181333, [186966] = 184052,
	[186871] = 181816, [186968] = 184054,
	[186870] = 181335, [186967] = 184053,
	[186868] = 178447, [186946] = 178334,
	[186866] = 175921, [186906] = 175884,

	[192298] = 181333, [192412] = 184052,
	[192300] = 181816, [192414] = 184054,
	[192299] = 181335, [192413] = 184053,
	[192297] = 178447, [192392] = 178334,
	[192295] = 175921, [192352] = 175884,

	[192301] = 188524,
	[192302] = 188691,
	[192303] = 188766,
	[192304] = 188775,
	[192305] = 188778,
}

E.item_equip_bonus = BLANK



local class_set_bonus = {


	DEMONHUNTER = {
		[577] = { 363736, 4 },
		[581] = { 363737, 4 },
	},

	DRUID = {
		[103] = { 364416, 2 },
	},







	PALADIN = {
		[65] = { 363674, 4 },
		[70] = { 364370, 4 },
	},


	SHAMAN = {
		[262] = { 363671, 4 },
		[264] = { 363672, 4 },
	},


}


E.item_set_bonus = {
	[188892] = class_set_bonus.DEMONHUNTER,
	[188896] = class_set_bonus.DEMONHUNTER,
	[188894] = class_set_bonus.DEMONHUNTER,
	[188898] = class_set_bonus.DEMONHUNTER,
	[188893] = class_set_bonus.DEMONHUNTER,
	[188847] = class_set_bonus.DRUID,
	[188851] = class_set_bonus.DRUID,
	[188849] = class_set_bonus.DRUID,
	[188853] = class_set_bonus.DRUID,
	[188848] = class_set_bonus.DRUID,





	[188933] = class_set_bonus.PALADIN,
	[188932] = class_set_bonus.PALADIN,
	[188929] = class_set_bonus.PALADIN,
	[188928] = class_set_bonus.PALADIN,
	[188931] = class_set_bonus.PALADIN,
	[188923] = class_set_bonus.SHAMAN,
	[188920] = class_set_bonus.SHAMAN,
	[188922] = class_set_bonus.SHAMAN,
	[188925] = class_set_bonus.SHAMAN,
	[188924] = class_set_bonus.SHAMAN,
}

E.item_unity = {
	[190465] = 354118,
	[190464] = 354333,
	[190468] = {
		356395,
		356391,
	},
	[190474] = 355447,
	[190472] = 356818,
	[190473] = {
		356250,
		356218,
	},
	[190471] = 354703,
}






E.sync_cooldowns = {
	["DEATHKNIGHT"] = {
		[55233] = { 250 },

		[49576] = { 276079 },
		[43265] = { 250, { -152280,152280, 321077,324128 } },
		[47568] = { 251 },
		[275699] = { 252 },
	},
	["DEMONHUNTER"] = {

		[198013] = { 577, 337534 },
		[212084] = { 581, 337534 },
		[306830] = { 581, 337544, 321076 },
		[207684] = { 581, 337544 },
		[202138] = { 581, 337544, 202138 },
		[202137] = { 581, 337544 },
		[204596] = { 581, 337544 },
		[232893] = { 581, 232893 },
		[191427] = { 577 },
		[232893] = { 581 },
		[212084] = { 577, 363737 },
		[258920] = { 581, 363737 },
	},
	["DRUID"] = {
		[194223] = { 102, { -102560,102560 } },
		[106951] = { 103, { -102543,102543 } },
		[50334] = { 104, { -102558,102558 } },
		[708] = { 105 },
	},
	["HUNTER"] = {
		[109304] = { 270581 },


		[257044] = { 254, { 260393,336867 } },


		[217200] = { 253 },

		[259495] = { 255 },
		[266779] = { 255 },
		[288613] = { 254 },
		[193530] = { 253 },

		[190925] = { 255, 265895 },
	},
	["MAGE"] = {
		[12042] = { 62 },
		[190319] = { 63 },
		[12472] = { 64, { -198144,198144 } },
	},
	["MONK"] = {
		[137639] = { 269, { -152173,152173 } },

		[123904] = { 269, 336616 },

		[119582] = { 268, { 337290,337570 } },
		[325216] = { 268, 337570, 321078 },
		[115203] = { 268 },
		[322507] = { 268, 337570 },
		[115399] = { 268, 337570 },

		[109132] = { 337084, { -115008,115008 } },

		[107428] = { 270 },
		[115310] = { 270 },
	},
	["PALADIN"] = {
		[853] = { 234299 },

		[31884] = { { -216331,216331, 231895,231895 } },


		[86659] = { 66, 204074, { -228049,228049 } },
		[212641] = { 66, 204074, { -228049,228049 } },
		[1022] = { 337600 },
		[204018] = { 337600 },
		[6940] = { 337600 },
		[1044] = { 337600 },
		[316958] = { 321079, 355447 },


		[31935] = { 66 },

		[255937] = { 70, 364370 },
	},
	["PRIEST"] = {
		[47536] = { 256 },
		[64843] = { 257 },
		[228260] = { 258 },
	},
	["ROGUE"] = {
		[5277] = { 354897 },
		[1966] = { 354897 },
		[185313] = { 238104 },
		[280719] = { 280719 },
		[323654] = { 354703 },

		[315341] = { 260 },
		[13877] = { 260 },
		[315508] = { 260 },
		[13750] = { 260 },
		[195457] = { 260 },
		[271877] = { 260 },
		[51690] = { 260 },
		[137619] = { 260 },
		[2983] = { 260 },
		[1856] = { 260 },
		[79140] = { 260 },
		[121471] = { 261 },
	},
	["SHAMAN"] = {

		[326059] = { 339186, 321078 },
		[198067] = { 262, { -192249,192249 } },
		[51533] = { 263, },
		[108280] = { 264 },
		[192058] = { 264, 363672 },
		[98008] = { 264, 363672 },
		[108280] = { 264 },
		[5394] = { 264, 363672 },
		[8143] = { 264, 363672 },
		[16191] = { 264, 363672 },
		[324386] = { 264, 363672, 321076 },
		[51485] = { 264, 363672, 51485 },
		[207399] = { 264, 363672, 207399 },
		[198838] = { 264, 363672, 198838 },
		[157153] = { 264, 363672, 157153 },
		[204330] = { 264, 363672, 204330 },
		[204336] = { 264, 363672, 204336 },
		[192077] = { 264, 363672, 192077 },
		[204331] = { 264, 363672, 204331 },
	},
	["WARLOCK"] = {
		[205180] = { 265 },
		[265187] = { 266 },
		[1122] = { 267 },
	},
	["WARRIOR"] = {
		[871] = { 73, 152278 },
		[167105] = { 71, 152278, { -262161,262161 } },
		[227847] = { 71, { -152277,152277 } },
		[1719] = { 72 },
		[107574] = { 73 },
		[184364] = { 72, 335582 },

	},
	["ALL"] = {

		[324631] = { 321078 },




	},
}

E.sync_in_raid = {
	[216331] = true,
	[31884] = true,
	[98008] = true,
	[108280] = true,
	[8143] = true,
	[192077] = true,
	[115203] = true,
	[316958] = true,
	[740] = true,
	[115310] = true,
	[47536] = true,
	[64843] = true,
}

E.sync_periodic = {
	[198013] = true,
	[212084] = true,
	[119582] = true,
	[31935] = true,
	[326059] = true,

	[49576] = true,


	[190925] = true,



	[255937] = true,
}

E:ProcessSpellDB()