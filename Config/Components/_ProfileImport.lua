local ProfileImport = SUI:NewModule('Config.Components.ProfileImport');

-- Load Libs
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local SUIConfig = LibStub('SUIConfig')

-- Import Profile Function
function ProfileImport:ImportProfile(string, doImport)
    if (not string) or (string == "") or (string == "< Paste Import String here >") or (string == '< ERROR: No Import String provided >') then
        return "< ERROR: No Import String provided >"
    end

    --LibDeflate decode
    local decoded_profile = LibDeflate:DecodeForPrint(string)
    if decoded_profile == nil then
        return "< ERROR: Invalid Import String >"
    end

    --LibDefalte uncompress
    local uncompressed_profile = LibDeflate:DecompressZlib(decoded_profile)
    if uncompressed_profile == nil then
        return "< ERROR: Invalid Import String >"
    end
    --AceSerialize
    --deserialize the profile and overwirte the current values
    local valid, imported_Profile = SUI:Deserialize(uncompressed_profile)
    if (doImport) then
        if valid and imported_Profile then
            for i, v in pairs(imported_Profile) do
                if type(v) == "table" then
                    SUI.db.profile[i] = CopyTable(v)
                else
                    local new_value = v
                    SUI.db.profile[i] = new_value
                end
            end
        else
            return "< ERROR: Invalid Import String >"
        end
    end

    if (valid and imported_Profile) then
        return "< OK! >"
    end
end

local function buildProfileImport()
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

    -- Create Window
    local window = SUIConfig:Window(UIParent, 400, 325, 'Profile Import')
    window:SetPoint('CENTER')
    window:SetFrameStrata('DIALOG');

    local fadeInfo = {}
    fadeInfo.mode = "IN"
    fadeInfo.timeToFade = 0.2
    fadeInfo.finishedFunc = function()
        window:Show()
    end
    UIFrameFade(window, fadeInfo)

    -- Create EditBox
    local editBox = SUIConfig:MultiLineBox(window, 380, 250, '< Paste Import String here >')
    SUIConfig:GlueTop(editBox, window, 0, -40)

    editBox.editBox:SetFocus()
    editBox.editBox:HighlightText()

    -- Create Import Button
    local importButton = SUIConfig:Button(window, 65, 20, 'Validate')
    SUIConfig:GlueBelow(importButton, window, -35, 30)

    -- Create Close Button
    local closeButton = SUIConfig:Button(window, 65, 20, 'Close')
    SUIConfig:GlueBelow(closeButton, window, 35, 30)

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

    -- Initiate Variable
    local importString

    importButton:SetScript("OnClick", function(self)
        -- Get Button Text
        local text = importButton:GetText()

        -- Check Import String
        if (ProfileImport:ImportProfile(editBox:GetValue())) then
            local string = editBox:GetValue()
            local response = ProfileImport:ImportProfile(importString or string)

            -- Check Import String
            if (text == 'Validate') then
                if (string.find(response, 'OK')) then
                    -- set importString value
                    importString = string

                    -- Set Response as EditBox value
                    editBox:SetValue(response)
                    self:SetText('Import')
                    editBox:Disable()
                elseif (string.find(response, 'ERROR')) then
                    editBox:SetValue(response)
                    editBox.editBox:HighlightText()
                end
            elseif (text == 'Import') then
                -- Hide Import Window
                local fadeInfo = {}
                fadeInfo.mode = "OUT"
                fadeInfo.timeToFade = 0.2
                fadeInfo.finishedFunc = function()
                    window:Hide();
                end
                UIFrameFade(window, fadeInfo)

                -- Display Confirm Window
                local buttons = {
                    ok = {
                        text    = 'Confirm',
                        onClick = function()
                            ProfileImport:ImportProfile(importString, true)
                            ReloadUI()
                        end
                    },
                    cancel = {
                        text    = 'Cancel',
                        onClick = function(self) self:GetParent():Hide() end
                    }
                }

                SUIConfig:Confirm('Import Profile', 'This will overwrite your existing settings!', buttons)
            end
        end
    end)
end

-- Create function to open the window
ProfileImport.Show = function(self)
    buildProfileImport()
end
