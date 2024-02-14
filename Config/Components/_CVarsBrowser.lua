local CvarsBrowser = SUI:NewModule('Config.Components.CvarsBrowser');

local function buildBrowser()
    local SUIConfig = LibStub('SUIConfig')
    SUIConfig.config = {
        font = {
            family    = STANDARD_TEXT_FONT,
            size      = 12,
            titleSize = 16,
            effect    = 'NONE',
            strata    = 'OVERLAY',
            color     = {
                normal   = { r = 1, g = 1, b = 1, a = 1 },
                disabled = { r = 1, g = 1, b = 1, a = 1 },
                header   = { r = 1, g = 0.9, b = 0, a = 1 },
            }
        },
        backdrop = {
            texture        = [[Interface\Buttons\WHITE8X8]],
            highlight      = { r = 0.40, g = 0.40, b = 0, a = 0.5 },
            panel          = { r = 0.065, g = 0.065, b = 0.065, a = 0.95 },
            slider         = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
            checkbox       = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
            dropdown       = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
            button         = { r = 0.055, g = 0.055, b = 0.055, a = 1 },
            buttonDisabled = { r = 0, g = 0.55, b = 1, a = 0.5 },
            border         = { r = 0.01, g = 0.01, b = 0.01, a = 1 },
            borderDisabled = { r = 0, g = 0.50, b = 1, a = 1 },
        },
        progressBar = {
            color = { r = 1, g = 0.9, b = 0, a = 0.5 },
        },
        highlight = {
            color = { r = 0, g = 0.55, b = 1, a = 0.5 },
            blank = { r = 0, g = 0, b = 0 }
        },
        dialog = {
            width  = 400,
            height = 100,
            button = {
                width  = 100,
                height = 20,
                margin = 5
            }
        },
        tooltip = {
            padding = 10
        }
    }

    local browser = SUIConfig:Window(UIParent, 400, 300, 'Cvars Browser')
    browser:SetPoint('CENTER')
    browser:SetFrameStrata('DIALOG');

    local cols = {
        {
            name   = 'Cvar',
            width  = 300,
            align  = 'LEFT',
            index  = 'cvar',
            format = 'string',
        },
        {
            name     = 'Value',
            width    = 50,
            align    = 'LEFT',
            index    = 'value',
            format   = 'number',
            sortable = false,
            events   = {
                OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                    print(table)
                end
            },
        },
    }

    local search = SUIConfig:SearchEditBox(browser, 380, 24, 'Search')
    SUIConfig:GlueBelow(search, browser, 10, 35, 'LEFT')

    local table = SUIConfig:ScrollTable(browser, cols, 14, 14)
    table:EnableSelection(true);
    SUIConfig:GlueTop(table, browser, 0, -60)

    local data = {
        { cvar = 'coming soon', value = 1 }
    }

    table:SetData(data)
end

CvarsBrowser.Show = function(self)
    buildBrowser()
end
