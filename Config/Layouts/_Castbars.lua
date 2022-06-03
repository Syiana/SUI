local Layout = SUI:NewModule('Config.Layout.Castbars')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Layout
  Layout.layout = {
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
  }
end
