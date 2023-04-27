local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in ipairs({
            PlayerFrameAlternateManaBarBorder,
            PlayerFrameAlternateManaBarLeftBorder,
            PlayerFrameAlternateManaBarRightBorder,
            FocusFrameSpellBar.Border,
            FocusFrameSpellBar.Background,
            TargetFrameSpellBar.Border,
            TargetFrameSpellBar.Background,
            PlayerFrame.PlayerFrameContainer.FrameTexture,
            TargetFrame.TargetFrameContainer.FrameTexture,
            FocusFrame.TargetFrameContainer.FrameTexture,
            TargetFrameToT.FrameTexture,
            FocusFrameToT.FrameTexture,
            PaladinPowerBarFrame.Background,
            PaladinPowerBarFrame.ActiveTexture,
            PlayerCastingBarFrame.Border,
            PlayerCastingBarFrame.Background,
            PetFrameTexture,
            PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon
        }) do
            v:SetDesaturated(true)
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Class Resource Bars

        -- Rogue Combopoints
        for rogue, v in pairs(RogueComboPointBarFrame.classResourceButtonPool.activeObjects) do
            rogue.BGActive:SetVertexColor(unpack(SUI:Color(0.15)))
            rogue.BGInactive:SetVertexColor(unpack(SUI:Color(0.15)))
            rogue.BGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
            for _, v in pairs(combopoint) do
                print(_)
            end
        end

        -- Mage Arcane
        for mage, v in pairs(MageArcaneChargesFrame.classResourceButtonPool.activeObjects) do
            mage.ArcaneBG:SetVertexColor(unpack(SUI:Color(0.15)))
            mage.ArcaneBGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Warlock
        for warlock, v in pairs(WarlockPowerFrame.classResourceButtonPool.activeObjects) do
            warlock.Background:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Druid
        for druid, v in pairs(DruidComboPointBarFrame.classResourceButtonPool.activeObjects) do
            druid.BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
            druid.BG_Inactive:SetVertexColor(unpack(SUI:Color(0.15)))
            druid.BG_Shadow:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Monk
        for monk, v in pairs(MonkHarmonyBarFrame.classResourceButtonPool.activeObjects) do
            monk.Chi_BG:SetVertexColor(unpack(SUI:Color(0.15)))
            monk.Chi_BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Death Knight
        for i, v in ipairs({
            RuneFrame.Rune1.BG_Active,
            RuneFrame.Rune1.BG_Inactive,
            RuneFrame.Rune1.BG_Shadow,
            RuneFrame.Rune2.BG_Active,
            RuneFrame.Rune2.BG_Inactive,
            RuneFrame.Rune2.BG_Shadow,
            RuneFrame.Rune3.BG_Active,
            RuneFrame.Rune3.BG_Inactive,
            RuneFrame.Rune3.BG_Shadow,
            RuneFrame.Rune4.BG_Active,
            RuneFrame.Rune4.BG_Inactive,
            RuneFrame.Rune4.BG_Shadow,
            RuneFrame.Rune5.BG_Active,
            RuneFrame.Rune5.BG_Inactive,
            RuneFrame.Rune5.BG_Shadow,
            RuneFrame.Rune6.BG_Active,
            RuneFrame.Rune6.BG_Inactive,
            RuneFrame.Rune6.BG_Shadow,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        -- Evoker
        for evoker, v in pairs(EssencePlayerFrame.classResourceButtonPool.activeObjects) do
            evoker.EssenceFillDone.CircBG:SetVertexColor(unpack(SUI:Color(0.15)))
            evoker.EssenceFillDone.CircBGActive:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
