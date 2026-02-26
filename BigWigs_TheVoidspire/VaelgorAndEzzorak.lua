
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vaelgor & Ezzorak", 2912, 2735)
if not mod then return end
mod:RegisterEnableMob(242056, 244552) -- Vaelgor, Ezzorak
mod:SetEncounterID(3178)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	{1262656, 1262676, 1262999, sound = "alarm"}, -- Nullbeam
	{1244672, sound = "underyou"}, -- Nullzone
	{1252157, sound = "alert"}, -- Nullzone Implosion
	1255612, -- Dread Breath (Targetted)
	{1255979, sound = "alarm"}, -- Dread Breath (Feared)
	{1264467, sound = "underyou"}, -- Tail Lash
	{1245554, sound = "alert"},-- Gloomtouched
	{1270852, sound = "none"}, -- Diminish
	{1245421, sound = "underyou"}, -- Gloomfield
	{1245059, sound = "alarm"}, -- Void Howl
	{1245175, sound = "none"}, -- Voidbolt
	-- {1280355, sound = "alarm"}, -- Rakfang Too spammy?
	1265152, -- Impale
	{1248865, 1249595, sound = "info"}, -- Radiant Barrier
	1270497, -- Shadowmark
})

--------------------------------------------------------------------------------
-- Locals
--

local midnightFlamesCount = 1
local nullbeamCount = 1
local dreadBreathCount = 1
local vaelwingCount = 1
local gloomCount = 1
local voidHowlCount = 1
local rakfangCount = 1
local radiantBarrierCount = 1

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		"stages",
		1249748, -- Midnight Flames
		-- Vaelgor
		1262623, -- Nullbeam
		1244221, -- Dread Breath
		{1265131, "TANK"}, -- Vaelwing
		-- Ezzorak
		1245391, -- Gloom
		1244917, -- Void Howl
		{1245645, "TANK"}, -- Rakfang
	},{
		["stages"] = "general",
		[1262623] = -33241, -- Vaelgor
		[1245391] = -33255, -- Ezzorak
	},{
		[1249748] = CL.raid_damage,
		[1262623] = CL.beam,
		[1244221] = CL.breath,
		[1244917] = CL.orbs,
	}
end


function mod:OnEncounterStart()
	self:SetStage(1)

	midnightFlamesCount = 1
	nullbeamCount = 1
	dreadBreathCount = 1
	vaelwingCount = 1
	gloomCount = 1
	voidHowlCount = 1
	rakfangCount = 1
	radiantBarrierCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MidnightFlames(duration)
	local barText = CL.count:format(CL.raid_damage, midnightFlamesCount)
	self:CDBar(1249748, duration, barText)
	midnightFlamesCount = midnightFlamesCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1249748, "yellow", barText)
			self:PlaySound(1249748, "alert")
		end
	}
end

-- Vaelgor
function mod:Nullbeam(duration)
	local barText = CL.count:format(CL.beam, nullbeamCount)
	self:CDBar(1262623, duration, barText)
	nullbeamCount = nullbeamCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1262623, "yellow", barText)
			self:PlaySound(1262623, "alert")
		end
	}
end

function mod:DreadBreath(duration)
	local barText = CL.count:format(CL.breath, dreadBreathCount)
	self:CDBar(1244221, duration, barText)
	dreadBreathCount = dreadBreathCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1244221, "red", barText)
			self:PlaySound(1244221, "warning") -- watch breath
		end
	}
end

function mod:Vaelwing(duration)
	local barText = CL.count:format(self:SpellName(1265131), vaelwingCount)
	self:CDBar(1265131, duration, barText)
	vaelwingCount = vaelwingCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1265131, "purple", barText)
			if self:ThreatTarget("player", "boss1") then -- this assumed Vaelgor boss1
				self:PlaySound(1265131, "alarm")
			end
		end
	}
end

-- Ezzorak
function mod:Gloom(duration)
	local barText = CL.count:format(self:SpellName(1245391), gloomCount)
	self:CDBar(1245391, duration, barText)
	gloomCount = gloomCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1245391, "orange", barText)
			self:PlaySound(1245391, "alert")-- possibly soak
		end
	}
end

function mod:VoidHowl(duration)
	local barText = CL.count:format(CL.orbs, voidHowlCount)
	self:CDBar(1244917, duration, barText)
	voidHowlCount = voidHowlCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1244917, "orange", barText)
			self:PlaySound(1244917, "alarm") -- spread
		end
	}
end

function mod:Rakfang(duration)
	local barText = CL.count:format(self:SpellName(1245645), rakfangCount)
	self:CDBar(1245645, duration, barText)
	rakfangCount = rakfangCount + 1
	return {
		msg = barText,
		callback = function()
			self:Message(1245645, "purple", barText)
			if self:ThreatTarget("player", "boss2") then -- this assumed Ezzorak boss2
				self:PlaySound(1245645, "alarm")
			end
		end
	}
end

-- Lightbound Vanguard
function mod:RadiantBarrier(duration)
	local barText = CL.count:format(CL.stage:format(2), radiantBarrierCount)
	self:CDBar("stages", duration, barText, 1248847) -- Radiant Barrier icon
	radiantBarrierCount = radiantBarrierCount + 1
	return {
		msg = barText,
	}
end
