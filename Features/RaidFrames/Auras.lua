--[[
    SUI 2.0 - Features/RaidFrames/Auras.lua

    Retail only. Dispel highlight and a centered defensive/external cooldown
    display on raid and party frames. Both use the client's AuraContainer
    (as SUI 1.x does for target auras), so aura data is never read in Lua and
    Midnight secret values stay inside the client.
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local pairs, strfind, CreateFrame = pairs, string.find, CreateFrame

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
    local curve = C_CurveUtil.CreateColorCurve()
    curve:SetType(Enum.LuaCurveType.Step)
    -- Dispel type enum -> colour: none, magic, curse, disease, poison, enrage, bleed.
    curve:AddPoint(0, DEBUFF_TYPE_NONE_COLOR)
    curve:AddPoint(1, DEBUFF_TYPE_MAGIC_COLOR)
    curve:AddPoint(2, DEBUFF_TYPE_CURSE_COLOR)
    curve:AddPoint(3, DEBUFF_TYPE_DISEASE_COLOR)
    curve:AddPoint(4, DEBUFF_TYPE_POISON_COLOR)
    curve:AddPoint(9, DEBUFF_TYPE_BLEED_COLOR or DEBUFF_TYPE_NONE_COLOR)
    dispelBorderOptions = { showWithoutDispelType = false, customDispelColorCurve = curve }
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

    local count = cooldown:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    count:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 2, -1)
    auraFrame:SetApplicationCount(count)
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
