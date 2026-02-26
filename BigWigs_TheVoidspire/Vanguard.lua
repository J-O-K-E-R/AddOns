
--------------------------------------------------------------------------------
-- TODO
-- -- Add sounds to the abilities

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lightblinded Vanguard", 2912, 2737)
if not mod then return end
mod:RegisterEnableMob(240431, 240437, 240438) -- Bellamy, Lightblood, Senn
mod:SetEncounterID(3180)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1276982, sound = "underyou"}, -- Divine Consecration
	{1248985, 1248994}, -- Execution Sentence (Targetted)
	{1249008, 1249024, sound = "none"}, -- Execution Sentence (Soaked Debuff)
	-- {1249122, 1249123} -- Execution Sentance (Unknown)
	{1272324, sound = "underyou"}, -- Divine Tempest
	{1246736, sound = "alarm"}, -- Judgement (Final Verdict)
	{1251857, sound = "alarm"}, -- Judgement (Shield of the Righteous)
	-- {1251840, sound = "alarm"}, -- Judgment of the Righteous, Used?
	{1248652, sound = "alarm"}, -- Divine Toll
	1246487, -- Avenger's Shield (Targetted)
	{1246502, sound = "alarm"}, -- Avenger's Shield (DoT Debuff)
	{1248721, sound = "alarm"}, -- Tyr's Wrath
	-- {1249130, sound = "info"}, -- Elekk Charge (Buff on the NPC's, lol)
	{1258514, sound = "alarm"}, -- Blinding Light
})

--------------------------------------------------------------------------------
-- Locals
--

local auraWrathCount = 1
local executionCount = 1
local divineStormCount = 1
local sacredTollCount = 1
local judgementRedCount = 1
local auraDevotionCount = 1
local divineTollCount = 1
local avengersShieldCount = 1
local judgementBlueCount = 1
local auraPeaceCount = 1
local tyrsWrathCount = 1
local searingRadianceCount = 1
local sacredShieldCount = 1
local zealousSpiritCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.aura_of_wrath = "Wrath" -- Short for Aura of Wrath
	L.execution_sentence = "Executes" -- Short for Execution Sentence
	L.judgement_red = "Judgement [R]" -- Red for the red icon.
	L.aura_of_devotion = "Devotion" -- Short for Aura of Devotion
	L.judgement_blue = "Judgement [B]" -- Blue for the blue icon.
	L.aura_of_peace = "Peace" -- Short for Aura of Peace
	L.zaelous_spirit = "Spirit" -- Short for Zealous Spirit
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
		-- Commander Venel Lightblood
		1248449, -- Aura of Wrath
		1248983, -- Execution Sentence
		1246765, -- Divine Storm
		1246749, -- Sacred Toll
		1246736, -- Judgement (Red)
		-- General Amias Bellamy
		1246162, -- Aura of Devotion
		1248644, -- Divine Toll
		1246485, -- Avenger's Shield
		1251857, -- Judgement (Blue)
		-- War Chaplain Senn
		1248451, -- Aura of Peace
		1248710, -- Tyr's Wrath
		1255738, -- Searing Radiance
		1248674, -- Sacred Shield
		-- Mythic
		1276243, -- Zealous Spirit
	},{
		["berserk"] = "general",
		[1248449] = -33680, -- Commander Venel Lightblood
		[1246162] = -32195, -- General Amias Bellamy
		[1248451] = -33681, -- War Chaplain Senn
		[1276243] = "mythic",
	},{
		[1248449] = L.aura_of_wrath,
		[1248983] = L.execution_sentence,
		[1246749] = CL.raid_damage,
		[1246736] = L.judgement_red,
		[1246162] = L.aura_of_devotion,
		[1248644] = CL.dodge,
		[1251857] = L.judgement_blue,
		[1248451] = L.aura_of_peace,
		[1248710] = CL.heal_absorbs,
		[1248674] = CL.shield,
		[1276243] = L.zaelous_spirit,
	}
end

function mod:OnEncounterStart()
	zealousSpiritCount = 1
	auraWrathCount = 1
	executionCount = 1
	divineStormCount = 1
	sacredTollCount = 1
	judgementRedCount = 1
	auraDevotionCount = 1
	divineTollCount = 1
	avengersShieldCount = 1
	judgementBlueCount = 1
	auraPeaceCount = 1
	tyrsWrathCount = 1
	searingRadianceCount = 1
	sacredShieldCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:JudgementBlue(duration)
	local barText = CL.count:format(L.judgement_blue, judgementBlueCount)
	self:CDBar(1251857, duration, barText)
	judgementBlueCount = judgementBlueCount + 1
	return {
		msg = barText,
		key = 1251857,
		callback = function()
			self:Message(1251857, "purple", barText)
		end
	}
end

function mod:JudgementRed(duration)
	local barText = CL.count:format(L.judgement_red, judgementRedCount)
	self:CDBar(1246736, duration, barText)
	judgementRedCount = judgementRedCount + 1
	return {
		msg = barText,
		key = 1246736,
		callback = function()
			self:Message(1246736, "purple", barText)
		end
	}
end

function mod:SacredToll(duration)
	local barText = CL.count:format(CL.raid_damage, sacredTollCount)
	self:CDBar(1246749, duration, barText)
	sacredTollCount = sacredTollCount + 1
	return {
		msg = barText,
		key = 1246749,
		callback = function()
			self:Message(1246749, "yellow", barText)
		end
	}
end

function mod:AvengersShield(duration)
	local barText = CL.count:format(self:SpellName(1246485), avengersShieldCount)
	self:CDBar(1246485, duration, barText)
	avengersShieldCount = avengersShieldCount + 1
	return {
		msg = barText,
		key = 1246485,
		callback = function()
			self:Message(1246485, "yellow", barText)
		end
	}
end

function mod:DivineStorm(duration)
	local barText = CL.count:format(self:SpellName(1246765), divineStormCount)
	self:CDBar(1246765, duration, barText)
	divineStormCount = divineStormCount + 1
	return {
		msg = barText,
		key = 1246765,
		callback = function()
			self:Message(1246765, "red", barText)
		end
	}
end

function mod:SearingRadiance(duration)
	-- 2 timers on pull handling
	local count = duration == 10 and 1 or duration == 59 and 2 or searingRadianceCount
	local barText = CL.count:format(self:SpellName(1255738), count)
	self:CDBar(1255738, duration, barText)
	searingRadianceCount = searingRadianceCount + 1
	return {
		msg = barText,
		key = 1255738,
		callback = function()
			self:Message(1255738, "orange", barText)
		end
	}
end

function mod:SacredShield(duration)
	local barText = CL.count:format(CL.shield, sacredShieldCount)
	self:CDBar(1248674, duration, barText)
	sacredShieldCount = sacredShieldCount + 1
	return {
		msg = barText,
		key = 1248674,
		callback = function()
			self:Message(1248674, "yellow", barText)
		end
	}
end

function mod:ZealousSpirit(duration)
	local barText = CL.count:format(L.zaelous_spirit, zealousSpiritCount)
	self:CDBar(1276243, duration, barText)
	zealousSpiritCount = zealousSpiritCount + 1
	return {
		msg = barText,
		key = 1276243,
		callback = function()
			self:Message(1276243, "cyan", barText)
		end
	}
end

function mod:AuraOfWrath(duration)
	local barText = CL.count:format(L.aura_of_wrath, auraWrathCount)
	self:CDBar(1248449, duration, barText)
	auraWrathCount = auraWrathCount + 1
	return {
		msg = barText,
		key = 1248449,
		callback = function()
			self:Message(1248449, "cyan", barText)
		end
	}
end

function mod:ExecutionSentence(duration)
	local barText = CL.count:format(L.execution_sentence, executionCount)
	self:CDBar(1248983, duration, barText)
	executionCount = executionCount + 1
	return {
		msg = barText,
		key = 1248983,
		callback = function()
			self:Message(1248983, "red", barText)
		end
	}
end

function mod:AuraOfDevotion(duration)
	local barText = CL.count:format(L.aura_of_devotion, auraDevotionCount)
	self:CDBar(1246162, duration, barText)
	auraDevotionCount = auraDevotionCount + 1
	return {
		msg = barText,
		key = 1246162,
		callback = function()
			self:Message(1246162, "cyan", barText)
		end
	}
end

function mod:DivineToll(duration)
	local barText = CL.count:format(CL.dodge, divineTollCount)
	self:CDBar(1248644, duration, barText)
	divineTollCount = divineTollCount + 1
	return {
		msg = barText,
		key = 1248644,
		callback = function()
			self:Message(1248644, "yellow", barText)
		end
	}
end

function mod:AuraOfPeace(duration)
	local barText = CL.count:format(L.aura_of_peace, auraPeaceCount)
	self:CDBar(1248451, duration, barText)
	auraPeaceCount = auraPeaceCount + 1
	return {
		msg = barText,
		key = 1248451,
		callback = function()
			self:Message(1248451, "cyan", barText)
		end
	}
end

function mod:TyrsWrath(duration)
	local barText = CL.count:format(CL.heal_absorbs, tyrsWrathCount)
	self:CDBar(1248710, duration, barText)
	tyrsWrathCount = tyrsWrathCount + 1
	return {
		msg = barText,
		key = 1248710,
		callback = function()
			self:Message(1248710, "orange", barText)
		end
	}
end
