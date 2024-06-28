local Module = SUI:NewModule("CastBars.Focus");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.castbars.style,
        texture = SUI.db.profile.general.texture
    }
    if (db.style == 'Custom') then
        if not InCombatLockdown() then
            if (db.texture ~= 'Default') then
                FocusFrameSpellBar:SetStatusBarTexture(db.texture)
            else
                FocusFrameSpellBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\Unitframes\\UI-StatusBar")
            end
            
        end
    end

    FocusFrameSpellBar:HookScript("OnEvent", function(self, event)
        if self.unit == "focus" then
            local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo(self.unit)
            local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo(self.unit)
    
            if (notInterruptibleCast) then
                FocusFrameSpellBar:SetStatusBarColor(.7, .7, .7)
            elseif (notInterruptibleChannel) then
                FocusFrameSpellBar:SetStatusBarColor(.7, .7, .7)
            else
                local color
                local isChannel = UnitChannelInfo(self.unit);
    
                if (isChannel) then
                    color = FocusFrameSpellBar.startChannelColor
                else
                    color = FocusFrameSpellBar.startCastColor
                end
    
                FocusFrameSpellBar:SetStatusBarColor(color.r, color.g, color.b)
            end
        end
    end)

    -- Color
    if (SUI:Color()) then
        FocusFrameSpellBar.Border:SetVertexColor(unpack(SUI:Color(0.15)))
    end
    
    FocusFrameSpellBar.Border:SetDrawLayer("OVERLAY", 1)
    FocusFrameSpellBar:SetWidth(FocusFrameSpellBar:GetWidth()-0.5)
    FocusFrameSpellBar:SetHeight(FocusFrameSpellBar:GetHeight()+0.1)
end
