local Module = SUI:NewModule("General.Errors");

function Module:OnEnable()
    local db = {
        errors = SUI.db.profile.general.cosmetic.errors,
        module = SUI.db.profile.modules.general
    }

    if ((not db.errors) and (db.module)) then
        local colors = {
            UI_INFO_MESSAGE = { r = 1.0, g = 1.0, b = 0.0 },
            UI_ERROR_MESSAGE = { r = 1.0, g = 0.1, b = 0.1 },
        }

        local originalOnEvent = UIErrorsFrame:GetScript("OnEvent")
        local GetGameMessageInfo, PlayVocalErrorSoundID, PlaySound = GetGameMessageInfo, PlayVocalErrorSoundID, PlaySound
        UIErrorsFrame:SetScript("OnEvent", function(self, event, ...)
            local messageType, message, r, g, b

            if event == "SYSMSG" then
                message, r, g, b = ...
                return originalOnEvent(self, event, ...)
            elseif event == "UI_INFO_MESSAGE" then
                messageType, message = ...
                return originalOnEvent(self, event, ...)
            end

            if event ~= "SYSMSG" then
                messageType, message = ...
                r, g, b = colors[event].r, colors[event].g, colors[event].b
                local _, soundKitID, voiceID = GetGameMessageInfo(messageType)
                if voiceID then
                    PlayVocalErrorSoundID(voiceID)
                elseif soundKitID then
                    PlaySound(soundKitID)
                end
            elseif event == "UI_INFO_MESSAGE" then
                messageType, message = ...
                return originalOnEvent(self, event, ...)
            end
        end)
    end
end
