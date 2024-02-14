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
                header = {
                    type = 'header',
                    label = 'Extras'
                }
            },
            {
                healthtext = {
                    key = 'healthtext',
                    type = 'checkbox',
                    label = 'Health Text',
                    tooltip = 'Shows the health percentage in the nameplate',
                    column = 4,
                    order = 1
                },
                casttime = {
                    key = 'casttime',
                    type = 'checkbox',
                    label = 'Cast Time',
                    tooltip = 'Show cast time below the cast icon',
                    column = 4,
                    order = 2
                },
                arenanumber = {
                    key = 'arenanumber',
                    type = 'checkbox',
                    label = 'Arena Nameplate',
                    tooltip = 'Shows Arena number over Nameplate',
                    column = 4,
                    order = 3
                },
            },
            {
                totemicons = {
                    key = 'totemicons',
                    type = 'checkbox',
                    label = 'Totem Icons',
                    tooltip = 'Shows Totem icons on Nameplate',
                    column = 4,
                    order = 1
                },
                server = {
                    key = 'server',
                    type = 'checkbox',
                    label = 'Hide Servername',
                    tooltip = 'Hide servernames entirely on nameplates',
                    column = 4,
                    order = 2
                },
                color = {
                    key = 'color',
                    type = 'checkbox',
                    label = 'Classcolor Playernames',
                    tooltip = 'Show Playernames in their class color',
                    column = 4,
                    order = 3
                },
            },
            {
                debuffs = {
                    key = 'debuffs',
                    type = 'checkbox',
                    label = 'Hide Debuffs',
                    tooltip = 'Hides your own debuffs above of the nameplates',
                    column = 4,
                    order = 3
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Options'
                }
            },
            {
                stackingmode = {
                    key = 'stackingmode',
                    type = 'checkbox',
                    label = 'Smart Stacking Mode',
                    tooltip = 'Enabled = Smart Stacking Mode / Disabled = Overlapping Nameplates',
                    column = 4,
                    order = 1
                },
            },
            {
                height = {
                    key = 'height',
                    type = 'slider',
                    label = 'Height',
                    precision = 1,
                    min = 1,
                    max = 5,
                    column = 4,
                    order = 1
                },
                width = {
                    key = 'width',
                    type = 'slider',
                    label = 'Width',
                    precision = 1,
                    min = 1,
                    max = 5,
                    column = 4,
                    order = 2
                }
            }
        },
    }
end
