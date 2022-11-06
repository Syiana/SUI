local LibDBIcon = LibStub("LibDBIcon-1.0")
local Module = SUI:NewModule("Maps.Minimap");

function Module:OnEnable()

  local EventFrame = CreateFrame("Frame")
  EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

  -- TODO: ADD CONFIG
  EventFrame:SetScript("OnEvent", function() 
    local buttons = LibDBIcon:GetButtonList()
      for i = 1, #buttons do
        LibDBIcon:ShowOnEnter(buttons[i], true)
    end
  end)

  local db = SUI.db.profile.maps
	if (db) then
    if not (db.minimap) then MinimapCluster:Hide() return end
    if not (IsAddOnLoaded("SexyMap")) then
      local Size = CreateFrame("Frame")
      Size:RegisterEvent("ADDON_LOADED")
      Size:RegisterEvent("PLAYER_LOGIN")
      Size:RegisterEvent("PLAYER_ENTERING_WORLD")
      Size:RegisterEvent("VARIABLES_LOADED")
      Size:SetScript("OnEvent", function()
        Minimap:SetScale(db.minimapsize)
      end)

      QueueStatusButton:SetParent(UIParent)
      QueueStatusButton:SetFrameLevel(1)
      QueueStatusButton:ClearAllPoints()
      QueueStatusButton:SetScale(0.8, 0.8)
      QueueStatusButton:SetPoint("BOTTOMRIGHT", MinimapCluster, "BOTTOMRIGHT", -15, 50)

      hooksecurefunc("QueueStatusDropDown_Show", function(button, relativeTo)
        DropDownList1:ClearAllPoints()
        DropDownList1:SetPoint("BOTTOMLEFT", QueueStatusButton, "BOTTOMLEFT", -60, -60)
      end)
    end
  end
end