local Layout = SUI:NewModule('Config.Layout.Chat')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Layout
    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile.chat,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Chat'
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
                    column = 5,
                    order = 1
                }
            },
            {
                chatinput = {
                    key = 'top',
                    type = 'checkbox',
                    label = 'Input on Top',
                    tooltip = 'Move chat input field to top of chat',
                    column = 4,
                    order = 1
                },
                link = {
                    key = 'link',
                    type = 'checkbox',
                    label = 'Link copy',
                    tooltip = 'Make links clickable to copy them',
                    column = 4,
                    order = 2
                },
                copy = {
                    key = 'copy',
                    type = 'checkbox',
                    label = 'Copy Symbol',
                    tooltip = 'Show/Hide copy chat-history icon',
                    column = 4,
                    order = 3
                },
            },
            {
                quickjoin = {
                    key = 'quickjoin',
                    type = 'checkbox',
                    label = 'Friendlist Button',
                    tooltip = 'Show/Hide friendlist button'
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Friendlist'
                }
            },
            {
                friendlist = {
                    key = 'friendlist',
                    type = 'checkbox',
                    label = 'Class-Friendlist',
                    tooltip = 'Show character names in class color in friendlist',
                    column = 4,
                    order = 1
                }
            }
        },
    }
end
