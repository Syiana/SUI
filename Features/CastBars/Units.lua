--[[
    SUI 2.0 - Features/CastBars/Units.lua

    Target and focus cast bars in the "Custom" style: compact bar, outlined
    text, tinted border, user scale and an optional position above the unit
    frame. SUI 1.x re-anchored these bars every frame; here the position is
    re-applied only when Blizzard moves the bar (a SetPoint hook).
]]

local _, ns = ...
local SUI = ns.SUI

local function unitCastbar(id, prefix, barName, frameName, clients)
    local enabledKey, sizeKey, topKey = prefix .. "Castbar", prefix .. "Size", prefix .. "OnTop"

    local F = SUI:NewFeature(id, {
        category = "castbars",
        clients = clients,
        toggle = function(db)
            return db.style == "Custom" and db[enabledKey]
        end,
        reload = true,
    })

    local bar, unitFrame
    local placing = false

    local function place()
        if placing or not F.db[topKey] then
            return
        end
        placing = true
        bar:ClearAllPoints()
        if bar.TextBorder then
            bar:SetPoint("TOPLEFT", unitFrame, "TOPLEFT", 45, 0)   -- retail (1.x position)
        else
            bar:SetPoint("BOTTOMLEFT", unitFrame, "TOPLEFT", 25, -12) -- classic art
        end
        placing = false
    end

    local function style()
        if InCombatLockdown() then
            return
        end
        local db = F.db
        bar:SetScale(db[sizeKey] or 1)
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
            SUI.Skin:Texture(bar.Background, true)
        end
        if bar.Text then
            bar.Text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        end
        local name = bar:GetName()
        SUI.Skin:Texture(bar.Border or (name and _G[name .. "Border"]), true)
        place()
    end

    function F:OnLoad()
        bar, unitFrame = _G[barName], _G[frameName]
        if not bar or not unitFrame then
            return
        end
        self:Hook(bar, "SetPoint", place)
        if bar.SetLook then
            self:Hook(bar, "SetLook", style)
        end
        self:HookScript(bar, "OnShow", function()
            if bar.TextBorder and bar:GetWidth() ~= 150 then
                style()
            end
        end)
    end

    function F:OnEnable()
        if bar then
            SUI:RunAfterCombat(style)
        end
    end

    function F:OnRefresh(key)
        if not bar then
            return
        end
        if key == sizeKey then
            SUI:RunAfterCombat(style)
        elseif key == topKey then
            if self.db[topKey] then
                place()
            elseif bar.AdjustPosition then
                bar:AdjustPosition()
            elseif Target_Spellbar_AdjustPosition then
                Target_Spellbar_AdjustPosition(bar)
            end
        end
    end
end

unitCastbar("CastBars.Target", "target", "TargetFrameSpellBar", "TargetFrame")
unitCastbar("CastBars.Focus", "focus", "FocusFrameSpellBar", "FocusFrame", { Mainline = true, Mists = true, TBC = true })
