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
                    CommunitiesGuildLogFrameCloseButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
