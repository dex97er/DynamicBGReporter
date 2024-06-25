local addonName, addon = ... 
addon = LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0") 

-- Simple debug structure that does nothing if debug.lua is not loaded 
addon.Debug = { 
    Print = function() end, 
    Toggle = function() end, 
    BGDevCommand = function() end, 
    enabled = false 
} 

-- Load the Capture module 
addon.Capture = addon.Capture or {} 

-- Load the AutoRelease module
addon.AutoRelease = addon.AutoRelease or {}

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
     
    if addon.subzoneTranslations[lang] and addon.subzoneTranslations[lang][subzone] then 
        return addon.subzoneTranslations[lang][subzone] 
    end 
     
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
    local englishName = GetEnglishLocationName(subzone, mapID) 
    local bgConfig = addon.bgConfigs[mapID]

    if englishName ~= "Unknown" and bgConfig then 
        local buttonLabel = bgConfig.buttons[englishName] or englishName
        mainFrame.location:SetText(self:GetLocalizedText("You are at: %s", buttonLabel)) 
        for _, button in ipairs(locationButtons) do 
            if button:GetText() == buttonLabel then 
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

    addon.Debug:Print("Current subzone: %s", subzone) 
    addon.Debug:Print("English location name: %s", englishName) 
    if bgConfig and bgConfig.buttons[englishName] then
        addon.Debug:Print("Button label: %s", bgConfig.buttons[englishName])
    end
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
    local frame = CreateFrame("Frame", "DynamicBGReporterFrame", UIParent, "BasicFrameTemplateWithInset") 
    frame:SetSize(275, 155)  -- Increased from 130 to 155
    frame:SetPoint("CENTER") 
    frame:SetMovable(true) 
    frame:EnableMouse(true) 
    frame:SetClampedToScreen(true) 
    frame:RegisterForDrag("LeftButton") 
    frame:SetScript("OnDragStart", frame.StartMoving) 
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing) 
     
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
    frame.title:SetPoint("TOP", frame, "TOP", 0, -5) 
     
    frame.location = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
    frame.location:SetPoint("TOP", frame.title, "BOTTOM", 0, -5) 
     
    frame.captureAnnouncer = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate") 
    frame.captureAnnouncer:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -95) 
    frame.captureAnnouncer:SetSize(24, 24) 
    frame.captureAnnouncer.text = frame.captureAnnouncer:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
    frame.captureAnnouncer.text:SetPoint("LEFT", frame.captureAnnouncer, "RIGHT", 5, 0) 
    frame.captureAnnouncer.text:SetText("Capture Announcer") 
     
    frame.captureAnnouncer:SetScript("OnClick", function(self) 
        addon.db.profile.captureAnnouncerEnabled = self:GetChecked() 
    end) 
     
    local header = CreateFrame("Frame", nil, frame) 
    header:SetHeight(20) 
    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0) 
    header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0) 
    header:EnableMouse(true) 
    header:RegisterForDrag("LeftButton") 
    header:SetScript("OnDragStart", function() frame:StartMoving() end) 
    header:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end) 
     
    frame:SetScale(0.85) 
     
    return frame 
end 

-- Update buttons function 
function addon:UpdateCompactButtons() 
    local mapID = addon.currentMapID or C_Map.GetBestMapForUnit("player") 
    addon.Debug:Print("Current MapID: %s", mapID) 
    local config = addon.bgConfigs[mapID] 
     
    if config then 
        addon.Debug:Print("Battleground found: %s", config.name) 
        mainFrame.title:SetText(config.name .. " Location Reporter") 
         
        for i, location in ipairs(config.locations) do 
            if not locationButtons[i] then 
                locationButtons[i] = CreateCompactButton("Location"..i, mainFrame, 50, 25, "TOPLEFT", mainFrame, "TOPLEFT", 10 + (i-1)*50, -45, 1) 
            end 
            locationButtons[i]:SetText(location) 
            locationButtons[i]:Show() 
        end 
         
        for i = #config.locations + 1, #locationButtons do 
            if locationButtons[i] then 
                locationButtons[i]:Hide() 
            end 
        end 
         
        for i, count in ipairs(addon.playerCounts) do 
            if not playerCountButtons[i] then 
                playerCountButtons[i] = CreateCompactButton("Players"..i, mainFrame, 25, 25, "TOPLEFT", mainFrame, "TOPLEFT", 10 + (i-1)*25, -70, 2) 
            end 
            playerCountButtons[i]:SetText(count) 
            playerCountButtons[i]:Show() 
        end 
         
        mainFrame:Show() 
    else 
        addon.Debug:Print("No matching Battleground config found") 
        mainFrame.title:SetText(self:GetLocalizedText("Not in Battleground")) 
        mainFrame.location:SetText("") 
        for _, button in ipairs(locationButtons) do 
            button:Hide() 
        end 
        for _, button in ipairs(playerCountButtons) do 
            button:Hide() 
        end 
    end 
     
    addon.currentSubzone = GetPlayerSubZone() 
     
    self:UpdatePlayerLocation() 
     
    mainFrame:Show() 
     
    addon.Debug:Print("Battleground set to %s", (config and config.name or "Unknown")) 
    if addon.currentSubzone then 
        addon.Debug:Print("Subzone set to %s", addon.currentSubzone) 
    end 
end 

function addon:UpdateCaptureAnnouncerCheckbox() 
    if mainFrame and mainFrame.captureAnnouncer then 
        mainFrame.captureAnnouncer:SetChecked(self.db.profile.captureAnnouncerEnabled) 
    end
    self.AutoRelease:UpdateAutoReleaseCheckbox()
end 

function addon:ToggleMainFrame() 
    if mainFrame:IsShown() then 
        mainFrame:Hide() 
    else 
        mainFrame:Show() 
        self:UpdateCompactButtons() 
        self:UpdatePlayerLocation() 
    end 
end 

function addon:ResetLocationButtons() 
    if selectedLocationButton then 
        selectedLocationButton:SetButtonState("NORMAL") 
        selectedLocationButton = nil 
    end 
    if selectedPlayerCountButton then 
        selectedPlayerCountButton:SetButtonState("NORMAL") 
        selectedPlayerCountButton = nil 
    end 
end 

function addon:OnInitialize() 
    self.db = LibStub("AceDB-3.0"):New("DynamicBGReporterDB", { 
        profile = { 
            captureAnnouncerEnabled = true, 
        } 
    }) 

    mainFrame = self:CreateCompactMainFrame() 
    self:UpdateCompactButtons() 
     
    mainFrame.captureAnnouncer:SetChecked(self.db.profile.captureAnnouncerEnabled) 
     
    self:RegisterChatCommand("bgdev", "BGDevCommand") 
    self:RegisterChatCommand("dbg", "ToggleMainFrame") 
    self:RegisterChatCommand("bgdebug", "BGDebugCommand") 
     
    mainFrame:Hide() 

    -- Initialize AutoRelease module
    self.AutoRelease:Initialize()
    self.AutoRelease:CreateAutoReleaseCheckbox(mainFrame)
    self.AutoRelease:UpdateAutoReleaseCheckbox()
end 

function addon:SendBGMessage() 
    if not IsInBattleground() then 
        addon.Debug:Print("Player is not in a battleground") 
        return 
    end 

    if selectedPlayerCountButton and selectedLocationButton then 
        local location = selectedLocationButton:GetText() 
        local playerCount = selectedPlayerCountButton:GetText() 
        local message = string.format("Location: %s, Player Count: %s", location, playerCount) 
        SendChatMessage(message, "INSTANCE_CHAT") 
        addon.Debug:Print("Message sent to instance chat: %s", message) 
    else 
        addon.Debug:Print("No location or player count selected") 
        addon.Debug:Print("selectedLocationButton: %s", tostring(selectedLocationButton)) 
        addon.Debug:Print("selectedPlayerCountButton: %s", tostring(selectedPlayerCountButton)) 
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
    self:UpdateCompactButtons() 
    self:UpdatePlayerLocation() 
    self:UpdateCaptureAnnouncerCheckbox() 
end 

function addon:PLAYER_ENTERING_WORLD() 
    addon.isDevMode = false 
    addon.currentMapID = nil 
    addon.currentSubzone = nil 
     
    self:ResetLocationButtons() 
    self:UpdateCompactButtons() 
    self:UpdatePlayerLocation() 
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

function addon:BGDebugCommand(input) 
    self.Debug:Toggle() 
end 

function addon:BGDevCommand(input) 
    self.Debug:BGDevCommand(input) 
end 

return addon