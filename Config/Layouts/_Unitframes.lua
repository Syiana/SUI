local Layout = SUI:NewModule('Config.Layout.Unitframes')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Data
    local Textures = SUI:GetModule("Data.Textures")
    local Partyprofile = SUI:GetModule("Data.Partyprofile")

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
                    key     = 'unitframes.style',
                    type    = 'dropdown',
                    label   = 'Style',
                    options = {
                        { value = 'Default', text = 'Default' },
                        --{ value = 'Big', text = 'Big' },
                        --{ value = 'Small', text = 'Transparent' }
                    },
                    column  = 4,
                    order   = 1
                },
                texture = {
                    key = 'general.texture',
                    type = 'dropdown',
                    label = 'Texture',
                    options = Textures.data,
                    column = 4,
                    order = 3
                },
            },
            {
                class = {
                    key = 'unitframes.classcolor',
                    type = 'checkbox',
                    label = 'Class Color',
                    tooltip = 'Change healthcolor to class color',
                    column = 4,
                    order = 1
                },
                pvp = {
                    key = 'unitframes.pvpbadge',
                    type = 'checkbox',
                    label = 'PvP Badge',
                    tooltip = 'Display PVP icon on Unit frames',
                    column = 4,
                    order = 2
                },
                hitindicator = {
                    key = 'unitframes.hitindicator',
                    type = 'checkbox',
                    label = 'Hit indicator',
                    tooltip = 'Display numbers on Player Portrait',
                    column = 4,
                    order = 3
                },
            },
            {
                combat = {
                    key = 'unitframes.combaticon',
                    type = 'checkbox',
                    label = 'Combat Icon',
                    tooltip = 'Display combat icon on Unitframes',
                    column = 4,
                    order = 1
                },
                totemicons = {
                    key = 'unitframes.totemicons',
                    type = 'checkbox',
                    label = 'Totem Icons',
                    tooltip = 'Show Totem Icons (Consecration duration etc.) below the Player Unitframe',
                    column = 4,
                    order = 2,
                },
                classbar = {
                    key = 'unitframes.classbar',
                    type = 'checkbox',
                    label = 'Class Bar',
                    tooltip = 'Show ClassBar (Combopoints, HolyPower etc.)',
                    column = 4,
                    order = 3,
                }
            },
            {
                cornericon = {
                    key = 'unitframes.cornericon',
                    type = 'checkbox',
                    label = 'Corner Icon',
                    tooltip = 'Display corner icon on Unitframes',
                    column = 4,
                    order = 1
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Raid/Party Frame'
                },
            },
            {
                style = {
                    key = 'raidframes.texture',
                    type = 'dropdown',
                    label = 'Texture',
                    options = Textures.data,
                    column = 4,
                    order = 1
                },
            },
        },
    }
end
