--[[
    SUI 2.0 - Features/NamePlates/Auras.lua

    Crowd control on the unit (left of the health bar) and its important
    buffs (right) on retail nameplates. Uses the 12.1 AuraContainer, which
    filters and updates the auras itself (secret-safe), so SUI only binds a
    container to the unit when the plate appears.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next = next

local F = SUI:NewFeature("NamePlates.Auras", {
    category = "nameplates",
    toggle = "auras.enabled",
    clients = { Mainline = true },
    conflicts = NP.conflicts,
})

local BASE = 20
local containers = {} -- state -> { cc = container, important = container }
local ccFilter, importantFilter

local function initIcon(aura)
    aura:SetSize(BASE, BASE)
    local icon = aura:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    aura:SetIcon(icon)
    NP.SkinIcon(icon, aura)
    local cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
    cooldown:SetAllPoints(icon)
    cooldown:SetReverse(true)
    cooldown:SetDrawBling(false)
    aura:SetDurationCooldown(cooldown)
    aura:SetMouseMotionEnabled(false)
end

local function newContainer(st, filter, point, relative, x, grow)
    local container = CreateFrame("AuraContainer", nil, st.frame, "CustomAuraContainerTemplate")
    container:SetFlowLayoutAnchorPoint(point)
    container:SetFlowLayoutGrowthDirection(grow, AnchorUtil.FlowDirection.Down)
    container:SetFlowLayoutMaximumLineSize(3 * (BASE + 2))
    container:AddAuraGroup("SUI", filter, {
        maxFrameCount = 3,
        initializeFrame = initIcon,
        layout = { elementSpacing = 2, lineSpacing = 2 },
    })
    container:SetPoint(point, st.healthBar, relative, x, 0)
    container:SetEnabled(false)
    return container
end

local function bind(container, unit, show, scale)
    if show then
        container:SetScale(scale)
        container:SetUnit(unit)
        container:SetEnabled(true)
        container:Show()
    else
        container:SetEnabled(false)
        container:Hide()
    end
end

local function apply(st)
    if not st.healthBar then
        return
    end
    local set = containers[st]
    if not set then
        set = {
            cc = newContainer(st, ccFilter, "RIGHT", "LEFT", -24, AnchorUtil.FlowDirection.Left),
            important = newContainer(st, importantFilter, "LEFT", "RIGHT", 24, AnchorUtil.FlowDirection.Right),
        }
        containers[st] = set
    end
    local db = F.db.auras
    local scale = db.size / BASE
    bind(set.cc, st.unit, db.cc, scale)
    bind(set.important, st.unit, db.important, scale)
end

function F:OnLoad()
    local AF = AuraUtil and AuraUtil.AuraFilters
    if not (AF and AuraUtil.CreateFilterString and select(4, GetBuildInfo()) >= 120100) then
        self.unavailable = true
        return
    end
    ccFilter = AuraUtil.CreateFilterString(AF.Harmful, AF.CrowdControl)
    importantFilter = AuraUtil.CreateFilterString(AF.Helpful, AF.Important)
end

function F:OnEnable()
    if self.unavailable then
        return
    end
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "Removed")
    for _, frame in next, NP.byUnit do
        apply(NP.state[frame])
    end
end

F.OnRefresh = F.OnEnable

function F:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        apply(st)
    end
end

function F:Removed()
    local set = NP.removed and containers[NP.removed]
    if set then
        bind(set.cc, nil, false)
        bind(set.important, nil, false)
    end
end

function F:OnDisable()
    for _, set in next, containers do
        bind(set.cc, nil, false)
        bind(set.important, nil, false)
    end
end
