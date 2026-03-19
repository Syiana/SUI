local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

-- Lua
local _G = getfenv(0)
local t_insert = _G.table.insert

local backdrops = {}
local BORDER_HIGHLIGHT_TEXTURE = "Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight"
local BORDER_COLOR = DEFAULT_TAB_SELECTED_COLOR_TABLE

local backdrop_proto = {}
do
    function backdrop_proto:UpdateAlpha(a)
        self:SetBackdropColor(0, 0, 0, a)
        self:SetBackdropBorderColor(0, 0, 0, a)
    end
end

function Style:CreateBackdrop(parent, alpha, xOffset, yOffset)
    local backdrop = Mixin(CreateFrame("Frame", nil, parent, "BackdropTemplate"), backdrop_proto)
    backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
    backdrop:SetPoint("TOPLEFT", xOffset or 0, -(yOffset or 0))
    backdrop:SetPoint("BOTTOMRIGHT", -(xOffset or 0), yOffset or 0)
    backdrop:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border",
        tile = true,
        tileEdge = true,
        tileSize = 8,
        edgeSize = 8
        -- insets = {left = 4, right = 4, top = 4, bottom = 4},
    })

    -- the way Blizz position it creates really weird gaps, so fix it
    backdrop.Center:ClearAllPoints()
    backdrop.Center:SetPoint("TOPLEFT", backdrop.TopLeftCorner, "BOTTOMRIGHT", 0, 0)
    backdrop.Center:SetPoint("BOTTOMRIGHT", backdrop.BottomRightCorner, "TOPLEFT", 0, 0)

    backdrop:SetBackdropColor(0, 0, 0, alpha)
    backdrop:SetBackdropBorderColor(0, 0, 0, alpha)

    t_insert(backdrops, backdrop)

    return backdrop
end

function Style:ApplyBorderAccent(leftTexture, middleTexture, rightTexture, anchor)
    if not leftTexture or not middleTexture or not rightTexture or not anchor then
        return
    end

    leftTexture:ClearAllPoints()
    leftTexture:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -2)
    leftTexture:SetTexture(BORDER_HIGHLIGHT_TEXTURE)
    leftTexture:SetVertexColor(BORDER_COLOR.r, BORDER_COLOR.g, BORDER_COLOR.b)
    leftTexture:SetTexCoord(0, 1, 0.5, 1)
    leftTexture:SetSize(8, 8)

    rightTexture:ClearAllPoints()
    rightTexture:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", 0, -2)
    rightTexture:SetTexture(BORDER_HIGHLIGHT_TEXTURE)
    rightTexture:SetVertexColor(BORDER_COLOR.r, BORDER_COLOR.g, BORDER_COLOR.b)
    rightTexture:SetTexCoord(1, 0, 0.5, 1)
    rightTexture:SetSize(8, 8)

    middleTexture:ClearAllPoints()
    middleTexture:SetPoint("TOPLEFT", leftTexture, "TOPRIGHT", 0, 0)
    middleTexture:SetPoint("TOPRIGHT", rightTexture, "TOPLEFT", 0, 0)
    middleTexture:SetTexture(BORDER_HIGHLIGHT_TEXTURE)
    middleTexture:SetVertexColor(BORDER_COLOR.r, BORDER_COLOR.g, BORDER_COLOR.b)
    middleTexture:SetTexCoord(0, 1, 0, 0.5)
    middleTexture:SetSize(8, 8)
end
