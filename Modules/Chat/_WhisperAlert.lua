local Module = SUI:NewModule("Chat.WhisperAlert")

local frame

local function playWhisperAlert()
    PlaySoundFile([[Interface\\AddOns\\SUI\\Media\Sounds\whisper.ogg]], "Master")
end

function Module:OnEnable()
    if not SUI.db.profile.chat.whisperalert then
        return
    end

    if not frame then
        frame = CreateFrame("Frame")
        frame:SetScript("OnEvent", playWhisperAlert)
    end

    frame:RegisterEvent("CHAT_MSG_WHISPER")
    frame:RegisterEvent("CHAT_MSG_BN_WHISPER")
end

function Module:OnDisable()
    if frame then
        frame:UnregisterAllEvents()
    end
end
