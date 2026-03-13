local Module = SUI:NewModule("Skins.Damagemeter");

function Module:OnEnable()
    if (SUI:Color()) then
        local hooksInstalled = false

        local function SkinDamageEntry(frame)
            if not frame or (frame.IsForbidden and frame:IsForbidden()) then
                return
            end

            local statusBar = frame.StatusBar or frame
            if not statusBar then
                return
            end

            local objects = {}
            if statusBar.BackgroundEdge then
                objects[#objects + 1] = statusBar.BackgroundEdge
            end
            if statusBar.Background then
                objects[#objects + 1] = statusBar.Background
            end

            if #objects > 0 then
                SUI:Skin(objects, true)
            end

            if statusBar.Background then
                statusBar.Background:SetAlpha(0)
            end

            if statusBar.BackgroundEdge then
                statusBar.BackgroundEdge:Show()
            end

            local texture = SUI.db.profile.general.texture
            if texture and texture ~= [[Interface\Default]] and frame.SetStatusBarTexture and frame.GetStatusBarTexture then
                frame:SetStatusBarTexture(texture)

                local barTexture = frame:GetStatusBarTexture()
                if barTexture and barTexture.SetDrawLayer then
                    barTexture:SetDrawLayer("BORDER")
                end
            end
        end

        local function SkinDamageWindows()
            if not DamageMeter then
                return
            end

            for i = 1, 3 do
                local frame = _G["DamageMeterSessionWindow" .. i]
                if frame then
                    SUI:Skin(frame, true)
                    if frame.Header then
                        SUI:Skin(frame.Header, true)
                    end

                    if frame.EnumerateEntryFrames then
                        for _, entry in frame:EnumerateEntryFrames() do
                            SkinDamageEntry(entry)
                        end
                    end
                end
            end
        end

        local function InstallHooks()
            if hooksInstalled or not DamageMeter then
                return
            end

            if DamageMeter.GetSessionWindow then
                hooksecurefunc(DamageMeter, "GetSessionWindow", SkinDamageWindows)
            end

            if DamageMeterEntryMixin and DamageMeterEntryMixin.Init then
                hooksecurefunc(DamageMeterEntryMixin, "Init", SkinDamageEntry)
            end

            hooksInstalled = true
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_DamageMeter" then
                InstallHooks()
                SkinDamageWindows()
            end
        end)

        if C_AddOns.IsAddOnLoaded("Blizzard_DamageMeter") then
            InstallHooks()
            SkinDamageWindows()
        end
    end
end
