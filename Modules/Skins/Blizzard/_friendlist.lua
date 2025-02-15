local Module = SUI:NewModule("Skins.Friendlist");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(AddFriendEntryFrame, true)
        SUI:Skin(AddFriendFrame.Border, true)
        SUI:Skin(FriendsFrame, true)
        SUI:Skin(FriendsFrame.NineSlice, true)
        SUI:Skin(FriendsFrameInset, true)
        SUI:Skin(FriendsFrameInset.NineSlice, true)
        SUI:Skin(FriendsFriendsFrame, true)
        SUI:Skin(FriendsFriendsFrame.Border, true)
        SUI:Skin(RecruitAFriendFrame, true)
        SUI:Skin(RecruitAFriendFrame.RecruitList, true)
        SUI:Skin(RecruitAFriendFrame.RecruitList.Header, true)
        SUI:Skin(RecruitAFriendFrame.RecruitList.ScrollFrameInset, true)
        SUI:Skin(RecruitAFriendFrame.RecruitList.ScrollFrameInset.NineSlice, true)
        SUI:Skin(RecruitAFriendFrame.RewardClaiming, true)
        SUI:Skin(RecruitAFriendFrame.RewardClaiming.Inset, true)
        SUI:Skin(RecruitAFriendFrame.RewardClaiming.Inset.NineSlice, true)
        SUI:Skin(RecruitAFriendRecruitmentFrame, true)
        SUI:Skin(RecruitAFriendRecruitmentFrame.Border, true)
        SUI:Skin(WhoFrameListInset, true)
        SUI:Skin(WhoFrameListInset.NineSlice, true)
        SUI:Skin(WhoFrameEditBoxInset, true)
        SUI:Skin(WhoFrameEditBoxInset.NineSlice, true)
        SUI:Skin(FriendsFrameBattlenetFrame.BroadcastFrame, true)
        SUI:Skin(FriendsFrameBattlenetFrame.BroadcastFrame.Border, true)

        -- Tabs
        SUI:Skin(FriendsTabHeaderTab1, true)
        SUI:Skin(FriendsTabHeaderTab2, true)
        SUI:Skin(FriendsTabHeaderTab3, true)
        SUI:Skin(FriendsFrameTab1, true)
        SUI:Skin(FriendsFrameTab2, true)
        SUI:Skin(FriendsFrameTab3, true)
        SUI:Skin(FriendsFrameTab4, true)
    end
end
