local Layout = SUI:NewModule('Config.Layout.Castbars')

function Layout:OnEnable()
    -- Database
    local db = SUI.db

    -- Layout
    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile.castbars,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Castbars'
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
                casticons = {
                    key = 'icon',
                    type = 'checkbox',
                    label = 'Icons',
                    tooltip = 'Display spell icons on castbar',
                    column = 4
                },
                casttime = {
                    key = 'timer',
                    type = 'checkbox',
                    label = 'Timer',
                    tooltip = 'Display cast time on castbar',
                    column = 4
                },
                targetCastbar = {
                    key = 'targetCastbar',
                    type = 'checkbox',
                    label = 'Target Castbar',
                    tooltip = 'Custom Target Castbar',
                    column = 4
                }
            },
            {
                focusCastbar = {
                    key = 'focusCastbar',
                    type = 'checkbox',
                    label = 'Focus Castbar',
                    tooltip = 'Custom Focus Castbar',
                    column = 4
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Castbar Scales'
                },
            },
            {
                targetSize = {
                    key = 'targetSize',
                    type = 'slider',
                    label = 'Target',
                    precision = 1,
                    min = 0.5,
                    max = 3,
                    column = 4,
                    order = 2,
                    onChange = function(slider)
                        TargetFrameSpellBar:SetScale(slider.value)
                    end,
                },
                focusSize = {
                    key = 'focusSize',
                    type = 'slider',
                    label = 'Focus Target',
                    precision = 1,
                    min = 0.5,
                    max = 3,
                    column = 4,
                    order = 3,
                    onChange = function(slider)
                        FocusFrameSpellBar:SetScale(slider.value)
                    end,
                },
            },
            {
                header = {
                    type = 'header',
                    label = 'Castbar On Top'
                },
            },
            {
                targetOnTop = {
                    key = 'targetOnTop',
                    type = 'checkbox',
                    label = 'Target',
                    tooltip = 'Display the Castbar above its Unitframe',
                    column = 4,
                    order = 1
                },
                focusOnTop = {
                    key = 'focusOnTop',
                    type = 'checkbox',
                    label = 'Focus',
                    tooltip = 'Display the Castbar above its Unitframe',
                    column = 4,
                    order = 2
                },
            }
        }
    }
end
