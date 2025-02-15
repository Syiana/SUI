local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MailFrame)
        SUI:Skin(MailFrame.NineSlice)
        SUI:Skin(OpenMailFrame)
        SUI:Skin(OpenMailFrame.NineSlice)
        SUI:Skin(MailFrameInset)
        SUI:Skin(MailFrameInset.NineSlice)
        SUI:Skin(OpenMailFrameInset)
        SUI:Skin(OpenMailFrameInset.NineSlice)
        SUI:Skin(SendMailMoneyInset)
        SUI:Skin(SendMailMoneyInset.NineSlice)
        SUI:Skin(SendMailMoneyBg)
        SUI:Skin(SendMailFrame)

        -- Tabs
        SUI:Skin(MailFrameTab1)
        SUI:Skin(MailFrameTab2)
    end
end
