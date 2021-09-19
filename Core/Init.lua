SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0")

local defaults = {
  profile = {
    install = false,
    general = {
      theme = "Dark",
      font = "Fonts\\FRIZQT__.TTF",
      texture = nil,
      color = "",
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
      style = 'Default',
      classcolor = true,
      factioncolor = true,
      statusglow = false,
      pvpbadge = false,
      combaticon = false,
      links = true,
      buffs = {
        small = 21,
        large = 17,
        purgeborder = true
      },
      raid = {
        alwaysontop = false
      }
    },
    raiframes = {},
    actionbar = {
      buttons = {
        key = true,
        macro = false,
        range = true,
        flash = false,
        size = 1,
        padding = 1
      },
      gryphones = true,
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
		cords = false,
		opacity = false,
		showminimap = true,
		showclock = true,
		showdate = true,
		showgarrison = false,
		showtracking = false,
		showworldmap = false,
	},
    edit = {}
  }
}

if (IsTestBuild) then
  function SUI:OnInitialize()
    -- Database
    self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    -- Color
    function SUI:Color(sub)
      local colors = {
        Blizzard = nil,
        Dark = {0.3, 0.3, 0.3},
        Class = 'class',
        Custom = self.db.profile.general.color,
      }

      local color = colors[self.db.profile.general.theme]
      if (sub) then
        for key, value in pairs(color) do
          color[key] = value - sub
        end
      end

      return color
    end
  end
else
  print("SUI PREALPHA ONLY WORKS ON PTR!")
  DisableAddOn("SUI")
end

function SUI:RefreshConfig()
  print("db changed");
end