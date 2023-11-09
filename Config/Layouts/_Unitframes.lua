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
                    tooltip = 'Display combat icon on Unit frames',
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
                size = {
                    key = 'raidframes.size',
                    type = 'dropdown',
                    label = 'Custom Size',
                    options = {
                        { value = true, text = 'Enabled' },
                        { value = false, text = 'Disabled' }
                    },
                    tooltip = 'Enable Custom Party-Raidframestyle Sizing',
                    column = 4,
                    order = 2
                },
            },
            {
                partyheight = {
                    key = 'raidframes.height',
                    type = 'slider',
                    label = 'Height',
                    precision = 1,
                    min = 50,
                    max = 300,
                    column = 4,
                    order = 1,
                    onChange = function(slider)
                        if db.profile.raidframes.size then
                            for i = 1, 5 do
                                _G["CompactPartyFrameMember" .. i]:SetHeight(slider.value)
                                _G["CompactPartyFrameMember" .. i .. "StatusText"]:ClearAllPoints()
                                _G["CompactPartyFrameMember" .. i .. "StatusText"]:SetPoint("CENTER",
                                    _G["CompactPartyFrameMember" .. i], "CENTER")
                            end
                        end
                    end,
                },
                partywidth = {
                    key = 'raidframes.width',
                    type = 'slider',
                    label = 'Width',
                    precision = 1,
                    min = 50,
                    max = 300,
                    column = 4,
                    order = 2,
                    onChange = function(slider)
                        if db.profile.raidframes.size then
                            for i = 1, 5 do
                                _G["CompactPartyFrameMember" .. i]:SetWidth(slider.value)
                                _G["CompactPartyFrameMember" .. i .. "StatusText"]:ClearAllPoints()
                                _G["CompactPartyFrameMember" .. i .. "StatusText"]:SetPoint("CENTER",
                                    _G["CompactPartyFrameMember" .. i], "CENTER")
                            end
                        end
                    end,
                }
            },
        },
    }
end
