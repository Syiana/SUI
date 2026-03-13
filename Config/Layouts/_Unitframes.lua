local Layout = SUI:NewModule('Config.Layout.Unitframes')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Data
    local Textures = SUI:GetModule("Data.Textures")
    local TargetModule = SUI:GetModule("UnitFrames.Target", true)

    local function refreshTargetAuras()
        if TargetModule and TargetModule.RefreshAuras then
            TargetModule:RefreshAuras()
        end
    end

    -- Layout
    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Player and Target'
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
                    label = 'Raid and Party'
                },
            },
            {
                texture = {
                    key = 'raidframes.texture',
                    type = 'dropdown',
                    label = 'Texture',
                    options = Textures.data,
                    column = 4,
                    order = 1
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Target Auras'
                },
            },
            {
                buffsize = {
                    key = 'unitframes.buffs.size',
                    type = 'slider',
                    label = 'Target Buff Size',
                    max = 50,
                    column = 4,
                    order = 1,
                    onChange = refreshTargetAuras
                },
                debuffsize = {
                    key = 'unitframes.debuffs.size',
                    type = 'slider',
                    label = 'Target Debuff Size',
                    max = 50,
                    column = 4,
                    order = 2,
                    onChange = refreshTargetAuras
                },
            },
            {
                buffx = {
                    key = 'unitframes.buffs.targetx',
                    type = 'slider',
                    label = 'Buff X Offset',
                    min = -50,
                    max = 50,
                    column = 4,
                    order = 1,
                    onChange = refreshTargetAuras
                },
                buffy = {
                    key = 'unitframes.buffs.targety',
                    type = 'slider',
                    label = 'Buff Y Offset',
                    min = -50,
                    max = 50,
                    column = 4,
                    order = 2,
                    onChange = refreshTargetAuras
                },
            },
            {
                debuffx = {
                    key = 'unitframes.debuffs.targetx',
                    type = 'slider',
                    label = 'Debuff X Offset',
                    min = -50,
                    max = 50,
                    column = 4,
                    order = 1,
                    onChange = refreshTargetAuras
                },
                debuffy = {
                    key = 'unitframes.debuffs.targety',
                    type = 'slider',
                    label = 'Debuff Y Offset',
                    min = -50,
                    max = 50,
                    column = 4,
                    order = 2,
                    onChange = refreshTargetAuras
                },
            },
        },
    }
end
