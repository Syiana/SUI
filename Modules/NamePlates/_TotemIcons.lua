local Module = SUI:NewModule("NamePlates.TotemIcons");

function Module:OnEnable()
    if C_AddOns.IsAddOnLoaded('Plater') or C_AddOns.IsAddOnLoaded('TidyPlates_ThreatPlates') or C_AddOns.IsAddOnLoaded('TidyPlates') or C_AddOns.IsAddOnLoaded('Kui_Nameplates') then return end
    local db = SUI.db.profile.nameplates.totemicons
    if db then
        local f = CreateFrame("Frame", nil, UIParent)
        f:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        f:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
        f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

        f:SetScript("OnEvent", function(self, event, ...)
            return self[event](self, event, ...)
        end)

        local showDuration = true
        local showCooldownCount = false
        local showFriendlyTotems = true

        local activeTotems = {}
        local totemStartTimes = setmetatable({ __mode = "v" }, {})

        -- /script SetCVar("nameplateShowFriendlyTotems", 1)

        -- nameplateShowEnemyGuardians = "0",
        -- nameplateShowEnemyMinions   = "0",
        -- nameplateShowEnemyMinus     = "0",
        -- nameplateShowEnemyTotems    = "1",
        -- nameplateShowEnemyPets      = "1",
        local APILevel = math.floor(select(4, GetBuildInfo()) / 10000)

        local function GetNPCIDByGUID(guid)
            local _, _, _, _, _, npcID = strsplit("-", guid);
            return tonumber(npcID)
        end

        local totemNpcIDs
        if APILevel >= 8 then
            totemNpcIDs = {
                -- [npcID] = { spellID, duration }
                [2630] = { 2484, 20 }, -- Earthbind
                [60561] = { 51485, 20 }, -- Earthgrab
                [3527] = { 5394, 15 }, -- Healing Stream
                [6112] = { 8512, 120 }, -- Windfury
                [97369] = { 192222, 15 }, -- Liquid Magma
                [5913] = { 8143, 10 }, -- Tremor
                [5925] = { 204336, 3 }, -- Grounding
                [78001] = { 157153, 15 }, -- Cloudburst
                [53006] = { 98008, 6 }, -- Spirit Link
                [59764] = { 108280, 12 }, -- Healing Tide
                [61245] = { 192058, 2 }, -- Static Charge
                [100943] = { 198838, 15 }, -- Earthen Wall
                [97285] = { 192077, 15 }, -- Wind Rush
                [105451] = { 204331, 15 }, -- Counterstrike
                [104818] = { 207399, 30 }, -- Ancestral
                [105427] = { 204330, 15 }, -- Skyfury
                [179867] = { 355580, 6 }, -- Static Field
                [166523] = { 324386, 30 }, -- Vesper Totem (Kyrian)

                -- Warrior
                [119052] = { 236320, 15 }, -- War Banner

                --Priest
                [101398] = { 211522, 12 }, -- Psyfiend
            }
        elseif APILevel <= 2 then
            totemNpcIDs = {
                -- [npcID] = { spellID, duration }
                [2630] = { 2484, 20 }, -- Earthbind
                [5925] = { 8177, 45 }, -- Grounding
                [3968] = { 6495, 300 }, -- Sentry
                [15430] = { 2062, 120 }, -- Earth Elemental Totem
                [15439] = { 2894, 120 }, -- Fire Elemental Totem
                [15447] = { 3738, 120 }, -- Wrath of Air Totem
                [17539] = { 30706, 120 }, -- Totem of Wrath
                [5924] = { 8170, 120 }, -- Disease Cleansing Totem
                [5923] = { 8166, 120 }, -- Poison Cleansing Totem
                [15803] = { 25908, 120 }, -- Tranquil Air Totem
                [5913] = { 8143, 120 }, -- Tremor
            }
            local function addTotem(data, ...)
                local numArgs = select("#", ...)
                for i = 1, numArgs do
                    local npcID = select(i, ...)
                    totemNpcIDs[npcID] = data
                end
            end

            addTotem({ 5675, 120 }, 3573, 7414, 7415, 7416, 15489) -- Mana Spring Totem
            addTotem({ 1535, 5 }, 5879, 6110, 6111, 7844, 7845, 15482, 15483) -- Fire Nova Totem
            addTotem({ 8187, 20 }, 5929, 7464, 7465, 7466, 15484) -- Magma Totem
            addTotem({ 3599, 60 }, 2523, 3902, 3903, 3904, 7400, 7402, 15480) -- Searing Totem
            addTotem({ 5730, 15 }, 3579, 3911, 3912, 3913, 7398, 7399, 15478) -- Stoneclaw Totem
            addTotem({ 8184, 120 }, 5927, 7424, 7425, 15487) -- Fire Resistance Totem
            addTotem({ 8227, 120 }, 5950, 6012, 7423, 10557, 15485) -- Flametongue Totem
            addTotem({ 8181, 120 }, 5926, 7412, 7413, 15486) -- Frost Resistance Totem
            addTotem({ 8835, 120 }, 7486, 7487, 15463) -- Grace of Air Totem
            addTotem({ 10595, 120 }, 7467, 7468, 7469, 15490) -- Nature Resistance Totem
            addTotem({ 8071, 120 }, 5873, 5919, 5920, 7366, 7367, 7368, 15470, 15474) -- Stoneskin Totem
            addTotem({ 31634, 300 }, 5874, 5921, 5922, 7403, 15464, 15479) -- Strength of Earth
            addTotem({ 8512, 120 }, 6112, 7483, 7484, 15496, 15497) -- Windfury Totem
            addTotem({ 15107, 120 }, 9687, 9688, 9689, 15492) -- Windwall Totem
            addTotem({ 5394, 120 }, 3527, 3906, 3907, 3908, 3909, 15488) -- Healing Stream Totem
        end

        local function CreateIcon(nameplate)
            local frame = CreateFrame("Frame", nil, nameplate)
            frame:SetSize(25, 25)
            frame:SetPoint("BOTTOM", nameplate, "TOP", 0, 5)

            local icon = frame:CreateTexture(nil, "ARTWORK")
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            icon:SetAllPoints()

            local bg = frame:CreateTexture(nil, "BACKGROUND")
            bg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
            bg:SetVertexColor(0, 0, 0, 0.5)
            bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
            bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)

            local cd = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
            if not showCooldownCount then
                cd.noCooldownCount = true -- disable OmniCC for this cooldown
                cd:SetHideCountdownNumbers(true)
            end
            cd:SetReverse(true)
            cd:SetDrawEdge(false)
            cd:SetAllPoints(frame)

            frame.cooldown = cd
            frame.icon = icon
            frame.bg = bg

            return frame
        end

        function f.NAME_PLATE_UNIT_ADDED(self, event, unit)
            local np = C_NamePlate.GetNamePlateForUnit(unit)
            local guid = UnitGUID(unit)
            local npcID = GetNPCIDByGUID(guid)

            if npcID and totemNpcIDs[npcID] then
                if not showFriendlyTotems then
                    -- local isAttackable = UnitCanAttack("player", unit)
                    local isFriendly = UnitReaction(unit, "player") >= 4
                    if isFriendly then return end
                end

                if not np.NugTotemIcon then
                    np.NugTotemIcon = CreateIcon(np)
                end

                local iconFrame = np.NugTotemIcon
                iconFrame:Show()

                local totemData = totemNpcIDs[npcID]
                local spellID, duration = unpack(totemData)

                local tex = C_Spell.GetSpellTexture(spellID)

                iconFrame.icon:SetTexture(tex)
                local startTime = totemStartTimes[guid]
                if startTime and showDuration then
                    iconFrame.cooldown:SetCooldown(startTime, duration)
                    iconFrame.cooldown:Show()
                end

                activeTotems[guid] = np
            end
        end

        function f.NAME_PLATE_UNIT_REMOVED(self, event, unit)
            local np = C_NamePlate.GetNamePlateForUnit(unit)
            if np.NugTotemIcon then
                np.NugTotemIcon:Hide()

                local guid = UnitGUID(unit)
                activeTotems[guid] = nil
            end
        end

        function f:COMBAT_LOG_EVENT_UNFILTERED(event, unit)
            local timestamp, eventType, hideCaster,
            srcGUID, srcName, srcFlags, srcFlags2,
            dstGUID, dstName, dstFlags, dstFlags2 = CombatLogGetCurrentEventInfo()

            if eventType == "SPELL_SUMMON" then
                local npcID = GetNPCIDByGUID(dstGUID)
                if npcID and totemNpcIDs[npcID] then
                    totemStartTimes[dstGUID] = GetTime()
                end
            end
        end
    end
end
