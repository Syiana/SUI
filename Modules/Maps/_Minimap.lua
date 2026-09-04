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

            -- Level 1 keeps the button out of the way in normal play, but it also puts
            -- it under the Edit Mode overlay. While the manager is open the Editmode
            -- module has lifted it, so leave the level alone; it restores it on exit.
            if not (EditModeManagerFrame and EditModeManagerFrame:IsShown()) then
                QueueStatusButton:SetFrameLevel(1)
            end

            QueueStatusButton:SetScale(0.8, 0.8)
            QueueStatusButton:ClearAllPoints()
            QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
        end

        hooksecurefunc(QueueStatusButton, "UpdatePosition", function()
            -- This is a post-hook, so Blizzard has already reanchored the button by
            -- the time we run and we have to put it back. The one moment we must not
            -- is while LibEditMode has it selected for dragging: it flags the button
            -- movable for exactly that window, and correcting the anchor mid-drag
            -- would pull it out from under the cursor.
            if QueueStatusButton:IsMovable() then return end

            Module:UpdateQueueIconPosition()
        end)

        -- Blizzard only calls UpdatePosition when the queue state changes, so claim
        -- the button up front rather than leaving it anchored to the minimap.
        Module:UpdateQueueIconPosition()
    end
end
