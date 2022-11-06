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
        buffsize = {
          key = 'unitframes.buffs.size',
          type = 'slider',
          label = 'Buff Size',
          max = 50,
          column = 4,
          order = 2
        },
        debuffsize = {
          key = 'unitframes.debuffs.size',
          type = 'slider',
          label = 'Debuff Size',
          max = 50,
          column = 4,
          order = 3
        }
      }
    },
  }
end
