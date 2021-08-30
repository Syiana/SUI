local Defaults = SUI:NewModule("Config.Defaults");

Defaults.profile = {
  profile = {
    general = {
      font = "Fonts\\FRIZQT__.TTF",
      texture = "",
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
    buffs = {},
    chat = {
      style = 'Custom'
    },
    maps = {},
    edit = {}
  }
}