local Skin = SUI:NewModule("Skins.Safequeue");

function Skin:OnEnable()
    if not (IsAddOnLoaded("SafeQueue")) then return end
    SUI:Skin(SafeQueue)

    -- Buttons
    SUI:Skin({
        SafeQueueEnterButton.Left,
        SafeQueueEnterButton.Middle,
        SafeQueueEnterButton.Right,
        select(2, SafeQueueCloseButton:GetRegions())
    }, false, true, false, true)
end