local Module = SUI:NewModule("Skins.RaidFrame");

function Module:OnEnable()
    if (SUI:Color()) then
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
        end)

        CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidPanel-Toggle")

		hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
            if self:IsForbidden() then return end
            if self and self:GetName() then
                local name = self:GetName()
                if name and name:match("^Compact") then
                    SUI:Skin({
                        self.horizDivider
                    }, false, true)

                    for g = 1, NUM_RAID_GROUPS do
                        local group = _G["CompactRaidGroup" .. g .. "BorderFrame"]
                        if group then
                            SUI:Skin(group)
                        end
                    end
                end
            end
		end)
    end
end
