local LibDBIcon = LibStub("LibDBIcon-1.0")
local Module = SUI:NewModule("Maps.Minimap");

function Module:OnEnable()

    local db = {
        maps = SUI.db.profile.maps,
    }

    if db then
        if not (C_AddOns.IsAddOnLoaded("SexyMap")) then
            if db.maps.buttons then
                local EventFrame = CreateFrame("Frame")
                EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
                EventFrame:SetScript("OnEvent", function()
                    local buttons = LibDBIcon:GetButtonList()
                    for i = 1, #buttons do
                        LibDBIcon:ShowOnEnter(buttons[i], true)
                    end
                end)
            end
        end

        -- The queue status icon used to be reparented and reanchored here. Blizzard
        -- drives its position from its own code and from Edit Mode, so every custom
        -- anchor turned into a tug of war; it is left alone now.
    end
end
