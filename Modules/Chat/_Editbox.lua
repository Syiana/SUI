local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

local _G = getfenv(0)
local next = _G.next

local handledEditBoxes = {}
local EDIT_BOX_TEXTURES = {"Left", "Mid", "Right", "FocusLeft", "FocusMid", "FocusRight"}

local function positionEditBox(frame, position, offset)
    if not frame then
        return
    end

    frame:ClearAllPoints()

    if position == "top" then
        frame:SetPoint("TOPLEFT", frame.chatFrame, "TOPLEFT", -4, offset)
        frame:SetPoint("TOPRIGHT", frame.chatFrame, "TOPRIGHT", 4, offset)
        return
    end

    frame:SetPoint("BOTTOMLEFT", frame.chatFrame, "BOTTOMLEFT", -4, -offset)
    frame:SetPoint("BOTTOMRIGHT", frame.chatFrame, "BOTTOMRIGHT", 4, -offset)
end

function Style:HandleEditBox(frame)
    if not handledEditBoxes[frame] then
        frame.Backdrop = Style:CreateBackdrop(frame, Style.db.edit.alpha, 0, 2)

        handledEditBoxes[frame] = true
    end

    for _, texture in next, EDIT_BOX_TEXTURES do
        _G[frame:GetName() .. texture]:SetTexture(0)
    end

    positionEditBox(frame, Style.db.edit.position, Style.db.edit.offset)
end

function Style:UpdateEditBoxPosition()
    for editBox in next, handledEditBoxes do
        positionEditBox(editBox, Style.db.edit.position, Style.db.edit.offset)
    end
end

function Style:UpdateEditBoxAlpha()
    local alpha = Style.db.edit.alpha

    for editBox in next, handledEditBoxes do
        editBox.Backdrop:UpdateAlpha(alpha)
    end
end
