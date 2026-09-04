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

        local applyingQueueIcon = false

        function Module:UpdateQueueIconPosition()
            if C_AddOns.IsAddOnLoaded("EditModeExpanded") then return end
            if applyingQueueIcon then return end

            -- LibEditMode flags the button movable for exactly as long as it is
            -- selected in Edit Mode. Correcting the anchor in that window would fight
            -- the drag, and it also covers the SetPoint LibEditMode does on drop,
            -- which lands before it tells us the new position.
            if QueueStatusButton:IsMovable() then return end

            applyingQueueIcon = true
            QueueStatusButton:SetParent(UIParent)
            QueueStatusButton:SetScale(0.8, 0.8)
            QueueStatusButton:ClearAllPoints()
            QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
            applyingQueueIcon = false
        end

        -- Blizzard reanchors this button from more than one place: its own
        -- UpdatePosition, the minimap layout and Edit Mode. Hooking UpdatePosition
        -- only caught one of them, so watch SetPoint instead and put the button back
        -- whichever path moved it.
        hooksecurefunc(QueueStatusButton, "SetPoint", function()
            if applyingQueueIcon then return end

            Module:UpdateQueueIconPosition()
        end)

        -- Blizzard only repositions on queue changes, so claim the button up front.
        Module:UpdateQueueIconPosition()
    end
end
