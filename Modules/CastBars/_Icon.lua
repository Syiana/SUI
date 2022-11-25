local Module = SUI:NewModule("CastBars.Icon");

function Module:OnEnable()
    local db = SUI.db.profile.castbars
    if (db.style == 'Custom' and SUI:Color() and db.icon) then
        if not InCombatLockdown() then
            local backdrop = {
                bgFile = nil,
                edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
                tile = false,
                tileSize = 32,
                edgeSize = 4,
                insets = {
                    left = 4,
                    right = 4,
                    top = 4,
                    bottom = 4,
                },
            }

            local function IconSkin(b)
                if not b or (b and b.styled) then return end

                if b == PlayerCastingBarFrame.Icon and (PlayerCastingBarFrame) then
                    b.parent = PlayerCastingBarFrame
                elseif b == FocusFrameSpellBar.Icon then
                    b.parent = FocusFrameSpellBar
                else
                    b.parent = TargetFrameSpellBar
                end

                local frame = CreateFrame("Frame", nil, b.parent)

                b:SetTexCoord(0.1, 0.9, 0.1, 0.9)

                local border = frame:CreateTexture(nil, "BACKGROUND")
                border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
                border:SetTexCoord(0, 1, 0, 1)
                border:SetDrawLayer("BACKGROUND", -7)
                --border:SetVertexColor(unpack(SUI:Color()))
                border:ClearAllPoints()
                border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
                border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
                b.border = border

                local back = CreateFrame("Frame", nil, b.parent, "BackdropTemplate")
                back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
                back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
                back:SetFrameLevel(frame:GetFrameLevel() - 1)
                back:SetBackdrop(backdrop)
                back:SetBackdropBorderColor(unpack(SUI:Color(0.25)))
                back:SetAlpha(0.9)
                b.bg = back
                b.styled = true
            end

            local total = 0
            local timer = CreateFrame("Frame")
            timer:SetScript("OnUpdate", function(self, elapsed)
                total = total + elapsed
                if PlayerCastingBarFrame.Icon then
                    IconSkin(PlayerCastingBarFrame.Icon)
                end
                if TargetFrameSpellBar.Icon then
                    IconSkin(TargetFrameSpellBar.Icon)
                end
                if FocusFrameSpellBar.Icon then
                    IconSkin(FocusFrameSpellBar.Icon)
                end
                if PlayerCastingBarFrame.Icon.styled and TargetFrameSpellBar.Icon.styled then
                    timer:SetScript("OnUpdate", nil)
                end
            end)
        end
    end
end
