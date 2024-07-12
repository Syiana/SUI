SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
local addonName, addon = ...

DisableAddOn('LortiUI')
DisableAddOn('UberUI')

local defaults = {
    profile = {
        install = false,
        general = {
            theme = 'Dark',
            font = [[Interface\AddOns\SUI\Media\Fonts\Prototype.ttf]],
            texture = [[Interface\AddOns\SUI\Media\Textures\Status\Smooth]],
            color = { r = 0, g = 0, b = 0, a = 1 },
            automation = {
                delete = true,
                decline = false,
                repair = true,
                sell = true,
                invite = false,
                release = false,
                resurrect = false,
                cinematic = false
            },
            cosmetic = {
                afkscreen = true,
                errors = false,
                talkhead = false,
            },
            display = {
                fps = true,
                ms = true
            }
        },
        unitframes = {
            style = 'Big',
            portrait = 'Default',
            classcolor = true,
            factioncolor = true,
            statusglow = false,
            pvpbadge = false,
            combaticon = false,
            hitindicator = false,
            links = false,
            size = 1,
            textsize = 11,
            player = {
                size = 1
            },
            target = {
                size = 1
            },
            buffs = {
                size = 26
            },
            debuffs = {
                size = 20,
                debufftype = false
            }
        },
        raidframes = {
            texture = [[Interface\AddOns\SUI\Media\Textures\Status\Flat]],
        },
        nameplates = {
            style = 'Default',
            texture = [[Interface\AddOns\SUI\Media\Textures\Status\Flat]],
            health = true,
            casttime = true,
            classcolor = true,
            totems = true,
            highlight = false
        },
        actionbar = {
            style = 'Default',
            buttons = {
                key = true,
                macro = false,
                range = true,
                flash = false,
                size = 38,
                padding = 5
            },
            micromenu = 'mouseover',
            bagbuttons = 'mouseover',
            mouseover = {
                bar3 = false,
                bar4 = false,
                bar5 = false,
                stancebar = false
            },
            gryphones = true,
            bindings = false,
        },
        castbars = {
            style = 'Custom',
            timer = true,
            icon = true,
        },
        tooltip = {
            style = 'Custom',
            lifeontop = true,
            mouseanchor = false
        },
        buffs = {
            fading = false,
            debufftype = false,
            buff = {
                size = 32,
                padding = 2,
                icons = 10
            },
            debuff = {
                size = 34,
                padding = 2,
                icons = 10
            }
        },
        chat = {
            style = 'Custom',
            top = true,
            link = true,
            copy = true,
            friendlist = true,
            quickjoin = true,
            outline = true,
        },
        maps = {
            coords = true,
            minimap = true,
            clock = true,
        },
        misc = {
            tabbinder = false,
            interrupt = false,
            fastloot = false,
            searchbags = false,
            sortbags = false,
            expbar = true,
        },
        modules = {
            general = true,
            unitframes = true,
            nameplates = true,
            actionbar = true,
            castbars = true,
            tooltip = true,
            buffs = true,
            map = true,
            chat = true,
            misc = true
        },
        new_version = false,
        edit = {}
    }
}

function SUI:OnInitialize()
    -- SUI 8.0
    if (SUIDB and SUIDB.A_DEFAULTS) then
        SUIDB = {}
        print(
            '|cffff00d5S|r|cff027bffUI|r: |cffff0000You had a broken database from a previous version of SUI, unfortunately we had to reset the profile.|r')
    end

    -- Database
    self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)

    -- Colors
    local _, class = UnitClass("player")
    local classColor = RAID_CLASS_COLORS[class]
    local customColor = self.db.profile.general.color
    local module = self.db.profile.modules.general
    local themes = {
        Blizzard = nil,
        Dark = { 0.3, 0.3, 0.3 },
        Class = { classColor.r, classColor.g, classColor.b },
        Custom = { customColor.r, customColor.g, customColor.b },
    }
    local theme = themes[self.db.profile.general.theme]


    self.Theme = {
        Register = function(n, f)
            --print('register')
            --if (self.Theme.Frames[n]) then f(true, self.Theme.Data) end
        end,
        Update = function()
            -- print("update")
            for n, f in pairs(self.Theme.Frames) do
                -- print(n)
                f(false, self.Theme.Data)
            end
        end,
        Data = function()
            local themes = {
                Blizzard = nil,
                Dark = { 0.3, 0.3, 0.3 },
                Class = { classColor.r, classColor.g, classColor.b },
                Custom = { customColor.r, customColor.g, customColor.b },
            }
            local theme = themes[self.db.profile.general.theme]
            return {
                style = self.db.profile.general.theme,
                color = self.db.profile.general.color
            }
        end,
        Frames = {
            Tooltip = function() end
        }
    }

    function self:Color(sub, alpha)
        if (theme and module) then
            if not (alpha) then alpha = 1 end
            local color = { 0, 0, 0, alpha }
            for key, value in pairs(theme) do
                if (sub) then color[key] = value - sub else color[key] = value end
            end
            return color
        end
    end

    function self:Skin(frame, customColor, isTable, color, desaturated)
        local forbiddenFrames = {
            ["FriendsFrameIcon"] = true, ["TradeSkillFramePortrait"] = true,
            ["CollectionsJournalPortrait"] = true, ["AuctionPortraitTexture"] = true,
            ["ArchaeologyFramePortrait"] = true, ["ArchaeologyFrameBgLeft"] = true,
            ["ContainerFrame2Portrait"] = true, ["ContainerFrame3Portrait"] = true,
            ["ContainerFrame4Portrait"] = true, ["ContainerFrame5Portrait"] = true,
            ["ContainerFrame6Portrait"] = true, ["ContainerFrame7Portrait"] = true,
            ["ContainerFrame8Portrait"] = true, ["ContainerFrame9Portrait"] = true,
            ["ContainerFrame10Portrait"] = true, ["ContainerFrame11Portrait"] = true,
            ["ContainerFrame12Portrait"] = true, ["BankPortraitTexture"] = true,
            ["CharacterFramePortrait"] = true, ["ClassTrainerFramePortrait"] = true,
            ["CommunitiesFrame.PortraitOverlay.Portrait"] = true, ["InspectFramePortrait"] = true,
            ["InspectHeadSlotIconTexture"] = true, ["InspectNeckSlotIconTexture"] = true,
            ["InspectShoulderSlotIconTexture"] = true, ["InspectBackSlotIconTexture"] = true,
            ["InspectChestSlotIconTexture"] = true, ["InspectShirtSlotIconTexture"] = true,
            ["InspectTabardSlotIconTexture"] = true, ["InspectWristSlotIconTexture"] = true,
            ["InspectHandsSlotIconTexture"] = true, ["InspectWaistSlotIconTexture"] = true,
            ["InspectLegsSlotIconTexture"] = true, ["InspectFeetSlotIconTexture"] = true,
            ["InspectFinger0SlotIconTexture"] = true, ["InspectFinger1SlotIconTexture"] = true,
            ["InspectTrinket0SlotIconTexture"] = true, ["InspectTrinket1SlotIconTexture"] = true,
            ["InspectMainHandSlotIconTexture"] = true, ["InspectSecondarySlotIconTexture"] = true,
            ["InspectSecondaryHandSlotIconTexture"] = true, ["InspectRangedSlotIconTexture"] = true,
            ["GossipFrame.ParchmentFrame"] = true, ["QuestFrameDetailPanel.ParchmentFrame"] = true,
            ["QuestFrameRewardPanel.ParchmentFrame"] = true, ["QuestFrameProgressPanel.ParchmentFrame"] = true,
            ["QuestFrameGreetingPanel.ParchmentFrame"] = true, ["QuestLogFrame.ParchmentFrame"] = true,
            ["QuestLogDetailFrameBackgroundTopLeft"] = true, ["QuestLogDetailFrameBackgroundTopRight"] = true,
            ["QuestLogDetailFrameBackgroundBottomLeft"] = true, ["QuestLogDetailFrameBackgroundBottomRight"] = true,
            ["QuestFramePortrait"] = true, ["PlayerTalentFramePortrait"] = true,
            ["PVPFramePortrait"] = true, ["PVEFramePortrait"] = true,
            ["EncounterJournalPortrait"] = true, ["ChannelFrame.Icon"] = true,
            ["SpellBookFramePortrait"] = true, ["MicroButtonPortrait"] = true,
            ["SpellbookMicroButton.NormalTexture"] = true, ["AchievementFrameHeaderShield"] = true,
            ["MerchantFramePortrait"] = true, ["TimeManagerGlobe"] = true,
            ["MacroFramePortrait"] = true, ["OpenMailFrameIcon"] = true,
            ["ChatFrame1Background"] = true, ["ChatFrame2Background"] = true,
            ["ChatFrame3Background"] = true, ["ChatFrame4Background"] = true,
            ["ChatFrame5Background"] = true, ["ChatFrame6Background"] = true,
            ["ChatFrame7Background"] = true, ["ChatFrame8Background"] = true,
            ["ChatFrame9Background"] = true, ["ChatFrame10Background"] = true,
            ["ReforgingFramePortrait"] = true, ["SpellBookSkillLineTab1.Portrait"] = true,
            ["TradeFrameRecipientPortrait"] = true, ["TradeFramePlayerPortrait"] = true,
            ["DressUpFramePortrait"] = true, ["ReadyCheckPortrait"] = true,
            ["ItemSocketingFramePortrait"] = true, ["FriendsFrameStatusDropDownStatus"] = true,
            ["WardrobeFramePortrait"] = true, ["TaxiPortrait"] = true,
            ["TaxiMap"] = true, ["TabardFramePortrait"] = true,
            ["TabardFrameEmblemTopLeft"] = true, ["TabardFrameEmblemTopRight"] = true,
            ["TabardFrameEmblemBottomLeft"] = true, ["TabardFrameEmblemBottomRight"] = true,
            ["GuildRegistrarFramePortrait"] = true, ["PetitionFramePortrait"] = true,
            ["LootFramePortraitOverlay"] = true, ["CalendarCreateEventIcon"] = true,
            ["StaticPopup1AlertIcon"] = true, ["PVPConquestFrameInfoButtonInfoIconAlliance"] = true,
            ["PVPConquestFrameInfoButtonInfoIconHorde"] = true, ["ContainerFrame1Portrait"] = true,
            ["CharacterHeadSlotSubIconTexture"] = true, ["CharacterShouldersSlotSubIconTexture"] = true,
            ["CharacterNeckSlotSubIconTexture"] = true, ["CharacterBackSlotSubIconTexture"] = true,
            ["CharacterChestSlotSubIconTexture"] = true, ["CharacterWristSlotSubIconTexture"] = true,
            ["CharacterHandsSlotSubIconTexture"] = true, ["CharacterWaistSlotSubIconTexture"] = true,
            ["CharacterLegsSlotSubIconTexture"] = true, ["CharacterFeetSlotSubIconTexture"] = true,
            ["CharacterFinger0SlotSubIconTexture"] = true, ["CharacterFinger1SlotSubIconTexture"] = true,
            ["HonorFramePvPIcon"] = true,
            [select(1,QuestLogFrame:GetRegions())] = true, [select(18, MailFrame:GetRegions())] = true,
            [select(2, SpellBookSkillLineTab1:GetRegions())] = true, [select(2, SpellBookSkillLineTab2:GetRegions())] = true,
            [select(2, SpellBookSkillLineTab3:GetRegions())] = true, [select(2, SpellBookSkillLineTab4:GetRegions())] = true,
            [select(1, ItemTextFrame:GetRegions())] = true, [select(6, SendMailMoneyGold:GetRegions())] = true,
            [select(6, SendMailMoneySilver:GetRegions())] = true, [select(6, SendMailMoneyCopper:GetRegions())] = true,
            [select(18, ChannelFrame:GetRegions())] = true, [select(1, SpellBookFrame:GetRegions())] = true,
            [select(2, QuestLogFrame:GetRegions())] = true,
        }

        if (frame) then
            if not (isTable) then
                for _, v in pairs({ frame:GetRegions() }) do
                    if (not forbiddenFrames[v:GetName()]) and (not forbiddenFrames[v]) then
                        if v:GetObjectType() == "Texture" then
                            if (color) then
                                v:SetVertexColor(color.r, color.g, color.b)
                                v:SetDesaturated(1)
                            elseif (customColor) then
                                v:SetVertexColor(unpack(SUI:Color(.15)))
                            else
                                v:SetVertexColor(.15, .15, .15)
                            end
                        end
                    end
                end
            else
                for _, v in pairs(frame) do
                    if (v) then
                        if (customColor) then
                            v:SetVertexColor(unpack(SUI:Color(.15)))
                        elseif (desaturated) then
                            v:SetDesaturated(true)
                            v:SetVertexColor(1,1,1)
                        else
                            v:SetVertexColor(.15, .15, .15)
                        end
                    end
                end
            end
        end
    end

    -- Item Informations
    local simpleTypes = {
        enchantID  = 2,
        socket1    = 3,
        socket2    = 4,
        socket3    = 5
    }

    GetEnchantNameByID = {
        -- Weapon
        [4227] = "130 Agi",
        [4067] = "Avalanche",
        [4074] = "Ele Slayer",
        [4084] = "Heartsong",
        [4083] = "Hurricane",
        [4099] = "Landslide",
        [4066] = "Mending",
        [4097] = "Power Torrent",
        [4098] = "Windwalk",
        [4175] = "Gnomish X-Scope",
        [4217] = "Pyrium Weapon",
        [3827] = "110 AP",
        [3830] = "50 Spellpower",
        [3368] = "Fallen Crusader",
        [3369] = "Cinderglacier",
        [3370] = "Razorice",
        [3595] = "Spellbreaking",
        [3367] = "Spellshattering",
        [3366] = "Lichbane",
        [3594] = "Swordbreaking",
        [3365] = "Swordshattering",
        [3847] = "Stoneskin Gargoyle",
        [3789] = "Berserking",
        [3869] = "Blade Ward",
        [3870] = "Blood Draining",
        [3834] = "63 Spellpower",
        [3790] = "Black Magic",
        [3854] = "81 Spellpower",
        [3788] = "Accuracy",
        [3239] = "Icebreaker",
        [3241] = "Lifeward",
        [1103] = "26 Agi",
        [3833] = "65 AP",
        [3844] = "45 Spirit",
        [3251] = "Giantslaying",
        [3247] = "Scourgebane",
        [3828] = "85 AP",

        -- Feet
        [4105] = "Agi & Speed",
        [4062] = "Stam & Speed",
        [4069] = "50 Haste",
        [4104] = "Mastery & Speed",
        [4076] = "35 Agi",
        [4094] = "50 Mastery",
        [4092] = "50 Hit",
        [3232] = "Stam & Speed",
        [1597] = "32 AP",
        [983] = "16 Agi",

        -- Bracer
        [4071] = "50 Crit",
        [4086] = "50 Dodge",
        [4093] = "50 Spirit",
        [4101] = "65 Crit",
        [4095] = "50 Ept",
        [4108] = "65 Haste",
        [4089] = "50 Hit",
        [4065] = "50 Haste",
        [4258] = "50 Agi",
        [4257] = "50 Int",
        [4256] = "50 Str",
        [4107] = "65 Mastery",
        [4189] = "195 Stam",
        [3850] = "40 Stam",
        [3845] = "50 AP",
        [2332] = "30 Spellpower",
        [3851] = "Titanguard",
        [3231] = "15 Ept",
        [1147] = "18 Spirit",
        [2661] = "6 Stats",
        [4190] = "130 Agi",
        [4191] = "130 Str",
        [4192] = "130 Int",

        -- Chest
        [4088] = "40 Spirit",
        [4103] = "75 Stam",
        [4077] = "40 Resi",
        [4063] = "15 Stats",
        [4102] = "20 Stats",
        [4070] = "55 Stam",
        [3832] = "+10 Stats",
        [3245] = "20 Resi",
        [1953] = "22 Def",

        -- Cloak
        [4100] = "65 Crit",
        [4087] = "50 Crit",
        [4096] = "50 Int",
        [4064] = "70 SP",
        [4072] = "30 Int",
        [4090] = "250 Armor",
        [4116] = "Spirit Procc",
        [4115] = "Int Procc",
        [4118] = "AP Procc",
        [1099] = "22 Agi",
        [3831] = "23 Haste",
        [3294] = "225 Armor",
        [3230] = "20 Frost Res",
        [1951] = "16 Def",
        [1354] = "20 Fire Res",
        [1262] = "20 Arcane Resi",
        [3256] = "Stealth & 10 Agi",
        [1446] = "20 Shadow Resi",
        [1400] = "20 Nature Resi",
        [3296] = "10 Spirit",


        -- Hands
        [4075] = "35 Str",
        [4082] = "50 Ept",
        [4068] = "50 Haste",
        [4061] = "50 Mastery",
        [4106] = "50 Str",
        [3253] = "Armsman",
        [846] = "5 Fishing",
        [3249] = "16 Crit",
        [3829] = "35 AP",
        [3222] = "20 Agi",

        -- Off-hands
        [4091] = "40 Int",
        [4085] = "50 Mastery",
        [4073] = "160 Armor",

        -- Head
        [4207] = "60 Int & 35 Crit",
        [4206] = "90 Stam & 35 D+",
        [4208] = "60 Str & 35 Mastery",
        [4245] = "60 Int & 35 Resi",
        [4209] = "60 Agi & 35 Haste",
        [4246] = "60 Agi & 35 Resi",
        [4247] = "60 Str & 35 Resi",

        -- Shoulders
        [4200] = "50 Int & 25 Haste",
        [4204] = "50 Agi & 25 Mastery",
        [4202] = "50 Str & 25 Crit",
        [4198] = "75 Stam & 25 D+",
        [4248] = "50 Int & 25 Resi",
        [4250] = "50 Agi & 25 Resi",
        [4249] = "50 Str & 25 Resi",
        [4199] = "30 Int & 20 Haste",
        [4197] = "45 Stam & 20 D+",
        [4201] = "30 Str & 20 Crit",
        [4205] = "30 Agi & 20 Mastery",
        [4196] = "130 Int & 25 Haste",
        [4193] = "130 Agi & 25 Mastery",
        [4194] = "130 Str & 25 Crit",
        [4195] = "195 Stam & 25 Dodge",

        -- Legs
        [4110] = "95 Int & 55 Spirit",
        [4114] = "95 Int & 55 Spirit",
        [4112] = "95 Int & 80 Stam",
        [4113] = "95 Int & 80 Stam",
        [4109] = "55 Int & 45 Spirit",
        [4126] = "190 AP & 55 Crit",
        [4270] = "145 Stam & 55 D+",
        [4124] = "85 Stam & 45 Agi",
        [4122] = "110 AP & 45 Crit",
        [4127] = "145 Stam & 55 Agi",

        -- Ring
        [4078] = "40 Str",
        [4080] = "40 Int",
        [4081] = "60 Stam",
        [4079] = "40 Agi",

        -- Armor Kits
        [4121] = "+44 Stam",

        -- Engineering
        [4179] = "Synapse",
        [4180] = "Quickflip",
        [4181] = "Tazik Shock",
        [4182] = "Spinal",
        [4183] = "Z50 Mana"
    }

    local itemSlots = {
        -- Left Side
        [1] = true,
        [2] = false,
        [3] = true,
        [15] = true,
        [5] = true,
        [9] = true,

        -- Right Side
        [10] = true,
        [6] = false,
        [7] = true,
        [8] = true,
        [11] = true,
        [12] = true,
        [13] = false,
        [14] = false,

        -- Weapons
        [16] = true,
        [17] = true,
        [18] = true
    }

    function ParseItemLink(link)
        local _, linkOptions = LinkUtil.ExtractLink(link)
        local item = { strsplit(":", linkOptions) }
        local t = {}

        for k, v in pairs(simpleTypes) do
            t[k] = tonumber(item[v])
        end

        for i = 1, 4 do
            local gem = tonumber(item[i + 2])
            if gem then
                t.gems = t.gems or {}
                t.gems[i] = gem
            end
        end

        local idx = 13
        local numBonusIDs = tonumber(item[idx])
        if numBonusIDs then
            t.bonusIDs = {}
            for i = 1, numBonusIDs do
                t.bonusIDs[i] = tonumber(item[idx + i])
            end
        end
        idx = idx + (numBonusIDs or 0) + 1

        local numModifiers = tonumber(item[idx])
        if numModifiers then
            t.modifiers = {}
            for i = 1, numModifiers do
                local offset = i * 2
                t.modifiers[i] = {
                    tonumber(item[idx + offset - 1]),
                    tonumber(item[idx + offset])
                }
            end
            idx = idx + numModifiers * 2 + 1
        else
            idx = idx + 1
        end

        for i = 1, 3 do
            local relicNumBonusIDs = tonumber(item[idx])
            if relicNumBonusIDs then
                t.relicBonusIDs = t.relicBonusIDs or {}
                t.relicBonusIDs[i] = {}
                for j = 1, relicNumBonusIDs do
                    t.relicBonusIDs[i][j] = tonumber(item[idx + j])
                end
            end
            idx = idx + (relicNumBonusIDs or 0) + 1
        end

        local crafterGUID = item[idx]
        if #crafterGUID > 0 then
            t.crafterGUID = crafterGUID
        end
        idx = idx + 1

        t.extraEnchantID = tonumber(item[idx])

        return t
    end

    SocketTextureCache = {}

    function SocketTexture(id)
        if SocketTextureCache[id] then
            return SocketTextureCache[id]
        else
            local name, _, _, _, _, _, _, _, _, iconTexture = GetItemInfo(id)
            if iconTexture then
                iconTexture = "\124T"..iconTexture..":0\124t"
                SocketTextureCache[id] = iconTexture
                return iconTexture
            end
        end
    end

    EmptySocketTextures = {
        ["EMPTY_SOCKET_META"]       = 136257,
        ["EMPTY_SOCKET_BLUE"]       = 136256,
        ["EMPTY_SOCKET_RED"]        = 136258,
        ["EMPTY_SOCKET_YELLOW"]     = 136259,
        ["EMPTY_SOCKET_PRISMATIC"]  = 458977,
        ["EMPTY_SOCKET_COGWHEEL"]   = 407324
    }

    function EmptySockets(itemLink)
        local stats = GetItemStats(itemLink)
        local sockets = {}
        if stats ~= nil then
            for key, val in pairs(stats) do
                if (string.find(key, "EMPTY_SOCKET_")) then
                    table.insert(sockets, key)
                end
            end
        end

        if (sockets[1] == "EMPTY_SOCKET_YELLOW" and sockets[2] == "EMPTY_SOCKET_META") then
            sockets[1] = "EMPTY_SOCKET_META"
            sockets[2] = "EMPTY_SOCKET_YELLOW"
        end
        return sockets
    end

    function NoEnchantText(itemLink, slotID, isPlayer, unit)
        local _, _, _, _, _, _, itemType = GetItemInfo(itemLink)
        local prof1, prof2 = GetProfessions()
        if (itemSlots[slotID]) then
            if (slotID == 11 or slotID == 12) then
                if (isPlayer and (prof1 and prof1 == 6 or prof2 and prof2 == 6)) then
                    local _, _, skill  = GetProfessionInfo(6)

                    if (skill >= 475) then
                        return true
                    end
                end
            elseif (slotID == 18 ) then
                if (unit) then
                    local _, class = UnitClass(unit)
                    if (class == "HUNTER" and (itemType == "Guns" or itemType == "Guns" or itemType == "Crossbows")) then
                        return true
                    end
                end
            else
                return true
            end
        else
            return false
        end
    end

    -- SUI Version check
    local currentVersion = C_AddOns.GetAddOnMetadata(addonName, "Version")

    local function GetDefaultCommChannel()
        if IsInRaid() then
            return IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID"
        elseif IsInGroup() then
            return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY"
        elseif IsInGuild() then
            return "GUILD"
        else
            return "YELL"
        end
    end

    function self:ReceiveVersion(_, version, _, sender)
        if not SUI.db.profile.new_version then
            if (version > currentVersion) then
                print("|cffff00d5S|r|cff027bffUI|r:", "A newer version is available. If you experience any errors or bugs, updating is highly recommended.")

                SUI.db.profile.new_version = version
            end
        elseif (SUI.db.profile.new_version == currentVersion) or (SUI.db.profile.new_version <= currentVersion) then
            SUI.db.profile.new_version = false
        end
    end

    function self:SendVersion(channel)
        self:SendCommMessage("SUIVersion", currentVersion, channel or GetDefaultCommChannel())
    end

    self:RegisterComm("SUIVersion", "ReceiveVersion")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", function()
        self:SendVersion()
        if IsInGuild() then self:SendVersion("GUILD") end
    end)
    C_Timer.After(30, function()
        self:SendVersion()
        if IsInGuild() then self:SendVersion("GUILD") end
        self:SendVersion("YELL")
    end)

    if (SUI.db.profile.new_version and SUI.db.profile.new_version > currentVersion) then
        print("|cffff00d5S|r|cff027bffUI|r:", "A newer version is available. If you experience any errors or bugs, updating is highly recommended.")
    end
end
