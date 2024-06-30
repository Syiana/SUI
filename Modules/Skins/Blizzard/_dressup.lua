local Module = SUI:NewModule("Skins.Dressup");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(DressUpFrame)
        SUI:Skin(DressUpFrameResetButton)
        SUI:Skin(DressUpFrameCancelButton)

        -- Buttons
        SUI:Skin({
            DressUpFrameResetButton.Left,
            DressUpFrameResetButton.Middle,
            DressUpFrameResetButton.Right,
            DressUpFrameCancelButton.Left,
            DressUpFrameCancelButton.Middle,
            DressUpFrameCancelButton.Right
        }, false, true, false, true)
    end
end
