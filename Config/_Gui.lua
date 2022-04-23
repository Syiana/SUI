local L = LibStub("AceLocale-3.0"):GetLocale("SUILocale")
local Gui = SUI:NewModule("Config.Gui")

--Imports
local Themes = SUI:GetModule("Data.Themes")
local Fonts = SUI:GetModule("Data.Fonts")
local Textures = SUI:GetModule("Data.Textures")
local User = SUI:GetModule("Data.User")

function Gui:OnEnable()
  local StdUi = LibStub('StdUi')
  StdUi.config = {
    font = {
        family    = STANDARD_TEXT_FONT,
        size      = 12,
        titleSize = 16,
        effect    = 'NONE',
        strata    = 'OVERLAY',
        color     = {
        normal   = { r = 1, g = 1, b = 1, a = 1 },
        disabled = { r = 1, g = 1, b = 1, a = 1 },
        header   = { r = 1, g = 0.9, b = 0, a = 1 },
      }
    },
    backdrop = {
      texture        = [[Interface\Buttons\WHITE8X8]],
      highlight      = { r = 0.40, g = 0.40, b = 0, a = 0.5 },
      panel          = { r = 0.065, g = 0.065, b = 0.065, a = 0.95 },
      slider         = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
      checkbox	     = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
      dropdown	     = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
      button         = { r = 0.055, g = 0.055, b = 0.055, a = 1 },
      buttonDisabled = { r = 0, g = 0.55, b = 1, a = 0.5 },
      border         = { r = 0.01, g = 0.01, b = 0.01, a = 1 },
      borderDisabled = { r = 0, g = 0.50, b = 1, a = 1 },
    },
    progressBar = {
      color = { r = 1, g = 0.9, b = 0, a = 0.5 },
    },
    highlight = {
      color = { r = 0, g = 0.55, b = 1, a = 0.5 },
      blank = { r = 0, g = 0, b = 0 }
    },
    dialog = {
      width  = 400,
      height = 100,
      button = {
        width  = 100,
        height = 20,
        margin = 5
      }
    },
    tooltip = {
      padding = 10
    }
  };

  --DB
  local db = SUI.db

  --Config
  local config = StdUi:Window(UIParent, 700, 400)
  config:SetPoint('CENTER')
  config.titlePanel:SetPoint('LEFT', 10, 0)
  config.titlePanel:SetPoint('RIGHT', -35, 0)
  config:Hide()

  local version = StdUi:Label(config.titlePanel, GetAddOnMetadata("SUI", "version"))
  StdUi:GlueLeft(version, config.titlePanel, 35, 0)

  local logo = StdUi:Texture(config.titlePanel, 120, 35, "Interface\\AddOns\\SUI\\Media\\Textures\\Config\\Logo")
  StdUi:GlueAbove(logo, config, 0, -35)

  function SUI:Config()
    if (config:IsVisible()) then
      local fadeInfo = {}
      fadeInfo.mode = "OUT"
      fadeInfo.timeToFade = 0.2
      fadeInfo.finishedFunc = function()
        config:Hide()
      end
      UIFrameFade(config, fadeInfo)
    else
      local fadeInfo = {}
      fadeInfo.mode = "IN"
      fadeInfo.timeToFade = 0.2
      fadeInfo.finishedFunc = function()
        config:Show()
      end
      UIFrameFade(config, fadeInfo)
    end
  end

  GameMenuFrame.Header:Hide()
  local frame = CreateFrame("Button", "UIPanelButtonTemplateTest",
  GameMenuFrame, "UIPanelButtonTemplate")
  frame:SetHeight(20)
  frame:SetWidth(145)
  frame:SetText("|cfff58cbaS|r|cff009cffUI|r")
  frame:ClearAllPoints()
  frame:SetPoint("TOP", 0, -11)
  frame:RegisterForClicks("AnyUp")
  frame:SetScript("OnClick", function()
    SUI:Config()
    ToggleGameMenu()
  end)

  --Edit
  local edit = StdUi:Button(config, 160, 25, L['Edit'])
  StdUi:GlueBottom(edit, config, 10, 36, 'LEFT')
  edit:SetScript('OnClick', function()
    SUI:Config()
    SUI:Edit()
  end)

  --Save
  local save = StdUi:Button(config, 160, 25, L['Save'])
  StdUi:GlueBottom(save, config, 10, 10, 'LEFT')
  save:SetScript('OnClick', function()
    ReloadUI()
  end)

  --Categories
  local categories = {
    { title = L['General'], name = 'General' },
    {title = L['Unitframes'], name = 'Unitframes'},
    -- {title = 'Nameplates', name = 'Nameplates'},
    {title = L['Actionbar'], name = 'Actionbar'},
    {title = L['Castbars'], name = 'Castbars'},
    {title = L['Tooltip'], name = 'Tooltip'},
    {title = L['Buffs'], name = 'Buffs'},
    {title = L['Map'], name = 'Map'},
    {title = L['Chat'], name = 'Chat'},
    {title = L['Misc'], name = 'Misc'},
    {title = L['FAQ'], name = 'FAQ'},
    -- {title = 'Profiles', name = 'Profiles'},
  }
  local tabs = StdUi:TabPanel(config, nil, nil, categories, true, nil, 25)
  StdUi:GlueAcross(tabs, config, 10, -35, -10, 10)

  --Options
  local options =  {
    General = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.general,
      rows = {
        {
          header = {
            type = 'header',
            label = L['General']
          }
        },
        {
          theme = {
            key = 'theme',
            type = 'dropdown',
            label = L['Theme'],
            options = Themes.data,
            column = 4,
            order = 1
          },
          font = {
            key = 'font',
            type = 'dropdown',
            label = L['Font'],
            options = Fonts.data,
            column = 4,
            order = 2
          },
          texture = {
            key = 'texture',
            type = 'dropdown',
            label = L['Texture'],
            options = Textures.data,
            column = 4,
            order = 3
          }
        },
        {
          color = {
            key = 'color',
            type = 'color',
            label = L['Custom Color'],
            column = 3,
            update = function() end,
            cancel = function() end
          }
        },
        {
          header = {
            type = 'header',
            label = L['Automation']
          },
        },
        {
          repair = {
            key = 'automation.repair',
            type = 'checkbox',
            label = L['Repair'],
            tooltip = L['Repairs your gear automatically'],
            column = 3,
            order = 1
          },
          sell = {
            key = 'automation.sell',
            type = 'checkbox',
            label = L['Sell'],
            tooltip = L['Sells grey items automatically'],
            column = 3,
            order = 2
          },
          delete = {
            key = 'automation.delete',
            type = 'checkbox',
            label = L['Delete'],
            tooltip = L['Inserts "DELETE" when deleting Rare+ items'],
            column = 3,
            order = 3
          },
          duel = {
            key = 'automation.decline',
            type = 'checkbox',
            label = L['Duel'],
            tooltip = L['Declines duels automatically'],
            column = 3,
            order = 3
          }
        },
        {
          release  = {
            key = 'automation.release',
            type = 'checkbox',
            label = L['Release'],
            tooltip = L['Release automatically when you died'],
            column = 3,
            order = 1
          },
          resurrect = {
            key = 'automation.resurrect',
            type = 'checkbox',
            label = L['Resurrect'],
            tooltip = L['Accept ress automatically'],
            column = 3,
            order = 2
          },
          invite = {
            key = 'automation.invite',
            type = 'checkbox',
            label = L['Invite'],
            tooltip = L['Accept group invite automatically'],
            column = 3,
            order = 3
          },
          cinematic = {
            key = 'automation.cinematic',
            type = 'checkbox',
            label = L['Cinematic'],
            tooltip = L['Skip cinematics automatically'],
            column = 3,
            order = 4
          },
        },
        {
          header = {
            type = 'header',
            label = L['Cosmetic']
          },
        },
        {
          afk = {
            key = 'cosmetic.afkscreen',
            type = 'checkbox',
            label = L['AFK Screen'],
            tooltip = L['coming soon'],
            column = 3,
            order = 1
          },
          talkhead = {
            key = 'cosmetic.talkinghead',
            type = 'checkbox',
            label = L['Talkinghead'],
            tooltip = L['Hide Talkinghead frame'],
            column = 3,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = L['Display']
          },
        },
        {
          items = {
            key = 'display.ilvl',
            type = 'checkbox',
            label = L['Item Infos'],
            tooltip = L['Display item level on item icons'],
            column = 3,
            order = 1
          },
          avgilvl = {
            key = 'display.avgilvl',
            type = 'checkbox',
            label = L['Average iLvl'],
            tooltip = L['Display average item level on inspected players'],
            column = 3,
            order = 1
          },
          fps = {
            key = 'display.fps',
            type = 'checkbox',
            label = L['FPS'],
            tooltip = L['Show current FPS'],
            column = 2,
            order = 2
          },
          ms = {
            key = 'display.ms',
            type = 'checkbox',
            label = L['MS'],
            tooltip = L['Show current ping'],
            column = 2,
            order = 3
          }
        }
      },
    },
    Unitframes = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Unitframes']
          },
        },
        {
          style = {
            key = 'unitframes.style',
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'Big', text = L['Big'] },
              { value = 'Small', text = L['Small'] }
            },
            column = 5
          }
        },
        {
          class = {
            key = 'unitframes.classcolor',
            type = 'checkbox',
            label = L['ClassColor'],
            tooltip = L['Change healthcolor to class color'],
            column = 4,
          },
          pvp = {
            key = 'unitframes.pvpbadge',
            type = 'checkbox',
            label = L['PvP Badge'],
            tooltip = L['Display PVP icon on Unit frames'],
            column = 4,
          },
          glow = {
            key = 'unitframes.statusglow',
            type = 'checkbox',
            label = L['Status Glow'],
            tooltip = L['Enable glow on Unit frames when in resting area'],
            column = 4,
          }
        },
        {
          hitindicator = {
            key = 'unitframes.hitindicator',
            type = 'checkbox',
            label = L['Hit indicator'],
            column = 4,
            order = 1
          },
          combat = {
            key = 'unitframes.combaticon',
            type = 'checkbox',
            label = L['Combat Icon'],
            tooltip = L['Display combat icon on Unit frames'],
            column = 4,
            order = 2
          },
          link = {
            key = 'unitframes.links',
            type = 'checkbox',
            label = L['Char Links'],
            tooltip = L['Extra menu to generate character-links for Check-PVP, Raider.io, etc.'],
            column = 4,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = L['Buffs']
          },
        },
        {
          border = {
            key = 'unitframes.buffs.purgeborder',
            type = 'checkbox',
            label = L['Purge Border'],
            column = 4,
            order = 1
          },
          size = {
            key = 'unitframes.buffs.size',
            type = 'slider',
            label = L['Icon Size'],
            max = 50,
            column = 5,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = L['Raidframes']
          },
        },
        {
          style = {
            key = 'raidframes.texture',
            type = 'dropdown',
            label = L['Texture'],
            options = Textures.data,
            column = 5
          }
        },
      },
    },
    Nameplates = {
      layoutConfig = { padding = { top = 15 } },
      rows = {
        {
          header = {
            type = 'header',
            label = L['Nameplates']
          }
        },
        {
          style = {
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 1, text = L['Default'] },
              { value = 2, text = L['Custom'] }
            },
            initialValue = 1,
            column = 5,
            order = 1
          },
          texture = {
            type = 'dropdown',
            label = L['Texture'],
            options = {
              { value = 1, text = L['Stack'] },
              { value = 2, text = L['Overlap'] },
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          size = {
            type = 'slider',
            label = L['Size'],
            max = 5,
            column = 5,
            order = 1
          },
          typ = {
            type = 'dropdown',
            label = L['Typ'],
            options = {
              { value = 1, text = L['Stack'] },
              { value = 2, text = L['Overlap'] },
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = L['Extras']
          }
        },
        {
          arena = {
            type = 'checkbox',
            label = L['Arena Number'],
            column = 4,
            order = 1
          },
        }
      },
    },
    Actionbar = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.actionbar,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Actionbar']
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'DefaultNoBg', text = L['Default (hide background)']},
              { value = 'Small', text = L['Small'] }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = L['Buttons']
          },
        },
        {
          hotkeys = {
            key = 'buttons.key',
            type = 'checkbox',
            label = L['Hotkeys Text'],
            tooltip = L['Show Hotkeys text'],
            column = 4,
            order = 1
          },
          macros = {
            key = 'buttons.macro',
            type = 'checkbox',
            label = L['Macro Text'],
            tooltip = L['Show Macro text'],
            column = 4,
            order = 2
          },
          gryphones = {
            key = 'gryphones',
            type = 'checkbox',
            label = L['Gryphones'],
            tooltip = L['Show actionbar gryphones'],
            column = 4,
            order = 3
          }
        },
        {
          range = {
            key = 'buttons.range',
            type = 'checkbox',
            label = L['Range Color'],
            tooltip = L['Show spell-color in red if out of range'],
            column = 4,
            order = 1
          },
          flash = {
            key = 'buttons.flash',
            type = 'checkbox',
            label = L['Flash Animation'],
            tooltip = L['Flash spell-icon when pressing it'],
            column = 4,
            order = 2
          }
        },
        {
          size = {
            key = 'buttons.size',
            type = 'slider',
            label = L['Size'],
            max = 50,
            column = 4,
            order = 1
          },
          padding = {
            key = 'buttons.padding',
            type = 'slider',
            label = L['Padding'],
            max = 50,
            column = 4,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = L['Micro Menu']
          },
        },
        {
          style = {
            key = 'menu.style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'Custom', text = L['Custom'] },
              { value = 'Hide', text = L['Custom (hide background)'] },
            },
            initialValue = 1,
            column = 4,
            order = 1
          },
          mouseover = {
            key = 'menu.mouseover',
            type = 'checkbox',
            label = L['Show on Mouseover'],
            tooltip = L['Show micromenu on mouseover'],
            column = 4,
            order = 2
          },
          bagbuttons = {
            key = 'menu.bagbuttons',
            type = 'checkbox',
            label = L['Hide bag buttons'],
            tooltip = L['Hide background & bag buttons in the micromenu'],
            column = 4,
            order = 3
          },
        },
      },
    },
    Castbars = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.castbars,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Castbars']
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'Custom', text = L['Custom'] }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = L['Settings']
          },
        },
        {
          mouseanchor = {
            key = 'icon',
            type = 'checkbox',
            label = L['Icons'],
            column = 4
          },
          lifeontop = {
            key = 'timer',
            type = 'checkbox',
            label = L['Timer'],
            column = 4
          }
        }
      },
    },
    Tooltip = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.tooltip,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Tooltip']
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'Custom', text = L['Custom'] }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = L['Settings']
          },
        },
        {
          mouseanchor = {
            key = 'mouseanchor',
            type = 'checkbox',
            label = L['Mouseanchor'],
            column = 4
          },
          lifeontop = {
            key = 'lifeontop',
            type = 'checkbox',
            label = L['Life on Top'],
            column = 4
          },
          hideincombat = {
            key = 'hideincombat',
            type = 'checkbox',
            label = L['Hide in Combat'],
            column = 4
          }
        }
      },
    },
    Buffs = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.buffs,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Buffs']
          }
        },
        {
          size = {
            key = 'buff.size',
            type = 'slider',
            label = L['Size'],
            max = 100,
            column = 4,
            order = 1
          },
          padding = {
            key = 'buff.padding',
            type = 'slider',
            label = L['Padding'],
            max = 5,
            column = 4,
            order = 3
          }
        },
        {
          icons = {
            key = 'buff.icons',
            type = 'slider',
            label = L['Icons Row'],
            max = 20,
            column = 8
          },
        },
        {
          header = {
            type = 'header',
            label = L['Debuffs']
          }
        },
        {
          size = {
            key = 'debuff.size',
            type = 'slider',
            label = L['Size'],
            max = 100,
            column = 4,
            order = 1
          },
          padding = {
            key = 'debuff.padding',
            type = 'slider',
            label = L['Padding'],
            max = 5,
            column = 4,
            order = 3
          }
        },
        {
          icons = {
            key = 'debuff.icons',
            type = 'slider',
            label = L['Icons Row'],
            max = 20,
            column = 8
          },
        }
      },
    },
    Map = {
      layoutConfig = { padding = { top = 15 } },
	    database = db.profile.maps,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Worldmap']
          }
        },
        {
          small = {
		      	key = 'small',
            type = 'checkbox',
            label = L['Small Map'],
            tooltip = L['coming soon'],
            column = 4,
            order = 1
          },
          cords = {
		      	key = 'coords',
            type = 'checkbox',
            label = L['Coords'],
            column = 4,
            order = 2
          },
          opacity = {
		  	    key = 'opacity',
            type = 'checkbox',
            label = L['Opacity'],
            tooltip = L['coming soon'],
            column = 4,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = L['Minimap']
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'Legion', text = L['Legion'] }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          showminimap = {
			      key = 'minimap',
            type = 'checkbox',
            label = L['Show Minimap'],
            column = 4,
            order = 1
          },
          showclock = {
			      key = 'clock',
            type = 'checkbox',
            label = L['Show Clock'],
            column = 4,
            order = 2
          },
          showdate = {
			      key = 'date',
            type = 'checkbox',
            label = L['Show Date'],
            column = 4,
            order = 3
          }
        },
        {
          showgarrison = {
			      key = 'garrison',
            type = 'checkbox',
            label = L['Garrison Symbol'],
            column = 4,
            order = 1
          },
          showtracking = {
			      key = 'tracking',
            type = 'checkbox',
            label = L['Tracking Symbol'],
            column = 4,
            order = 2
          }
        }
      },
    },
    Chat = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.chat,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Chat']
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = L['Style'],
            options = {
              { value = 'Default', text = L['Default'] },
              { value = 'Custom', text = L['Custom'] }
            },
            column = 5,
            order = 1
          }
        },
        {
          hotkeys = {
            key = 'top',
            type = 'checkbox',
            label = L['Input on Top'],
            column = 4,
            order = 1
          },
          link = {
            key = 'link',
            type = 'checkbox',
            label = L['Link copy'],
            column = 4,
            order = 2
          },
          copy = {
            key = 'copy',
            type = 'checkbox',
            label = L['Copy Symbol'],
            column = 4,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = L['Friendlist']
          }
        },
        {
          friendlist = {
            key = 'friendlist',
            type = 'checkbox',
            label = L['Class-Friendlist'],
            column = 4,
            order = 1
          }
        }
      },
    },
    Misc = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.misc,
      rows = {
        {
          header = {
            type = 'header',
            label = L['Misc']
          }
        },
        {
          cvars = {
            type = 'button',
            text = L['CVars Browser'],
            onClick = function()
              print(L['coming soon...']);
            end,
            column = 3,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = L['General']
          }
        },
        {
          interrupt = {
            key = 'interrupt',
            type = 'checkbox',
            label = L['Interrupt'],
            column = 3,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = L['PvP']
          }
        },
        {
          safequeue = {
            key = 'safequeue',
            type = 'checkbox',
            label = L['Safequeue'],
            column = 3,
            order = 1
          },
          tabbinder = {
            key = 'tabbinder',
            type = 'checkbox',
            label = L['Tabbinder'],
            column = 3,
            order = 1
          },
          losecontrol = {
            key = 'losecontrol',
            type = 'checkbox',
            label = L['Losecontrol'],
            column = 3,
            order = 1
          },
        }
      }
    },
    FAQ = {
      layoutConfig = { padding = { top = 15 } },
      rows = {
        {
          header = {
            type = 'header',
            label = L['Credits']
          }
        },
        {
          team = {
            type = 'scroll',
            label = L['Team'],
            scrollChild = function(self)
              local items = {};
              local function update(parent, label, data)
                label.data = data;
                label:SetText(data.text);
                StdUi:SetObjSize(label, 60, 20);
                label:SetPoint('RIGHT');
                label:SetPoint('LEFT');
                return label;
              end
              StdUi:ObjectList(self.scrollChild, items, 'Label', update, User.team);
            end,
            height = 220,
            column = 4,
            order = 1
          },
          special = {
            type = 'scroll',
            label = L['Specials'],
            scrollChild = function(self)
              local items = {};
              local function update(parent, label, data)
                label.data = data;
                label:SetText(data.text);
                StdUi:SetObjSize(label, 60, 20);
                label:SetPoint('RIGHT');
                label:SetPoint('LEFT');
                return label;
              end
              StdUi:ObjectList(self.scrollChild, items, 'Label', update, User.specials);
            end,
            height = 220,
            column = 4,
            order = 2
          },
          supporter = {
            type = 'scroll',
            label = L['Supporter'],
            scrollChild = function(self)
              local items = {};
              local function update(parent, label, data)
                label.data = data;
                label:SetText(data.text);
                StdUi:SetObjSize(label, 60, 20);
                label:SetPoint('RIGHT');
                label:SetPoint('LEFT');
                return label;
              end
              StdUi:ObjectList(self.scrollChild, items, 'Label', update, User.supporter);
            end,
            height = 220,
            column = 4,
            order = 3
          },
        },
        {
          header = {
            type = 'header',
            label = L['Help']
          }
        },
        {
          discord = {
            type = 'button',
            text = L['Discord'],
            onClick = function()
              StdUi:Dialog(L['Discord'], L['discord.gg/yBWkxxR'])
            end,
            column = 3,
            order = 1
          },
          twitch = {
            type = 'button',
            text = L['Twitch'],
            onClick = function()
              StdUi:Dialog(L['Twitch'], L['twitch.tv/syiana'])
            end,
            column = 3,
            order = 2
          },
          reset = {
            type = 'button',
            text = L['Reset UI'],
            onClick = function()
              local buttons = {
                ok = {
                  text    = L['Confirm'],
                  onClick = function() db:ResetProfile() ReloadUI() end
                },
                cancel = {
                  text    = L['Cancel'],
                  onClick = function(self) self:GetParent():Hide() end
                }
              }
              StdUi:Confirm(L['Reset UI'], L['This will reset your profile'], buttons)
            end,
            column = 3,
            order = 3
          }
        }
      },
    },
    Profiles = {
      layoutConfig = { padding = { top = 15 } },
      rows = {
        {
          header = {
            type = 'header',
            label = L['Profiles']
          }
        },
        {
          profile = {
            type = 'dropdown',
            label = L['Profile'],
            options = {
              { value = 1, text = L['Default'] },
              { value = 2, text = L['Custom'] }
            },
            initialValue = 1,
            column = 6,
            order = 1
          }
        },
        {
          copy = {
            type = 'dropdown',
            label = L['Copy from'],
            options = {
              { value = 1, text = L['Default'] },
              { value = 2, text = L['Custom'] }
            },
            initialValue = 1,
            column = 6,
            order = 1
          }
        },
        {
          new = {
            type = 'button',
            text = L['New'],
            onClick = function()
              print(L['new profile']);
            end,
            column = 3,
            order = 1
          },
          delete = {
            type = 'button',
            text = L['Delete'],
            column = 3,
            order = 2
          },
          export = {
            type = 'button',
            text = L['Export'],
            column = 3,
            order = 3
          },
          import = {
            type = 'button',
            text = L['Import'],
            column = 3,
            order = 4
          }
        }
      },
    }
  }
  tabs:EnumerateTabs(function(tab)
    StdUi:BuildWindow(tab.frame, options[tab.name])
  end)
end