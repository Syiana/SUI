--[[
    SUI 2.0 - Features/Chat/FriendList.lua

    Colours online friends in the friend list by class and shows the
    character (and level below the level cap) next to Battle.net names. A
    "^Alias$" in the friend note replaces the name, as in 1.x.
    Hooks each list button's name text once; retail acquires buttons from a
    ScrollBox, the classic clients use a fixed HybridScrollFrame button list.
]]

local _, ns = ...
local SUI = ns.SUI

local floor, format, pairs, type, strmatch = math.floor, string.format, pairs, type, string.match

local F = SUI:NewFeature("Chat.FriendList", {
    category = "chat",
    toggle = "friendlist",
})

local classTokens = {} -- localized class name -> class token
local hooked = {}
local maxLevel
local busy = false

-- "^Alias$" anywhere in the friend note replaces the name (1.x).
local function alias(note)
    local name = type(note) == "string" and strmatch(note, "%^(.-)%$")
    if name and name ~= "" then
        return name
    end
end

local function setText(fontString, r, g, b, text)
    busy = true
    fontString:SetText(format("|cff%02x%02x%02x%s|r", floor(r * 255), floor(g * 255), floor(b * 255), text))
    busy = false
end

local function colorName(fontString)
    if busy or not F.enabled then
        return
    end
    local button = fontString:GetParent()
    local kind, id = button.buttonType, button.id
    local name, nickname, character, class, level, online, nameColor
    if kind == FRIENDS_BUTTON_TYPE_BNET then
        local info = C_BattleNet.GetFriendAccountInfo(id)
        if not info then
            return
        end
        local game = info.gameAccountInfo
        nickname = alias(info.note)
        name = nickname or info.accountName
        online = game and game.isOnline
        nameColor = FRIENDS_BNET_NAME_COLOR
        if online and game.clientProgram == BNET_CLIENT_WOW and game.characterName then
            character, class, level = game.characterName, game.className, game.characterLevel
        end
    elseif kind == FRIENDS_BUTTON_TYPE_WOW then
        local info = C_FriendList.GetFriendInfoByIndex(id)
        if not (info and info.name) then
            return
        end
        nickname = alias(info.notes)
        name = nickname or info.name
        online = info.connected
        nameColor = FRIENDS_WOW_NAME_COLOR
        if online then
            class, level = info.className, info.level
        end
    else
        return
    end

    local token = class and classTokens[class]
    if not token then
        -- Only an alias to show: keep Blizzard's online/offline colours.
        local c = online and nameColor or FRIENDS_GRAY_COLOR
        if nickname and c then
            setText(fontString, c.r, c.g, c.b, name)
        end
        return
    end
    local text = name
    if character then
        if level and level < maxLevel then
            text = format("%s [%s - %d]", name, character, level)
        else
            text = format("%s [%s]", name, character)
        end
    elseif level and level < maxLevel then
        text = format("%s - %d", name, level)
    end
    local r, g, b = SUI.Compat.GetClassColor(token)
    setText(fontString, r, g, b, text)
end

local function hookButton(button)
    local name = button and button.name
    if name and not hooked[name] then
        hooked[name] = true
        hooksecurefunc(name, "SetText", colorName)
    end
end

function F:OnLoad()
    for token, name in pairs(LOCALIZED_CLASS_NAMES_MALE or {}) do
        classTokens[name] = token
    end
    for token, name in pairs(LOCALIZED_CLASS_NAMES_FEMALE or {}) do
        classTokens[name] = token
    end
    maxLevel = (GetMaxLevelForPlayerExpansion and GetMaxLevelForPlayerExpansion())
        or (GetMaxPlayerLevel and GetMaxPlayerLevel()) or MAX_PLAYER_LEVEL or 60

    local scrollBox = FriendsListFrame and FriendsListFrame.ScrollBox
    if scrollBox and ScrollUtil and ScrollUtil.AddAcquiredFrameCallback then
        ScrollUtil.AddAcquiredFrameCallback(scrollBox, function(_, button)
            hookButton(button)
        end, self, true)
        return
    end
    local function scan()
        local list = FriendsFrameFriendsScrollFrame and FriendsFrameFriendsScrollFrame.buttons
        for i = 1, list and #list or 0 do
            hookButton(list[i])
        end
    end
    scan()
    -- Classic may create the buttons on first show.
    if FriendsFrame_UpdateFriends then
        self:Hook("FriendsFrame_UpdateFriends", scan)
    end
end
