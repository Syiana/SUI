local Module = SUI:NewModule("Misc.Interrupt");

function Module:OnEnable()
    local db = SUI.db.profile.misc.interrupt
    if (db) then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        frame:SetScript("OnEvent", function()
            if IsInGroup() then
                local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
                if not (event == "SPELL_INTERRUPT" and sourceGUID == UnitGUID("player")) then return end
                SendChatMessage("INTERRUPTED" .. " " .. destName .. ": " .. C_Spell.GetSpellLink(spellID), "PARTY")
            elseif IsInRaid() then
                local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
                if not (event == "SPELL_INTERRUPT" and sourceGUID == UnitGUID("player")) then return end
                SendChatMessage("INTERRUPTED" .. " " .. destName .. ": " .. C_Spell.GetSpellLink(spellID), "RAID")
            end
        end)
    end
end
