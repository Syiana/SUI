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
  local edit = StdUi:Button(config, 160, 25, 'Edit')
  StdUi:GlueBottom(edit, config, 10, 36, 'LEFT')
  edit:SetScript('OnClick', function()
    SUI:Config()
    SUI:Edit()
  end)

  --Save
  local save = StdUi:Button(config, 160, 25, 'Save')
  StdUi:GlueBottom(save, config, 10, 10, 'LEFT')
  save:SetScript('OnClick', function()
    ReloadUI()
  end)

  --Categories
  local categories = {
    {title = 'General', name = 'General'},
    {title = 'Unitframes', name = 'Unitframes'},
    -- {title = 'Nameplates', name = 'Nameplates'},
    {title = 'Actionbar', name = 'Actionbar'},
    {title = 'Castbars', name = 'Castbars'},
    {title = 'Tooltip', name = 'Tooltip'},
    {title = 'Buffs', name = 'Buffs'},
    {title = 'Map', name = 'Map'},
    {title = 'Chat', name = 'Chat'},
    {title = 'Misc', name = 'Misc'},
    {title = 'FAQ', name = 'FAQ'},
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
            label = 'General'
          }
        },
        {
          theme = {
            key = 'theme',
            type = 'dropdown',
            label = 'Theme',
            options = Themes.data,
            column = 4,
            order = 1
          },
          font = {
            key = 'font',
            type = 'dropdown',
            label = 'Font',
            options = Fonts.data,
            column = 4,
            order = 2
          },
          texture = {
            key = 'texture',
            type = 'dropdown',
            label = 'Texture',
            options = Textures.data,
            column = 4,
            order = 3
          }
        },
        {
          color = {
            key = 'color',
            type = 'color',
            label = 'Custom Color',
            column = 3,
            update = function() end,
            cancel = function() end
          }
        },
        {
          header = {
            type = 'header',
            label = 'Automation'
          },
        },
        {
          repair = {
            key = 'automation.repair',
            type = 'checkbox',
            label = 'Repair',
            tooltip = 'Repairs your gear automatically',
            column = 3,
            order = 1
          },
          sell = {
            key = 'automation.sell',
            type = 'checkbox',
            label = 'Sell',
            tooltip = 'Sells grey items automatically',
            column = 3,
            order = 2
          },
          delete = {
            key = 'automation.delete',
            type = 'checkbox',
            label = 'Delete',
            tooltip = 'Inserts "DELETE" when deleting Rare+ items',
            column = 3,
            order = 3
          },
          duel = {
            key = 'automation.decline',
            type = 'checkbox',
            label = 'Duel',
            tooltip = 'Declines duels automatically',
            column = 3,
            order = 3
          }
        },
        {
          release  = {
            key = 'automation.release',
            type = 'checkbox',
            label = 'Release',
            tooltip = 'Release automatically when you died',
            column = 3,
            order = 1
          },
          resurrect = {
            key = 'automation.resurrect',
            type = 'checkbox',
            label = 'Resurrect',
            tooltip = 'Accept ress automatically',
            column = 3,
            order = 2
          },
          invite = {
            key = 'automation.invite',
            type = 'checkbox',
            label = 'Invite',
            tooltip = 'Accept group invite automatically',
            column = 3,
            order = 3
          },
          cinematic = {
            key = 'automation.cinematic',
            type = 'checkbox',
            label = 'Cinematic',
            tooltip = 'Skip cinematics automatically',
            column = 3,
            order = 4
          },
        },
        {
          header = {
            type = 'header',
            label = 'Cosmetic'
          },
        },
        {
          afk = {
            key = 'cosmetic.afkscreen',
            type = 'checkbox',
            label = 'AFK Screen',
            tooltip = 'coming soon',
            column = 3,
            order = 1
          },
          talkhead = {
            key = 'cosmetic.talkinghead',
            type = 'checkbox',
            label = 'Talkinghead',
            tooltip = 'Show Talkinghead frame',
            column = 3,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = 'Display'
          },
        },
        {
          items = {
            key = 'display.ilvl',
            type = 'checkbox',
            label = 'Item Infos',
            tooltip = 'Display item level on item icons',
            column = 3,
            order = 1
          },
          avgilvl = {
            key = 'display.avgilvl',
            type = 'checkbox',
            label = 'Average iLvl',
            tooltip = 'Display average item level on inspected players',
            column = 3,
            order = 1
          },
          fps = {
            key = 'display.fps',
            type = 'checkbox',
            label = 'FPS',
            tooltip = 'Show current FPS',
            column = 2,
            order = 2
          },
          ms = {
            key = 'display.ms',
            type = 'checkbox',
            label = 'MS',
            tooltip = 'Show current ping',
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
            label = 'Unitframes'
          },
        },
        {
          style = {
            key = 'unitframes.style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Big', text = 'Big' },
              { value = 'Small', text = 'Small' }
            },
            column = 5
          }
        },
        {
          class = {
            key = 'unitframes.classcolor',
            type = 'checkbox',
            label = 'Class Color',
            tooltip = 'Change healthcolor to class color',
            column = 4,
          },
          pvp = {
            key = 'unitframes.pvpbadge',
            type = 'checkbox',
            label = 'PvP Badge',
            tooltip = 'Display PVP icon on Unit frames',
            column = 4,
          },
          glow = {
            key = 'unitframes.statusglow',
            type = 'checkbox',
            label = 'Status Glow',
            tooltip = 'Enable glow on Unit frames when in resting area',
            column = 4,
          }
        },
        {
          hitindicator = {
            key = 'unitframes.hitindicator',
            type = 'checkbox',
            label = 'Hit indicator',
            column = 4,
            order = 1
          },
          combat = {
            key = 'unitframes.combaticon',
            type = 'checkbox',
            label = 'Combat Icon',
            tooltip = 'Display combat icon on Unit frames',
            column = 4,
            order = 2
          },
          link = {
            key = 'unitframes.links',
            type = 'checkbox',
            label = 'Char Links',
            tooltip = 'Extra menu to generate character-links for Check-PVP, Raider.io, etc.',
            column = 4,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = 'Buffs'
          },
        },
        {
          border = {
            key = 'unitframes.buffs.purgeborder',
            type = 'checkbox',
            label = 'Purge Border',
            tooltip = 'Highlight purgable buffs',
            column = 4,
            order = 1
          },
          size = {
            key = 'unitframes.buffs.size',
            type = 'slider',
            label = 'Icon Size',
            max = 50,
            column = 5,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = 'Raidframes'
          },
        },
        {
          style = {
            key = 'raidframes.texture',
            type = 'dropdown',
            label = 'Texture',
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
            label = 'Nameplates'
          }
        },
        {
          style = {
            type = 'dropdown',
            label = 'Style',
            options = {
              { value = 1, text = 'Default' },
              { value = 2, text = 'Custom' }
            },
            initialValue = 1,
            column = 5,
            order = 1
          },
          texture = {
            type = 'dropdown',
            label = 'Texture',
            options = {
              { value = 1, text = 'Stack' },
              { value = 2, text = 'Overlap' },
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          size = {
            type = 'slider',
            label = 'Size',
            max = 5,
            column = 5,
            order = 1
          },
          typ = {
            type = 'dropdown',
            label = 'Typ',
            options = {
              { value = 1, text = 'Stack' },
              { value = 2, text = 'Overlap' },
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = 'Extras'
          }
        },
        {
          arena = {
            type = 'checkbox',
            label = 'Arena Number',
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
            label = 'Actionbar'
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'DefaultNoBg', text = 'Default (hide background)'},
              { value = 'Small', text = 'Small' }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = 'Buttons'
          },
        },
        {
          hotkeys = {
            key = 'buttons.key',
            type = 'checkbox',
            label = 'Hotkeys Text',
            tooltip = 'Show Hotkeys text',
            column = 4,
            order = 1
          },
          macros = {
            key = 'buttons.macro',
            type = 'checkbox',
            label = 'Macro Text',
            tooltip = 'Show Macro text',
            column = 4,
            order = 2
          },
          gryphones = {
            key = 'gryphones',
            type = 'checkbox',
            label = 'Gryphones',
            tooltip = 'Show actionbar gryphones',
            column = 4,
            order = 3
          }
        },
        {
          range = {
            key = 'buttons.range',
            type = 'checkbox',
            label = 'Range Color',
            tooltip = 'Show spell-color in red if out of range',
            column = 4,
            order = 1
          },
          flash = {
            key = 'buttons.flash',
            type = 'checkbox',
            label = 'Flash Animation',
            tooltip = 'Flash spell-icon when pressing it',
            column = 4,
            order = 2
          }
        },
        {
          size = {
            key = 'buttons.size',
            type = 'slider',
            label = 'Size',
            max = 50,
            column = 4,
            order = 1
          },
          padding = {
            key = 'buttons.padding',
            type = 'slider',
            label = 'Padding',
            max = 50,
            column = 4,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = 'Micro Menu'
          },
        },
        {
          style = {
            key = 'menu.style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Custom', text = 'Custom' }
            },
            initialValue = 1,
            column = 4,
            order = 1
          },
          mouseover = {
            key = 'menu.mouseover',
            type = 'checkbox',
            label = 'Show on Mouseover',
            tooltip = 'Show micromenu on mouseover',
            column = 4,
            order = 2
          },
          bagbuttons = {
            key = 'menu.hidebag',
            type = 'checkbox',
            label = 'Hide bag buttons',
            tooltip = 'Hide background & bag buttons in the micromenu',
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
            label = 'Chastbars'
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Custom', text = 'Custom' }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = 'Settings'
          },
        },
        {
          casticons = {
            key = 'icon',
            type = 'checkbox',
            label = 'Icons',
            tooltip = 'Display spell icons on castbar',
            column = 4
          },
          casttime = {
            key = 'timer',
            type = 'checkbox',
            label = 'Timer',
            tooltip = 'Display cast time on castbar',
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
            label = 'Tooltip'
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Custom', text = 'Custom' }
            },
            initialValue = 1,
            column = 5,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = 'Settings'
          },
        },
        {
          mouseanchor = {
            key = 'mouseanchor',
            type = 'checkbox',
            label = 'Mouseanchor',
            tooltip = 'Attach tooltip to mouse cursor',
            column = 4
          },
          lifeontop = {
            key = 'lifeontop',
            type = 'checkbox',
            label = 'Life on Top',
            tooltip = 'Show HP bar in tooltip on top',
            column = 4
          },
          hideincombat = {
            key = 'hideincombat',
            type = 'checkbox',
            tooltip = 'Hide tooltips while in combat',
            label = 'Hide in Combat',
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
            label = 'Buffs'
          }
        },
        {
          size = {
            key = 'buff.size',
            type = 'slider',
            label = 'Size',
            max = 100,
            column = 4,
            order = 1
          },
          icons = {
            key = 'buff.icons',
            type = 'slider',
            label = 'Icons',
            tooltip = 'Icons per row',
            min = 2,
            max = 20,
            column = 5,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = 'Debuffs'
          }
        },
        {
          size = {
            key = 'debuff.size',
            type = 'slider',
            label = 'Size',
            max = 100,
            column = 4,
            order = 1
          },
          icons = {
            key = 'debuff.icons',
            type = 'slider',
            label = 'Icons',
            tooltip = 'Icons per row',
            min = 2,
            max = 20,
            column = 5,
            order = 2
          }
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
            label = 'Worldmap'
          }
        },
        {
          small = {
		      	key = 'small',
            type = 'checkbox',
            label = 'Small Map',
            tooltip = 'coming soon.',
            column = 4,
            order = 1
          },
          cords = {
		      	key = 'coords',
            type = 'checkbox',
            label = 'Coords',
            tooltip = 'Display coordinates on map',
            column = 4,
            order = 2
          },
          opacity = {
		  	    key = 'opacity',
            type = 'checkbox',
            label = 'Opacity',
            tooltip = 'coming soon.',
            column = 4,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = 'Minimap'
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = 'Style',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Legion', text = 'Legion' }
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
            label = 'Show Minimap',
            tooltip = 'Show/Hide minimap',
            column = 4,
            order = 1
          },
          showclock = {
			      key = 'clock',
            type = 'checkbox',
            label = 'Show Clock',
            tooltip = 'Show/Hide clock on minimap',
            column = 4,
            order = 2
          },
          showdate = {
			      key = 'date',
            type = 'checkbox',
            label = 'Show Date',
            tooltip = 'Show/Hide calendar icon on minimap',
            column = 4,
            order = 3
          }
        },
        {
          showgarrison = {
			      key = 'garrison',
            type = 'checkbox',
            label = 'Garrison Symbol',
            tooltip = 'Show/Hide covenant icon on minimap',
            column = 4,
            order = 1
          },
          showtracking = {
			      key = 'tracking',
            type = 'checkbox',
            label = 'Tracking Symbol',
            tooltip = 'Show/Hide tracking icon on minimap',
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
            label = 'Chat'
          }
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Custom', text = 'Custom' }
            },
            column = 5,
            order = 1
          }
        },
        {
          chatinput = {
            key = 'top',
            type = 'checkbox',
            label = 'Input on Top',
            tooltip = 'Move chat input field to top of chat',
            column = 4,
            order = 1
          },
          link = {
            key = 'link',
            type = 'checkbox',
            label = 'Link copy',
            tooltip = 'Make links clickable to copy them',
            column = 4,
            order = 2
          },
          copy = {
            key = 'copy',
            type = 'checkbox',
            label = 'Copy Symbol',
            tooltip = 'Show/Hide copy chat-history icon',
            column = 4,
            order = 3
          },
        },
        {
          quickjoin = {
            key = 'quickjoin',
            type = 'checkbox',
            label = 'Friendlist Button',
            tooltip = 'Show/Hide friendlist button'
          }
        },
        {
          header = {
            type = 'header',
            label = 'Friendlist'
          }
        },
        {
          friendlist = {
            key = 'friendlist',
            type = 'checkbox',
            label = 'Class-Friendlist',
            tooltip = 'Show character names in class color in friendlist',
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
            label = 'Misc'
          }
        },
        {
          cvars = {
            type = 'button',
            text = 'CVars Browser',
            onClick = function()
              print("coming soon...");
            end,
            column = 3,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = 'General'
          }
        },
        {
          interrupt = {
            key = 'interrupt',
            type = 'checkbox',
            label = 'Interrupt',
            tooltip = 'Announce successful interrupts party',
            column = 3,
            order = 1
          }
        },
        {
          header = {
            type = 'header',
            label = 'PvP'
          }
        },
        {
          safequeue = {
            key = 'safequeue',
            type = 'checkbox',
            label = 'Safequeue',
            tooltip = 'Show time left to join and remove leave-button on queuepop-window',
            column = 3,
            order = 1
          },
          tabbinder = {
            key = 'tabbinder',
            type = 'checkbox',
            label = 'Tabbinder',
            tooltip = 'Only target players with TAB in PVP-Combat',
            column = 3,
            order = 1
          },
          losecontrol = {
            key = 'losecontrol',
            type = 'checkbox',
            label = 'Losecontrol',
            tooltip = 'Shows crowd-control icons with timer for yourself',
            column = 3,
            order = 1
          }
        }
      },
    },
    FAQ = {
      layoutConfig = { padding = { top = 15 } },
      rows = {
        {
          header = {
            type = 'header',
            label = 'Credits'
          }
        },
        {
          team = {
            type = 'scroll',
            label = 'Team',
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
            label = 'Specials',
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
            label = 'Supporter',
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
            label = 'Help'
          }
        },
        {
          discord = {
            type = 'button',
            text = 'Discord',
            onClick = function()
              StdUi:Dialog('Discord', 'discord.gg/yBWkxxR')
            end,
            column = 3,
            order = 1
          },
          twitch = {
            type = 'button',
            text = 'Twitch',
            onClick = function()
              StdUi:Dialog('Twitch', 'twitch.tv/syiana')
            end,
            column = 3,
            order = 2
          },
          reset = {
            type = 'button',
            text = 'Reset UI',
            onClick = function()
              local buttons = {
                ok = {
                  text    = 'Confirm',
                  onClick = function() db:ResetProfile() ReloadUI() end
                },
                cancel = {
                  text    = 'Cancel',
                  onClick = function(self) self:GetParent():Hide() end
                }
              }
              StdUi:Confirm('Reset UI', 'This will reset your profile', buttons)
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
            label = 'Profiles'
          }
        },
        {
          profile = {
            type = 'dropdown',
            label = 'Profile',
            options = {
              { value = 1, text = 'Default' },
              { value = 2, text = 'Custom' }
            },
            initialValue = 1,
            column = 6,
            order = 1
          }
        },
        {
          copy = {
            type = 'dropdown',
            label = 'Copy from',
            options = {
              { value = 1, text = 'Default' },
              { value = 2, text = 'Custom' }
            },
            initialValue = 1,
            column = 6,
            order = 1
          }
        },
        {
          new = {
            type = 'button',
            text = 'New',
            onClick = function()
              print("new profile");
            end,
            column = 3,
            order = 1
          },
          delete = {
            type = 'button',
            text = 'Delete',
            column = 3,
            order = 2
          },
          export = {
            type = 'button',
            text = 'Export',
            column = 3,
            order = 3
          },
          import = {
            type = 'button',
            text = 'Import',
            column = 3,
            order = 4
          }
        }
      },
    },
  }

  tabs:EnumerateTabs(function(tab)
    StdUi:BuildWindow(tab.frame, options[tab.name])
  end)
end