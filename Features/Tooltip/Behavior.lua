--[[
    SUI 2.0 - Features/Tooltip/Behavior.lua

    Where the default tooltip appears and when it is hidden. Retail places
    the tooltip through Edit Mode; the classic clients get an SUI mover for
    it instead. "Mouse Anchor" attaches it to the cursor on every client.
    "Hide in Combat" hides GameTooltip while in combat (1.x replaced its
    OnShow script; this only hooks it).
]]

local _, ns = ...
local SUI = ns.SUI

local InCombatLockdown = InCombatLockdown

-- Anchor ------------------------------------------------------------------------
local Anchor = SUI:NewFeature("Tooltip.Anchor", {
    category = "tooltip",
    toggle = function(db)
        return db.mouseanchor or not SUI.HasEditMode
    end,
})

function Anchor:OnLoad()
    local holder
    if not SUI.HasEditMode then
        holder = CreateFrame("Frame", nil, UIParent)
        holder:SetSize(150, 25)
        SUI.Movers:Add(holder, "tooltip", { point = "BOTTOMRIGHT", x = -50, y = 120 }, { label = "Tooltip" })
    end
    local feature = self
    self:Hook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        if tooltip:IsForbidden() then
            return
        end
        if feature.db.mouseanchor then
            tooltip:SetOwner(parent, "ANCHOR_CURSOR")
        elseif holder then
            tooltip:ClearAllPoints()
            tooltip:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
        end
    end)
end

-- Hide in combat --------------------------------------------------------------------
local Combat = SUI:NewFeature("Tooltip.HideInCombat", {
    category = "tooltip",
    toggle = "hideincombat",
})

local function hideInCombat(tooltip)
    if InCombatLockdown() then
        tooltip:Hide()
    end
end

function Combat:OnLoad()
    self:HookScript(GameTooltip, "OnShow", hideInCombat)
end

function Combat:OnEnable()
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "HideTooltip")
end

function Combat:HideTooltip()
    GameTooltip:Hide()
end
