local Module = SUI:NewModule("Skins.Communities");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Communities" then
                SUI:Skin(CommunitiesFrame)
                SUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame)
                SUI:Skin(CommunitiesFrameInset)
                SUI:Skin(CommunitiesFrame.ChatEditBox)
                SUI:Skin(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)
                SUI:Skin(CommunitiesFrame.InviteButton)
                SUI:Skin(CommunitiesFrame.MemberList.InsetFrame)
                SUI:Skin(CommunitiesFrame.MemberList.ColumnDisplay)
                SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame)
                SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame.Border)
                SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame.RemoveButton)
                SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame.GroupInviteButton)
                SUI:Skin(CommunitiesFrameCommunitiesList.FilligreeOverlay)
                SUI:Skin(CommunitiesFrame.Chat.InsetFrame)
                SUI:Skin(CommunitiesFrame.GuildLogButton)
                SUI:Skin(CommunitiesFrame.StreamDropDownMenu)
                SUI:Skin(CommunitiesFrame.CommunitiesListDropDownMenu)
                SUI:Skin(CommunitiesGuildLogFrame)
                SUI:Skin(CommunitiesGuildLogFrame.Container.NineSlice)
                SUI:Skin(CommunitiesGuildLogFrame.Container.ScrollFrame.ScrollBar.Background)
                SUI:Skin(CommunitiesTicketManagerDialog)
                SUI:Skin(CommunitiesTicketManagerDialog.InviteManager.ArtOverlay)
                SUI:Skin(CommunitiesTicketManagerDialog.InviteManager.ColumnDisplay)
                SUI:Skin(CommunitiesSettingsDialog.BG)
                SUI:Skin(CommunitiesAvatarPickerDialog.Selector)


                -- Reset Icon colors
                select(1, CommunitiesFrame.ChatTab:GetRegions()):SetVertexColor(.15, .15, .15)
                select(1, CommunitiesFrame.RosterTab:GetRegions()):SetVertexColor(.15, .15, .15)
                select(1, CommunitiesFrame.GuildBenefitsTab:GetRegions()):SetVertexColor(.15, .15, .15)
                select(1, CommunitiesFrame.GuildInfoTab:GetRegions()):SetVertexColor(.15, .15, .15)

                -- Buttons
                SUI:Skin({
                    CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton.Left,
                    CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton.Middle,
                    CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton.Right,
                    CommunitiesFrame.InviteButton.Left,
                    CommunitiesFrame.InviteButton.Middle,
                    CommunitiesFrame.InviteButton.Right,
                    CommunitiesFrame.GuildMemberDetailFrame.RemoveButton.Left,
                    CommunitiesFrame.GuildMemberDetailFrame.RemoveButton.Middle,
                    CommunitiesFrame.GuildMemberDetailFrame.RemoveButton.Right,
                    CommunitiesFrame.GuildMemberDetailFrame.GroupInviteButton.Left,
                    CommunitiesFrame.GuildMemberDetailFrame.GroupInviteButton.Middle,
                    CommunitiesFrame.GuildMemberDetailFrame.GroupInviteButton.Right,
                    CommunitiesFrame.GuildLogButton.Left,
                    CommunitiesFrame.GuildLogButton.Middle,
                    CommunitiesFrame.GuildLogButton.Right,
                    CommunitiesGuildLogFrameCloseButton.Left,
                    CommunitiesGuildLogFrameCloseButton.Middle,
                    CommunitiesGuildLogFrameCloseButton.Right,
                    CommunitiesTicketManagerDialog.GenerateLinkButton.Left,
                    CommunitiesTicketManagerDialog.GenerateLinkButton.Middle,
                    CommunitiesTicketManagerDialog.GenerateLinkButton.Right,
                    CommunitiesTicketManagerDialog.Close.Left,
                    CommunitiesTicketManagerDialog.Close.Middle,
                    CommunitiesTicketManagerDialog.Close.Right,
                    CommunitiesTicketManagerDialog.LinkToChat.Left,
                    CommunitiesTicketManagerDialog.LinkToChat.Middle,
                    CommunitiesTicketManagerDialog.LinkToChat.Right,
                    CommunitiesTicketManagerDialog.Copy.Left,
                    CommunitiesTicketManagerDialog.Copy.Middle,
                    CommunitiesTicketManagerDialog.Copy.Right,
                    CommunitiesSettingsDialog.ChangeAvatarButton.Left,
                    CommunitiesSettingsDialog.ChangeAvatarButton.Middle,
                    CommunitiesSettingsDialog.ChangeAvatarButton.Right,
                    CommunitiesSettingsDialog.Accept.Left,
                    CommunitiesSettingsDialog.Accept.Middle,
                    CommunitiesSettingsDialog.Accept.Right,
                    CommunitiesSettingsDialog.Delete.Left,
                    CommunitiesSettingsDialog.Delete.Middle,
                    CommunitiesSettingsDialog.Delete.Right,
                    CommunitiesSettingsDialog.Cancel.Left,
                    CommunitiesSettingsDialog.Cancel.Middle,
                    CommunitiesSettingsDialog.Cancel.Right,
                    CommunitiesAvatarPickerDialog.Selector.OkayButton.Left,
                    CommunitiesAvatarPickerDialog.Selector.OkayButton.Middle,
                    CommunitiesAvatarPickerDialog.Selector.OkayButton.Right,
                    CommunitiesAvatarPickerDialog.Selector.CancelButton.Left,
                    CommunitiesAvatarPickerDialog.Selector.CancelButton.Middle,
                    CommunitiesAvatarPickerDialog.Selector.CancelButton.Right,
                    CommunitiesFrame.CommunitiesControlFrame.GuildControlButton.Left,
                    CommunitiesFrame.CommunitiesControlFrame.GuildControlButton.Middle,
                    CommunitiesFrame.CommunitiesControlFrame.GuildControlButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
