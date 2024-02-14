local Friendlist = SUI:NewModule("Chat.Friendlist");

function Friendlist:OnEnable()
    local db = SUI.db.profile.chat.friendlist
    if (db) then
        function FriendsListByClassColor_Update()
            local Config = {
                format = "[if=level][color=level][=level][/color][/if] [color=class][=accountName|name] [if=characterName]([=characterName])[/if][/color]",
                level = "[if=level][=level][/if]"
            }
            local Color
            do

                ---@param r number|ColorMixin
                ---@param g? number
                ---@param b? number
                local function ColorToHex(r, g, b)
                    if type(r) == "table" then
                        if r.r then
                            r, g, b = r.r, r.g, r.b
                        else
                            r, g, b = unpack(r)
                        end
                    end
                    if not r then
                        return "ffffff"
                    end
                    return format("%02X%02X%02X", floor(r * 255), floor(g * 255), floor(b * 255))
                end

                ---@type table<string, string>
                local cache
                do

                    cache = {}

                    ---@diagnostic disable-next-line: undefined-field
                    local colors = (_G.CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS)

                    ---@diagnostic disable-next-line: undefined-field
                    for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do cache[v] = ColorToHex(colors[k]) end

                    ---@diagnostic disable-next-line: undefined-field
                    for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do cache[v] = ColorToHex(colors[k]) end

                    if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
                        cache.Evoker = cache.Evoker or "33937F"
                        cache.Monk = cache.Monk or "00FF98"
                        cache.Paladin = cache.Paladin or "F48CBA"
                        cache.Shaman = cache.Shaman or "0070DD"
                    end

                end

                Color = {}

                Color.From = ColorToHex

                Color.Gray = Color.From(_G.FRIENDS_GRAY_COLOR) ---@diagnostic disable-line: undefined-field
                Color.BNet = Color.From(_G.FRIENDS_BNET_NAME_COLOR) ---@diagnostic disable-line: undefined-field
                Color.WoW = Color.From(_G.FRIENDS_WOW_NAME_COLOR) ---@diagnostic disable-line: undefined-field

                ---@param query any
                ---@return string?
                function Color.ForClass(query)
                    return cache[query]
                end

                ---@param level any
                ---@return string?
                function Color.ForLevel(level)
                    if level and type(level) ~= "number" then
                        level = tonumber(level, 10)
                    end
                    if not level then
                        return
                    end
                    local color = _G.GetQuestDifficultyColor(level) ---@diagnostic disable-line: undefined-field
                    return Color.From(color.r, color.g, color.b)
                end

            end

            local Util
            do

                Util = {}

                ---@generic K, V
                ---@param destination K
                ---@param source V
                ---@return K
                function Util.MergeTable(destination, source)
                    for k, v in pairs(source) do
                        destination[k] = v
                    end
                    return destination
                end

                ---@param text string
                function Util.EscapePattern(text)
                    if type(text) ~= "string" then
                        return
                    end
                    return (
                        text
                            :gsub("%%", "%%%%")
                            :gsub("%|", "%%|")
                            :gsub("%?", "%%?")
                            :gsub("%.", "%%.")
                            :gsub("%-", "%%-")
                            :gsub("%_", "%%_")
                            :gsub("%[", "%%[")
                            :gsub("%]", "%%]")
                            :gsub("%(", "%%(")
                            :gsub("%)", "%%)")
                            :gsub("%*", "%%*")
                        )
                end

                ---@param a any
                ---@param b any
                ---@param c any
                function Util.SafeReplace(a, b, c)
                    if type(a) == "string" and type(b) == "string" and type(c) == "string" then
                        a = a:gsub(b, c)
                    end
                    return a
                end

                ---@param oldName string
                ---@param newName string
                ---@param lineID? number
                ---@param bnetIDAccount? number
                function Util.SafeReplaceName(oldName, newName, lineID, bnetIDAccount)
                    if bnetIDAccount then
                        -- HOTFIX: Disable custom names when handling chat messages from BNet friends until we figure out a possible workaround.
                        -- `GetBNPlayerLink` is not working well when used to replace the real BNet name with an alias in the chat the name gets mangled something fierce.
                        if lineID then
                            return oldName
                        end
                        return _G.GetBNPlayerLink(newName, newName, bnetIDAccount, lineID) ---@diagnostic disable-line: undefined-field
                    end
                    return newName
                end

            end

            local Parse
            do

                Parse = {}

                ---@param note any
                ---@return string?
                function Parse.Note(note)
                    if type(note) ~= "string" then
                        return
                    end
                    local alias = note:match("%^(.-)%$")
                    if alias and alias ~= "" then
                        return alias
                    end
                end

                ---@param friendWrapper FriendWrapper
                ---@param field string
                function Parse.Color(friendWrapper, field)

                    ---@type string|number|boolean|nil
                    local out

                    ---@type string|number|boolean|nil
                    local value = friendWrapper.data[field]

                    if field == "level" or field == "characterLevel" then
                        out = Color.ForLevel(value)
                    elseif field == "className" or field == "class" then
                        out = Color.ForClass(value)
                    end

                    if not out then
                        local r, g, b = field:match("^%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*$") ---@type string?, string?, string?
                        if r then
                            out = Color.From(r / 255, g / 255, b / 255)
                        else
                            local hex = field:match("^%s*([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f])%s*$") ---@type string?
                            if hex then
                                out = hex
                            end
                        end
                    end

                    if not out then
                        ---@diagnostic disable-next-line: undefined-field
                        local offline = not
                            friendWrapper.data[
                            friendWrapper.type == FRIENDS_BUTTON_TYPE_BNET and "isOnline" or "connected"]
                        if offline then
                            out = Color.Gray
                        elseif friendWrapper.type == FRIENDS_BUTTON_TYPE_BNET then ---@diagnostic disable-line: undefined-field
                            out = Color.BNet
                        else
                            out = Color.WoW
                        end
                    end

                    if not out then
                        out = "ffffff"
                    end

                    return out

                end

                ---@param friendWrapper FriendWrapper
                ---@param text string
                ---@param content? string
                ---@param reverseLogic? boolean
                function Parse.Logic(friendWrapper, text, content, reverseLogic)

                    ---@type string|number|boolean|nil
                    local out

                    ---@type string[]
                    local fields = { strsplit("|", text) }

                    if not fields[1] then
                        fields = { text }
                    end

                    for i = 1, #fields do

                        local field = fields[i]
                        local value = friendWrapper.data[field] ---@type string|number|boolean|nil

                        if value ~= nil then

                            if field == "accountName" or field == "name" then

                                ---@diagnostic disable-next-line: undefined-field
                                local note = friendWrapper.data[
                                    friendWrapper.type == FRIENDS_BUTTON_TYPE_BNET and "note" or "notes"] ---@type string?
                                local alias = Parse.Note(note)

                                if alias then
                                    out = alias
                                end

                            end

                            if not out then
                                out = value
                            end

                            if (not out) or out == "" or out == 0 or out == "0" then
                                out = nil
                            end

                            if out ~= nil then
                                out = tostring(out)
                                break
                            end

                        end

                    end

                    if content and content ~= "" then
                        if reverseLogic then
                            if out ~= nil then
                                out = nil
                            else
                                out = content
                            end
                        end
                        if out ~= nil then
                            return Parse.Format(friendWrapper, content)
                        end
                        return ""
                    end

                    if out == nil then
                        return ""
                    elseif type(out) == "string" then
                        return out
                    else
                        return tostring(out)
                    end

                end

                ---@param friendWrapper FriendWrapper
                ---@param text string
                function Parse.Format(friendWrapper, text)

                    -- [=X|Y|Z|...]
                    for matched, logic in text:gmatch("(%[=(.-)%])") do
                        text = Util.SafeReplace(
                            text,
                            Util.EscapePattern(matched),
                            Parse.Logic(friendWrapper, logic)
                        )
                    end

                    -- [color=X]Y[/color]
                    for matched, blockText, content in text:gmatch("(%[[cC][oO][lL][oO][rR]=(.-)%](.-)%[%/[cC][oO][lL][oO][rR]%])") do
                        text = Util.SafeReplace(
                            text,
                            Util.EscapePattern(matched),
                            format("|cff%s%s|r", Parse.Color(friendWrapper, blockText),
                                Parse.Format(friendWrapper, content))
                        )
                    end

                    -- [if=X]Y[/if]
                    for matched, logic, content in text:gmatch("(%[[iI][fF]=(.-)%](.-)%[%/[iI][fF]%])") do
                        text = Util.SafeReplace(
                            text,
                            Util.EscapePattern(matched),
                            Parse.Logic(friendWrapper, logic, content)
                        )
                    end

                    -- [if~=X]Y[/if]
                    for matched, logic, content in text:gmatch("(%[[iI][fF][%~%!]=(.-)%](.-)%[%/[iI][fF]%])") do
                        text = Util.SafeReplace(
                            text,
                            Util.EscapePattern(matched),
                            Parse.Logic(friendWrapper, logic, content, true)
                        )
                    end

                    return text

                end

            end

            local Friends
            do

                ---@class BNetAccountInfoExtended : BNetGameAccountInfo, BNetAccountInfo
                ---@field bnet boolean
                ---@field isBNet boolean

                Friends = {}

                ---@param friendIndex number
                ---@param accountIndex number
                ---@param wowAccountGUID? string
                ---@return BNetAccountInfoExtended?
                function Friends.BNGetFriendGameAccountInfo(friendIndex, accountIndex, wowAccountGUID)
                    local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, accountIndex)
                    local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex, wowAccountGUID)
                    if not gameAccountInfo and not accountInfo then
                        return
                    end
                    return Util.MergeTable(gameAccountInfo or {}, accountInfo or {}) ---@diagnostic disable-line: return-type-mismatch
                end

                ---@param friendIndex number
                ---@param wowAccountGUID? string
                function Friends.BNGetFriendInfo(friendIndex, wowAccountGUID)
                    return C_BattleNet.GetFriendAccountInfo(friendIndex, wowAccountGUID)
                end

                ---@param id number
                ---@param wowAccountGUID? string
                function Friends.BNGetFriendInfoByID(id, wowAccountGUID)
                    return C_BattleNet.GetAccountInfoByID(id, wowAccountGUID)
                end

                ---@param friendIndex number
                function Friends.BNGetNumFriendGameAccounts(friendIndex)
                    return C_BattleNet.GetFriendNumGameAccounts(friendIndex)
                end

                ---@param query number|string
                function Friends.GetFriendInfo(query)
                    local info ---@type FriendInfo?
                    if type(query) == "number" then
                        info = C_FriendList.GetFriendInfoByIndex(query)
                    end
                    if type(query) == "string" then
                        info = C_FriendList.GetFriendInfo(query)
                    end
                    if not info then
                        return
                    end
                    Friends.AddFieldAlias(info)
                    return info
                end

                ---@param data BNetAccountInfoExtended|BNetAccountInfo
                ---@param id number
                function Friends.PackageFriendBNetCharacter(data, id)
                    for i = 1, Friends.BNGetNumFriendGameAccounts(id) do
                        local temp = Friends.BNGetFriendGameAccountInfo(id, i)
                        if temp and temp.clientProgram == _G.BNET_CLIENT_WOW then ---@diagnostic disable-line: undefined-field
                            for k, v in pairs(temp) do
                                data[k] = v
                            end
                            break
                        end
                    end
                    Friends.AddFieldAlias(data, true)
                    return data
                end

                ---@param data BNetAccountInfoExtended|BNetAccountInfo|FriendInfo
                ---@param isBNet? boolean
                function Friends.AddFieldAlias(data, isBNet)
                    ---@param ... string
                    ---@return string?, string?, string?
                    local function first(...)
                        local temp
                        for _, v in ipairs({ ... }) do
                            temp = data[v]
                            if temp ~= nil then
                                return temp, temp, temp
                            end
                        end
                        return temp, temp, temp
                    end

                    isBNet = not not isBNet
                    data.bnet = isBNet
                    data.isBNet = isBNet
                    -- data.name, data.characterName = first("characterName", "name") ---@diagnostic disable-line: assign-type-mismatch
                    data.level, data.characterLevel = first("characterLevel", "level") ---@diagnostic disable-line: assign-type-mismatch
                    data.class, data.className = first("className", "class") ---@diagnostic disable-line: assign-type-mismatch
                    data.race, data.raceName = first("raceName", "race") ---@diagnostic disable-line: assign-type-mismatch
                    data.faction, data.factionName = first("factionName", "faction") ---@diagnostic disable-line: assign-type-mismatch
                    data.area, data.areaName = first("areaName", "area") ---@diagnostic disable-line: assign-type-mismatch
                    data.connected, data.isOnline = first("isOnline", "connected") ---@diagnostic disable-line: assign-type-mismatch
                    data.mobile, data.isWowMobile = first("isWowMobile", "mobile") ---@diagnostic disable-line: assign-type-mismatch
                    data.afk, data.isAFK, data.isGameAFK = first("isGameAFK", "isAFK", "afk") ---@diagnostic disable-line: assign-type-mismatch
                    data.dnd, data.isDND, data.isGameBusy = first("isGameBusy", "isDND", "dnd") ---@diagnostic disable-line: assign-type-mismatch
                end

                ---@alias FriendType number `2`=`FRIENDS_BUTTON_TYPE_BNET` and `3`=`FRIENDS_BUTTON_TYPE_WOW`

                ---@class FriendWrapper
                ---@field public type FriendType
                ---@field public data? BNetAccountInfoExtended|BNetAccountInfo|FriendInfo

                ---@param buttonType FriendType
                ---@param id number
                ---@return FriendWrapper?
                function Friends.PackageFriend(buttonType, id)
                    local temp ---@type FriendWrapper
                    if buttonType == FRIENDS_BUTTON_TYPE_BNET then ---@diagnostic disable-line: undefined-field
                        temp = {
                            type = buttonType,
                            data = Friends.PackageFriendBNetCharacter(Friends.BNGetFriendInfo(id), id),
                        }
                    elseif buttonType == FRIENDS_BUTTON_TYPE_WOW then ---@diagnostic disable-line: undefined-field
                        temp = {
                            type = buttonType,
                            data = Friends.GetFriendInfo(id),
                        }
                    end
                    if not temp.data then
                        return
                    end
                    return temp
                end

                ---@param chatType ChatType
                ---@param name string
                ---@param lineID? number
                function Friends.GetAlias(chatType, name, lineID)
                    if chatType == "WHISPER" then
                        local friendInfo = Friends.GetFriendInfo(name)
                        if friendInfo then
                            local newName = Parse.Note(friendInfo.notes)
                            if newName then
                                return Util.SafeReplaceName(name, newName, lineID)
                            end
                        end
                    elseif chatType == "BN_WHISPER" then
                        local presenceID = GetAutoCompletePresenceID(name)
                        if presenceID then
                            local friendInfo = Friends.BNGetFriendInfoByID(presenceID)
                            if friendInfo then
                                local newName = Parse.Note(friendInfo.note)
                                if newName then
                                    return Util.SafeReplaceName(name, newName, lineID, presenceID)
                                end
                            end
                        end
                    end
                    return name
                end

                ---@param text string
                function Friends.ReplaceName(text)
                    if type(text) ~= "string" then
                        return text
                    end
                    return (
                        text:gsub("|HBNplayer:(.-)|h(.-)|h",
                            function(data, displayText) return format("|HBNplayer:%s|h%s|h", data,
                                (Friends.GetAlias("BN_WHISPER", displayText))) end))
                end

            end

            -- mutex lock when setting text to avoid recursion
            local isSettingText = false

            ---@class ListFrameButton : Button
            ---@field buttonType number
            ---@field id number
            ---@field gameIcon Texture
            ---@field name FontString

            ---@param self ListFrameButton
            ---@param ... any
            local function SetTextHook(self, ...)
                if isSettingText then
                    return
                end
                ---@diagnostic disable-next-line: assign-type-mismatch
                local button = self:GetParent() ---@type ListFrameButton
                local buttonType, id = button.buttonType, button.id
                if buttonType ~= FRIENDS_BUTTON_TYPE_BNET and buttonType ~= FRIENDS_BUTTON_TYPE_WOW then
                    return
                end
                local friendWrapper = Friends.PackageFriend(buttonType, id)
                if not friendWrapper then
                    return
                end
                -- button.gameIcon:SetTexture("Interface\\Buttons\\ui-paidcharactercustomization-button")
                -- button.gameIcon:SetTexCoord(8/128, 55/128, 72/128, 119/128)
                MAX_PLAYER_LEVEL_TABLE = {};
                MAX_PLAYER_LEVEL_TABLE[8] = 60
                MAX_PLAYER_LEVEL_TABLE[9] = 70
                maxLevel = MAX_PLAYER_LEVEL_TABLE[GetAccountExpansionLevel()]

                isSettingText = true
                if (tonumber(Parse.Format(friendWrapper, Config.level)) == maxLevel) then
                    self:SetText(Parse.Format(friendWrapper,
                        "[color=class][=accountName|name] [if=characterName][[=characterName]][/if][/color]"))
                else
                    self:SetText(Parse.Format(friendWrapper,
                        "[color=class][=accountName|name] [if=characterName][[=characterName][/if][if=level] - [=level]][/if][/color]"))
                end
                --print(Parse.Format(friendWrapper, Config.level))
                --self:SetText(Parse.Format(friendWrapper, Config.format))
                isSettingText = false
            end

            local HookButtons
            do
                ---@type table<ListFrameButton, boolean>
                local hookedButtons = {}
                ---@param buttons ListFrameButton[]
                function HookButtons(buttons)
                    for i = 1, #buttons do
                        local button = buttons[i]
                        if button.name and not hookedButtons[button] then
                            hookedButtons[button] = true
                            hooksecurefunc(button.name, "SetText", SetTextHook)
                        end
                    end
                end
            end

            ---@class ListFrame : Frame
            ---@field ScrollBox? ScrollFrame
            ---@field buttons? ListFrameButton[]

            ---@type ListFrame
            local scrollFrame = _G.FriendsListFrameScrollFrame or _G.FriendsFrameFriendsScrollFrame or
                _G.FriendsListFrame ---@diagnostic disable-line: undefined-field

            if scrollFrame.ScrollBox then
                scrollFrame.ScrollBox:GetView():RegisterCallback(_G.ScrollBoxListMixin.Event.OnAcquiredFrame,
                    function(_, button, created) if created then HookButtons({ button }) end end) ---@diagnostic disable-line: undefined-field
            end

            if scrollFrame.buttons then
                HookButtons(scrollFrame.buttons)
            end
        end

        FriendsListByClassColor_Update()
    end
end
