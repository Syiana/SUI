local Module = SUI:NewModule("Misc.Hide");

function Module:OnEnable()
    local db = SUI.db.profile.misc.dragonflying
    if (db) then
        local function hideWings()
            for _, child in ipairs({UIWidgetPowerBarContainerFrame:GetChildren()}) do
                for _, v in ipairs({child:GetRegions()}) do
                    if v:GetObjectType() == "Texture" then
                        v:Hide()
                    end
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