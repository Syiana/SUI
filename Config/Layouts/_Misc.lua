local Layout = SUI:NewModule('Config.Layout.Misc')

function Layout:OnEnable()
  -- Database
  local db = SUI.db

  -- Components
  local CvarsBrowser = SUI:GetModule("Config.Components.CvarsBrowser")

  -- Layout
  Layout.layout = {
    layoutConfig = { padding = { top = 15 } },
    database = db.profile.misc,
    rows = {
      {
        header = {
          type = 'header',
          label = 'Misc'
        }
      },
      {
        cvars = {
          type = 'button',
          text = 'CVars Browser',
          onClick = function()
            CvarsBrowser.Show()
          end,
          column = 3,
          order = 3
        }
      },
      {
        header = {
          type = 'header',
          label = 'General'
        }
      },
      {
        interrupt = {
          key = 'interrupt',
          type = 'checkbox',
          label = 'Interrupt',
          tooltip = 'Announce successful interrupts party',
          column = 3,
          order = 1
        }
      },
      {
        header = {
          type = 'header',
          label = 'PvP'
        }
      },
      {
        safequeue = {
          key = 'safequeue',
          type = 'checkbox',
          label = 'SafeQueue',
          tooltip = 'Show time left to join and remove leave-button on queuepop-window',
          column = 3,
          order = 1
        },
        tabbinder = {
          key = 'tabbinder',
          type = 'checkbox',
          label = 'Tab Binder',
          tooltip = 'Only target players with TAB in PVP-Combat',
          column = 3,
          order = 1
        },
        dampening = {
          key = 'dampening',
          type = 'checkbox',
          label = 'Dampening',
          tooltip = 'Shows dampening right below the arena timer',
          column = 3,
          order = 1
        },
        surrender = {
          key = 'surrender',
          type = 'checkbox',
          label = 'Surrender',
          tooltip = 'Allows you to surrender by typing /gg',
          column = 3,
          order = 1
        },
      },
      {
        losecontrol= {
          key = 'losecontrol',
          type = 'checkbox',
          label = 'LoseControl',
          tooltip = 'More transparent Loss of Control Alert frame',
          column = 3,
          order = 1
        },
      }
    },
  }
end
