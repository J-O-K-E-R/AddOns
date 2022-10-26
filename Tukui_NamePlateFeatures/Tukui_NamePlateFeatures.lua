------------------------------------------------------------------------------------------
-- Tukui 18 - Battle for Azeroth (8.0.0) 
-- latest update 02-01-2019, release 14-08-2018
------------------------------------------------------------------------------------------

-- Setting up Nameplates Extra Features.

------------------------------------------------------------------------------------------
-- LOCALS/VARIABLES/FUNCTIONS
------------------------------------------------------------------------------------------
local T, C, L = Tukui:unpack()
local TukuiUnitFrames = T["UnitFrames"]
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsUnit = UnitIsUnit

-- Add Ingame Config
C["NamePlates"]["CurrentTargetGrow"] = true
C["NamePlates"]["CurrentTargetScale"] = 1.2
C["NamePlates"]["SetAlpha"] = true 
C["NamePlates"]["CurrentTargetAlpha"] = 1
C["NamePlates"]["NonTargetedAlpha"] = 0.5
C["NamePlates"]["ThreatIndicator"] = true
C["NamePlates"]["ThreatOnHealth"] = false
C["NamePlates"]["ThreatGlow"] = false
C["NamePlates"]["PercentageHP"] = true
C["NamePlates"]["HealthPrediction"] = false

-- Add Locales
local CurrentTargetGrow = {
	["Name"] = "|cffFFFF99Current Target Grow|r",
	["Desc"] = "Enable/Disable current Target Grow, increasing size of the targeted Mob's Nameplate.",
}
TukuiConfig.enUS["NamePlates"]["CurrentTargetGrow"] = CurrentTargetGrow

local CurrentTargetScale = {
	["Name"] = "|cffFFFF99Set Target Scale|r",
	["Desc"] = "Set the scale of your Targeted Mob's Nameplate.",
}
TukuiConfig.enUS["NamePlates"]["CurrentTargetScale"] = CurrentTargetScale

local SetAlpha = {
	["Name"] = "|cffFFFF99Adjust Nameplate Alpha|r",
	["Desc"] = "Enable/Disable alpha options for Nameplates. Targeted Nameplate alpha and Non Targeted Nameplate alpha",
}
TukuiConfig.enUS["NamePlates"]["SetAlpha"] = SetAlpha

local CurrentTargetAlpha = {
	["Name"] = "|cffFFFF99Targeted Alpha|r",
	["Desc"] = "Set Alpha of Current Targeted Nameplate.",
}
TukuiConfig.enUS["NamePlates"]["CurrentTargetAlpha"] = CurrentTargetAlpha

local NonTargetedAlpha = {
	["Name"] = "|cffFFFF99Non Targeted Alpha|r",
	["Desc"] = "Set Alpha of Non Targeted Nameplates.",
}
TukuiConfig.enUS["NamePlates"]["NonTargetedAlpha"] = NonTargetedAlpha

local ThreatIndicator = {
	["Name"] = "|cffFFFF99Threat Indicator|r",
	["Desc"] = "Enable/Disable a Threat Indicator for Nameplates.",
}
TukuiConfig.enUS["NamePlates"]["ThreatIndicator"] = ThreatIndicator

local ThreatOnHealth = {
	["Name"] = "|cffFFFF99Threat On Health|r",
	["Desc"] = "Enable/Disable Threat Coloring for Health.",
}
TukuiConfig.enUS["NamePlates"]["ThreatOnHealth"] = ThreatOnHealth

local ThreatGlow = {
	["Name"] = "|cffFFFF99Threat Glow|r",
	["Desc"] = "Enable/Disable Threat Glow around the Nameplate.",
}
TukuiConfig.enUS["NamePlates"]["ThreatGlow"] = ThreatGlow

local PercentageHP = {
	["Name"] = "|cffFFFF99Health percentage|r",
	["Desc"] = "Enable/Disable a percentage for Health next to the name tag.",
}
TukuiConfig.enUS["NamePlates"]["PercentageHP"] = PercentageHP

local HealthPrediction = {
	["Name"] = "|cffFFFF99Health Prediction / Healcomm|r",
	["Desc"] = "Enable/Disable a prediction for incoming Health ansd Absorbs.",
}
TukuiConfig.enUS["NamePlates"]["HealthPrediction"] = HealthPrediction

------------------------------------------------------------------------------------------
-- Set NamePlate HP percentage
------------------------------------------------------------------------------------------
local function Nameplates(self)
	local Name = self.Name
	if C["NamePlates"]["PercentageHP"] == true then
		self:Tag(Name, "[Tukui:Classification][Tukui:DiffColor][level] [Tukui:GetNameHostilityColor][Tukui:NameLong]|r   [perhp]%")
	end	
end	
hooksecurefunc(TukuiUnitFrames, "Nameplates", Nameplates)

------------------------------------------------------------------------------------------
-- Set NamePlate Health Prediction
------------------------------------------------------------------------------------------
local function Nameplates(self)
	local Health = self.Health
	local HealthTexture = T.GetTexture(C["NamePlates"]["HealthTexture"])
	
	if C["NamePlates"]["HealthPrediction"] then
		local myHealthBar = CreateFrame("StatusBar", nil, Health)
		myHealthBar:SetFrameStrata(self:GetFrameStrata())
		myHealthBar:SetPoint("TOPLEFT", Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		myHealthBar:SetPoint("BOTTOMLEFT", Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		myHealthBar:SetWidth(self:GetWidth())
		myHealthBar:SetStatusBarTexture(HealthTexture)
		myHealthBar:SetStatusBarColor(0, 0.3, 0.15, 1)
		myHealthBar:SetMinMaxValues(0,1)

		local otherHealthBar = CreateFrame("StatusBar", nil, Health)
		otherHealthBar:SetFrameStrata(self:GetFrameStrata())
		otherHealthBar:SetPoint("TOPLEFT", Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		otherHealthBar:SetPoint("BOTTOMLEFT", Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		otherHealthBar:SetWidth(self:GetWidth())
		otherHealthBar:SetStatusBarTexture(HealthTexture)
		otherHealthBar:SetStatusBarColor(0, 0.3, 0, 1)

		local absorbHealthBar = CreateFrame("StatusBar", nil, Health)
		absorbHealthBar:SetFrameStrata(self:GetFrameStrata())
		absorbHealthBar:SetPoint("TOPLEFT", Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		absorbHealthBar:SetPoint("BOTTOMLEFT", Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		absorbHealthBar:SetWidth(self:GetWidth())
		absorbHealthBar:SetStatusBarTexture(HealthTexture)
		absorbHealthBar:SetStatusBarColor(0.3, 0.3, 0, 1)

		absorbHealthBar:SetFrameLevel(Health:GetFrameLevel())
		otherHealthBar:SetFrameLevel(absorbHealthBar:GetFrameLevel() + 1)
		myHealthBar:SetFrameLevel(absorbHealthBar:GetFrameLevel() + 2)

		self.HealthPrediction = {
			myBar = myHealthBar,
			otherBar = otherHealthBar,
			absorbBar = absorbHealthBar,
			maxOverflow = 1,
		}	
	end	
end	
hooksecurefunc(TukuiUnitFrames, "Nameplates", Nameplates)

------------------------------------------------------------------------------------------
-- Set NamePlate Size when targeted
------------------------------------------------------------------------------------------
local function CreateUnits()	
	if (C["NamePlates"].Enable and C["NamePlates"].CurrentTargetGrow) then
		SetCVar("nameplateSelectedScale", (C["NamePlates"].CurrentTargetScale))
	else
		SetCVar("nameplateSelectedScale", 1)
	end		
end	
hooksecurefunc(TukuiUnitFrames, "CreateUnits", CreateUnits)

------------------------------------------------------------------------------------------
-- Set NamePlate Alpha when targeted / not targeted
------------------------------------------------------------------------------------------
local function Nameplates(self)
	local Nameplates = self

	if C["NamePlates"]["SetAlpha"] == true then 
		local function ToggleTargetGrowth(UnitIsUnit)
			if UnitIsUnit("target", self.unit) then
				Nameplates:SetAlpha(C["NamePlates"].CurrentTargetAlpha)
			else
				Nameplates:SetAlpha(C["NamePlates"].NonTargetedAlpha)
			end
		end
			
		ToggleTargetGrowth(UnitIsUnit)
				
		local EventHandler = CreateFrame("Frame")
		EventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
		EventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		EventHandler:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
		EventHandler:SetScript("OnEvent", function()
		ToggleTargetGrowth(UnitIsUnit)
		end)
	end
end
hooksecurefunc(TukuiUnitFrames, "Nameplates", Nameplates)

------------------------------------------------------------------------------------------
-- Set NamePlate threat feature
------------------------------------------------------------------------------------------
local function Nameplates(self)
	if C["NamePlates"]["ThreatIndicator"] == true or C["NamePlates"]["ThreatOnHealth"] == true or C["NamePlates"]["ThreatGlow"] == true then
		local ThreatIconFrame = CreateFrame("StatusBar")
		local Health = self.Health
		local ThreatIndicatorSize = C["NamePlates"]["ThreatIndicatorSize"]
		
		local ThreatIcon = self:CreateTexture(nil, "OVERLAY")
		ThreatIcon:Size(self:GetHeight()*1.8)
		ThreatIcon:Point("LEFT", self, "RIGHT", 0, 0)
		ThreatIcon:SetTexture([[Interface\AddOns\Tukui_NamePlateFeatures\Media\threat02.tga]])
		ThreatIcon:Hide()

		local function ThreatNamePlateUpdate()
			local GetColor = T.ColorGradient
			local unit = self.unit
			local isInGroup, isInRaid = IsInGroup(), IsInRaid()
			local Shadow = self.Shadow
		
			if UnitAffectingCombat("player") and UnitAffectingCombat(unit) and (isInRaid or isInGroup) and UnitCanAttack("player", unit) then
				local _, _, ThreatPercent = UnitDetailedThreatSituation("player", unit)
				local ThreatValue = ThreatPercent or 0
				ThreatIconFrame:SetValue(ThreatValue)
				local R, G, B = GetColor(ThreatValue, 100, 0,.8,0, .8,.8,0, .8,0,0)
				
				if C["NamePlates"]["ThreatIndicator"] then
					ThreatIcon:Show()
					ThreatIcon:SetVertexColor(R, G, B)
				end	
				
				if 	C["NamePlates"]["ThreatGlow"] then
					Shadow:SetBackdropBorderColor(R, G, B)
				end	
				
				if C["NamePlates"]["ThreatOnHealth"] then
					Health.colorTapping = false
					Health.colorReaction = false
					Health.colorDisconnected = false
					Health.colorClass = false
					Health:SetStatusBarColor(R, G, B)
				end	
			else
				if C["NamePlates"]["ThreatIndicator"] then
					ThreatIcon:Hide()
				end	
				if C["NamePlates"]["ThreatOnHealth"] then
					Health.colorTapping = true
					Health.colorReaction = true
					Health.colorDisconnected = true
					Health.colorClass = true
					Health:SetStatusBarColor(StatusBarColor) -- not working
				end	
			end
		end
		ThreatNamePlateUpdate()
				
		local EventHandler = CreateFrame("Frame")
		-- what events are useful?
		EventHandler:RegisterEvent("PLAYER_DEAD")
		EventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
		EventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
		EventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		EventHandler:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
		EventHandler:RegisterEvent("PLAYER_REGEN_ENABLED")
		EventHandler:RegisterEvent("PLAYER_REGEN_DISABLED")
		EventHandler:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
		EventHandler:SetScript("OnEvent", function()
		ThreatNamePlateUpdate()
		end)
	end
end	
hooksecurefunc(TukuiUnitFrames, "Nameplates", Nameplates)