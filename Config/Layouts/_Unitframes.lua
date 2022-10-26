local Layout = SUI:NewModule('Config.Layout.Unitframes')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Data
  local Textures = SUI:GetModule("Data.Textures")

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
        style = {
          key = 'unitframes.style',
          type = 'dropdown',
          label  = 'Style',
          options = {
            { value = 'Default', text = 'Default' },
            { value = 'Big', text = 'Big' },
            { value = 'Small', text = 'Transparent' }
          },
          column = 4,
          order = 1
        },
        portrait = {
          key = 'unitframes.portrait',
          type = 'dropdown',
          label = 'Portrait',
          options = {
            { value = 'Default', text = 'Default' },
            { value = 'ClassIcon', text = 'ClassIcon' },
          },
          column = 4,
          order = 2
        },
        size = {
          key = 'unitframes.size',
          type = 'slider',
          label = 'Frame Size',
          precision = 1,
          min = 0.1,
          max = 5,
          column = 4,
          order = 3,
          onChange = function(slider)
            PlayerFrame:SetScale(slider.value)
            TargetFrame:SetScale(slider.value)
            FocusFrame:SetScale(slider.value)
          end,
        }
      },
      {
        class = {
          key = 'unitframes.classcolor',
          type = 'checkbox',
          label = 'Class Color',
          tooltip = 'Change healthcolor to class color',
          column = 4,
        },
        pvp = {
          key = 'unitframes.pvpbadge',
          type = 'checkbox',
          label = 'PvP Badge',
          tooltip = 'Display PVP icon on Unit frames',
          column = 4,
        },
        hitindicator = {
          key = 'unitframes.hitindicator',
          type = 'checkbox',
          label = 'Hit indicator',
          column = 4,
          order = 1
        },
      },
      {
        combat = {
          key = 'unitframes.combaticon',
          type = 'checkbox',
          label = 'Combat Icon',
          tooltip = 'Display combat icon on Unit frames',
          column = 4,
          order = 2
        },
        link = {
          key = 'unitframes.links',
          type = 'checkbox',
          label = 'Char Links',
          tooltip = 'Extra menu to generate character-links for Check-PVP, Raider.io, etc.',
          column = 4,
          order = 3
        }
      },
      {
        header = {
          type = 'header',
          label = 'Raidframes'
        },
      },
      {
        style = {
          key = 'raidframes.texture',
          type = 'dropdown',
          label = 'Texture',
          options = Textures.data,
          column = 5
        }
      },
    },
  }
end
