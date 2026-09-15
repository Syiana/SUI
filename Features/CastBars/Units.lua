--[[
    SUI 2.0 - Features/CastBars/Units.lua

    Target, focus and boss cast bars in the "Custom" style: compact bar,
    outlined text, tinted border and a user scale. Target and focus can sit
    above their unit frame; SUI 1.x re-anchored them every frame, here the
    position is re-applied only when Blizzard moves the bar (a SetPoint hook).
]]

local _, ns = ...
local SUI = ns.SUI
local CB = ns.CastBars

local function styleBar(bar, scale)
    bar:SetScale(scale or 1)
    if bar.TextBorder then
        if bar:GetWidth() ~= 150 then
            bar:SetSize(150, 12)
        end
        bar.TextBorder:SetAlpha(0)
        local icon = bar.Icon
        if icon then
            icon:SetSize(16, 16)
            icon:ClearAllPoints()
            icon:SetPoint("TOPLEFT", bar, "TOPLEFT", -20, 2)
            if bar.BorderShield then
                bar.BorderShield:ClearAllPoints()
                bar.BorderShield:SetPoint("CENTER", icon, "CENTER", 0, -2.5)
            end
        end
        if bar.Text then
            bar.Text:ClearAllPoints()
            bar.Text:SetPoint("TOP", bar, "TOP", 0, 2.5)
        end
    end
    if bar.Text then
        bar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    end
    CB.TintBar(bar)
end

-- spec: id, enabledKey, sizeKey, topKey (optional), clients, bars() -> array of { bar, unitFrame }
local function unitCastbars(spec)
    local enabledKey, sizeKey, topKey = spec.enabledKey, spec.sizeKey, spec.topKey

    local F = SUI:NewFeature(spec.id, {
        category = "castbars",
        clients = spec.clients,
        toggle = function(db)
            return db.style == "Custom" and db[enabledKey]
        end,
        reload = true,
    })

    local bars, unitOf = {}, {}
    local placing = false

    local function place(bar)
        if placing or not topKey or not F.db[topKey] then
            return
        end
        placing = true
        bar:ClearAllPoints()
        if bar.TextBorder then
            bar:SetPoint("TOPLEFT", unitOf[bar], "TOPLEFT", 45, 0)     -- retail (1.x position)
        else
            bar:SetPoint("BOTTOMLEFT", unitOf[bar], "TOPLEFT", 25, -12) -- classic art
        end
        placing = false
    end

    local function style(bar)
        if InCombatLockdown() then
            return
        end
        styleBar(bar, F.db[sizeKey])
        place(bar)
    end

    local function styleAll()
        for i = 1, #bars do
            style(bars[i])
        end
    end

    local function onShow(bar)
        if bar.TextBorder and bar:GetWidth() ~= 150 then
            style(bar)
        end
    end

    function F:OnLoad()
        local list = spec.bars()
        for i = 1, #list do
            local bar, unitFrame = list[i][1], list[i][2]
            if bar and unitFrame then
                bars[#bars + 1] = bar
                unitOf[bar] = unitFrame
                if topKey then
                    self:Hook(bar, "SetPoint", place)
                end
                if bar.SetLook then
                    self:Hook(bar, "SetLook", style)
                end
                self:HookScript(bar, "OnShow", onShow)
            end
        end
    end

    function F:OnEnable()
        SUI:RunAfterCombat(styleAll)
    end

    function F:OnThemeChanged()
        for i = 1, #bars do
            CB.TintBar(bars[i])
        end
    end

    function F:OnRefresh(key)
        if key == sizeKey then
            SUI:RunAfterCombat(styleAll)
        elseif topKey and key == topKey then
            for i = 1, #bars do
                local bar = bars[i]
                if self.db[topKey] then
                    place(bar)
                elseif bar.AdjustPosition then
                    bar:AdjustPosition()
                elseif Target_Spellbar_AdjustPosition then
                    Target_Spellbar_AdjustPosition(bar)
                end
            end
        end
    end
end

unitCastbars({
    id = "CastBars.Target", enabledKey = "targetCastbar", sizeKey = "targetSize", topKey = "targetOnTop",
    bars = function()
        return { { TargetFrameSpellBar, TargetFrame } }
    end,
})

unitCastbars({
    id = "CastBars.Focus", enabledKey = "focusCastbar", sizeKey = "focusSize", topKey = "focusOnTop",
    clients = { Mainline = true, Mists = true, TBC = true },
    bars = function()
        return { { FocusFrameSpellBar, FocusFrame } }
    end,
})

-- Boss frames: bars that do not exist on a client are skipped.
unitCastbars({
    id = "CastBars.Boss", enabledKey = "bossCastbar", sizeKey = "bossSize",
    bars = function()
        local list, bosses = {}, CB.BossBars()
        for i = 1, #bosses do
            local bar = bosses[i]
            list[i] = { bar, bar:GetParent() }
        end
        return list
    end,
})
