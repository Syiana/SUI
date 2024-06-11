local Module = SUI:NewModule("Skins.TradeSkill");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_TradeSkillUI" then
        local frameList = {
            TradeSkillSubClassDropDownLeft,
            TradeSkillSubClassDropDownMiddle,
            TradeSkillSubClassDropDownRight,
            TradeSkillInvSlotDropDownLeft,
            TradeSkillInvSlotDropDownMiddle,
            TradeSkillInvSlotDropDownRight,
            TradeSkillHorizontalBarLeft,
            TradeSkillExpandTabLeft,
            TradeSkillExpandTabMiddle,
            TradeSkillExpandTabRight
        }

        SUI:Skin(TradeSkillFrame)
        SUI:Skin(frameList, false, true)
      end
    end)
  end
end