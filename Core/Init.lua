SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0")

DisableAddOn('LortiUI')
DisableAddOn('UberUI')

local defaults = {
    profile = {
        install = false,
        general = {
            theme = 'Dark',
            font = 'Interface\\AddOns\\SUI\\Media\\Fonts\\Prototype.ttf',
            texture = 'Interface\\AddOns\\SUI\\Media\\Textures\\Status\\Smooth',
            color = {},
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
                talkhead = false,
            },
            display = {
                ilvl = true,
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
            player = {
                size = 1
            },
            target = {
                size = 1
            },
            buffs = {
                size = 26,
                purgeborder = true
            },
            debuffs = {
                size = 20
            }
        },
        raidframes = {
            texture = 'Interface\\AddOns\\SUI\\Media\\Textures\\Status\\Flat',
            alwaysontop = false
        },
        nameplates = {
            style = 'Custom',
            texture = 'Interface\\AddOns\\SUI\\Media\\Textures\\Status\\Flat',
            arena = true,
            health = true,
            casttime = true,
            classcolor = true,
            totems = true,
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
            menu = {
                style = 'Default',
                mouseovermicro = false,
                mouseoverbags = false,
            },
            mouseover = {
                bar3 = false,
                bar4 = false,
                bar5 = false,
                stancebar = false
            },
            gryphones = true,
        },
        castbars = {
            style = 'Custom',
            timer = true,
            icon = true,
            target = false
        },
        tooltip = {
            style = 'Custom',
            lifeontop = true,
            mouseanchor = false
        },
        buffs = {
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
            quickjoin = true
        },
        maps = {
            style = 'Default',
            small = false,
            opacity = false,
            coords = true,
            minimap = true,
            clock = true,
            date = false,
            garrison = true,
            tracking = false,
        },
        misc = {
            safequeue = true,
            losecontrol = true,
            tabbinder = false,
            pulltimer = false,
            interrupt = false,
            dampening = true,
            arenanameplate = false,
            surrender = false
        },
        edit = {}
    }
}

function SUI:OnInitialize()
    -- SUI 8.0
    if (SUIDB and SUIDB.A_DEFAULTS) then
        SUIDB = {}
        print(
            '|cfff58cbaS|r|cff009cffUI|r: |cffff0000You had a broken database from a previous version of SUI, unfortunately we had to reset the profile.|r')
    end

    -- Database
    self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)

    -- Colors
    local _, class = UnitClass("player")
    local classColor = RAID_CLASS_COLORS[class]
    local customColor = self.db.profile.general.color
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
        if (theme) then
            if not (alpha) then alpha = 1 end
            local color = { 0, 0, 0, alpha }
            for key, value in pairs(theme) do
                if (sub) then color[key] = value - sub else color[key] = value end
            end
            return color
        end
    end

    function self:Skin(frame, customColor, isTable)
        local forbiddenFrames = {
            ["FriendsFrameIcon"] = true,
            ["TradeSkillFramePortrait"] = true,
            ["CollectionsJournalPortrait"] = true,
            ["AuctionPortraitTexture"] = true,
            ["ArchaeologyFramePortrait"] = true,
            ["ArchaeologyFrameBgLeft"] = true,
            ["ContainerFrame2Portrait"] = true,
            ["ContainerFrame3Portrait"] = true,
            ["ContainerFrame4Portrait"] = true,
            ["ContainerFrame5Portrait"] = true,
            ["BankPortraitTexture"] = true,
            ["CharacterFramePortrait"] = true,
            ["ClassTrainerFramePortrait"] = true,
            ["CommunitiesFrame.PortraitOverlay.Portrait"] = true,
            ["InspectFramePortrait"] = true,
            ["InspectHeadSlotIconTexture"] = true,
            ["InspectNeckSlotIconTexture"] = true,
            ["InspectShoulderSlotIconTexture"] = true,
            ["InspectBackSlotIconTexture"] = true,
            ["InspectChestSlotIconTexture"] = true,
            ["InspectShirtSlotIconTexture"] = true,
            ["InspectTabardSlotIconTexture"] = true,
            ["InspectWristSlotIconTexture"] = true,
            ["InspectHandsSlotIconTexture"] = true,
            ["InspectWaistSlotIconTexture"] = true,
            ["InspectLegsSlotIconTexture"] = true,
            ["InspectFeetSlotIconTexture"] = true,
            ["InspectFinger0SlotIconTexture"] = true,
            ["InspectFinger1SlotIconTexture"] = true,
            ["InspectTrinket0SlotIconTexture"] = true,
            ["InspectTrinket1SlotIconTexture"] = true,
            ["InspectMainHandSlotIconTexture"] = true,
            ["InspectSecondarySlotIconTexture"] = true,
            ["InspectSecondaryHandSlotIconTexture"] = true,
            ["InspectRangedSlotIconTexture"] = true,
            ["GossipFrame.ParchmentFrame"] = true,
            ["QuestFrameDetailPanel.ParchmentFrame"] = true,
            ["QuestFrameRewardPanel.ParchmentFrame"] = true,
            ["QuestFrameProgressPanel.ParchmentFrame"] = true,
            ["QuestFrameGreetingPanel.ParchmentFrame"] = true,
            ["QuestLogFrame.ParchmentFrame"] = true,
            ["QuestLogDetailFrameBackgroundTopLeft"] = true,
            ["QuestLogDetailFrameBackgroundTopRight"] = true,
            ["QuestLogDetailFrameBackgroundBottomLeft"] = true,
            ["QuestLogDetailFrameBackgroundBottomRight"] = true,
            ["QuestFramePortrait"] = true,
            ["PlayerTalentFramePortrait"] = true,
            ["PVPFramePortrait"] = true,
            ["PVEFramePortrait"] = true,
            ["EncounterJournalPortrait"] = true,
            ["ChannelFrame.Icon"] = true,
            ["SpellBookFramePortrait"] = true,
            ["MicroButtonPortrait"] = true,
            ["SpellbookMicroButton.NormalTexture"] = true,
            ["AchievementFrameHeaderShield"] = true,
            ["MerchantFramePortrait"] = true,
            ["TimeManagerGlobe"] = true,
            ["MacroFramePortrait"] = true,
            ["OpenMailFrameIcon"] = true,
            ["ChatFrame1Background"] = true,
            ["ChatFrame2Background"] = true,
            ["ChatFrame3Background"] = true,
            ["ChatFrame4Background"] = true,
            ["ChatFrame5Background"] = true,
            ["ChatFrame6Background"] = true,
            ["ChatFrame7Background"] = true,
            ["ChatFrame8Background"] = true,
            ["ChatFrame9Background"] = true,
            ["ChatFrame10Background"] = true,
            ["ReforgingFramePortrait"] = true,
            ["SpellBookSkillLineTab1.Portrait"] = true,
            ["TradeFrameRecipientPortrait"] = true,
            ["TradeFramePlayerPortrait"] = true
        }

        if (frame) then
            if (isTable) then
                for _, v in pairs(frame) do
                    if (customColor) then
                        v:SetVertexColor(unpack(SUI:Color(.15)))
                    else
                        v:SetVertexColor(.15, .15, .15)
                    end
                end
            else
                for _, v in pairs({ frame:GetRegions() }) do
                    if v:GetObjectType() == "Texture" then
                        if not (forbiddenFrames[v:GetName()]) then
                            if (customColor) then
                                v:SetVertexColor(unpack(SUI:Color(.15)))
                            else
                                v:SetVertexColor(.15, .15, .15)
                            end
                        end
                    end
                end
            end
        end
    end
end
