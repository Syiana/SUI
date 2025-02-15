local Module = SUI:NewModule("Skins.Communities");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(CommunitiesFrame)
        SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame)
        SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame.Border)
        SUI:Skin(CommunitiesFrame.ChatEditBox)
        SUI:Skin(CommunitiesFrame.Chat.InsetFrame)
        SUI:Skin(CommunitiesFrame.Chat.InsetFrame.NineSlice)
        SUI:Skin(CommunitiesFrame.MemberList.InsetFrame)
        SUI:Skin(CommunitiesFrame.MemberList.InsetFrame.NineSlice)
        SUI:Skin(CommunitiesFrame.NineSlice)
        SUI:Skin(CommunitiesFrame.MemberList.ColumnDisplay)
        SUI:Skin(CommunitiesFrameInset)
        SUI:Skin(CommunitiesFrameInset.NineSlice)
        SUI:Skin(CommunitiesFrameCommunitiesList)
        SUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame)
        SUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame.NineSlice)
        SUI:Skin(ClubFinderGuildFinderFrame.InsetFrame)
        SUI:Skin(ClubFinderGuildFinderFrame.InsetFrame.NineSlice)
        SUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame)
        SUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame.NineSlice)
        SUI:Skin({
            CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
            CommunitiesFrameCommunitiesListListScrollFrameTop,
            CommunitiesFrameCommunitiesListListScrollFrameMiddle,
            CommunitiesFrameCommunitiesListListScrollFrameBottom
        }, false, true)
    end
end
