--[[
    SUI 2.0 - Features/General/Cursor.lua

    A soft glow ring that follows the mouse cursor. A slow ticker notices
    cursor movement and starts a throttled follow loop; the loop stops itself
    once the cursor rests. The ring hides while mouselooking (no cursor).
]]

local _, ns = ...
local SUI = ns.SUI

local GetCursorPosition, IsMouselooking = GetCursorPosition, IsMouselooking

local F = SUI:NewFeature("General.Cursor", {
    category = "general",
    toggle = "cosmetic.cursor",
})

local FOLLOW_RATE = 1 / 60 -- seconds between position updates while moving
local IDLE_STOP = 0.5      -- stop following after the cursor rested this long
local SIZE = 40

function F:OnLoad()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(SIZE, SIZE)
    frame:SetFrameStrata("TOOLTIP")
    frame:EnableMouse(false)
    if frame.SetIgnoreParentAlpha then
        frame:SetIgnoreParentAlpha(true)
    end
    local ring = frame:CreateTexture(nil, "OVERLAY")
    ring:SetAllPoints()
    if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("dragonflight-landingbutton-circleglow") then
        ring:SetAtlas("dragonflight-landingbutton-circleglow")
    else
        ring:SetTexture([[Interface\Cooldown\star4]])
    end
    ring:SetBlendMode("ADD")
    frame:Hide()
    self.frame = frame

    local lastX, lastY, idle = 0, 0, 0
    local function place()
        local x, y = GetCursorPosition()
        if x == lastX and y == lastY then
            return false
        end
        lastX, lastY = x, y
        local scale = UIParent:GetEffectiveScale()
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
        return true
    end

    self.follow = function(elapsed)
        if IsMouselooking() then
            frame:Hide()
            self:StopUpdate()
            self.following = false
            return
        end
        if place() then
            idle = 0
        else
            idle = idle + elapsed
            if idle >= IDLE_STOP then
                self:StopUpdate()
                self.following = false
            end
        end
    end

    self.watch = function()
        if self.following or IsMouselooking() then
            return
        end
        if place() or not frame:IsShown() then
            idle = 0
            frame:Show()
            self.following = true
            self:StartUpdate(self.follow, FOLLOW_RATE)
        end
    end
end

function F:OnEnable()
    self.following = false
    self:NewTicker(0.1, self.watch)
    self.watch()
end

function F:OnDisable()
    self.following = false
    self.frame:Hide()
end
