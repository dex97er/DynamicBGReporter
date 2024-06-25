local addonName, addon = ...

-- Create the AutoRelease module
addon.AutoRelease = {}
local AutoRelease = addon.AutoRelease

-- Local variables
local autoReleaseCheckbox

-- Function to check if the player is in a PvP instance
local function IsInPvPInstance()
    local _, instanceType = IsInInstance()
    return instanceType == "pvp" or instanceType == "arena"
end

-- Function to automatically release spirit
local function AutoReleaseSpirit()
    if IsInPvPInstance() and addon.db.profile.autoReleaseEnabled then
        RepopMe()
    end
end

-- Function to create and set up the auto-release checkbox
function AutoRelease:CreateAutoReleaseCheckbox(parent)
    autoReleaseCheckbox = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    autoReleaseCheckbox:SetPoint("TOPLEFT", parent.captureAnnouncer, "BOTTOMLEFT", 0, -5)
    autoReleaseCheckbox:SetSize(24, 24)
    
    autoReleaseCheckbox.text = autoReleaseCheckbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoReleaseCheckbox.text:SetPoint("LEFT", autoReleaseCheckbox, "RIGHT", 5, 0)
    autoReleaseCheckbox.text:SetText(addon:GetLocalizedText("Auto Release Spirit"))
    
    autoReleaseCheckbox:SetScript("OnClick", function(self)
        addon.db.profile.autoReleaseEnabled = self:GetChecked()
    end)
end

-- Function to update the checkbox state
function AutoRelease:UpdateAutoReleaseCheckbox()
    if autoReleaseCheckbox then
        autoReleaseCheckbox:SetChecked(addon.db.profile.autoReleaseEnabled)
    end
end

-- Function to initialize the module
function AutoRelease:Initialize()
    -- Add auto-release option to the addon's saved variables
    addon.db.profile.autoReleaseEnabled = addon.db.profile.autoReleaseEnabled or false
    
    -- Register events
    addon:RegisterEvent("PLAYER_DEAD", AutoReleaseSpirit)
end

-- Return the module
return AutoRelease