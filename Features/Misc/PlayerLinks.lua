--[[
    SUI 2.0 - Features/Misc/PlayerLinks.lua

    Adds Raider.io, WarcraftLogs and Check-PvP links for players to unit
    right-click menus. Retail (and every client with the Menu API) extends
    the menus directly; the old UnitPopup dropdown gets a small panel next to
    it instead, because adding entries to that dropdown taints it. A second
    feature adds the same links to the retail group finder menus (search
    results and applicants). A click opens a popup with the link to copy.
]]

local _, ns = ...
local SUI = ns.SUI

local format, strsplit = string.format, strsplit
local CanAccess = SUI.Compat.CanAccess

local PlayerLinks = SUI:NewFeature("Misc.PlayerLinks", {
    category = "misc",
    toggle = "playerlinks",
})

local REGIONS = { "us", "kr", "eu", "tw", "cn" }
local CLASSIC_LOGS = { Mists = "classic", TBC = "fresh", Vanilla = "vanilla" }

-- { label, url format (region, realm, name), realm with spaces instead of a slug }
local SITES = SUI.IsRetail and {
    { "Raider.io", "https://raider.io/characters/%s/%s/%s" },
    { "WarcraftLogs", "https://www.warcraftlogs.com/character/%s/%s/%s" },
    { "Check-PvP", "https://check-pvp.fr/%s/%s/%s", true },
} or {
    { "WarcraftLogs", "https://" .. (CLASSIC_LOGS[SUI.Client] or "classic") .. ".warcraftlogs.com/character/%s/%s/%s" },
}

StaticPopupDialogs.SUI_MISC_COPY_LINK = {
    text = SUI.brand .. "\nPress CTRL+C to copy the link.",
    button1 = CLOSE or "Close",
    hasEditBox = true,
    editBoxWidth = 320,
    OnShow = function(dialog, url)
        local box = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox or dialog.EditBox
        box:SetText(url)
        box:HighlightText()
        box:SetFocus()
    end,
    EditBoxOnEnterPressed = function(box)
        box:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(box)
        box:GetParent():Hide()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function playerRegion()
    return REGIONS[GetCurrentRegion()] or "eu"
end

-- "ArgentDawn" / "Argent Dawn" -> "Argent Dawn"
local function spacedRealm(realm)
    return (realm:gsub("(%l)(%u)", "%1 %2"))
end

local function buildUrl(site, name, realm, region)
    local realmPart
    if site[3] then
        realmPart = spacedRealm(realm):gsub(" ", "%%20")
    else
        realmPart = spacedRealm(realm):gsub("'", ""):gsub("%s+", "-"):lower()
    end
    return format(site[2], region, realmPart, name)
end

local function showLink(url)
    StaticPopup_Show("SUI_MISC_COPY_LINK", nil, nil, url)
end

-- Returns name, realm for "Name", "Name-Realm" or a separate realm; nil for secrets.
local function resolve(name, realm)
    if not name or not CanAccess(name) or (realm and not CanAccess(realm)) then
        return
    end
    if not realm or realm == "" then
        name, realm = strsplit("-", name, 2)
    end
    if not realm or realm == "" then
        realm = GetNormalizedRealmName()
    end
    if name and name ~= "" and realm then
        return name, realm
    end
end

-- Menu API ------------------------------------------------------------------------------
local UNIT_MENUS = {
    "MENU_UNIT_SELF", "MENU_UNIT_PLAYER", "MENU_UNIT_ENEMY_PLAYER", "MENU_UNIT_PARTY", "MENU_UNIT_RAID_PLAYER",
    "MENU_UNIT_FRIEND", "MENU_UNIT_FRIEND_OFFLINE", "MENU_UNIT_GUILD", "MENU_UNIT_GUILD_OFFLINE",
    "MENU_UNIT_COMMUNITIES_GUILD_MEMBER", "MENU_UNIT_COMMUNITIES_WOW_MEMBER", "MENU_UNIT_CHAT_ROSTER",
}

local function addToMenu(root, name, realm, region)
    root:CreateDivider()
    root:CreateTitle(SUI.brand .. " Player Links")
    for i = 1, #SITES do
        local url = buildUrl(SITES[i], name, realm, region)
        root:CreateButton(SITES[i][1], function()
            showLink(url)
        end)
    end
end

local function onUnitMenu(_, root, context)
    if not PlayerLinks.enabled or not context then
        return
    end
    local name, realm
    if context.unit then
        name, realm = UnitName(context.unit)
    end
    if not name or not CanAccess(name) then
        name, realm = context.name, context.server
    end
    name, realm = resolve(name, realm)
    if name then
        addToMenu(root, name, realm, playerRegion())
    end
end

local function onBattleNetMenu(_, root, context)
    if not PlayerLinks.enabled or not context or not context.bnetIDAccount or not C_BattleNet then
        return
    end
    local account = C_BattleNet.GetAccountInfoByID(context.bnetIDAccount)
    local game = account and account.gameAccountInfo
    if not game or game.clientProgram ~= BNET_CLIENT_WOW or (game.wowProjectID and game.wowProjectID ~= WOW_PROJECT_ID) then
        return
    end
    local name, realm = resolve(game.characterName, game.realmName)
    if name then
        addToMenu(root, name, realm, REGIONS[game.regionID] or playerRegion())
    end
end

-- Group finder menus (retail) ---------------------------------------------------------------
local PlayerLinksLFG = SUI:NewFeature("Misc.PlayerLinksLFG", {
    category = "misc",
    toggle = "playerlinkslfg",
    clients = { Mainline = true },
})

-- Search entries carry resultID; applicant member rows carry memberIdx and
-- their parent the applicantID.
local function groupFinderName(owner)
    if not owner or not C_LFGList then
        return
    end
    if owner.resultID then
        local info = C_LFGList.GetSearchResultInfo(owner.resultID)
        return info and info.leaderName
    end
    local parent = owner.GetParent and owner:GetParent()
    local applicantID = owner.applicantID or (parent and parent.applicantID)
    if applicantID and owner.memberIdx then
        return (C_LFGList.GetApplicantMemberInfo(applicantID, owner.memberIdx))
    end
end

local function onGroupFinderMenu(owner, root)
    if not PlayerLinksLFG.enabled then
        return
    end
    local name, realm = resolve(groupFinderName(owner))
    if name then
        addToMenu(root, name, realm, playerRegion())
    end
end

function PlayerLinksLFG:OnLoad()
    if Menu and Menu.ModifyMenu then
        Menu.ModifyMenu("MENU_LFG_FRAME_SEARCH_ENTRY", onGroupFinderMenu)
        Menu.ModifyMenu("MENU_LFG_FRAME_MEMBER_APPLY", onGroupFinderMenu)
    end
end

-- UnitPopup dropdown (clients without the Menu API) ----------------------------------------
local POPUP_TYPES = {
    SELF = true, PLAYER = true, ENEMY_PLAYER = true, PARTY = true, RAID_PLAYER = true, RAID = true,
    FRIEND = true, FRIEND_OFFLINE = true, GUILD = true, GUILD_OFFLINE = true, CHAT_ROSTER = true,
}

function PlayerLinks:BuildPanel()
    local panel = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    panel:SetFrameStrata("FULLSCREEN_DIALOG")
    panel:SetBackdrop({ bgFile = SUI.Media.blank, edgeFile = SUI.Media.blank, edgeSize = 1 })
    SUI:ProtectBackdrop(panel)
    panel:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    panel:SetBackdropBorderColor(0, 0, 0, 1)
    panel:EnableMouse(true)
    panel:SetSize(122, 26 + #SITES * 22)
    panel:Hide()

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOP", 0, -6)
    title:SetText(SUI.brand .. " Links")

    local function onClick(button)
        panel:Hide()
        showLink(buildUrl(button.site, panel.name, panel.realm, playerRegion()))
    end
    for i = 1, #SITES do
        local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        button:SetSize(110, 20)
        button:SetPoint("TOP", 0, -2 - i * 22)
        button:SetText(SITES[i][1])
        button.site = SITES[i]
        button:SetScript("OnClick", onClick)
    end

    self.panel = panel
    self.watchMouse = function()
        if not panel:IsMouseOver() then
            panel:Hide()
            PlayerLinks:StopUpdate()
        end
    end
end

function PlayerLinks:ShowPanel(which, unit, name)
    local panel = self.panel
    if not POPUP_TYPES[which] or UIDROPDOWNMENU_MENU_LEVEL ~= 1 then
        return
    end
    local realm
    if unit then
        name, realm = UnitName(unit)
    end
    name, realm = resolve(name, realm)
    if not name then
        panel:Hide()
        return
    end
    panel.name, panel.realm = name, realm
    panel:ClearAllPoints()
    panel:SetPoint("TOPLEFT", DropDownList1, "TOPRIGHT", 2, 0)
    self:StopUpdate()
    panel:Show()
end

function PlayerLinks:OnDropDownHidden()
    local panel = self.panel
    if not panel:IsShown() then
        return
    end
    -- The dropdown closes on mouse down; keep the panel while the cursor is on it.
    if panel:IsMouseOver() then
        self:StartUpdate(self.watchMouse, 0.2)
    else
        panel:Hide()
    end
end

-- Lifecycle -----------------------------------------------------------------------------
function PlayerLinks:OnLoad()
    if Menu and Menu.ModifyMenu then
        for i = 1, #UNIT_MENUS do
            Menu.ModifyMenu(UNIT_MENUS[i], onUnitMenu)
        end
        Menu.ModifyMenu("MENU_UNIT_BN_FRIEND", onBattleNetMenu)
        Menu.ModifyMenu("MENU_UNIT_BN_FRIEND_OFFLINE", onBattleNetMenu)
    elseif UnitPopup_ShowMenu and DropDownList1 then
        self:BuildPanel()
        self:Hook("UnitPopup_ShowMenu", function(_, which, unit, name)
            PlayerLinks:ShowPanel(which, unit, name)
        end)
        self:HookScript(DropDownList1, "OnHide", function()
            PlayerLinks:OnDropDownHidden()
        end)
    end
end

function PlayerLinks:OnDisable()
    if self.panel then
        self.panel:Hide()
    end
end
