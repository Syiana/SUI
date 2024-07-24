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

        local function QueueStatusButton_Reposition()
            if C_AddOns.IsAddOnLoaded("EditModeExpanded") then return end
            QueueStatusButton:SetParent(UIParent)
            QueueStatusButton:SetFrameLevel(1)
            QueueStatusButton:SetScale(0.8, 0.8)
            QueueStatusButton:ClearAllPoints()
            QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
        end
        
        hooksecurefunc(QueueStatusButton, "UpdatePosition", function()
            QueueStatusButton_Reposition()
        end)
    end
end
