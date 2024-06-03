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
        stackbuy = true,
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
        mouseover = false,
        hidebag = false,
      },
      gryphones = true,
    },
    castbars = {
      style = 'Custom',
      timer = true,
      icon = true
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