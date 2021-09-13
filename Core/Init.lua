SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0")

local defaults = {
  profile = {
    install = false,
    general = {
      theme = "Dark",
      font = "Fonts\\FRIZQT__.TTF",
      texture = "Default",
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
    maps = {},
    edit = {}
  }
}

function SUI:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)
  self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

function SUI:RefreshConfig()
  print("db changed");
end