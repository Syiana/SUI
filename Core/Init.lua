SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0")

local defaults = {
  profile = {
    install = false,
    general = {
      theme = "Dark",
      font = nil,
      texture = 'Interface\\AddOns\\SUI\\Media\\Textures\\Status\\Smooth',
      color = {},
      automation = {
        delete = true,
        decline = false,
        repair = true,
        sell = true,
        invite = true,
        release = true,
        resurrect = true,
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
      classcolor = true,
      factioncolor = true,
      statusglow = false,
      pvpbadge = false,
      combaticon = false,
      links = true,
      buffs = {
        small = 26,
        large = 26,
        purgeborder = true
      },
      raid = {
        alwaysontop = false
      }
    },
    raiframes = {},
    actionbar = {
      style = 'Default',
      buttons = {
        key = true,
        macro = false,
        range = true,
        flash = false,
        size = 1,
        padding = 1
      },
      menu = {
        mouseover = false
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
      style = 'Custom'
    },
    maps = {
      small = false,
      opacity = false,
      coordinates = false,
      showminimap = true,
      showclock = true,
      showdate = true,
      showgarrison = true,
      showtracking = false,
      showworldmap = false,
      classstyle = false
	  },
    misc = {
      safequeue = true,
      losecontrol = true,
      tabbinder = false,
      pulltimer = false,
      interrupt = false
    },
    edit = {}
  }
}

function SUI:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)

  -- Color
  function SUI:Color(sub)
    local colors = {
      Blizzard = nil,
      Dark = {0.3, 0.3, 0.3},
      Class = 'class',
      Custom = self.db.profile.general.color,
    }

    local color = colors[self.db.profile.general.theme]
    if (color and sub) then
      for key, value in pairs(color) do
        color[key] = value - sub
      end
    end

    return color
  end
end