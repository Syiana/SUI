local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
    if (SUI:Color()) then
        MailFrame:HookScript("OnShow", function()
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
            SUI:Skin(OpenMailFrame)
            SUI:Skin(OpenMailFrameInset)
            SUI:Skin(SendMailNameEditBox)
            SUI:Skin(SendMailSubjectEditBox)
            SUI:Skin(SendMailMoneyGold)
            SUI:Skin(SendMailMoneySilver)
            SUI:Skin(SendMailMoneyCopper)

            -- Buttons
            SUI:Skin({
                OpenAllMail.Left,
                OpenAllMail.Middle,
                OpenAllMail.Right,
                SendMailMailButton.Left,
                SendMailMailButton.Middle,
                SendMailMailButton.Right,
                SendMailCancelButton.Left,
                SendMailCancelButton.Middle,
                SendMailCancelButton.Right
            }, false, true, false, true)
        end)
    end
end
