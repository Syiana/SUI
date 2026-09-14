--[[
    SUI 2.0 - Features/General/Quests.lua

    Quest and gossip automation. Quests are accepted and turned in (when at
    most one reward can be chosen); a gossip window with exactly one option
    and no quests picks that option. Holding any modifier key skips both.
]]

local _, ns = ...
local SUI = ns.SUI

local IsModifierKeyDown = IsModifierKeyDown

-- Quests ----------------------------------------------------------------------------
local Quests = SUI:NewFeature("General.Quests", {
    category = "general",
    toggle = "automation.quests",
})

function Quests:OnEnable()
    self:RegisterEvent("QUEST_DETAIL", "OnDetail")
    self:RegisterEvent("QUEST_PROGRESS", "OnProgress")
    self:RegisterEvent("QUEST_COMPLETE", "OnComplete")
    self:RegisterEvent("QUEST_GREETING", "OnGreeting")
    if C_GossipInfo and C_GossipInfo.GetActiveQuests then
        self:RegisterEvent("GOSSIP_SHOW", "OnGossip")
    end
end

function Quests:OnDetail()
    if IsModifierKeyDown() then
        return
    end
    -- auto-accept quests are already in the log; the frame only informs
    if QuestGetAutoAccept and QuestGetAutoAccept() then
        return
    end
    AcceptQuest()
end

function Quests:OnProgress()
    if not IsModifierKeyDown() and IsQuestCompletable() then
        CompleteQuest()
    end
end

function Quests:OnComplete()
    if IsModifierKeyDown() then
        return
    end
    local choices = GetNumQuestChoices()
    if choices <= 1 then
        GetQuestReward(choices)
    end
end

-- NPCs that only offer quests (no gossip)
function Quests:OnGreeting()
    if IsModifierKeyDown() then
        return
    end
    for i = 1, GetNumActiveQuests() do
        local _, isComplete = GetActiveTitle(i)
        if isComplete then
            SelectActiveQuest(i)
            return
        end
    end
    if GetNumAvailableQuests() > 0 then
        SelectAvailableQuest(1)
    end
end

function Quests:OnGossip()
    if IsModifierKeyDown() then
        return
    end
    local active = C_GossipInfo.GetActiveQuests()
    for i = 1, #active do
        if active[i].isComplete then
            C_GossipInfo.SelectActiveQuest(active[i].questID)
            return
        end
    end
    local available = C_GossipInfo.GetAvailableQuests()
    if available[1] then
        C_GossipInfo.SelectAvailableQuest(available[1].questID)
    end
end

-- Gossip ------------------------------------------------------------------------------
local Gossip = SUI:NewFeature("General.Gossip", {
    category = "general",
    toggle = "automation.gossip",
})

function Gossip:OnEnable()
    if not (C_GossipInfo and C_GossipInfo.GetOptions and C_GossipInfo.GetActiveQuests) then
        return
    end
    self:RegisterEvent("GOSSIP_SHOW", "OnGossip")
    self:RegisterEvent("GOSSIP_CLOSED", function(feature)
        feature.lastOption = nil
    end)
end

function Gossip:OnGossip()
    local info = C_GossipInfo
    if IsModifierKeyDown() or #info.GetActiveQuests() > 0 or #info.GetAvailableQuests() > 0 then
        return
    end
    local options = info.GetOptions()
    if #options ~= 1 then
        return
    end
    local id = options[1].gossipOptionID
    -- never pick the same option twice in a row (NPCs that reopen the same page)
    if not id or id == self.lastOption then
        return
    end
    self.lastOption = id
    info.SelectOption(id)
end
