local Module = SUI:NewModule("Misc.Hide");

function Module:OnEnable()
    local db = SUI.db.profile.misc.dragonflying
    if (db) then
        local function hideWings()
            if not UIWidgetPowerBarContainerFrame then return end
            
            for _, child in ipairs({UIWidgetPowerBarContainerFrame:GetChildren()}) do
                if child and child.DecorLeft and child.DecorRight then
                    child.DecorLeft:Hide()
                    child.DecorRight:Hide()
                end
            end
        end

        local updateFrame = CreateFrame("Frame")
        updateFrame:RegisterEvent("UPDATE_UI_WIDGET")
        updateFrame:HookScript("OnEvent", function()
            hideWings()
        end)
    end
end
