local Module = SUI:NewModule("Skins.Achievment");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AchievementUI" then
                local function Skin(frame)
                    if frame then
                        SUI:Skin(frame, true)
                    end
                end

                Skin(AchievementFrame)
                Skin(AchievementFrame and AchievementFrame.Header)
                Skin(AchievementFrame and AchievementFrame.Searchbox)
                Skin(AchievementFrameSummary)
                Skin(AchievementFrameTab1)
                Skin(AchievementFrameTab2)
                Skin(AchievementFrameTab3)

                local header = AchievementFrame and AchievementFrame.Header
                if header then
                    if header.PointBorder then
                        header.PointBorder:SetAlpha(0)
                    end

                    for _, region in next, { header:GetRegions() } do
                        if region and region.SetVertexColor then
                            region:SetVertexColor(1, 1, 1)
                        end
                    end
                end

                self:UnregisterEvent("ADDON_LOADED")
            end
        end)
    end
end
