local Module = SUI:NewModule("Chat.Quickjoin");

function Module:OnEnable()
    local db = SUI.db.profile.chat.quickjoin
    if (db) then
        QuickJoinToastButton:Show()
        QuickJoinToastButton.Show = function()
            QuickJoinToastButton:SetPoint("TOPLEFT", ChatFrame1, "TOPLEFT", 50, 40)
        end
    else
        QuickJoinToastButton:Hide()
        QuickJoinToastButton.Show = function()
        end
    end
end
