local ADDON, SUI = ...

SUI.DB = {}
SUI.CONFIG = {}
SUI.MODULES = {}

SUI.CONFIG.DB = function() 

    if not (SUIDB) then
        SUIInstall = CreateFrame("Frame", UIParent)
        SUIInstall:SetWidth(GetScreenWidth())
        SUIInstall:SetHeight(GetScreenHeight())
        SUIInstall:SetPoint("CENTER", 0, 0)
        SUIInstall:EnableMouse(true)
        SUIInstall:SetFrameStrata("HIGH")
        SUIInstall.text = SUIInstall.text or SUIInstall:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        SUIInstall.text:SetScale(4)
        SUIInstall.text:SetPoint("CENTER", 0, 30)
        SUIInstall.text:SetText("Welcome to |cfff58cbaS|r|cff009cffUI|r")
        local Texture = SUIInstall:CreateTexture(nil, "BACKGROUND")
        Texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
        Texture:SetAllPoints(SUIInstall)
        SUIInstall.texture = Texture
    
        local Subtittle = CreateFrame("Frame", "$parentSubtittle", SUIInstall)
        Subtittle:SetWidth(GetScreenWidth())
        Subtittle:SetHeight(GetScreenHeight())
        Subtittle:SetPoint("CENTER", SUIInstall, 0, 85)
        Subtittle:EnableMouse(false)
        Subtittle:SetFrameStrata("HIGH")
        Subtittle.text = Subtittle.text or Subtittle:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        Subtittle.text:SetScale(1.5)
        Subtittle.text:SetAllPoints(true)
        Subtittle.text:SetJustifyH("CENTER")
        Subtittle.text:SetJustifyV("CENTER")
        Subtittle.text:SetText("The Dark Side of World of Warcraft")
    
        local Button = CreateFrame("Button", "Test", SUIInstall, "UIPanelButtonTemplate")
        Button:SetPoint("CENTER", 0, 25)
        Button:SetSize(100, 25)
        Button:SetText("Install")
        Button:SetNormalTexture("Interface\\Common\\bluemenu-main")
        Button:GetNormalTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
        Button:GetNormalTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
        Button:SetHighlightTexture("Interface\\Common\\bluemenu-main")
        Button:GetHighlightTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
        Button:GetHighlightTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
        Button:SetScript("OnClick",function(self, button, down)
            ReloadUI()
        end)
    end

    local DEFAULTS = {
        CONFIG = {
            DB = true
        },
        THEMES = {
            SELECTED = "Default",
            OPTIONS = {
                Default = {},
                Dark = {r = 0.37, g = 0.3, b = 0.3},
                Class = {r = 0.37, g = 0.3, b = 0.3},
                Custom = {r = 0.37, g = 0.3, b = 0.3}
            }
        },
        FONTS = {
            SELECTED = "Default",
            OPTIONS = {
                Default = "Interface\\AddOns\\SUI\\inc\\media\\fonts\\FRIZQT__.TTF",
                Prototype = "Interface\\AddOns\\SUI\\inc\\media\\fonts\\FRIZQT__.TTF",
            },
            NORMAL = "Interface\\AddOns\\SUI\\inc\\media\\fonts\\FRIZQT__.TTF"
        },
        TEXTURES = {
            SELECTED = "Default",
            OPTIONS = {
                Default = "Interface\\AddOns\\SUI\\inc\\media\\fonts\\FRIZQT__.TTF",
                Smooth = "Interface\\AddOns\\SUI\\inc\\media\\fonts\\FRIZQT__.TTF"
            }
        },
        MISC = {
            TalkHead = false,
        },
        UNITFRAMES = {
            STATE = true,
            CONFIG = {
                Size = 1,
                Buffs = {
                    Large = 27,
                    Small = 25, 
                },
                BigFrames = true,
                ClassColor = true,
                FactionColor = true,
                Background = true,
                PvPBadge = true,
                StatusGlow = false,
            }
        },
        RAIDFRAMES = {
            STATE = true,
            CONFIG = {
                Textures = true,
                PartyBuffs = false
            }
        },
        CASTBARS = {
            STATE = true,
            CONFIG = {
                Icon = true,
                Timer = true,
                Size = 1,
            }
        },
        ACTIONBAR = {
            STATE = true,
            CONFIG = {
                Size = 1,
                HotKeys = {
                    FontSize = 12,
                    Hide = false,
                },
                Macros = {
                    FontSize = 12,
                    Hide = false,
                },
                Shortbar = false,
                Range = true,
                Flash = true,
                Gryphones = true,
                Stats = true,
                Menu = true,
            }
        },
        BUFFS = {
            STATE = true,
            CONFIG = {

            }
        },
        TOOLTIP = {
            STATE = true,
            CONFIG = {
                LifeTop = true,
                OnMouse = false,
            }
        },
        MINIMAP = {
            STATE = true,
            CONFIG = {
                Clock = true,
                Date = false,
                Garrison = true,
                Tracking = false,
                WorldMap = false,
                CustomGestics = true,
                ClassSymbol = false,
                HideSymbol = false,
            }
        },
        MAP = {
            STATE = true,
            CONFIG = {
                CustomGestics = true,
                ClassSymbol = false,
                HideSymbol = false,
            }
        },
        CHAT = {
            STATE = true,
            CONFIG = {

            }
        },
        MISC = {
            STATE = true,
            CONFIG = {

            }
        },
        NAMEPLATE = {
            STATE = true,
            CONFIG = {}
        },
        SKINS = {
            STATE = true,
            BLIZZARD = {
                test = true
            },
            ADDONS = {
                sArena = true
            }
        },
        background = {
            showbg = true,
            showshadow = true,
            useflatbackground = false,
            backgroundcolor = {r = 0.2, g = 0.2, b = 0.2, a = 0.3},
            shadowcolor = {r = 0, g = 0, b = 0, a = 0.9},
            classcolored = false,
            inset = 5
        },
        color = {
            maincolor = {r = 0.37, g = 0.3, b = 0.3},
            normal = {r = 0.37, g = 0.3, b = 0.3},
            equipped = {r = 0.1, g = 0.5, b = 0.1},
            classcolored = false
        }
    }

    local function SUIDBSync(src, dst)
        if type(src) ~= "table" then return {} end
        if type(dst) ~= "table" then dst = { } end
        for k, v in pairs(src) do
        if type(v) == "table" then
            dst[k] = SUIDBSync(v, dst[k])
            elseif type(v) ~= type(dst[k]) then
            dst[k] = v
            end
        end
        return dst
    end
    SUIDB = SUIDBSync(DEFAULTS, SUIDB)

end