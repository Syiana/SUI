local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MailFrame, true)
        SUI:Skin(MailFrame.NineSlice, true)
        SUI:Skin(OpenMailFrame, true)
        SUI:Skin(OpenMailFrame.NineSlice, true)
        SUI:Skin(MailFrameInset, true)
        SUI:Skin(MailFrameInset.NineSlice, true)
        SUI:Skin(OpenMailFrameInset, true)
        SUI:Skin(OpenMailFrameInset.NineSlice, true)
        SUI:Skin(SendMailMoneyInset, true)
        SUI:Skin(SendMailMoneyInset.NineSlice, true)
        SUI:Skin(SendMailMoneyBg, true)
        SUI:Skin(SendMailFrame, true)

        -- Tabs
        SUI:Skin(MailFrameTab1, true)
        SUI:Skin(MailFrameTab2, true)
    end
end
