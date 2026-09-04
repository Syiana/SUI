local LibDBIcon = LibStub("LibDBIcon-1.0")
local Module = SUI:NewModule("Maps.Minimap");

function Module:OnEnable()

    local db = {
        maps = SUI.db.profile.maps,
        queueicon = SUI.db.profile.edit.queueicon
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

        function Module:UpdateQueueIconPosition()
            if C_AddOns.IsAddOnLoaded("EditModeExpanded") then return end
            QueueStatusButton:SetParent(UIParent)
            QueueStatusButton:SetFrameLevel(1)
            QueueStatusButton:SetScale(0.8, 0.8)
            QueueStatusButton:ClearAllPoints()
            QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
        end

        hooksecurefunc(QueueStatusButton, "UpdatePosition", function()
            -- Edit Mode owns the button while the manager is open. Reanchoring here
            -- would yank it out from under the drag and back to the stored spot,
            -- which is why it used to snap back to the minimap corner.
            if EditModeManagerFrame and EditModeManagerFrame:IsShown() then return end

            Module:UpdateQueueIconPosition()
        end)

        -- Blizzard only calls UpdatePosition when the queue state changes, so claim
        -- the button up front rather than leaving it anchored to the minimap.
        Module:UpdateQueueIconPosition()
    end
end
