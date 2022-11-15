local LibDBIcon = LibStub("LibDBIcon-1.0")
local Module = SUI:NewModule("Maps.Minimap");

function Module:OnEnable()

  local db = {
    maps = SUI.db.profile.maps,
    queueicon = SUI.db.profile.edit.queueicon
  }

  if db then
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

    if not db.maps.minimap then MinimapCluster:Hide() return end
    if not (IsAddOnLoaded("SexyMap")) then
      local Size = CreateFrame("Frame")
      Size:RegisterEvent("ADDON_LOADED")
      Size:RegisterEvent("PLAYER_LOGIN")
      Size:RegisterEvent("PLAYER_ENTERING_WORLD")
      Size:RegisterEvent("VARIABLES_LOADED")
      Size:SetScript("OnEvent", function()
        Minimap:SetScale(db.maps.minimapsize)
      end)

      QueueStatusButton:SetParent(UIParent)
      QueueStatusButton:SetFrameLevel(1)
      QueueStatusButton:SetScale(0.8, 0.8)
      QueueStatusButton:ClearAllPoints()
      QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)

      hooksecurefunc("QueueStatusDropDown_Show", function(button, relativeTo)
        DropDownList1:ClearAllPoints()
        DropDownList1:SetPoint("BOTTOMLEFT", QueueStatusButton, "BOTTOMLEFT", -70, -60)
      end)
    end
  end
end