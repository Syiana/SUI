local Module = SUI:NewModule("Chat.Url");

Module.patterns = {
    "(https://%S+%.%S+)",
    "(http://%S+%.%S+)",
    "(www%.%S+%.%S+)",
    "(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)"
}

Module.events = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_BATTLEGROUND",
    "CHAT_MSG_BATTLEGROUND_LEADER",
    "CHAT_MSG_BN_WHISPER",
    "CHAT_MSG_BN_WHISPER_INFORM",
    "CHAT_MSG_BN_CONVERSATION",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_SYSTEM"
}

function Module:MessageFilter(_, _, str, ...)
    for _, pattern in pairs(Module.patterns) do
        local result, match = string.gsub(str, pattern, "|cff0394ff|Hurl:%1|h[%1]|h|r")
        if match > 0 then
            return false, result, ...
        end
    end
end

function Module:RegisterFilters()
    if Module.filtersRegistered then
        return
    end

    for _, event in ipairs(Module.events) do
        if ChatFrameUtil and ChatFrameUtil.AddMessageEventFilter then
            ChatFrameUtil.AddMessageEventFilter(event, Module.MessageFilter)
        else
            ChatFrame_AddMessageEventFilter(event, Module.MessageFilter)
        end
    end

    Module.filtersRegistered = true
end

function Module:UnregisterFilters()
    if not Module.filtersRegistered then
        return
    end

    for _, event in ipairs(Module.events) do
        if ChatFrameUtil and ChatFrameUtil.RemoveMessageEventFilter then
            ChatFrameUtil.RemoveMessageEventFilter(event, Module.MessageFilter)
        else
            ChatFrame_RemoveMessageEventFilter(event, Module.MessageFilter)
        end
    end

    Module.filtersRegistered = false
end

function Module:EnableHyperlinks()
    if not Module.originalSetHyperlink then
        Module.originalSetHyperlink = _G.ItemRefTooltip.SetHyperlink
    end

    _G.ItemRefTooltip.SetHyperlink = function(self, link, ...)
        if link and strsub(link, 1, 3) == "url" then
            local editbox
            if ChatFrameUtil and ChatFrameUtil.ChooseBoxForSend then
                editbox = ChatFrameUtil.ChooseBoxForSend()
                ChatFrameUtil.ActivateChat(editbox)
                editbox:SetText(string.sub(link, 5))
            else
                editbox = ChatEdit_ChooseBoxForSend()
                ChatEdit_ActivateChat(editbox)
                editbox:Insert(string.sub(link, 5))
            end
            editbox:HighlightText()
            return
        end

        Module.originalSetHyperlink(self, link, ...)
    end
end

function Module:DisableHyperlinks()
    if Module.originalSetHyperlink then
        _G.ItemRefTooltip.SetHyperlink = Module.originalSetHyperlink
    end
end

function Module:OnEnable()
    if not SUI.db.profile.chat.link then
        return
    end

    Module:RegisterFilters()
    Module:EnableHyperlinks()
end

function Module:OnDisable()
    Module:DisableHyperlinks()
    Module:UnregisterFilters()
end
