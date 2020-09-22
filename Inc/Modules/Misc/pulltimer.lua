--[[SUI PULLTIMER v1.0]]

local CF=CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)

if not SUIDB.MODULES.PULLTIMER == true then return end 

cancel = false
function PullOnChat(time)
    PULL = CreateFrame("FRAME", nil)
    cdtime = time + 1
    throttle = cdtime
    ending = false
    start = math.floor(GetTime())
    if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
        channel = "RAID"
        user = nil
    else
        channel = "WHISPER"
        user = UnitName("player")
    end
    PULL:SetScript(
        "OnUpdate",
        function()
            if cancel ~= true then
                if ending == true then
                    return
                end
                countdown = (start - math.floor(GetTime()) + cdtime)
                if (countdown + 1) == throttle and countdown >= 0 then
                    if countdown == 0 then
                        SendChatMessage("Pulling", channel, nil, user)
                        throttle = countdown
                        ending = true
                    elseif countdown == 1 then
                        SendChatMessage("Pre-pot", channel, nil, user)
                        throttle = countdown
                    elseif countdown < 10 and countdown > 5 then
                        throttle = countdown
                    elseif countdown == 10 then
                        SendChatMessage(countdown, channel, nil, user)
                        if IsAddOnLoaded("DBM-Core") then
                            SlashCmdList["DEADLYBOSSMODS"]("pull 10")
                        end
                        if IsAddOnLoaded("BigWigs_Plugins") then
                            SlashCmdList["BIGWIGSPULL"]("/pull 10")
                        end
                        throttle = countdown
                    else
                        SendChatMessage(countdown, channel, nil, user)
                        throttle = countdown
                    end
                end
            end
        end
    )
end
 --
--[[ Slash Handler ]] SlashCmdList["PULL"] = function()
    PullOnChat(10)
end
SLASH_PULL1 = "/pull"

end)