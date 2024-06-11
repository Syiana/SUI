local Module = SUI:NewModule("Skins.Friendlist");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(FriendsFrame)
        SUI:Skin(FriendsFrameInset)
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
        SUI:Skin(FriendsFrameAddFriendButton)
        SUI:Skin(FriendsFrameSendMessageButton)
        SUI:Skin(FriendsFrameIgnorePlayerButton)
        SUI:Skin(FriendsFrameUnsquelchButton)
        SUI:Skin(FriendsFrameTab1)
        SUI:Skin(FriendsFrameTab2)
        SUI:Skin(FriendsFrameTab3)
        SUI:Skin(FriendsTabHeaderTab1)
        SUI:Skin(FriendsTabHeaderTab2)
    end
end
