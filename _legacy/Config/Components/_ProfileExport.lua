local ProfileExport = SUI:NewModule('Config.Components.ProfileExport');
local Theme = SUI:GetModule("Config.Components.Theme")

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
    Theme:Apply()

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
