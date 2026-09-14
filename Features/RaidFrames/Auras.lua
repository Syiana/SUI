--[[
    SUI 2.0 - Features/RaidFrames/Auras.lua

    Retail only. Dispel highlight, a centered defensive/external cooldown
    display and configurable buff/debuff containers on raid and party frames.
    All use the client's AuraContainer through its public setters
    (as SUI 1.x does for target auras), so aura data is never read in Lua and
    Midnight secret values stay inside the client.
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local pairs, strfind, CreateFrame, GetCVar, SetCVar = pairs, string.find, CreateFrame, SUI.Compat.GetCVar, SUI.Compat.SetCVar

local MAINLINE = { Mainline = true }
local ICON_SIZE = 20 -- base size; the option scales the container

-- Our own containers keep their state in fields on the container frame.
local function bindUnit(container, frame)
    local unit = frame.displayedUnit or frame.unit
    if container.suiUnit ~= unit then
        container.suiUnit = unit
        if unit then
            container:SetUnit(unit)
        end
        container:SetEnabled(unit ~= nil)
    end
    if unit then
        container:UpdateAllAuras()
    end
end

local function newContainer(frame, level)
    local container = CreateFrame("AuraContainer", nil, frame, "CustomAuraContainerTemplate")
    container:SetFrameLevel(frame:GetFrameLevel() + level)
    container:SetSize(1, 1)
    return container
end

-- Copies the look of Blizzard's selection border onto a texture.
local function borderLook(texture, frame)
    local selection = frame.selectionHighlight
    if selection and selection:GetTexture() then
        texture:SetTexture(selection:GetTexture())
        texture:SetTexCoord(selection:GetTexCoord())
    else
        texture:SetTexture(SUI.Media.blank)
        texture:SetAlpha(0.3)
    end
end

-- Dispel type enum -> colour (none, magic, curse, disease, poison, enrage, bleed).
-- Built once, on first use.
local dispelCurve
function RF.DispelCurve()
    if not dispelCurve then
        dispelCurve = C_CurveUtil.CreateColorCurve()
        dispelCurve:SetType(Enum.LuaCurveType.Step)
        dispelCurve:AddPoint(0, DEBUFF_TYPE_NONE_COLOR)
        dispelCurve:AddPoint(1, DEBUFF_TYPE_MAGIC_COLOR)
        dispelCurve:AddPoint(2, DEBUFF_TYPE_CURSE_COLOR)
        dispelCurve:AddPoint(3, DEBUFF_TYPE_DISEASE_COLOR)
        dispelCurve:AddPoint(4, DEBUFF_TYPE_POISON_COLOR)
        dispelCurve:AddPoint(9, DEBUFF_TYPE_BLEED_COLOR or DEBUFF_TYPE_NONE_COLOR)
    end
    return dispelCurve
end

-- Dispel highlight ------------------------------------------------------------------
local Dispel = SUI:NewFeature("RaidFrames.Dispel", {
    category = "raidframes",
    toggle = "auras.dispel",
    clients = MAINLINE,
})

local dispelContainers = setmetatable({}, { __mode = "k" })
local dispelBorderOptions

-- One invisible aura button per frame; its border is stretched over the
-- whole raid frame and coloured by the client from the dispel type.
local function initDispelButton(auraFrame)
    auraFrame:SetSize(1, 1)
    auraFrame:EnableMouse(false)
    local icon = auraFrame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(1, 1)
    icon:SetAlpha(0)
    auraFrame:SetIcon(icon)

    local raidFrame = auraFrame:GetParent():GetParent()
    local overlay = CreateFrame("Frame", nil, auraFrame)
    overlay:SetAllPoints(raidFrame)
    local border = overlay:CreateTexture(nil, "OVERLAY", nil, 7)
    border:SetAllPoints(overlay)
    borderLook(border, raidFrame)
    auraFrame:SetAuraBorder(border, dispelBorderOptions)
end

function Dispel:OnLoad()
    dispelBorderOptions = { showWithoutDispelType = false, customDispelColorCurve = RF.DispelCurve() }
end

function Dispel:Apply(frame)
    local container = dispelContainers[frame]
    if not container then
        container = newContainer(frame, 6)
        container:SetPoint("CENTER", frame, "CENTER")
        container:AddAuraGroup("Dispel", "HARMFUL|RAID_PLAYER_DISPELLABLE", {
            maxFrameCount = 1,
            initializeFrame = initDispelButton,
        })
        dispelContainers[frame] = container
    end
    container:Show()
    bindUnit(container, frame)
end

RF.On("CompactUnitFrame_UpdateAll", Dispel, Dispel.Apply)

function Dispel:OnEnable()
    RF.ForEachFrame(self.Apply, self)
end

local function hideContainers(list)
    for _, container in pairs(list) do
        container:SetEnabled(false)
        container.suiUnit = nil
        container:Hide()
    end
end

function Dispel:OnDisable()
    hideContainers(dispelContainers)
end

-- Defensive and external cooldowns ---------------------------------------------------
local Defensives = SUI:NewFeature("RaidFrames.Defensives", {
    category = "raidframes",
    toggle = "auras.defensives",
    clients = MAINLINE,
})

local defensiveContainers = setmetatable({}, { __mode = "k" })

local function initIcon(auraFrame)
    auraFrame:SetSize(ICON_SIZE, ICON_SIZE)
    auraFrame:EnableMouse(false) -- never steal clicks or mouseover casts from the raid frame

    local backdrop = auraFrame:CreateTexture(nil, "BACKGROUND")
    backdrop:SetPoint("TOPLEFT", -1, 1)
    backdrop:SetPoint("BOTTOMRIGHT", 1, -1)
    backdrop:SetTexture(SUI.Media.blank)
    SUI.Theme:Paint(backdrop, true)

    local icon = auraFrame:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(auraFrame)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    auraFrame:SetIcon(icon)

    local cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
    cooldown:SetAllPoints(icon)
    cooldown:SetReverse(true)
    cooldown:SetDrawBling(false)
    cooldown:SetHideCountdownNumbers(true)
    auraFrame:SetDurationCooldown(cooldown)
    auraFrame.suiCooldown = cooldown

    local count = cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    count:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 2, -1)
    auraFrame:SetApplicationCount(count)
    auraFrame.suiCount = count
end

local LAYOUT = { elementSpacing = 1, lineSpacing = 1 }

function Defensives:Apply(frame)
    local container = defensiveContainers[frame]
    local db = self.db.auras
    if not container then
        container = newContainer(frame, 8)
        container:SetPoint("CENTER", frame, "CENTER")
        container:SetFlowLayoutAnchorPoint("CENTER")
        container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
        container:AddAuraGroup("Big", "HELPFUL|BIG_DEFENSIVE", {
            maxFrameCount = 2, initializeFrame = initIcon, layout = LAYOUT,
        })
        container:AddAuraGroup("External", "HELPFUL|EXTERNAL_DEFENSIVE", {
            maxFrameCount = 2, initializeFrame = initIcon, layout = LAYOUT,
        })
        container:AddAuraGroup("Important", "HELPFUL|IMPORTANT|!BIG_DEFENSIVE|!EXTERNAL_DEFENSIVE", {
            maxFrameCount = 0, initializeFrame = initIcon, layout = LAYOUT,
        })
        defensiveContainers[frame] = container
    end
    if container.suiSize ~= db.size then
        container.suiSize = db.size
        container:SetScale(db.size / ICON_SIZE)
    end
    if container.suiImportant ~= db.important then
        container.suiImportant = db.important
        container:SetAuraGroupMaxFrameCount("Important", db.important and 1 or 0)
    end
    container:Show()
    bindUnit(container, frame)
end

RF.On("CompactUnitFrame_UpdateAll", Defensives, Defensives.Apply)

function Defensives:OnEnable()
    RF.ForEachFrame(self.Apply, self)
end

function Defensives:OnRefresh(key)
    if key and strfind(key, "^auras") then
        self:OnEnable()
    end
end

function Defensives:OnDisable()
    hideContainers(defensiveContainers)
end

-- Buffs and debuffs -----------------------------------------------------------------------
-- Buttons are built once at BASE size; size is container scale, so offsets
-- are divided by it. Spacing is fixed (the group layout has no setter).
local BASE, GAP = 20, 1
local AURA_LAYOUT = { elementSpacing = GAP, lineSpacing = GAP }
local NO_CANDIDATES, BOSS_ONLY = {}, { isBossOrRoleAura = true }

local auraButtons = setmetatable({}, { __mode = "k" }) -- aura button -> "buffs" | "debuffs"

local function styleButton(auraFrame, db)
    auraFrame.suiCooldown:SetAlpha(db.duration and 1 or 0)
    auraFrame.suiCount:SetAlpha(db.count and 1 or 0)
end

local function initAura(auraFrame, key)
    initIcon(auraFrame)
    auraFrame:SetSize(BASE, BASE)
    auraButtons[auraFrame] = key
    styleButton(auraFrame, SUI.db.profile.raidframes.auras[key])
end

local function initBuff(auraFrame)
    initAura(auraFrame, "buffs")
end

local function initDebuff(auraFrame)
    initAura(auraFrame, "debuffs")
    local border = auraFrame:CreateTexture(nil, "BACKGROUND", nil, 1)
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetTexture(SUI.Media.blank)
    auraFrame:SetAuraBorder(border, { showWithoutDispelType = true, customDispelColorCurve = RF.DispelCurve() })
end

local function saveAndSetCVar(name, value)
    local current = GetCVar(name)
    if current == nil then
        return
    end
    local saved = SUI.db.char.raidframes.savedCVars
    if value == nil then
        if saved[name] ~= nil then
            SetCVar(name, saved[name])
            saved[name] = nil
        end
    else
        if saved[name] == nil then
            saved[name] = current
        end
        if current ~= value then
            SetCVar(name, value)
        end
    end
end

local function defineAuras(id, key, level, init, cvar, mainFilters, extraFilter)
    local F = SUI:NewFeature(id, {
        category = "raidframes",
        toggle = "auras." .. key .. ".enabled",
        clients = MAINLINE,
    })

    local containers = setmetatable({}, { __mode = "k" })

    local function layout(container, frame, db)
        local scale = db.size / BASE
        local anchor, grow = db.anchor, db.grow
        local directions = AnchorUtil.FlowDirection
        local primary, secondary
        if grow == "LEFT" or grow == "RIGHT" then
            primary = grow == "LEFT" and directions.Left or directions.Right
            secondary = strfind(anchor, "BOTTOM") and directions.Up or directions.Down
        else
            primary = grow == "UP" and directions.Up or directions.Down
            secondary = strfind(anchor, "RIGHT") and directions.Left or directions.Right
        end
        container:SetScale(scale)
        container:ClearAllPoints()
        container:SetPoint(anchor, frame, anchor, db.x / scale, db.y / scale)
        container:SetFlowLayoutAnchorPoint(anchor)
        container:SetFlowLayoutGrowthDirection(primary, secondary)
        container:SetFlowLayoutMaximumLineSize(db.perRow * (BASE + GAP))

        local extra = extraFilter and db.filter == "Defensives"
        container:SetAuraGroupFilterString("Main", mainFilters[db.filter] or mainFilters.All)
        container:SetAuraGroupCandidateFilters("Main", db.filter == "Boss" and BOSS_ONLY or NO_CANDIDATES)
        container:SetAuraGroupMaxFrameCount("Main", db.max)
        if extraFilter then
            container:SetAuraGroupMaxFrameCount("Extra", extra and db.max or 0)
        end
    end

    function F:Apply(frame)
        local container = containers[frame]
        if not container then
            local db = self.db.auras[key]
            container = newContainer(frame, level)
            container:AddAuraGroup("Main", mainFilters.All, {
                maxFrameCount = db.max, initializeFrame = init, layout = AURA_LAYOUT,
            })
            if extraFilter then
                container:AddAuraGroup("Extra", extraFilter, {
                    maxFrameCount = 0, initializeFrame = init, layout = AURA_LAYOUT,
                })
            end
            containers[frame] = container
            layout(container, frame, db)
        end
        container:Show()
        bindUnit(container, frame)
    end

    RF.On("CompactUnitFrame_UpdateAll", F, F.Apply)

    local function relayout(self, frame)
        local container = containers[frame]
        if container then
            layout(container, frame, self.db.auras[key])
        end
        self:Apply(frame)
    end

    local function suppressBlizzard()
        if F.enabled then
            saveAndSetCVar(cvar, "0")
        end
    end

    function F:OnEnable()
        SUI:RunAfterCombat(suppressBlizzard)
        RF.ForEachFrame(relayout, self)
        local db = self.db.auras[key]
        for button, kind in pairs(auraButtons) do
            if kind == key then
                styleButton(button, db)
            end
        end
    end

    function F:OnRefresh(changed)
        if not changed or strfind(changed, "^auras%." .. key) then
            self:OnEnable()
        end
    end

    function F:OnDisable()
        hideContainers(containers)
        SUI:RunAfterCombat(function()
            saveAndSetCVar(cvar, nil)
        end)
    end

    return F
end

defineAuras("RaidFrames.Buffs", "buffs", 4, initBuff, "raidFramesDisplayBuffs",
    { All = "HELPFUL", Mine = "HELPFUL|PLAYER", Defensives = "HELPFUL|BIG_DEFENSIVE" }, "HELPFUL|EXTERNAL_DEFENSIVE")
defineAuras("RaidFrames.Debuffs", "debuffs", 5, initDebuff, "raidFramesDisplayDebuffs",
    { All = "HARMFUL", Dispellable = "HARMFUL|RAID_PLAYER_DISPELLABLE", Boss = "HARMFUL" }, nil)
