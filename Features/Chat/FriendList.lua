--[[
    SUI 2.0 - Features/Chat/FriendList.lua

    Colours online friends in the friend list by class and shows the
    character (and level below the level cap) next to Battle.net names.
    Hooks each list button's name text once; retail acquires buttons from a
    ScrollBox, the classic clients use a fixed HybridScrollFrame button list.
]]

local _, ns = ...
local SUI = ns.SUI

local floor, format, pairs = math.floor, string.format, pairs

local F = SUI:NewFeature("Chat.FriendList", {
    category = "chat",
    toggle = "friendlist",
})

local classTokens = {} -- localized class name -> class token
local hooked = {}
local maxLevel
local busy = false

local function colorName(fontString)
    if busy or not F.enabled then
        return
    end
    local button = fontString:GetParent()
    local kind, id = button.buttonType, button.id
    local text, class, level
    if kind == FRIENDS_BUTTON_TYPE_BNET then
        local info = C_BattleNet.GetFriendAccountInfo(id)
        local game = info and info.gameAccountInfo
        if not (game and game.isOnline and game.clientProgram == BNET_CLIENT_WOW and game.characterName) then
            return
        end
        class, level = game.className, game.characterLevel
        if level and level < maxLevel then
            text = format("%s [%s - %d]", info.accountName, game.characterName, level)
        else
            text = format("%s [%s]", info.accountName, game.characterName)
        end
    elseif kind == FRIENDS_BUTTON_TYPE_WOW then
        local info = C_FriendList.GetFriendInfoByIndex(id)
        if not (info and info.connected and info.name) then
            return
        end
        class, level = info.className, info.level
        if level and level < maxLevel then
            text = format("%s - %d", info.name, level)
        else
            text = info.name
        end
    else
        return
    end
    local token = class and classTokens[class]
    if not token then
        return
    end
    local r, g, b = SUI.Compat.GetClassColor(token)
    busy = true
    fontString:SetText(format("|cff%02x%02x%02x%s|r", floor(r * 255), floor(g * 255), floor(b * 255), text))
    busy = false
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
