
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Averzian", 2912, 2733)
if not mod then return end
mod:RegisterEnableMob(240435) -- Imperator Averzian
mod:SetEncounterID(3176)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1255680, sound = "alarm"}, -- Gnashing Void
	{1275059, sound = "alert"}, -- Black Miasma
	{1249265, 1260203}, -- Umbral Collapse (Targetted)
	-- {1249309, sound = "alarm"}, -- Umbral Collapse (DoT effect), still used?
	-- {1249716, 1265398}, -- Umbral Collapse (Unknown Aura)
	1280023, -- Void Marked
	{1280075, sound = "info"}, -- Lingering Darkness (DoT effect after dispel)
	{1260981, sound = "underyou"}, -- March of the Endless
	{1265540, sound = "alarm"}, -- Blackening Wounds
	1283069, -- Weakened
})

--------------------------------------------------------------------------------
-- Locals
--

local shadowAdvanceCount = 1
local umbralCollapseCount = 1
local voidMarkedCount = 1
local oblivionsWrathCount = 1
local voidFallCount = 1
local darkUpheavalCount = 1

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1251361, -- Shadow's Advance
		1249262, -- Umbral Collapse
		1280015, -- Void Marked
		1260712, -- Oblivion's Wrath
		1258883, -- Void Fall
		1249251, -- Dark Upheaval
	},{

	},
	{
		[1251361] = CL.adds, -- Shadow's Advance (Adds)
		[1249262] = CL.soak, -- Umbral Collapse (Soak)
		[1280015] = CL.marks, -- Void Marked (Marks)
		[1260712] = CL.dodge, -- Oblivion's Wrath (Dodge)
		[1258883] = CL.knockback, -- Void Fall (Knockback)
		[1249251] = CL.raid_damage, -- Dark Upheaval (Raid Damage)
	}
end

function mod:OnEncounterStart()
	shadowAdvanceCount = 1
	umbralCollapseCount = 1
	voidMarkedCount = 1
	oblivionsWrathCount = 1
	voidFallCount = 1
	darkUpheavalCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShadowsAdvance(duration)
	local barText = CL.count:format(CL.adds, shadowAdvanceCount)
	self:Bar(1251361, duration, barText)
	shadowAdvanceCount = shadowAdvanceCount + 1
	return {
		msg = barText,
		key = 1251361,
		callback = function()
			self:Message(1251361, "cyan", barText)
			self:PlaySound(1251361, "long")
		end
	}
end

function mod:UmbralCollapse(duration)
	local barText = CL.count:format(CL.soak, umbralCollapseCount)
	self:Bar(1249262, duration, barText)
	umbralCollapseCount = umbralCollapseCount + 1
	return {
		msg = barText,
		key = 1249262,
		callback = function()
			self:Message(1249262, "orange", barText)
			self:PlaySound(1249262, "warning")
		end
	}
end

function mod:VoidMarked(duration)
	local barText = CL.count:format(CL.marks, voidMarkedCount)
	self:Bar(1280015, duration, barText)
	voidMarkedCount = voidMarkedCount + 1
	return {
		msg = barText,
		key = 1280015,
		callback = function()
			self:Message(1280015, "yellow", barText)
			-- Sound on PAs
		end
	}
end

function mod:OblivionsWrath(duration)
	local barText = CL.count:format(CL.dodge, oblivionsWrathCount)
	self:Bar(1260712, duration, barText)
	oblivionsWrathCount = oblivionsWrathCount + 1
	return {
		msg = barText,
		key = 1260712,
		callback = function()
			self:Message(1260712, "purple", barText)
			self:PlaySound(1260712, "alarm")
		end
	}
end

function mod:VoidFall(duration)
	local barText = CL.count:format(CL.knockback, voidFallCount)
	self:Bar(1258883, duration, barText)
	voidFallCount = voidFallCount + 1
	return {
		msg = barText,
		key = 1258883,
		callback = function()
			self:Message(1258883, "cyan", barText)
			self:PlaySound(1258883, "long")
		end
	}
end

function mod:DarkUpheaval(duration)
	local barText = CL.count:format(CL.raid_damage, darkUpheavalCount)
	self:Bar(1249251, duration, barText)
	darkUpheavalCount = darkUpheavalCount + 1
	return {
		msg = barText,
		key = 1249251,
		callback = function()
			self:Message(1249251, "yellow", barText)
			self:PlaySound(1249251, "alert")
		end
	}
end
