local Module = SUI:NewModule("Skins.TradeSkill");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_TradeSkillUI" then
                SUI:Skin(TradeSkillFrame)
                SUI:Skin(TradeSkillExpandButtonFrame)
                SUI:Skin(TradeSkillSubClassDropDown)
                SUI:Skin(TradeSkillInvSlotDropDown)
                SUI:Skin(TradeSkillListScrollFrame)
                SUI:Skin(TradeSkillFrameEditBox)
                SUI:Skin(TradeSkillInputBox)
                SUI:Skin(TradeSkillDetailScrollFrame)

                -- Buttons
                SUI:Skin({
                    TradeSkillCreateAllButton.Left,
                    TradeSkillCreateAllButton.Middle,
                    TradeSkillCreateAllButton.Right,
                    TradeSkillCreateButton.Left,
                    TradeSkillCreateButton.Middle,
                    TradeSkillCreateButton.Right,
                    TradeSkillCancelButton.Left,
                    TradeSkillCancelButton.Middle,
                    TradeSkillCancelButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
