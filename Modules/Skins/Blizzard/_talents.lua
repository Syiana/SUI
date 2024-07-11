local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self, event, name)
            if (PlayerTalentFrame) then
                -- TalentFrame
                SUI:Skin(PlayerTalentFrame)
                SUI:Skin(PlayerTalentFrameInset)
                SUI:Skin(PlayerTalentFramePanel1)
                SUI:Skin(PlayerTalentFramePanel2)
                SUI:Skin(PlayerTalentFramePanel3)
                SUI:Skin(PlayerTalentFramePointsBar)
                SUI:Skin(PlayerTalentFrameScrollFrame)

                SUI:Skin(PlayerTalentFrameLearnButton)
                SUI:Skin(PlayerTalentFrameResetButton)
                SUI:Skin({
                        PlayerTalentFramePanel1HeaderIconPrimaryBorder,
                        PlayerTalentFramePanel1HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel2HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel2HeaderIconPrimaryBorder,
                        PlayerTalentFramePanel3HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel3HeaderIconPrimaryBorder,
                        PlayerTalentFramePanel4HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel4HeaderIconPrimaryBorder,
                    },
                    false,
                    true
                )

                -- Tabs
                SUI:Skin(PlayerTalentFrameTab1)
                SUI:Skin(PlayerTalentFrameTab2)
                SUI:Skin(PlayerTalentFrameTab3)

                -- Spec Tabs
                select(1, PlayerSpecTab1:GetRegions()):SetVertexColor(.15, .15, .15)
                select(1, PlayerSpecTab2:GetRegions()):SetVertexColor(.15, .15, .15)

                -- Buttons
                SUI:Skin({
                    PlayerTalentFrameLearnButton.Left,
                    PlayerTalentFrameLearnButton.Middle,
                    PlayerTalentFrameLearnButton.Right,
                    PlayerTalentFrameResetButton.Left,
                    PlayerTalentFrameResetButton.Middle,
                    PlayerTalentFrameResetButton.Right,
                    PlayerTalentFrameActivateButton.Left,
                    PlayerTalentFrameActivateButton.Middle,
                    PlayerTalentFrameActivateButton.Right,
                }, false, true, false, true)
            end

            if name == "Blizzard_TalentUI" then
                -- TalentFrame
                SUI:Skin(PlayerTalentFrame)
                SUI:Skin(PlayerTalentFrameInset)
                SUI:Skin(PlayerTalentFramePanel1)
                SUI:Skin(PlayerTalentFramePanel2)
                SUI:Skin(PlayerTalentFramePanel3)
                SUI:Skin(PlayerTalentFramePointsBar)
                SUI:Skin(PlayerTalentFrameScrollFrame)

                SUI:Skin(PlayerTalentFrameLearnButton)
                SUI:Skin(PlayerTalentFrameResetButton)
                SUI:Skin({
                        PlayerTalentFramePanel1HeaderIconPrimaryBorder,
                        PlayerTalentFramePanel1HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel2HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel2HeaderIconPrimaryBorder,
                        PlayerTalentFramePanel3HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel3HeaderIconPrimaryBorder,
                        PlayerTalentFramePanel4HeaderIconSecondaryBorder,
                        PlayerTalentFramePanel4HeaderIconPrimaryBorder,
                    },
                    false,
                    true
                )

                -- Tabs
                SUI:Skin(PlayerTalentFrameTab1)
                SUI:Skin(PlayerTalentFrameTab2)
                SUI:Skin(PlayerTalentFrameTab3)

                -- Buttons
                SUI:Skin({
                    PlayerTalentFrameLearnButton.Left,
                    PlayerTalentFrameLearnButton.Middle,
                    PlayerTalentFrameLearnButton.Right,
                    PlayerTalentFrameResetButton.Left,
                    PlayerTalentFrameResetButton.Middle,
                    PlayerTalentFrameResetButton.Right,
                    PlayerTalentFrameActivateButton.Left,
                    PlayerTalentFrameActivateButton.Middle,
                    PlayerTalentFrameActivateButton.Right,
                }, false, true, false, true)
            end
        end)
    end
end
