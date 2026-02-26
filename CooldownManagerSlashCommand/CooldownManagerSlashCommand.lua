-- API cache
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local InCombatLockdown = InCombatLockdown

-- Global environment
local _G = _G
local CooldownViewerSettings = _G.CooldownViewerSettings

-- Don't register /wa if WeakAuras is loaded
local waLoaded = IsAddOnLoaded('WeakAuras')
if waLoaded then
	print('Cooldown Manager Slash Command: WeakAuras AddOn detected, only registering /cd and skipping /wa')
end

local function ShowCooldownViewerSettings()
	if InCombatLockdown() or not CooldownViewerSettings then return end

	if not CooldownViewerSettings:IsShown() then
		CooldownViewerSettings:Show()
	else
		CooldownViewerSettings:Hide()
	end
end

SLASH_CDMSC1 = '/cd'
SLASH_CDMSC2 = not waLoaded and '/wa' or nil
function SlashCmdList.CDMSC(msg, editbox)
	ShowCooldownViewerSettings()
end
