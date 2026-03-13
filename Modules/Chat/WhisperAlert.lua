local SUIAddon = SUI
local WhisperAlert = SUIAddon:NewModule("SUI.Modules.Chat.WhisperAlert", "AceHook-3.0")

function WhisperAlert:OnInitialize()
    WhisperAlert.frame = CreateFrame("Frame")
    WhisperAlert.frame:RegisterEvent("CHAT_MSG_WHISPER")
    WhisperAlert.frame:RegisterEvent("CHAT_MSG_BN_WHISPER")

    function WhisperAlert:Sound()
        PlaySoundFile([[Interface\\AddOns\\SUI\\Media\Sounds\whisper.ogg]], "Master")
    end
end

function WhisperAlert:OnEnable()
    if not SUIAddon.db or not SUIAddon.db.profile or not SUIAddon.db.profile.chat or not SUIAddon.db.profile.chat.whisperalert then
        return
    end

    WhisperAlert:SecureHookScript(WhisperAlert.frame, "OnEvent", WhisperAlert.Sound)
end

function WhisperAlert:OnDisable()
    WhisperAlert:UnhookAll()
end
