
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vorasius", 2912, 2734)
if not mod then return end
mod:RegisterEnableMob(240434) -- Vorasius
mod:SetEncounterID(3177)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	-- {1243016, sound = "alarm"}, -- Blisterburst (15s debuff) still used?
	1259186, -- Blisterburst
	{1272527, sound = "none"}, -- Creep Spit
	{1243220, 1243270, sound = "underyou"}, -- Dark Goo
	1241844, -- Smashed
})

--------------------------------------------------------------------------------
-- Locals
--

local breathCount = 1
local parasiteCount = 1
local frenzyCount = 1
local roarCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.shadowclaw_slam = "Slams"
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1256855, -- Void Breath
		1254199, -- Parasite Expulsion
		1241692, -- Shadowclaw Slam
		1260052, -- Primordial Roar
	},
	{},
	{
		[1256855] = CL.breath, -- Void Breath (Breath)
		[1254199] = CL.adds, -- Parasite Expulsion (Adds)
		[1241692] = L.shadowclaw_slam, -- Shadowclaw Slam (Slams)
		[1260052] = CL.roar, -- Primordial Roar (Roar)
	}
end


function mod:OnEncounterStart()
	breathCount = 1
	parasiteCount = 1
	frenzyCount = 1
	roarCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidBreath(duration)
	local barText = CL.count:format(CL.breath, breathCount)
	self:Bar(1256855, duration, barText)
	breathCount = breathCount + 1
	return {
		msg = barText,
		key = 1256855,
		callback = function()
			self:Message(1256855, "red", barText)
			self:PlaySound(1256855, "warning")
		end
	}
end

function mod:ParasiteExpulsion(duration)
	local barText = CL.count:format(CL.adds, parasiteCount)
	self:Bar(1254199, duration, barText)
	parasiteCount = parasiteCount + 1
	return {
		msg = barText,
		key = 1254199,
		callback = function()
			self:Message(1254199, "cyan", barText)
			self:PlaySound(1254199, "long")
		end
	}
end

function mod:SmashingFrenzy(duration)
	local barText = CL.count:format(L.shadowclaw_slam, frenzyCount)
	self:Bar(1241692, duration, barText)
	frenzyCount = frenzyCount + 1
	return {
		msg = barText,
		key = 1241692,
		callback = function()
			self:Message(1241692, "yellow", barText)
			self:PlaySound(1241692, "alert")
		end
	}
end

function mod:PrimordialRoar(duration)
	local barText = CL.count:format(CL.roar, roarCount)
	self:Bar(1260052, duration, barText)
	roarCount = roarCount + 1
	return {
		msg = barText,
		key = 1260052,
		callback = function()
			self:Message(1260052, "orange", barText)
			self:PlaySound(1260052, "alarm")
		end
	}
end
