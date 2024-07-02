local Module = SUI:NewModule("NamePlates.ArenaNumbers");

function Module:OnEnable()
    local db = {
        arena = SUI.db.profile.nameplates.arena,
        module = SUI.db.profile.modules.nameplates
    }

    if (db.arena and db.module) then
        local myFrame = CreateFrame("Frame")
        myFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        myFrame:HookScript("OnEvent", function()
            local U = UnitIsUnit
            hooksecurefunc("CompactUnitFrame_UpdateName", function(F)
                if IsActiveBattlefieldArena() and F.unit:find("nameplate") then
                    for i = 1, 5 do
                        if U(F.unit, "arena" .. i) then
                            F.name:SetText(i)
                            F.name:SetTextColor(1, 1, 0)
                            break
                        end
                    end
                end
            end)
        end)
    end
end
