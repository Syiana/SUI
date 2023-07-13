local Module = SUI:NewModule("Skins.UnitFrames");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in ipairs({
            PlayerFrameAlternateManaBarBorder,
            PlayerFrameAlternateManaBarLeftBorder,
            PlayerFrameAlternateManaBarRightBorder,
            PetFrameTexture
        }) do
            v:SetDesaturated(true)
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        PlayerFrame:HookScript("OnUpdate", function()
            PlayerFrame.PlayerFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        PetFrame:HookScript("OnUpdate", function()
            PetFrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        TargetFrame:HookScript("OnUpdate", function()
            TargetFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            TargetFrameToT.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        FocusFrame:HookScript("OnUpdate", function()
            FocusFrame.TargetFrameContainer.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            FocusFrameToT.FrameTexture:SetVertexColor(unpack(SUI:Color(0.15)))
        end)

        for _, v in pairs(TotemFrame) do
            print(_)
        end

        TotemFrame:HookScript("OnEvent", function()
            for totem, v in pairs(TotemFrame.totemPool.activeObjects) do
                totem.Border:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end)

        -- Class Resource Bars
        local classBar = CreateFrame("Frame")
        classBar:RegisterEvent("PLAYER_ENTERING_WORLD")
        classBar:RegisterEvent("PLAYER_LOGIN")
        classBar:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
        classBar:HookScript("OnEvent", function()
            -- Rogue
            for rogue, v in pairs(RogueComboPointBarFrame.classResourceButtonPool.activeObjects) do
                rogue.BGActive:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.BGInactive:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.BGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.ChargedFrameActive:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            for rogue, v in pairs(ClassNameplateBarRogueFrame.classResourceButtonPool.activeObjects) do
                rogue.BGActive:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.BGInactive:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.BGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.ChargedFrameActive:SetVertexColor(unpack(SUI:Color(0.15)))
                rogue.ChargedFrameInactive:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            -- Mage
            for mage, v in pairs(MageArcaneChargesFrame.classResourceButtonPool.activeObjects) do
                mage.ArcaneBG:SetVertexColor(unpack(SUI:Color(0.15)))
                mage.ArcaneBGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            for mage, v in pairs(ClassNameplateBarMageFrame.classResourceButtonPool.activeObjects) do
                mage.ArcaneBG:SetVertexColor(unpack(SUI:Color(0.15)))
                mage.ArcaneBGShadow:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            -- Warlock
            for warlock, v in pairs(WarlockPowerFrame.classResourceButtonPool.activeObjects) do
                warlock.Background:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            for warlock, v in pairs(ClassNameplateBarWarlockFrame.classResourceButtonPool.activeObjects) do
                warlock.Background:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            -- Druid
            for druid, v in pairs(DruidComboPointBarFrame.classResourceButtonPool.activeObjects) do
                druid.BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
                druid.BG_Inactive:SetVertexColor(unpack(SUI:Color(0.15)))
                druid.BG_Shadow:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            for druid, v in pairs(ClassNameplateBarFeralDruidFrame.classResourceButtonPool.activeObjects) do
                druid.BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
                druid.BG_Inactive:SetVertexColor(unpack(SUI:Color(0.15)))
                druid.BG_Shadow:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            -- Monk
            for monk, v in pairs(MonkHarmonyBarFrame.classResourceButtonPool.activeObjects) do
                monk.Chi_BG:SetVertexColor(unpack(SUI:Color(0.15)))
                monk.Chi_BG_Active:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            for monk, v in pairs(ClassNameplateBarWindwalkerMonkFrame.classResourceButtonPool.activeObjects) do
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
                DeathKnightResourceOverlayFrame.Rune1.BG_Active,
                DeathKnightResourceOverlayFrame.Rune1.BG_Inactive,
                DeathKnightResourceOverlayFrame.Rune1.BG_Shadow,
                DeathKnightResourceOverlayFrame.Rune2.BG_Active,
                DeathKnightResourceOverlayFrame.Rune2.BG_Inactive,
                DeathKnightResourceOverlayFrame.Rune2.BG_Shadow,
                DeathKnightResourceOverlayFrame.Rune3.BG_Active,
                DeathKnightResourceOverlayFrame.Rune3.BG_Inactive,
                DeathKnightResourceOverlayFrame.Rune3.BG_Shadow,
                DeathKnightResourceOverlayFrame.Rune4.BG_Active,
                DeathKnightResourceOverlayFrame.Rune4.BG_Inactive,
                DeathKnightResourceOverlayFrame.Rune4.BG_Shadow,
                DeathKnightResourceOverlayFrame.Rune5.BG_Active,
                DeathKnightResourceOverlayFrame.Rune5.BG_Inactive,
                DeathKnightResourceOverlayFrame.Rune5.BG_Shadow,
                DeathKnightResourceOverlayFrame.Rune6.BG_Active,
                DeathKnightResourceOverlayFrame.Rune6.BG_Inactive,
                DeathKnightResourceOverlayFrame.Rune6.BG_Shadow
            }) do
                v:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            -- Evoker
            for evoker, v in pairs(EssencePlayerFrame.classResourceButtonPool.activeObjects) do
                evoker.EssenceFillDone.CircBG:SetVertexColor(unpack(SUI:Color(0.15)))
                evoker.EssenceFillDone.CircBGActive:SetVertexColor(unpack(SUI:Color(0.15)))

            end

            for evoker, v in pairs(ClassNameplateBarDracthyrFrame.classResourceButtonPool.activeObjects) do
                evoker.EssenceFillDone.CircBG:SetVertexColor(unpack(SUI:Color(0.15)))
                evoker.EssenceFillDone.CircBGActive:SetVertexColor(unpack(SUI:Color(0.15)))
            end

            -- Paladin
            PaladinPowerBarFrame.Background:SetVertexColor(unpack(SUI:Color(0.15)))
            PaladinPowerBarFrame.ActiveTexture:Hide()
            ClassNameplateBarPaladinFrame.Background:SetVertexColor(unpack(SUI:Color(0.15)))
            ClassNameplateBarPaladinFrame.ActiveTexture:Hide()
        end)
    end
end
