--[[
    SUI 2.0 - Features/RaidFrames/Unit.lua

    Per-frame styling of raid and party CompactUnitFrames: bar texture,
    health colours, names, health text, role icons, mouseover highlight and
    the themed background. All of it runs from the shared hooks in Core.lua;
    work that only has to happen once per frame is cached per setting stamp.
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local _G, wipe, pairs, strfind, strsub, strbyte = _G, wipe, pairs, string.find, string.sub, string.byte
local UnitName, UnitClass, UnitIsPlayer, UnitIsConnected = UnitName, UnitClass, UnitIsPlayer, UnitIsConnected
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local CanAccess, GetClassColor = SUI.Compat.CanAccess, SUI.Compat.GetClassColor

local function weak()
    return setmetatable({}, { __mode = "k" })
end

-- Bar texture (1.x) ------------------------------------------------------------------
local BLIZZARD_STATUSBAR = SUI.Media.BLIZZARD_STATUSBAR

local Texture = SUI:NewFeature("RaidFrames.Texture", {
    category = "raidframes",
    toggle = function(db)
        return db.texture ~= BLIZZARD_STATUSBAR
    end,
})

local textured = weak() -- frame -> texture path applied

local BLIZZARD_HEALTH = [[Interface\RaidFrame\Raid-Bar-Hp-Fill]]
local BLIZZARD_POWER = [[Interface\RaidFrame\Raid-Bar-Resource-Fill]]

local function setBarTextures(frame, health, power)
    frame.healthBar:SetStatusBarTexture(health)
    frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
    if frame.powerBar then
        frame.powerBar:SetStatusBarTexture(power)
        frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
    end
    if frame.myHealPrediction and frame.myHealPrediction.SetTexture then
        frame.myHealPrediction:SetTexture(health)
    end
    if frame.otherHealPrediction and frame.otherHealPrediction.SetTexture then
        frame.otherHealPrediction:SetTexture(health)
    end
end

function Texture:Apply(frame)
    local texture = self.db.texture
    if textured[frame] ~= texture and frame.healthBar then
        textured[frame] = texture
        setBarTextures(frame, texture, texture)
    end
end

-- Blizzard's setup resets the textures.
function Texture:Setup(frame)
    textured[frame] = nil
    self:Apply(frame)
end

-- Arena frames too, like 1.x ("^Compact").
RF.On("DefaultCompactUnitFrameSetup", Texture, Texture.Setup, true)
RF.On("DefaultCompactMiniFrameSetup", Texture, Texture.Setup, true)
RF.On("CompactUnitFrame_UpdateAll", Texture, Texture.Apply, true)

local function restoreTexture(_, frame)
    if frame.healthBar then
        setBarTextures(frame, BLIZZARD_HEALTH, BLIZZARD_POWER)
    end
end

function Texture:OnEnable()
    wipe(textured)
    RF.ForEachFrame(self.Apply, self, true)
end

function Texture:OnRefresh(key)
    if key == "texture" then
        self:OnEnable()
    end
end

function Texture:OnDisable()
    wipe(textured)
    RF.ForEachFrame(restoreTexture, nil, true)
end

-- Frame look (1.x, always on) ----------------------------------------------------------
-- Unit frame borders and the party title are hidden; under a theme the
-- party divider is a dark grey line.
local Look = SUI:NewFeature("RaidFrames.Look", { category = "raidframes" })

local BORDERS = { "horizTopBorder", "horizBottomBorder", "vertLeftBorder", "vertRightBorder" }
local looked = weak() -- frame -> theme state applied

function Look:Apply(frame)
    local themed = SUI.Theme.enabled
    if looked[frame] == themed then
        return
    end
    looked[frame] = themed
    for i = 1, #BORDERS do
        local border = frame[BORDERS[i]]
        if border then
            border:Hide()
        end
    end
    local kind = RF.kind[frame]
    if frame.horizDivider and (kind == RF.PARTY or kind == RF.PET) then
        if themed then
            frame.horizDivider:SetVertexColor(0.3, 0.3, 0.3)
        else
            frame.horizDivider:SetVertexColor(1, 1, 1)
        end
    end
end

function Look:Setup(frame)
    looked[frame] = nil
    self:Apply(frame)
end

RF.On("DefaultCompactUnitFrameSetup", Look, Look.Setup, true)
RF.On("CompactUnitFrame_UpdateAll", Look, Look.Apply, true)

function Look:OnEnable()
    if _G.CompactPartyFrameTitle then
        _G.CompactPartyFrameTitle:SetAlpha(0)
    end
    RF.ForEachFrame(self.Apply, self, true)
end

Look.OnThemeChanged = Look.OnEnable

-- Health bar colours -------------------------------------------------------------------
local Colors = SUI:NewFeature("RaidFrames.Colors", {
    category = "raidframes",
    toggle = function(db)
        return db.colors ~= "Default"
    end,
})

function Colors:Apply(frame)
    local unit, bar = frame.unit, frame.healthBar
    if not unit or not bar or not UnitIsConnected(unit) then
        return
    end
    if self.db.colors == "Dark" then
        bar:SetStatusBarColor(0.25, 0.25, 0.25)
    elseif UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        if class and CanAccess(class) then
            bar:SetStatusBarColor(GetClassColor(class))
        end
    end
end

RF.On("CompactUnitFrame_UpdateHealthColor", Colors, Colors.Apply)

function Colors:OnEnable()
    RF.ForEachFrame(self.Apply, self)
end

Colors.OnRefresh = Colors.OnEnable

-- Blizzard caches the colour it last set on the bar.
local function restoreColor(_, frame)
    local bar = frame.healthBar
    if bar and bar.r then
        bar:SetStatusBarColor(bar.r, bar.g, bar.b)
    end
end

function Colors:OnDisable()
    RF.ForEachFrame(restoreColor)
end

-- Names ------------------------------------------------------------------------------------
local Names = SUI:NewFeature("RaidFrames.Names", {
    category = "raidframes",
    toggle = function(db)
        local n = db.names
        return n.mode ~= "Default" or n.classcolor or n.font ~= ""
    end,
})

local nameStamp, stamp = weak(), 1
local shortNames, shortCount = {}, 0

-- Cuts to `length` characters (UTF-8 aware).
local function shorten(text, length)
    local i, n, count = 1, #text, 0
    while i <= n do
        count = count + 1
        if count > length then
            return strsub(text, 1, i - 1)
        end
        local b = strbyte(text, i)
        i = i + (b >= 240 and 4 or b >= 224 and 3 or b >= 192 and 2 or 1)
    end
    return text
end

function Names:Apply(frame)
    local fs = frame.name
    if not fs then
        return
    end
    local db = self.db.names
    if nameStamp[frame] ~= stamp then
        nameStamp[frame] = stamp
        RF.SetFont(fs, db.font, db.size)
        fs:SetAlpha(db.mode == "Hide" and 0 or 1)
        if not db.classcolor then
            RF.RestoreColor(fs)
        end
    end
    if db.mode == "Short" and frame.unit then
        local text = UnitName(frame.unit) -- secret in some instances: then Blizzard's name stays
        if text and CanAccess(text) then
            local short = shortNames[text]
            if not short then
                -- ponytail: the cache only grows with distinct names; wiped at 500 entries.
                if shortCount > 500 then
                    wipe(shortNames)
                    shortCount = 0
                end
                short = shorten(text, db.length)
                shortNames[text] = short
                shortCount = shortCount + 1
            end
            fs:SetText(short)
        end
    end
    if db.classcolor and frame.unit and UnitIsPlayer(frame.unit) then
        local _, class = UnitClass(frame.unit)
        if class and CanAccess(class) then
            fs:SetTextColor(GetClassColor(class))
        end
    end
end

RF.On("CompactUnitFrame_UpdateName", Names, Names.Apply)

function Names:OnEnable()
    stamp = stamp + 1
    wipe(shortNames)
    shortCount = 0
    RF.ForEachFrame(self.Apply, self)
end

local function restoreName(_, frame)
    if frame.name then
        RF.RestoreFont(frame.name)
        frame.name:SetAlpha(1)
        if _G.CompactUnitFrame_UpdateName then
            _G.CompactUnitFrame_UpdateName(frame)
        end
    end
end

function Names:OnDisable()
    stamp = stamp + 1
    RF.ForEachFrame(restoreName)
end

function Names:OnRefresh(key)
    if key and strfind(key, "^names") then
        self:OnDisable()
        self:OnEnable()
    end
end

-- Health text ------------------------------------------------------------------------------
local Health = SUI:NewFeature("RaidFrames.HealthText", {
    category = "raidframes",
    toggle = function(db)
        local h = db.health
        return h.hide or h.color ~= "Default" or h.font ~= ""
    end,
})

local healthStamp, hstamp = weak(), 1

-- Blizzard's status text update only sets the text, so styling on the full
-- update (roster, unit and setup changes) is enough.
function Health:Apply(frame)
    local fs = frame.statusText
    if not fs then
        return
    end
    local db = self.db.health
    if healthStamp[frame] ~= hstamp then
        healthStamp[frame] = hstamp
        RF.SetFont(fs, db.font, db.size)
        fs:SetAlpha(db.hide and 0 or 1)
        if db.color == "Default" then
            RF.RestoreColor(fs)
        end
    end
    if db.color == "Class" and frame.unit and UnitIsPlayer(frame.unit) then
        local _, class = UnitClass(frame.unit)
        if class and CanAccess(class) then
            fs:SetTextColor(GetClassColor(class))
        end
    end
end

function Health:Setup(frame)
    healthStamp[frame] = nil
    self:Apply(frame)
end

RF.On("DefaultCompactUnitFrameSetup", Health, Health.Setup)
RF.On("CompactUnitFrame_UpdateAll", Health, Health.Apply)

function Health:OnEnable()
    hstamp = hstamp + 1
    RF.ForEachFrame(self.Apply, self)
end

function Health:OnRefresh(key)
    if key and strfind(key, "^health") then
        self:OnEnable()
    end
end

local function restoreHealth(_, frame)
    if frame.statusText then
        RF.RestoreFont(frame.statusText)
        frame.statusText:SetAlpha(1)
    end
end

function Health:OnDisable()
    hstamp = hstamp + 1
    RF.ForEachFrame(restoreHealth)
end

-- Role icons -----------------------------------------------------------------------------
local Roles = SUI:NewFeature("RaidFrames.RoleIcons", {
    category = "raidframes",
    toggle = function(db)
        return db.roleicons ~= "Default"
    end,
})

function Roles:Apply(frame)
    local icon = frame.roleIcon
    if not icon then
        return
    end
    if self.db.roleicons == "Hide"
        or (UnitGroupRolesAssigned and frame.unit and UnitGroupRolesAssigned(frame.unit) == "DAMAGER") then
        icon:Hide()
        icon:SetWidth(1) -- Blizzard anchors the name to the icon
    end
end

RF.On("CompactUnitFrame_UpdateRoleIcon", Roles, Roles.Apply)

function Roles:OnEnable()
    RF.ForEachFrame(self.Apply, self)
end

local function restoreRole(_, frame)
    _G.CompactUnitFrame_UpdateRoleIcon(frame)
end

-- Switching between the two modes needs Blizzard's state first.
function Roles:OnRefresh(key)
    if key ~= "roleicons" then
        return
    end
    self:OnDisable()
    self:OnEnable()
end

function Roles:OnDisable()
    if _G.CompactUnitFrame_UpdateRoleIcon then
        RF.ForEachFrame(restoreRole)
    end
end

-- Mouseover highlight ------------------------------------------------------------------------
-- A texture in the HIGHLIGHT layer of the unit button: the client shows it
-- on mouseover, no scripts needed. It borrows the selection border's look.
local Mouseover = SUI:NewFeature("RaidFrames.Mouseover", {
    category = "raidframes",
    toggle = "mouseover",
})

local highlights = weak()

function Mouseover:Apply(frame)
    local hl = highlights[frame]
    if hl then
        hl:Show()
        return
    end
    hl = frame:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(frame)
    local selection = frame.selectionHighlight
    if selection and selection:GetTexture() then
        hl:SetTexture(selection:GetTexture())
        hl:SetTexCoord(selection:GetTexCoord())
        hl:SetVertexColor(1, 1, 1, 0.6)
    else
        hl:SetColorTexture(1, 1, 1, 0.15)
    end
    hl:SetBlendMode("ADD")
    highlights[frame] = hl
end

RF.On("CompactUnitFrame_UpdateAll", Mouseover, Mouseover.Apply)

function Mouseover:OnEnable()
    RF.ForEachFrame(self.Apply, self)
end

function Mouseover:OnDisable()
    for _, hl in pairs(highlights) do
        hl:Hide()
    end
end
