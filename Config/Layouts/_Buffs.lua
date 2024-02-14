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
                collapse = {
                    key = 'unitframes.buffs.collapse',
                    type = 'checkbox',
                    label = 'Collapse Button',
                    tooltip = 'Show the Collapse button at the Player Buff Frame',
                    column = 3,
                    order = 1
                },
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
