
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chimaerus the Undreamt God", 2939, 2795)
if not mod then return end
mod:RegisterEnableMob(245569) -- Chimaerus
mod:SetEncounterID(3306)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	{1245698, sound = "info"}, -- Alnsight
	-- 1253744, -- Rift Vulnerability (Applied at the same time as Alnsight)
	{1250953, sound = "none"}, -- Rift Sickness
	-- 1262020, -- Colossal Strikes, Used?
	{1265940, sound = "alarm"}, -- Fearsome Cry
	1264756, -- Rift Madness
	1257087, -- Consuming Miasma
	{1258192, sound = "none"}, -- Lingering Miasma
	{1246653, sound = "none"}, -- Caustic Phelgm
	{1272726, sound = "alarm"}, -- Rending Tear
})

--------------------------------------------------------------------------------
-- Locals
--

local almdustUpheavalCount = 1
local riftEmergenceCount = 1
local riftMadnessCount = 1
local consumingMiasmaCount = 1
local causticPhlegmCount = 1
local rendingTearCount = 1
local consumeCount = 1
local corruptedDevastationCount = 1
local ravenousDiveCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rift_madness = "Madness" -- Short for Rift Madness
	L.consuming_miasma = "Dispels" -- Move to common?
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		-- Stage One: Insatiable Hunger
		1262289, -- Alndust Upheaval
		1258610, -- Rift Emergence
		1264756, -- Rift Madness
		1257087, -- Consuming Miasma
		1246653, -- Caustic Phlegm
		1272726, -- Rending Tear
		1245396, -- Consume
		-- Stage Two: To The Skies
		1245486, -- Corrupted Devastation
		1245406, -- Ravenous Dive
		1246621, -- Caustic Phlegm
		1257085, -- Consuming Miasma
	},{
		[1262289] = CL.stage:format(1),
		[1245486] = CL.stage:format(2),
	},{
		[1262289] = CL.soak, -- Alndust Upheaval (Soak)
		[1258610] = CL.adds, -- Rift Emergence (Adds)
		[1264756] = L.rift_madness, -- Rift Madness (Madness)
		[1257087] = L.consuming_miasma, -- Consuming Miasma (Dispels)
		[1246653] = CL.raid_damage, -- Caustic Phlegm (Raid Damage)
		[1272726] = CL.frontal_cone, -- Rending Tear (Frontal Cone)
		[1245396] = CL.stage:format(2), -- Consume (Stage 2)
		[1245486] = CL.breath, -- Corrupted Devastation (Breath)
		[1245406] = CL.stage:format(1), -- Ravenous Dive (Stage 1)
		[1246621] = CL.raid_damage, -- Caustic Phlegm (Raid Damage)
		[1257085] = L.consuming_miasma, -- Consuming Miasma (Dispels)
	}
end

function mod:OnEncounterStart()
	self:SetStage(1)

	almdustUpheavalCount = 1
	riftEmergenceCount = 1
	riftMadnessCount = 1
	consumingMiasmaCount = 1
	causticPhlegmCount = 1
	rendingTearCount = 1
	consumeCount = 1
	corruptedDevastationCount = 1
	ravenousDiveCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Insatiable Hunger
-- Alndust Upheaval
function mod:AlndustUpheaval(duration)
	local barText = CL.count:format(CL.soak, almdustUpheavalCount)
	self:Bar(1262289, duration, barText)
	almdustUpheavalCount = almdustUpheavalCount + 1
	return {
		msg = barText,
		key = 1262289,
		callback = function()
			self:Message(1262289, "yellow", barText)
			self:PlaySound(1262289, "alert")
		end
	}
end

-- Rift Emergence
function mod:RiftEmergence(duration)
	local barText = CL.count:format(CL.adds, riftEmergenceCount)
	self:Bar(1258610, duration, barText)
	riftEmergenceCount = riftEmergenceCount + 1
	return {
		msg = barText,
		key = 1258610,
		callback = function()
			self:Message(1258610, "yellow", barText)
			self:PlaySound(1258610, "alert")
		end
	}
end

-- Rift Madness
function mod:RiftMadness(duration)
	local barText = CL.count:format(L.rift_madness, riftMadnessCount)
	self:Bar(1264756, duration, barText)
	riftMadnessCount = riftMadnessCount + 1
	return {
		msg = barText,
		key = 1264756,
		callback = function()
			self:Message(1264756, "yellow", barText)
			self:PlaySound(1264756, "alert")
		end
	}
end

-- Consuming Miasma
function mod:ConsumingMiasma(duration)
	local barText = CL.count:format(L.consuming_miasma, consumingMiasmaCount)
	self:Bar(1257087, duration, barText)
	consumingMiasmaCount = consumingMiasmaCount + 1
	return {
		msg = barText,
		key = 1257087,
		callback = function()
			self:Message(1257087, "yellow", barText)
			self:PlaySound(1257087, "alert")
		end
	}
end

-- Caustic Phlegm
function mod:CausticPhlegm(duration)
	local barText = CL.count:format(CL.raid_damage, causticPhlegmCount)
	self:Bar(1246653, duration, barText)
	causticPhlegmCount = causticPhlegmCount + 1
	return {
		msg = barText,
		key = 1246653,
		callback = function()
			self:Message(1246653, "yellow", barText)
			self:PlaySound(1246653, "alert")
		end
	}
end

-- Rending Tear
function mod:RendingTear(duration)
	local barText = CL.count:format(CL.frontal_cone, rendingTearCount)
	self:Bar(1272726, duration, barText)
	rendingTearCount = rendingTearCount + 1
	return {
		msg = barText,
		key = 1272726,
		callback = function()
			self:Message(1272726, "yellow", barText)
			self:PlaySound(1272726, "alert")
		end
	}
end

-- Consume
function mod:Consume(duration)
	local barText = CL.count:format(CL.stage:format(2), consumeCount)
	self:Bar(1245396, duration, barText)
	consumeCount = consumeCount + 1
	return {
		msg = barText,
		key = 1245396,
		callback = function()
			self:Message(1245396, "red", barText)
			self:PlaySound(1245396, "long")
		end
	}
end

-- Stage Two: To The Skies

-- Corrupted Devastation
function mod:CorruptedDevastation(duration)
	local barText = CL.count:format(CL.breath, corruptedDevastationCount)
	self:Bar(1245486, duration, barText)
	corruptedDevastationCount = corruptedDevastationCount + 1
	return {
		msg = barText,
		key = 1245486,
		callback = function()
			self:Message(1245486, "red", barText)
			self:PlaySound(1245486, "long")
		end
	}
end

-- Ravenous Dive
function mod:RavenousDive(duration)
	local barText = CL.stage:format(1) -- No count needed? or handle bar restarting also.
	self:Bar(1245406, duration, barText)
	-- only the 30s one means stage 2 is about to end, the other one was updating the timer.
	if duration == 30 then
		return {
			msg = barText,
			key = 1245406,
			callback = function()
				self:Message(1245406, "red", barText)
				self:PlaySound(1245406, "long")
			end
		}
	end
	return {msg = barText}
end

-- Caustic Phlegm (Stage 2)
function mod:CausticPhlegmStage2(duration)
	local barText = CL.count:format(CL.raid_damage, causticPhlegmCount)
	self:Bar(1246621, duration, barText)
	causticPhlegmCount = causticPhlegmCount + 1
	return {
		msg = barText,
		key = 1246621,
		callback = function()
			self:Message(1246621, "red", barText)
			self:PlaySound(1246621, "long")
		end
	}
end

-- Consuming Miasma (Stage 2)
function mod:ConsumingMiasmaStage2(duration)
	local barText = CL.count:format(L.consuming_miasma, consumingMiasmaCount)
	self:Bar(1257085, duration, barText)
	consumingMiasmaCount = consumingMiasmaCount + 1
	return {
		msg = barText,
		key = 1257085,
		callback = function()
			self:Message(1257085, "red", barText)
			self:PlaySound(1257085, "long")
		end
	}
end
