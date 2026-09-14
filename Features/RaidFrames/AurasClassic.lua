--[[
    SUI 2.0 - Features/RaidFrames/AurasClassic.lua

    Classic clients: buffs and debuffs on raid frames reuse Blizzard's aura
    buttons (frame.buffFrames / frame.debuffFrames). Layout (size, anchor,
    growth, rows, spacing) is applied when Blizzard's frame setup runs or an
    option changes; after each Blizzard aura update the buttons are refilled
    with SUI's filter and count. No tables or closures on the update path.
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local _G, floor, strfind, CreateFrame = _G, math.floor, string.find, CreateFrame

local CLASSIC = { Classic = true }

-- Resolved in OnLoad (client APIs are not touched at file load).
local UnitAura, setCooldown, clearCooldown, debuffColors

local function resolveApi()
    if UnitAura then
        return
    end
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
    debuffColors = DebuffTypeColor
end

-- Layout ---------------------------------------------------------------------------------
-- Buttons are anchored straight to the unit frame: the corner opposite the
-- growth sits on the chosen anchor, shifted by column/row.
local original = setmetatable({}, { __mode = "k" }) -- button array -> Blizzard's button count

local function layout(frame, buttons, db, template)
    local count = #buttons
    if original[buttons] == nil then
        original[buttons] = count
    end
    if template and count > 0 then
        for i = count + 1, db.max do
            local button = CreateFrame("Button", nil, frame, template)
            button:Hide()
            buttons[i] = button
        end
    end

    local grow, anchor = db.grow, db.anchor
    local horizontal = grow == "LEFT" or grow == "RIGHT"
    local hs, vs
    if horizontal then
        hs = grow == "RIGHT" and 1 or -1
        vs = strfind(anchor, "BOTTOM") and 1 or -1
    else
        vs = grow == "UP" and 1 or -1
        hs = strfind(anchor, "RIGHT") and -1 or 1
    end
    local corner = (vs > 0 and "BOTTOM" or "TOP") .. (hs > 0 and "LEFT" or "RIGHT")
    local size, step, perRow = db.size, db.size + db.spacing, db.perRow

    for i = 1, #buttons do
        local button = buttons[i]
        local col, row = (i - 1) % perRow, floor((i - 1) / perRow)
        local dx, dy
        if horizontal then
            dx, dy = col * step * hs, row * step * vs
        else
            dx, dy = row * step * hs, col * step * vs
        end
        button:ClearAllPoints()
        button:SetPoint(corner, frame, anchor, db.x + dx, db.y + dy)
        button:SetSize(size, size)
        if button.cooldown then
            button.cooldown:SetAlpha(db.duration and 1 or 0)
        end
        if button.count then
            button.count:SetAlpha(db.count and 1 or 0)
        end
        if i > db.max then
            button:Hide()
        end
    end
end

-- Hands extra buttons back (Blizzard does not know them) on disable.
local function hideExtra(buttons)
    local keep = original[buttons]
    if keep then
        for i = keep + 1, #buttons do
            buttons[i]:Hide()
        end
    end
end

-- Refill -------------------------------------------------------------------------------------
-- Runs after every Blizzard aura update of a raid frame (hot path).
local function fill(buttons, unit, filter, max, bossOnly, size, isDebuff)
    local shown, index = 0, 1
    while shown < max do
        local name, icon, count, debuffType, duration, expiration, _, _, _, _, _, isBoss = UnitAura(unit, index, filter)
        if not name then
            break
        end
        if not bossOnly or isBoss then
            shown = shown + 1
            local button = buttons[shown]
            if not button then
                break
            end
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
            if isDebuff then
                -- Blizzard enlarges boss debuffs on its own update.
                if button:GetWidth() ~= size then
                    button:SetSize(size, size)
                end
                if button.border then
                    local color = debuffColors[debuffType or "none"] or debuffColors.none
                    button.border:SetVertexColor(color.r, color.g, color.b)
                end
            end
            button:Show()
        end
        index = index + 1
    end
    for i = shown + 1, #buttons do
        buttons[i]:Hide()
    end
end

-- Features ------------------------------------------------------------------------------------
local BUFF_FILTERS = { All = "HELPFUL", Mine = "HELPFUL|PLAYER" }
local DEBUFF_FILTERS = { All = "HARMFUL", Dispellable = "HARMFUL|RAID", Boss = "HARMFUL" }

local function define(id, key, field, template, filters, isDebuff)
    local F = SUI:NewFeature(id, {
        category = "raidframes",
        toggle = "auras." .. key .. ".enabled",
        clients = CLASSIC,
        reload = true, -- Blizzard's anchors come back with its next frame setup
    })

    -- Scalars read on the update path, refreshed with the settings.
    local filter, max, bossOnly, size = "HELPFUL", 3, false, 16
    local canCreate = false

    function F:OnLoad()
        resolveApi()
        canCreate = not C_XMLUtil or not C_XMLUtil.GetTemplateInfo or C_XMLUtil.GetTemplateInfo(template) ~= nil
    end

    function F:Layout(frame)
        local buttons = frame[field]
        if buttons then
            layout(frame, buttons, self.db.auras[key], canCreate and template)
        end
    end

    function F:Update(frame)
        local buttons = frame[field]
        local unit = frame.displayedUnit or frame.unit
        if buttons and unit then
            fill(buttons, unit, filter, max, bossOnly, size, isDebuff)
        end
    end

    RF.On("DefaultCompactUnitFrameSetup", F, F.Layout)
    RF.On("CompactUnitFrame_UpdateAuras", F, F.Update)

    local function layoutAndFill(self, frame)
        self:Layout(frame)
        self:Update(frame)
    end

    function F:OnEnable()
        local db = self.db.auras[key]
        filter = filters[db.filter] or filters.All
        bossOnly = db.filter == "Boss"
        max, size = db.max, db.size
        RF.ForEachFrame(layoutAndFill, self)
    end

    function F:OnRefresh(changed)
        if not changed or strfind(changed, "^auras%." .. key) then
            self:OnEnable()
        end
    end

    local function restore(_, frame)
        if frame[field] then
            hideExtra(frame[field])
        end
    end

    function F:OnDisable()
        RF.ForEachFrame(restore)
    end

    return F
end

define("RaidFrames.BuffsClassic", "buffs", "buffFrames", "CompactBuffTemplate", BUFF_FILTERS, false)
define("RaidFrames.DebuffsClassic", "debuffs", "debuffFrames", "CompactDebuffTemplate", DEBUFF_FILTERS, true)
