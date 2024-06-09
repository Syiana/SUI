local Module = SUI:NewModule("Skins.Arena");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ArenaUI" and not (C_AddOns.IsAddOnLoaded("Shadowed Unit Frames")) then
                for i, v in pairs(
                    {
                        ArenaEnemyFrame1Texture,
                        ArenaEnemyFrame2Texture,
                        ArenaEnemyFrame3Texture,
                        ArenaEnemyFrame4Texture,
                        ArenaEnemyFrame5Texture,
                        ArenaEnemyFrame1SpecBorder,
                        ArenaEnemyFrame2SpecBorder,
                        ArenaEnemyFrame3SpecBorder,
                        ArenaEnemyFrame4SpecBorder,
                        ArenaEnemyFrame5SpecBorder,
                        ArenaEnemyFrame1PetFrameTexture,
                        ArenaEnemyFrame2PetFrameTexture,
                        ArenaEnemyFrame3PetFrameTexture,
                        ArenaEnemyFrame4PetFrameTexture,
                        ArenaEnemyFrame5PetFrameTexture
                    }
                ) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or
                (event == "PLAYER_ENTERING_WORLD" and instanceType == "arena")
            then
                for i, v in pairs(
                    {
                        ArenaPrepFrame1Texture,
                        ArenaPrepFrame2Texture,
                        ArenaPrepFrame3Texture,
                        ArenaPrepFrame4Texture,
                        ArenaPrepFrame5Texture,
                        ArenaPrepFrame1SpecBorder,
                        ArenaPrepFrame2SpecBorder,
                        ArenaPrepFrame3SpecBorder,
                        ArenaPrepFrame4SpecBorder,
                        ArenaPrepFrame5SpecBorder
                    }
                ) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end

            if C_AddOns.IsAddOnLoaded("Blizzard_ArenaUI") then
                for i, v in pairs(
                    {
                        ArenaEnemyFrame1Texture,
                        ArenaEnemyFrame2Texture,
                        ArenaEnemyFrame3Texture,
                        ArenaEnemyFrame4Texture,
                        ArenaEnemyFrame5Texture,
                        ArenaEnemyFrame1SpecBorder,
                        ArenaEnemyFrame2SpecBorder,
                        ArenaEnemyFrame3SpecBorder,
                        ArenaEnemyFrame4SpecBorder,
                        ArenaEnemyFrame5SpecBorder,
                        ArenaEnemyFrame1PetFrameTexture,
                        ArenaEnemyFrame2PetFrameTexture,
                        ArenaEnemyFrame3PetFrameTexture,
                        ArenaEnemyFrame4PetFrameTexture,
                        ArenaEnemyFrame5PetFrameTexture
                    }
                ) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
