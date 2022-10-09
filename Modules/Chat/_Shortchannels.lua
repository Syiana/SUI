local Module = SUI:NewModule("Chat.Shortchannels");

function Module:OnEnable()
    local db = SUI.db.profile.chat.shortchannels
    if (db) then
        local rplc = {"[G]","[T]","[WD]","[LD]","[LFG]","[GR]","[i]","[IL]","[G]","[P]","[PL]","[PL]","[O]","[R]","[RL]","[RW]","[%1]"}
        local gsub = gsub
        local time = _G.time
        local newAddMsg = {}
        local chn = {
            "%[%d%d?%. General[^%]]*%]",
            "%[%d%d?%. Trade[^%]]*%]",
            "%[%d%d?%. WorldDefense[^%]]*%]",
            "%[%d%d?%. LocalDefense[^%]]*%]",
            "%[%d%d?%. LookingForGroup[^%]]*%]",
            "%[%d%d?%. GuildRecruitment[^%]]*%]",
            gsub(CHAT_INSTANCE_CHAT_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_INSTANCE_CHAT_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
            "%[(%d%d?)%. ([^%]]+)%]"
        }
        local AddMessage = function(frame, text, ...)
            for i = 1, 17 do
                text = gsub(text, chn[i], rplc[i])
            end
            text = gsub(text, "%[(%d0?)%. .-%]", "[%1]")
            return newAddMsg[frame:GetName()](frame, text, ...)
        end

        for i = 1, NUM_CHAT_WINDOWS do
            local f = "ChatFrame"..i
            if i ~= 2 then -- skip combatlog
                newAddMsg[f] = _G[f].AddMessage
                _G[f].AddMessage = AddMessage    
            end
        end
    end
end