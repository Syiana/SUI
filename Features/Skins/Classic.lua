--[[
    SUI 2.0 - Features/Skins/Classic.lua

    Blizzard frames of the classic clients (Mists, TBC, Vanilla). Groups
    without `clients` apply to all three. Most classic frames still carry
    their portrait or parchment inside the frame, so those regions are
    protected before the frame is painted.
]]

local _, ns = ...

local Mists = { Mists = true }
local TBCMists = { TBC = true, Mists = true }
local VanillaTBC = { Vanilla = true, TBC = true }

local groups = {
    -- Regions that keep their colours (listed before anything is painted)
    {
        protect = {
            "CharacterFramePortrait", "TradeFrameRecipientPortrait", "BankPortraitTexture",
            "SpellBookPage1", "SpellBookPage2", "QuestLogFramePageBg", "QuestLogDetailFramePageBg", "QuestNPCModelBg",
            "OpenStationeryBackgroundLeft", "OpenStationeryBackgroundRight", "InboxFrameBg",
            "ReadyCheckPortrait", "TaxiPortrait", "TaxiMap", "BNToastFrameIconTexture",
            "ContainerFrame1Portrait", "ContainerFrame2Portrait", "ContainerFrame3Portrait", "ContainerFrame4Portrait",
            "ContainerFrame5Portrait", "ContainerFrame6Portrait", "ContainerFrame7Portrait", "ContainerFrame8Portrait",
            "ContainerFrame9Portrait", "ContainerFrame10Portrait", "ContainerFrame11Portrait",
            "ContainerFrame12Portrait", "ContainerFrame13Portrait",
            "FriendsFrame#19", "GossipFrame#19", "MailFrame#18", "OpenMailFrame#18", "LootFrame#18",
            "TradeFrame#18", "ItemTextFrame#18", "ReportFrame#9", "PetPaperDollFrameExpBar#4",
            "SpellBookSkillLineTab1#2", "SpellBookSkillLineTab2#2", "SpellBookSkillLineTab3#2",
            "SpellBookSkillLineTab4#2", "SpellBookSkillLineTab5#2",
        },
    },
    { clients = { Vanilla = true }, protect = { "SpellBookFrame#1", "QuestLogFrame#2" } },
    { clients = TBCMists, protect = { "SpellBookFrame#3", "TaxiFrame#13", "QuestLogFrame#18", "QuestLogDetailFrame#18" } },
    { clients = Mists, protect = { "BankFrame#15" } },

    -- Frames present at login
    {
        "StaticPopup1.BG", "StaticPopup2.BG", "StaticPopup3.BG",
        "StaticPopup1.EditBox.NineSlice", "StaticPopup2.EditBox.NineSlice", "StaticPopup3.EditBox.NineSlice",
        "StaticPopup1EditBox.NineSlice", "StaticPopup2EditBox.NineSlice", "StaticPopup3EditBox.NineSlice",
        "StaticPopup1EditBoxLeft", "StaticPopup1EditBoxMid", "StaticPopup1EditBoxRight",
        "StaticPopup2EditBoxLeft", "StaticPopup2EditBoxMid", "StaticPopup2EditBoxRight",
        "StaticPopup3EditBoxLeft", "StaticPopup3EditBoxMid", "StaticPopup3EditBoxRight",
        "EditModeSystemSettingsDialog", "EditModeSystemSettingsDialog.Border",
        "LFGListApplicationDialog", "LFGListApplicationDialog.Border", "LFGInvitePopup", "LFGInvitePopup.Border",
        "BNToastFrame", "ReadyCheckListenerFrame", "ReadyCheckListenerFrame.NineSlice",
        "BattleTagInviteFrame", "BattleTagInviteFrame.Border",
    },
    -- Bags and bank
    {
        "BackpackTokenFrame", "ContainerFrame1BackgroundBottom",
        "ContainerFrame1", "ContainerFrame2", "ContainerFrame3", "ContainerFrame4", "ContainerFrame5",
        "ContainerFrame6", "ContainerFrame7", "ContainerFrame8", "ContainerFrame9", "ContainerFrame10",
        "ContainerFrame11", "ContainerFrame12", "ContainerFrame13",
        "BankFrameMoneyFrameInset", "BankFrameMoneyFrameInset.NineSlice",
    },
    -- Character
    {
        "CharacterFrame.NineSlice", "CharacterStatsPane", "TokenFramePopup", "TokenFramePopup.Border",
        "ReputationFrame", "ReputationListScrollFrame", "ReputationDetailFrame", "ReputationDetailFrame.Border",
        "PetPaperDollFrame", "PetPaperDollXPBar1", "PetPaperDollFrameExpBar#2",
        "CharacterFrameTab1", "CharacterFrameTab2", "CharacterFrameTab3", "CharacterFrameTab4", "CharacterFrameTab5",
    },
    { clients = VanillaTBC, "PaperDollFrame", "SkillFrame", "SkillListScrollFrame", "SkillDetailScrollFrame", "HonorFrame", "PVPFrame" },
    {
        clients = Mists,
        "CharacterFrame", "CharacterFrameInset", "CharacterFrameInset.NineSlice",
        "CharacterFrameInsetRight", "CharacterFrameInsetRight.NineSlice",
        "GearManagerPopupFrame", "GearManagerPopupFrame.BorderBox",
    },
    -- Friends, guild registrar, tabard, gossip, books, loot, mail
    {
        "FriendsFrameFriendsScrollFrame", "WhoListScrollFrame",
        "WhoFrameColumnHeader1", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4",
        "RaidInfoFrame", "RaidInfoFrame.Header", "RaidInfoFrame.Border",
        "GuildRegistrarFrameInset", "GuildRegistrarFrameInset.NineSlice", "TabardFrameInset", "TabardFrameInset.NineSlice",
        "TabardFrameMoneyBg", "TabardFrameMoneyInset", "TabardFrameMoneyInset.NineSlice",
        "GossipFrame.GreetingPanel.ScrollBar.Background",
        "ItemTextFrameInset", "ItemTextFrameInset.NineSlice", "ItemTextScrollFrame",
        "PetitionFrameInset.NineSlice",
        "LootFrameInset", "LootFrameInset.NineSlice",
        "GroupLootFrame1", "GroupLootFrame2", "GroupLootFrame3", "GroupLootFrame4",
        "MailEditBoxScrollBar.Background", "OpenMailScrollFrame",
    },
    -- Quest log
    {
        "QuestLogFrame", "QuestLogFrame.NineSlice", "QuestLogListScrollFrame", "QuestRewardScrollFrame",
        "QuestDetailScrollFrame", "QuestProgressScrollFrame", "QuestModelScene",
    },
    {
        clients = Mists,
        "QuestLogFrameInset", "QuestLogFrameInset.NineSlice", "QuestLogDetailFrame", "QuestLogDetailFrame.NineSlice",
        "QuestLogDetailFrameInset", "QuestLogDetailFrameInset.NineSlice", "QuestLogDetailScrollFrame",
    },
    -- Spellbook, taxi, merchant, settings, add-on list
    {
        "SpellBookFrame", "SpellBookFrame.NineSlice",
        "SpellBookSkillLineTab1#1", "SpellBookSkillLineTab2#1", "SpellBookSkillLineTab3#1",
        "SpellBookSkillLineTab4#1", "SpellBookSkillLineTab5#1",
        "SpellBookFrameTabButton1", "SpellBookFrameTabButton2", "SpellBookFrameTabButton3",
        "SpellBookFrameTabButton4", "SpellBookFrameTabButton5",
        "TaxiFrame",
        "MerchantGuildBankRepairButton", "MerchantSellAllJunkButton",
        "SettingsPanel.GameTab", "SettingsPanel.AddOnsTab",
        "AddonListInset", "AddonListInset.NineSlice",
        "AddonListScrollFrameScrollBarTop", "AddonListScrollFrameScrollBarMiddle", "AddonListScrollFrameScrollBarBottom",
    },
    { clients = Mists, "SpellBookFrameInset", "SpellBookFrameInset.NineSlice", "SpellBookProfessionFrame", "SpellBookProfessionFrame.NineSlice" },
    -- Battleground score (Vanilla/TBC), dungeon finder extras (Mists)
    {
        clients = VanillaTBC,
        "WorldStateScoreFrame", "WorldStateScoreScrollFrame",
        "WorldStateScoreFrameTab1", "WorldStateScoreFrameTab2", "WorldStateScoreFrameTab3",
    },
    { clients = Mists, "ScenarioFinderFrameInset", "ScenarioFinderFrameInset.NineSlice" },

    -- Load-on-demand -------------------------------------------------------------------
    {
        addon = "Blizzard_TalentUI",
        protect = {
            "PlayerTalentFramePortrait", "PlayerTalentFrameBackgroundTopLeft", "PlayerTalentFrameBackgroundTopRight",
            "PlayerTalentFrameBackgroundBottomLeft", "PlayerTalentFrameBackgroundBottomRight",
            "PlayerSpecTab1#2", "PlayerSpecTab2#2",
        },
        "PlayerTalentFrame", "PlayerTalentFrameScrollFrame", "PlayerTalentFramePointsBar", "PlayerTalentFrameTalents",
        "PlayerTalentFrameInset", "PlayerTalentFrameInset.NineSlice",
        "PlayerTalentFrameTab1", "PlayerTalentFrameTab2", "PlayerTalentFrameTab3", "PlayerTalentFrameTab4",
        "PlayerSpecTab1", "PlayerSpecTab2",
    },
    {
        addon = "Blizzard_GlyphUI",
        clients = Mists,
        "GlyphFrameSideInset", "GlyphFrameSideInset.NineSlice",
        "GlyphFrameScrollFrameScrollBarTop", "GlyphFrameScrollFrameScrollBarMiddle", "GlyphFrameScrollFrameScrollBarBottom",
    },
    {
        addon = "Blizzard_TradeSkillUI",
        protect = { "TradeSkillFramePortrait" },
        "TradeSkillFrame", "TradeSkillFrame.NineSlice", "TradeSkillListScrollFrame#1", "TradeSkillListScrollFrame#2",
    },
    { addon = "Blizzard_TrainerUI", protect = { "ClassTrainerFramePortrait" } },
    {
        addon = "Blizzard_MacroUI",
        protect = { "MacroFrame#18", "MacroFrameTextBackground.NineSlice#9" },
        "MacroFrame.MacroSelector.ScrollBar.Background", "MacroPopupFrame", "MacroPopupFrame.BorderBox",
    },
    { addon = "Blizzard_TimeManager", protect = { "TimeManagerFrame#18" } },
    {
        addon = "Blizzard_Calendar",
        protect = {
            "CalendarClassButton1#3", "CalendarClassButton2#3", "CalendarClassButton3#3", "CalendarClassButton4#3",
            "CalendarClassButton5#3", "CalendarClassButton6#3", "CalendarClassButton7#3", "CalendarClassButton8#3",
            "CalendarClassButton9#3", "CalendarClassButton10#3", "CalendarClassButton11#3",
            "CalendarClassButton12#3", "CalendarClassButton13#3",
        },
        "CalendarClassButton1", "CalendarClassButton2", "CalendarClassButton3", "CalendarClassButton4",
        "CalendarClassButton5", "CalendarClassButton6", "CalendarClassButton7", "CalendarClassButton8",
        "CalendarClassButton9", "CalendarClassButton10", "CalendarClassButton11", "CalendarClassButton12",
        "CalendarClassButton13", "CalendarClassTotalsButton",
    },
    {
        addon = "Blizzard_ItemSocketingUI",
        "ItemSocketingScrollFrame.ScrollBar", "ItemSocketingScrollFrame.ScrollBar.Background",
    },
    {
        addon = "Blizzard_AuctionHouseUI",
        "AuctionHouseFrame.CategoriesList.NineSlice", "AuctionHouseFrame.CategoriesList.ScrollBar.Background",
        "AuctionHouseFrame.BrowseResultsFrame.ItemList", "AuctionHouseFrame.BrowseResultsFrame.ItemList.NineSlice",
        "AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBar.Background", "AuctionHouseFrame.MoneyFrameInset",
    },
    {
        addon = "Blizzard_GuildBankUI",
        clients = TBCMists,
        "GuildBankTab1", "GuildBankTab2", "GuildBankTab3", "GuildBankTab4",
        "GuildBankTab5", "GuildBankTab6", "GuildBankTab7", "GuildBankTab8",
        "GuildBankInfoScrollFrame#1", "GuildBankInfoScrollFrame#2",
    },
    {
        addon = "Blizzard_GroupFinder_VanillaStyle",
        clients = VanillaTBC,
        "LFGListingFrame", "LFGBrowseFrame", "LFGParentFrameTab1", "LFGParentFrameTab2", "LFGBrowseFrameTab1", "LFGBrowseFrameTab2",
    },
    {
        addon = "Blizzard_ArenaUI",
        clients = TBCMists,
        tint = { -- like the 1.x arena skin: tinted, not desaturated
            "ArenaEnemyFrame1Texture", "ArenaEnemyFrame2Texture", "ArenaEnemyFrame3Texture",
            "ArenaEnemyFrame4Texture", "ArenaEnemyFrame5Texture",
            "ArenaEnemyFrame1SpecBorder", "ArenaEnemyFrame2SpecBorder", "ArenaEnemyFrame3SpecBorder",
            "ArenaEnemyFrame4SpecBorder", "ArenaEnemyFrame5SpecBorder",
            "ArenaEnemyFrame1PetFrameTexture", "ArenaEnemyFrame2PetFrameTexture", "ArenaEnemyFrame3PetFrameTexture",
            "ArenaEnemyFrame4PetFrameTexture", "ArenaEnemyFrame5PetFrameTexture",
            "ArenaPrepFrame1Texture", "ArenaPrepFrame2Texture", "ArenaPrepFrame3Texture",
            "ArenaPrepFrame4Texture", "ArenaPrepFrame5Texture",
            "ArenaPrepFrame1SpecBorder", "ArenaPrepFrame2SpecBorder", "ArenaPrepFrame3SpecBorder",
            "ArenaPrepFrame4SpecBorder", "ArenaPrepFrame5SpecBorder",
        },
    },
    {
        addon = "Blizzard_AchievementUI",
        clients = Mists,
        protect = { "AchievementFrameHeaderShield" },
        hide = { "AchievementFrameHeaderPointBorder" },
        "AchievementFrame", "AchievementFrameHeader", "AchievementFrameSummary",
        "AchievementFrameTab1", "AchievementFrameTab2", "AchievementFrameTab3",
    },
    {
        addon = "Blizzard_ArchaeologyUI",
        clients = Mists,
        protect = { "ArchaeologyFrameBgLeft", "ArchaeologyFrameBgRight" },
        "ArchaeologyFrame", "ArchaeologyFrame.NineSlice",
    },
    {
        addon = "Blizzard_Collections",
        clients = Mists,
        protect = { "CollectionsJournal#3" },
        "MountJournal.ScrollBar.Background", "CollectionsJournalTab6",
        "PetJournalSummonRandomFavoritePetButtonBorder", "PetJournalHealPetButtonBorder",
    },
    {
        addon = "Blizzard_Transmog",
        clients = Mists,
        "TransmogFrame", "TransmogFrame.NineSlice", "TransmogFrame.WardrobeCollection",
        "TransmogFrame.WardrobeCollection.TabContent",
    },
    {
        addon = "Blizzard_PVPUI",
        clients = Mists,
        "HonorQueueFrame.Inset", "HonorQueueFrame.Inset.NineSlice", "HonorQueueFrame.RoleInset",
        "HonorQueueFrame.RoleInset.NineSlice",
        "WarGamesQueueFrame", "WarGamesQueueFrame.RightInset", "WarGamesQueueFrame.RightInset.NineSlice",
        "WarGamesQueueFrame.HorizontalBar", "WarGamesQueueFrameInfoScrollFrame.ScrollBar.Background",
        "WarGamesQueueFrameScrollFrameScrollBarTop", "WarGamesQueueFrameScrollFrameScrollBarMiddle",
        "WarGamesQueueFrameScrollFrameScrollBarBottom",
        "ConquestQueueFrame", "ConquestQueueFrame.Inset", "ConquestQueueFrame.Inset.NineSlice",
    },
    { addon = "Blizzard_ReforgingUI", clients = Mists, "ReforgingFrame", "ReforgingFrame.NineSlice", "ReforgingFrameButtonFrame" },
    { addon = "Blizzard_ItemUpgradeUI", clients = Mists, "ItemUpgradeFrame", "ItemUpgradeFrame.NineSlice" },
}

for i = 1, #groups do
    ns.Skins.Classic[i] = groups[i]
end
