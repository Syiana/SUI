local Module = SUI:NewModule("Chat.Quickjoin");

local originalQuickJoinShow

function Module:OnEnable()
    local mouseoverOnly = SUI.db.profile.chat.quickjoin
    local idleAlpha = mouseoverOnly and 0 or 1

    if not QuickJoinToastButton then
        return
    end

    if not originalQuickJoinShow then
        originalQuickJoinShow = QuickJoinToastButton.Show
    end

    QuickJoinToastButton.Show = function(self, ...)
        originalQuickJoinShow(self, ...)
        self:SetAlpha(idleAlpha)
    end

    if not QuickJoinToastButton.suiQuickJoinHoverHooked then
        QuickJoinToastButton:HookScript("OnEnter", function(self)
            self:SetAlpha(1)
        end)

        QuickJoinToastButton:HookScript("OnLeave", function(self)
            self:SetAlpha(SUI.db.profile.chat.quickjoin and 0 or 1)
        end)

        QuickJoinToastButton:HookScript("OnShow", function(self)
            self:SetAlpha(SUI.db.profile.chat.quickjoin and 0 or 1)
        end)

        QuickJoinToastButton.suiQuickJoinHoverHooked = true
    end

    QuickJoinToastButton:Show()
    QuickJoinToastButton:SetAlpha(idleAlpha)
end
