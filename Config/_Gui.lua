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
        family    = "Interface\\AddOns\\SUI\\Media\\Fonts\\Prototype.ttf",
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
  config:Hide()
  config.titlePanel:SetPoint('LEFT', 10, 0)
  config.titlePanel:SetPoint('RIGHT', -35, 0)

  local version = StdUi:Label(config.titlePanel, 'v'.. GetAddOnMetadata("SUI", "version"))
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
    {title = 'Tooltip', name = 'Tooltip'},
    {title = 'Buffs', name = 'Buffs'},
    {title = 'Map', name = 'Map'},
    {title = 'Chat', name = 'Chat'},
    {title = 'Misc', name = 'Misc'},
    {title = 'FAQ', name = 'FAQ'},
    {title = 'Profiles', name = 'Profiles'},
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
            column = 3
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
            column = 3,
            order = 1
          },
          sell = {
            key = 'automation.sell',
            type = 'checkbox',
            label = 'Sell',
            column = 3,
            order = 2
          },
          delete = {
            key = 'automation.delete',
            type = 'checkbox',
            label = 'Delete',
            column = 3,
            order = 3
          }
        },
        {
          repair = {
            key = 'automation.release',
            type = 'checkbox',
            label = 'Release',
            column = 3,
            order = 1
          },
          sell = {
            key = 'automation.resurrect',
            type = 'checkbox',
            label = 'Resurrect',
            column = 3,
            order = 2
          },
          invite = {
            key = 'automation.invite',
            type = 'checkbox',
            label = 'Invite',
            column = 3,
            order = 3
          },
          cinematic = {
            key = 'automation.cinematic',
            type = 'checkbox',
            label = 'Cinematic',
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
            column = 4,
            order = 1
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
            column = 3,
            order = 1
          },
          fps = {
            key = 'display.fps',
            type = 'checkbox',
            label = 'FPS',
            column = 2,
            order = 2
          },
          ms = {
            key = 'display.ms',
            type = 'checkbox',
            label = 'MS',
            column = 2,
            order = 3
          }
        }
      },
    },
    Unitframes = {
      layoutConfig = { padding = { top = 15 } },
      database = db.profile.unitframes,
      rows = {
        {
          header = {
            type = 'header',
            label = 'Unitframes'
          },
        },
        {
          style = {
            key = 'style',
            type = 'dropdown',
            label = 'Style',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Small', text = 'Small' },
              { value = 'Big', text = 'Big' }
            },
            column = 5
          }
        },
        {
          class = {
            key = 'classcolor',
            type = 'checkbox',
            label = 'ClassColor',
            column = 4,
          },
          pvp = {
            key = 'pvpbadge',
            type = 'checkbox',
            label = 'PvP Badge',
            column = 4,
          },
          glow = {
            key = 'statusglow',
            type = 'checkbox',
            label = 'Status Glow',
            column = 4,
          }
        },
        {
          combat = {
            key = 'combaticon',
            type = 'checkbox',
            label = 'Combat Icon',
            column = 4,
          },
          link = {
            key = 'links',
            type = 'checkbox',
            label = 'Char Links',
            column = 4,
          }
        },
        {
          header = {
            type = 'header',
            label = 'Buffs'
          },
        },
        {
          smallsize = {
            key = 'buffs.small',
            type = 'slider',
            label = 'Smallbuff Size',
            max = 100,
            column = 4,
            order = 1
          },
          largesize = {
            key = 'buffs.large',
            type = 'slider',
            label = 'Largebuff Size',
            max = 100,
            column = 4,
            order = 1
          },
          border = {
            key = 'buffs.purgeborder',
            type = 'checkbox',
            label = 'Purge Border',
            column = 4,
            order = 2
          }
        },
        -- {
        --   header = {
        --     type = 'header',
        --     label = 'Raid'
        --   },
        -- },
        -- {
        --   top = {
        --     key = 'raid.alwaysontop',
        --     type = 'checkbox',
        --     label = 'Always on Top',
        --     column = 4
        --   }
        -- }
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
            type = 'dropdown',
            label = 'Style',
            options = {
              { value = 1, text = 'Default' },
              { value = 2, text = 'Small' },
              { value = 3, text = 'Classic' }
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
            column = 4,
            order = 1
          },
          macros = {
            key = 'buttons.macro',
            type = 'checkbox',
            label = 'Macro Text',
            column = 4,
            order = 2
          },
          gryphones = {
            key = 'gryphones',
            type = 'checkbox',
            label = 'Gryphones',
            column = 4,
            order = 3
          }
        },
        {
          range = {
            key = 'buttons.range',
            type = 'checkbox',
            label = 'Range Color',
            column = 4,
            order = 1
          },
          flash = {
            key = 'buttons.flash',
            type = 'checkbox',
            label = 'Flash Animation',
            column = 4,
            order = 2
          }
        },
        {
          size = {
            key = 'buttons.size',
            type = 'slider',
            label = 'Size',
            max = 5,
            column = 4,
            order = 1
          },
          padding = {
            key = 'buttons.padding',
            type = 'slider',
            label = 'Padding',
            max = 5,
            column = 4,
            order = 2
          }
        },
        {
          header = {
            type = 'header',
            label = 'Menu'
          },
        },
        {
          mouseover = {
            type = 'checkbox',
            label = 'Show on Mouseover',
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
            label = 'Style',
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
            column = 4
          },
          lifeontop = {
            key = 'lifeontop',
            type = 'checkbox',
            label = 'Life on Top',
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
          padding = {
            key = 'buff.padding',
            type = 'slider',
            label = 'Padding',
            max = 5,
            column = 4,
            order = 3
          }
        },
        {
          icons = {
            key = 'buff.icons',
            type = 'slider',
            label = 'Icons Row',
            max = 20,
            column = 8
          },
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
          padding = {
            key = 'debuff.padding',
            type = 'slider',
            label = 'Padding',
            max = 5,
            column = 4,
            order = 3
          }
        },
        {
          icons = {
            key = 'debuff.icons',
            type = 'slider',
            label = 'Icons Row',
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
            label = 'Worldmap'
          }
        },
        {
          small = {
		      	key = 'small',
            type = 'checkbox',
            label = 'Small Map',
            column = 4,
            order = 1
          },
          cords = {
		      	key = 'coordinates',
            type = 'checkbox',
            label = 'Coords',
            column = 4,
            order = 2
          },
          opacity = {
		  	    key = 'opacity',
            type = 'checkbox',
            label = 'Opacity',
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
          showminimap = {
			      key = 'showminimap',
            type = 'checkbox',
            label = 'Show Minimap',
            column = 4,
            order = 1
          },
          showclock = {
			      key = 'showclock',
            type = 'checkbox',
            label = 'Show Clock',
            column = 4,
            order = 2
          },
          showdate = {
			      key = 'showdate',
            type = 'checkbox',
            label = 'Show Date',
            column = 4,
            order = 3
          }
        },
        {
          showgarrison = {
			      key = 'showgarrison',
            type = 'checkbox',
            label = 'Garrison Symbol',
            column = 4,
            order = 1
          },
          showtracking = {
			      key = 'showtracking',
            type = 'checkbox',
            label = 'Tracking Symbol',
            column = 4,
            order = 2
          },
          showworldmap = {
			      key = 'showworldmap',
            type = 'checkbox',
            label = 'WorldMap Symbol',
            column = 4,
            order = 3
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
            label = 'Style',
            options = {
              { value = 'Default', text = 'Default' },
              { value = 'Custom', text = 'Custom' }
            },
            column = 5,
            order = 1
          }
        },
        {
          hotkeys = {
            type = 'checkbox',
            label = 'Input on Top',
            column = 4,
            order = 1
          },
          macros = {
            type = 'checkbox',
            label = 'Friend Symbol',
            column = 4,
            order = 2
          },
          gryphones = {
            type = 'checkbox',
            label = 'Copy Symbol',
            column = 4,
            order = 3
          }
        },
        {
          header = {
            type = 'header',
            label = 'Friendlist'
          }
        },
        {
          hotkeys = {
            type = 'checkbox',
            label = 'Classcolors',
            column = 4,
            order = 1
          }
        }
      },
    },
    Misc = {
      layoutConfig = { padding = { top = 15 } },
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
              print("CVars");
            end,
            column = 3,
            order = 3
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
              print("Discord");
            end,
            column = 3,
            order = 1
          },
          twitch = {
            type = 'button',
            text = 'Twitch',
            onClick = function()
              print("Twitch");
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
                  onClick = function() db:ResetProfile() end
                },
                cancel = {
                  text    = 'Cancel',
                  onClick = function() end
                }
              }
              StdUi:Confirm('Reset UI', 'Confirm if u want to fully reset your UI', buttons)
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
              print("test");
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