local SUIAddon = SUI
local Modules = SUIAddon:NewModule("SUI.Modules.Chat")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Style = SUIAddon:GetModule("SUI.Modules.Chat.Style")
    Modules.Link = SUIAddon:GetModule("SUI.Modules.Chat.Link")
    Modules.Copy = SUIAddon:GetModule("SUI.Modules.Chat.Copy")
    Modules.WhisperAlert = SUIAddon:GetModule("SUI.Modules.Chat.WhisperAlert")
end

function Modules:OnEnable()
    Modules.db = SUIAddon.db.profile.chat

    if Modules.db.style == "Modern" then
        Modules.Style:Enable()
    end
    if Modules.db.link then
        Modules.Link:Enable()
    end
    if Modules.db.copy then
        Modules.Copy:Enable()
    end
    if Modules.db.whisperalert then
        Modules.WhisperAlert:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Style:Disable()
    Modules.Link:Disable()
    Modules.Copy:Disable()
    Modules.WhisperAlert:Disable()
end
