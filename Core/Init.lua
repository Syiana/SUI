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
        afkscreen = true
      },
      display = {
        fps = true,
        ms = true
      }
    },
    unitframes = {
      style = 'Default',
      portrait = 'ClassIcon',
      classcolor = true,
      factioncolor = true,
      statusglow = false,
      pvpbadge = true,
      combaticon = false,
      hitindicator = false,
      size = 1,
      font = {
        size = 11
      },
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
    actionbar = {
      style = 'Default',
      buttons = {
        key = false,
        macro = false,
        range = false,
        flash = false,
        size = 38,
        padding = 5
      },
      menu = {
        style = 'Default',
        mouseovermicro = false,
        mouseoverbags = false
      },
      gryphones = false,
      bindings = true,
    },
    castbars = {
      style = 'Custom',
      timer = true,
      icon = true
    },
    tooltip = {
      style = 'Custom',
      hideincombat = false,
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
      shortchannels = false,
    },
    maps = {
      minimap = true,
      clock = true,
      date = false,
      tracking = false,
	  },
    misc = {
      safequeue = true,
      tabbinder = false,
      interrupt = false,
      arenanameplate = false,
      fastloot = true,
      vendorprice = true
    },
    edit = {}
  }
}

function SUI:OnInitialize()
  -- SUI 8.0
  if (SUIDB and SUIDB.A_DEFAULTS) then
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
    Dark = {0.3, 0.3, 0.3},
    Class = {classColor.r, classColor.g, classColor.b},
    Custom = {customColor.r, customColor.g, customColor.b},
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
        Dark = {0.3, 0.3, 0.3},
        Class = {classColor.r, classColor.g, classColor.b},
        Custom = {customColor.r, customColor.g, customColor.b},
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
      local color = {0, 0, 0, alpha}
      for key, value in pairs(theme) do
        if (sub) then color[key] = value - sub else color[key] = value end
      end
      return color
    end
  end
end