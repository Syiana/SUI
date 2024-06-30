local ProfileExport = SUI:NewModule('Config.Components.ProfileExport');

-- Load Libs
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local SUIConfig = LibStub('SUIConfig')

-- Export Profile Function
function ProfileExport:exportProfile(db)
    --AceSerialize
    local serialized_profile = SUI:Serialize(db.profile)

    --LibDeflate
    local compressed_profile = LibDeflate:CompressZlib(serialized_profile)
    local encoded_profile    = LibDeflate:EncodeForPrint(compressed_profile)
    return encoded_profile
end

local function buildProfileExport()
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

    local window = SUIConfig:Window(UIParent, 400, 325, 'Profile Export')
    window:SetPoint('CENTER')
    window:SetFrameStrata('DIALOG');

    local fadeInfo = {}
    fadeInfo.mode = "IN"
    fadeInfo.timeToFade = 0.2
    fadeInfo.finishedFunc = function()
        window:Show()
    end
    UIFrameFade(window, fadeInfo)

    local editBox = SUIConfig:MultiLineBox(window, 380, 250, ProfileExport:exportProfile(SUI.db), true)
    SUIConfig:GlueTop(editBox, window, 0, -40)

    editBox.editBox:SetFocus()
    editBox.editBox:HighlightText()

    -- Create Close Button
    local closeButton = SUIConfig:Button(window, 65, 20, 'Close')
    SUIConfig:GlueBelow(closeButton, window, 0, 30)

    -- Close Button Logic
    closeButton:SetScript("OnClick", function(self)
        local fadeInfo = {}
        fadeInfo.mode = "OUT"
        fadeInfo.timeToFade = 0.2
        fadeInfo.finishedFunc = function()
            window:Hide();
        end
        UIFrameFade(window, fadeInfo)
    end)
end

-- Create function to open the window
ProfileExport.Show = function(self)
    buildProfileExport()
end
