local Module = SUI:NewModule("Skins.Communities");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(CommunitiesFrame, true)
        SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame, true)
        SUI:Skin(CommunitiesFrame.GuildMemberDetailFrame.Border, true)
        SUI:Skin(CommunitiesFrame.ChatEditBox, true)
        SUI:Skin(CommunitiesFrame.Chat.InsetFrame, true)
        SUI:Skin(CommunitiesFrame.Chat.InsetFrame.NineSlice, true)
        SUI:Skin(CommunitiesFrame.MemberList.InsetFrame, true)
        SUI:Skin(CommunitiesFrame.MemberList.InsetFrame.NineSlice, true)
        SUI:Skin(CommunitiesFrame.NineSlice, true)
        SUI:Skin(CommunitiesFrame.MemberList.ColumnDisplay, true)
        SUI:Skin(CommunitiesFrameInset, true)
        SUI:Skin(CommunitiesFrameInset.NineSlice, true)
        SUI:Skin(CommunitiesFrameCommunitiesList, true)
        SUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame, true)
        SUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame.NineSlice, true)
        SUI:Skin(CommunitiesFrameGuildDetailsFrame, true)
        SUI:Skin(CommunitiesFrame.GuildBenefitsFrame, true)
        SUI:Skin(ClubFinderGuildFinderFrame.InsetFrame, true)
        SUI:Skin(ClubFinderGuildFinderFrame.InsetFrame.NineSlice, true)
        SUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame, true)
        SUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame.NineSlice, true)
        SUI:Skin({
            CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
            CommunitiesFrameCommunitiesListListScrollFrameTop,
            CommunitiesFrameCommunitiesListListScrollFrameMiddle,
            CommunitiesFrameCommunitiesListListScrollFrameBottom
        }, true, true)
    end
end
