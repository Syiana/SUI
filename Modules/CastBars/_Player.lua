local Module = SUI:NewModule("CastBars.Player");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.castbars.style,
        texture = SUI.db.profile.general.texture,
        module = SUI.db.profile.modules.castbars
    }

    if (db.module) then
        if (SUI:Color()) then
            CastingBarFrame.Border:SetVertexColor(unpack(SUI:Color(0.15)))
            MirrorTimer1Border:SetVertexColor(.15, .15, .15)
        end

        CastingBarFrame:HookScript("OnEvent", function(self, event)
            if self.unit == "player" then
                local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo("player")
                local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo("player")

                if (notInterruptibleCast) then
                    CastingBarFrame:SetStatusBarColor(.7, .7, .7)
                elseif (notInterruptibleChannel) then
                    CastingBarFrame:SetStatusBarColor(.7, .7, .7)
                else
                    local color
                    local isChannel = UnitChannelInfo("player");

                    if (isChannel) then
                        color = CastingBarFrame.startChannelColor
                    else
                        color = CastingBarFrame.startCastColor
                    end

                    CastingBarFrame:SetStatusBarColor(color.r, color.g, color.b)
                end
            end
        end)

        if (db.style == 'Custom') then
            if not InCombatLockdown() then
                CastingBarFrame.ignoreFramePositionManager = true
                CastingBarFrame:SetMovable(true)
                CastingBarFrame:ClearAllPoints()
                CastingBarFrame:SetScale(1)
                CastingBarFrame:SetUserPlaced(true)
                CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -120)
                CastingBarFrame.Icon:Show()
                CastingBarFrame.Icon:ClearAllPoints()
                CastingBarFrame.Icon:SetSize(20, 20)
                CastingBarFrame.Icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -5, 0)
                CastingBarFrame.Border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border-Small]])
                CastingBarFrame.Flash:SetTexture([[Interface\CastingBar\UI-CastingBar-Flash-Small]])
                CastingBarFrame.Text:ClearAllPoints()
                CastingBarFrame.Text:SetPoint("CENTER", 0, 1)

                CastingBarFrame.BorderShield:SetWidth(CastingBarFrame.BorderShield:GetWidth())
                CastingBarFrame.Border:SetPoint("TOP", 0, 26)
                CastingBarFrame.Flash:SetPoint("TOP", 0, 26)
                CastingBarFrame.BorderShield:SetPoint("TOP", 0, 26)

                --Texture
                CastingBarFrame.Border:SetDrawLayer("OVERLAY", 1)
                MirrorTimer1Border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border-Small]])

                if (db.texture ~= 'Default') then
                    CastingBarFrame:SetStatusBarTexture(db.texture)
                    MirrorTimer1StatusBar:SetStatusBarTexture(db.texture)
                    MirrorTimer1StatusBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    MirrorTimer1StatusBar:ClearAllPoints()
                    MirrorTimer1StatusBar:SetPoint("CENTER", MirrorTimer1, "CENTER", 0, 6)
                end

                CastingBarFrame:SetWidth(CastingBarFrame:GetWidth() - 0.7)
            end
        end
    end
end
