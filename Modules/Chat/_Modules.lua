local SUIAddon = SUI
local Modules = SUIAddon:NewModule("SUI.Modules.Chat")

function Modules:OnInitialize()
    Modules.Legacy = SUIAddon:GetModule("Chat.Core", true)
    Modules.Style = SUIAddon:GetModule("Chat.Modern", true)
    Modules.Link = SUIAddon:GetModule("Chat.Url", true)
    Modules.Copy = SUIAddon:GetModule("Chat.Copy", true)
end

local function setModuleEnabled(module, enabled)
    if not module then
        return
    end

    if enabled then
        if not module:IsEnabled() then
            module:Enable()
        end
    else
        if module:IsEnabled() then
            module:Disable()
        end
    end
end

function Modules:OnEnable()
    Modules.db = SUIAddon.db.profile.chat

    setModuleEnabled(Modules.Legacy, Modules.db.style == "Custom")
    setModuleEnabled(Modules.Style, Modules.db.style == "Modern")
    setModuleEnabled(Modules.Link, Modules.db.link)
    setModuleEnabled(Modules.Copy, Modules.db.copy)
end

function Modules:OnDisable()
    setModuleEnabled(Modules.Legacy, false)
    setModuleEnabled(Modules.Style, false)
    setModuleEnabled(Modules.Link, false)
    setModuleEnabled(Modules.Copy, false)
end
