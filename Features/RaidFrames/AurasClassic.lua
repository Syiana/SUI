--[[
    SUI 2.0 - Features/RaidFrames/AurasClassic.lua

    Classic clients: the SUI aura rows reuse Blizzard's aura buttons
    (frame.buffFrames / frame.debuffFrames), restyled with the SUI look.
    Same settings as retail where the client can answer them: buff mode and
    raid filter, debuff mode, boss debuffs leading the row x1.3, sizes as a
    share of the frame height, countdown only on icons of 18px and more.
    Layout runs on Blizzard's frame setup, a size change or an option change;
    after each Blizzard aura update the buttons are refilled (no tables or
    closures on that path).
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local _G, pairs, max, min, floor = _G, pairs, math.max, math.min, math.floor
local CreateFrame = CreateFrame

local LEAD_SCALE = 1.3
local MAX_BUFFS, MAX_DEBUFFS, MAX_LEAD = 6, 6, 2
local COUNTDOWN_MIN_SIZE = 18
local FALLBACK_HEIGHT = 36
local ANY, BOSS, NOT_BOSS = 0, 1, 2
local CORNERS = {
    [1] = { [1] = "BOTTOMLEFT", [-1] = "BOTTOMRIGHT" },
    [-1] = { [1] = "TOPLEFT", [-1] = "TOPRIGHT" },
}
local R, G, B = RF.DEBUFF_R, RF.DEBUFF_G, RF.DEBUFF_B

local F = SUI:NewFeature("RaidFrames.AurasClassic", {
    category = "raidframes",
    toggle = "auras.enabled",
    clients = { Classic = true },
    reload = true, -- Blizzard's anchors and look come back with its next frame setup
})

-- Resolved in OnLoad (client APIs are not touched at file load).
local UnitAura, setCooldown, clearCooldown
local canCreateBuffs, canCreateDebuffs = false, false

-- Settings resolved on enable/refresh; read on the update path.
local buffFilter, debuffFilter = "HELPFUL", "HARMFUL"
local buffMax, debuffMax, leadMax, tooltips = 0, 0, 0, true
local revision = 1

local state = setmetatable({}, { __mode = "k" })      -- frame -> layout state (one table per frame)
local typeBorders = setmetatable({}, { __mode = "k" }) -- button -> SUI type border | false
local original = setmetatable({}, { __mode = "k" })    -- button array -> Blizzard's button count

local function templateExists(name)
    return not C_XMLUtil or not C_XMLUtil.GetTemplateInfo or C_XMLUtil.GetTemplateInfo(name) ~= nil
end

function F:OnLoad()
    UnitAura = _G.UnitAura
    if not UnitAura then
        local getAura = C_UnitAuras.GetAuraDataByIndex
        UnitAura = function(unit, index, filter)
            local a = getAura(unit, index, filter)
            if a then
                return a.name, a.icon, a.applications, a.dispelName, a.duration, a.expirationTime,
                    a.sourceUnit, a.isStealable, nil, a.spellId, nil, a.isBossAura
            end
        end
    end
    setCooldown = CooldownFrame_Set
    clearCooldown = CooldownFrame_Clear or function(cooldown)
        cooldown:Hide()
    end
    canCreateBuffs = templateExists("CompactBuffTemplate")
    canCreateDebuffs = templateExists("CompactDebuffTemplate")
end

local function resolve(db)
    local a = db.auras
    local b, d = a.buffs, a.debuffs
    -- "HELPFUL|RAID" is the classic raid pick; "important" has no classic flag.
    local raid = b.filter ~= "all"
    if b.mode == "mine" then
        buffFilter = raid and "HELPFUL|PLAYER|RAID" or "HELPFUL|PLAYER"
    else
        buffFilter = raid and "HELPFUL|RAID" or "HELPFUL"
    end
    debuffFilter = d.mode == "dispellable" and "HARMFUL|RAID" or "HARMFUL"
    buffMax = b.mode == "hide" and 0 or min(max(b.max, 1), MAX_BUFFS)
    debuffMax = d.mode == "hide" and 0 or min(max(d.max, 1), MAX_DEBUFFS)
    leadMax = (d.mode == "hide" or not d.lead) and 0 or MAX_LEAD
    tooltips = a.tooltips
end

-- Buttons ---------------------------------------------------------------------------------
local function style(button, isDebuff)
    if typeBorders[button] ~= nil or not button.icon then
        return
    end
    local overlay = CreateFrame("Frame", nil, button)
    overlay:SetAllPoints(button)
    overlay:SetFrameLevel((button.cooldown and button.cooldown:GetFrameLevel() or button:GetFrameLevel()) + 1)
    if button.count then
        button.count:SetParent(overlay)
    end
    local typeBorder = RF.StyleAura(button, button.icon, overlay, isDebuff)
    if isDebuff and button.border then
        button.border:SetAlpha(0) -- SUI's type border replaces Blizzard's
    end
    typeBorders[button] = typeBorder or false
end

local function ensure(frame, buttons, count, template)
    if original[buttons] == nil then
        original[buttons] = #buttons
    end
    if template and #buttons > 0 then
        for i = #buttons + 1, count do
            local button = CreateFrame("Button", nil, frame, template)
            button:Hide()
            buttons[i] = button
        end
    end
end

-- Anchors every button straight to the frame: slots grow away from the
-- anchor, the first `lead` slots use the larger size.
local function place(frame, buttons, settings, px, leadPx, lead, isDebuff)
    local point = settings.point
    local reference, relative, bx, by = RF.AuraAnchor(frame, point)
    local horizontal, hs, vs = RF.AuraGrowth(point, settings.grow)
    local corner = CORNERS[vs][hs]
    local perRow, spacing = max(settings.perrow, 1), settings.spacing
    local x, y = bx + settings.x, by + settings.y
    local rowStep = (lead > 0 and leadPx or px) + spacing
    local along, row = 0, 0
    local duration, count = settings.duration and 1 or 0, settings.count and 1 or 0

    for i = 1, #buttons do
        local button = buttons[i]
        style(button, isDebuff)
        local size = i <= lead and leadPx or px
        if i > 1 and (i - 1) % perRow == 0 then
            row, along = row + 1, 0
        end
        button:ClearAllPoints()
        if horizontal then
            button:SetPoint(corner, reference, relative, x + along * hs, y + row * rowStep * vs)
        else
            button:SetPoint(corner, reference, relative, x + row * rowStep * hs, y + along * vs)
        end
        button:SetSize(size, size)
        along = along + size + spacing
        if button.cooldown then
            button.cooldown:SetHideCountdownNumbers(size < COUNTDOWN_MIN_SIZE)
            button.cooldown:SetAlpha(duration)
        end
        if button.count then
            button.count:SetAlpha(count)
        end
        button:EnableMouse(tooltips)
    end
end

local function percent(height, value)
    return max(floor(height * value / 100 + 0.5), 6)
end

function F:Layout(frame)
    local height = frame:GetHeight()
    if not height or height < 1 then
        height = FALLBACK_HEIGHT
    end
    local powerBar = frame.powerBar
    local power = powerBar ~= nil and powerBar:IsShown()
    local st = state[frame]
    if not st then
        st = {}
        state[frame] = st
    elseif st.height == height and st.power == power and st.revision == revision then
        return
    end
    st.height, st.power, st.revision = height, power, revision

    local db = self.db.auras
    local buttons = frame.buffFrames
    if buttons then
        st.bpx = percent(height, db.buffs.size)
        ensure(frame, buttons, buffMax, canCreateBuffs and "CompactBuffTemplate")
        place(frame, buttons, db.buffs, st.bpx, st.bpx, 0, false)
    end
    buttons = frame.debuffFrames
    if buttons then
        st.dpx = percent(height, db.debuffs.size)
        st.lpx = floor(st.dpx * LEAD_SCALE + 0.5)
        st.lead = 0
        ensure(frame, buttons, debuffMax + leadMax, canCreateDebuffs and "CompactDebuffTemplate")
        place(frame, buttons, db.debuffs, st.dpx, st.lpx, 0, true)
    end
    -- Blizzard's aura update ran before this layout on a first setup.
    self:Update(frame)
end

-- Setup resets size and anchors: always lay out again.
function F:Setup(frame)
    local st = state[frame]
    if st then
        st.revision = nil
    end
    self:Layout(frame)
end

-- Refill ---------------------------------------------------------------------------------------
-- Fills slots first..last with auras of `filter` (bossMode ANY/BOSS/NOT_BOSS);
-- returns the last slot used. Hot path.
local function fillRange(buttons, first, last, unit, filter, bossMode, size, isDebuff)
    local slot, index = first - 1, 1
    while slot < last do
        local name, icon, count, debuffType, duration, expiration, _, _, _, _, _, isBoss = UnitAura(unit, index, filter)
        if not name then
            break
        end
        if bossMode == ANY or (bossMode == BOSS) == (isBoss and true or false) then
            local button = buttons[slot + 1]
            if not button then
                break
            end
            slot = slot + 1
            button:SetID(index)
            button.filter = filter
            button.icon:SetTexture(icon)
            if count and count > 1 then
                button.count:SetText(count)
                button.count:Show()
            else
                button.count:Hide()
            end
            if duration and duration > 0 then
                setCooldown(button.cooldown, expiration - duration, duration, true, true)
            else
                clearCooldown(button.cooldown)
            end
            -- Blizzard enlarges boss debuffs on its own update.
            if button:GetWidth() ~= size then
                button:SetSize(size, size)
            end
            if isDebuff then
                local typeBorder = typeBorders[button]
                if typeBorder then
                    if R[debuffType or "none"] == nil then
                        debuffType = "none"
                    end
                    local t = debuffType or "none"
                    typeBorder:SetVertexColor(R[t], G[t], B[t], 1)
                end
            end
            button:Show()
        end
        index = index + 1
    end
    return slot
end

local function hideFrom(buttons, first)
    for i = first, #buttons do
        buttons[i]:Hide()
    end
end

function F:Update(frame)
    local st = state[frame]
    local unit = frame.displayedUnit or frame.unit
    if not st or not unit then
        return
    end
    local buttons = frame.buffFrames
    if buttons and st.bpx then
        hideFrom(buttons, fillRange(buttons, 1, buffMax, unit, buffFilter, ANY, st.bpx, false) + 1)
    end
    buttons = frame.debuffFrames
    if buttons and st.dpx then
        local lead = 0
        if leadMax > 0 then
            lead = fillRange(buttons, 1, leadMax, unit, debuffFilter, BOSS, st.lpx, true)
        end
        if lead ~= st.lead then
            st.lead = lead
            place(frame, buttons, self.db.auras.debuffs, st.dpx, st.lpx, lead, true)
        end
        local last = fillRange(buttons, lead + 1, lead + debuffMax, unit, debuffFilter,
            leadMax > 0 and NOT_BOSS or ANY, st.dpx, true)
        hideFrom(buttons, last + 1)
    end
end

RF.On("DefaultCompactUnitFrameSetup", F, F.Setup)
RF.On("CompactUnitFrame_UpdateAll", F, F.Layout) -- catches size changes (party size option)
RF.On("CompactUnitFrame_UpdateAuras", F, F.Update)

function F:OnEnable()
    resolve(self.db)
    revision = revision + 1
    RF.ForEachFrame(self.Layout, self)
end

function F:OnRefresh(key)
    if not key or key:find("^auras%.") then
        self:OnEnable()
    end
end

-- Extra buttons are SUI's; Blizzard never shows or hides them.
function F:OnDisable()
    for buttons, keep in pairs(original) do
        for i = keep + 1, #buttons do
            buttons[i]:Hide()
        end
    end
end
