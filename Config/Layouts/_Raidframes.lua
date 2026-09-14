local Layout = SUI:NewModule('Config.Layout.Raidframes')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Data
    local Textures = SUI:GetModule("Data.Textures")
    local RaidFramesModule = SUI:GetModule("RaidFrames.Core", true)
    local AuraModule = SUI:GetModule("RaidFrames.Auras", true)

    local function refreshRaidFrames()
        if RaidFramesModule and RaidFramesModule.RefreshLayout then
            RaidFramesModule:RefreshLayout()
        end
    end

    local function refreshRaidAuras()
        if AuraModule and AuraModule.Refresh then
            AuraModule:Refresh()
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
                    label = 'Party and Raid Frames'
                },
            },
            {
                texture = {
                    key = 'raidframes.texture',
                    type = 'dropdown',
                    label = 'Texture',
                    options = Textures.data,
                    column = 4,
                    order = 1,
                    onChange = refreshRaidFrames
                },
                partyscale = {
                    key = 'raidframes.partyscale',
                    type = 'slider',
                    label = 'Party Frame Scale',
                    min = 0.5,
                    max = 1.5,
                    step = 0.1,
                    column = 4,
                    order = 2,
                    onChange = refreshRaidFrames
                },
                raidscale = {
                    key = 'raidframes.raidscale',
                    type = 'slider',
                    label = 'Raid Frame Scale',
                    min = 0.5,
                    max = 1.5,
                    step = 0.1,
                    column = 4,
                    order = 3,
                    onChange = refreshRaidFrames
                },
            },
            {
                size = {
                    key = 'raidframes.size',
                    type = 'checkbox',
                    label = 'Custom Party Frame Size',
                    tooltip = 'Size the party frames yourself instead of leaving them at the Blizzard size|n|nRequires a reload',
                    column = 4,
                    order = 1
                },
                width = {
                    key = 'raidframes.width',
                    type = 'slider',
                    label = 'Party Frame Width',
                    min = 50,
                    max = 200,
                    step = 1,
                    column = 4,
                    order = 2
                },
                height = {
                    key = 'raidframes.height',
                    type = 'slider',
                    label = 'Party Frame Height',
                    min = 30,
                    max = 150,
                    step = 1,
                    column = 4,
                    order = 3
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Auras'
                },
            },
            {
                aurasenabled = {
                    key = 'raidframes.auras.enabled',
                    type = 'checkbox',
                    label = 'SUI Auras',
                    tooltip =
                    'Draw buffs, debuffs and defensives on the party and raid frames ourselves|n|nTurning this off hands the rows straight back to Blizzard',
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                auratooltips = {
                    key = 'raidframes.auras.tooltips',
                    type = 'checkbox',
                    label = 'Aura Tooltips',
                    tooltip = 'Show a tooltip when you hover one of the icons',
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Buffs'
                },
            },
            {
                buffmode = {
                    key = 'raidframes.auras.buffs.mode',
                    type = 'dropdown',
                    label = 'Buffs',
                    options = {
                        { value = 'mine', text = 'Show Own' },
                        { value = 'all',  text = 'Show All' },
                        { value = 'hide', text = 'Hide' }
                    },
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                bufffilter = {
                    key = 'raidframes.auras.buffs.filter',
                    type = 'dropdown',
                    label = 'Buff Filter',
                    tooltip =
                    'Which buffs are worth a slot|n|nRaid Buffs is the selection the default raid frames draw|n|nImportant Only is stricter and keeps just what the game flags as important',
                    options = {
                        { value = 'raid',      text = 'Raid Buffs' },
                        { value = 'important', text = 'Important Only' },
                        { value = 'all',       text = 'Everything' }
                    },
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
                buffpoint = {
                    key = 'raidframes.auras.buffs.point',
                    type = 'dropdown',
                    label = 'Buff Corner',
                    options = {
                        { value = 'BOTTOMRIGHT', text = 'Bottom Right' },
                        { value = 'BOTTOMLEFT',  text = 'Bottom Left' }
                    },
                    column = 4,
                    order = 3,
                    onChange = refreshRaidAuras
                },
            },
            {
                buffsize = {
                    key = 'raidframes.auras.buffs.size',
                    type = 'slider',
                    label = 'Buff Size',
                    tooltip = 'Icon size as a share of the frame height',
                    min = 15,
                    max = 60,
                    step = 1,
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                buffmax = {
                    key = 'raidframes.auras.buffs.max',
                    type = 'slider',
                    label = 'Max Buffs',
                    min = 1,
                    max = 6,
                    step = 1,
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
                buffperrow = {
                    key = 'raidframes.auras.buffs.perrow',
                    type = 'slider',
                    label = 'Buffs Per Row',
                    min = 1,
                    max = 6,
                    step = 1,
                    column = 4,
                    order = 3,
                    onChange = refreshRaidAuras
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Debuffs'
                },
            },
            {
                debuffmode = {
                    key = 'raidframes.auras.debuffs.mode',
                    type = 'dropdown',
                    label = 'Debuffs',
                    options = {
                        { value = 'all',         text = 'Show All' },
                        { value = 'dispellable', text = 'Show Dispellable' },
                        { value = 'hide',        text = 'Hide' }
                    },
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                debufflead = {
                    key = 'raidframes.auras.debuffs.lead',
                    type = 'checkbox',
                    label = 'Enlarge Boss Debuffs',
                    tooltip = 'Draw boss and role debuffs larger, at the front of the row',
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
            },
            {
                debuffsize = {
                    key = 'raidframes.auras.debuffs.size',
                    type = 'slider',
                    label = 'Debuff Size',
                    tooltip = 'Icon size as a share of the frame height',
                    min = 20,
                    max = 80,
                    step = 1,
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                debuffmax = {
                    key = 'raidframes.auras.debuffs.max',
                    type = 'slider',
                    label = 'Max Debuffs',
                    min = 1,
                    max = 6,
                    step = 1,
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Defensives'
                },
            },
            {
                defensivemode = {
                    key = 'raidframes.auras.defensives.mode',
                    type = 'dropdown',
                    label = 'Defensives',
                    options = {
                        { value = 'big',  text = 'Major Only' },
                        { value = 'all',  text = 'Major and External' },
                        { value = 'hide', text = 'Hide' }
                    },
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                defensivepoint = {
                    key = 'raidframes.auras.defensives.point',
                    type = 'dropdown',
                    label = 'Position',
                    options = {
                        { value = 'CENTER', text = 'Center' },
                        { value = 'LEFT',   text = 'Left' },
                        { value = 'RIGHT',  text = 'Right' }
                    },
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
            },
            {
                defensivesize = {
                    key = 'raidframes.auras.defensives.size',
                    type = 'slider',
                    label = 'Defensive Size',
                    tooltip = 'Icon size as a share of the frame height',
                    min = 20,
                    max = 100,
                    step = 1,
                    column = 4,
                    order = 1,
                    onChange = refreshRaidAuras
                },
                defensivex = {
                    key = 'raidframes.auras.defensives.x',
                    type = 'slider',
                    label = 'X Offset',
                    min = -50,
                    max = 50,
                    step = 1,
                    column = 4,
                    order = 2,
                    onChange = refreshRaidAuras
                },
                defensivey = {
                    key = 'raidframes.auras.defensives.y',
                    type = 'slider',
                    label = 'Y Offset',
                    min = -50,
                    max = 50,
                    step = 1,
                    column = 4,
                    order = 3,
                    onChange = refreshRaidAuras
                },
            },
        },
    }
end
