local addonName, PrettyReps = ...

local ReputationService = PrettyReps.ReputationService

MAX_REPUTATION_REACTION = 8;

local ReputationFilterSortTypeOrder = {
    "none",
    "character"
}

local function GetReputationSortTypeName(sortType)
    local sortTypeNames = {
        ["none"] = "All",
    }

    if sortType == "character" then
        return UnitName("player")
    end
    
    return sortTypeNames[sortType]
end

PrettyRepsReputationFrameMixin = {};

function PrettyRepsReputationFrameMixin:OnLoad()
	local view = CreateScrollBoxListLinearView();

	local function Initializer(button, elementData)
		button:Initialize(elementData);
	end

	view:SetElementIndentCalculator(function(elementData)
		local isTopLevelHeader = elementData.isHeader and not elementData.isChild;
		if isTopLevelHeader then
			return 0;
		end

		local isChildOfSubHeader = not elementData.isHeader and elementData.isChild;
		if isChildOfSubHeader then
			return 46;
		end

		return 2;
	end);

	view:SetElementFactory(function(factory, elementData)
		if not elementData.isHeader then
			factory("PrettyRepsReputationEntryTemplate", Initializer);
			return;
		end

		local isTopLevelHeader = elementData.isHeader and not elementData.isChild;
		if isTopLevelHeader then
			factory("PrettyRepsReputationHeaderTemplate", Initializer);
			return;
		end

		local isSubHeader = elementData.isHeader and elementData.isChild;
		if isSubHeader then
			factory("PrettyRepsReputationSubHeaderTemplate", Initializer);
			return;
		end
	end);

	local topPadding, bottomPadding, leftPadding, rightPadding = 10, 10, 5, 5;
	local elementSpacing = 3;
	view:SetPadding(topPadding, bottomPadding, leftPadding, rightPadding, elementSpacing);

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);

	self.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnDataRangeChanged, GenerateClosure(self.RefreshAccountWideReputationTutorial), self);

	self.filterDropdown:SetWidth(130);
	self.TransferButton:SetSize(22, 22)

	PrettyReps.Events:RegisterCallback(PrettyReps.Events.Names.CacheInvalidated, 
        function()
            if self:IsVisible() then
                self:Update() 
            end
        end,
        self
    );

    -- Add button handlers
    PrettyRepsSettingsFrame.ScrollFrame.OptionsContainer.ActionsSection.ExpandAllButton:SetScript("OnClick", function()
        PrettyReps.DataManager:ExpandAll()
    end)
    
    PrettyRepsSettingsFrame.ScrollFrame.OptionsContainer.ActionsSection.CollapseAllButton:SetScript("OnClick", function()
        PrettyReps.DataManager:CollapseAll()
    end)
end

function PrettyRepsReputationFrameMixin:UpdateSearchResults(searchText)
    -- Update the options with search text
    PrettyReps.OptionsManager:SetOption("searchText", searchText)
    
    -- Update will now use the search text from options
    self:Update()
end

PrettyRepsReputationTransferButtonMixin = {};

-- Button handlers as part of the button's mixin
function PrettyRepsReputationTransferButtonMixin:OnClick(button)
    if PrettyRepsSettingsFrame:IsShown() then
        PrettyRepsSettingsFrame:Hide();
    else
        -- Hide reputation detail frame if it's showing
        if PrettyRepsReputationFrame.ReputationDetailFrame:IsShown() then
            PrettyRepsReputationFrame.ReputationDetailFrame:Hide();
        end
        PrettyRepsSettingsFrame:Show();
    end
end

function PrettyRepsReputationTransferButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip_AddNormalLine(GameTooltip, "Configure PrettyReps")
    GameTooltip:Show()
end

function PrettyRepsReputationTransferButtonMixin:OnLeave()
    GameTooltip:Hide()
end

local ReputationFrameEvents = {
	"MAJOR_FACTION_RENOWN_LEVEL_CHANGED",
	"MAJOR_FACTION_UNLOCKED",
	"QUEST_LOG_UPDATE",
	"UPDATE_FACTION",
}

local function IsSortTypeSelected(sortType)
    return PrettyReps.ReputationService:GetReputationSortType() == sortType
end

local function SetSortTypeSelected(sortType)
    PrettyReps.ReputationService:SetReputationSortType(sortType)
end

local function IsLegacyRepSelected()
	return C_Reputation.AreLegacyReputationsShown();
end

local function SetLegacyRepSelected()
	C_Reputation.SetLegacyReputationsShown(not IsLegacyRepSelected()); 
end

local function IsNotEncounteredSelected()
    return PrettyReps.OptionsManager:GetOption("showNotEncountered");
end

local function SetNotEncounteredSelected()
    local current = PrettyReps.OptionsManager:GetOption("showNotEncountered");
    PrettyReps.OptionsManager:SetOption("showNotEncountered", not current);
end

function PrettyRepsReputationFrameMixin:OnShow()
    FrameUtil.RegisterFrameForEvents(self, ReputationFrameEvents)
    self:Update()

    local parent = self:GetParent()
    if HelpTip:IsShowing(parent, REPUTATION_EXALTED_PLUS_HELP) then
        HelpTip:Hide(parent, REPUTATION_EXALTED_PLUS_HELP)
        SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_REPUTATION_EXALTED_PLUS, true)
    end

    self.filterDropdown:SetupMenu(function(dropdown, rootDescription)
        rootDescription:SetTag("MENU_REPUTATION_FRAME_FILTER")

        -- Sort type radio buttons
        for index, sortType in ipairs(ReputationFilterSortTypeOrder) do
            rootDescription:CreateRadio(GetReputationSortTypeName(sortType), 
                IsSortTypeSelected, SetSortTypeSelected, sortType)
        end
    end)
end

function PrettyRepsReputationFrameMixin:OnHide()
	FrameUtil.UnregisterFrameForEvents(self, ReputationFrameEvents);
	-- Hide settings frame when reputation frame is hidden
	if PrettyRepsSettingsFrame and PrettyRepsSettingsFrame:IsShown() then
		PrettyRepsSettingsFrame:Hide();
	end
end

function PrettyRepsReputationFrameMixin:OnEvent(event, ...)
	if event == "UPDATE_FACTION" or event == "QUEST_LOG_UPDATE" or event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED" or event == "MAJOR_FACTION_UNLOCKED" then
		self:Update();
	end
end

function PrettyRepsReputationFrameMixin:Update()
    local factionList = {}
    for index = 1, ReputationService:GetNumFactions() do
        local factionData = ReputationService:GetFactionDataByIndex(index)
        if factionData then
            factionData.factionIndex = index
            tinsert(factionList, factionData)
        end
    end
    
    self.ScrollBox:SetDataProvider(CreateDataProvider(factionList), ScrollBoxConstants.RetainScrollPosition)
    self.ReputationDetailFrame:Refresh()
end

function PrettyRepsReputationFrameMixin:RefreshAccountWideReputationTutorial()
	HelpTip:Hide(self, ACCOUNT_WIDE_REPUTATION_TUTORIAL);

	local tutorialAcknowledged = GetCVarBitfield("closedInfoFramesAccountWide", LE_FRAME_TUTORIAL_ACCOUNT_WIDE_REPUTATION);
	if tutorialAcknowledged then
		return;
	end

	local accountWideReputation = self.ScrollBox:FindFrameByPredicate(function(button, elementData) return elementData.isAccountWide; end);
	if not accountWideReputation then
		return;
	end

	local helpTipInfo = {
		text = ACCOUNT_WIDE_REPUTATION_TUTORIAL,
		buttonStyle = HelpTip.ButtonStyle.Close,
		cvarBitfield = "closedInfoFramesAccountWide",
		bitfieldFlag = LE_FRAME_TUTORIAL_ACCOUNT_WIDE_REPUTATION,
		targetPoint = HelpTip.Point.RightEdgeCenter,
		offsetX = 40,
		alignment = HelpTip.Alignment.Center,
		acknowledgeOnHide = false,
		checkCVars = true,
	};
	HelpTip:Show(self, helpTipInfo, accountWideReputation);
end

local ReputationType = EnumUtil.MakeEnum(
	"Standard",
	"Friendship",
	"MajorFaction"
);

local function GetReputationTypeFromElementData(elementData)
	if not elementData then
		return nil;
	end

	if not elementData.hasBeenEncountered then
        return ReputationType.Standard;
    end

	local friendshipData = C_GossipInfo.GetFriendshipReputation(elementData.factionID);
	local isFriendshipReputation = friendshipData and friendshipData.friendshipFactionID > 0;
	if isFriendshipReputation then
		return ReputationType.Friendship;
	end

	if ReputationService:IsMajorFaction(elementData.factionID) then
		return ReputationType.MajorFaction;
	end

	return ReputationType.Standard;
end

PrettyRepsReputationHeaderMixin = {};

function PrettyRepsReputationHeaderMixin:Initialize(elementData)
	self.elementData = elementData;
	self.factionIndex = elementData.factionIndex;
	self.factionID = elementData.factionID;

	-- Show completion stats in header if enabled and stats exist
	if elementData.isHeader and not elementData.isChild and elementData.completionStats 
		and PrettyReps.ReputationService:IsDisplayGroupTotals() then
		local stats = elementData.completionStats
		local displayText
		if PrettyReps.OptionsManager:GetOption("displayTotalsAsPercentage") then
			-- Format percentage to only show decimal if needed
			local percentage = stats.percentage
			local percentageText = percentage % 1 == 0 and 
				string.format("%d%%", percentage) or 
				string.format("%.1f%%", percentage)
			
			displayText = string.format("%s (%s)", 
				elementData.name,
				percentageText
			)
		else
			displayText = string.format("%s (%d/%d)", 
				elementData.name,
				stats.completed,
				stats.total
			)
		end
		self.Name:SetText(displayText)
	else
		self.Name:SetText(self.elementData.name or "");
	end

	self.Right:SetAtlas(self:IsCollapsed() and "Options_ListExpand_Right" or "Options_ListExpand_Right_Expanded", TextureKitConstants.UseAtlasSize);
	self.HighlightRight:SetAtlas(self:IsCollapsed() and "Options_ListExpand_Right" or "Options_ListExpand_Right_Expanded", TextureKitConstants.UseAtlasSize);
end

function PrettyRepsReputationHeaderMixin:IsCollapsed()
	return self.elementData.isCollapsed;
end

function PrettyRepsReputationHeaderMixin:ToggleCollapsed()
	if self:IsCollapsed() then
		ReputationService:ExpandFactionHeader(self.factionIndex);
	else
		ReputationService:CollapseFactionHeader(self.factionIndex);
	end
end

function PrettyRepsReputationHeaderMixin:OnMouseDown()
	self.Name:AdjustPointsOffset(1, -1);
end

function PrettyRepsReputationHeaderMixin:OnMouseUp()
	self.Name:AdjustPointsOffset(-1, 1);
end

function PrettyRepsReputationHeaderMixin:OnClick()
	self:ToggleCollapsed();
end

PrettyRepsReputationEntryMixin = CreateFromMixins(CallbackRegistryMixin);

function PrettyRepsReputationEntryMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);
	self:AddDynamicEventMethod(EventRegistry, "ReputationFrame.NewFactionSelected", self.RefreshHighlightVisuals);

	self.Content.AccountWideIcon:SetScript("OnLeave", function()
		GameTooltip_Hide();
		self:OnLeave();
	end);

	self.Content.BackgroundHighlight:SetFrameLevel(self:GetFrameLevel() - 1);
end

function PrettyRepsReputationEntryMixin:Initialize(elementData)
    self.factionIndex = elementData.factionIndex
    self.factionID = elementData.factionID
    self.elementData = elementData
	self.reputationType = GetReputationTypeFromElementData(self.elementData)

    self.Content.Name:SetText(self.elementData.name or "")
    self.Content.ReputationBar:SetShown(elementData.hasBeenEncountered)
    self.Content.NotEncounteredText:SetShown(not elementData.hasBeenEncountered)
    
    if elementData.hasBeenEncountered then
        self:InitializeReputationBarForReputationType()
    end

    self:TryInitParagonDisplay()
    self:RefreshHighlightVisuals()
end

function PrettyRepsReputationEntryMixin:TryInitParagonDisplay()
    local factionID = self.factionID;
    local paragonIcon = self.Content.ParagonIcon;
    
    -- Get paragon info first to check for rewards
    local currentValue, threshold, rewardQuestID, hasRewardPending, tooLowLevelForParagon = ReputationService:GetFactionParagonInfo(factionID);
    
    -- Check if we should hide the icon
    if ReputationService:IsHideParagonIcons() and 
       (not ReputationService:IsShowParagonRewards() or not hasRewardPending) or
       not ReputationService:IsFactionParagon(factionID) or
       not self.elementData.hasBeenEncountered then
        paragonIcon:Hide();
        return;
    end

    -- Setup paragon icon states
    C_Reputation.RequestFactionParagonPreloadRewardData(factionID);
    paragonIcon.Glow:SetShown(not tooLowLevelForParagon and hasRewardPending);
    paragonIcon.Check:SetShown(not tooLowLevelForParagon and hasRewardPending);
    paragonIcon:Show();
end

function PrettyRepsReputationEntryMixin:OnClick()
	-- Hide settings frame if it's showing when selecting a faction
	if PrettyRepsSettingsFrame:IsShown() then
		PrettyRepsSettingsFrame:Hide();
	end

	local alreadySelected = self:IsSelected();
	ReputationService:SetSelectedFaction(not alreadySelected and self.factionIndex or 0);

	-- Hide this faction's tooltip when it is selected (since we're showing the options for this reputation)
	if self:IsSelected() then
		self:HideTooltip();
	-- If we just deselected the faction, then we're clear to show the tooltip again 
	elseif self:IsMouseOver() then
		self:ShowTooltipForReputationType();
	end

	EventRegistry:TriggerEvent("ReputationFrame.NewFactionSelected");
end

function PrettyRepsReputationEntryMixin:OnMouseDown()
	self.Content:AdjustPointsOffset(1, -1);
end

function PrettyRepsReputationEntryMixin:OnMouseUp()
	self.Content:AdjustPointsOffset(-1, 1);
end

function PrettyRepsReputationEntryMixin:OnEnter()
	self.Content.ReputationBar:TryShowBarProgressText();

	self:RefreshHighlightVisuals();
	
	if not self:IsSelected() then
		self:ShowTooltipForReputationType();
	end
end

local function AddCharacterAttribution(tooltip, elementData, useBottomText)
    if not elementData or not elementData.character then
        return
    end

    local charInfo = string.format("Attained by %s - %s", 
        elementData.character.name,
        elementData.character.realm
    );

    if useBottomText then
        GameTooltip_SetBottomText(tooltip, charInfo, ACCOUNT_WIDE_FONT_COLOR)
    else
        local wrapText = false
        GameTooltip_AddColoredLine(tooltip, charInfo, ACCOUNT_WIDE_FONT_COLOR, wrapText)
    end
end

function PrettyRepsReputationEntryMixin:ShowTooltipForReputationType()
	if ReputationService:IsFactionParagon(self.elementData.factionID) then
		self:ShowParagonRewardsTooltip();
	elseif self.reputationType == ReputationType.Friendship then
		local canClickForOptions = true;
		self:ShowFriendshipReputationTooltip(self.elementData.factionID, "ANCHOR_RIGHT", canClickForOptions);
	elseif self.reputationType == ReputationType.MajorFaction then
		self:ShowMajorFactionRenownTooltip();
	elseif self.reputationType == ReputationType.Standard then
		self:ShowStandardTooltip();
	end
end

local function TryAppendAccountReputationLineToTooltip(tooltip, factionID)
	if not tooltip or not factionID or not C_Reputation.IsAccountWideReputation(factionID) then
		return;
	end

	local wrapText = false;
	GameTooltip_AddColoredLine(tooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL, ACCOUNT_WIDE_FONT_COLOR, wrapText);
end

function PrettyRepsReputationEntryMixin:ShowParagonRewardsTooltip()
	EmbeddedItemTooltip:SetOwner(self, "ANCHOR_RIGHT");
	PrettyRepsReputationParagonFrame_SetupParagonTooltip(self);
	GameTooltip_SetBottomText(EmbeddedItemTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION, GREEN_FONT_COLOR);

    -- Only add blank line and attribution if we're going to show attribution
    if not self.elementData.isAccountWide and 
       (not self.elementData.isHeader or self.elementData.isHeaderWithRep) then
		AddCharacterAttribution(EmbeddedItemTooltip, self.elementData, true);
    end

	EmbeddedItemTooltip:Show();
end

function PrettyRepsReputationEntryMixin:ShowFriendshipReputationTooltip(factionID, anchor, canClickForOptions)
    local friendshipData = self.elementData.friendshipData;
    if not friendshipData then return end

    GameTooltip:SetOwner(self, anchor);
    
    -- Get rank info from our stored data
    local rankInfo = {
        currentLevel = friendshipData.rank,
        maxLevel = friendshipData.maxRank or 0
    }
    
    if rankInfo.maxLevel > 0 then
        GameTooltip_SetTitle(GameTooltip, friendshipData.name.." ("..rankInfo.currentLevel.." / "..rankInfo.maxLevel..")", HIGHLIGHT_FONT_COLOR);
    else
        GameTooltip_SetTitle(GameTooltip, friendshipData.name, HIGHLIGHT_FONT_COLOR);
    end

    TryAppendAccountReputationLineToTooltip(GameTooltip, factionID);

    GameTooltip_AddBlankLineToTooltip(GameTooltip);
    GameTooltip:AddLine(friendshipData.text, nil, nil, nil, true);
    
    if friendshipData.nextThreshold then
        local current = friendshipData.standing - friendshipData.reactionThreshold;
        local max = friendshipData.nextThreshold - friendshipData.reactionThreshold;
        local wrapText = true;
        GameTooltip_AddHighlightLine(GameTooltip, friendshipData.reaction.." ("..current.." / "..max..")", wrapText);
    else
        local wrapText = true;
        GameTooltip_AddHighlightLine(GameTooltip, friendshipData.reaction, wrapText);
    end

    if canClickForOptions then
        GameTooltip_AddBlankLineToTooltip(GameTooltip);
        GameTooltip_AddInstructionLine(GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);
    end

    -- Only add blank line and attribution if we're going to show attribution
    if not self.elementData.isAccountWide and 
       (not self.elementData.isHeader or self.elementData.isHeaderWithRep) then
        GameTooltip_AddBlankLineToTooltip(GameTooltip);
        AddCharacterAttribution(GameTooltip, self.elementData);
    end

    GameTooltip:Show();
end

function PrettyRepsReputationEntryMixin:ShowMajorFactionRenownTooltip()
	local function AddRenownRewardsToTooltip(renownRewards)
		GameTooltip_AddHighlightLine(GameTooltip, MAJOR_FACTION_BUTTON_TOOLTIP_NEXT_REWARDS);
	
		for i, rewardInfo in ipairs(renownRewards) do
			local renownRewardString;
			local icon, name, description = RenownRewardUtil.GetRenownRewardInfo(rewardInfo, GenerateClosure(self.ShowMajorFactionRenownTooltip, self));
			if icon then
				local file, width, height = icon, 16, 16;
				local rewardTexture = CreateSimpleTextureMarkup(file, width, height);
				renownRewardString = rewardTexture .. " " .. name;
			end
			local wrapText = false;
			GameTooltip_AddNormalLine(GameTooltip, renownRewardString, wrapText);
		end
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

	local factionID = self.elementData.factionID;
	local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID);

	local tooltipTitle = majorFactionData.name;
	GameTooltip_SetTitle(GameTooltip, tooltipTitle, HIGHLIGHT_FONT_COLOR);
	TryAppendAccountReputationLineToTooltip(GameTooltip, factionID);
	GameTooltip_AddHighlightLine(GameTooltip, RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel);

	GameTooltip_AddBlankLineToTooltip(GameTooltip);


	GameTooltip_AddNormalLine(GameTooltip, MAJOR_FACTION_RENOWN_TOOLTIP_PROGRESS:format(majorFactionData.name));
	GameTooltip_AddBlankLineToTooltip(GameTooltip);

	local nextRenownRewards = C_MajorFactions.GetRenownRewardsForLevel(factionID, C_MajorFactions.GetCurrentRenownLevel(factionID) + 1);
	if #nextRenownRewards > 0 then
		AddRenownRewardsToTooltip(nextRenownRewards);
	end

	GameTooltip_AddBlankLineToTooltip(GameTooltip);
	GameTooltip_AddInstructionLine(GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);

    -- Only add blank line and attribution if we're going to show attribution
    if not self.elementData.isAccountWide and 
       (not self.elementData.isHeader or self.elementData.isHeaderWithRep) then
		GameTooltip_AddBlankLineToTooltip(GameTooltip);
		AddCharacterAttribution(GameTooltip, self.elementData);
    end

	GameTooltip:Show();
end

function PrettyRepsReputationEntryMixin:ShowStandardTooltip()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_SetTitle(GameTooltip, self.elementData.name);
	TryAppendAccountReputationLineToTooltip(GameTooltip, self.elementData.factionID);
	GameTooltip_AddBlankLineToTooltip(GameTooltip);
	GameTooltip_AddInstructionLine(GameTooltip, REPUTATION_BUTTON_TOOLTIP_CLICK_INSTRUCTION);

    -- Only add blank line and attribution if we're going to show attribution
    if not self.elementData.isAccountWide and 
       (not self.elementData.isHeader or self.elementData.isHeaderWithRep) and
       self.elementData.character then
		GameTooltip_AddBlankLineToTooltip(GameTooltip);
		AddCharacterAttribution(GameTooltip, self.elementData);
    end

	GameTooltip:Show();
end

function PrettyRepsReputationEntryMixin:OnLeave()
	self.Content.ReputationBar:TryShowReputationStandingText();

	self:RefreshHighlightVisuals();

	self:HideTooltip();
end

function PrettyRepsReputationEntryMixin:HideTooltip()
	-- Hide the reputation progress tooltip or the paragon progress tooltip (whichever is up)
	if GameTooltip:GetOwner() == self then
		GameTooltip_Hide();
	elseif EmbeddedItemTooltip:GetOwner() == self then
		EmbeddedItemTooltip_Hide(EmbeddedItemTooltip);
	end
end

function PrettyRepsReputationEntryMixin:IsSelected()
	return ReputationService:GetSelectedFaction() == self.factionIndex;
end

function PrettyRepsReputationEntryMixin:RefreshHighlightVisuals()
	self:RefreshAccountWideIcon();
	self:RefreshBackgroundHighlight();
end

function PrettyRepsReputationEntryMixin:RefreshAccountWideIcon()
	local showAccountWideIcon = C_Reputation.IsAccountWideReputation(self.factionID) and (self:IsSelected() or self:IsMouseOver());
	self.Content.AccountWideIcon:SetShown(showAccountWideIcon);
end

function PrettyRepsReputationEntryMixin:RefreshBackgroundHighlight()
	self:RefreshBackgroundHighlightColor();
	self:RefreshBackgroundHighlightOpacity();
end

function PrettyRepsReputationEntryMixin:RefreshBackgroundHighlightColor()
    local color = self:IsAtWar() and FACTION_AT_WAR_COLOR or WHITE_FONT_COLOR;
    for _, region in ipairs(self.Content.BackgroundHighlight.TextureRegions) do
        region:SetVertexColor(color:GetRGB());
    end
end

function PrettyRepsReputationEntryMixin:RefreshBackgroundHighlightOpacity()
    local isAtWar = self:IsAtWar();
    local isHighlighted = self:IsSelected() or self:IsMouseOver();
    
    -- Set base alpha based on at-war state
    local baseAlpha = isAtWar and 0.4 or 0;
    -- Increase alpha when highlighted
    local alpha = isHighlighted and (isAtWar and 0.55 or 0.1) or baseAlpha;
    
    self.Content.BackgroundHighlight:SetAlpha(alpha);
end

function PrettyRepsReputationEntryMixin:IsAtWar()
	return PrettyReps.ReputationService:IsFactionAtWar(self.factionID);
end

PrettyRepsReputationEntryAccountWideIconMixin = {};

function PrettyRepsReputationEntryAccountWideIconMixin:OnEnter()
	if not self:IsShown() then
		return;
	end

	self:ShowTooltip();
end

function PrettyRepsReputationEntryAccountWideIconMixin:ShowTooltip()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_AddNormalLine(GameTooltip, REPUTATION_TOOLTIP_ACCOUNT_WIDE_LABEL);
	GameTooltip:Show();
end

local function NormalizeBarValues(minValue, maxValue, currentValue)
	maxValue = maxValue - minValue;
	currentValue = currentValue - minValue;
	minValue = 0;

	return minValue, maxValue, currentValue;
end

local function InitializeBarForStandardReputation(factionData, reputationBar)
	local isCapped = factionData.reaction == MAX_REPUTATION_REACTION;
	local minValue, maxValue, currentValue;
	if isCapped then
		-- Max rank, make it look like a full bar
		minValue, maxValue, currentValue = 0, 1, 1;
	else
		minValue, maxValue, currentValue = factionData.currentReactionThreshold, factionData.nextReactionThreshold, factionData.currentStanding;
	end
	minValue, maxValue, currentValue = NormalizeBarValues(minValue, maxValue, currentValue);
	reputationBar:UpdateBarValues(minValue, maxValue, currentValue);
	
	local progressText = not isCapped and HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(REPUTATION_PROGRESS_FORMAT:format(BreakUpLargeNumbers(currentValue), BreakUpLargeNumbers(maxValue))) or nil; 
	reputationBar:UpdateBarProgressText(progressText);
	local gender = UnitSex("player");
	local reputationStandingtext = GetText("FACTION_STANDING_LABEL" .. factionData.reaction, gender);
	reputationBar:UpdateReputationStandingText(reputationStandingtext);
	reputationBar:TryShowReputationStandingText();

	local colorIndex = factionData.reaction;
	reputationBar:UpdateBarColor(FACTION_BAR_COLORS[colorIndex]);
end

local function InitializeBarForFriendship(factionData, reputationBar)
    local minValue, maxValue, currentValue;
    local friendshipData = factionData.friendshipData;
    local isMaxRank = not friendshipData.nextThreshold;
    
    if isMaxRank then
        -- Max rank, make it look like a full bar
        minValue, maxValue, currentValue = 0, 1, 1;
    else
        minValue = friendshipData.reactionThreshold;
        maxValue = friendshipData.nextThreshold;
        currentValue = friendshipData.standing;
    end
    
    minValue, maxValue, currentValue = NormalizeBarValues(minValue, maxValue, currentValue);
    reputationBar:UpdateBarValues(minValue, maxValue, currentValue);

    local progressText = not isMaxRank and HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(REPUTATION_PROGRESS_FORMAT:format(BreakUpLargeNumbers(currentValue), BreakUpLargeNumbers(maxValue))) or nil;
    reputationBar:UpdateBarProgressText(progressText)
    reputationBar:UpdateReputationStandingText(friendshipData.reaction);
    reputationBar:TryShowReputationStandingText();

    local friendshipColorIndex = 5; -- Always color friendships green
    reputationBar:UpdateBarColor(FACTION_BAR_COLORS[friendshipColorIndex]);
end

local function InitializeBarForMajorFaction(factionData, reputationBar)
	local minValue, maxValue, currentValue;
	local majorFactionData = C_MajorFactions.GetMajorFactionData(factionData.factionID);
	local isMaxRenown = C_MajorFactions.HasMaximumRenown(factionData.factionID);
	if isMaxRenown then
		-- Max renown, make it look like a full bar
		minValue, maxValue, currentValue = 0, 1, 1;
	else
		minValue, maxValue, currentValue = 0, majorFactionData.renownLevelThreshold, majorFactionData.renownReputationEarned;
	end
	minValue, maxValue, currentValue = NormalizeBarValues(minValue, maxValue, currentValue);
	reputationBar:UpdateBarValues(minValue, maxValue, currentValue);

	local progressText = not isMaxRenown and HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(REPUTATION_PROGRESS_FORMAT:format(BreakUpLargeNumbers(currentValue), BreakUpLargeNumbers(maxValue))) or nil;
	reputationBar:UpdateBarProgressText(progressText);
	reputationBar:UpdateReputationStandingText(RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel);
	reputationBar:TryShowReputationStandingText();

	reputationBar:UpdateBarColor(BLUE_FONT_COLOR);
end

local BarInitializerByReputationType = {
	[ReputationType.Standard] = InitializeBarForStandardReputation,
	[ReputationType.Friendship] = InitializeBarForFriendship,
	[ReputationType.MajorFaction] = InitializeBarForMajorFaction,
};

function PrettyRepsReputationEntryMixin:InitializeReputationBarForReputationType()
	local BarInitializer = BarInitializerByReputationType[self.reputationType];

	if not BarInitializer then
		return;
	end

	BarInitializer(self.elementData, self.Content.ReputationBar);

	self.Content.ReputationBar.BonusIcon:SetShown(self.elementData.hasBonusRepGain);
end

PrettyRepsReputationSubHeaderMixin = CreateFromMixins(PrettyRepsReputationEntryMixin);

function PrettyRepsReputationSubHeaderMixin:Initialize(elementData)
    PrettyRepsReputationEntryMixin.Initialize(self, elementData)

    self.Content.Name:ClearAllPoints()
    self.Content.Name:SetPoint("LEFT", self.ToggleCollapseButton, "RIGHT", 4, 0)
    self.Content.Name:SetPoint("RIGHT", self.Content.ReputationBar, "LEFT", -10, 0)

    -- Only show reputation bar if this header has rep and has been encountered
    self.Content.ReputationBar:SetShown(elementData.hasBeenEncountered and elementData.isHeaderWithRep)
    self.Content.NotEncounteredText:SetShown(not elementData.hasBeenEncountered and elementData.isHeaderWithRep)
    
    -- Always show background highlight and enable mouse for all headers
    self.Content.BackgroundHighlight:SetShown(true)
    self:EnableMouse(true)

    -- Show completion stats in subheader if enabled and stats exist
    if elementData.isHeader and elementData.completionStats 
        and PrettyReps.ReputationService:IsDisplayGroupTotals() then
        local stats = elementData.completionStats
        local displayText
        if PrettyReps.OptionsManager:GetOption("displayTotalsAsPercentage") then
            -- Format percentage to only show decimal if needed
            local percentage = stats.percentage
            local percentageText = percentage % 1 == 0 and 
                string.format("%d%%", percentage) or 
                string.format("%.1f%%", percentage)
            
            displayText = string.format("%s (%s)", 
                elementData.name,
                percentageText
            )
        else
            displayText = string.format("%s (%d/%d)", 
                elementData.name,
                stats.completed,
                stats.total
            )
        end
        self.Content.Name:SetText(displayText)
    else
        self.Content.Name:SetText(self.elementData.name or "")
    end

    self.ToggleCollapseButton:RefreshIcon()
end

function PrettyRepsReputationSubHeaderMixin:IsCollapsed()
	return self.elementData.isCollapsed;
end

function PrettyRepsReputationSubHeaderMixin:ToggleCollapsed()
	if self:IsCollapsed() then
		ReputationService:ExpandFactionHeader(self.factionIndex);
	else
		ReputationService:CollapseFactionHeader(self.factionIndex);
	end
end

PrettyRepsReputationSubHeaderToggleCollapseButtonMixin = {};

function PrettyRepsReputationSubHeaderToggleCollapseButtonMixin:GetHeader()
	return self:GetParent();
end

function PrettyRepsReputationSubHeaderToggleCollapseButtonMixin:RefreshIcon()
	local header = self:GetHeader();
	self:GetNormalTexture():SetAtlas(header:IsCollapsed() and "campaign_headericon_closed" or "campaign_headericon_open", TextureKitConstants.UseAtlasSize);
	self:GetPushedTexture():SetAtlas(header:IsCollapsed() and "campaign_headericon_closedpressed" or "campaign_headericon_openpressed", TextureKitConstants.UseAtlasSize);
end

function PrettyRepsReputationSubHeaderToggleCollapseButtonMixin:OnClick()
	self:GetHeader():ToggleCollapsed();
end

PrettyRepsReputationBarMixin = {};

function PrettyRepsReputationBarMixin:UpdateBarValues(minValue, maxValue, currentValue)
	self:SetMinMaxValues(minValue, maxValue);
	self:SetValue(currentValue);
end

function PrettyRepsReputationBarMixin:UpdateBarColor(color)
	self:SetStatusBarColor(color:GetRGB());
end

function PrettyRepsReputationBarMixin:UpdateBarProgressText(barProgressText)
	self.barProgressText = barProgressText;
end

function PrettyRepsReputationBarMixin:UpdateReputationStandingText(reputationStandingText)
	self.reputationStandingText = reputationStandingText;
end

function PrettyRepsReputationBarMixin:TryShowBarProgressText()
	if not self.barProgressText then
		return;
	end

	self.BarText:SetText(self.barProgressText);
end

function PrettyRepsReputationBarMixin:TryShowReputationStandingText()
	if not self.reputationStandingText then
		return;
	end

	self.BarText:SetText(self.reputationStandingText);
end

PrettyRepsReputationBarBonusIconMixin = {};

function PrettyRepsReputationBarBonusIconMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_SetTitle(GameTooltip, BONUS_REPUTATION_TITLE, HIGHLIGHT_FONT_COLOR);
	local wrapText = true;
	GameTooltip_AddNormalLine(GameTooltip, BONUS_REPUTATION_TOOLTIP, wrapText);
	GameTooltip:Show();
end

function PrettyRepsReputationBarBonusIconMixin:OnLeave()
	GameTooltip_Hide();
end

PrettyRepsReputationBarParagonIconMixin = {};

function PrettyRepsReputationBarParagonIconMixin:OnUpdate()
	if not self.Glow:IsShown() then
		return;
	end
		
	local alpha;
	local time = GetTime();
	local value = time - floor(time);
	local direction = mod(floor(time), 2);
	if direction == 0 then
		alpha = value;
	else
		alpha = 1 - value;
	end
	self.Glow:SetAlpha(alpha);
end

function PrettyRepsReputationParagonFrame_SetupParagonTooltip(frame)
	local factionID = frame.factionID;
	EmbeddedItemTooltip.factionID = frame.factionID;

	local factionStandingtext;
	local factionData = ReputationService:GetFactionDataByID(factionID);
	local reputationInfo = C_GossipInfo.GetFriendshipReputation(factionID);
	if reputationInfo and reputationInfo.friendshipFactionID > 0 then
		factionStandingtext = reputationInfo.reaction;
	elseif ReputationService:IsMajorFaction(factionID) then
		factionStandingtext = MAJOR_FACTION_MAX_RENOWN_REACHED;
	else
		local gender = UnitSex("player");
		factionStandingtext = GetText("FACTION_STANDING_LABEL"..factionData.reaction, gender);
	end
	local currentValue, threshold, rewardQuestID, hasRewardPending, tooLowLevelForParagon = ReputationService:GetFactionParagonInfo(factionID);

	if ( tooLowLevelForParagon ) then
		GameTooltip_SetTitle(EmbeddedItemTooltip, PARAGON_REPUTATION_TOOLTIP_TEXT_LOW_LEVEL, NORMAL_FONT_COLOR);
	else
		GameTooltip_SetTitle(EmbeddedItemTooltip, factionStandingtext, HIGHLIGHT_FONT_COLOR);

		TryAppendAccountReputationLineToTooltip(EmbeddedItemTooltip, factionID);
		GameTooltip_AddBlankLineToTooltip(EmbeddedItemTooltip);

		local description = PARAGON_REPUTATION_TOOLTIP_TEXT:format(factionData.name);
		if ( hasRewardPending ) then
			local questIndex = C_QuestLog.GetLogIndexForQuestID(rewardQuestID);
			local text = GetQuestLogCompletionText(questIndex);
			if ( text and text ~= "" ) then
				description = text;
			end
		end
		GameTooltip_AddNormalLine(EmbeddedItemTooltip, description);
		if ( not hasRewardPending ) then
			local value = mod(currentValue, threshold);
			-- show overflow if reward is pending
			if ( hasRewardPending ) then
				value = value + threshold;
			end
			GameTooltip_ShowProgressBar(EmbeddedItemTooltip, 0, threshold, value, REPUTATION_PROGRESS_FORMAT:format(value, threshold));
		end
		GameTooltip_AddQuestRewardsToTooltip(EmbeddedItemTooltip, rewardQuestID);
	end
end

function PrettyRepsReputationParagonWatchBar_OnEnter(self)
	if not ReputationService:IsFactionParagon(self.factionID) then
		return;
	end

	self.UpdateTooltip = PrettyRepsReputationParagonFrame_SetupParagonTooltip;
	GameTooltip_SetDefaultAnchor(EmbeddedItemTooltip, self);
	PrettyRepsReputationParagonFrame_SetupParagonTooltip(self);
	EmbeddedItemTooltip:Show();
end

function PrettyRepsReputationParagonWatchBar_OnLeave(self)
	EmbeddedItemTooltip_Hide(EmbeddedItemTooltip);
	self.UpdateTooltip = nil;
end

PrettyRepsReputationDetailFrameMixin = CreateFromMixins(CallbackRegistryMixin);

function PrettyRepsReputationDetailFrameMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);
	self:AddStaticEventMethod(EventRegistry, "ReputationFrame.NewFactionSelected", self.Refresh);
end

function PrettyRepsReputationDetailFrameMixin:OnShow()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
end

function PrettyRepsReputationDetailFrameMixin:OnHide()
	self:ClearSelectedFaction();
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
end

function PrettyRepsReputationDetailFrameMixin:UpdateCheckboxStates(factionData)
    if not factionData then return end

    -- For guild factions, disable all checkboxes except watch
    if factionData.isGuildFaction then
        -- Disable At War checkbox
        self.StateContainer.CheckboxState.AtWarCheckbox:SetEnabled(false)
        self.StateContainer.CheckboxState.AtWarCheckbox:SetChecked(false)
        self.StateContainer.CheckboxState.AtWarCheckbox.Label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)

        -- Disable Inactive checkbox
        self.StateContainer.CheckboxState.MakeInactiveCheckbox:SetEnabled(false)        
        self.StateContainer.CheckboxState.MakeInactiveCheckbox:SetChecked(false)
        self.StateContainer.CheckboxState.MakeInactiveCheckbox.Label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)

        -- Enable Watch checkbox
        local watchCheckbox = self.StateContainer.CheckboxState.WatchFactionCheckbox
        watchCheckbox:SetEnabled(true)
        watchCheckbox:SetChecked(PrettyReps.ReputationService:IsFactionWatched(factionData.factionID))
        watchCheckbox.Label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

        -- Disable Favorite checkbox
        local favoriteCheckbox = self.StateContainer.CheckboxState.FavoriteCheckbox
        favoriteCheckbox:SetEnabled(false)
        favoriteCheckbox:SetChecked(false)
        favoriteCheckbox.Label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
        
        return
    end

    -- Handle At War checkbox
    local canToggleAtWar = not factionData.isHeader and 
                          factionData.canToggleAtWar and 
                          PrettyReps.ReputationService:HasCurrentCharacterEncounteredFaction(factionData.factionID)
    local atWar = PrettyReps.ReputationService:IsFactionAtWar(factionData.factionID)
    
    self.StateContainer.CheckboxState.AtWarCheckbox:SetEnabled(canToggleAtWar)
    self.StateContainer.CheckboxState.AtWarCheckbox:SetChecked(atWar)
    local atWarTextColor = canToggleAtWar and RED_FONT_COLOR or GRAY_FONT_COLOR
    self.StateContainer.CheckboxState.AtWarCheckbox.Label:SetTextColor(atWarTextColor.r, atWarTextColor.g, atWarTextColor.b)

    -- Handle Inactive checkbox
    local inactiveCheckbox = self.StateContainer.CheckboxState.MakeInactiveCheckbox
    inactiveCheckbox:SetEnabled(true)        
    inactiveCheckbox:SetChecked(PrettyReps.ReputationService:IsFactionInactive(factionData.factionID))
    inactiveCheckbox.Label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

    -- Handle Watch checkbox
    local watchCheckbox = self.StateContainer.CheckboxState.WatchFactionCheckbox
    watchCheckbox:SetEnabled(not factionData.isHeader)
    watchCheckbox:SetChecked(PrettyReps.ReputationService:IsFactionWatched(factionData.factionID))
    if watchCheckbox:IsEnabled() then
        watchCheckbox.Label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    else
        watchCheckbox.Label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    end

    -- Handle Favorite checkbox
    local favoriteCheckbox = self.StateContainer.CheckboxState.FavoriteCheckbox
    favoriteCheckbox:SetEnabled(true)
    favoriteCheckbox:SetChecked(PrettyReps.ReputationService:IsFactionFavorite(factionData.factionID))
    favoriteCheckbox.Label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

function PrettyRepsReputationDetailFrameMixin:UpdateStateVisibility(factionData)
    if not self.StateContainer then return end
    
    -- For guild factions, always show checkboxes but hide warning
    if factionData and factionData.isGuildFaction then
        self:UpdateCheckboxStates(factionData)
        self.StateContainer.NotEncounteredWarning:Hide()
        return
    end
    
    local hasEncountered = false
    local hasBeenEncounteredByAnyCharacter = false
    if factionData then
        hasEncountered = PrettyReps.ReputationService:HasCurrentCharacterEncounteredFaction(factionData.factionID)
        
        -- Check account data for any character encounters
        local accountFaction = PrettyReps.DataManager:GetFactionById(
            factionData.factionID, 
            PrettyRepsDB.AccountData
        )
        hasBeenEncounteredByAnyCharacter = accountFaction and accountFaction.hasBeenEncountered
    end
    
    self:UpdateCheckboxStates(factionData)
    
    -- Show warning text only if this is a reputation-bearing faction that hasn't been encountered
    local shouldShowWarning = not hasEncountered and (not factionData.isHeader or factionData.isHeaderWithRep)
    self.StateContainer.NotEncounteredWarning:SetShown(shouldShowWarning)
    
    if shouldShowWarning then
        local warningText = hasBeenEncounteredByAnyCharacter and 
            "This character has not encountered this faction." or
            "No characters have encountered this faction."
        self.StateContainer.NotEncounteredWarning.Text:SetText(warningText)
    end
end

function PrettyRepsReputationDetailFrameMixin:Refresh()
    local selectedFactionIndex = PrettyReps.ReputationService:GetSelectedFaction();
    local factionData = PrettyReps.ReputationService:GetFactionDataByIndex(selectedFactionIndex);
    if not factionData or (factionData.factionID <= 0 and not factionData.isGuildFaction) then
        self:Hide();
        return;
    end

    self.Title:SetText(factionData.name);
    self.Description:SetText(factionData.description or "");
    
    -- Update state container visibility
    self:UpdateStateVisibility(factionData);
    
    -- Update renown button - only for headers with rep that are major factions
    local isMajorFaction = PrettyReps.ReputationService:IsMajorFaction(factionData.factionID);
    local baseHeight = isMajorFaction and 253 or 228;
    
    -- Only add extra height if we're showing the warning text and it's not a guild faction
    local characterHasEncountered = PrettyReps.ReputationService:HasCurrentCharacterEncounteredFaction(factionData.factionID);
    local shouldShowWarning = not factionData.isGuildFaction and 
                             not characterHasEncountered and 
                             (not factionData.isHeader or factionData.isHeaderWithRep);
    local finalHeight = shouldShowWarning and (baseHeight + 40) or baseHeight;

    self:SetHeight(finalHeight);
    self.ViewRenownButton:Refresh();

    self:Show();
end

function PrettyRepsReputationDetailFrameMixin:ClearSelectedFaction()
	ReputationService:SetSelectedFaction(0);
	EventRegistry:TriggerEvent("ReputationFrame.NewFactionSelected");
end

PrettyRepsReputationDetailViewRenownButtonMixin = {};

function PrettyRepsReputationDetailViewRenownButtonMixin:Refresh()
	local factionData = ReputationService:GetFactionDataByIndex(ReputationService:GetSelectedFaction());
	self.factionID = factionData and factionData.factionID or nil;
	if not self.factionID or not ReputationService:IsMajorFaction(self.factionID) then
		self:Disable();
		self:Hide();
		return;
	end

	local majorFactionData = C_MajorFactions.GetMajorFactionData(self.factionID);

	self.disabledTooltip = majorFactionData.unlockDescription;
	self:SetEnabled(majorFactionData.isUnlocked);
	self:Show();
end

function PrettyRepsReputationDetailViewRenownButtonMixin:OnClick()
	MajorFactions_LoadUI();

	if MajorFactionRenownFrame:IsShown() and MajorFactionRenownFrame:GetCurrentFactionID() == self.factionID then
		ToggleMajorFactionRenown();
	else
		HideUIPanel(MajorFactionRenownFrame);
		EventRegistry:TriggerEvent("MajorFactionRenownMixin.MajorFactionRenownRequest", self.factionID);
		ShowUIPanel(MajorFactionRenownFrame);
	end
end

PrettyRepsReputationDetailAtWarCheckboxMixin = {};

function PrettyRepsReputationDetailAtWarCheckboxMixin:OnClick()    
	local selectedFactionIndex = ReputationService:GetSelectedFaction()
    local selectedFaction = ReputationService:GetFactionDataByIndex(selectedFactionIndex)
    local selectedFactionID = selectedFaction and selectedFaction.factionID

    if not selectedFaction then return end
    
    PrettyReps.ReputationService:SetFactionAtWar(selectedFaction.factionID, self:GetChecked())
    
    -- Play appropriate sound
    local clickSound = self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
        or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
    PlaySound(clickSound)

	if PrettyRepsReputationFrame then
        PrettyRepsReputationFrame:Update()
    end
end

function PrettyRepsReputationDetailAtWarCheckboxMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	local wrapText = true;
	GameTooltip_AddNormalLine(GameTooltip, REPUTATION_AT_WAR_DESCRIPTION, wrapText);
	GameTooltip:Show();
end

function PrettyRepsReputationDetailAtWarCheckboxMixin:OnLeave()
	GameTooltip_Hide();
end

PrettyRepsReputationDetailInactiveCheckboxMixin = {};

function PrettyRepsReputationDetailInactiveCheckboxMixin:OnClick()
    local selectedFactionIndex = PrettyReps.ReputationService:GetSelectedFaction()
    local selectedFaction = PrettyReps.ReputationService:GetFactionDataByIndex(selectedFactionIndex)
    if not selectedFaction then return end

    -- Set the inactive state using our service (account-wide)
    PrettyReps.ReputationService:SetFactionInactive(selectedFaction.factionID, self:GetChecked())

    -- Play appropriate sound
    local clickSound = self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
        or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
    PlaySound(clickSound)
    
    -- Update the UI
    if PrettyRepsReputationFrame then
        PrettyRepsReputationFrame:Update()
    end
end

function PrettyRepsReputationDetailInactiveCheckboxMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	local wrapText = true;
	GameTooltip_AddNormalLine(GameTooltip, REPUTATION_MOVE_TO_INACTIVE, wrapText);
	GameTooltip:Show();
end

function PrettyRepsReputationDetailInactiveCheckboxMixin:OnLeave()
	GameTooltip_Hide();
end

PrettyRepsReputationDetailWatchFactionCheckboxMixin = {};

function PrettyRepsReputationDetailWatchFactionCheckboxMixin:OnClick()
    local selectedFactionIndex = ReputationService:GetSelectedFaction()
    local selectedFaction = ReputationService:GetFactionDataByIndex(selectedFactionIndex)
    local selectedFactionID = selectedFaction and selectedFaction.factionID

	ReputationService:SetFactionWatched(self:GetChecked() and selectedFactionID or 0)

	StatusTrackingBarManager:UpdateBarsShown()
	PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
		or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
end

function PrettyRepsReputationDetailWatchFactionCheckboxMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    local wrapText = true
    GameTooltip_AddNormalLine(GameTooltip, REPUTATION_SHOW_AS_XP, wrapText)
    GameTooltip:Show()
end

function PrettyRepsReputationDetailWatchFactionCheckboxMixin:OnLeave()
    GameTooltip_Hide()
end

PrettyRepsReputationDetailFavoriteCheckboxMixin = {};

function PrettyRepsReputationDetailFavoriteCheckboxMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    local wrapText = true;
    GameTooltip_AddNormalLine(GameTooltip, "Moves the reputation bar to the top of your list under the favourites heading. Useful for reputations you are most interested in tracking.", wrapText);
    GameTooltip:Show();
end

function PrettyRepsReputationDetailFavoriteCheckboxMixin:OnLeave()
    GameTooltip_Hide();
end

function PrettyRepsReputationDetailFavoriteCheckboxMixin:OnClick()
    local selectedFactionIndex = PrettyReps.ReputationService:GetSelectedFaction()
    local selectedFaction = PrettyReps.ReputationService:GetFactionDataByIndex(selectedFactionIndex)
    if not selectedFaction then return end

    -- Set the favorite state
    PrettyReps.ReputationService:SetFactionFavorite(selectedFaction.factionID, self:GetChecked())

    -- Play appropriate sound
    local clickSound = self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
        or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
    PlaySound(clickSound)
    
    -- Update the UI
    if PrettyRepsReputationFrame then
        PrettyRepsReputationFrame:Update()
    end
end

PrettyRepsSettingsFrameMixin = {};

function PrettyRepsSettingsFrameMixin:OnLoad()
    ButtonFrameTemplate_HidePortrait(self);
    self:SetTitle("PrettyReps Settings");

    self.TopTileStreaks:Hide();
    self.Inset:ClearAllPoints();
    self.Inset:SetPoint("TOPLEFT", self, "TOPLEFT", 11, -28);
    self.Inset:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -6, 10);

    -- Set up checkbox handlers
    local layoutSection = self.ScrollFrame.OptionsContainer.LayoutSection
    local visibilitySection = self.ScrollFrame.OptionsContainer.VisibilitySection

    local groupUnobtainableCheckbox = layoutSection.GroupUnobtainableCheckbox;
    local hideUnobtainableCheckbox = layoutSection.HideUnobtainableCheckbox;

    -- Set initial enabled state of hide checkbox
    hideUnobtainableCheckbox:SetEnabled(false) -- Start disabled until parent is checked

    -- Group Unobtainable checkbox handler
    groupUnobtainableCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetGroupUnobtainable(isChecked)
        
        -- Enable/disable hide checkbox based on group checkbox state
        hideUnobtainableCheckbox:SetEnabled(isChecked)
        
        -- Update text colors
        if isChecked then
            hideUnobtainableCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
            hideUnobtainableCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
        else
            hideUnobtainableCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
            hideUnobtainableCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
        end
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    -- Hide Unobtainable checkbox handler
    hideUnobtainableCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetHideUnobtainable(isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    local displayGroupTotalsCheckbox = layoutSection.DisplayGroupTotalsCheckbox;
    local displayTotalsAsPercentageCheckbox = layoutSection.DisplayTotalsAsPercentageCheckbox;

    -- Set initial enabled state of percentage checkbox
    displayTotalsAsPercentageCheckbox:SetEnabled(false) -- Start disabled until parent is checked
    
    -- Display Group Totals checkbox handler
    displayGroupTotalsCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetDisplayGroupTotals(isChecked)
        
        -- Enable/disable percentage checkbox based on group totals checkbox state
        displayTotalsAsPercentageCheckbox:SetEnabled(isChecked)
        
        -- Update text colors
        if isChecked then
            displayTotalsAsPercentageCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
            displayTotalsAsPercentageCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
        else
            displayTotalsAsPercentageCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
            displayTotalsAsPercentageCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
        end
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    local hideInactiveCheckbox = layoutSection.HideInactiveCheckbox;
    
    -- Hide Inactive checkbox handler
    hideInactiveCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetHideInactiveGroup(isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    local showOppositeFactionCheckbox = visibilitySection.ShowOppositeFactionCheckbox;

    -- Show Opposite Faction checkbox handler
    showOppositeFactionCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.OptionsManager:SetOption("showOppositeFaction", isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    local hideParagonIconsCheckbox = layoutSection.HideParagonIconsCheckbox;
    local showParagonRewardsCheckbox = layoutSection.ShowParagonRewardsCheckbox;

    -- Set initial enabled state of child checkbox
    showParagonRewardsCheckbox:SetEnabled(false) -- Start disabled until parent is checked

    -- Hide Paragon Icons checkbox handler
    hideParagonIconsCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetHideParagonIcons(isChecked)
        
        -- Enable/disable child checkbox based on parent checkbox state
        showParagonRewardsCheckbox:SetEnabled(isChecked)
        
        -- Update text colors
        if isChecked then
            showParagonRewardsCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
            showParagonRewardsCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
        else
            showParagonRewardsCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
            showParagonRewardsCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
        end
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    -- Show Paragon Rewards checkbox handler
    showParagonRewardsCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetShowParagonRewards(isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    -- Add handler for Display Totals As Percentage checkbox
    local displayTotalsAsPercentageCheckbox = layoutSection.DisplayTotalsAsPercentageCheckbox;
    
    displayTotalsAsPercentageCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.OptionsManager:SetOption("displayTotalsAsPercentage", isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    -- Register for data initialization
    PrettyReps.Events:RegisterCallback(PrettyReps.Events.Names.DataInitialized, 
        function()
            if self:IsVisible() then
                self:UpdateCheckboxStates()
            end
        end,
        self
    )

    -- In the PrettyRepsSettingsFrameMixin:OnLoad function, update the guild reputation checkbox handler
    local hideGuildReputationCheckbox = layoutSection.HideGuildReputationCheckbox;

    hideGuildReputationCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.ReputationService:SetHideGuildReputation(isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    -- Set gold color for all checkbox labels
    local goldColor = {r = 1, g = 0.82, b = 0}
    local checkboxes = {
        layoutSection.GroupUnobtainableCheckbox,
        layoutSection.HideUnobtainableCheckbox,
        layoutSection.DisplayGroupTotalsCheckbox,
        layoutSection.HideInactiveCheckbox,
        visibilitySection.ShowOppositeFactionCheckbox,
        layoutSection.HideParagonIconsCheckbox,
        layoutSection.ShowParagonRewardsCheckbox,
        layoutSection.HideGuildReputationCheckbox,
        layoutSection.DisplayTotalsAsPercentageCheckbox,
    }
    
    for _, checkbox in ipairs(checkboxes) do
        checkbox.Text:SetTextColor(goldColor.r, goldColor.g, goldColor.b)
    end

    local showNotEncounteredCheckbox = visibilitySection.ShowNotEncounteredCheckbox;

    showNotEncounteredCheckbox:SetScript("OnClick", function(checkbox)
        local isChecked = checkbox:GetChecked()
        PrettyReps.OptionsManager:SetOption("showNotEncountered", isChecked)
        
        -- Update the UI
        if PrettyRepsReputationFrame then
            PrettyRepsReputationFrame:Update()
        end
        PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON 
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end)

    -- Add reset settings button handler
    local resetSettingsButton = self.ScrollFrame.OptionsContainer.ActionsSection.ResetSettingsButton;
    resetSettingsButton:SetScript("OnClick", function()
        -- Show confirmation dialog
        StaticPopupDialogs["PRETTYREPS_RESET_SETTINGS"] = {
            text = "Are you sure you want to reset all PrettyReps settings to default values?",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                -- Reset all options
                PrettyReps.OptionsManager:ResetAll()
                
                -- Update checkbox states
                self:UpdateCheckboxStates()
                
                -- Update the main reputation frame
                if PrettyRepsReputationFrame then
                    PrettyRepsReputationFrame:Update()
                end
                
                -- Play sound
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("PRETTYREPS_RESET_SETTINGS")
    end)

    -- Add reset settings button handler
    local factoryResetButton = self.ScrollFrame.OptionsContainer.FactoryResetSection.FactoryResetButton;
    
    -- Store factory reset warning text
    local FACTORY_RESET_WARNING = "WARNING: This will perform a factory reset of PrettyReps."
        .. "\n\nThis includes:"
        .. "\n- All reputation data"
        .. "\n- All addon settings"
        .. "\n- All favorite factions"
        .. "\n- All inactive factions"
        .. "\n\nYou will need to login to all of your characters again."
    
    factoryResetButton:SetScript("OnClick", function()
        -- Show confirmation dialog with extra warning
        StaticPopupDialogs["PRETTYREPS_WIPE_DATA"] = {
            text = FACTORY_RESET_WARNING .. "\n\nAre you sure?",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                -- Perform factory reset and update UI
                PrettyReps.DataManager:FactoryReset()
                self:UpdateCheckboxStates()
                if PrettyRepsReputationFrame then
                    PrettyRepsReputationFrame:Update()
                end
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
            showAlert = true,  -- Shows the dialog with a warning ! icon
        }
        StaticPopup_Show("PRETTYREPS_WIPE_DATA")
    end)

    -- Add tooltip
    factoryResetButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Factory Reset")
        GameTooltip:AddLine(FACTORY_RESET_WARNING, 1, 0, 0, true)
        GameTooltip:Show()
    end)

    factoryResetButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Add homepage button handler
    local homepageButton = self.ScrollFrame.OptionsContainer.ActionsSection.HomepageButton;
    local HOMEPAGE_URL = "https://www.curseforge.com/wow/addons/pretty-reps"
    
    homepageButton:SetScript("OnClick", function()
        -- Show dialog with copyable URL
        StaticPopupDialogs["PRETTYREPS_HOMEPAGE"] = {
            text = "Press CTRL+C to copy the link",
            button1 = "Close",
            hasEditBox = true,
            editBoxWidth = 250,
            OnShow = function(self)
                self.editBox:SetText(HOMEPAGE_URL)
                self.editBox:SetFocus()
                self.editBox:HighlightText()
            end,
            OnHide = function(self)
                self.editBox:SetText("")
            end,
            EditBoxOnEscapePressed = function(self)
                self:GetParent():Hide()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
        StaticPopup_Show("PRETTYREPS_HOMEPAGE")
    end)

    -- Add tooltip
    homepageButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("PrettyReps Addon Homepage")
        GameTooltip:AddLine("Click to get the URL for the PrettyReps addon homepage.", 1, 1, 1, true)
        GameTooltip:Show()
    end)

    homepageButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Add tooltips for action buttons
    local expandAllButton = self.ScrollFrame.OptionsContainer.ActionsSection.ExpandAllButton;
    expandAllButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Expand All")
        GameTooltip:AddLine("Expand all faction headers and subheaders.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    expandAllButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local collapseAllButton = self.ScrollFrame.OptionsContainer.ActionsSection.CollapseAllButton;
    collapseAllButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Collapse All")
        GameTooltip:AddLine("Collapse all faction headers and subheaders.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    collapseAllButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    local resetSettingsButton = self.ScrollFrame.OptionsContainer.ActionsSection.ResetSettingsButton;
    resetSettingsButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Reset Settings")
        GameTooltip:AddLine("Reset the above settings to their default values.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    resetSettingsButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
end

function PrettyRepsSettingsFrameMixin:UpdateCheckboxStates()
    -- Only update if OptionsManager is initialized
    if not PrettyRepsDB or not PrettyRepsDB.Options then return end
    
    local layoutSection = self.ScrollFrame.OptionsContainer.LayoutSection
    local visibilitySection = self.ScrollFrame.OptionsContainer.VisibilitySection

    local groupUnobtainableCheckbox = layoutSection.GroupUnobtainableCheckbox;
    local hideUnobtainableCheckbox = layoutSection.HideUnobtainableCheckbox;
    
    if groupUnobtainableCheckbox then
        local groupEnabled = PrettyReps.ReputationService:IsGroupUnobtainable()
        groupUnobtainableCheckbox:SetChecked(groupEnabled)
        
        -- Update hide checkbox state and enabled status
        if hideUnobtainableCheckbox then
            hideUnobtainableCheckbox:SetEnabled(groupEnabled)
            hideUnobtainableCheckbox:SetChecked(PrettyReps.ReputationService:IsHideUnobtainable())
            
            -- Update text color based on enabled state
            if groupEnabled then
                hideUnobtainableCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
                hideUnobtainableCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
            else
                hideUnobtainableCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
                hideUnobtainableCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
            end
        end
    end

    -- Update Display Group Totals checkbox and its child
    local displayGroupTotalsCheckbox = layoutSection.DisplayGroupTotalsCheckbox;
    local displayTotalsAsPercentageCheckbox = layoutSection.DisplayTotalsAsPercentageCheckbox;
    
    if displayGroupTotalsCheckbox then
        local groupTotalsEnabled = PrettyReps.ReputationService:IsDisplayGroupTotals()
        displayGroupTotalsCheckbox:SetChecked(groupTotalsEnabled)
        
        -- Update child checkbox state and enabled status
        if displayTotalsAsPercentageCheckbox then
            displayTotalsAsPercentageCheckbox:SetEnabled(groupTotalsEnabled)
            displayTotalsAsPercentageCheckbox:SetChecked(PrettyReps.OptionsManager:GetOption("displayTotalsAsPercentage"))
            
            -- Update text color based on enabled state
            if groupTotalsEnabled then
                displayTotalsAsPercentageCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
                displayTotalsAsPercentageCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
            else
                displayTotalsAsPercentageCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
                displayTotalsAsPercentageCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
            end
        end
    end

    -- Update Hide Inactive checkbox
    local hideInactiveCheckbox = layoutSection.HideInactiveCheckbox;
    if hideInactiveCheckbox then
        hideInactiveCheckbox:SetChecked(PrettyReps.ReputationService:IsHideInactiveGroup())
    end

    -- Update Show Opposite Faction checkbox
    local showOppositeFactionCheckbox = visibilitySection.ShowOppositeFactionCheckbox;
    if showOppositeFactionCheckbox then
        showOppositeFactionCheckbox:SetChecked(PrettyReps.OptionsManager:GetOption("showOppositeFaction"))
    end

    -- Update Hide Paragon Icons checkbox and its child
    local hideParagonIconsCheckbox = layoutSection.HideParagonIconsCheckbox;
    local showParagonRewardsCheckbox = layoutSection.ShowParagonRewardsCheckbox;
    
    if hideParagonIconsCheckbox then
        local hideEnabled = PrettyReps.ReputationService:IsHideParagonIcons()
        hideParagonIconsCheckbox:SetChecked(hideEnabled)
        
        -- Enable/disable child checkbox based on parent checkbox state
        if showParagonRewardsCheckbox then
            showParagonRewardsCheckbox:SetEnabled(hideEnabled)
            showParagonRewardsCheckbox:SetChecked(PrettyReps.ReputationService:IsShowParagonRewards())
            
            -- Update text color based on enabled state
            if hideEnabled then
                showParagonRewardsCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
                showParagonRewardsCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
            else
                showParagonRewardsCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
                showParagonRewardsCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
            end
        end
    end

    -- Update Hide Guild Reputation checkbox
    local hideGuildReputationCheckbox = layoutSection.HideGuildReputationCheckbox;
    if hideGuildReputationCheckbox then
        hideGuildReputationCheckbox:SetChecked(PrettyReps.ReputationService:IsHideGuildReputation())
    end

    -- Update Show Not Encountered checkbox
    local showNotEncounteredCheckbox = visibilitySection.ShowNotEncounteredCheckbox;
    if showNotEncounteredCheckbox then
        showNotEncounteredCheckbox:SetChecked(PrettyReps.OptionsManager:GetOption("showNotEncountered"))
    end

    -- Update Display Totals As Percentage checkbox
    local displayTotalsAsPercentageCheckbox = layoutSection.DisplayTotalsAsPercentageCheckbox;
    if displayTotalsAsPercentageCheckbox then
        -- Only enable if group totals is checked
        local groupTotalsEnabled = PrettyReps.ReputationService:IsDisplayGroupTotals()
        displayTotalsAsPercentageCheckbox:SetEnabled(groupTotalsEnabled)
        displayTotalsAsPercentageCheckbox:SetChecked(PrettyReps.OptionsManager:GetOption("displayTotalsAsPercentage"))
        
        -- Update text colors based on enabled state
        if groupTotalsEnabled then
            displayTotalsAsPercentageCheckbox.Text:SetTextColor(1, 0.82, 0)  -- Gold for enabled
            displayTotalsAsPercentageCheckbox.Description:SetTextColor(0.8, 0.8, 0.8)
        else
            displayTotalsAsPercentageCheckbox.Text:SetTextColor(0.5, 0.5, 0.5)  -- Gray for disabled
            displayTotalsAsPercentageCheckbox.Description:SetTextColor(0.5, 0.5, 0.5)
        end
    end
end

function PrettyRepsSettingsFrameMixin:OnShow()
    -- Hide the reputation detail frame since they occupy the same space
    if PrettyRepsReputationFrame.ReputationDetailFrame then
        PrettyRepsReputationFrame.ReputationDetailFrame:Hide();
    end
    
    -- Update checkbox states when showing the frame
    self:UpdateCheckboxStates()
    
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
end

function PrettyRepsSettingsFrameMixin:OnHide()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
end

