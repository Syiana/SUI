local Module = SUI:NewModule("Misc.Interrupt");

function Module:OnEnable()
    local db = SUI.db.profile.misc.interrupt
    if (db) then
        local function GetAnnounceChannel()
            if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
                return "INSTANCE_CHAT"
            elseif IsInRaid() then
                return "RAID"
            elseif IsInGroup() then
                return "PARTY"
            end
        end

        local frame = CreateFrame("Frame")

        -- COMBAT_LOG_EVENT_UNFILTERED is closed to addons since 12.0, but
        -- UNIT_SPELLCAST_INTERRUPTED now carries the interrupter's GUID, which is
        -- everything this needed the combat log for.
        frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
        frame:SetScript("OnEvent", function(_, _, unitTarget, _, spellID, interruptedBy)
            if interruptedBy ~= UnitGUID("player") then return end

            local channel = GetAnnounceChannel()
            if not channel then return end

            local destName = unitTarget and UnitName(unitTarget)
            local spellLink = spellID and C_Spell.GetSpellLink(spellID)
            if not destName or not spellLink then return end

            SendChatMessage("INTERRUPTED" .. " " .. destName .. ": " .. spellLink, channel)
        end)
    end
end
