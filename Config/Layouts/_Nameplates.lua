local Layout = SUI:NewModule('Config.Layout.Nameplates')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Layout
  Layout.layout = {
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
  }
end
