local Layout = SUI:NewModule('Config.Layout.Actionbar')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Layout
  Layout.layout = {
    layoutConfig = { padding = { top = 15 } },
    database = db.profile.actionbar,
    rows = {
      {
        header = {
          type = 'header',
          label = 'Actionbar'
        }
      },
      {
        style = {
          key = 'style',
          label = 'Style',
          type = 'dropdown',
          options = {
            { value = 'Default', text = 'Default' },
            { value = 'DefaultNoBg', text = 'Default (hide background)'},
            { value = 'Small', text = 'Small' }
          },
          initialValue = 1,
          column = 5,
          order = 1
        }
      },
      {
        header = {
          type = 'header',
          label = 'Buttons'
        },
      },
      {
        hotkeys = {
          key = 'buttons.key',
          type = 'checkbox',
          label = 'Hotkeys Text',
          tooltip = 'Show Hotkeys text',
          column = 4,
          order = 1
        },
        macros = {
          key = 'buttons.macro',
          type = 'checkbox',
          label = 'Macro Text',
          tooltip = 'Show Macro text',
          column = 4,
          order = 2
        },
        gryphones = {
          key = 'gryphones',
          type = 'checkbox',
          label = 'Gryphones',
          tooltip = 'Show actionbar gryphones',
          column = 4,
          order = 3
        }
      },
      {
        range = {
          key = 'buttons.range',
          type = 'checkbox',
          label = 'Range Color',
          tooltip = 'Show spell-color in red if out of range',
          column = 4,
          order = 1
        },
        flash = {
          key = 'buttons.flash',
          type = 'checkbox',
          label = 'Flash Animation',
          tooltip = 'Flash spell-icon when pressing it',
          column = 4,
          order = 2
        }
      },
      {
        size = {
          key = 'buttons.size',
          type = 'slider',
          label = 'Size',
          max = 50,
          column = 4,
          order = 1
        },
        padding = {
          key = 'buttons.padding',
          type = 'slider',
          label = 'Padding',
          max = 50,
          column = 4,
          order = 2
        }
      },
      {
        header = {
          type = 'header',
          label = 'Micro Menu'
        },
      },
      {
        style = {
          key = 'menu.style',
          type = 'dropdown',
          options = {
            { value = 'Default', text = 'Default' },
            { value = 'Custom', text = 'Custom' }
          },
          initialValue = 1,
          column = 4,
          order = 1
        },
        mouseover = {
          key = 'menu.mouseover',
          type = 'checkbox',
          label = 'Show on Mouseover',
          tooltip = 'Show micromenu on mouseover',
          column = 4,
          order = 2
        },
        bagbuttons = {
          key = 'menu.hidebag',
          type = 'checkbox',
          label = 'Hide bag buttons',
          tooltip = 'Hide background & bag buttons in the micromenu',
          column = 4,
          order = 3
        },
      },
    },
  }
end
