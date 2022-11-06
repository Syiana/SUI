local Buffs = SUI:NewModule("Buffs.Buffs")

function Buffs:OnEnable()
    local hooked = {}

    function UpdateBuffStyling(pool)
        for frame, _ in pairs(pool.activeObjects) do
            if not hooked[frame] then
                hooked[frame] = true

                local icon = frame.Icon
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                if frame.Border then frame.Border:Hide() end
                frame.duration:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")

                if BuffFrame.exampleAuraFrames == nil then
                    hooksecurefunc(frame, "UpdateDuration", function(self)
                        
                        local durationText = self.duration:GetText()
                        if durationText ~= nil then
                            if strfind(durationText, " ") then
                                self.duration:SetText(gsub(durationText, " ", ""))
                            end
                        end

                        local count = self.count
                        if count ~= nil then
                            count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                            count:ClearAllPoints()
                            count:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -2)
                        end

                        self.duration:ClearAllPoints()
                        self.duration:SetPoint("CENTER", frame, "BOTTOM", 0, 15)
                        self.duration:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
                    end)
                end
                
                ButtonBackdrop(frame)
            end
        end
    end
    
    for _, pool in pairs(BuffFrame.auraPool.pools) do
        hooksecurefunc(pool, "Acquire", UpdateBuffStyling)
    end

    EditModeManagerFrame:HookScript("OnShow", function()
        hooksecurefunc(BuffFrame, "UpdateAuraButtons", function() end)
    end)

    function ButtonDefault(button)
        local Backdrop = {
            bgFile = "",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 5,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        }
        local icon = button.Icon

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth() + 5, icon:GetHeight() + 6)
        border:SetPoint("CENTER", button, "CENTER", 1, 5)

        border.texture = border:CreateTexture(nil, "Border")
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\UIActionBar")
        border.texture:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        border.texture:SetVertexColor(0, 0, 0)
        border.texture:SetAllPoints()

        local shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        shadow:SetSize(icon:GetWidth(), icon:GetHeight())
        shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -2, 2)
        shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 1, -1)
        shadow:SetFrameLevel(button:GetFrameLevel() - 1)
        shadow:SetBackdrop(Backdrop)
        shadow:SetBackdropBorderColor(0, 0, 0)
    end

    function ButtonBackdrop(button)
        local Backdrop = {
            bgFile = "",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 5,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        }

        local icon = button.Icon
        local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth(), icon:GetHeight())
        border:SetPoint("CENTER", button, "CENTER", 0, 0)

        border.texture = border:CreateTexture(nil, "Border")
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\Normal_N")
        border.texture:SetVertexColor(0, 0, 0)
        border.texture:SetSize(40, 40)
        border.texture:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs + 5)

        --border.texture:SetAllPoints()
    end

    function ButtonBorder(Button)

    end
end