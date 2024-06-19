local Skin = SUI:NewModule("Skins.Safequeue");

function Skin:OnEnable()
    if not (IsAddOnLoaded("SafeQueue")) then return end
    SUI:Skin(SafeQueue)
    SUI:Skin(SafeQueueEnterButton)
    SUI:Skin(SafeQueueCloseButton)
end