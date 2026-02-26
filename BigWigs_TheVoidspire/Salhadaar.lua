
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fallen-King Salhadaar", 2912, 2736)
if not mod then return end
mod:RegisterEnableMob(240432) -- Fallen-King Salhadaar
mod:SetEncounterID(3179)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1250828, sound = "underyou"}, -- Void Exposure
	{1250991, sound = "alarm"}, -- Dark Radiation
	1245960, -- Void Infusion
	{1245592, sound = "underyou"}, -- Torturous Extract
	{1260030, sound = "underyou"}, -- Umbral Beams
	{1253024, 1268992}, -- Shattering Twilight (tank, others)
	{1251213, sound = "underyou"}, -- Twilight Spikes
	1248697, -- Despotic Command
	{1248709, sound = "alarm"}, -- Oppressive Darkness
	{1250686, sound = "none"}, -- Twisting Obscurity (Raid damage/dot)
	{1271577, sound = "alarm"}, -- Destabilizing Strikes
})

--------------------------------------------------------------------------------
-- Locals
--

local voidConvergenceCount = 1
local entropicUnravelingCount = 1
local shatteringTwilightCount = 1
local fracturedProjectionCount = 1
local despoticCommandCount = 1
local twistingObscurityCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.fractured_projection = "Kicks" -- Move this to common?
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1247738, -- Void Convergence
		1246175, -- Entropic Unraveling
		1250803, -- Shattering Twilight
		1254081, -- Fractured Projection
		1248697, -- Despotic Command
		1250686, -- Twisting Obscurity
	},{

	},{
		[1247738] = CL.orbs, -- Void Convergence (Orbs)
		[1246175] = CL.full_energy, -- Entropic Unraveling (Full Energy)
		[1250803] = CL.spikes, -- Shattering Twilight (Spikes)
		[1254081] = L.fractured_projection, -- Fractured Projection (Kicks)
		[1248697] = CL.pools, -- Despotic Command (Pools)
		[1250686] = CL.raid_damage, -- Twisting Obscurity (Raid Damage)
	}
end


function mod:OnEncounterStart()
	voidConvergenceCount = 1
	entropicUnravelingCount = 1
	shatteringTwilightCount = 1
	fracturedProjectionCount = 1
	despoticCommandCount = 1
	twistingObscurityCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidConvergence(duration)
	local barText = CL.count:format(CL.orbs, voidConvergenceCount)
	self:Bar(1247738, duration, barText)
	voidConvergenceCount = voidConvergenceCount + 1
	return {
		msg = barText,
		key = 1247738,
		callback = function()
			self:Message(1247738, "orange", barText)
			self:PlaySound(1247738, "alarm")
		end
	}
end

function mod:EntropicUnraveling(duration)
	local barText = CL.count:format(CL.full_energy, entropicUnravelingCount)
	self:Bar(1246175, duration, barText)
	entropicUnravelingCount = entropicUnravelingCount + 1
	-- Scheduling instead of using the callback since these were getting started and canceled right away during tests.
	self:ScheduleTimer("Message", duration, 1246175, "red", barText)
	self:ScheduleTimer("PlaySound", duration, 1246175, "warning")
end

function mod:ShatteringTwilight(duration)
	local barText = CL.count:format(CL.spikes, shatteringTwilightCount)
	self:Bar(1250803, duration, barText)
	shatteringTwilightCount = shatteringTwilightCount + 1
	return {
		msg = barText,
		key = 1250803,
		callback = function()
			self:Message(1250803, "purple", barText)
			-- Sound on PAs
		end
	}
end

function mod:FracturedProjection(duration)
	local barText = CL.count:format(L.fractured_projection, fracturedProjectionCount)
	self:Bar(1254081, duration, barText)
	fracturedProjectionCount = fracturedProjectionCount + 1
	return {
		msg = barText,
		key = 1254081,
		callback = function()
			self:Message(1254081, "red", barText)
			self:PlaySound(1254081, "warning")
		end
	}
end

function mod:DespoticCommand(duration)
	local barText = CL.count:format(CL.pools, despoticCommandCount)
	self:Bar(1248697, duration, barText)
	despoticCommandCount = despoticCommandCount + 1
	return {
		msg = barText,
		key = 1248697,
		callback = function()
			self:Message(1248697, "yellow", barText)
			-- Sound on PAs
		end
	}
end

function mod:TwistingObscurity(duration)
	local barText = CL.count:format(CL.raid_damage, twistingObscurityCount)
	self:Bar(1250686, duration, barText)
	twistingObscurityCount = twistingObscurityCount + 1
	return {
		msg = barText,
		key = 1250686,
		callback = function()
			self:Message(1250686, "yellow", barText)
			self:PlaySound(1250686, "alert")
		end
	}
end
