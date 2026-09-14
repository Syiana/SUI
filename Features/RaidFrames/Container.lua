--[[
    SUI 2.0 - Features/RaidFrames/Container.lua

    Everything that works on the raid and party containers rather than on
    single unit frames: scale, strata, custom party frame size, party frames
    while solo, keeping Blizzard_CompactRaidFrames enabled and the theme tint
    of the raid manager and container borders. Protected containers are only
    touched out of combat.
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local _G, InCombatLockdown, IsInGroup = _G, InCombatLockdown, IsInGroup

-- Scale ---------------------------------------------------------------------------
local Scale = SUI:NewFeature("RaidFrames.Scale", {
    category = "raidframes",
    toggle = function(db)
        return db.raidscale ~= 1 or db.partyscale ~= 1
    end,
})

local function setScale(frame, scale)
    if frame and not frame:IsForbidden() and frame:GetScale() ~= scale then
        frame:SetScale(scale)
    end
end

-- Retail parents CompactPartyFrame to PartyFrame; scaling both would
-- multiply the scale, so the compact frame is only scaled on its own.
local function applyScales(raid, party)
    local partyFrame, compact = _G.PartyFrame, _G.CompactPartyFrame
    setScale(_G.CompactRaidFrameContainer, raid)
    setScale(partyFrame, party)
    if compact and (not partyFrame or compact:GetParent() ~= partyFrame) then
        setScale(compact, party)
    end
    if not partyFrame then
        for i = 1, 4 do
            setScale(_G["PartyMemberFrame" .. i], party)
        end
    end
end

local function scaleNow()
    if Scale.enabled then
        applyScales(Scale.db.raidscale, Scale.db.partyscale)
    end
end

function Scale:Apply()
    SUI:RunAfterCombat(scaleNow)
end

function Scale:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Apply")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "Apply")
    self:Apply()
end

function Scale:OnRefresh()
    self:Apply()
end

function Scale:OnDisable()
    SUI:RunAfterCombat(function()
        applyScales(1, 1)
    end)
end

-- Always on top -------------------------------------------------------------------
local OnTop = SUI:NewFeature("RaidFrames.AlwaysOnTop", {
    category = "raidframes",
    toggle = "alwaysontop",
})

local ONTOP_FRAMES = { "CompactRaidFrameContainer", "CompactPartyFrame", "PartyFrame" }
local originalStrata = {}

local function raiseNow()
    if not OnTop.enabled then
        return
    end
    for i = 1, #ONTOP_FRAMES do
        local frame = _G[ONTOP_FRAMES[i]]
        if frame and not frame:IsForbidden() then
            originalStrata[frame] = originalStrata[frame] or frame:GetFrameStrata()
            frame:SetFrameStrata("HIGH")
        end
    end
end

function OnTop:OnEnable()
    SUI:RunAfterCombat(raiseNow)
end

function OnTop:OnDisable()
    SUI:RunAfterCombat(function()
        for frame, strata in pairs(originalStrata) do
            frame:SetFrameStrata(strata)
        end
    end)
end

-- Custom party frame size (1.x: party members and pets only) -----------------------
local Size = SUI:NewFeature("RaidFrames.Size", {
    category = "raidframes",
    toggle = "size",
    reload = true, -- Blizzard only restores its sizes on a full layout pass
})

local PARTY, PET = RF.PARTY, RF.PET

-- Compared against the real size, so Blizzard re-layouts are caught too.
function Size:Apply(frame)
    local kind = RF.kind[frame]
    if kind ~= PARTY and kind ~= PET then
        return
    end
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED", "ApplyAll")
        return
    end
    local db = self.db
    if kind == PET then
        if frame:GetWidth() ~= db.width then
            frame:SetWidth(db.width)
        end
    elseif frame:GetWidth() ~= db.width or frame:GetHeight() ~= db.height then
        frame:SetSize(db.width, db.height)
        if frame.statusText then
            frame.statusText:ClearAllPoints()
            frame.statusText:SetPoint("CENTER", frame, "CENTER")
        end
        if frame.centerStatusIcon then
            frame.centerStatusIcon:ClearAllPoints()
            frame.centerStatusIcon:SetPoint("CENTER", frame, "CENTER")
        end
    end
end

function Size:ApplyAll()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    RF.ForEachFrame(self.Apply, self)
end

RF.On("CompactUnitFrame_UpdateAll", Size, Size.Apply)

Size.OnEnable = Size.ApplyAll
Size.OnRefresh = Size.ApplyAll

-- Party frames while solo ------------------------------------------------------------
local Solo = SUI:NewFeature("RaidFrames.Solo", {
    category = "raidframes",
    toggle = "solo",
    clients = { Mainline = true, TBC = true },
})

local function showSolo()
    local party = _G.CompactPartyFrame
    if not Solo.enabled or not party or IsInGroup() then
        return
    end
    if InCombatLockdown() then
        Solo:RegisterEvent("PLAYER_REGEN_ENABLED", "Update")
        return
    end
    if not party:IsShown() then
        party:Show()
        if _G.PartyFrame and _G.PartyFrame.UpdatePaddingAndLayout then
            _G.PartyFrame:UpdatePaddingAndLayout()
        end
    end
end

function Solo:Update()
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    showSolo()
end

function Solo:OnLoad()
    local party = _G.CompactPartyFrame
    if party and party.UpdateVisibility then
        self:Hook(party, "UpdateVisibility", showSolo)
    end
end

Solo.OnEnable = Solo.Update

function Solo:OnDisable()
    SUI:RunAfterCombat(function()
        local party = _G.CompactPartyFrame
        if party and party.UpdateVisibility then
            party:UpdateVisibility()
        end
    end)
end

-- Keep Blizzard_CompactRaidFrames enabled (1.x _Show.lua, without its taint) --------
local KeepEnabled = SUI:NewFeature("RaidFrames.KeepEnabled", {
    category = "raidframes",
    toggle = "keepenabled",
})

local BLIZZARD_ADDONS = { Blizzard_CompactRaidFrames = true, Blizzard_CUFProfiles = true }

local function reenable(addon)
    if BLIZZARD_ADDONS[addon] then
        SUI.Compat.EnableAddOn(addon)
    end
end

function KeepEnabled:OnLoad()
    if C_AddOns and C_AddOns.DisableAddOn then
        self:Hook(C_AddOns, "DisableAddOn", reenable)
    elseif _G.DisableAddOn then
        self:Hook("DisableAddOn", reenable)
    end
end

function KeepEnabled:OnEnable()
    if SUI.Compat.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
        return
    end
    for addon in pairs(BLIZZARD_ADDONS) do
        SUI.Compat.EnableAddOn(addon)
    end
    SUI:Print("Blizzard raid frames were disabled and have been enabled again. Reload the interface to show them.")
    SUI:RequestReload(self.id)
end

-- Theme tint (1.x Skins/Blizzard/_raidframe.lua and the party border tint) ---------
SUI.Skin:Register("Blizzard_CompactRaidFrames", {
    "CompactRaidFrameManager",
    "CompactRaidFrameManager.BorderFrame",
    "CompactPartyFrameBorderFrame",
    "CompactRaidFrameContainerBorderFrame",
    "CompactRaidFrameContainer.BorderFrame",
})
