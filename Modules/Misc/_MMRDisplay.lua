local Module = SUI:NewModule("Misc.MMRDisplay");

function Module:OnEnable()
    local db = {
        mmr = SUI.db.profile.misc.mmr,
        module = SUI.db.profile.modules.misc
    }

    if (db.mmr and db.module) then
        -- Variables
        local alreadyUpdated = false
        local font = STANDARD_TEXT_FONT

        -- Create FontStrings
        WorldStateScoreFrame:CreateFontString("SUI_MMRDisplay_Team1", "OVERLAY")
        WorldStateScoreFrame:CreateFontString("SUI_MMRDisplay_Team2", "OVERLAY")

        -- Position MMR Texts
        SUI_MMRDisplay_Team1:SetPoint("LEFT", WorldStateScoreFrameLeaveButton, "LEFT", 35, 40)
        SUI_MMRDisplay_Team2:SetPoint("LEFT", WorldStateScoreFrameLeaveButton, "LEFT", 35, 25)

        -- Set Text Colors
        SUI_MMRDisplay_Team1:SetTextColor(0.74, 0.40, 1)
        SUI_MMRDisplay_Team2:SetTextColor(1, 0.83, 0)

        -- Set Font Size
        SUI_MMRDisplay_Team1:SetFont(font, 16, "OUTLINE")
        SUI_MMRDisplay_Team2:SetFont(font, 16, "OUTLINE")

        local function mmrDisplay()
            -- Check if Text Update and Prints have already been done
            if (alreadyUpdated) then return end
            for i = 0, 1 do
                local _, _, _, teamMMR = GetBattlefieldTeamInfo(i)
                if teamMMR > 0 then
                    if i == 0 then
                        SUI_MMRDisplay_Team1:SetText("MMR: " .. teamMMR)
                        print("|cffff00d5S|r|cff027bffUI|r: |cffbd67ffMMR - " .. teamMMR .. "|r")
                    else
                        SUI_MMRDisplay_Team2:SetText("MMR: " .. teamMMR)
                        print("|cffff00d5S|r|cff027bffUI|r: |cffffd500MMR - " .. teamMMR .. "|r")
                    end
                end
            end
        end

        function SUI_MMRDisplayTest()
            -- Set Justify
            SUI_MMRDisplay_Team1:SetJustifyH("LEFT")
            SUI_MMRDisplay_Team2:SetJustifyH("LEFT")

            -- Example Texts
            SUI_MMRDisplay_Team1:SetText("MMR: 2039")
            SUI_MMRDisplay_Team2:SetText("MMR: 2051")

            -- Example Prints
            print("|cff00d5S|r|cff027bffUI|r: |cffbd67ffMMR - 2039|r")
            print("|cff00d5S|r|cff027bffUI|r: |cffffd500MMR - 2051|r")

            WorldStateScoreFrame:Show()
            WorldStateScoreFrameLeaveButton:Show()
        end

        local updateFrame = CreateFrame("Frame")
        updateFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        updateFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
        updateFrame:HookScript("OnEvent", function(_, event)
            if (event == "PLAYER_ENTERING_WORLD") then
                alreadyUpdated = false
            elseif (event == "UPDATE_BATTLEFIELD_SCORE") then
                mmrDisplay()
                alreadyUpdated = true
            end
        end)
    end
end