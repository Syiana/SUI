--[[
    SUI 2.0 - Features/Chat/Filters.lua

    Features that rewrite incoming messages through Blizzard's message event
    filters (never AddMessage hooks): clickable URLs, item icons in loot
    messages and role icons in group chat. Filters run once per chat frame
    per message, so they allocate nothing but the resulting string and skip
    secret (12.x restricted) messages.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local gsub, strsub, strfind = string.gsub, string.sub, string.find
local CanAccess = SUI.Compat.CanAccess

-- Clickable URLs ---------------------------------------------------------------------------
-- Links use the garrmission type: every client ignores unknown garrmission
-- data silently, so a plain SetItemRef post-hook can handle the click without
-- replacing ItemRefTooltip methods. The click fills the chat input like 1.x.
local Links = SUI:NewFeature("Chat.Links", {
    category = "chat",
    toggle = "link",
})

local LINK_PREFIX = "garrmission:SUIurl:"
local LINK_REPLACE = "|cff0394ff|H" .. LINK_PREFIX .. "%1|h[%1]|h|r"
local URL_PATTERNS = {
    "(https?://[^%s|]+)",
    "(www%.[^%s|]+%.[^%s|]+)",
    "(%d+%.%d+%.%d+%.%d+:?%d*/?[^%s|]*)",
}
local URL_EVENTS = {
    "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_BATTLEGROUND", "CHAT_MSG_BATTLEGROUND_LEADER",
    "CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_WHISPER_INFORM", "CHAT_MSG_CHANNEL", "CHAT_MSG_SYSTEM",
}

local function urlFilter(_, _, msg, ...)
    if not CanAccess(msg) or type(msg) ~= "string" then
        return false, msg, ...
    end
    for i = 1, #URL_PATTERNS do
        local result, count = gsub(msg, URL_PATTERNS[i], LINK_REPLACE)
        if count > 0 then
            return false, result, ...
        end
    end
    return false, msg, ...
end

function Links:OnLoad()
    if not SetItemRef then
        return
    end
    self:Hook("SetItemRef", function(link)
        if CanAccess(link) and type(link) == "string" and strsub(link, 1, #LINK_PREFIX) == LINK_PREFIX then
            -- Like 1.x: put the URL into the chat input, highlighted for copying.
            local util = ChatFrameUtil
            local choose = util and util.ChooseBoxForSend or ChatEdit_ChooseBoxForSend
            local activate = util and util.ActivateChat or ChatEdit_ActivateChat
            local box = choose and choose()
            if box then
                activate(box)
                box:SetText(strsub(link, #LINK_PREFIX + 1))
                box:HighlightText()
            end
        end
    end)
end

function Links:OnEnable()
    Chat.AddFilter(URL_EVENTS, urlFilter)
end

function Links:OnDisable()
    Chat.RemoveFilter(URL_EVENTS, urlFilter)
end

-- Loot icons ---------------------------------------------------------------------------------
local LootIcons = SUI:NewFeature("Chat.LootIcons", {
    category = "chat",
    toggle = "looticons",
})

local LOOT_EVENTS = { "CHAT_MSG_LOOT" }
local getItemIcon

local function addIcon(link)
    local icon = getItemIcon(link)
    if icon then
        return "|T" .. icon .. ":12:12:0:0:64:64:5:59:5:59|t" .. link
    end
end

local function lootFilter(_, _, msg, ...)
    if not CanAccess(msg) or type(msg) ~= "string" or not strfind(msg, "|Hitem:", 1, true) then
        return false, msg, ...
    end
    return false, (gsub(msg, "(|c[^|]*|Hitem:.-|h|r)", addIcon)), ...
end

function LootIcons:OnLoad()
    getItemIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
end

function LootIcons:OnEnable()
    Chat.AddFilter(LOOT_EVENTS, lootFilter)
end

function LootIcons:OnDisable()
    Chat.RemoveFilter(LOOT_EVENTS, lootFilter)
end

-- Role icons -------------------------------------------------------------------------------------
-- 1.x replaced the global GetColoredName, which taints chat on 12.x. The icon
-- is prefixed to the message text instead.
local RoleIcons = SUI:NewFeature("Chat.RoleIcons", {
    category = "chat",
    toggle = "roleicons",
})

local ROLE_TEXTURE = [[|TInterface\LFGFrame\UI-LFG-ICON-PORTRAITROLES:12:12:0:0:64:64:]]
local ROLE_ICONS = {
    TANK = ROLE_TEXTURE .. "0:19:22:41|t ",
    HEALER = ROLE_TEXTURE .. "20:39:1:20|t ",
    DAMAGER = ROLE_TEXTURE .. "20:39:22:41|t ",
}
local ROLE_EVENTS = {
    "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
}

local function roleFilter(_, _, msg, author, ...)
    if not (CanAccess(msg) and CanAccess(author)) or type(author) ~= "string" or not IsInGroup() then
        return false, msg, author, ...
    end
    local role = UnitGroupRolesAssigned(author)
    if role == "NONE" then
        role = UnitGroupRolesAssigned(Ambiguate(author, "none"))
    end
    local icon = ROLE_ICONS[role]
    if icon then
        return false, icon .. msg, author, ...
    end
    return false, msg, author, ...
end

function RoleIcons:OnEnable()
    if UnitGroupRolesAssigned then
        Chat.AddFilter(ROLE_EVENTS, roleFilter)
    end
end

function RoleIcons:OnDisable()
    if UnitGroupRolesAssigned then
        Chat.RemoveFilter(ROLE_EVENTS, roleFilter)
    end
end
