local lib, oldminor = LibStub:NewLibrary("AddonsPanel", 3)
if not lib then return end

function lib.new(parent, addonname)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame.name = "Death Alerts"
	frame.addonname = addonname
	frame:Hide()
	frame:SetScript("OnShow", lib.OnShow)
	InterfaceOptions_AddCategory(frame)
	return frame
end

local fields = {"Title", "Author", "Version"}

function lib.OnShow(frame)
	if options ~= nil then options:Hide() end --prevents panel duplication

	local notesVal = GetAddOnMetadata(frame.addonname, "Notes")

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(frame.name)

	local notes = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetHeight(32)
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("RIGHT", parent, -32, 0)
	notes:SetHeight(30)
	notes:SetNonSpaceWrap(true)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetText(notesVal)

	local anchor
	for _,field in pairs(fields) do
		local val = GetAddOnMetadata(frame.addonname, field)
		if val then
			local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			title:SetWidth(75)
			if not anchor then title:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", -2, -8)
			else title:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6) end
			title:SetJustifyH("RIGHT")
			title:SetText(field:gsub("X%-", ""))

			local detail = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			detail:SetPoint("LEFT", title, "RIGHT", 4, 0)
			detail:SetPoint("RIGHT", -16, 0)
			detail:SetJustifyH("LEFT")
			detail:SetText("|cff9999ff" .. val)

			anchor = title
		end
	end

	---------------------------------------------------------------------------------------------------------------

	options = CreateFrame("Frame", nil, frame)
	options:SetPoint("BOTTOMLEFT",20,20)
	options:SetWidth(580)
	options:SetHeight(400)

	local texture = options:CreateTexture("ARTWORK");
	texture:SetAllPoints();
	texture:SetColorTexture(0,0,0,.25);

	---------------------------------------------------------------------------------------------------------------

	--Set default color if not previously defined (normally only for first addon loadup)
	if rDAColor == nil or gDAColor == nil or bDAColor == nil then rDAColor, gDAColor, bDAColor = 0.5,0,0.5 end
	
	local colorPickerButton = CreateFrame("Button", "state", options)
	colorPickerButton:SetSize(20,20)
	colorPickerButton:SetPoint("TOPLEFT",20,-21)
	
	local colorPickerTexture = colorPickerButton:CreateTexture("ARTWORK");
	colorPickerTexture:SetAllPoints();
	colorPickerTexture:SetColorTexture(rDAColor, gDAColor, bDAColor);

	colorPickerButton:SetScript("OnClick", function(button, who)
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame:SetColorRGB(rDAColor, gDAColor, bDAColor)
    	rPrev, gPrev, bPrev = rDAColor, gDAColor, bDAColor

 		ColorPickerFrame.func = 
 			function ()
 				rDAColor, gDAColor, bDAColor = ColorPickerFrame:GetColorRGB()
 				colorPickerTexture:SetColorTexture(rDAColor, gDAColor, bDAColor);
        end
 		ColorPickerFrame.cancelFunc = 
 			function ()
            	rDAColor, gDAColor, bDAColor = rPrev, gPrev, bPrev
            	colorPickerTexture:SetColorTexture(rDAColor, gDAColor, bDAColor);
        end 

 		ColorPickerFrame:Hide()
 		ColorPickerFrame:Show()
 	end)

 	local colorPickerBorder = colorPickerButton:CreateTexture(nil,"BACKGROUND")
	colorPickerBorder:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	colorPickerBorder:SetPoint("TOPLEFT",-1.5,1.5)
	colorPickerBorder:SetPoint("BOTTOMRIGHT",2,-2)
	colorPickerBorder:SetVertexColor(0.85, 0.85, 0.85)

	local colorPickerText = options:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	colorPickerText:SetPoint("TOPLEFT",50,-24.5)
	colorPickerText:SetText("Alert Color")
	colorPickerText:SetTextColor(1,1,1,1)
	colorPickerText:SetFont("Fonts\\ARIALN.ttf",15)


	local colorPickerExample = CreateFrame("Button", "state", options, "UIPanelButtonTemplate")
	colorPickerExample:SetSize(93,30)
	colorPickerExample:SetText("Example Alert")
	colorPickerExample:SetPoint("TOPLEFT",16,-45)
	colorPickerExample:SetScript("OnClick", function()
		DEFAULT_CHAT_FRAME:AddMessage("<Example> died to <something> (9999)", rDAColor, gDAColor, bDAColor)
	end)

	---------------------------------------------------------------------------------------------------------------

	local reset = CreateFrame("Button", "state", options, "UIPanelButtonTemplate")
	reset:SetSize(90,30)
	reset:SetText("Reset to Defaults")
	reset:SetPoint("BOTTOM",0,20)
	reset:SetScript("OnClick", function()
		rDAColor, gDAColor, bDAColor = 0.5,0,0.5
 		colorPickerTexture:SetColorTexture(rDAColor, gDAColor, bDAColor);
		DEFAULT_CHAT_FRAME:AddMessage("<Example> died to <something> (999999)", rDAColor, gDAColor, bDAColor)
	end)

	---------------------------------------------------------------------------------------------------------------
end