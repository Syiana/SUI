local Module = SUI:NewModule("Chat.Quickjoin");

function Module:OnEnable()
    local db = {
        quickjoin = SUI.db.profile.chat.quickjoin,
        module = SUI.db.profile.modules.chat
    }

    if ((not db.quickjoin) and db.module)then
        FriendsMicroButton:Hide()
        FriendsMicroButton.Show = function()
        end
    else
        FriendsMicroButton:Show()
        FriendsMicroButton.Show = function()
        end
    end
end
