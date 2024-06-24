local addonName, addon = ...

local Capture = {}
addon.Capture = Capture

Capture.currtime = 0
Capture.threecheck = false
Capture.twocheck = false
Capture.onecheck = false
Capture.zone = nil
Capture.chattype = "INSTANCE_CHAT" -- INSTANCE_CHAT for BG, otherwise SAY, RAID, EMOTE

function Capture:ResetVars()
    self.currtime = 0
    self.threecheck = false
    self.twocheck = false
    self.onecheck = false
    self.zone = nil
end

function Capture:Update()
    if not addon.db.profile.captureAnnouncerEnabled then
        return
    end

    if self.currtime > 0 then
        local timetocap = 8 - math.floor(GetTime() - self.currtime)
        if timetocap > 0 and timetocap <= 3 then
            local function returntext(num) 
                return string.format("Capping %s in %d...", self.zone, num)
            end
            
            if timetocap == 3 and not self.threecheck then
                self.threecheck = true
                SendChatMessage(returntext(3), self.chattype)
            elseif timetocap == 2 and not self.twocheck then
                self.twocheck = true
                SendChatMessage(returntext(2), self.chattype)
            elseif timetocap == 1 and not self.onecheck then
                self.onecheck = true
                SendChatMessage(returntext(1), self.chattype)
            end
        end
    end    
end

function Capture:GetEnglishZoneName(localZone)
    -- This function remains the same
end

function Capture:Start(unit, spellID)
    if not addon.db.profile.captureAnnouncerEnabled then
        return
    end

    if spellID == 21651 and unit == "player" then
        self.currtime = GetTime()
        local localZone = string.upper(GetSubZoneText())
        self.zone = self:GetEnglishZoneName(localZone)
        addon:ScheduleRepeatingTimer("CaptureUpdate", 0.1)
    end
end

function Capture:Interrupt(unit, spellID)
    if not addon.db.profile.captureAnnouncerEnabled then
        return
    end

    if spellID == 21651 and unit == "player" then
        if self.threecheck then
            SendChatMessage(string.format("Capping %s interrupted", self.zone), self.chattype)
        end
        self:ResetVars()
        addon:CancelAllTimers()
    end
end

function Capture:Succeed(unit, spellID)
    if spellID == 21651 and unit == "player" then
        self:ResetVars()
        addon:CancelAllTimers()
    end
end

function Capture:HandleBGSystemMessage(message)
    if self.currtime > 0 and self.zone then
        local mapID = addon.currentMapID or C_Map.GetBestMapForUnit("player")
        local config = addon.bgConfigs[mapID]
        if config and config.areas then
            local formatted_zone = config.areas[self.zone]
            if formatted_zone and string.find(message, formatted_zone) then
                self:ResetVars()
                addon:CancelAllTimers()
            end
        end
    end
end

return Capture