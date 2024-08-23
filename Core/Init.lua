SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0")

C_AddOns.DisableAddOn('LortiUI')
C_AddOns.DisableAddOn('UberUI')

local defaults = {
    profile = {
        install = false,
        reset = false,
        general = {
            theme = 'Dark',
            font = [[Interface\Addons\SUI\Media\Fonts\Prototype.ttf]],
            texture = [[Interface\Addons\SUI\Media\Textures\Status\Smooth.blp]],
            color = { r = 0, g = 0, b = 0, a = 1 },
            automation = {
                delete = true,
                decline = false,
                repair = 'Default',
                sell = true,
                stackbuy = true,
                invite = false,
                release = false,
                resurrect = false,
                cinematic = false
            },
            cosmetic = {
                afkscreen = true,
                talkhead = false,
                errors = false
            },
            display = {
                ilvl = true,
                fps = true,
                ms = true
            }
        },
        unitframes = {
            style = 'Default',
            classcolor = true,
            factioncolor = true,
            pvpbadge = false,
            combaticon = false,
            hitindicator = false,
            totemicons = true,
            classbar = true,
            cornericon = true,
            level = true,
            player = {
                size = 1
            },
            target = {
                size = 1
            },
            buffs = {
                size = 26,
                collapse = false
            },
            debuffs = {
                size = 20
            }
        },
        nameplates = {
            style = 'Default',
            texture = [[Interface\Addons\SUI\Media\Textures\Status\Smooth.blp]],
            arenanumber = true,
            totemicons = true,
            healthtext = true,
            server = true,
            color = true,
            casttime = true,
            stackingmode = false,
            height = 2,
            width = 1,
            debuffs = false
        },
        raidframes = {
            texture = [[Interface\Addons\SUI\Media\Textures\Status\Flat.blp]],
            alwaysontop = false,
            size = false,
            height = 75,
            width = 100,
        },
        actionbar = {
            buttons = {
                key = true,
                macro = true,
                range = true,
                flash = false,
                size = 12
            },
            menu = {
                micromenu = 'show',
                bagbar = 'show'
            },
            bars = {
                bar1 = false,
                bar2 = false,
                bar3 = false,
                bar4 = false,
                bar5 = false,
                bar6 = false,
                bar7 = false,
                bar8 = false,
                petbar = false,
                stancebar = false
            }
        },
        castbars = {
            style = 'Custom',
            timer = true,
            icon = true,
            targetCastbar = true,
            focusCastbar = true,
            focusSize = 1,
            targetSize = 1,
            targetOnTop = false,
            focusOnTop = false
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
            quickjoin = true,
            looticons = true,
            roleicons = true
        },
        maps = {
            minimapsize = 1,
            style = 'Default',
            small = false,
            opacity = 1,
            coords = true,
            minimap = true,
            clock = true,
            date = false,
            garrison = true,
            tracking = false,
            buttons = true,
            expansionbutton = false,
        },
        misc = {
            safequeue = true,
            tabbinder = false,
            pulltimer = false,
            interrupt = false,
            dampening = true,
            arenanameplate = false,
            surrender = false,
            losecontrol = false,
            repbar = false,
            menubutton = true,
        },
        edit = {
            statsframe = {
                point = 'BOTTOMLEFT',
                x = 5,
                y = 3
            },
            queueicon = {
                point = 'CENTER',
                x = 0,
                y = 0
            },
            micromenu = {
                point = 'BOTTOMRIGHT',
                x = 0,
                y = 0
            },
            bagbar = {
                point = 'BOTTOMRIGHT',
                x = 0,
                y = 50
            }
        },
    }
}

function SUI:OnInitialize()
    -- SUI DB Reset 10.0
    -- Also check _Install.lua for the next reset!
    if (SUIDB and not SUIDB.profiles.Default.reset) then
        SUIDB = {}
        print('|cfff58cbaS|r|cff009cffUI|r: |cffff0000You had a broken database from a previous version of SUI, unfortunately we had to reset the profile.|r')
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
end

function SUI:LSB_Helper(LSBList, LSBHash)
    local list = {}
    for index, name in pairs(LSBList) do
        list[index] = {}
        for k, v in pairs(LSBHash) do
            if (name == k) then
                list[index] = {
                    text = name,
                    value = v
                }
            end
        end
    end
    return list
end
