local Module = SUI:NewModule("UnitFrames.Pet");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes
    if (db) then
        PetFrameHealthBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-StatusBar");
        PetFrameManaBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-StatusBar");
        PetFrameHealthBar:ClearAllPoints()
        PetFrameHealthBar:SetPoint("TOPLEFT", 45, -22)
        PetFrameHealthBar:SetHeight(10)
        PetFrameManaBar:ClearAllPoints()
        PetFrameManaBar:SetPoint("TOPLEFT", 45, -32)
        PetFrameManaBar:SetHeight(5)
    end
end