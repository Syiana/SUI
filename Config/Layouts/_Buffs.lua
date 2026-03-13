local Layout = SUI:NewModule('Config.Layout.Buffs')

function Layout:OnEnable()
    -- Database
    local db = SUI.db
    local Buffs = SUI:GetModule("Buffs.Buffs", true)
    local Debuffs = SUI:GetModule("Buffs.Debuffs", true)

    local function refreshTopAuras()
        if Buffs and Buffs.Refresh then
            Buffs:Refresh()
        end

        if Debuffs and Debuffs.Refresh then
            Debuffs:Refresh()
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
                    label = 'Buffs'
                },
            },
            {
                collapse = {
                    key = 'unitframes.buffs.collapse',
                    type = 'checkbox',
                    label = 'Collapse Button',
                    tooltip = 'Show the Collapse button at the Player Buff Frame',
                    column = 3,
                    order = 1,
                    onChange = refreshTopAuras
                },
            },
            {
                bufftextsize = {
                    key = 'unitframes.buffs.textsize',
                    type = 'slider',
                    label = 'Text Size',
                    min = 8,
                    max = 16,
                    column = 4,
                    order = 1,
                    onChange = refreshTopAuras
                },
                buffdurationoffset = {
                    key = 'unitframes.buffs.durationoffset',
                    type = 'slider',
                    label = 'Duration Offset',
                    min = -6,
                    max = 10,
                    column = 4,
                    order = 2,
                    onChange = refreshTopAuras
                }
            },
            {
                buffcountx = {
                    key = 'unitframes.buffs.countx',
                    type = 'slider',
                    label = 'Count X Offset',
                    min = -10,
                    max = 10,
                    column = 4,
                    order = 1,
                    onChange = refreshTopAuras
                },
                buffcounty = {
                    key = 'unitframes.buffs.county',
                    type = 'slider',
                    label = 'Count Y Offset',
                    min = -10,
                    max = 10,
                    column = 4,
                    order = 2,
                    onChange = refreshTopAuras
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Debuffs'
                },
            },
            {
                debufftextsize = {
                    key = 'unitframes.debuffs.textsize',
                    type = 'slider',
                    label = 'Text Size',
                    min = 8,
                    max = 16,
                    column = 4,
                    order = 1,
                    onChange = refreshTopAuras
                },
                debuffdurationoffset = {
                    key = 'unitframes.debuffs.durationoffset',
                    type = 'slider',
                    label = 'Duration Offset',
                    min = -6,
                    max = 10,
                    column = 4,
                    order = 2,
                    onChange = refreshTopAuras
                }
            },
            {
                debuffcountx = {
                    key = 'unitframes.debuffs.countx',
                    type = 'slider',
                    label = 'Count X Offset',
                    min = -10,
                    max = 10,
                    column = 4,
                    order = 1,
                    onChange = refreshTopAuras
                },
                debuffcounty = {
                    key = 'unitframes.debuffs.county',
                    type = 'slider',
                    label = 'Count Y Offset',
                    min = -10,
                    max = 10,
                    column = 4,
                    order = 2,
                    onChange = refreshTopAuras
                }
            }
        },
    }
end
