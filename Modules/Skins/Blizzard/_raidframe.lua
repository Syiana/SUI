local Module = SUI:NewModule("Skins.RaidFrame");

function Module:OnEnable()
    if (SUI:Color()) then
        for i = 1, 5 do
            local frame = _G["CompactRaidFrame" .. i .. "HorizDivider"]
            if frame then
                SUI:Skin({frame}, false, true)
            end
        end

        local frame = CreateFrame("Frame")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:SetScript("OnEvent", function(self, event)
            SUI:Skin(CompactRaidFrameContainerBorderFrame)
            SUI:Skin(CompactRaidFrameManager)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameProfileSelector)
            SUI:Skin(CompactRaidFrameManagerContainerResizeFrame)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameConvertToRaid)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameLockedModeToggle)
            SUI:Skin(CompactRaidFrameManagerDisplayFrameHiddenModeToggle)

            for g = 1, NUM_RAID_GROUPS do
                local group = _G["CompactRaidGroup" .. g .. "BorderFrame"]
                if group then
                    SUI:Skin(group)
                end
                
                for m = 1, 5 do
                    local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
                    if frame then
                        SUI:Skin({
                            _G[frame .. "horizTopBorder"],
                            _G[frame .. "horizBottomBorder"],
                            _G[frame .. "vertLeftBorder"],
                            _G[frame .. "vertRightBorder"],
                            _G[frame .. "horizDivider"]
                        }, false, true)
                    end
                end
            end

            for i = 1, 40 do
                local frame = _G["CompactRaidFrame" .. i .. "HorizDivider"]
                if frame then
                    SUI:Skin({frame}, false, true)
                end
            end
        end)
        CompactRaidFrameManagerToggleButton:SetNormalTexture(
        "Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidPanel-Toggle")
        for i = 1, 4 do
            _G["PartyMemberFrame" .. i .. "PVPIcon"]:SetAlpha(0)
            _G["PartyMemberFrame" .. i .. "NotPresentIcon"]:Hide()
            _G["PartyMemberFrame" .. i .. "NotPresentIcon"].Show = function()
            end
        end
    end
end
