local Layout = SUI:NewModule('Config.Layout.Profiles')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Layout
  -- Layout.layout = {
  --   layoutConfig = { padding = { top = 15 } },
  --   rows = {
  --     {
  --       header = {
  --         type = 'header',
  --         label = 'Profiles'
  --       }
  --     },
  --     {
  --       profile = {
  --         type = 'dropdown',
  --         label = 'Profile',
  --         options = {
  --           { value = 1, text = 'Default' },
  --           { value = 2, text = 'Custom' }
  --         },
  --         initialValue = 1,
  --         column = 6,
  --         order = 1
  --       }
  --     },
  --     {
  --       copy = {
  --         type = 'dropdown',
  --         label = 'Copy from',
  --         options = {
  --           { value = 1, text = 'Default' },
  --           { value = 2, text = 'Custom' }
  --         },
  --         initialValue = 1,
  --         column = 6,
  --         order = 1
  --       }
  --     },
  --     {
  --       new = {
  --         type = 'button',
  --         text = 'New',
  --         onClick = function()
  --           print("new profile");
  --         end,
  --         column = 3,
  --         order = 1
  --       },
  --       delete = {
  --         type = 'button',
  --         text = 'Delete',
  --         column = 3,
  --         order = 2
  --       },
  --       export = {
  --         type = 'button',
  --         text = 'Export',
  --         column = 3,
  --         order = 3
  --       },
  --       import = {
  --         type = 'button',
  --         text = 'Import',
  --         column = 3,
  --         order = 4
  --       }
  --     }
  --   },
  -- }

  Layout.layout = {
    layoutConfig = { padding = { top = 15 } },
    rows = {
      {
        header = {
          type = 'header',
          label = 'Profiles'
        }
      },
      {
        profile = {
          type = 'label',
          label = 'coming soon ...',
        }
      }
    },
  }
end
