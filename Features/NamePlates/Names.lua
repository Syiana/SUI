--[[
    SUI 2.0 - Features/NamePlates/Names.lua

    Player names on nameplates: class coloured, without the realm, and the
    arena slot number instead of the name in arenas. One hook on
    CompactUnitFrame_UpdateName handles all three, so they cannot overwrite
    each other. Nameplate name fonts are set once.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, UnitName = next, UnitName
local state = NP.state

local F = SUI:NewFeature("NamePlates.Names", {
    category = "nameplates",
    toggle = function(db)
        return db.arenanumber or (NP.isCustom(db) and (db.color or db.server))
    end,
    conflicts = NP.conflicts,
    reload = true, -- Blizzard only rewrites a name when the unit changes
})

local showArena, classColor, hideServer

local FONTS = { "SystemFont_NamePlate", "SystemFont_NamePlateFixed", "SystemFont_LargeNamePlate", "SystemFont_LargeNamePlateFixed" }
local originalFonts = {}

local function setFonts(custom)
    for i = 1, #FONTS do
        local font = _G[FONTS[i]]
        if font and font:GetFont() then
            local orig = originalFonts[i]
            if not orig then
                orig = { font:GetFont() }
                originalFonts[i] = orig
            end
            if custom then
                font:SetFont(orig[1], 10, "OUTLINE")
            else
                font:SetFont(orig[1], orig[2], orig[3])
            end
        end
    end
end

local function apply(st)
    local name = st.frame.name
    if not name then
        return
    end
    if showArena and st.arena then
        name:SetText(st.arena)
        name:SetVertexColor(1, 1, 0)
        return
    end
    if not st.isPlayer then
        return
    end
    if hideServer then
        name:SetText((UnitName(st.unit)))
    end
    if classColor and st.classR then
        name:SetVertexColor(st.classR, st.classG, st.classB)
    end
end

function F:OnLoad()
    self:Hook("CompactUnitFrame_UpdateName", function(frame)
        local st = state[frame]
        if st and st.unit then
            apply(st)
        end
    end)
end

function F:OnEnable()
    local db = self.db
    local custom = NP.isCustom(db)
    showArena = db.arenanumber and not SUI.IsVanilla
    classColor = custom and db.color
    hideServer = custom and db.server
    setFonts(custom)
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    if not SUI.IsVanilla then
        self:RegisterEvent("ARENA_OPPONENT_UPDATE", "ApplyAll")
    end
    self:ApplyAll()
end

F.OnRefresh = F.OnEnable

function F:ApplyAll()
    for _, frame in next, NP.byUnit do
        apply(state[frame])
    end
end

function F:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        apply(st)
    end
end

function F:OnDisable()
    setFonts(false)
end
