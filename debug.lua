local addonName, addon = ...

-- Extend the existing Debug structure
addon.Debug.enabled = false

function addon.Debug:Toggle()
    self.enabled = not self.enabled
    local status = self.enabled and "enabled" or "disabled"
    self:Print("Debug mode " .. status)
end

function addon.Debug:Print(...)
    if self.enabled then
        local prefix = "|cFF00FF00[DBG]|r "
        local message = string.format(...)
        DEFAULT_CHAT_FRAME:AddMessage(prefix .. message)
    end
end

function addon.Debug:BGDevCommand(input)
    local chatType = IsInRaid() and "RAID" or IsInGroup() and "PARTY" or "SAY"
    if IsInInstance() then
        chatType = "INSTANCE_CHAT"
    end
    
    SendChatMessage("[BGDev] " .. (input or "No input"), chatType)
end

-- Additional debug functions can be added here

return addon.Debug
