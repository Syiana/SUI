local ADDON, SUI = ...
SUI.MODULES.CASTBARS.Icon = function(DB) 
    if (DB and DB.STATE) then
        if not InCombatLockdown() then
            local function IconSkin(b)
                if not b or (b and b.styled) then return end
            
                if b == CastingBarFrame.Icon and (CastingBarFrame) then
                    b.parent = CastingBarFrame
                elseif b == FocusFrameSpellBar.Icon then
                    b.parent = FocusFrameSpellBar
                else
                    b.parent = TargetFrameSpellBar
                end
            
                frame = CreateFrame("Frame", nil, b.parent)
            
                b:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            
                local border = frame:CreateTexture(nil, "BACKGROUND")
                border:SetTexture("Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\gloss")
                border:SetTexCoord(0, 1, 0, 1)
                border:SetDrawLayer("BACKGROUND",- 7)
                border:SetVertexColor(0.4, 0.35, 0.35)
                border:ClearAllPoints()
                border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
                border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
                b.border = border
            
                local back = CreateFrame("Frame", nil, b.parent, "BackdropTemplate")
                back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
                back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
                back:SetFrameLevel(frame:GetFrameLevel() - 1)
                back:SetBackdrop(backdrop)
                back:SetBackdropBorderColor(0, 0, 0, 0.9)
                b.bg = back
            
                b.styled = true
            end
            
            function UpdateTimer(self, elapsed)
                total = total + elapsed
                if CastingBarFrame.Icon then
                    IconSkin(CastingBarFrame.Icon)
                end
                if TargetFrameSpellBar.Icon then
                    IconSkin(TargetFrameSpellBar.Icon)
                end
                if FocusFrameSpellBar.Icon then
                    IconSkin(FocusFrameSpellBar.Icon)
                end
                if CastingBarFrame.Icon.styled and TargetFrameSpellBar.Icon.styled then
                    cf:SetScript("OnUpdate", nil)
                end
            end
            
            total = 0
            cf = CreateFrame("Frame")
            cf:SetScript("OnUpdate", UpdateTimer)
        end
    end
end