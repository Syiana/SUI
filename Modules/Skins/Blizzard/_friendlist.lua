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
  end
end