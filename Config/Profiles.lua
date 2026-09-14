--[[
    SUI 2.0 - Config/Profiles.lua

    Profiles tab: switch, create, copy, delete, reset, export and import.
    Everything applies live; features that cannot undo their changes ask
    for a reload on their own.
]]

local _, ns = ...
local SUI = ns.SUI

local SUIConfig = LibStub("SUIConfig")

local function confirm(title, message, onConfirm)
    SUIConfig:Confirm(title, message, {
        ok = {
            text = "Confirm",
            onClick = function(self)
                self:GetParent():Hide()
                onConfirm()
            end,
        },
        cancel = {
            text = "Cancel",
            onClick = function(self)
                self:GetParent():Hide()
            end,
        },
    })
end

local function profileOptions(includeCurrent)
    local out = {}
    local current = SUI.db:GetCurrentProfile()
    for _, name in ipairs(SUI.db:GetProfiles()) do
        if includeCurrent or name ~= current then
            out[#out + 1] = { value = name, text = name }
        end
    end
    return out
end

-- Import / export windows -------------------------------------------------------
local function textWindow(title, text, readOnly)
    local window = SUIConfig:Window(UIParent, 400, 325, title)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    local box = SUIConfig:MultiLineBox(window, 380, 250, text, readOnly)
    SUIConfig:GlueTop(box, window, 0, -40)
    box.editBox:SetFocus()
    box.editBox:HighlightText()
    window.box = box
    window:Show()
    return window
end

local function showExport()
    local window = textWindow("Profile Export", SUI:ExportProfile(), true)
    local close = SUIConfig:Button(window, 65, 20, "Close")
    SUIConfig:GlueBelow(close, window, 0, 30)
    close:SetScript("OnClick", function()
        window:Hide()
    end)
end

local function showImport()
    local window = textWindow("Profile Import", "")
    local import = SUIConfig:Button(window, 65, 20, "Import")
    SUIConfig:GlueBelow(import, window, -35, 30)
    local close = SUIConfig:Button(window, 65, 20, "Close")
    SUIConfig:GlueBelow(close, window, 35, 30)
    close:SetScript("OnClick", function()
        window:Hide()
    end)
    import:SetScript("OnClick", function()
        local data, isV2 = SUI:DecodeProfile(window.box:GetValue())
        if not data then
            window.box:SetValue(isV2)
            window.box.editBox:HighlightText()
            return
        end
        window:Hide()
        confirm("Import Profile", "This overwrites the settings of the current profile.", function()
            SUI:ImportProfile(data, isV2)
            SUI:Print("Profile imported.")
        end)
    end)
end

-- Layout ----------------------------------------------------------------------------
local newName = ""

SUI.Config:RegisterLayout("Profiles", {
    order = 900,
    bind = false,
    group = "system",
    rows = function()
        return {
            { header = { type = "header", label = "Current Profile" } },
            {
                current = {
                    type = "dropdown",
                    label = "Active Profile",
                    options = profileOptions(true),
                    initialValue = SUI.db:GetCurrentProfile(),
                    onValueChanged = function(_, value)
                        if value and value ~= SUI.db:GetCurrentProfile() then
                            SUI.db:SetProfile(value)
                        end
                    end,
                    column = 6,
                    order = 1,
                },
                reset = {
                    type = "button",
                    text = "Reset Profile",
                    onClick = function()
                        confirm("Reset Profile", "This resets all settings of the current profile.", function()
                            SUI.db:ResetProfile()
                        end)
                    end,
                    column = 4,
                    order = 2,
                },
            },
            { header = { type = "header", label = "Manage" } },
            {
                name = {
                    type = "editBox",
                    label = "New Profile Name",
                    initialValue = newName,
                    onValueChanged = function(_, value)
                        newName = value or ""
                    end,
                    column = 6,
                    order = 1,
                },
                create = {
                    type = "button",
                    text = "Create",
                    onClick = function()
                        local name = strtrim(newName or "")
                        if name == "" then
                            SUI:Print("Enter a profile name first.")
                            return
                        end
                        SUI.db:SetProfile(name)
                    end,
                    column = 3,
                    order = 2,
                },
            },
            {
                copy = {
                    type = "dropdown",
                    label = "Copy From",
                    options = profileOptions(false),
                    onValueChanged = function(_, value)
                        if value then
                            confirm("Copy Profile", "Copy all settings from " .. value .. " into the current profile?", function()
                                SUI.db:CopyProfile(value)
                            end)
                        end
                    end,
                    column = 6,
                    order = 1,
                },
                delete = {
                    type = "dropdown",
                    label = "Delete",
                    options = profileOptions(false),
                    onValueChanged = function(_, value)
                        if value then
                            confirm("Delete Profile", "Delete the profile " .. value .. "?", function()
                                SUI.db:DeleteProfile(value)
                                SUI.callbacks:Fire("ProfileChanged")
                            end)
                        end
                    end,
                    column = 6,
                    order = 2,
                },
            },
            { header = { type = "header", label = "Profile Sharing" } },
            {
                export = { type = "button", text = "Export", onClick = showExport, column = 3, order = 1 },
                import = { type = "button", text = "Import", onClick = showImport, column = 3, order = 2 },
            },
        }
    end,
})
