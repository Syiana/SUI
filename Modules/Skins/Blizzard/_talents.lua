local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_TalentUI" then
                -- TalentFrame
                SUI:Skin(PlayerTalentFrame)
                SUI:Skin(PlayerTalentFrameInset)
                SUI:Skin(PlayerTalentFramePanel1)
                SUI:Skin(PlayerTalentFramePanel2)
                SUI:Skin(PlayerTalentFramePanel3)
                if (PlayerTalentFramePanel4) then
                    SUI:Skin(PlayerTalentFramePanel4)
                end

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

                -- Talent DualSpec Frame
                SUI:Skin(PlayerTalentFrameActivateButton)
                SUI:Skin(PlayerTalentFrameToggleSummariesButton)
                SUI:Skin(PlayerTalentFramePanel1SelectTreeButton)
                SUI:Skin(PlayerTalentFramePanel2SelectTreeButton)
                SUI:Skin(PlayerTalentFramePanel3SelectTreeButton)
                if (PlayerTalentFramePanel4SelectTreeButton) then
                    SUI:Skin(PlayerTalentFramePanel4SelectTreeButton)
                end

                -- Tabs
                SUI:Skin(PlayerTalentFrameTab1)
                SUI:Skin(PlayerTalentFrameTab3)
            end

            if name == "Blizzard_GlyphUI" then
                -- Glyph Frame
                SUI:Skin(GlyphFrame)
                SUI:Skin(PlayerTalentFrameInset)
                SUI:Skin(GlyphFrameScrollFrame)
                SUI:Skin(GlyphFrameSideInset)
                SUI:Skin(GlyphFrameHeader1)
                SUI:Skin(GlyphFrameHeader2)
                SUI:Skin({
                        GlyphFrameScrollFrameScrollBarTop,
                        GlyphFrameScrollFrameScrollBarMiddle,
                        GlyphFrameScrollFrameScrollBarBottom
                    },
                    false,
                    true
                )
                --SUI:Skin(GlyphFrameScrollFrameScrollBar)
            end
        end)
    end
end
