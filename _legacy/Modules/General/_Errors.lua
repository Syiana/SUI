local Module = SUI:NewModule("General.Errors");

function Module:OnEnable()
    local db = SUI.db.profile.general.cosmetic.errors
    if not db then
        local colors = {
            UI_INFO_MESSAGE = { r = 1.0, g = 1.0, b = 0.0 },
            UI_ERROR_MESSAGE = { r = 1.0, g = 0.1, b = 0.1 },
        }
        
        local map = {
            SYSMSG = "system",
            UI_INFO_MESSAGE = "information",
            UI_ERROR_MESSAGE = "errors",
        }

        local originalOnEvent = UIErrorsFrame:GetScript("OnEvent")
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
                    C_Sound.PlayVocalErrorSound(voiceID)
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
