local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")

function f:ADDON_LOADED(event, addon)
	LibStub("AddonsPanel").new(nil, "DeathAlerts")

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end

function f:PLAYER_LOGIN()
	local s = {}
	local a = {}
	local e = {}
	local ma = {}
	local en = {}
	local ena = {}
	local name = ""
	local role = ""
	local ra_message = ""
	local partyMember = ""
	local raidMember = ""
	local playerName = ""
	local isDead = ""
	local lastSpell = ""
	local lastAmount = ""
	local lastEvent = ""

	--f:SetScript("OnEvent", function(self, oEvent, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, over, ...)
	f:SetScript("OnEvent", function(self, oEvent)
		timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, over = CombatLogGetCurrentEventInfo(self)

		if destName then name = destName else name = "someone" end

		player, partyMember, raidMember, isDead = UnitName("player"), UnitInParty(name), UnitInRaid(name), UnitIsDead(name)

		if s[name] ~= "Dazed" and e[name] ~= "SPELL_AURA_REMOVED" and e[name] ~= "SPELL_AURA_APPLIED" then
			lastSpell, lastAmount, lastEvent, lastMeleeAmount, lastEnvironType, lastEnvironAmount = s[name], a[name], e[name], ma[name], en[name], ena[name]
		end
		-- If Melee, spellId is damage amount
		-- If Environ, spellId is damage type, spellName is damage amount

		if isDead then
			if partyMember or raidMember or player == name then
				if lastAmount ~= "BUFF" and lastAmount ~= "DEBUFF" then
					if lastAmount ~= nil and lastEvent == "SPELL_DAMAGE" or lastEvent == "SPELL_PERIODIC_DAMAGE" or lastEvent == "RANGE_DAMAGE" then
						DEFAULT_CHAT_FRAME:AddMessage("<" .. name .. "> died to <" .. lastSpell .. "> (" .. lastAmount .. ")", rDAColor, gDAColor, bDAColor)
					elseif lastEvent == "SWING_DAMAGE" and lastMeleeAmount ~= nil then
						DEFAULT_CHAT_FRAME:AddMessage("<" .. name .. "> died to melee damage (" .. lastMeleeAmount .. ")", rDAColor, gDAColor, bDAColor)
					elseif lastEvent == "ENVIRONMENTAL_DAMAGE" and lastEnvironAmount ~= nil then
						DEFAULT_CHAT_FRAME:AddMessage("<" .. name .. "> died to <" .. lastEnvironType .. "> (" .. lastEnvironAmount .. ")", rDAColor, gDAColor, bDAColor)
					end
				end
			end
		end

		s[name], ma[name], a[name], e[name], en[name], ena[name] = spellName, spellId, amount, event, spellId, spellName
		
	end)
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

SLASH_DeathAlerts1, SLASH_DeathAlerts2 = "/deathalerts", "/da"

SlashCmdList.DeathAlerts = function(input)
	if DeathAlerts_Enabled or DeathAlerts_Enabled == nil then
		DeathAlerts_Enabled = false
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		print("DeathAlerts: |cffff0000 Disabled")
	else
		DeathAlerts_Enabled = true
		f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		print("DeathAlerts: |cff008000 Enabled")
	end
end