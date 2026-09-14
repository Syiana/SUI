--[[
    SUI 2.0 - Features/Tooltip/GroupFinder.lua

    Retail group finder: search result tooltips show the leader's Mythic+
    rating for activities where Blizzard does not already show it, and group
    members who are not the leader can hover applicants to read Blizzard's
    applicant tooltip (spec, item level, rating, note).
]]

local _, ns = ...
local SUI = ns.SUI

local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Tooltip.GroupFinder", {
    category = "tooltip",
    toggle = "lfgtooltips",
    clients = { Mainline = true },
})

local function addLeaderRating(tooltip, resultID)
    if not F.enabled or not resultID then
        return
    end
    local info = C_LFGList.GetSearchResultInfo(resultID)
    local score = info and info.leaderOverallDungeonScore
    if not score or not CanAccess(score) or score <= 0 then
        return
    end
    local activityID = info.activityIDs and info.activityIDs[1] or info.activityID
    local activity = activityID and C_LFGList.GetActivityInfoTable(activityID)
    if activity and activity.isMythicPlusActivity then
        return -- Blizzard lists the leader's score itself
    end
    local r, g, b = 1, 1, 1
    local color = C_ChallengeMode.GetDungeonScoreRarityColor(score)
    if color then
        r, g, b = color.r, color.g, color.b
    end
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("Leader Mythic+ Rating", score, 0, 0.6, 1, r, g, b)
    tooltip:Show()
end

-- Non-leaders see the applicant list behind a cover that swallows the mouse.
local function cover()
    local frame = LFGListFrame
    local viewer = frame and frame.ApplicationViewer
    return viewer and viewer.UnempoweredCover
end

local function setCoverMouse(enabled)
    local c = cover()
    if c then
        c:EnableMouse(enabled)
    end
end

function F:OnLoad()
    local feature = self
    SUI:OnAddonLoaded(LFGListFrame and SUI.name or "Blizzard_GroupFinder", function()
        if LFGListUtil_SetSearchEntryTooltip then
            hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", addLeaderRating)
        end
        if feature.enabled then
            setCoverMouse(false)
        end
    end)
end

function F:OnEnable()
    setCoverMouse(false)
end

function F:OnDisable()
    setCoverMouse(true)
end
