--[[
    SUI 2.0 - Features/Chat/Copy.lua

    A small button on every chat frame opens its history in a copy window.
    Secret (12.x restricted) lines are skipped. The button sits inside the
    Modern backdrop or just outside the Blizzard frame, depending on style.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local next, wipe, concat = next, wipe, table.concat
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Chat.Copy", {
    category = "chat",
    toggle = "copy",
})

local TEX = SUI.mediaPath .. [[Textures\Chat\]]
local buttons = {} -- chat frame -> button
local lines = {}

local function copyHistory(button)
    local frame = button.chatFrame
    wipe(lines)
    for i = 1, frame:GetNumMessages() do
        local msg = frame:GetMessageInfo(i)
        if msg and CanAccess(msg) then
            lines[#lines + 1] = msg
        end
    end
    Chat.ShowCopy(frame.name or frame:GetName() or "Chat", concat(lines, "\n"), true)
    wipe(lines)
end

local function enter(button)
    button:SetAlpha(1)
end

local function leave(button)
    button:SetAlpha(0.55)
end

function F:Place(button)
    button:ClearAllPoints()
    if self.db.style == "Modern" then
        button:SetPoint("TOPRIGHT", button.chatFrame, "TOPRIGHT", -4, -4)
    else
        button:SetPoint("TOPRIGHT", button.chatFrame, "TOPRIGHT", 10, -5)
    end
end

function F:AddButton(frame)
    local button = buttons[frame]
    if not button then
        button = CreateFrame("Button", nil, frame)
        button.chatFrame = frame
        button:SetSize(20, 20)
        button:SetFrameLevel(frame:GetFrameLevel() + 10)
        button:SetNormalTexture(TEX .. "copynormal")
        button:SetHighlightTexture(TEX .. "copyhighlight")
        button:SetScript("OnClick", copyHistory)
        button:SetScript("OnEnter", enter)
        button:SetScript("OnLeave", leave)
        buttons[frame] = button
    end
    self:Place(button)
    leave(button)
    button:Show()
end

function F:OnLoad()
    Chat.OnNewFrame(self, "AddButton")
end

function F:OnEnable()
    Chat.EachFrame(self.AddButton, self)
end

function F:OnRefresh()
    for _, button in next, buttons do
        self:Place(button)
    end
end

function F:OnDisable()
    for _, button in next, buttons do
        button:Hide()
    end
    Chat.HideCopy()
end
