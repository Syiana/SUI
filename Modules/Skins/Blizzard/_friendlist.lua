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
        
        -- Handle Who Frame elements (may not exist in current version)
        local whoFrameListInset = _G["WhoFrameListInset"]
        if whoFrameListInset then
            SUI:Skin(whoFrameListInset, true)
            if whoFrameListInset.NineSlice then
                SUI:Skin(whoFrameListInset.NineSlice, true)
            end
        end
        
        local whoFrameEditBoxInset = _G["WhoFrameEditBoxInset"]
        if whoFrameEditBoxInset then
            SUI:Skin(whoFrameEditBoxInset, true)
            if whoFrameEditBoxInset.NineSlice then
                SUI:Skin(whoFrameEditBoxInset.NineSlice, true)
            end
        end
        
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
