local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
    if (SUI:Color()) then
        -- Alternate Power Bar
        for i, v in ipairs({
            PlayerFrameAlternateManaBarBorder,
            PlayerFrameAlternateManaBarLeftBorder,
            PlayerFrameAlternateManaBarRightBorder,
            PetFrameTexture
        }) do
            v:SetDesaturated(true)
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Player Frame
        PlayerFrame:HookScript("OnUpdate", function()
            PlayerFrame.PlayerFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetVertexColor(unpack(
                SUI:Color(0.15)))
            PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        -- Pet Frame
        PetFrame:HookScript("OnUpdate", function()
            PetFrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        -- Target Frame
        TargetFrame:HookScript("OnUpdate", function()
            TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            TargetFrameToT.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        -- Focus Frame
        FocusFrame:HookScript("OnUpdate", function()
            FocusFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            FocusFrameToT.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        BossTargetFrameContainer:HookScript("OnUpdate", function()
            Boss1TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            Boss2TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            Boss3TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            Boss4TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        -- Totem Bar
        TotemFrame:HookScript("OnEvent", function(self)
            for totem, _ in self.totemPool:EnumerateActive() do
                totem.Border:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end)

        -- Class Resource Bars
        local _, playerClass = UnitClass("player")

        if (playerClass == 'ROGUE') then
            -- Rogue
            hooksecurefunc(RogueComboPointBarFrame, "UpdatePower", function()
                for bar, _ in RogueComboPointBarFrame.classResourceButtonPool:EnumerateActive() do
                    bar.BGActive:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BGInactive:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
                    if (bar.isCharged) then
                        bar.ChargedFrameActive:SetVertexColor(unpack(SUI:Color(0.15)))
                    end
                end

                for bar, _ in ClassNameplateBarRogueFrame.classResourceButtonPool:EnumerateActive() do
                    bar.BGActive:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BGInactive:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
                    if (bar.isCharged) then
                        bar.ChargedFrameActive:SetVertexColor(unpack(SUI:Color(0.15)))
                    end
                end
            end)
        elseif (playerClass == 'MAGE') then
            -- Mage
            hooksecurefunc(MagePowerBar, "UpdatePower", function()
                for bar, _ in MageArcaneChargesFrame.classResourceButtonPool:EnumerateActive() do
                    bar.ArcaneBG:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.ArcaneBGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
                end

                for bar, _ in ClassNameplateBarMageFrame.classResourceButtonPool:EnumerateActive() do
                    bar.ArcaneBG:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.ArcaneBGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end)
        elseif (playerClass == 'WARLOCK') then
            -- Warlock
            hooksecurefunc(WarlockPowerFrame, "UpdatePower", function()
                for bar, _ in WarlockPowerFrame.classResourceButtonPool:EnumerateActive() do
                    bar.Background:SetVertexColor(unpack(SUI:Color(0.15)))
                end

                for bar, _ in ClassNameplateBarWarlockFrame.classResourceButtonPool:EnumerateActive() do
                    bar.Background:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end)
        elseif (playerClass == 'DRUID') then
            -- Druid
            hooksecurefunc(DruidComboPointBarFrame, "UpdatePower", function()
                for bar, _ in DruidComboPointBarFrame.classResourceButtonPool:EnumerateActive() do
                    bar.BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BG_Inactive:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BG_Shadow:SetVertexColor(unpack(SUI:Color(0.15)))
                end

                for bar, _ in ClassNameplateBarFeralDruidFrame.classResourceButtonPool:EnumerateActive() do
                    bar.BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BG_Inactive:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.BG_Shadow:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end)
        elseif (playerClass == 'MONK') then
            -- Monk
            hooksecurefunc(MonkHarmonyBarFrame, "UpdatePower", function()
                for bar, _ in MonkHarmonyBarFrame.classResourceButtonPool:EnumerateActive() do
                    bar.Chi_BG:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.Chi_BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
                end

                for bar, _ in ClassNameplateBarWindwalkerMonkFrame.classResourceButtonPool:EnumerateActive() do
                    bar.Chi_BG:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.Chi_BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end)
        elseif (playerClass == 'DEATHKNIGHT') then
            -- Death Knight
            hooksecurefunc(RuneFrame, "UpdateRunes", function()
                SUI:Skin(RuneFrame.Rune1)
                SUI:Skin(RuneFrame.Rune2)
                SUI:Skin(RuneFrame.Rune3)
                SUI:Skin(RuneFrame.Rune4)
                SUI:Skin(RuneFrame.Rune5)
                SUI:Skin(RuneFrame.Rune6)
                SUI:Skin(DeathKnightResourceOverlayFrame.Rune1)
                SUI:Skin(DeathKnightResourceOverlayFrame.Rune2)
                SUI:Skin(DeathKnightResourceOverlayFrame.Rune3)
                SUI:Skin(DeathKnightResourceOverlayFrame.Rune4)
                SUI:Skin(DeathKnightResourceOverlayFrame.Rune5)
                SUI:Skin(DeathKnightResourceOverlayFrame.Rune6)
            end)
        elseif (playerClass == 'EVOKER') then
            -- Evoker
            hooksecurefunc(EssencePlayerFrame, "UpdatePower", function()
                for bar, _ in EssencePlayerFrame.classResourceButtonPool:EnumerateActive() do
                    bar.EssenceFillDone.CircBG:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.EssenceFillDone.CircBGActive:SetVertexColor(unpack(SUI:Color(0.15)))
                end

                for bar, _ in ClassNameplateBarDracthyrFrame.classResourceButtonPool:EnumerateActive() do
                    bar.EssenceFillDone.CircBG:SetVertexColor(unpack(SUI:Color(0.15)))
                    bar.EssenceFillDone.CircBGActive:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end)
        elseif (playerClass == 'PALADIN') then
            -- Paladin
            hooksecurefunc(PaladinPowerBar, "UpdatePower", function()
                PaladinPowerBarFrame.Background:SetVertexColor(unpack(SUI:Color(0.15)))
                PaladinPowerBarFrame.ActiveTexture:Hide()
                ClassNameplateBarPaladinFrame.Background:SetVertexColor(unpack(SUI:Color(0.15)))
                ClassNameplateBarPaladinFrame.ActiveTexture:Hide()
            end)
        end
    end
end
