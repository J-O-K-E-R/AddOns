local mod	= DBM:NewMod(861, "DBM-Pandaria", nil, 322, 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20240428104741")
mod:SetCreatureID(72057)
mod:SetReCombatTime(20, 10)
mod:SetUsedIcons(8, 7, 6)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 144696 144688 144695",
	"SPELL_AURA_APPLIED 144689 144693",
	"SPELL_AURA_REMOVED 144689"
)

--REMINDER: Chat yells are blocked outdoors now, despite how deadly and annoying Burning soul s when they don't run out, we can't chat bubble it
local warnAncientFlame			= mod:NewSpellAnnounce(144695, 2)--probably add a move warning with right DAMAGE event
local warnMagmaCrush			= mod:NewSpellAnnounce(144688, 3)
local warnBurningSoul			= mod:NewTargetNoFilterAnnounce(144689, 4)

local specWarnBurningSoul		= mod:NewSpecialWarningMoveAway(144689, nil, nil, nil, 1, 2)
local specWarnGTFO				= mod:NewSpecialWarningGTFO(144693, nil, nil, nil, 1, 8)
local specWarnEternalAgony		= mod:NewSpecialWarningSpell(144696, nil, nil, nil, 2, 2)--Fights over, this is 5 minute berserk spell.

--local timerAncientFlameCD		= mod:NewCDTimer(43, 144695)--Insufficent logs
--local timerBurningSoulCD		= mod:NewCDTimer(22, 144689)--22-30 sec variation (maybe larger, small sample size)
local timerBurningSoul			= mod:NewBuffFadesTimer(10, 144689, nil, nil, nil, 5)

local berserkTimer				= mod:NewBerserkTimer(300)

mod:AddSetIconOption("SetIconOnBurningSoul", 144689, true, 0, {8, 7, 6})
mod:AddRangeFrameOption(8, 144689)
mod:AddReadyCheckOption(33118, false, 90)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then--We know for sure this is an actual pull and not diving into in progress
		if self:IsInCombat() then
			berserkTimer:Cancel()--In case repulled before last pulls EndCombat Could fire
		end
		berserkTimer:Start()
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 144696 then
		specWarnEternalAgony:Show()
		specWarnEternalAgony:Play("aesoon")
	elseif spellId == 144688 then
		warnMagmaCrush:Show()
	elseif spellId == 144695 then
		warnAncientFlame:Show()
--		timerAncientFlameCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 144689 then
		warnBurningSoul:CombinedShow(1.2, args.destName)
		timerBurningSoul:Start()
--		timerBurningSoulCD:Start()
		if args:IsPlayer() then
			specWarnBurningSoul:Show()
			specWarnBurningSoul:Play("runout")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
		if self.Options.SetIconOnBurningSoul then--Set icons on first debuff to get an earlier spread out.
			self:SetSortedIcon("roster", 1.2, args.destName, 8, 3, true)
		end
	elseif spellId == 144693 and args:IsPlayer() then
		specWarnGTFO:Show(args.spellName)--One warning is enough, because it honestly isn't worth moving for unless blizz buffs it.
		specWarnGTFO:Play("watchfeet")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 144689 then
		if self.Options.SetIconOnBurningSoul then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() and self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end
