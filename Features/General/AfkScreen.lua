--[[
    SUI 2.0 - Features/General/AfkScreen.lua

    While the player is flagged AFK the UI fades out, the camera slowly spins
    and a panel shows the character model, name, guild, date and clock. Any
    popup, ready check, queue invite, combat or death brings the UI back
    (fading in over 0.5s like 1.x); after a loading screen it is re-checked.
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat
local date = date

local F = SUI:NewFeature("General.AfkScreen", {
    category = "general",
    toggle = "cosmetic.afkscreen",
})

local texts = {}

local function text(parent, size, point, x, y, relative)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    texts[#texts + 1] = fs
    fs:SetFont(SUI.db.profile.general.font, size, "OUTLINE")
    fs:SetPoint(point, parent, relative or point, x, y)
    return fs
end

-- Plain frames without background, like 1.x (its template call was a no-op).
local function panel(anchor, height)
    local frame = CreateFrame("Frame")
    frame:SetFrameStrata("FULLSCREEN")
    frame:SetPoint(anchor .. "LEFT", UIParent, anchor .. "LEFT", -2, anchor == "TOP" and 2 or -2)
    frame:SetPoint(anchor .. "RIGHT", UIParent, anchor .. "RIGHT", 2, anchor == "TOP" and 2 or -2)
    frame:SetHeight(height)
    frame:Hide()
    return frame
end

function F:OnLoad()
    local top = panel("TOP", 82)
    local bottom = panel("BOTTOM", 152)
    self.top, self.bottom = top, bottom

    top.afk = text(top, 40, "CENTER", 0, 0)
    top.afk:SetText("AFK")
    top.name = text(top, 26, "LEFT", 25, 19)
    top.guild = text(top, 15, "LEFT", 25, -3)
    top.info = text(top, 15, "LEFT", 25, -20)
    top.date = text(top, 15, "BOTTOMLEFT", -100, 44, "BOTTOMRIGHT")
    top.clock = text(top, 20, "BOTTOMLEFT", -100, 20, "BOTTOMRIGHT")

    bottom.logo = text(bottom, 110, "CENTER", 0, 15)
    bottom.logo:SetText(SUI.brand)

    local model = CreateFrame("PlayerModel", nil, bottom)
    model:SetSize(800, 1200)
    model:SetPoint("RIGHT", bottom, "RIGHT", 250, 110)
    self.model = model

    self.updateClock = function()
        top.clock:SetText(date("%H:%M:%S"))
        top.date:SetText(date("%a %b/%d"))
    end

    local hide = function()
        self:HideScreen()
    end
    if StaticPopup_Show then
        self:Hook("StaticPopup_Show", hide)
    end
    if LFGDungeonReadyDialog then
        self:HookScript(LFGDungeonReadyDialog, "OnShow", hide)
    end
    if PVPReadyDialog then
        self:HookScript(PVPReadyDialog, "OnShow", hide)
    end
end

function F:OnEnable()
    self:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", "Update", "player")
    self:RegisterEvent("PLAYER_DEAD", "HideScreen")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "HideScreen")
    self:RegisterEvent("PLAYER_LEAVING_WORLD", "HideScreen")
    self:RegisterEvent("READY_CHECK", "HideScreen")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
    self:Update()
end

function F:OnDisable()
    self:HideScreen()
end

function F:OnRefresh(key)
    if key == "font" then
        for i = 1, #texts do
            local _, size = texts[i]:GetFont()
            texts[i]:SetFont(self.db.font, size, "OUTLINE")
        end
    end
end

function F:Update()
    local afk = UnitIsAFK("player")
    if not Compat.CanAccess(afk) then
        return
    end
    if not afk then
        self:HideScreen()
        return
    end
    local dead = UnitIsDead("player")
    if (Compat.CanAccess(dead) and dead) or InCombatLockdown() then
        return
    end
    if C_PvP and C_PvP.IsArena and C_PvP.IsArena() then
        return
    end
    self:ShowScreen()
end

function F:ShowScreen()
    if self.active then
        return
    end
    self.active = true

    local top = self.top
    local _, class = UnitClass("player")
    local r, g, b = Compat.GetClassColor(class)
    top.afk:SetTextColor(r, g, b)
    top.name:SetTextColor(r, g, b)
    top.name:SetText(UnitName("player"))
    -- 1.x: "Level N Faction CLASSTOKEN", moved up into the guild line without a guild
    local guild = IsInGuild() and GetGuildInfo("player")
    top.guild:SetText(guild and ("|cff0394ff" .. guild .. "|r") or "")
    top.info:ClearAllPoints()
    top.info:SetPoint("LEFT", top, "LEFT", 25, guild and -20 or -3)
    top.info:SetText((LEVEL or "Level") .. " " .. UnitLevel("player") .. " " .. (UnitFactionGroup("player") or "") .. " " .. (class or ""))
    self.updateClock()
    self:NewTicker(0.5, self.updateClock)

    self.model:SetUnit("player")
    self.model:SetRotation(math.rad(-15))
    self.model:SetCamDistanceScale(1.2)

    self.minimapHidden = Minimap and Minimap:IsShown()
    if self.minimapHidden then
        Minimap:Hide()
    end
    SUI:StopFading(UIParent)
    UIParent:SetAlpha(0)
    top:Show()
    self.bottom:Show()
    MoveViewRightStart(0.1)
end

function F:HideScreen()
    if not self.active then
        return
    end
    self.active = false
    self:CancelTimers()
    MoveViewRightStop()
    self.top:Hide()
    self.bottom:Hide()
    SUI:FadeIn(UIParent, 0.5, 0, 1)
    if self.minimapHidden then
        Minimap:Show()
        self.minimapHidden = nil
    end
end
