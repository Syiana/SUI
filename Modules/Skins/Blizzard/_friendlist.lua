local Module = SUI:NewModule("Skins.Friendlist");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(FriendsFrame)
        SUI:Skin(FriendsFrameInset)
        SUI:Skin(AddFriendFrame)
        SUI:Skin(WhoFrameEditBoxInset)
        SUI:Skin(WhoListScrollFrame)
        SUI:Skin(WhoListScrollFrame)
        SUI:Skin(WhoFrameListInset)
        SUI:Skin(WhoFrameColumnHeader1)
        SUI:Skin(WhoFrameColumnHeader2)
        SUI:Skin(WhoFrameColumnHeader3)
        SUI:Skin(WhoFrameColumnHeader4)
        SUI:Skin(WhoFrameDropDown)
        SUI:Skin(FriendsFrameFriendsScrollFrame)
        SUI:Skin(FriendsFrameTab1)
        SUI:Skin(FriendsFrameTab2)
        SUI:Skin(FriendsFrameTab3)
        SUI:Skin(FriendsTabHeaderTab1)
        SUI:Skin(FriendsTabHeaderTab2)
        SUI:Skin(FriendsFrameStatusDropDown)
        SUI:Skin(FriendsFrameBattlenetFrame.BroadcastFrame)
        SUI:Skin(RaidInfoFrame)
        SUI:Skin(RaidInfoInstanceLabel)
        SUI:Skin(RaidInfoIDLabel)
        SUI:Skin(RaidGroup1)
        SUI:Skin(RaidGroup2)
        SUI:Skin(RaidGroup3)
        SUI:Skin(RaidGroup4)
        SUI:Skin(RaidGroup5)
        SUI:Skin(RaidGroup6)
        SUI:Skin(RaidGroup7)
        SUI:Skin(RaidGroup8)

        -- Raid Class Buttons
        SUI:Skin(RaidClassButton1)
        SUI:Skin(RaidClassButton2)
        SUI:Skin(RaidClassButton3)
        SUI:Skin(RaidClassButton4)
        SUI:Skin(RaidClassButton5)
        SUI:Skin(RaidClassButton6)
        SUI:Skin(RaidClassButton7)
        SUI:Skin(RaidClassButton8)
        SUI:Skin(RaidClassButton9)
        SUI:Skin(RaidClassButton10)
        SUI:Skin(RaidClassButton11)
        SUI:Skin(RaidClassButton12)
        SUI:Skin(RaidClassButton13)

        -- Reset Raid Class Button Icon Color
        if (RaidClassButton1) then
            select(2, RaidClassButton1:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton2:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton3:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton4:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton5:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton6:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton7:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton8:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton9:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton10:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton11:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton12:GetRegions()):SetVertexColor(1,1,1)
            select(2, RaidClassButton13:GetRegions()):SetVertexColor(1,1,1)
        end
        
        -- Buttons
        SUI:Skin({
            FriendsFrameAddFriendButton.Left,
            FriendsFrameAddFriendButton.Middle,
            FriendsFrameAddFriendButton.Right,
            FriendsFrameSendMessageButton.Left,
            FriendsFrameSendMessageButton.Middle,
            FriendsFrameSendMessageButton.Right,
            FriendsFrameIgnorePlayerButton.Left,
            FriendsFrameIgnorePlayerButton.Middle,
            FriendsFrameIgnorePlayerButton.Right,
            FriendsFrameUnsquelchButton.Left,
            FriendsFrameUnsquelchButton.Middle,
            FriendsFrameUnsquelchButton.Right,
            FriendsFrameBattlenetFrameScrollFrame.UpdateButton.Left,
            FriendsFrameBattlenetFrameScrollFrame.UpdateButton.Middle,
            FriendsFrameBattlenetFrameScrollFrame.UpdateButton.Right,
            FriendsFrameBattlenetFrameScrollFrame.CancelButton.Left,
            FriendsFrameBattlenetFrameScrollFrame.CancelButton.Middle,
            FriendsFrameBattlenetFrameScrollFrame.CancelButton.Right,
            WhoFrameWhoButton.Left,
            WhoFrameWhoButton.Middle,
            WhoFrameWhoButton.Right,
            WhoFrameAddFriendButton.Left,
            WhoFrameAddFriendButton.Middle,
            WhoFrameAddFriendButton.Right,
            WhoFrameGroupInviteButton.Left,
            WhoFrameGroupInviteButton.Middle,
            WhoFrameGroupInviteButton.Right,
            RaidFrameRaidInfoButton.Left,
            RaidFrameRaidInfoButton.Middle,
            RaidFrameRaidInfoButton.Right,
            RaidInfoCancelButton.Left,
            RaidInfoCancelButton.Middle,
            RaidInfoCancelButton.Right,
            RaidFrameConvertToRaidButton.Left,
            RaidFrameConvertToRaidButton.Middle,
            RaidFrameConvertToRaidButton.Right,
            AddFriendEntryFrameAcceptButton.Left,
            AddFriendEntryFrameAcceptButton.Middle,
            AddFriendEntryFrameAcceptButton.Right,
            AddFriendEntryFrameCancelButton.Left,
            AddFriendEntryFrameCancelButton.Middle,
            AddFriendEntryFrameCancelButton.Right
        }, false, true, false, true)

        if (RaidFrameReadyCheckButton) then
            SUI:Skin({
                RaidFrameReadyCheckButton.Left,
                RaidFrameReadyCheckButton.Middle,
                RaidFrameReadyCheckButton.Right
            }, false, true, false, true)
        end

        local raid = CreateFrame("Frame")
        raid:RegisterEvent("ADDON_LOADED")
        raid:HookScript("OnEvent", function(self, event, name)
            if name == 'Blizzard_RaidUI' then
                SUI:Skin({
                    RaidFrameReadyCheckButton.Left,
                    RaidFrameReadyCheckButton.Middle,
                    RaidFrameReadyCheckButton.Right,
                }, false, true, false, true)

                SUI:Skin(RaidGroup1)
                SUI:Skin(RaidGroup2)
                SUI:Skin(RaidGroup3)
                SUI:Skin(RaidGroup4)
                SUI:Skin(RaidGroup5)
                SUI:Skin(RaidGroup6)
                SUI:Skin(RaidGroup7)
                SUI:Skin(RaidGroup8)

                -- Raid Class Buttons
                SUI:Skin(RaidClassButton1)
                SUI:Skin(RaidClassButton2)
                SUI:Skin(RaidClassButton3)
                SUI:Skin(RaidClassButton4)
                SUI:Skin(RaidClassButton5)
                SUI:Skin(RaidClassButton6)
                SUI:Skin(RaidClassButton7)
                SUI:Skin(RaidClassButton8)
                SUI:Skin(RaidClassButton9)
                SUI:Skin(RaidClassButton10)
                SUI:Skin(RaidClassButton11)
                SUI:Skin(RaidClassButton12)
                SUI:Skin(RaidClassButton13)

                -- Reset Raid Class Button Icon Color
                select(2, RaidClassButton1:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton2:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton3:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton4:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton5:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton6:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton7:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton8:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton9:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton10:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton11:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton12:GetRegions()):SetVertexColor(1,1,1)
                select(2, RaidClassButton13:GetRegions()):SetVertexColor(1,1,1)
            end
        end)
    end
end
