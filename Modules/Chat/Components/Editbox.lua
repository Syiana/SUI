local SUIAddon = SUI
local Style = SUIAddon:GetModule("SUI.Modules.Chat.Style")

-- Lua
local _G = getfenv(0)
local next = _G.next

local handledEditBoxes = {}

local EDIT_BOX_TEXTURES

EDIT_BOX_TEXTURES = {"Left", "Mid", "Right", "FocusLeft", "FocusMid", "FocusRight"}

function Style:HandleEditBox(frame)
    if not handledEditBoxes[frame] then
        frame.Backdrop = Style:CreateBackdrop(frame, Style.db.edit.alpha, 0, 2)

        handledEditBoxes[frame] = true
    end

    for _, texture in next, EDIT_BOX_TEXTURES do
        _G[frame:GetName() .. texture]:SetTexture(0)
    end

    frame:ClearAllPoints()

    if Style.db.edit.position == "top" then
        frame:SetPoint("TOPLEFT", frame.chatFrame, "TOPLEFT", -4, Style.db.edit.offset)
        frame:SetPoint("TOPRIGHT", frame.chatFrame, "TOPRIGHT", 4, Style.db.edit.offset)
    else
        frame:SetPoint("BOTTOMLEFT", frame.chatFrame, "BOTTOMLEFT", -4, -Style.db.edit.offset)
        frame:SetPoint("BOTTOMRIGHT", frame.chatFrame, "BOTTOMRIGHT", 4, -Style.db.edit.offset)
    end

    --[[frame:SetFontObject("SUIEditBoxFont")
    frame.header:SetFontObject("SUIEditBoxFont")
    frame.headerSuffix:SetFontObject("SUIEditBoxFont")
    frame.NewcomerHint:SetFontObject("SUIEditBoxFont")
    frame.prompt:SetFontObject("SUIEditBoxFont")]]
end

function Style:UpdateEditBoxPosition()
    local isOnTop = Style.db.edit.position == "top"
    local offset = Style.db.edit.offset

    for editBox in next, handledEditBoxes do
        editBox:ClearAllPoints()

        if isOnTop then
            editBox:SetPoint("TOPLEFT", editBox.chatFrame, "TOPLEFT", -4, offset)
            editBox:SetPoint("TOPRIGHT", editBox.chatFrame, "TOPRIGHT", 4, offset)
        else
            editBox:SetPoint("BOTTOMLEFT", editBox.chatFrame, "BOTTOMLEFT", -4, -offset)
            editBox:SetPoint("BOTTOMRIGHT", editBox.chatFrame, "BOTTOMRIGHT", 4, -offset)
        end
    end
end

function Style:UpdateEditBoxAlpha()
    local alpha = Style.db.edit.alpha

    for editBox in next, handledEditBoxes do
        editBox.Backdrop:UpdateAlpha(alpha)
    end
end
