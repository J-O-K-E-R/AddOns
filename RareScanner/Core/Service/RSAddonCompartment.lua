-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Minimap pins
local HBD_Pins = LibStub("HereBeDragons-Pins-2.0")

-- Minimap icon
local ldi = LibStub("LibDBIcon-1.0")

local RSMinimap = private.NewLib("RareScannerMinimap")

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")

-- RareScanner services
local RSMap = private.ImportLib("RareScannerMap")
local RSNpcPOI = private.ImportLib("RareScannerNpcPOI")
local RSContainerPOI = private.ImportLib("RareScannerContainerPOI")
local RSEventPOI = private.ImportLib("RareScannerEventPOI")
local RSGuidePOI = private.ImportLib("RareScannerGuidePOI")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- Addon compartiment
---============================================================================

local tooltip

function RareScanner_OnAddonCompartmentClick(addonName, button)
	if (button == "LeftButton") then
		RSExplorerFrame:Show()
	elseif (button == "RightButton") then
		InterfaceOptionsFrame_OpenToCategory("RareScanner")
		InterfaceOptionsFrame_OpenToCategory("RareScanner")
	end
end

function RareScanner_OnAddonCompartmentEnter(addonName, button)
	if (not tooltip) then
		tooltip = CreateFrame("GameTooltip", "RareScanner_AddonCompartimentTooltip", UIParent, "GameTooltipTemplate")
	end
	
    tooltip:SetOwner(button, "ANCHOR_LEFT");
	tooltip:SetText("RareScanner")
	tooltip:AddLine(AL["MINIMAP_ICON_TOOLTIP1"], 1, 1, 1)
	tooltip:AddLine(AL["MINIMAP_ICON_TOOLTIP2"], 1, 1, 1)
	tooltip:Show()
end

function RareScanner_OnAddonCompartmentLeave(addonName, button)
	tooltip:Hide()
end