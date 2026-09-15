--[[
    SUI 2.0 - Features/Skins/Retail.lua

    Retail-only Blizzard frames (the SUI 1.x skin set that runs on 12.x).
    Frames whose names Retail shares with the classic clients live in
    Shared.lua. The few functions here handle frames Blizzard fills from
    pools or recolours itself.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, type = _G, type

-- Bags keep Blizzard's colours underneath (tinted, not desaturated, as in 1.x).
-- Item slots come from a pool; their border is re-set on Update.
local function skinBags(Skin, S, feature)
    local shade = { 0, 0, 0, 0.78 }
    local function slots(container)
        local pool = container.itemButtonPool
        if pool and type(pool.EnumerateActive) == "function" then
            for button in pool:EnumerateActive() do
                S.Tint(button.NormalTexture, 0.15)
            end
        end
    end
    local function border(frame)
        local b = frame and frame.Border
        if b then
            S.Tint(b.Left, 0.1)
            S.Tint(b.Middle, 0.1)
            S.Tint(b.Right, 0.1)
        end
    end
    local function container(frame)
        if not frame then
            return
        end
        S.TintFrame(frame.NineSlice, 0.1)
        local bg = frame.Bg
        if bg then
            S.Tint(bg.TopSection, 0.1)
            S.Tint(bg.BottomEdge, 0.1)
            S.Tint(bg.BottomLeft, shade)
            S.Tint(bg.BottomRight, shade)
        end
        border(frame.MoneyFrame)
        S.Hook(feature, frame, "Update", slots)
    end
    for i = 1, 13 do
        container(_G["ContainerFrame" .. i])
    end
    container(ContainerFrameCombinedBags)
    border(ContainerFrame1MoneyFrame)
    border(BackpackTokenFrame)
end

-- Skyriding vigor: Blizzard recolours and re-saturates the art itself, so
-- repaint right after either call (1.x replaced both methods instead).
local function skinVigor(Skin, S, feature)
    local container = UIWidgetPowerBarContainerFrame
    if not container then
        return
    end
    local hooked, busy = {}, false
    local function repaint(texture)
        if not busy then
            busy = true
            Skin:Texture(texture, true)
            busy = false
        end
    end
    local function paint(texture, atlas)
        if texture and texture.GetAtlas and texture:GetAtlas() == atlas then
            Skin:Texture(texture, true)
            if not hooked[texture] then
                hooked[texture] = true
                S.Hook(feature, texture, "SetVertexColor", repaint)
                S.Hook(feature, texture, "SetDesaturated", repaint)
            end
        end
    end
    local function update()
        local children = { container:GetChildren() }
        for i = 1, #children do
            local child = children[i]
            paint(child.DecorLeft, "dragonriding_vigor_decor")
            paint(child.DecorRight, "dragonriding_vigor_decor")
            local bars = { child:GetChildren() }
            for j = 1, #bars do
                paint(bars[j].Frame, "dragonriding_vigor_frame")
            end
        end
    end
    S.Hook(feature, container, "ProcessWidget", update)
    update()
end

-- Midnight damage meter: rows are pooled and initialised through the mixin.
local function skinDamageMeter(Skin, S, feature)
    local function entry(frame)
        if not frame or (frame.IsForbidden and frame:IsForbidden()) then
            return
        end
        -- 1.x passed these to SUI:Skin as a plain table, which tinted nothing
        local bar = frame.StatusBar or frame
        if bar.BackgroundEdge then
            bar.BackgroundEdge:Show()
        end
        if bar.Background then
            bar.Background:SetAlpha(0)
        end
        if frame.SetStatusBarTexture then
            frame:SetStatusBarTexture(SUI:Get("general.texture"))
            local texture = frame:GetStatusBarTexture()
            if texture then
                texture:SetDrawLayer("BORDER")
            end
        end
    end
    local done = {}
    local function windows()
        for i = 1, 3 do
            local window = _G["DamageMeterSessionWindow" .. i]
            if window and not done[window] then
                done[window] = true
                Skin:Frame(window, true)
                Skin:Frame(window.Header, true)
                if type(window.EnumerateEntryFrames) == "function" then
                    for _, row in window:EnumerateEntryFrames() do
                        entry(row)
                    end
                end
            end
        end
    end
    S.Hook(feature, DamageMeter, "GetSessionWindow", windows)
    S.Hook(feature, DamageMeterEntryMixin, "Init", entry)
    windows()
end

local groups = {
    { run = skinBags },
    { run = skinVigor },
    {
        "BankFrameTab1", "BankFrameTab2", "BankFrameTab3",
        "AccountBankPanel.NineSlice", "AccountBankPanel.MoneyFrame.Border",
        "ReagentBankFrame", "ReagentBankFrame.NineSlice",
    },
    {
        "CharacterFrame", "CharacterFrame.NineSlice", "CharacterFrameInset", "CharacterFrameInset.NineSlice",
        "CharacterFrameInsetRight", "CharacterFrameInsetRight.NineSlice", "CharacterStatsPane",
        "TokenFramePopup", "TokenFramePopup.Border",
        "ReputationFrame.ReputationDetailFrame", "ReputationFrame.ReputationDetailFrame.Border",
        "CurrencyTransferLog", "CurrencyTransferLog.TitleContainer", "CurrencyTransferLog.NineSlice",
        "CurrencyTransferLogInset.NineSlice",
        "CharacterFrameTab1", "CharacterFrameTab2", "CharacterFrameTab3",
    },
    {
        "ReadyStatus.Border", "QueueStatusFrame", "QueueStatusFrame.NineSlice",
        "PVPMatchScoreboard", "PVPMatchScoreboard.Content",
        "PVPScoreboardTab1", "PVPScoreboardTab2", "PVPScoreboardTab3",
        run = function(Skin, S, feature)
            -- 1.x re-skinned the scoreboard whenever it opened
            S.HookScript(feature, PVPMatchScoreboard, "OnShow", function(frame)
                Skin:Frame(frame, true)
            end)
        end,
    },
    {
        grey = { -- 1.x: plain SetVertexColor(0.15)
            "MerchantRepairItemButton#1", "MerchantRepairAllButton#1",
            "MerchantGuildBankRepairButton#1", "MerchantSellAllJunkButton#1",
        },
    },
    {
        "QuestLogPopupDetailFrame", "QuestLogPopupDetailFrame.NineSlice",
        "ObjectiveTrackerFrame", "ObjectiveTrackerFrame.Header",
        "CampaignQuestObjectiveTracker", "CampaignQuestObjectiveTracker.Header",
        "QuestObjectiveTracker", "QuestObjectiveTracker.Header",
        "ProfessionsRecipeTracker", "ProfessionsRecipeTracker.Header",
        "ScenarioObjectiveTracker", "ScenarioObjectiveTracker.Header",
    },

    -- Load-on-demand -------------------------------------------------------------------
    {
        addon = "Blizzard_AchievementUI",
        hide = { "AchievementFrame.Header.PointBorder" },
        white = { "AchievementFrame.Header" },
        "AchievementFrame", "AchievementFrame.Searchbox", "AchievementFrameSummary",
        "AchievementFrameTab1", "AchievementFrameTab2", "AchievementFrameTab3",
    },
    {
        addon = "Blizzard_ProfessionsCustomerOrders",
        "ProfessionsCustomerOrdersFrame", "ProfessionsCustomerOrdersFrame.NineSlice",
        "ProfessionsCustomerOrdersFrame.BrowseOrders.CategoryList.NineSlice",
        "ProfessionsCustomerOrdersFrame.MoneyFrameBorder", "ProfessionsCustomerOrdersFrame.MoneyFrameInset.NineSlice",
        "ProfessionsCustomerOrdersFrameBrowseTab", "ProfessionsCustomerOrdersFrameOrdersTab",
    },
    { addon = "Blizzard_AlliedRacesUI", "AlliedRacesFrame", "AlliedRacesFrame.NineSlice", "AlliedRacesFrameInset.NineSlice" },
    { addon = "Blizzard_ArchaeologyUI", "ArchaeologyFrame.NineSlice" },
    { addon = "Blizzard_AzeriteUI", "AzeriteEmpoweredItemUI.BorderFrame", "AzeriteEmpoweredItemUI.BorderFrame.NineSlice" },
    { addon = "Blizzard_AzeriteRespecUI", "AzeriteRespecFrame", "AzeriteRespecFrame.NineSlice" },
    {
        addon = "Blizzard_AzeriteEssenceUI",
        "AzeriteEssenceUI", "AzeriteEssenceUI.NineSlice", "AzeriteEssenceUI.LeftInset.NineSlice",
        "AzeriteEssenceUI.RightInset.NineSlice", "AzeriteEssenceUI.EssenceList.ScrollBar",
    },
    {
        addon = "Blizzard_Collections",
        protect = { "MountJournal.BottomLeftInset.SlotButton#2" },
        white = { "MountJournal.BottomLeftInset.SlotButton#2" },
        "MountJournal.BottomLeftInset", "MountJournal.BottomLeftInset.NineSlice", "MountJournal.BottomLeftInset.SlotButton",
        "WardrobeCollectionFrame", "WardrobeCollectionFrame.ItemsCollectionFrame",
        "WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice", "WardrobeCollectionFrame.SetsCollectionFrame",
        "WardrobeCollectionFrame.SetsCollectionFrame.LeftInset", "WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice",
        "WardrobeCollectionFrame.SetsCollectionFrame.RightInset", "WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice",
        "WardrobeCollectionFrameScrollFrameScrollBarTop", "WardrobeCollectionFrameScrollFrameScrollBarMiddle",
        "WardrobeCollectionFrameScrollFrameScrollBarBottom", "WardrobeCollectionFrameScrollFrameScrollBarThumbTexture",
        "WardrobeCollectionFrameTab1", "WardrobeCollectionFrameTab2",
    },
    { addon = "Blizzard_DamageMeter", run = skinDamageMeter },
    { addon = "Blizzard_FlightMap", "FlightMapFrame", "FlightMapFrame.BorderFrame", "FlightMapFrame.BorderFrame.NineSlice" },
    {
        addon = "Blizzard_GarrisonUI",
        "GarrisonCapacitiveDisplayFrame", "GarrisonCapacitiveDisplayFrame.NineSlice",
        "GarrisonCapacitiveDisplayFrameInset", "GarrisonCapacitiveDisplayFrameInset.NineSlice",
    },
    {
        addon = "Blizzard_HousingDashboard",
        "HousingDashboardFrame", "HousingDashboardFrame.NineSlice",
        "HousingDashboardFrameScrollFrameScrollBarTop", "HousingDashboardFrameScrollFrameScrollBarMiddle",
        "HousingDashboardFrameScrollFrameScrollBarBottom", "HousingDashboardFrameScrollFrameScrollBarThumbTexture",
    },
    {
        addon = "Blizzard_InspectUI",
        hide = { "InspectMainHandSlotFrame", "InspectMainHandSlot#-1", "InspectSecondaryHandSlot#-1" },
    },
    { addon = "Blizzard_IslandsQueueUI", "IslandsQueueFrame", "IslandsQueueFrame.NineSlice", "IslandsQueueFrame.ArtOverlayFrame" },
    {
        addon = "Blizzard_PVPUI",
        hide = { "PVPQueueFrame.HonorInset" },
        "HonorFrame", "HonorFrame.ConquestFrame", "HonorFrame.Inset", "HonorFrame.Inset.NineSlice", "HonorFrame.BonusFrame",
        "ConquestFrame", "ConquestFrame.ConquestBar", "ConquestFrame.Inset", "ConquestFrame.Inset.NineSlice",
        "PVPQueueFrame", "PVPQueueFrame.HonorInset", "PVPQueueFrame.HonorInset.NineSlice",
        "PlunderstormFrame.Inset", "PlunderstormFrame.Inset.NineSlice",
    },
    {
        addon = "Blizzard_Professions",
        "ProfessionsFrame", "ProfessionsFrame.NineSlice",
        "ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice",
        "ProfessionsFrame.CraftingPage.SchematicForm.NineSlice", "ProfessionsFrame.CraftingPage.SchematicForm.Details",
        "ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.NineSlice",
        "ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.BackgroundNineSlice",
        "ProfessionsFrame.TabSystem.tabs.1", "ProfessionsFrame.TabSystem.tabs.2", "ProfessionsFrame.TabSystem.tabs.3",
        "ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton",
        "ProfessionsFrame.OrdersPage.BrowseFrame.GuildOrdersButton",
        "ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton",
        "ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton",
        "InspectRecipeFrame", "InspectRecipeFrame.NineSlice",
    },
    {
        addon = "Blizzard_ProfessionsBook",
        "ProfessionsBookFrame", "ProfessionsBookFrame.NineSlice", "ProfessionsBookFrameInset",
        "ProfessionsBookFrameInset.NineSlice", "ProfessionsBookPage1", "ProfessionsBookPage2",
        run = function()
            -- Grey "missing" labels are unreadable on the dark pages
            for i = 1, 3 do
                local missing = _G["SecondaryProfession" .. i .. "Missing"]
                if missing then
                    missing:SetVertexColor(0.8, 0.8, 0.8)
                end
                local button = _G["SecondaryProfession" .. i]
                if button and button.missingText then
                    button.missingText:SetVertexColor(0.8, 0.8, 0.8)
                end
            end
        end,
    },
    {
        addon = "Blizzard_PlayerSpells",
        protect = { "PlayerSpellsFrame.TalentsFrame#4" },
        "PlayerSpellsFrame", "PlayerSpellsFrame.NineSlice", "PlayerSpellsFrame.SpellBookFrame",
        "PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs.1",
        "PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs.2",
        "PlayerSpellsFrame.TalentsFrame", "PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer",
        "PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton",
        "PlayerSpellsFrame.TalentsFrame.SearchBox", "PlayerSpellsFrame.TalentsFrame.LoadSystem",
        "PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown", "PlayerSpellsFrame.TalentsFrame.ApplyButton",
        "HeroTalentsSelectionDialog", "HeroTalentsSelectionDialog.NineSlice",
        "ClassTalentFrameTitleBg", "ClassTalentFrameBg", "ClassTalentFrameTalentsPvpTalentFrameTalentListBg",
        "PlayerSpellsFrame.TabSystem.tabs.1", "PlayerSpellsFrame.TabSystem.tabs.2", "PlayerSpellsFrame.TabSystem.tabs.3",
        run = function(Skin, S, feature)
            local background = S.Resolve("PlayerSpellsFrame.TalentsFrame#4")
            if background then
                background:SetVertexColor(1, 1, 1, 0.7)
            end
            local pageText = S.Resolve("PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls.PageText")
            if pageText then
                pageText:SetVertexColor(0.8, 0.8, 0.8)
            end
            -- Spell names and borders are reset every time a page is drawn
            S.Hook(feature, SpellBookItemMixin, "UpdateVisuals", function(item)
                if item.Name then
                    item.Name:SetTextColor(0.8, 0.8, 0.8)
                end
                if item.Button and item.Button.Border then
                    item.Button.Border:SetVertexColor(0.5, 0.5, 0.5)
                end
            end)
        end,
    },
    { addon = "Blizzard_ScrappingMachineUI", "ScrappingMachineFrame", "ScrappingMachineFrame.NineSlice" },
}

for i = 1, #groups do
    ns.Skins.Mainline[i] = groups[i]
end
