local Layout = SUI:NewModule('Config.Layout.Tooltip')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Layout
    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile.tooltip,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Tooltip'
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
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Settings'
                },
            },
            {
                mouseanchor = {
                    key = 'mouseanchor',
                    type = 'checkbox',
                    label = 'Mouseanchor',
                    tooltip = 'Attach tooltip to mouse cursor',
                    column = 4
                },
                lifeontop = {
                    key = 'lifeontop',
                    type = 'checkbox',
                    label = 'Life on Top',
                    tooltip = 'Show HP bar in tooltip on top',
                    column = 4
                },
                hideincombat = {
                    key = 'hideincombat',
                    type = 'checkbox',
                    tooltip = 'Hide tooltips while in combat',
                    label = 'Hide in Combat',
                    column = 4
                }
            }
        },
    }
end
