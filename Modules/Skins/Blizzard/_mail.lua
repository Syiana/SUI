local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MailFrame)
        SUI:Skin(MailFrameInset)
        SUI:Skin(OpenAllMail)
        SUI:Skin(MailFrameTab1)
        SUI:Skin(MailFrameTab2)
        SUI:Skin(SendMailFrame)
        SUI:Skin(SendMailMailButton)
        SUI:Skin(SendMailCancelButton)
        SUI:Skin(MailEditBoxScrollBar.Background)
        SUI:Skin(SendMailMoneyInset)
        SUI:Skin(SendMailMoneyBg)
    end
end
