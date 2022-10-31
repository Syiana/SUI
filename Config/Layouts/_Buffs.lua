local Layout = SUI:NewModule('Config.Layout.Buffs')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Layout
  Layout.layout = {
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
        border = {
          key = 'unitframes.buffs.purgeborder',
          type = 'checkbox',
          label = 'Purge Border',
          tooltip = 'Highlight purgable buffs',
          column = 3,
          order = 1
        }
      },
      {
        big = {
          key = 'unitframes.buffs.size',
          type = 'slider',
          label = 'Big Buff Size',
          max = 50,
          column = 4,
          order = 2
        },
        small = {
          key = 'unitframes.debuffs.size',
          type = 'slider',
          label = 'Small Buff Size',
          max = 50,
          column = 4,
          order = 3
        }
      }
    },
  }
end
