--[[	

    $$$$$$$\                      $$$$$$$\                               $$\ 
    $$  __$$\                     $$  __$$\                              $$ |
    $$ |  $$ | $$$$$$\   $$$$$$\  $$ |  $$ |$$$$$$\  $$$$$$$\   $$$$$$\  $$ |
    $$$$$$$  |$$  __$$\ $$  __$$\ $$$$$$$  |\____$$\ $$  __$$\ $$  __$$\ $$ |
    $$  __$$< $$$$$$$$ |$$ /  $$ |$$  ____/ $$$$$$$ |$$ |  $$ |$$$$$$$$ |$$ |
    $$ |  $$ |$$   ____|$$ |  $$ |$$ |     $$  __$$ |$$ |  $$ |$$   ____|$$ |
    $$ |  $$ |\$$$$$$$\ $$$$$$$  |$$ |     \$$$$$$$ |$$ |  $$ |\$$$$$$$\ $$ |
    \__|  \__| \_______|$$  ____/ \__|      \_______|\__|  \__| \_______|\__|
                        $$ |                                                 
                        $$ |                                                 
                        \__|                                                

--]]

local RepPanel = {}

---------------------------------------------------------------------------------------------
--								Exports
---------------------------------------------------------------------------------------------
_G.PrettyReps.RepPanel = {}

function _G.PrettyReps.RepPanel.InitReputationRow(...)
    RepPanel:ReputationFrame_InitReputationRow(...)
end

---------------------------------------------------------------------------------------------
--								Functions
---------------------------------------------------------------------------------------------

function RepPanel:GetOption(name)
    return _G.PrettyReps.DataUtils.GetOption(name)
end

function RepPanel:GetFactionInfo(panelData, factionIndex)
	local factionData = panelData[factionIndex]
	return factionData
end

function RepPanel:GetSelectedFaction()
	-- return selectedFactionIndex
    return -1
end

function RepPanel:ReputationFrame_InitReputationRow(panelData, factionRow, elementData)
    local factionIndex = elementData.index;
	local factionContainer = factionRow.Container;
	local factionBar = factionContainer.ReputationBar;
	local factionTitle = factionContainer.Name;
	local factionButton = factionContainer.ExpandOrCollapseButton;
	local factionStanding = factionBar.FactionStanding;

    local factionData = self:GetFactionInfo(panelData, factionIndex);

    local name = factionData.name
	local description = factionData.description
	local standingID = factionData.standingID
	local barMin = factionData.bottomValue
	local barMax = factionData.topValue
	local barValue = factionData.earnedValue
	local atWarWith = factionData.atWarWith
	local canToggleAtWar = factionData.canToggleAtWar
	local isHeader = factionData.isHeader
	local isCollapsed = factionData.isCollapsed
	local hasRep = factionData.hasRep
	local isChild = factionData.isChild
	local isLayoutChild = factionData.isLayoutChild
	local factionID = factionData.factionID
	local hasBonusRepGain = factionData.hasBonusRepGain
	local isFriendship = factionData.isFriendship
	local factionStandingtext = factionData.factionStandingtext
	local colorIndex = factionData.colorIndex
	local friendshipID = factionData.friendshipID
	local hasEncountered = factionData.hasEncountered

	local isMajorFaction = factionData.isMajorFaction
	local majorFactionData = factionData.majorFactionData
	local hasMaximumRenown = factionData.hasMaximumRenown

    factionRow.factionData = factionData
    factionRow:SetScript("OnClick", function() RepPanel:ReputationBar_OnClick(factionRow) end)
    factionRow:SetScript("OnEnter", function() RepPanel:ReputationBar_OnEnter(factionRow) end)
    factionRow:SetScript("OnLeave", function() RepPanel:ReputationBar_OnLeave(factionRow) end)

    if self:GetOption("GroupTotals", true) and factionData.exaltedCount then
		name = name .. " (" .. factionData.exaltedCount .. "/" .. factionData.exaltedTotal .. ")"
	end

    factionTitle:SetText(name);
	if ( isCollapsed ) then
		factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	else
		factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	end

    local colorIndex = standingID;
	local barColor = FACTION_BAR_COLORS[colorIndex];
	local factionStandingtext;

	local isCapped;
	if (standingID == MAX_REPUTATION_REACTION) then
		isCapped = true;
	end

    -- check if this is a friendship faction or a Major Faction
	local repInfo = factionData.isFriendship and factionData.friendshipData
	if (repInfo and repInfo.friendshipFactionID > 0) then
		factionStandingtext = repInfo.reaction;
		if ( repInfo.nextThreshold ) then
			barMin, barMax, barValue = repInfo.reactionThreshold, repInfo.nextThreshold, repInfo.standing;
		else
			-- max rank, make it look like a full bar
			barMin, barMax, barValue = 0, 1, 1;
			isCapped = true;
		end
		local friendshipColorIndex = 5;
		barColor = FACTION_BAR_COLORS[colorIndex];						-- always color friendships green
		factionRow.friendshipID = repInfo.friendshipFactionID;			-- for doing friendship tooltip
	elseif ( isMajorFaction ) then

		barMin, barMax = 0, majorFactionData.renownLevelThreshold;
		isCapped = hasMaximumRenown
		barValue = isCapped and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0;
		barColor = BLUE_FONT_COLOR;

		factionRow.friendshipID = nil;
		factionStandingtext = RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel;
	else
		local gender = UnitSex("player");
		factionStandingtext = GetText("FACTION_STANDING_LABEL"..standingID, gender);
		factionRow.friendshipID = nil;
	end
    factionStanding:SetText(factionStandingtext);

	--Normalize Values
	barMax = barMax - barMin;
	barValue = barValue - barMin;
	barMin = 0;

	factionRow.standingText = factionStandingtext;

	if ( isCapped ) then
		factionRow.rolloverText = nil
	else
		factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE..format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(barMax))..FONT_COLOR_CODE_CLOSE;
	end

    factionBar:SetFillStyle("STANDARD_NO_RANGE_FILL");
	factionBar:SetMinMaxValues(0, barMax);
	factionBar:SetValue(barValue);
	factionBar:SetStatusBarColor(barColor.r, barColor.g, barColor.b);

	-- Paragon
	factionContainer.Paragon:SetShown(false);
	local isParagon = factionID and C_Reputation.IsFactionParagon(factionID);
	if (isParagon) then
		local paragonFrame = factionContainer.Paragon;
		paragonFrame.factionID = factionID;
		local currentValue, threshold, rewardQuestID, hasRewardPending, tooLowLevelForParagon = C_Reputation.GetFactionParagonInfo(factionID);
		C_Reputation.RequestFactionParagonPreloadRewardData(factionID);

		if _G.PrettyReps.DataUtils.GetOption("ShowParagonIcons", true) and (hasRewardPending or not _G.PrettyReps.DataUtils.GetOption("ParagonIconsRewardOnly", false)) then
			factionContainer.Paragon:SetShown(true);

			paragonFrame.Glow:SetShown(not tooLowLevelForParagon and hasRewardPending);
			paragonFrame.Check:SetShown(not tooLowLevelForParagon and hasRewardPending);
		end

		if currentValue and _G.PrettyReps.DataUtils.GetOption("ShowParagonBars", true) then
			barMax = threshold
			barMin = 0
			barValue = mod(currentValue, threshold)
			factionBar:SetMinMaxValues(0, threshold)
			factionBar:SetValue(barValue)
			factionBar:SetStatusBarColor(0, 0.5, 0.9)
			factionStanding:SetText("Paragon")
			factionRow.standingText = "Paragon"
			factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE
		end
	end

	factionBar.BonusIcon:SetShown(hasBonusRepGain);

	self:ReputationFrame_SetRowType(factionRow, isLayoutChild, isHeader, hasRep);

	factionRow:Show();

    -- Update details if this is the selected faction
	if ( atWarWith ) then
		factionContainer.ReputationBar.AtWarHighlight1:Show();
		factionContainer.ReputationBar.AtWarHighlight2:Show();
	else
		factionContainer.ReputationBar.AtWarHighlight1:Hide();
		factionContainer.ReputationBar.AtWarHighlight2:Hide();
	end

	if ( factionID == _G.PrettyReps.DataUtils:GetSelectedFaction().factionID ) then
		if ( ReputationDetailFrame:IsShown() ) then
			ReputationDetailFactionName:SetText(name);
			ReputationDetailFactionDescription:SetText(description);

			local isMajorFaction = false
			ReputationDetailFrame:SetHeight(isMajorFaction and 228 or 203);
			ReputationDetailViewRenownButton:SetShown(isMajorFaction);
			factionContainer.ReputationBar.Highlight1:Show();
			factionContainer.ReputationBar.Highlight2:Show();
		end
	else
		factionContainer.ReputationBar.Highlight1:Hide();
		factionContainer.ReputationBar.Highlight2:Hide();
	end
end

function RepPanel:ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)
	local factionData = factionRow.factionData
	local factionID = factionRow.factionData.factionID
	local factionContainer = factionRow.Container;
	local factionBar = factionContainer.ReputationBar;
	local factionTitle = factionContainer.Name;
	local factionButton = factionContainer.ExpandOrCollapseButton;
	local factionBackground = factionContainer.Background;
	local factionStanding = factionBar.FactionStanding;
	local factionLeftTexture = factionBar.LeftTexture;
	local factionRightTexture = factionBar.RightTexture;

	factionLeftTexture:SetWidth(62);
	factionRightTexture:SetWidth(42);
	factionBar:SetPoint("RIGHT", 0, 0);
	if ( isHeader ) then
		local isMajorFactionHeader = factionID and C_Reputation.IsMajorFaction(factionID);

		local xOffset = isMajorFactionHeader and 25 or isChild and 15 or 2;
		local yOffset = 0;
		factionContainer:SetPoint("LEFT", xOffset, yOffset);

		factionButton:SetPoint("LEFT", factionContainer, "LEFT", 3, 0);
		factionButton:SetScript("OnClick", function() _G.PrettyReps.DataUtils:ToggleCollapsed(factionData) end)
		factionButton:Show();

		factionTitle:SetPoint("LEFT", factionButton, "RIGHT", 10, 0);
		local relativePoint = hasRep and "LEFT" or "RIGHT";
		factionTitle:SetPoint("RIGHT", factionBar, relativePoint, -3, 0);
		factionTitle:SetFontObject(isMajorFactionHeader and GameFontHighlightSmall or GameFontNormalLeft);

		factionBackground:SetShown(isMajorFactionHeader);

		if isMajorFactionHeader then
			factionLeftTexture:SetHeight(21);
			factionRightTexture:SetHeight(21);
			factionLeftTexture:SetTexCoord(0.7578125, 1.0, 0.0, 0.328125);
			factionRightTexture:SetTexCoord(0.0, 0.1640625, 0.34375, 0.671875);
			factionBar:SetWidth(101);
		else
			factionLeftTexture:SetHeight(15);
			factionLeftTexture:SetWidth(60);
			factionRightTexture:SetHeight(15);
			factionRightTexture:SetWidth(39);
			factionLeftTexture:SetTexCoord(0.765625, 1.0, 0.046875, 0.28125);
			factionRightTexture:SetTexCoord(0.0, 0.15234375, 0.390625, 0.625);
			factionBar:SetWidth(99);
		end
	else
		local xOffset = isChild and 44 or 25;
		local yOffset = 0;
		factionContainer:SetPoint("LEFT", xOffset, yOffset);

		factionButton:Hide();
		factionTitle:SetPoint("LEFT", 10, 0);
		factionTitle:SetPoint("RIGHT", factionBar, "LEFT", -3, 0);
		factionTitle:SetFontObject(GameFontHighlightSmall);
		factionBackground:Show();
		factionLeftTexture:SetHeight(21);
		factionRightTexture:SetHeight(21);
		factionLeftTexture:SetTexCoord(0.7578125, 1.0, 0.0, 0.328125);
		factionRightTexture:SetTexCoord(0.0, 0.1640625, 0.34375, 0.671875);
		factionBar:SetWidth(101)
	end

	factionStanding:SetShown(hasRep or not isHeader);
	factionBar:SetShown(hasRep or not isHeader);
	factionBar:GetParent():GetParent().hasRep = hasRep or not isHeader;
end

---------------------------------------------------------------------------------------------
--								Reputation Bar Events
---------------------------------------------------------------------------------------------

function RepPanel:ReputationBar_OnClick(factionRow)
    local factionData = factionRow.factionData

    if ( ReputationDetailFrame:IsShown() and (_G.PrettyReps.DataUtils.GetSelectedFaction().factionID == factionData.factionID) ) then
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
		ReputationDetailFrame:Hide();
        _G.PrettyReps.DataUtils.ClearSelectedFaction()
	else
        if ( factionData.hasRep or not factionData.isHeader ) then
            PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
            _G.PrettyReps.DataUtils.SetSelectedFaction(factionData)
            ReputationDetailFrame:Show();
            _G.PrettyReps.Refresh()
        end
	end

	RepPanel:ShowTooltip(factionRow)
end

function RepPanel:ReputationBar_OnEnter(factionRow)
    if (factionRow.rolloverText) then
		factionRow.Container.ReputationBar.FactionStanding:SetText(factionRow.rolloverText);
	end

	factionRow.Container.ReputationBar.Highlight1:Show();
	factionRow.Container.ReputationBar.Highlight2:Show();
	
	if not factionRow.factionData.isHeader or factionRow.factionData.hasRep then
		RepPanel:ShowTooltip(factionRow)
	end
end

function RepPanel:ReputationBar_OnLeave(factionRow)
	factionRow.Container.ReputationBar.FactionStanding:SetText(factionRow.standingText);
    local selectedFaction = _G.PrettyReps.DataUtils.GetSelectedFaction()

    if selectedFaction.factionID ~= factionRow.factionData.factionID or ((not ReputationDetailFrame:IsShown())) then
        factionRow.Container.ReputationBar.Highlight1:Hide();
		factionRow.Container.ReputationBar.Highlight2:Hide();
    end

	GameTooltip:Hide();
end

---------------------------------------------------------------------------------------------
--								Tooltip
---------------------------------------------------------------------------------------------

function RepPanel:ShowTooltip(factionRow)
	if ReputationDetailFrame:IsShown() then
		GameTooltip:SetOwner(ReputationDetailFrame, "ANCHOR_BOTTOMRIGHT", -208, 0);
	else
		GameTooltip:SetOwner(factionRow, "ANCHOR_BOTTOMRIGHT", 0, 0);
	end

	if factionRow.factionData.isFriendship then
		self:ShowFriendshipReputationTooltip(factionRow)
	elseif factionRow.factionData.isMajorFaction and not factionRow.factionData.hasMaximumRenown then
		self:ShowMajorFactionRenownTooltip(factionRow);
	else
		self:ShowReputationTooltip(factionRow)
	end
end

function RepPanel:ShowFriendshipReputationTooltip(factionRow)
	local repInfo = factionRow.factionData.friendshipData
	if ( repInfo and repInfo.friendshipFactionID and repInfo.friendshipFactionID > 0) then
		local rankInfo = factionRow.factionData.friendshipRanks
		if ( rankInfo.maxLevel > 0 ) then
			GameTooltip:SetText(repInfo.name.." ("..rankInfo.currentLevel.." / "..rankInfo.maxLevel..")", 1, 1, 1);
		else
			GameTooltip:SetText(repInfo.name, 1, 1, 1);
		end
		GameTooltip:AddLine(repInfo.text, nil, nil, nil, true);
		if ( repInfo.nextThreshold ) then
			local current = repInfo.standing - repInfo.reactionThreshold;
			local max = repInfo.nextThreshold - repInfo.reactionThreshold;
			GameTooltip:AddLine(repInfo.reaction.." ("..current.." / "..max..")" , 1, 1, 1, true);
		else
			GameTooltip:AddLine(repInfo.reaction, 1, 1, 1, true);
		end

		AddAttainedByLine(factionRow)
		GameTooltip:Show();
	end
end

function RepPanel:ShowMajorFactionRenownTooltip(factionRow)
	local function AddRenownRewardsToTooltip(renownRewards)
		GameTooltip_AddHighlightLine(GameTooltip, MAJOR_FACTION_BUTTON_TOOLTIP_NEXT_REWARDS);
	
		for i, rewardInfo in ipairs(renownRewards) do
			local renownRewardString;
			local icon, name, description = RenownRewardUtil.GetRenownRewardInfo(rewardInfo, GenerateClosure(factionRow.ShowMajorFactionRenownTooltip, factionRow));
			if icon then
				local file, width, height = icon, 16, 16;
				local rewardTexture = CreateSimpleTextureMarkup(file, width, height);
				renownRewardString = rewardTexture .. " " .. name;
			end
			local wrapText = false;
			GameTooltip_AddNormalLine(GameTooltip, renownRewardString, wrapText);
		end
	end

	local majorFactionData = factionRow.factionData.majorFactionData

	local tooltipTitle = majorFactionData.name;
	GameTooltip_SetTitle(GameTooltip, tooltipTitle, NORMAL_FONT_COLOR);
	GameTooltip_AddColoredLine(GameTooltip, RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel, BLUE_FONT_COLOR);	
	GameTooltip_AddBlankLineToTooltip(GameTooltip);
	GameTooltip_AddHighlightLine(GameTooltip, MAJOR_FACTION_RENOWN_TOOLTIP_PROGRESS:format(majorFactionData.name));
	GameTooltip_AddBlankLineToTooltip(GameTooltip);

	local nextRenownRewards = C_MajorFactions.GetRenownRewardsForLevel(majorFactionData.factionID, majorFactionData.renownLevel + 1)
	if #nextRenownRewards > 0 then
		AddRenownRewardsToTooltip(nextRenownRewards);
	end

	GameTooltip_AddBlankLineToTooltip(GameTooltip)
	AddAttainedByLine(factionRow)
	GameTooltip:Show();
end

function RepPanel:ShowReputationTooltip(factionRow)
	GameTooltip:SetText(factionRow.factionData.name, nil, nil, nil, nil, true)
	GameTooltip:AddLine(factionRow.standingText..(factionRow.rolloverText and " ("..factionRow.rolloverText..")" or ""), 1, 1, 1)
	AddAttainedByLine(factionRow)	
	GameTooltip:Show();
end

function AddAttainedByLine(factionRow)
	local realm = factionRow.factionData.playerRealm and factionRow.factionData.playerRealm or '<Unknown Realm>'
	local text = "Attained by " .. factionRow.factionData.playerName .. " - " .. realm
	GameTooltip_AddColoredLine(GameTooltip, text, REFUND_TOOLTIP_COLOR, false)
end
