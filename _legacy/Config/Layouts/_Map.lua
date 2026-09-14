local Layout = SUI:NewModule('Config.Layout.Map')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Layout
    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile.maps,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Worldmap'
                }
            },
            {
                opacity = {
                    key = 'opacity',
                    type = 'slider',
                    label = 'Opacity',
                    precision = 1,
                    min = 0.1,
                    max = 1,
                    column = 4,
                    order = 1,
                    onChange = function(slider)
                        WorldMapFrame:SetAlpha(slider.value)
                    end,
                },
                cords = {
                    key = 'coords',
                    type = 'checkbox',
                    label = 'Coordinates',
                    tooltip = 'Display coordinates on map',
                    column = 4,
                    order = 2
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Minimap'
                }
            },
            {
                showminimap = {
                    key = 'minimap',
                    type = 'checkbox',
                    label = 'Show Minimap',
                    tooltip = 'Show/Hide minimap',
                    column = 4,
                    order = 1
                },
                showclock = {
                    key = 'clock',
                    type = 'checkbox',
                    label = 'Show Clock',
                    tooltip = 'Show/Hide clock on minimap',
                    column = 4,
                    order = 2
                },
                showdate = {
                    key = 'date',
                    type = 'checkbox',
                    label = 'Show Date',
                    tooltip = 'Show/Hide calendar icon on minimap',
                    column = 4,
                    order = 3
                }
            },
            {
                showtracking = {
                    key = 'tracking',
                    type = 'checkbox',
                    label = 'Tracking Symbol',
                    tooltip = 'Show/Hide tracking icon on minimap',
                    column = 4,
                    order = 1
                },
                buttons = {
                    key = 'buttons',
                    type = 'checkbox',
                    label = 'Buttons on Mouseover',
                    tooltip = 'Show minimap buttons on mouseover',
                    column = 4,
                    order = 2
                },
                expansionbutton = {
                    key = 'expansionbutton',
                    type = 'checkbox',
                    label = 'Expansion Button Mouseover',
                    tooltip = 'Show Expansion Button on mouseover',
                    column = 4,
                    order = 3
                }
            }
        },
    }
end
