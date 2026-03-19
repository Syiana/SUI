local Layout = SUI:NewModule('Config.Layout.Tooltip')

function Layout:OnEnable()
    -- Database
    local db = SUI.db
    local TooltipModule = SUI:GetModule("Tooltip.Core", true)

    local function refreshTooltipAnchor()
        if TooltipModule and TooltipModule.RefreshAnchor then
            TooltipModule:RefreshAnchor()
        end
    end

    local function refreshTooltipLifeOnTop()
        if TooltipModule and TooltipModule.RefreshLifeOnTop then
            TooltipModule:RefreshLifeOnTop()
        end
    end

    local function refreshTooltipHideInCombat()
        if TooltipModule and TooltipModule.RefreshHideInCombat then
            TooltipModule:RefreshHideInCombat()
        end
    end

    -- Layout
    Layout.layout = {
        layoutConfig = { padding = { top = 15 } },
        database = db.profile.tooltip,
        rows = {
            {
                header = {
                    type = 'header',
                    label = 'Tooltip'
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
                    column = 4,
                    order = 1
                }
            },
            {
                header = {
                    type = 'header',
                    label = 'Behavior'
                },
            },
            {
                mouseanchor = {
                    key = 'mouseanchor',
                    type = 'checkbox',
                    label = 'Mouse Anchor',
                    tooltip = 'Attach tooltip to mouse cursor',
                    column = 4,
                    onChange = refreshTooltipAnchor
                },
                lifeontop = {
                    key = 'lifeontop',
                    type = 'checkbox',
                    label = 'Life on Top',
                    tooltip = 'Show HP bar in tooltip on top',
                    column = 4,
                    onChange = refreshTooltipLifeOnTop
                },
                hideincombat = {
                    key = 'hideincombat',
                    type = 'checkbox',
                    tooltip = 'Hide tooltips while in combat',
                    label = 'Hide in Combat',
                    column = 4,
                    onChange = refreshTooltipHideInCombat
                }
            }
        },
    }
end
