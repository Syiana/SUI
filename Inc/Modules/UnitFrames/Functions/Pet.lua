local ADDON, SUI = ...
SUI.MODULES.UNITFRAMES.Pet = function(state) 
    if (state) then
            --TEXTURES
            PetFrameHealthBar:SetStatusBarTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-StatusBar");
            PetFrameManaBar:SetStatusBarTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-StatusBar");
        
        PetFrameHealthBar:ClearAllPoints()
        PetFrameHealthBar:SetPoint("TOPLEFT", 45, -22)
        PetFrameHealthBar:SetHeight(10)
        PetFrameManaBar:ClearAllPoints()
        PetFrameManaBar:SetPoint("TOPLEFT", 45, -32)
        PetFrameManaBar:SetHeight(5)
    end
end