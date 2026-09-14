--[[
    SUI 2.0 - Features/General/Automation.lua

    Small quality-of-life automations: fill in DELETE, decline duels, release
    on death, accept resurrections and group invites from friends, skip
    cinematics (hold Ctrl to watch) and accept LFG role checks.
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat

local function findPopup(which)
    return StaticPopup_FindVisible and StaticPopup_FindVisible(which)
end

-- Delete confirmation ---------------------------------------------------------------
local Delete = SUI:NewFeature("General.Delete", {
    category = "general",
    toggle = "automation.delete",
})

local function fillDelete()
    local dialog = findPopup("DELETE_GOOD_ITEM") or findPopup("DELETE_GOOD_QUEST_ITEM")
    if not dialog then
        return
    end
    local box = (dialog.GetEditBox and dialog:GetEditBox()) or dialog.editBox or dialog.EditBox
    if box then
        box:SetText(DELETE_ITEM_CONFIRM_STRING)
    end
end

function Delete:OnEnable()
    -- The popup is shown by Blizzard's handler of the same event; fill it next frame.
    self:RegisterEvent("DELETE_ITEM_CONFIRM", function(feature)
        feature:After(0, fillDelete)
    end)
end

-- Decline duels -----------------------------------------------------------------------
local Decline = SUI:NewFeature("General.Decline", {
    category = "general",
    toggle = "automation.decline",
})

function Decline:OnEnable()
    self:RegisterEvent("DUEL_REQUESTED", function()
        CancelDuel()
        StaticPopup_Hide("DUEL_REQUESTED")
    end)
    if C_PetBattles and C_PetBattles.CancelPVPDuel then
        self:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED", function()
            C_PetBattles.CancelPVPDuel()
            StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
        end)
    end
end

-- Auto release ----------------------------------------------------------------------
local Release = SUI:NewFeature("General.Release", {
    category = "general",
    toggle = "automation.release",
})

function Release:OnEnable()
    self:RegisterEvent("PLAYER_DEAD", function()
        RepopMe()
    end)
end

-- Accept resurrection -----------------------------------------------------------------
local Resurrect = SUI:NewFeature("General.Resurrect", {
    category = "general",
    toggle = "automation.resurrect",
})

function Resurrect:OnEnable()
    self:RegisterEvent("RESURRECT_REQUEST", function(_, _, inviter)
        -- 1.x: wait while the resurrecting player is still fighting
        local inCombat = inviter and UnitAffectingCombat(inviter)
        if not Compat.CanAccess(inCombat) or inCombat then
            return
        end
        AcceptResurrect()
        StaticPopup_Hide("RESURRECT")
        StaticPopup_Hide("RESURRECT_NO_SICKNESS")
        StaticPopup_Hide("RESURRECT_NO_TIMER")
    end)
end

-- Accept group invites from friends and guild members -------------------------------
local Invite = SUI:NewFeature("General.Invite", {
    category = "general",
    toggle = "automation.invite",
})

local function isKnown(guid)
    return (C_BattleNet and C_BattleNet.GetAccountInfoByGUID and C_BattleNet.GetAccountInfoByGUID(guid))
        or (C_FriendList and C_FriendList.IsFriend and C_FriendList.IsFriend(guid))
        or (IsGuildMember and IsGuildMember(guid))
end

function Invite:OnEnable()
    self:RegisterEvent("PARTY_INVITE_REQUEST", "OnInvite")
end

function Invite:OnInvite(_, _, _, _, _, _, _, guid)
    if not guid or guid == "" or not Compat.CanAccess(guid) or IsInGroup() then
        return
    end
    -- never auto join while queued
    local queue = QueueStatusButton or MiniMapLFGFrame
    if queue and queue:IsShown() then
        return
    end
    if isKnown(guid) then
        AcceptGroup()
        self:RegisterEvent("GROUP_ROSTER_UPDATE", "HidePopup")
    end
end

function Invite:HidePopup()
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    if LFGInvitePopup and StaticPopupSpecial_Hide then
        StaticPopupSpecial_Hide(LFGInvitePopup)
    end
    StaticPopup_Hide("PARTY_INVITE")
end

-- Skip cinematics -----------------------------------------------------------------------
local Cinematic = SUI:NewFeature("General.Cinematic", {
    category = "general",
    toggle = "automation.cinematic",
})

local function stopMovie()
    local frame = MovieFrame
    if frame and frame:IsShown() and frame.StopMovie then
        frame:StopMovie()
    end
end

function Cinematic:OnEnable()
    self:RegisterEvent("CINEMATIC_START", function()
        if not IsControlKeyDown() and CinematicFrame_CancelCinematic then
            CinematicFrame_CancelCinematic()
        end
    end)
    if C_EventUtils and C_EventUtils.IsEventValid and C_EventUtils.IsEventValid("PLAY_MOVIE") then
        self:RegisterEvent("PLAY_MOVIE", function(feature)
            if not IsControlKeyDown() then
                feature:After(0, stopMovie)
            end
        end)
    end
end

-- Accept LFG role checks ------------------------------------------------------------------
local RoleCheck = SUI:NewFeature("General.RoleCheck", {
    category = "general",
    toggle = "automation.rolecheck",
    clients = { Mainline = true, Mists = true },
})

local function acceptRoleCheck()
    local button = LFDRoleCheckPopupAcceptButton
    if button and button:IsVisible() and button:IsEnabled() then
        button:Click()
    end
end

function RoleCheck:OnEnable()
    self:RegisterEvent("LFG_ROLE_CHECK_SHOW", function(feature)
        feature:After(0, acceptRoleCheck)
    end)
end
