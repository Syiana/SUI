local Layout = SUI:NewModule('Config.Layout.Nameplates')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Data
  local Textures = SUI:GetModule("Data.Textures")

  -- Layout
  Layout.layout = {
    layoutConfig = { padding = { top = 15 } },
    database = db.profile.nameplates,
    rows = {
      {
        header = {
          type = 'header',
          label = 'Nameplates'
        }
      },
      {
        style = {
          key = 'style',
          label = 'Style',
          type = 'dropdown',
          options = {
            { value = 'Default', text = 'Default' },
            { value = 'Custom', text = 'Custom' }
          },
          initialValue = 1,
          column = 5,
          order = 1
        },
        texture = {
          key = 'texture',
          type = 'dropdown',
          label = 'Texture',
          options = Textures.data,
          column = 5,
          order = 2
        }
      },
      {
        size = {
          type = 'slider',
          label = 'Size',
          max = 5,
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
        arenanumber = {
          key = 'arenanumber',
          type = 'checkbox',
          label = 'Arena Nameplate',
          tooltip = 'Shows Arena number over Nameplate',
          column = 4,
          order = 1
        },
        totemicons = {
          key = 'totemicons',
          type = 'checkbox',
          label = 'Totem Icons',
          tooltip = 'Shows Totem icons on Nameplate',
          column = 4,
          order = 1
        },
      }
    },
  }
end
