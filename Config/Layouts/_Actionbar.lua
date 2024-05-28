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
                range = {
                    key = 'buttons.range',
                    type = 'checkbox',
                    label = 'Range Color',
                    tooltip = 'Show spell-color in red if out of range',
                    column = 4,
                    order = 1
                },
                size = {
                    key = 'buttons.size',
                    type = 'slider',
                    label = 'Text size',
                    max = 20,
                    column = 4,
                    order = 1
                },
            },
            {
                bagbar = {
                    key = 'menu.bagbar',
                    type = 'dropdown',
                    label = 'Bag Buttons',
                    column = 4,
                    order = 2,
                    options = {
                        { value = 'show', text = 'Show' },
                        { value = 'mouse_over', text = 'Show on Mouseover' },
                        { value = 'hide', text = 'Hide' }
                    }
                },
                micromenu = {
                    key = 'menu.micromenu',
                    type = 'dropdown',
                    label = 'MicroMenu',
                    column = 4,
                    order = 3,
                    options = {
                        { value = 'show', text = 'Show' },
                        { value = 'mouse_over', text = 'Show on Mouseover' },
                        { value = 'hide', text = 'Hide' }
                    },
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Show on Mouseover'
                },
            },
            {
                actionbar1 = {
                    key = 'bars.bar1',
                    type = 'checkbox',
                    label = 'Bar 1',
                    column = 3,
                    order = 1
                },
                actionbar2 = {
                    key = 'bars.bar2',
                    type = 'checkbox',
                    label = 'Bar 2',
                    column = 3,
                    order = 2
                },
                actionbar3 = {
                    key = 'bars.bar3',
                    type = 'checkbox',
                    label = 'Bar 3',
                    column = 3,
                    order = 3
                },
                actionbar4 = {
                    key = 'bars.bar4',
                    type = 'checkbox',
                    label = 'Bar 4',
                    column = 3,
                    order = 4
                }
            },
            {
                actionbar5 = {
                    key = 'bars.bar5',
                    type = 'checkbox',
                    label = 'Bar 5',
                    column = 3,
                    order = 1
                },
                actionbar6 = {
                    key = 'bars.bar6',
                    type = 'checkbox',
                    label = 'Bar 6',
                    column = 3,
                    order = 2
                },
                actionbar7 = {
                    key = 'bars.bar7',
                    type = 'checkbox',
                    label = 'Bar 7',
                    column = 3,
                    order = 3
                },
                actionbar8 = {
                    key = 'bars.bar8',
                    type = 'checkbox',
                    label = 'Bar 8',
                    column = 3,
                    order = 4
                }
            },
            {
                petbar = {
                    key = 'bars.petbar',
                    type = 'checkbox',
                    label = 'Pet Bar',
                    column = 3,
                    order = 1
                },
                stancebar = {
                    key = 'bars.stancebar',
                    type = 'checkbox',
                    label = 'Stance Bar',
                    column = 3,
                    order = 2
                },
            }
        }
    }
end
