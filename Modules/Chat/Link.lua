local SUIAddon = SUI
local Link = SUIAddon:NewModule("SUI.Modules.Chat.Link", "AceHook-3.0")

function Link:OnInitialize()
    Link.patterns = {"(https://%S+%.%S+)", "(http://%S+%.%S+)", "(www%.%S+%.%S+)", "(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)"}

    Link.events = {
        ["CHAT_MSG_SAY"] = false,
        ["CHAT_MSG_YELL"] = false,
        ["CHAT_MSG_WHISPER"] = false,
        ["CHAT_MSG_WHISPER_INFORM"] = false,
        ["CHAT_MSG_GUILD"] = false,
        ["CHAT_MSG_OFFICER"] = false,
        ["CHAT_MSG_PARTY"] = false,
        ["CHAT_MSG_PARTY_LEADER"] = false,
        ["CHAT_MSG_RAID"] = false,
        ["CHAT_MSG_RAID_LEADER"] = false,
        ["CHAT_MSG_RAID_WARNING"] = false,
        ["CHAT_MSG_INSTANCE_CHAT"] = false,
        ["CHAT_MSG_INSTANCE_CHAT_LEADER"] = false,
        ["CHAT_MSG_BN_WHISPER"] = false,
        ["CHAT_MSG_BN_WHISPER_INFORM"] = false,
        ["CHAT_MSG_CHANNEL"] = false,
        ["CHAT_MSG_SYSTEM"] = false
    }

    function Link:URL(self, str, ...)
        for _, pattern in pairs(Link.patterns) do
            local result, match = string.gsub(str, pattern, "|cff0394ff|Hurl:%1|h[%1]|h|r")
            if match > 0 then
                return false, result, ...
            end
        end
    end

    function Link:RegisterEvents()
        for event in pairs(Link.events) do
            if not Link.events[event] then
                ChatFrameUtil.AddMessageEventFilter(event, Link.URL)

                Link.events[event] = true
            end
        end
    end

    function Link:UnregisterEvents()
        for event in pairs(Link.events) do
            if Link.events[event] then
                ChatFrameUtil.RemoveMessageEventFilter(event, Link.URL)

                Link.events[event] = false
            end
        end
    end

    Link.SetHyperlink = ItemRefTooltip.SetHyperlink
    function Link:EnableHyperlink()
        local SetHyperlink = _G.ItemRefTooltip.SetHyperlink
        function _G.ItemRefTooltip:SetHyperlink(link, ...)
            if link and (strsub(link, 1, 3) == "url") then
                local editbox = ChatFrameUtil.ChooseBoxForSend()
                ChatFrameUtil.ActivateChat(editbox)
                editbox:SetText(string.sub(link, 5))
                editbox:HighlightText()
                return
            end

            SetHyperlink(self, link, ...)
        end
    end
end

function Link:OnEnable()
    if not SUIAddon.db or not SUIAddon.db.profile or not SUIAddon.db.profile.chat or not SUIAddon.db.profile.chat.link then
        return
    end

    Link:RegisterEvents()
    Link:EnableHyperlink()
end

function Link:Disable()
    ItemRefTooltip.SetHyperlink = Link.SetHyperlink
    Link:UnregisterEvents()
end
