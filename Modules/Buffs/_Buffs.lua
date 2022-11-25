local Buffs = SUI:NewModule("Buffs.Buffs");

function Buffs:OnEnable()
    if IsAddOnLoaded("BlizzBuffsFacade") then return end

    local db = SUI.db.profile.unitframes.buffs
    local theme = SUI.db.profile.general.theme

    local function UpdateDuration(self, timeLeft)
        if timeLeft >= 86400 then
            self.duration:SetFormattedText("%dd", ceil(timeLeft / 86400))
        elseif timeLeft >= 3600 then
            self.duration:SetFormattedText("%dh", ceil(timeLeft / 3600))
        elseif timeLeft >= 60 then
            self.duration:SetFormattedText("%dm", ceil(timeLeft / 60))
        else
            self.duration:SetFormattedText("%ds", timeLeft)
        end
    end

    local function ButtonDefault(button)
        local Backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 6,
            insets = { left = 6, right = 6, top = 6, bottom = 6 },
        }

        local icon = button.Icon

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth() + 4, icon:GetHeight() + 4)
        border:SetPoint("CENTER", button, "CENTER", 0, 5)

        border.texture = border:CreateTexture()
        border.texture:SetAllPoints()
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
        border.texture:SetTexCoord(0, 1, 0, 1)
        border.texture:SetDrawLayer("BACKGROUND", -7)
        border.texture:SetVertexColor(0.4, 0.35, 0.35)

        border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
        border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
        border.shadow:SetBackdrop(Backdrop)
        border.shadow:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))

        button.SUIBorder = border
    end

    local function ButtonBackdrop(button)
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
        border:SetPoint("CENTER", button, "CENTER", 0, 5)

        local shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
        shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
        shadow:SetBackdrop(Backdrop)
        shadow:SetBackdropBorderColor(0, 0, 0)

        button.SUIBorder = border
    end

    local function ButtonBordered(button)

    end

    function updateBuffs()
        local Children = { BuffFrame.AuraContainer:GetChildren() }

        for index, child in pairs(Children) do
            local frame = select(index, BuffFrame.AuraContainer:GetChildren())
            local icon = frame.Icon
            local duration = frame.duration
            local count = frame.count

            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if frame.Border then frame.Border:Hide() end

            -- Set Stack Font size and reposition it
            if count then
                count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                count:ClearAllPoints()
                count:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
            end

            -- Set Duration Font size and reposition it
            duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            duration:ClearAllPoints()
            duration:SetPoint("CENTER", frame, "BOTTOM", 0, 15)
            duration:SetDrawLayer("OVERLAY")

            if frame.SUIBorder == nil then
                ButtonDefault(frame)
            end
        end
    end

    if theme ~= 'Blizzard' then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterUnitEvent("UNIT_AURA", "player")
        frame:RegisterEvent("WEAPON_ENCHANT_CHANGED")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnEvent", updateBuffs)
    end

    -- Collapse Button
    if not db.collapse then
        local hideCollapse = CreateFrame("Frame")
        hideCollapse:RegisterEvent("PLAYER_ENTERING_WORLD")
        hideCollapse:RegisterUnitEvent("UNIT_AURA", "player")
        hideCollapse:SetScript("OnEvent", function()
            BuffFrame.CollapseAndExpandButton:Hide()
        end)

        hooksecurefunc(C_EditMode, "OnEditModeExit", function()
            BuffFrame.CollapseAndExpandButton:Hide()
        end)
    end

    hooksecurefunc(BuffButtonMixin, "UpdateDuration", UpdateDuration)
    hooksecurefunc(TempEnchantButtonMixin, "UpdateDuration", UpdateDuration)
end
