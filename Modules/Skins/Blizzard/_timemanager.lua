local Module = SUI:NewModule("Skins.TimeManager");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TimeManagerFrame)
        SUI:Skin(TimeManagerFrameInset)
        SUI:Skin(TimeManagerAlarmHourDropDown)
        SUI:Skin(TimeManagerAlarmMinuteDropDown)
        SUI:Skin(TimeManagerAlarmAMPMDropDown)
    end
end
