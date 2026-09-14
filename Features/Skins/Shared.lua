--[[
    SUI 2.0 - Features/Skins/Shared.lua

    Blizzard frames whose names are the same on Retail and the classic
    clients. Missing frames are ignored, so a group may list names that only
    some clients have. Groups limited to some clients carry `clients`.
]]

local _, ns = ...

local MainlineMists = { Mainline = true, Mists = true }

local groups = {
    -- Game menu, popups and dialogs
    {
        "GameMenuFrame", "GameMenuFrame.Header", "GameMenuFrame.Border",
        "StaticPopup1", "StaticPopup1.Border", "StaticPopup2", "StaticPopup2.Border",
        "StaticPopup3", "StaticPopup3.Border",
        "EditModeManagerFrame", "EditModeManagerFrame.Border",
        "VehicleSeatIndicator", "ReportFrame", "ReportFrame.Border",
        "LFGDungeonReadyStatus.Border", "LFGDungeonReadyDialog", "LFGDungeonReadyDialog.Border",
        "LFGListInviteDialog", "LFGListInviteDialog.Border",
    },
    -- Battleground/arena countdown bars are created on demand
    {
        run = function(Skin, S, feature)
            S.HookScript(feature, TimerTracker, "OnEvent", function(tracker)
                local list = tracker.timerList
                for i = 1, list and #list or 0 do
                    Skin:Texture(_G["TimerTrackerTimer" .. i .. "StatusBarBorder"], true)
                end
            end)
        end,
    },
    -- Character slots
    {
        "CharacterHeadSlotFrame", "CharacterNeckSlotFrame", "CharacterShoulderSlotFrame",
        "CharacterBackSlotFrame", "CharacterChestSlotFrame", "CharacterShirtSlotFrame",
        "CharacterTabardSlotFrame", "CharacterWristSlotFrame", "CharacterHandsSlotFrame",
        "CharacterWaistSlotFrame", "CharacterLegsSlotFrame", "CharacterFeetSlotFrame",
        "CharacterFinger0SlotFrame", "CharacterFinger1SlotFrame",
        "CharacterTrinket0SlotFrame", "CharacterTrinket1SlotFrame",
        "CharacterMainHandSlotFrame", "CharacterSecondaryHandSlotFrame",
        "CharacterMainHandSlot#-1", "CharacterSecondaryHandSlot#-1",
        "PaperDollInnerBorderLeft", "PaperDollInnerBorderRight", "PaperDollInnerBorderTop",
        "PaperDollInnerBorderTopLeft", "PaperDollInnerBorderTopRight", "PaperDollInnerBorderBottom",
        "PaperDollInnerBorderBottomLeft", "PaperDollInnerBorderBottomRight", "PaperDollInnerBorderBottom2",
    },
    -- Bank
    { "BankFrame", "BankFrame.NineSlice", "BankSlotsFrame.NineSlice", "BankFrameMoneyFrameBorder" },
    -- Dress up
    { "DressUpFrame", "DressUpFrame.NineSlice", "DressUpFrame.OutfitDetailsPanel", "DressUpFrameInset", "DressUpFrameInset.NineSlice" },
    -- Friends
    {
        "AddFriendEntryFrame", "AddFriendFrame.Border",
        "FriendsFrame", "FriendsFrame.NineSlice", "FriendsFrameInset", "FriendsFrameInset.NineSlice",
        "FriendsFriendsFrame", "FriendsFriendsFrame.Border",
        "RecruitAFriendFrame", "RecruitAFriendFrame.RecruitList", "RecruitAFriendFrame.RecruitList.Header",
        "RecruitAFriendFrame.RecruitList.ScrollFrameInset", "RecruitAFriendFrame.RecruitList.ScrollFrameInset.NineSlice",
        "RecruitAFriendFrame.RewardClaiming", "RecruitAFriendFrame.RewardClaiming.Inset",
        "RecruitAFriendFrame.RewardClaiming.Inset.NineSlice",
        "RecruitAFriendRecruitmentFrame", "RecruitAFriendRecruitmentFrame.Border",
        "WhoFrameListInset", "WhoFrameListInset.NineSlice", "WhoFrameEditBoxInset", "WhoFrameEditBoxInset.NineSlice",
        "FriendsFrameBattlenetFrame.BroadcastFrame", "FriendsFrameBattlenetFrame.BroadcastFrame.Border",
        "FriendsTabHeaderTab1", "FriendsTabHeaderTab2", "FriendsTabHeaderTab3",
        "FriendsFrameTab1", "FriendsFrameTab2", "FriendsFrameTab3", "FriendsFrameTab4",
    },
    -- Gossip, books, petitions, guild registrar, tabard
    {
        "GossipFrame", "GossipFrame.NineSlice", "GossipFrameInset", "GossipFrameInset.NineSlice",
        "ItemTextFrame", "ItemTextFrame.NineSlice",
        "PetitionFrame", "PetitionFrame.NineSlice", "PetitionFrameInset",
        "GuildRegistrarFrame", "GuildRegistrarFrame.NineSlice", "TabardFrame", "TabardFrame.NineSlice",
    },
    -- Loot
    { "LootFrame", "LootFrame.NineSlice" },
    -- Mail
    {
        "MailFrame", "MailFrame.NineSlice", "MailFrameInset", "MailFrameInset.NineSlice",
        "OpenMailFrame", "OpenMailFrame.NineSlice", "OpenMailFrameInset", "OpenMailFrameInset.NineSlice",
        "SendMailFrame", "SendMailMoneyInset", "SendMailMoneyInset.NineSlice", "SendMailMoneyBg",
        "MailFrameTab1", "MailFrameTab2",
    },
    -- Merchant
    {
        "MerchantFrame", "MerchantFrame.NineSlice", "MerchantFrameInset", "MerchantFrameInset.NineSlice",
        "StackSplitFrame", "MerchantMoneyBg", "MerchantMoneyInset", "MerchantMoneyInset.NineSlice",
        "MerchantBuyBackItemSlotTexture", "MerchantFrameTab1", "MerchantFrameTab2",
    },
    -- Quest dialog
    {
        "QuestFrame", "QuestFrame.NineSlice", "QuestFrameInset", "QuestFrameInset.NineSlice",
        "QuestNPCModelTopBorder", "QuestNPCModelRightBorder", "QuestNPCModelTopRightCorner",
        "QuestNPCModelBottomRightCorner", "QuestNPCModelBottomBorder", "QuestNPCModelBottomLeftCorner",
        "QuestNPCModelLeftBorder", "QuestNPCModelTopLeftCorner",
        "QuestNPCModelTextTopBorder", "QuestNPCModelTextRightBorder", "QuestNPCModelTextTopRightCorner",
        "QuestNPCModelTextBottomRightCorner", "QuestNPCModelTextBottomBorder", "QuestNPCModelTextBottomLeftCorner",
        "QuestNPCModelTextLeftBorder", "QuestNPCModelTextTopLeftCorner",
    },
    -- Trade
    {
        "TradeFrame", "TradeFrame.NineSlice", "TradeFrame.RecipientOverlay", "TradeFrameInset.NineSlice",
        "TradePlayerEnchantInset", "TradePlayerEnchantInset.NineSlice", "TradePlayerItemsInset.NineSlice",
        "TradeRecipientItemsInset.NineSlice", "TradeRecipientMoneyBg", "TradeRecipientMoneyInset.NineSlice",
        "TradeRecipientEnchantInset", "TradeRecipientEnchantInset.NineSlice",
    },
    -- Settings and add-on list
    { "SettingsPanel", "SettingsPanel.Bg", "SettingsPanel.NineSlice", "AddonList", "AddonList.NineSlice", "AddonListBg" },

    -- Load-on-demand -------------------------------------------------------------------
    {
        addon = "Blizzard_Communities",
        "CommunitiesFrame", "CommunitiesFrame.NineSlice", "CommunitiesFrameInset", "CommunitiesFrameInset.NineSlice",
        "CommunitiesFrame.GuildMemberDetailFrame", "CommunitiesFrame.GuildMemberDetailFrame.Border",
        "CommunitiesFrame.ChatEditBox", "CommunitiesFrame.Chat.InsetFrame", "CommunitiesFrame.Chat.InsetFrame.NineSlice",
        "CommunitiesFrame.MemberList.InsetFrame", "CommunitiesFrame.MemberList.InsetFrame.NineSlice",
        "CommunitiesFrame.MemberList.ColumnDisplay",
        "CommunitiesFrameCommunitiesList", "CommunitiesFrameCommunitiesList.InsetFrame",
        "CommunitiesFrameCommunitiesList.InsetFrame.NineSlice",
        "CommunitiesFrameGuildDetailsFrame", "CommunitiesFrame.GuildBenefitsFrame",
        "ClubFinderGuildFinderFrame.InsetFrame", "ClubFinderGuildFinderFrame.InsetFrame.NineSlice",
        "ClubFinderCommunityAndGuildFinderFrame.InsetFrame", "ClubFinderCommunityAndGuildFinderFrame.InsetFrame.NineSlice",
        "CommunitiesFrameCommunitiesListListScrollFrameThumbTexture", "CommunitiesFrameCommunitiesListListScrollFrameTop",
        "CommunitiesFrameCommunitiesListListScrollFrameMiddle", "CommunitiesFrameCommunitiesListListScrollFrameBottom",
    },
    {
        addon = "Blizzard_TimeManager",
        "TimeManagerFrame", "TimeManagerFrame.NineSlice", "TimeManagerFrameInset", "TimeManagerFrameInset.NineSlice",
        "StopwatchFrame", "StopwatchFrameBackgroundLeft",
    },
    {
        addon = "Blizzard_MacroUI",
        "MacroFrame", "MacroFrame.NineSlice", "MacroFrameInset", "MacroFrameInset.NineSlice",
        "MacroFrameTextBackground", "MacroFrameTextBackground.NineSlice",
        "MacroButtonScrollFrameTop", "MacroButtonScrollFrameMiddle", "MacroButtonScrollFrameBottom",
        "MacroButtonScrollFrameScrollBarThumbTexture", "MacroFrameTab1", "MacroFrameTab2",
    },
    {
        addon = "Blizzard_InspectUI",
        "InspectFrame", "InspectFrame.NineSlice", "InspectFrameInset", "InspectFrameInset.NineSlice",
        "InspectPaperDollItemsFrame", "InspectPaperDollItemsFrame.InspectTalents", "InspectPVPFrame",
        "InspectModelFrameBorderLeft", "InspectModelFrameBorderRight", "InspectModelFrameBorderTop",
        "InspectModelFrameBorderTopLeft", "InspectModelFrameBorderTopRight", "InspectModelFrameBorderBottom",
        "InspectModelFrameBorderBottomLeft", "InspectModelFrameBorderBottomRight", "InspectModelFrameBorderBottom2",
        "InspectHeadSlotFrame", "InspectNeckSlotFrame", "InspectShoulderSlotFrame", "InspectBackSlotFrame",
        "InspectChestSlotFrame", "InspectShirtSlotFrame", "InspectTabardSlotFrame", "InspectWristSlotFrame",
        "InspectHandsSlotFrame", "InspectWaistSlotFrame", "InspectLegsSlotFrame", "InspectFeetSlotFrame",
        "InspectFinger0SlotFrame", "InspectFinger1SlotFrame", "InspectTrinket0SlotFrame", "InspectTrinket1SlotFrame",
        "InspectSecondaryHandSlotFrame",
        "InspectFrameTab1", "InspectFrameTab2", "InspectFrameTab3", "InspectFrameTab4",
    },
    {
        addon = "Blizzard_Calendar",
        "CalendarFrame", "CalendarCreateEventFrame", "CalendarCreateEventFrame.Header", "CalendarCreateEventFrame.Border",
        "CalendarViewHolidayFrame", "CalendarViewHolidayFrame.Header", "CalendarViewHolidayFrame.Border",
        "CalendarCreateEventDivider", "CalendarCreateEventFrameButtonBackground",
        "CalendarCreateEventMassInviteButtonBorder", "CalendarCreateEventCreateButtonBorder",
    },
    {
        addon = "Blizzard_TrainerUI",
        "ClassTrainerFrame", "ClassTrainerFrame.NineSlice", "ClassTrainerFrameInset.NineSlice",
        "ClassTrainerFrameBottomInset.NineSlice",
    },
    { addon = "Blizzard_ItemSocketingUI", "ItemSocketingFrame", "ItemSocketingFrame.NineSlice" },
    {
        addon = "Blizzard_AuctionHouseUI",
        "AuctionHouseFrame", "AuctionHouseFrame.NineSlice", "AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice",
        "AuctionHouseFrame.BuyDialog", "AuctionHouseFrame.BuyDialog.Border", "AuctionHouseFrame.MoneyFrameBorder",
        "AuctionHouseFrame.MoneyFrameInset.NineSlice", "AuctionHouseFrame.CategoriesList",
        "AuctionHouseFrameBuyTab", "AuctionHouseFrameSellTab", "AuctionHouseFrameAuctionsTab",
        "AuctionHouseFrameAuctionsFrameAuctionsTab", "AuctionHouseFrameAuctionsFrameBidsTab",
    },
    {
        addon = "Blizzard_GuildBankUI",
        clients = { Mainline = true, TBC = true, Mists = true },
        "GuildBankFrame", "GuildBankFrameLeft", "GuildBankFrameMiddle", "GuildBankFrameRight", "GuildBankFrame.MoneyFrameBG",
        "GuildBankFrame.Column1", "GuildBankFrame.Column2", "GuildBankFrame.Column3", "GuildBankFrame.Column4",
        "GuildBankFrame.Column5", "GuildBankFrame.Column6", "GuildBankFrame.Column7",
        "GuildBankFrameTab1", "GuildBankFrameTab2", "GuildBankFrameTab3", "GuildBankFrameTab4",
    },
    {
        addon = "Blizzard_EncounterJournal",
        clients = MainlineMists,
        hide = { "EncounterJournalInset" },
        "EncounterJournal", "EncounterJournal.NineSlice", "EncounterJournalInset", "EncounterJournalInset.NineSlice",
        "EncounterJournalNavBar", "EncounterJournalNavBar.overlay",
        "EncounterJournalMonthlyActivitiesTab", "EncounterJournalSuggestTab", "EncounterJournalDungeonTab",
        "EncounterJournalRaidTab", "EncounterJournalLootJournalTab",
    },
    {
        addon = "Blizzard_Collections",
        clients = MainlineMists,
        "CollectionsJournal", "CollectionsJournal.NineSlice", "CollectionsJournalBg",
        "MountJournal", "MountJournal.MountDisplay", "MountJournal.LeftInset.NineSlice", "MountJournal.RightInset.NineSlice",
        "ToyBox", "ToyBox.iconsFrame", "ToyBox.iconsFrame.NineSlice",
        "HeirloomsJournal", "HeirloomsJournal.iconsFrame", "HeirloomsJournal.iconsFrame.NineSlice",
        "PetJournalLeftInset", "PetJournalLeftInset.NineSlice", "PetJournalPetCardInset", "PetJournalPetCardInset.NineSlice",
        "PetJournalPetCard", "PetJournalLoadoutPet1", "PetJournalLoadoutPet2", "PetJournalLoadoutPet3",
        "PetJournalLoadoutBorder", "PetJournalRightInset.NineSlice",
        "MountJournalListScrollFrameScrollBarThumbTexture", "MountJournalListScrollFrameScrollBarTop",
        "MountJournalListScrollFrameScrollBarMiddle", "MountJournalListScrollFrameScrollBarBottom",
        "PetJournalListScrollFrameScrollBarThumbTexture", "PetJournalListScrollFrameScrollBarTop",
        "PetJournalListScrollFrameScrollBarMiddle", "PetJournalListScrollFrameScrollBarBottom",
        "CollectionsJournalTab1", "CollectionsJournalTab2", "CollectionsJournalTab3",
        "CollectionsJournalTab4", "CollectionsJournalTab5",
    },
    -- Dungeon finder
    {
        clients = MainlineMists,
        "PVEFrame", "PVEFrame.shadows", "PVEFrame.NineSlice", "PVEFrameLeftInset", "PVEFrameLeftInset.NineSlice",
        "LFGListFrame", "LFGListFrame.SearchPanel.ResultsInset", "LFGListFrame.SearchPanel.ResultsInset.NineSlice",
        "LFGListFrame.CategorySelection", "LFGListFrame.CategorySelection.Inset",
        "LFGListFrame.CategorySelection.Inset.NineSlice",
        "LFDParentFrameInset", "LFDParentFrameInset.NineSlice",
        "RaidFinderFrameRoleInset", "RaidFinderFrameRoleInset.NineSlice",
        "RaidFinderFrameBottomInset", "RaidFinderFrameBottomInset.NineSlice",
        "LFDRoleCheckPopup", "LFDRoleCheckPopup.Border", "PVPReadyDialog", "PVPReadyDialog.Border",
        "LFDQueueFrameBackground", "LFDParentFrameRoleBackground",
        "PVEFrameTopFiligree", "PVEFrameBottomFiligree", "PVEFrameBlueBg",
        "PVEFrameTab1", "PVEFrameTab2", "PVEFrameTab3", "PVEFrameTab4",
    },
    { addon = "Blizzard_ChallengesUI", clients = MainlineMists, "ChallengesFrameInset.NineSlice" },
}

for i = 1, #groups do
    ns.Skins.Shared[i] = groups[i]
end
