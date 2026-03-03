-- ===================================================================
-- ArcUI_CooldownState.lua
-- Consolidated cooldown state visual system
-- v3.3.0: ArcAuras-pattern refactor — single feed+apply, no cascade
--
-- ARCHITECTURE: Owns two invisible shadow Cooldown frames per icon:
--
-- _arcCDMShadowCooldown (main CD):
--   Fed with GetSpellCooldownDuration. GCD filtered.
--   IsShown()=true  → ALL charges depleted / full cooldown active
--   IsShown()=false → ready or has charges available
--
-- _arcCDMChargeShadow (charge recharge):
--   Fed with GetSpellChargeDuration. No GCD contamination.
--   IsShown()=true  → recharge timer active
--   IsShown()=false → all charges full
--
-- EVENT-DRIVEN ARCHITECTURE (matches ArcAuras):
--   Per-icon event handler catches SPELL_UPDATE_COOLDOWN/CHARGES.
--   Feeds shadows, then calls ApplyCooldownStateVisuals ONCE.
--   OnCooldownDone on each shadow catches natural timer expiry.
--   NO hooks on SetCooldown/SetCooldownFromDurationObject —
--   we call those ourselves, so hooking them was reacting to our
--   own writes = 5-13x cascade per event. ArcAuras never does this.
--
-- ENFORCEMENT HOOKS (on CDM parent frame):
--   SetAlpha, SetDesaturated, SetVertexColor hooks BLOCK CDM's
--   native writes and enforce our values. These never re-feed
--   or re-dispatch — they just guard the values we already set.
-- ===================================================================

local ADDON, ns = ...

ns.CooldownState = ns.CooldownState or {}

-- ═══════════════════════════════════════════════════════════════════
-- SECRET-SAFE AURAINSTANCEID HELPER
-- ═══════════════════════════════════════════════════════════════════
local function HasAuraInstanceID(value)
  if ns.API and ns.API.HasAuraInstanceID then
    return ns.API.HasAuraInstanceID(value)
  end
  if value == nil then return false end
  if issecretvalue and issecretvalue(value) then return true end
  if type(value) == "number" and value == 0 then return false end
  return value ~= nil
end

-- ═══════════════════════════════════════════════════════════════════
-- DEPENDENCY REFERENCES (resolved lazily on first call)
-- ═══════════════════════════════════════════════════════════════════
local CDM
local InitCooldownCurves
local GetEffectiveStateVisuals
local GetEffectiveReadyAlpha
local GetGlowThresholdCurve
local ShowReadyGlow
local HideReadyGlow
local SetGlowAlpha
local ShouldShowReadyGlow
local ApplyBorderDesaturation
local HideAuraActiveGlow

local resolved = false

local function ResolveDependencies()
  CDM = ns.CDMEnhance
  if not CDM then return false end

  InitCooldownCurves          = CDM.InitCooldownCurves
  GetEffectiveStateVisuals    = CDM.GetEffectiveStateVisuals
  GetEffectiveReadyAlpha      = CDM.GetEffectiveReadyAlpha
  GetGlowThresholdCurve       = CDM.GetGlowThresholdCurve
  ShowReadyGlow               = CDM.ShowReadyGlow
  HideReadyGlow               = CDM.HideReadyGlow or function() end
  SetGlowAlpha                = CDM.SetGlowAlpha
  ShouldShowReadyGlow         = CDM.ShouldShowReadyGlow
  ApplyBorderDesaturation     = CDM.ApplyBorderDesaturation
  HideAuraActiveGlow          = CDM.HideAuraActiveGlow or function() end

  resolved = true
  return true
end

-- ═══════════════════════════════════════════════════════════════════
-- SMALL HELPERS
-- ═══════════════════════════════════════════════════════════════════

local function ResolveCurrentSpellID(frame, cfg)
  if frame.cooldownInfo then
    local live = frame.cooldownInfo.overrideSpellID or frame.cooldownInfo.spellID
    if live then return live end
  end
  return cfg._spellID
end

local function ResolveIconTexture(frame)
  local iconTex = frame.Icon or frame.icon
  if not iconTex then return nil end
  if not iconTex.SetDesaturated and iconTex.Icon then
    iconTex = iconTex.Icon
  end
  return iconTex
end

local function SetDesat(iconTex, value)
  if not iconTex then return end
  if iconTex.SetDesaturation then
    iconTex:SetDesaturation(value or 0)
  end
end

local function SetVertexColorSafe(frame, iconTex, r, g, b, a)
  if not iconTex then return end
  frame._arcDesiredVertexColor = { r = r, g = g, b = b }
  frame._arcBypassVertexHook = true
  iconTex:SetVertexColor(r, g, b, a or 1)
  frame._arcBypassVertexHook = false
end

local function ResetDurationText(frame)
  local skip = frame._arcSwipeWaitForNoCharges
  if frame._arcCooldownText and frame._arcCooldownText.SetIgnoreParentAlpha then
    if not skip then frame._arcCooldownText:SetIgnoreParentAlpha(false) end
  end
  if frame._arcChargeText and frame._arcChargeText.SetIgnoreParentAlpha then
    if not skip then frame._arcChargeText:SetIgnoreParentAlpha(false) end
  end
  if frame.Cooldown and frame.Cooldown.Text and frame.Cooldown.Text.SetIgnoreParentAlpha then
    if not skip then frame.Cooldown.Text:SetIgnoreParentAlpha(false) end
  end
  if frame.Cooldown and frame.Cooldown.SetIgnoreParentAlpha then
    frame.Cooldown:SetIgnoreParentAlpha(false)
  end
  -- Walk native Cooldown regions
  if frame.Cooldown and not skip then
    local countdownFS = frame.Cooldown.GetCountdownFontString and frame.Cooldown:GetCountdownFontString()
    if countdownFS and countdownFS.SetIgnoreParentAlpha then
      countdownFS:SetIgnoreParentAlpha(false)
    end
    for _, region in ipairs({frame.Cooldown:GetRegions()}) do
      if region:IsObjectType("FontString") and region.SetIgnoreParentAlpha
         and not region._arcIsChargeText then
        region:SetIgnoreParentAlpha(false)
      end
    end
  end
end

local function PreserveDurationText(frame)
  -- Don't enable IgnoreParentAlpha if the group container is hidden
  -- Check both frame and parent: icons added after SafeShowContainer don't have the flag
  if frame._arcGroupHidden then return end
  local parent = frame:GetParent()
  if parent and parent._arcGroupHidden then return end
  
  -- Skip cooldown text if charge-conditional hide is active
  if not frame._arcHideCDTextForCharges then
    if frame._arcCooldownText and frame._arcCooldownText.SetIgnoreParentAlpha then
      frame._arcCooldownText:SetIgnoreParentAlpha(true)
      frame._arcCooldownText:SetAlpha(1)
    end
    if frame.Cooldown and frame.Cooldown.Text and frame.Cooldown.Text.SetIgnoreParentAlpha then
      frame.Cooldown.Text:SetIgnoreParentAlpha(true)
      frame.Cooldown.Text:SetAlpha(1)
    end
  end
  -- Skip charge text if hideAtZero is active
  if not frame._arcHideChargeAtZero then
    if frame._arcChargeText and frame._arcChargeText.SetIgnoreParentAlpha then
      frame._arcChargeText:SetIgnoreParentAlpha(true)
      frame._arcChargeText:SetAlpha(1)
    end
  end
  -- Native Cooldown FontStrings: The Cooldown widget can recreate/reset
  -- its internal text when CDM pushes new DurationObjects. Walk regions
  -- every call to catch any new or reset FontStrings.
  if frame.Cooldown then
    local countdownFS = frame.Cooldown.GetCountdownFontString and frame.Cooldown:GetCountdownFontString()
    if countdownFS and countdownFS.SetIgnoreParentAlpha then
      countdownFS:SetIgnoreParentAlpha(true)
      countdownFS:SetAlpha(1)
    end
    for _, region in ipairs({frame.Cooldown:GetRegions()}) do
      if region:IsObjectType("FontString") and region.SetIgnoreParentAlpha
         and not region._arcIsChargeText then
        region:SetIgnoreParentAlpha(true)
        region:SetAlpha(1)
      end
    end
  end
end

-- ═══════════════════════════════════════════════════════════════════
-- CHARGE-CONDITIONAL TEXT VISIBILITY
--
-- Uses shadow state (non-secret) to conditionally show/hide text:
--   chargeText.hideAtZero: hide charge count when charges = 0
--   cooldownText.hideWhenHasCharges: hide CD text when charges > 0
-- ═══════════════════════════════════════════════════════════════════
local function ApplyChargeConditionalText(frame, cfg, isChargeSpell, isRecharging, isOnCooldown)
  if not isChargeSpell then
    -- Not a charge spell — clear any override flags
    frame._arcHideChargeAtZero = nil
    frame._arcHideCDTextForCharges = nil
    return
  end

  -- Derive charge state from shadows (non-secret):
  --   isRecharging = charges > 0 (charge shadow shown)
  --   isOnCooldown && !isRecharging = charges = 0 (all spent)
  --   !isOnCooldown && !isRecharging = all charges ready
  local chargesSpent = isOnCooldown and not isRecharging  -- charges = 0
  local hasCharges = isRecharging or not isOnCooldown      -- charges > 0

  -- ── CHARGE TEXT: hideAtZero ──
  local chargeCfg = cfg.chargeText
  local wantHideAtZero = chargeCfg and chargeCfg.hideAtZero and chargeCfg.enabled ~= false
  if wantHideAtZero and chargesSpent then
    frame._arcHideChargeAtZero = true
    if frame._arcChargeText then
      frame._arcChargeText:SetAlpha(0)
    end
  else
    frame._arcHideChargeAtZero = nil
    -- Only restore if charge text is enabled (don't fight chargeText.enabled=false)
    if chargeCfg and chargeCfg.enabled ~= false and frame._arcChargeText then
      -- Don't override if parent frame is hidden
      if (frame._lastAppliedAlpha or 1) > 0.01 then
        frame._arcChargeText:SetAlpha(1)
      end
    end
  end

  -- ── COOLDOWN TEXT: hideWhenHasCharges ──
  local cdTextCfg = cfg.cooldownText
  local wantHideCDWithCharges = cdTextCfg and cdTextCfg.hideWhenHasCharges and cdTextCfg.enabled ~= false
  if wantHideCDWithCharges and hasCharges then
    frame._arcHideCDTextForCharges = true
    -- Use SetHideCountdownNumbers to properly suppress the Cooldown widget's
    -- built-in countdown — SetAlpha alone gets overwritten by CDM updates.
    if frame.Cooldown then
      frame.Cooldown:SetHideCountdownNumbers(true)
    end
    if frame._arcCooldownText then
      frame._arcCooldownText:SetAlpha(0)
    end
  else
    local wasHidden = frame._arcHideCDTextForCharges
    frame._arcHideCDTextForCharges = nil
    -- Only restore if cooldown text is enabled and was previously hidden by us
    if wasHidden and cdTextCfg and cdTextCfg.enabled ~= false then
      if frame.Cooldown then
        frame.Cooldown:SetHideCountdownNumbers(false)
      end
      if (frame._lastAppliedAlpha or 1) > 0.01 then
        if frame._arcCooldownText then
          frame._arcCooldownText:SetAlpha(1)
        end
      end
    end
  end
end

-- ═══════════════════════════════════════════════════════════════════
-- DUAL SHADOW COOLDOWN FRAMES — Creation + Feeding + CDM Write Hook
--
-- Shadow frames are our independent cooldown detection system.
-- CDM never sees them. We feed them, we read them.
--
-- Hooks:
--   1. OnCooldownDone on each shadow — natural timer expiry
--   2. SetCooldownFromDurationObject on CDM's VISIBLE Cooldown —
--      CDM writes to its cooldown → we react by feeding our shadows
--      and applying visuals. Independent of CDM's event dispatch.
--
-- NO hooks on shadow SetCooldown / SetCooldownFromDurationObject —
-- we call those during feeding. Hooking them = cascade.
-- ═══════════════════════════════════════════════════════════════════

local function CreateInvisibleCooldown(frame)
  local cd = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
  cd:SetAllPoints(frame)
  cd:SetDrawSwipe(false)
  cd:SetDrawEdge(false)
  cd:SetDrawBling(false)
  cd:SetHideCountdownNumbers(true)
  cd:SetAlpha(0)
  return cd
end

local FeedShadowCooldown
local EnforceCooldownReadyGlow

-- Shared dispatch: apply visuals + glow + label after shadow state changes.
-- Called from OnCooldownDone hooks AND CDM Cooldown write hook.
local function DispatchAfterShadowUpdate(frame)
  local cachedCfg = frame._arcCfg
  if not cachedCfg then return end
  ns.CDMEnhance.ApplyCooldownStateVisuals(frame, cachedCfg)
  if ns.CDMSpellUsability and ns.CDMSpellUsability.UpdateGlow then
    ns.CDMSpellUsability.UpdateGlow(frame, cachedCfg)
  end
  if frame._arcCLHasText and ns.CustomLabel and ns.CustomLabel.UpdateVisibility then
    ns.CustomLabel.UpdateVisibility(frame)
  end
end

local function EnsureShadowCooldown(frame)
  if not frame._arcCDMShadowCooldown then
    frame._arcCDMShadowCooldown = CreateInvisibleCooldown(frame)

    -- OnCooldownDone: natural timer expiry
    -- DEFERRED: WoW fires OnCooldownDone before IsShown() updates to false.
    -- If we dispatch immediately, ApplyCooldownStateVisuals re-feeds the shadow
    -- and reads stale IsShown()=true, concluding the spell is still on cooldown.
    -- Deferring by one frame ensures IsShown() returns the correct value.
    frame._arcCDMShadowCooldown:HookScript("OnCooldownDone", function()
      if frame._arcFeedingShadow then return end
      C_Timer.After(0, function()
        if frame._arcFeedingShadow then return end
        local shadowCD = frame._arcCDMShadowCooldown
        if shadowCD then
          frame._arcLastShadowShown = shadowCD:IsShown() or false
        end
        DispatchAfterShadowUpdate(frame)
      end)
    end)
  end

  -- Only create charge shadow for charge spells (saves frame creation + feed cost)
  if frame._arcIsChargeSpellCached and not frame._arcCDMChargeShadow then
    frame._arcCDMChargeShadow = CreateInvisibleCooldown(frame)

    -- OnCooldownDone for charge shadow: recharge timer expired
    -- DEFERRED: Same IsShown() timing issue as main shadow (see above).
    frame._arcCDMChargeShadow:HookScript("OnCooldownDone", function()
      if frame._arcFeedingShadow then return end
      C_Timer.After(0, function()
        if frame._arcFeedingShadow then return end
        local chargeShadow = frame._arcCDMChargeShadow
        if chargeShadow then
          frame._arcLastChargeShown = chargeShadow:IsShown() or false
        end
        DispatchAfterShadowUpdate(frame)
      end)
    end)
  end

  return frame._arcCDMShadowCooldown, frame._arcCDMChargeShadow
end

-- Feed shadow frames. _arcFeedingShadow guards Clear() only.
-- Charge shadow only fed if it exists (charge spells only).
FeedShadowCooldown = function(frame, spellID)
  if not spellID then return end

  -- SPELL CHANGE DETECTION: When CDM reassigns a frame to a different spell
  -- (via layout manager / Pools recycle), the shadow still has the OLD spell's
  -- cooldown timer. Invalidate cache so state-change detection doesn't skip
  -- visuals, and kill any stale ready glow from the previous spell immediately.
  local prevSpellID = frame._arcShadowFedSpellID
  if prevSpellID and prevSpellID ~= spellID then
    frame._arcLastShadowShown = nil
    frame._arcLastChargeShown = nil
    if frame._arcReadyGlowActive and ns.CDMEnhance and ns.CDMEnhance.HideReadyGlow then
      ns.CDMEnhance.HideReadyGlow(frame)
    end
  end
  frame._arcShadowFedSpellID = spellID

  local shadowCD, chargeShadow = EnsureShadowCooldown(frame)

  local isOnGCD = nil
  pcall(function()
    local cdInfo = C_Spell.GetSpellCooldown(spellID)
    if cdInfo and cdInfo.isOnGCD == true then isOnGCD = true end
  end)

  if isOnGCD then
    shadowCD:SetCooldown(0, 0)
  else
    local durObj = nil
    pcall(function() durObj = C_Spell.GetSpellCooldownDuration(spellID) end)
    if durObj then
      frame._arcFeedingShadow = true
      shadowCD:Clear()
      frame._arcFeedingShadow = nil
      pcall(function() shadowCD:SetCooldownFromDurationObject(durObj, true) end)
    else
      shadowCD:SetCooldown(0, 0)
    end
  end

  -- Only feed charge shadow if it exists (charge spells only)
  if chargeShadow then
    local chargeDurObj = nil
    pcall(function() chargeDurObj = C_Spell.GetSpellChargeDuration(spellID) end)
    if chargeDurObj then
      frame._arcFeedingShadow = true
      chargeShadow:Clear()
      frame._arcFeedingShadow = nil
      pcall(function() chargeShadow:SetCooldownFromDurationObject(chargeDurObj, true) end)
    else
      chargeShadow:SetCooldown(0, 0)
    end
  end
end

-- ═══════════════════════════════════════════════════════════════════
-- BINARY STATE DETECTION via dual shadow cooldown frames
-- ═══════════════════════════════════════════════════════════════════
local function GetBinaryCooldownState(frame, isChargeSpell)
  local shadowCD = frame._arcCDMShadowCooldown
  local isOnCooldown = shadowCD and shadowCD:IsShown() or false
  local isRecharging = false
  if isChargeSpell and not isOnCooldown then
    local chargeShadow = frame._arcCDMChargeShadow
    isRecharging = chargeShadow and chargeShadow:IsShown() or false
  end
  return isOnCooldown, isRecharging
end

local function GetCooldownFlags(spellID)
  if not spellID then return nil, false end
  local isOnGCD = nil
  pcall(function()
    local cdInfo = C_Spell.GetSpellCooldown(spellID)
    if cdInfo and cdInfo.isOnGCD == true then isOnGCD = true end
  end)
  local isChargeSpell = false
  pcall(function()
    isChargeSpell = C_Spell.GetSpellCharges(spellID) ~= nil
  end)
  return isOnGCD, isChargeSpell
end

local function ReadCooldownState(frame, spellID)
  local isOnGCD, isChargeSpell = GetCooldownFlags(spellID)
  local isOnCooldown, isRecharging = GetBinaryCooldownState(frame, isChargeSpell)
  return isOnCooldown, isRecharging, isChargeSpell, isOnGCD
end

-- ═══════════════════════════════════════════════════════════════════
-- USABILITY HELPERS
-- ═══════════════════════════════════════════════════════════════════
local function GetUsabilityAlpha(frame, spellID, cfg)
  if not spellID then return nil end
  local su = cfg and cfg.spellUsability
  if not su or not su.enabled then return nil end
  if frame.spellOutOfRange then
    local ri = cfg and cfg.rangeIndicator
    local rangeEnabled = not ri or ri.enabled ~= false
    if rangeEnabled then return nil end
  end
  local isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellID)
  if isUsable then return nil end
  if notEnoughMana then
    return su.notEnoughResourceAlpha
  else
    return su.notUsableAlpha
  end
end



-- ═══════════════════════════════════════════════════════════════════
-- OPTIONS PANEL PREVIEW HELPER
-- ═══════════════════════════════════════════════════════════════════
local function PreviewClampAlpha(alpha)
  if alpha <= 0 then
    if ns.CDMEnhance.IsOptionsPanelOpen and ns.CDMEnhance.IsOptionsPanelOpen() then
      return 0.35
    end
  end
  return alpha
end

-- ═══════════════════════════════════════════════════════════════════
-- APPLY READY STATE
-- ═══════════════════════════════════════════════════════════════════
local function ApplyReadyState(frame, iconTex, stateVisuals, usabilityAlphaOverride)
  local effectiveReadyAlpha = GetEffectiveReadyAlpha(stateVisuals)
  if usabilityAlphaOverride then
    effectiveReadyAlpha = usabilityAlphaOverride
  end
  effectiveReadyAlpha = PreviewClampAlpha(effectiveReadyAlpha)
  frame._arcTargetAlpha = nil
  if effectiveReadyAlpha < 1.0 then
    frame._arcEnforceReadyAlpha = true
    frame._arcReadyAlphaValue = effectiveReadyAlpha
  else
    frame._arcEnforceReadyAlpha = false
    frame._arcReadyAlphaValue = nil
  end
  if frame._lastAppliedAlpha ~= effectiveReadyAlpha then
    frame._arcBypassFrameAlphaHook = true
    frame:SetAlpha(effectiveReadyAlpha)
    frame._arcBypassFrameAlphaHook = false
    frame._lastAppliedAlpha = effectiveReadyAlpha
  end
  frame._arcDesatBranch = frame._arcDesatBranch or "READY"
  frame._arcForceDesatValue = nil
  ApplyBorderDesaturation(frame, 0)
  frame:Show()
  frame._arcPreserveDurationText = false
  ResetDurationText(frame)
end

-- ═══════════════════════════════════════════════════════════════════
-- APPLY COOLDOWN STATE ALPHA
-- ═══════════════════════════════════════════════════════════════════
local function ApplyCooldownAlpha(frame, stateVisuals)
  local cdAlpha = stateVisuals.cooldownAlpha or 1.0
  cdAlpha = PreviewClampAlpha(cdAlpha)
  frame._arcEnforceReadyAlpha = false
  frame._arcReadyAlphaValue = nil
  frame._arcTargetAlpha = cdAlpha
  if frame._lastAppliedAlpha ~= cdAlpha then
    frame._arcBypassFrameAlphaHook = true
    frame:SetAlpha(cdAlpha)
    frame._arcBypassFrameAlphaHook = false
    frame._lastAppliedAlpha = cdAlpha
  end

  -- Preserve duration text: keep countdown + charge text visible even when
  -- frame is dimmed/hidden. This is the WHOLE POINT of the feature — text
  -- stays readable at full opacity while the icon fades to cooldownAlpha.
  -- Arc Auras applies preserve unconditionally regardless of alpha.
  frame._arcPreserveDurationText = stateVisuals.preserveDurationText == true
  if stateVisuals.preserveDurationText then
    -- Cooldown widget must be at alpha 1 so its child text can be visible.
    -- The frame itself is at cdAlpha (possibly 0), but IgnoreParentAlpha
    -- on the FontStrings makes them ignore the entire parent alpha chain.
    if frame.Cooldown then
      frame.Cooldown:SetAlpha(1)
    end
    PreserveDurationText(frame)
  else
    if frame.Cooldown then
      if frame.Cooldown.SetIgnoreParentAlpha then
        frame.Cooldown:SetIgnoreParentAlpha(false)
      end
    end
    ResetDurationText(frame)
  end
end

-- ═══════════════════════════════════════════════════════════════════
-- APPLY COOLDOWN DESATURATION
-- ═══════════════════════════════════════════════════════════════════
local function ApplyCooldownDesat(frame, iconTex, stateVisuals, hasActiveAuraDisplay, isRecharging)
  if hasActiveAuraDisplay then
    frame._arcForceDesatValue = 0
    frame._arcBypassDesatHook = true
    SetDesat(iconTex, 0)
    frame._arcBypassDesatHook = false
    ApplyBorderDesaturation(frame, 0)
  elseif stateVisuals.noDesaturate then
    frame._arcForceDesatValue = 0
    frame._arcBypassDesatHook = true
    SetDesat(iconTex, 0)
    frame._arcBypassDesatHook = false
    ApplyBorderDesaturation(frame, 0)
  else
    frame._arcForceDesatValue = nil
    local shadowCD = frame._arcCDMShadowCooldown
    local borderDesat = (shadowCD and shadowCD:IsShown()) and 1 or 0
    ApplyBorderDesaturation(frame, borderDesat)
  end
end

local function ApplyReadyGlow(frame, stateVisuals)
  if ShouldShowReadyGlow(stateVisuals, frame) then
    ShowReadyGlow(frame, stateVisuals)
  else
    HideReadyGlow(frame)
  end
end

-- ═══════════════════════════════════════════════════════════════════
-- PATH A: Ignore Aura Override (binary)
-- ═══════════════════════════════════════════════════════════════════
local function HandleIgnoreAuraOverride(frame, iconTex, cfg, stateVisuals)
  local spellID = ResolveCurrentSpellID(frame, cfg)
  if not spellID then
    frame._arcReadyForGlow = false
    frame._arcForceDesatValue = nil
    frame._arcEnforceReadyAlpha = false
    frame._arcReadyAlphaValue = nil
    frame._arcTargetAlpha = nil
    frame._arcDesiredSwipe = nil
    frame._arcDesiredEdge = nil
    frame._arcDesiredVertexColor = nil
    HideReadyGlow(frame)
    return
  end

  local isOnCooldown, isRecharging, isChargeSpell, isOnGCD = ReadCooldownState(frame, spellID)

  local waitForNoCharges = isChargeSpell and stateVisuals.waitForNoCharges
  local glowWhileCharges = stateVisuals.glowWhileChargesAvailable

  local useCooldownVisuals
  if isOnCooldown then
    useCooldownVisuals = true
  elseif isChargeSpell and isRecharging then
    useCooldownVisuals = not waitForNoCharges
  else
    useCooldownVisuals = false
  end

  local isGlowEligible
  if isOnCooldown then
    isGlowEligible = false
  elseif isChargeSpell and isRecharging and not glowWhileCharges then
    isGlowEligible = false
  else
    isGlowEligible = true
  end

  frame:Show()

  if useCooldownVisuals then
    frame._arcDesatBranch = "IAO_BIN_CD"
    ApplyCooldownAlpha(frame, stateVisuals)
    if stateVisuals.noDesaturate or isRecharging then
      frame._arcForceDesatValue = 0
      frame._arcBypassDesatHook = true
      SetDesat(iconTex, 0)
      frame._arcBypassDesatHook = false
      ApplyBorderDesaturation(frame, 0)
    else
      frame._arcForceDesatValue = 1
      frame._arcBypassDesatHook = true
      SetDesat(iconTex, 1)
      frame._arcBypassDesatHook = false
      ApplyBorderDesaturation(frame, 1)
    end
    if stateVisuals.cooldownTint and stateVisuals.cooldownTintColor then
      local col = stateVisuals.cooldownTintColor
      SetVertexColorSafe(frame, iconTex, col.r or 0.5, col.g or 0.5, col.b or 0.5)
    else
      frame._arcDesiredVertexColor = nil
    end
    if isGlowEligible then ApplyReadyGlow(frame, stateVisuals) else HideReadyGlow(frame) end
  else
    frame._arcDesatBranch = "IAO_BIN_READY"
    local usabilityAlpha = GetUsabilityAlpha(frame, spellID, cfg)
    ApplyReadyState(frame, iconTex, stateVisuals, usabilityAlpha)
    frame._arcForceDesatValue = 0
    frame._arcBypassDesatHook = true
    SetDesat(iconTex, 0)
    frame._arcBypassDesatHook = false
    frame._arcDesiredVertexColor = nil
    if isGlowEligible then ApplyReadyGlow(frame, stateVisuals) else HideReadyGlow(frame) end
  end

  -- CHARGE-CONDITIONAL TEXT (hideAtZero / hideWhenHasCharges)
  ApplyChargeConditionalText(frame, cfg, isChargeSpell, isRecharging, isOnCooldown)

  -- SWIPE/EDGE
  -- IAO frames MUST control swipe regardless of Masque — IAO is about showing
  -- spell cooldown instead of aura duration, so we need explicit swipe control
  -- to prevent GCD swipes from showing through.
  if frame.Cooldown then
    local swipeCfg = cfg.cooldownSwipe
    local userWantsSwipe = not swipeCfg or swipeCfg.showSwipe ~= false
    local userWantsEdge  = not swipeCfg or swipeCfg.showEdge  ~= false
    local noGCDSwipe = swipeCfg and swipeCfg.noGCDSwipe
    local wantSwipe, wantEdge
    if isChargeSpell then
      local swipeWait = swipeCfg and swipeCfg.swipeWaitForNoCharges
      local edgeWait  = swipeCfg and swipeCfg.edgeWaitForNoCharges
      if isOnCooldown then
        wantSwipe = userWantsSwipe; wantEdge = userWantsEdge
      elseif isRecharging then
        wantSwipe = userWantsSwipe and not swipeWait
        wantEdge  = userWantsEdge and not edgeWait
      elseif isOnGCD and not noGCDSwipe then
        -- On GCD but user wants GCD swipes visible — release control to CDM
        wantSwipe = nil; wantEdge = nil
      else
        wantSwipe = false; wantEdge = false
      end
    else
      if isOnCooldown then
        wantSwipe = userWantsSwipe; wantEdge = userWantsEdge
      elseif isOnGCD and not noGCDSwipe then
        -- On GCD but user wants GCD swipes visible — release control to CDM
        wantSwipe = nil; wantEdge = nil
      else
        wantSwipe = false; wantEdge = false
      end
    end
    frame._arcDesiredSwipe = wantSwipe
    frame._arcDesiredEdge  = wantEdge
    if wantSwipe ~= nil then
      frame._arcBypassSwipeHook = true
      frame.Cooldown:SetDrawSwipe(wantSwipe)
      frame.Cooldown:SetDrawEdge(wantEdge)
      frame._arcBypassSwipeHook = false
    end
  end
end


-- ═══════════════════════════════════════════════════════════════════
-- PATH B: Aura Logic (buffs / debuffs / totems)
-- ═══════════════════════════════════════════════════════════════════
local function HandleAuraLogic(frame, iconTex, cfg, stateVisuals)
  frame._arcTargetAlpha = nil
  frame._arcTargetDesat = nil
  frame._arcTargetTint = nil

  local isAuraActive = HasAuraInstanceID(frame.auraInstanceID) or (frame.totemData ~= nil)
  local isCooldownFrame = not cfg._isAura and frame.totemData == nil

  local cdSpellID, cdOnCooldown, cdRecharging, cdIsCharge, cdIsOnGCD
  if isCooldownFrame then
    cdSpellID = ResolveCurrentSpellID(frame, cfg)
    if cdSpellID then
      cdOnCooldown, cdRecharging, cdIsCharge, cdIsOnGCD = ReadCooldownState(frame, cdSpellID)
    end
  end

  -- ALPHA
  if frame._arcTargetAlpha == nil then
    if isCooldownFrame then
      if cdSpellID then
        local isOnGCD, isChargeSpell = cdIsOnGCD, cdIsCharge
        local isOnCooldown, isRecharging = cdOnCooldown, cdRecharging
        local waitForNoCharges = isChargeSpell and stateVisuals.waitForNoCharges
        local useCooldownVisuals
        if isOnCooldown then useCooldownVisuals = true
        elseif isChargeSpell and isRecharging then useCooldownVisuals = not waitForNoCharges
        else useCooldownVisuals = false end
        if not isChargeSpell and isOnGCD then
          local usabilityAlpha = GetUsabilityAlpha(frame, cdSpellID, cfg)
          ApplyReadyState(frame, iconTex, stateVisuals, usabilityAlpha)
        elseif useCooldownVisuals then
          frame:Show()
          ApplyCooldownAlpha(frame, stateVisuals)
        else
          local usabilityAlpha = GetUsabilityAlpha(frame, cdSpellID, cfg)
          ApplyReadyState(frame, iconTex, stateVisuals, usabilityAlpha)
        end
      else
        ApplyReadyState(frame, iconTex, stateVisuals)
      end
    else
      local targetAlpha
      if isAuraActive then
        local effectiveReadyAlpha = GetEffectiveReadyAlpha(stateVisuals)
        targetAlpha = effectiveReadyAlpha
        if effectiveReadyAlpha < 1.0 then
          frame._arcEnforceReadyAlpha = true
          frame._arcReadyAlphaValue = effectiveReadyAlpha
        else
          frame._arcEnforceReadyAlpha = false
        end
      else
        frame._arcEnforceReadyAlpha = false
        local cdAlpha = stateVisuals.cooldownAlpha
        targetAlpha = PreviewClampAlpha(cdAlpha)
      end
      frame._arcTargetAlpha = targetAlpha
      if frame._lastAppliedAlpha ~= targetAlpha then
        frame._arcBypassFrameAlphaHook = true
        frame:SetAlpha(targetAlpha)
        if frame.Cooldown then frame.Cooldown:SetAlpha(targetAlpha) end
        frame._arcBypassFrameAlphaHook = false
        frame._lastAppliedAlpha = targetAlpha
      end
      if not frame:IsShown() then frame:Show() end
    end
  end

  -- DESATURATION
  if frame._arcTargetDesat == nil then
    if isCooldownFrame then
      frame._arcDesatBranch = "AURA_CD_NATIVE"
      frame._arcForceDesatValue = nil
      frame._arcTargetDesat = -1
    else
      local targetDesat
      if isAuraActive then
        frame._arcDesatBranch = "AURA_READY"; targetDesat = 0
      else
        frame._arcDesatBranch = "AURA_CD"
        targetDesat = stateVisuals.cooldownDesaturate and 1 or 0
      end
      frame._arcBypassDesatHook = true
      SetDesat(iconTex, targetDesat)
      frame._arcBypassDesatHook = false
      frame._arcTargetDesat = targetDesat
      ApplyBorderDesaturation(frame, targetDesat)
    end
  end

  -- TINT
  if frame._arcTargetTint == nil then
    if isCooldownFrame then
      frame._arcDesiredVertexColor = nil
      frame._arcTargetTint = true
    else
      local tR, tG, tB = 1, 1, 1
      if not isAuraActive and stateVisuals.cooldownTint and stateVisuals.cooldownTintColor then
        local col = stateVisuals.cooldownTintColor
        tR, tG, tB = col.r or 0.5, col.g or 0.5, col.b or 0.5
      end
      frame._arcTargetTint = string.format("%.2f,%.2f,%.2f", tR, tG, tB)
      -- RAW write: do NOT use SetVertexColorSafe for aura frames.
      -- SetVertexColorSafe sets _arcDesiredVertexColor, which the hook enforces
      -- against ALL future writes — blocking CDM from clearing tint when aura activates.
      -- Old working version used raw SetVertexColor; match that behavior.
      frame._arcDesiredVertexColor = nil
      if iconTex then
        frame._arcBypassVertexHook = true
        iconTex:SetVertexColor(tR, tG, tB, 1)
        frame._arcBypassVertexHook = false
      end
    end
  end

  -- SWIPE/EDGE release for cooldown frames showing auras
  if isCooldownFrame then
    frame._arcDesiredSwipe = nil
    frame._arcDesiredEdge = nil
  end

  -- GLOW
  local auraID = frame.auraInstanceID
  if isCooldownFrame or frame._arcTargetGlow == nil or not isAuraActive then
    if isCooldownFrame then
      if cdSpellID then
        local glowOnCD, glowRecharging = cdOnCooldown, cdRecharging
        local glowWhileCharges = stateVisuals.glowWhileChargesAvailable
        local glowEligible = true
        if glowOnCD then glowEligible = false
        elseif cdIsCharge and glowRecharging and not glowWhileCharges then glowEligible = false end
        if glowEligible and ShouldShowReadyGlow(stateVisuals, frame) then
          ShowReadyGlow(frame, stateVisuals)
        else
          HideReadyGlow(frame)
        end
      else
        ApplyReadyGlow(frame, stateVisuals)
      end
    elseif ShouldShowReadyGlow(stateVisuals, frame) and isAuraActive then
      local threshold = stateVisuals.glowThreshold or 1.0
      if threshold < 1.0 and auraID then
        local auraType = stateVisuals.glowAuraType or "auto"
        local unit = "player"
        if auraType == "debuff" then unit = "target"
        elseif auraType == "auto" then
          local cat = frame.category
          if cat == 3 then unit = "target" end
        end
        InitCooldownCurves()
        local auraDurObj = C_UnitAuras and C_UnitAuras.GetAuraDuration
                           and C_UnitAuras.GetAuraDuration(unit, auraID)
        if auraDurObj then
          local thresholdCurve = GetGlowThresholdCurve(threshold)
          if thresholdCurve then
            local ok, glowAlpha = pcall(function()
              return auraDurObj:EvaluateRemainingPercent(thresholdCurve)
            end)
            if ok and glowAlpha ~= nil then
              SetGlowAlpha(frame, glowAlpha, stateVisuals)
            else ShowReadyGlow(frame, stateVisuals) end
          else ShowReadyGlow(frame, stateVisuals) end
        else ShowReadyGlow(frame, stateVisuals) end
      else ShowReadyGlow(frame, stateVisuals) end
      frame._arcTargetGlow = true
    else
      HideReadyGlow(frame)
      frame._arcTargetGlow = true
    end
  end
end


-- ═══════════════════════════════════════════════════════════════════
-- PATH C: Cooldown Logic — BINARY (matches ArcAuras pattern)
-- ═══════════════════════════════════════════════════════════════════
local function HandleCooldownLogic(frame, iconTex, cfg, stateVisuals)
  local spellID = ResolveCurrentSpellID(frame, cfg)
  if not spellID then
    frame._arcDesatBranch = "C1_NO_SPELL"
    frame._arcForceDesatValue = nil
    frame._arcEnforceReadyAlpha = false
    frame._arcReadyAlphaValue = nil
    frame._arcTargetAlpha = nil
    frame._arcDesiredSwipe = nil
    frame._arcDesiredEdge = nil
    frame._arcDesiredVertexColor = nil
    return
  end

  local isOnCooldown, isRecharging, isChargeSpell, isOnGCD = ReadCooldownState(frame, spellID)

  local waitForNoCharges = isChargeSpell and stateVisuals.waitForNoCharges
  local glowWhileCharges = stateVisuals.glowWhileChargesAvailable

  local useCooldownVisuals
  if isOnCooldown then useCooldownVisuals = true
  elseif isChargeSpell and isRecharging then useCooldownVisuals = not waitForNoCharges
  else useCooldownVisuals = false end

  local isGlowEligible
  if isOnCooldown then isGlowEligible = false
  elseif isChargeSpell and isRecharging and not glowWhileCharges then isGlowEligible = false
  else isGlowEligible = true end

  local cfgHasIgnoreAura = (cfg.auraActiveState and cfg.auraActiveState.ignoreAuraOverride)
                        or (cfg.cooldownSwipe and cfg.cooldownSwipe.ignoreAuraOverride)
  local hasActiveAuraDisplay = not cfgHasIgnoreAura
                               and ((frame.wasSetFromAura == true)
                                    or (frame.totemData ~= nil))

  frame:Show()

  if useCooldownVisuals then
    frame._arcDesatBranch = "C_BIN_CD"
    ApplyCooldownAlpha(frame, stateVisuals)
    ApplyCooldownDesat(frame, iconTex, stateVisuals, hasActiveAuraDisplay, isRecharging)
    if stateVisuals.cooldownTint and stateVisuals.cooldownTintColor then
      local col = stateVisuals.cooldownTintColor
      SetVertexColorSafe(frame, iconTex, col.r or 0.5, col.g or 0.5, col.b or 0.5)
    else
      frame._arcDesiredVertexColor = nil
    end
    if isGlowEligible then ApplyReadyGlow(frame, stateVisuals) else HideReadyGlow(frame) end
  else
    frame._arcDesatBranch = "C_BIN_READY"
    frame._arcPreserveCooldownPath = nil  -- Cooldown ended, allow normal dispatch
    local usabilityAlpha = GetUsabilityAlpha(frame, spellID, cfg)
    ApplyReadyState(frame, iconTex, stateVisuals, usabilityAlpha)
    frame._arcDesiredVertexColor = nil
    if isGlowEligible then ApplyReadyGlow(frame, stateVisuals) else HideReadyGlow(frame) end
  end

  -- CHARGE-CONDITIONAL TEXT (hideAtZero / hideWhenHasCharges)
  ApplyChargeConditionalText(frame, cfg, isChargeSpell, isRecharging, isOnCooldown)

  -- SWIPE/EDGE
  local masqueControlsCD = ns.Masque and ns.Masque.ShouldMasqueControlCooldowns
    and ns.Masque.ShouldMasqueControlCooldowns()
  if masqueControlsCD then
    frame._arcDesiredSwipe = nil
    frame._arcDesiredEdge  = nil
  elseif frame.Cooldown then
    local swipeCfg = cfg.cooldownSwipe
    local userWantsSwipe = not swipeCfg or swipeCfg.showSwipe ~= false
    local userWantsEdge  = not swipeCfg or swipeCfg.showEdge  ~= false
    local noGCDSwipe = swipeCfg and swipeCfg.noGCDSwipe
    local wantSwipe, wantEdge

    if isChargeSpell then
      local swipeWait = swipeCfg and swipeCfg.swipeWaitForNoCharges
      local edgeWait  = swipeCfg and swipeCfg.edgeWaitForNoCharges
      local hasWaitFlags = swipeWait or edgeWait
      if isOnCooldown then
        wantSwipe = userWantsSwipe; wantEdge = userWantsEdge
      elseif isRecharging then
        wantSwipe = not swipeWait and userWantsSwipe
        wantEdge  = not edgeWait and userWantsEdge
      elseif noGCDSwipe or hasWaitFlags then
        wantSwipe = false; wantEdge = false
      else
        wantSwipe = nil; wantEdge = nil
      end
    else
      if isOnCooldown then
        wantSwipe = userWantsSwipe; wantEdge = userWantsEdge
      elseif noGCDSwipe and isOnGCD then
        wantSwipe = false; wantEdge = false
      else
        wantSwipe = nil; wantEdge = nil
      end
    end

    frame._arcDesiredSwipe = wantSwipe
    frame._arcDesiredEdge  = wantEdge
    if wantSwipe ~= nil then
      frame._arcBypassSwipeHook = true
      frame.Cooldown:SetDrawSwipe(wantSwipe)
      frame.Cooldown:SetDrawEdge(wantEdge)
      frame._arcBypassSwipeHook = false
    end
  end
end


-- ═══════════════════════════════════════════════════════════════════
-- MAIN DISPATCHER
-- ═══════════════════════════════════════════════════════════════════
local function NewApplyCooldownStateVisuals(frame, cfg, normalAlpha, stateVisuals)
  if not frame then return end
  if not resolved then
    if not ResolveDependencies() then return end
  end
  if frame._arcConfig or frame._arcAuraID then return end

  local iconTex = ResolveIconTexture(frame)
  if not iconTex then return end

  if not stateVisuals then
    stateVisuals = GetEffectiveStateVisuals(cfg)
  end

  local cdID = frame.cooldownID
  local isGlowPreview = cdID and ns.CDMEnhanceOptions
                        and ns.CDMEnhanceOptions.IsGlowPreviewActive
                        and ns.CDMEnhanceOptions.IsGlowPreviewActive(cdID)

  local ignoreAuraOverride = (cfg.auraActiveState and cfg.auraActiveState.ignoreAuraOverride)
                          or (cfg.cooldownSwipe and cfg.cooldownSwipe.ignoreAuraOverride)

  local hasSpellUsability = cfg.spellUsability and cfg.spellUsability.enabled == true
  local hasNoGCDSwipe = cfg.cooldownSwipe and cfg.cooldownSwipe.noGCDSwipe
  local hasWaitFlags = cfg.cooldownSwipe and (cfg.cooldownSwipe.swipeWaitForNoCharges or cfg.cooldownSwipe.edgeWaitForNoCharges)

  if not stateVisuals and not isGlowPreview and not ignoreAuraOverride and not hasSpellUsability and not hasNoGCDSwipe and not hasWaitFlags then
    local prevBranch = frame._arcDesatBranch
    local wasManagedDesat = prevBranch ~= nil and prevBranch ~= "NO_SV_EARLY"
    frame._arcForceDesatValue = nil
    frame._arcReadyForGlow = false
    frame._arcDesatBranch = "NO_SV_EARLY"
    frame._arcDesiredSwipe = nil
    frame._arcDesiredEdge = nil
    frame._arcDesiredVertexColor = nil
    HideReadyGlow(frame)
    -- Clean up leftover aura active glow (e.g. glowWhenMissing was just disabled)
    if frame._arcAuraActiveGlowActive then
      HideAuraActiveGlow(frame)
    end
    if wasManagedDesat then
      SetDesat(iconTex, 0)
      frame._arcBypassVertexHook = true
      if iconTex then iconTex:SetVertexColor(1, 1, 1, 1) end
      frame._arcBypassVertexHook = false
      ApplyBorderDesaturation(frame, 0)
    end
    return
  end

  if not stateVisuals then
    local rs = cfg.cooldownStateVisuals and cfg.cooldownStateVisuals.readyState or {}
    stateVisuals = {
      readyAlpha          = 1.0,
      readyGlow           = isGlowPreview and true or (rs.glow == true),
      readyGlowType       = rs.glowType or "button",
      readyGlowColor      = rs.glowColor,
      readyGlowIntensity  = rs.glowIntensity or 1.0,
      readyGlowScale      = rs.glowScale or 1.0,
      readyGlowSpeed      = rs.glowSpeed or 0.25,
      readyGlowLines      = rs.glowLines or 8,
      readyGlowThickness  = rs.glowThickness or 2,
      readyGlowParticles  = rs.glowParticles or 4,
      readyGlowXOffset    = rs.glowXOffset or 0,
      readyGlowYOffset    = rs.glowYOffset or 0,
      cooldownAlpha       = 1.0,
    }
  end

  if isGlowPreview then
    ShowReadyGlow(frame, stateVisuals)
    return
  end

  local useAuraLogic = cfg._isAura or false
  if not useAuraLogic then
    if frame.totemData ~= nil then useAuraLogic = true
    elseif frame.wasSetFromAura == true then useAuraLogic = true end
  end

  -- OVERRIDE TRANSITION PROTECTION: spell override swaps (e.g. Surging Totem
  -- → Retract → back) can flip wasSetFromAura/totemData, diverting from
  -- cooldown-binary to aura-logic. Aura logic sees totemData as "active aura"
  -- → AURA_READY, hiding the remaining cooldown. If CDMEnhance flagged this
  -- frame during override detection, force cooldown path until CD ends.
  if useAuraLogic and frame._arcPreserveCooldownPath then
    useAuraLogic = false
  end

  -- DISPATCH
  if ignoreAuraOverride then
    -- Always route to IAO handler when user enabled ignoreAuraOverride.
    -- Previously gated behind cdmWouldShowAura (hasAura/selfAura/wasSetFromAura),
    -- but on reload those flags may not be populated yet (buff not active,
    -- cooldownInfo metadata not set). This caused fallthrough to HandleCooldownLogic
    -- which set _arcIgnoreAuraOverride=false, breaking GCD intercept.
    -- HandleIgnoreAuraOverride handles both CD and ready states correctly.
    frame._arcDesatBranch = "DISPATCH_IAO"
    frame._arcIgnoreAuraOverride = true
    HandleIgnoreAuraOverride(frame, iconTex, cfg, stateVisuals)
  elseif useAuraLogic then
    -- EVENT-DRIVEN AURA FRAMES: OptimizedApplyIconVisuals is the authority
    -- on alpha/desat/tint for true aura frames (cfg._isAura or totem).
    -- It fires instantly on SetAuraInstanceInfo/ClearAuraInstanceInfo hooks.
    -- CooldownState's HandleAuraLogic duplicates that work and can arrive
    -- late (via rescans/tickers), overwriting the correct values.
    -- Exception: cooldown frames with wasSetFromAura need HandleAuraLogic
    -- because their sub-path uses ReadCooldownState (spell cooldown, not aura).
    if frame._arcAuraEventDriven and (cfg._isAura or frame.totemData ~= nil) then
      -- True aura/totem frame with event hooks — skip, OptimizedApply owns this
      return
    end
    frame._arcDesatBranch = "DISPATCH_AURA"
    frame._arcIgnoreAuraOverride = false
    HandleAuraLogic(frame, iconTex, cfg, stateVisuals)
  else
    frame._arcDesatBranch = "DISPATCH_CD"
    frame._arcIgnoreAuraOverride = false
    HandleCooldownLogic(frame, iconTex, cfg, stateVisuals)
  end
end


-- ═══════════════════════════════════════════════════════════════════
-- STANDALONE READY GLOW ENFORCEMENT (shadow binary detection)
-- Mirrors ArcAurasCooldown lines 540-548: reads shadows, decides glow.
-- Called from DispatchAfterShadowUpdate and exported for CDMEnhance.
-- ═══════════════════════════════════════════════════════════════════
EnforceCooldownReadyGlow = function(frame, stateVisuals)
  if not frame then return end
  if not resolved then
    if not ResolveDependencies() then return end
  end
  if not stateVisuals then return end

  -- Feed shadow first (match ArcAurasCooldown: always feed before reading)
  local spellID
  if frame.cooldownInfo then
    spellID = frame.cooldownInfo.overrideSpellID or frame.cooldownInfo.spellID
  end
  if not spellID then spellID = frame._arcCachedSpellID end
  if spellID then
    EnsureShadowCooldown(frame)
    FeedShadowCooldown(frame, spellID)
  end

  local shadowCD = frame._arcCDMShadowCooldown
  local isOnCooldown = shadowCD and shadowCD:IsShown() or false

  local chargeShadow = frame._arcCDMChargeShadow
  local isRecharging = chargeShadow and chargeShadow:IsShown() or false

  local glowWhileCharges = stateVisuals.glowWhileChargesAvailable

  local isGlowEligible
  if isOnCooldown then
    isGlowEligible = false
  elseif isRecharging and not glowWhileCharges then
    isGlowEligible = false
  else
    isGlowEligible = true
  end

  if isGlowEligible and ShouldShowReadyGlow(stateVisuals, frame) then
    ShowReadyGlow(frame, stateVisuals)
  else
    HideReadyGlow(frame)
  end
end


-- ═══════════════════════════════════════════════════════════════════
-- INSTALL
-- ═══════════════════════════════════════════════════════════════════
ns.CDMEnhance.ApplyCooldownStateVisuals = NewApplyCooldownStateVisuals

ns.CooldownState.Apply              = NewApplyCooldownStateVisuals
ns.CooldownState.ApplyReadyState    = ApplyReadyState
ns.CooldownState.ApplyReadyGlow     = ApplyReadyGlow
ns.CooldownState.ResolveIconTexture = ResolveIconTexture
ns.CooldownState.GetUsabilityAlpha  = GetUsabilityAlpha
ns.CooldownState.EnforceReadyGlow   = EnforceCooldownReadyGlow
ns.CooldownState.PreserveDurationText = PreserveDurationText

function ns.CooldownState.FeedShadow(frame, cfg)
  if not frame then return end
  if frame._arcConfig or frame._arcAuraID then return end
  local spellID
  if frame.cooldownInfo then
    spellID = frame.cooldownInfo.overrideSpellID or frame.cooldownInfo.spellID
  end
  if not spellID and cfg then spellID = cfg._spellID end
  if spellID then
    FeedShadowCooldown(frame, spellID)
  end
end

function ns.CooldownState.EnsureShadow(frame)
  if not frame then return end
  EnsureShadowCooldown(frame)
end