--[[
    SUI 2.0 - Features/Chat/Extras.lua

    Small chat features: hyperlink tooltips on mouseover, the input box above
    the chat for the Blizzard style (1.x: Custom style only, off by default), a whisper sound, the retail quick join
    button shown only on mouseover, and theme tinting of the chat edit boxes,
    channel and chat settings windows.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local _G, next, pcall, strfind = _G, next, pcall, string.find
local CanAccess = SUI.Compat.CanAccess

-- Hyperlink tooltips (Modern style, as in 1.x) -------------------------------------------
local Tooltips = SUI:NewFeature("Chat.Tooltips", {
    category = "chat",
    toggle = function(db)
        return db.settings.tooltips and db.style == "Modern"
    end,
})

local hookedFrames = {}
local ownsTooltip = false

-- 1.x skipped item links and let SetHyperlink reject types it cannot show.
-- Hover only, so the pcall is not on a hot path.
local function linkEnter(frame, link)
    if not Tooltips.enabled or not CanAccess(link) or type(link) ~= "string"
        or strfind(link, "^item:") or strfind(link, "^garrmission:SUIurl:") then
        return
    end
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    if pcall(GameTooltip.SetHyperlink, GameTooltip, link) then
        GameTooltip:Show()
        ownsTooltip = true
    else
        GameTooltip:Hide()
    end
end

local function linkLeave()
    if ownsTooltip then
        ownsTooltip = false
        GameTooltip:Hide()
    end
end

function Tooltips:HookFrame(frame)
    if not hookedFrames[frame] then
        hookedFrames[frame] = true
        frame:HookScript("OnHyperlinkEnter", linkEnter)
        frame:HookScript("OnHyperlinkLeave", linkLeave)
    end
end

function Tooltips:OnLoad()
    Chat.OnNewFrame(self, "HookFrame")
end

function Tooltips:OnEnable()
    Chat.EachFrame(self.HookFrame, self)
end

function Tooltips:OnDisable()
    linkLeave()
end

-- Input box on top (Blizzard style) ----------------------------------------------------
local EditBoxTop = SUI:NewFeature("Chat.EditBoxTop", {
    category = "chat",
    toggle = function(db)
        return db.top and db.style ~= "Modern"
    end,
})

local originalPoints = {} -- edit box -> { {point, relativeTo, relativePoint, x, y}, ... }

function EditBoxTop:MoveBox(frame)
    local box = frame.editBox or _G[frame:GetName() .. "EditBox"]
    if not box then
        return
    end
    if not originalPoints[box] then
        local points = {}
        for i = 1, box:GetNumPoints() do
            points[i] = { box:GetPoint(i) }
        end
        originalPoints[box] = points
    end
    box:ClearAllPoints()
    box:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", -7, 25)
    box:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 10, 25)
end

function EditBoxTop:OnLoad()
    Chat.OnNewFrame(self, "MoveBox")
end

function EditBoxTop:OnEnable()
    Chat.EachFrame(self.MoveBox, self)
end

function EditBoxTop:OnDisable()
    for box, points in next, originalPoints do
        box:ClearAllPoints()
        for i = 1, #points do
            local p = points[i]
            box:SetPoint(p[1], p[2], p[3], p[4], p[5])
        end
        originalPoints[box] = nil
    end
end

-- Whisper sound -----------------------------------------------------------------------------
local WhisperAlert = SUI:NewFeature("Chat.WhisperAlert", {
    category = "chat",
    toggle = "whisperalert",
})

function WhisperAlert:Play()
    local sound = self.db.whispersound
    if sound and sound ~= "" then
        PlaySoundFile(sound, "Master")
    end
end

function WhisperAlert:OnEnable()
    self:RegisterEvent("CHAT_MSG_WHISPER", "Play")
    self:RegisterEvent("CHAT_MSG_BN_WHISPER", "Play")
end

-- Quick join button on mouseover (retail) ------------------------------------------------
local QuickJoin = SUI:NewFeature("Chat.QuickJoin", {
    category = "chat",
    toggle = "quickjoin",
    clients = { Mainline = true },
})

local function hideButton(button)
    button:SetAlpha(0)
end

function QuickJoin:OnLoad()
    local button = QuickJoinToastButton
    if not button then
        return
    end
    self:HookScript(button, "OnEnter", function()
        button:SetAlpha(1)
    end)
    self:HookScript(button, "OnLeave", hideButton)
    self:HookScript(button, "OnShow", hideButton)
end

function QuickJoin:OnEnable()
    if QuickJoinToastButton then
        QuickJoinToastButton:SetAlpha(0)
    end
end

function QuickJoin:OnDisable()
    if QuickJoinToastButton then
        QuickJoinToastButton:SetAlpha(1)
    end
end

-- Skins ----------------------------------------------------------------------------------------
-- Paths that do not exist on a client are skipped by the skin core.
local skin = {
    "ChatConfigFrame", "ChatConfigFrame.Header", "ChatConfigFrame.Border",
    "ChatConfigBackgroundFrame", "ChatConfigBackgroundFrame.NineSlice",
    "ChatConfigCategoryFrame", "ChatConfigCategoryFrame.NineSlice",
    -- Classic loads the channel window with the interface, retail on demand.
    "ChannelFrame", "ChannelFrame.NineSlice", "ChannelFrame.LeftInset.NineSlice",
    "ChannelFrame.RightInset.NineSlice", "ChannelFrameInset.NineSlice",
}
for i = 1, 7 do
    skin[#skin + 1] = "ChatFrame" .. i .. "EditBox"
end
SUI.Skin:Register("SUI", skin)
SUI.Skin:Register("Blizzard_Channels", {
    "ChannelFrame", "ChannelFrame.NineSlice", "ChannelFrame.LeftInset.NineSlice",
    "ChannelFrame.RightInset.NineSlice", "ChannelFrameInset.NineSlice",
})
