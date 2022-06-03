local Layout = SUI:NewModule('Config.Layout.Map')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Layout
  Layout.layout = {
    layoutConfig = { padding = { top = 15 } },
    database = db.profile.maps,
    rows = {
      {
        header = {
          type = 'header',
          label = 'Worldmap'
        }
      },
      {
        small = {
          key = 'small',
          type = 'checkbox',
          label = 'Small Map',
          tooltip = 'coming soon.',
          column = 4,
          order = 1
        },
        cords = {
          key = 'coords',
          type = 'checkbox',
          label = 'Coords',
          tooltip = 'Display coordinates on map',
          column = 4,
          order = 2
        },
        opacity = {
          key = 'opacity',
          type = 'checkbox',
          label = 'Opacity',
          tooltip = 'coming soon.',
          column = 4,
          order = 3
        }
      },
      {
        header = {
          type = 'header',
          label = 'Minimap'
        }
      },
      {
        style = {
          key = 'style',
          type = 'dropdown',
          label = 'Style',
          options = {
            { value = 'Default', text = 'Default' },
            { value = 'Legion', text = 'Legion' }
          },
          initialValue = 1,
          column = 5,
          order = 1
        }
      },
      {
        showminimap = {
          key = 'minimap',
          type = 'checkbox',
          label = 'Show Minimap',
          tooltip = 'Show/Hide minimap',
          column = 4,
          order = 1
        },
        showclock = {
          key = 'clock',
          type = 'checkbox',
          label = 'Show Clock',
          tooltip = 'Show/Hide clock on minimap',
          column = 4,
          order = 2
        },
        showdate = {
          key = 'date',
          type = 'checkbox',
          label = 'Show Date',
          tooltip = 'Show/Hide calendar icon on minimap',
          column = 4,
          order = 3
        }
      },
      {
        showgarrison = {
          key = 'garrison',
          type = 'checkbox',
          label = 'Garrison Symbol',
          tooltip = 'Show/Hide covenant icon on minimap',
          column = 4,
          order = 1
        },
        showtracking = {
          key = 'tracking',
          type = 'checkbox',
          label = 'Tracking Symbol',
          tooltip = 'Show/Hide tracking icon on minimap',
          column = 4,
          order = 2
        }
      }
    },
  }
end
