local addonName, addon = ...
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0")

-- Load the Capture module
addon.Capture = addon.Capture or {}
addon.AutoRelease = addon.AutoRelease or {}
addon.isDevMode = false
addon.currentMapID = nil
addon.currentSubzone = nil


local mainFrame
local locationButtons = {}
local playerCountButtons = {}
local selectedLocationButton = nil
local selectedPlayerCountButton = nil

-- Helper functions
local function GetPlayerSubZone()
    return GetSubZoneText() or ""
end

local function GetEnglishLocationName(subzone, mapID)
    local config = addon.bgConfigs[mapID]
    if not config then return "Unknown" end

    local lang = GetLocale()
    
    -- Überprüfen Sie zuerst die Übersetzungen für die aktuelle Sprache
    if addon.subzoneTranslations[lang] and addon.subzoneTranslations[lang][subzone] then
        return addon.subzoneTranslations[lang][subzone]
    end
    
    -- Wenn keine Übersetzung gefunden wurde, überprüfen Sie die englischen Subzonen
    for englishName, translations in pairs(config.subzones) do
        if tContains(translations, subzone) then
            return englishName
        end
    end
    
    return "Unknown"
end
function addon:UpdatePlayerLocation()
    local subzone = GetPlayerSubZone()
    local mapID = addon.currentMapID or C_Map.GetBestMapForUnit("player")
    local config = addon.bgConfigs[mapID]
    
    if config then
        local abbreviation = nil
        local lang = GetLocale()
        
        -- Versuchen Sie zuerst, die Abkürzung aus den Lokalisierungsdaten zu erhalten
        if addon.subzoneTranslations[lang] and addon.subzoneTranslations[lang][subzone] then
            abbreviation = addon.subzoneTranslations[lang][subzone]
        else
            -- Wenn keine lokalisierte Abkürzung gefunden wurde, suchen Sie nach der englischen Version
            for englishName, translations in pairs(config.subzones) do
                if tContains(translations, subzone) then
                    -- Suchen Sie die Abkürzung in den englischen Lokalisierungsdaten
                    abbreviation = addon.subzoneTranslations["enUS"][englishName]
                    break
                end
            end
        end
        
        if abbreviation then
            mainFrame.location:SetText(self:GetLocalizedText("You are at: %s", abbreviation))
            for _, button in ipairs(locationButtons) do
                if button:GetText() == abbreviation then
                    button:SetButtonState("PUSHED", 1)
                    selectedLocationButton = button
                else
                    button:SetButtonState("NORMAL")
                end
            end
        else
            mainFrame.location:SetText(self:GetLocalizedText("Location unknown"))
            if selectedLocationButton then
                selectedLocationButton:SetButtonState("NORMAL")
                selectedLocationButton = nil
            end
        end
    else
        mainFrame.location:SetText(self:GetLocalizedText("Not in a known battleground"))
        if selectedLocationButton then
            selectedLocationButton:SetButtonState("NORMAL")
            selectedLocationButton = nil
        end
    end
    
    print("Debug: Current subzone:", subzone)
    print("Debug: Abbreviated location:", abbreviation or "Unknown")
end
-- Create compact button function
local function CreateCompactButton(name, parent, width, height, point, relativeFrame, relativePoint, xOffset, yOffset, row)
    local button = CreateFrame("Button", name, parent, "UIPanelButtonGrayTemplate")
    button:SetSize(width, height)
    button:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
    
    button:SetScript("OnClick", function(self)
        local prevSelected = (row == 1) and selectedLocationButton or selectedPlayerCountButton
        if prevSelected then
            prevSelected:SetButtonState("NORMAL")
        end
        
        if row == 1 then
            selectedLocationButton = self
        else
            selectedPlayerCountButton = self
            addon:SendBGMessage()
        end
	
        
        self:SetButtonState("PUSHED", 1)
    end)
    
    return button
end

-- Create main frame function
    function addon:CreateCompactMainFrame()
        local frame = CreateFrame("Frame", "DynamicBGReporterFrame", UIParent)
        frame:SetSize(275, 100)  -- Reduzierte Höhe, da wir die obere Leiste entfernen
        frame:SetPoint("CENTER")
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:SetClampedToScreen(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        
        -- Hintergrundbild und Rahmen hinzufügen
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 }
        })
        frame:SetBackdropColor(0, 0, 0, 0.8)
        
        frame.location = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.location:SetPoint("TOP", frame, "TOP", 0, -10)
        
        -- Capture Announcer Checkbox
        frame.captureAnnouncer = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
        frame.captureAnnouncer:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
        frame.captureAnnouncer:SetSize(24, 24)
        frame.captureAnnouncer.text = frame.captureAnnouncer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.captureAnnouncer.text:SetPoint("LEFT", frame.captureAnnouncer, "RIGHT", 5, 0)
        frame.captureAnnouncer.text:SetText(self:GetLocalizedText("Capture Announcer"))
        
        frame.captureAnnouncer:SetScript("OnClick", function(self)
            addon.db.profile.captureAnnouncerEnabled = self:GetChecked()
        end)
        
        -- Auto Release Checkbox
        frame.autoRelease = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
        frame.autoRelease:SetPoint("LEFT", frame.captureAnnouncer.text, "RIGHT", 10, 0)
        frame.autoRelease:SetSize(24, 24)
        frame.autoRelease.text = frame.autoRelease:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        frame.autoRelease.text:SetPoint("LEFT", frame.autoRelease, "RIGHT", 5, 0)
        frame.autoRelease.text:SetText(self:GetLocalizedText("Auto Release"))
        
        frame.autoRelease:SetScript("OnClick", function(self)
            addon.db.profile.autoReleaseEnabled = self:GetChecked()
        end)
        
        -- Schließen-Button hinzufügen
        local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
        closeButton:SetScript("OnClick", function() frame:Hide() end)
        
        frame:SetScale(0.85)
        
        return frame
    end

-- Update buttons function
    function addon:UpdateCompactButtons()
        local mapID = addon.isDevMode and addon.currentMapID or C_Map.GetBestMapForUnit("player")
        print("Debug: Current MapID:", mapID)  -- Debug-Ausgabe hinzugefügt
        local config = addon.bgConfigs[mapID]
        
        if config or addon.isDevMode then  -- Ändern Sie diese Zeile
            print("Debug: Battleground found:", config and config.name or "Dev Mode")
            mainFrame.title:SetText((config and config.name or "Dev Mode") .. " Location Reporter")
            
            
            for i, location in ipairs(config.locations) do
                if not locationButtons[i] then
                    locationButtons[i] = CreateCompactButton("Location"..i, mainFrame, 50, 25, "TOPLEFT", mainFrame, "TOPLEFT", 10 + (i-1)*50, -55, 1)
                end
                locationButtons[i]:SetText(location)
                locationButtons[i]:Show()
            end
            
            for i, count in ipairs(addon.playerCounts) do
                if not playerCountButtons[i] then
                    playerCountButtons[i] = CreateCompactButton("Players"..i, mainFrame, 25, 25, "TOPLEFT", mainFrame, "TOPLEFT", 10 + (i-1)*25, -80, 2)
                end
                playerCountButtons[i]:SetText(count)
                playerCountButtons[i]:Show()
            end
            
            mainFrame:Show()
        else
            print("Debug: No matching Battleground config found")
            mainFrame.title:SetText(self:GetLocalizedText("Not in Battleground"))
            mainFrame.location:SetText("")
            for _, button in ipairs(locationButtons) do
                button:Hide()
            end
            for _, button in ipairs(playerCountButtons) do
                button:Hide()
            end
            mainFrame:Show()
        end
        
        addon.currentSubzone = addon.isDevMode and addon.currentSubzone or GetPlayerSubZone()
        
        -- Update the player location
        self:UpdatePlayerLocation()
        
        print("Dev Mode: Battleground set to " .. (config and config.name or "Unknown"))
        if addon.currentSubzone then
            print("Dev Mode: Subzone set to " .. addon.currentSubzone)
        end
    end

    function addon:UpdateCaptureAnnouncerCheckbox()
        if mainFrame then
            if mainFrame.captureAnnouncer then
                mainFrame.captureAnnouncer:SetChecked(self.db.profile.captureAnnouncerEnabled)
            end
            if mainFrame.autoRelease then
                mainFrame.autoRelease:SetChecked(self.db.profile.autoReleaseEnabled)
            end
        end
    end
    

-- New function to toggle the main frame
    function addon:ToggleMainFrame()
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            mainFrame:Show()
            self:UpdateCompactButtons()
            self:UpdatePlayerLocation()
        end
    end

function addon:BGDevCommand(input)
    if input == "on" then
        addon.isDevMode = true
        print("Dev Mode enabled (messages will be sent to SAY)")
        self:UpdateCompactButtons()
    elseif input == "off" then
        addon.isDevMode = false
        print("Dev Mode disabled (messages will be sent to INSTANCE_CHAT)")
        self:UpdateCompactButtons()
    else
        local mapID = tonumber(input)
        if mapID then
            addon.currentMapID = mapID
            addon.isDevMode = true
            print("Dev Mode: MapID set to " .. mapID .. " (messages will be sent to SAY)")
            self:UpdateCompactButtons()
        else
            print("Usage: /bgdev [on|off|mapID]")
        end
    end
end



-- Initialize function
    function addon:OnInitialize()
        self.db = LibStub("AceDB-3.0"):New("DynamicBGReporterDB", {
            profile = {
                captureAnnouncerEnabled = true,
                autoReleaseEnabled = false,
            }
        })
    
        if self.AutoRelease and self.AutoRelease.Initialize then
            self.AutoRelease:Initialize()
        end
    
        mainFrame = self:CreateCompactMainFrame()
        self:UpdateCompactButtons()
        self:UpdateCaptureAnnouncerCheckbox()
        
        self:RegisterChatCommand("bgdev", "BGDevCommand")
        self:RegisterChatCommand("dbg", "ToggleMainFrame")
        
        mainFrame:Hide()
    end
function addon:SendBGMessage()
    if not addon.isDevMode then
        local inInstance, instanceType = IsInInstance()
        if not inInstance or (instanceType ~= "pvp" and instanceType ~= "arena") then
            print("Debug: Player is not in a battleground or arena")
            return
        end
    end

    if selectedLocationButton and selectedPlayerCountButton then
        local location = selectedLocationButton:GetText()
        local playerCount = selectedPlayerCountButton:GetText()
        local message = string.format("%s %s", location, playerCount)
        
        local chatType = addon.isDevMode and "SAY" or "INSTANCE_CHAT"
        
        SendChatMessage(message, chatType)
        print("Message sent to " .. chatType .. ":", message)
    else
        print("Debug: No location or player count selected")
    end
end
function addon:CheckZoneAndToggleFrame()
    if not mainFrame then
        print("Warning: mainFrame not created yet")
        return
    end

    local inInstance, instanceType = IsInInstance()
    if inInstance and (instanceType == "pvp" or instanceType == "arena") then
        mainFrame:Show()
        self:UpdateCompactButtons()
        self:UpdatePlayerLocation()
    else
        mainFrame:Hide()
    end
end


function addon:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("ZONE_CHANGED_INDOORS")
    self:RegisterEvent("UNIT_SPELLCAST_START")
    self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
    self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    self:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
    self:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
  
    self:UpdateCaptureAnnouncerCheckbox()
end

function addon:PLAYER_ENTERING_WORLD()
    addon.isDevMode = false
    addon.currentMapID = nil
    addon.currentSubzone = nil
    self:CheckZoneAndToggleFrame()
end

addon.ZONE_CHANGED_NEW_AREA = addon.PLAYER_ENTERING_WORLD
addon.ZONE_CHANGED = addon.PLAYER_ENTERING_WORLD
addon.ZONE_CHANGED_INDOORS = addon.PLAYER_ENTERING_WORLD

function addon:UNIT_SPELLCAST_START(event, unit, castGUID, spellID)
    self.Capture:Start(unit, spellID)
end

function addon:UNIT_SPELLCAST_INTERRUPTED(event, unit, castGUID, spellID)
    self.Capture:Interrupt(unit, spellID)
end

function addon:UNIT_SPELLCAST_SUCCEEDED(event, unit, castGUID, spellID)
    self.Capture:Succeed(unit, spellID)
end

function addon:CHAT_MSG_BG_SYSTEM_HORDE(event, message)
    self.Capture:HandleBGSystemMessage(message)
end

function addon:CHAT_MSG_BG_SYSTEM_ALLIANCE(event, message)
    self.Capture:HandleBGSystemMessage(message)
end

function addon:CaptureUpdate()
    self.Capture:Update()
end

-- Return the addon table at the end of the file
return addon