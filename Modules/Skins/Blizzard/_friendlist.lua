local Module = SUI:NewModule("Skins.Friendlist");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(AddFriendEntryFrame)
        SUI:Skin(AddFriendFrame.Border)
        SUI:Skin(FriendsFrame)
        SUI:Skin(FriendsFrame.NineSlice)
        SUI:Skin(FriendsFrameInset)
        SUI:Skin(FriendsFrameInset.NineSlice)
        SUI:Skin(FriendsFriendsFrame)
        SUI:Skin(FriendsFriendsFrame.Border)
        SUI:Skin(RecruitAFriendFrame)
        SUI:Skin(RecruitAFriendFrame.RecruitList)
        SUI:Skin(RecruitAFriendFrame.RecruitList.Header)
        SUI:Skin(RecruitAFriendFrame.RecruitList.ScrollFrameInset)
        SUI:Skin(RecruitAFriendFrame.RecruitList.ScrollFrameInset.NineSlice)
        SUI:Skin(RecruitAFriendFrame.RewardClaiming)
        SUI:Skin(RecruitAFriendFrame.RewardClaiming.Inset)
        SUI:Skin(RecruitAFriendFrame.RewardClaiming.Inset.NineSlice)
        SUI:Skin(RecruitAFriendRecruitmentFrame)
        SUI:Skin(RecruitAFriendRecruitmentFrame.Border)
        SUI:Skin(WhoFrameListInset)
        SUI:Skin(WhoFrameListInset.NineSlice)
        SUI:Skin(WhoFrameEditBoxInset)
        SUI:Skin(WhoFrameEditBoxInset.NineSlice)

        -- Tabs
        SUI:Skin(FriendsTabHeaderTab1)
        SUI:Skin(FriendsTabHeaderTab2)
        SUI:Skin(FriendsTabHeaderTab3)
        SUI:Skin(FriendsFrameTab1)
        SUI:Skin(FriendsFrameTab2)
        SUI:Skin(FriendsFrameTab3)
        SUI:Skin(FriendsFrameTab4)
    end
end
