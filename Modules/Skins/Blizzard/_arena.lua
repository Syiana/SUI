local Module = SUI:NewModule("Skins.Arena");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        -- f:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ArenaUI" then
                local frameList = {
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

                SUI:Skin(frameList, true)
            elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or (event == "PLAYER_ENTERING_WORLD" and instanceType == "arena") then
                local frameList = {
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

                SUI:Skin(frameList, true)
            end
        end)
    end
end
