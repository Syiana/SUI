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

    FocusFrameSpellBar:HookScript("OnEvent", function(self)
        local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo(self.unit)
        local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo(self.unit)

        if (notInterruptibleCast) then
            self:SetStatusBarColor(.7, .7, .7)
        elseif (notInterruptibleChannel) then
            self:SetStatusBarColor(.7, .7, .7)
        else
            local color
            local isChannel = UnitChannelInfo("player");

            if (isChannel) then
                color = self.startChannelColor
            else
                color = self.startCastColor
            end

            self:SetStatusBarColor(color.r, color.g, color.b)
        end
    end)

    -- Color
    FocusFrameSpellBar.Border:SetVertexColor(unpack(SUI:Color(0.15)))
    FocusFrameSpellBar.Border:SetDrawLayer("OVERLAY", 1)
    FocusFrameSpellBar:SetWidth(FocusFrameSpellBar:GetWidth()-0.5)
    FocusFrameSpellBar:SetHeight(FocusFrameSpellBar:GetHeight()+0.1)
end
