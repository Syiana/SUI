local ADDON, SUI = ...
SUI.MODULES.ACTIONBAR.Buttons = function(DB) 
    if (DB.STATE) then
        local dominos = IsAddOnLoaded("Dominos")
        local bartender = IsAddOnLoaded("Bartender4")

        if IsAddOnLoaded("Masque") and (dominos or bartender) then
            return
        end
        
        --CONFIG
        local config = {
            font = STANDARD_TEXT_FONT,
            textures = {
                normal = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\gloss",
                flash = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\flash",
                hover = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\hover",
                pushed = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\pushed",
                checked = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\checked",
                equipped = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\gloss_grey",
                buttonback = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\button_background",
                buttonbackflat = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\button_background_flat",
                outer_shadow = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\outer_shadow"
            },
            backdrop = {
                bgFile = "",
                edgeFile = "Interface\\AddOns\\SUI\\inc\\assets\\media\\core\\outer_shadow",
                tile = false,
                tileSize = 32,
                edgeSize = 5,
                insets = {
                    left = 5,
                    right = 5,
                    top = 5,
                    bottom = 5
                }
            },
            background = {
                showbg = true,
                showshadow = true,
                useflatbackground = false,
                backgroundcolor = {r = 0.2, g = 0.2, b = 0.2, a = 0.3},
                shadowcolor = {r = 0, g = 0, b = 0, a = 0.9},
                classcolored = false,
                inset = 5
            },
            color = {
                maincolor = {r = 0.37, g = 0.3, b = 0.3},
                normal = {r = 0.37, g = 0.3, b = 0.3},
                equipped = {r = 0.1, g = 0.5, b = 0.1},
                classcolored = false
            },
        }

            local StatusTexture = CreateFrame("frame")
            StatusTexture:RegisterEvent("PLAYER_ENTERING_WORLD")
            StatusTexture:SetScript("OnEvent", function(self,event)
                local st = { StatusTrackingBarManager:GetChildren() }
                for _,s in pairs(st) do
                   for k,v in pairs(s) do
                      if k == "StatusBar" then
                         v:SetStatusBarTexture("Interface\\Addons\\SUI\\inc\\assets\\media\\unitframes\\UI-StatusBar")
                      end
                   end
                end
            end)

        local function applyBackground(bu)
            if not bu or (bu and bu.bg) then
                return
            end

            if bu:GetFrameLevel() < 1 then
                bu:SetFrameLevel(1)
            end
            bu.bg = CreateFrame("Frame", nil, bu, "BackdropTemplate")

            bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
            bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
            bu.bg:SetFrameLevel(bu:GetFrameLevel() - 1)
            if config.background.showbg and not config.background.useflatbackground then
                local t = bu.bg:CreateTexture(nil, "BACKGROUND", -8)
                t:SetTexture(config.textures.buttonback)

                t:SetVertexColor(
                    config.background.backgroundcolor.r,
                    config.background.backgroundcolor.g,
                    config.background.backgroundcolor.b,
                    config.background.backgroundcolor.a
                )
            end
            bu.bg:SetBackdrop(config.backdrop)
   
            if config.background.showshadow then
                bu.bg:SetBackdropBorderColor(
                    config.background.shadowcolor.r,
                    config.background.shadowcolor.g,
                    config.background.shadowcolor.b,
                    config.background.shadowcolor.a
                )
            end
        end

        local function styleExtraActionButton(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local name = bu:GetName() or bu:GetParent():GetName()
            local style = bu.style or bu.Style
            local icon = bu.icon or bu.Icon
            local cooldown = bu.cooldown or bu.Cooldown
            local ho = _G[name .. "HotKey"]

            style:SetTexture(nil)
            hooksecurefunc(
                style,
                "SetTexture",
                function(self, texture)
                    if texture then
                        self:SetTexture(nil)
                    end
                end
            )

            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            cooldown:SetAllPoints(icon)

            if ho then
                ho:Hide()
            end

            bu:SetNormalTexture(config.textures.normal)
            local nt = bu:GetNormalTexture()
            nt:SetVertexColor(SUIDB.color.normal.r, SUIDB.color.normal.g, SUIDB.color.normal.b, 1)
            nt:SetAllPoints(bu)
            bu.Back = CreateFrame("Frame", nil, bu, "BackdropTemplate")
            bu.Back:SetPoint("TOPLEFT", bu, "TOPLEFT", -3, 3)
            bu.Back:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 3, -3)
            bu.Back:SetFrameLevel(bu:GetFrameLevel() - 1)
            bu.Back:SetBackdrop(backdrop)
            bu.Back:SetBackdropBorderColor(0, 0, 0, 0.9)
            bu.rabs_styled = true
        end

        local function styleActionButton(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local action = bu.action
            local name = bu:GetName()
            local ic = _G[name .. "Icon"]
            local co = _G[name .. "Count"]
            local bo = _G[name .. "Border"]
            local ho = _G[name .. "HotKey"]
            local cd = _G[name .. "Cooldown"]
            local na = _G[name .. "Name"]
            local fl = _G[name .. "Flash"]
            local nt = _G[name .. "NormalTexture"]
            local fbg = _G[name .. "FloatingBG"]
            local fob = _G[name .. "FlyoutBorder"]
            local fobs = _G[name .. "FlyoutBorderShadow"]
            if fbg then
                fbg:Hide()
            end
            if fob then
                fob:SetTexture(nil)
            end
            if fobs then
                fobs:SetTexture(nil)
            end
            bo:SetTexture(nil)
            --ho:SetFont(FONT, 12, "OUTLINE")
            ho:ClearAllPoints()
            ho:SetPoint("TOPRIGHT", bu)
            ho:SetPoint("TOPLEFT", bu)
            if not dominos and not bartender4 and (SUIDB.ACTIONBAR.HotKeys) then
                ho:Hide()
            end
            --na:SetFont(FONT, 12, "OUTLINE")
            na:ClearAllPoints()
            na:SetPoint("BOTTOMLEFT", bu)
            na:SetPoint("BOTTOMRIGHT", bu)
            if not dominos and not bartender4 and not SUIDB.ACTIONBAR.Macros == false then
                na:Hide()
            end
            --co:SetFont(FONT, 12, "OUTLINE")
            co:ClearAllPoints()
            co:SetPoint("BOTTOMRIGHT", bu)
            if not dominos and not bartender4 then
                --co:Hide()
            end

            fl:SetTexture(config.textures.flash)
            bu:SetPushedTexture(config.textures.pushed)
            bu:SetNormalTexture(config.textures.normal)
            if not nt then
                nt = bu:GetNormalTexture()
            end
            ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            cd:SetPoint("TOPLEFT", bu, "TOPLEFT")
            cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT")
            if action and IsEquippedAction(action) then
                nt:SetVertexColor(config.color.equipped.r, config.color.equipped.g, config.color.equipped.b, 1)
            else
                bu:SetNormalTexture(config.textures.normal)
                nt:SetVertexColor(config.color.normal.r, config.color.normal.g, config.color.normal.b, 1)
            end
            nt:SetAllPoints(bu)
            hooksecurefunc(
                nt,
                "SetVertexColor",
                function(nt, r, g, b, a)
                    local bu = nt:GetParent()
                    local action = bu.action
                    if r == 1 and g == 1 and b == 1 and action and (IsEquippedAction(action)) then
                        if config.color.equipped.r == 1 and config.color.equipped.g == 1 and config.color.equipped.b == 1 then
                            nt:SetVertexColor(0.999, 0.999, 0.999, 1)
                        else
                            nt:SetVertexColor(config.color.equipped.r, config.color.equipped.g, config.color.equipped.b, 1)
                        end
                    elseif r == 0.5 and g == 0.5 and b == 1 then
                        if SUIDB.color.normal.r == 0.5 and config.color.normal.g == 0.5 and config.color.normal.b == 1 then
                            nt:SetVertexColor(0.499, 0.499, 0.999, 1)
                        else
                            nt:SetVertexColor(config.color.normal.r, config.color.normal.g, config.color.normal.b, 1)
                        end
                    elseif r == 1 and g == 1 and b == 1 then
                        if config.color.normal.r == 1 and config.color.normal.g == 1 and config.color.normal.b == 1 then
                            nt:SetVertexColor(0.999, 0.999, 0.999, 1)
                        else
                            nt:SetVertexColor(config.color.normal.r, config.color.normal.g, config.color.normal.b, 1)
                        end
                    end
                end
            )
            if not bu.bg then
                applyBackground(bu)
            end
            bu.rabs_styled = true
            if bartender4 then
                nt:SetTexCoord(0, 1, 0, 1)
                nt.SetTexCoord = function()
                    return
                end
                bu.SetNormalTexture = function()
                    return
                end
            end
            
        end

        local function styleLeaveButton(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local name = bu:GetName()
            local nt = bu:GetNormalTexture()
            local bo = bu:CreateTexture(name .. "Border", "BACKGROUND", nil, -7)
            nt:SetTexCoord(0.2, 0.8, 0.2, 0.8)
            nt:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            nt:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            bo:SetTexture(config.textures.normal)
            bo:SetTexCoord(0, 1, 0, 1)
            bo:SetDrawLayer("BACKGROUND", -7)
            bo:SetVertexColor(0.4, 0.35, 0.35)
            bo:ClearAllPoints()
            bo:SetAllPoints(bu)
            if not bu.bg then
                applyBackground(bu)
            end
            bu.rabs_styled = true
        end

        local function stylePetButton(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local name = bu:GetName()
            local ic = _G[name .. "Icon"]
            local fl = _G[name .. "Flash"]
            local nt = _G[name .. "NormalTexture2"]
            nt:SetAllPoints(bu)
            nt:SetVertexColor(config.color.normal.r, config.color.normal.g, config.color.normal.b, 1)
            fl:SetTexture(config.textures.flash)
            bu:SetPushedTexture(config.textures.pushed)
            bu:SetNormalTexture(config.textures.normal)
            hooksecurefunc(
                bu,
                "SetNormalTexture",
                function(self, texture)
                    if texture and texture ~= config.textures.normal then
                        self:SetNormalTexture(config.textures.normal)
                    end
                end
            )
            ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            if not bu.bg then
                applyBackground(bu)
            end
            bu.rabs_styled = true
        end

        local function styleStanceButton(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local name = bu:GetName()
            local ic = _G[name .. "Icon"]
            local fl = _G[name .. "Flash"]
            local nt = _G[name .. "NormalTexture2"]
            nt:SetAllPoints(bu)
            nt:SetVertexColor(config.color.normal.r, config.color.normal.g, config.color.normal.b, 1)
            fl:SetTexture(config.textures.flash)
            bu:SetPushedTexture(config.textures.pushed)
            bu:SetNormalTexture(config.textures.normal)
            ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            if not bu.bg then
                applyBackground(bu)
            end
            bu.rabs_styled = true
        end

        local function stylePossessButton(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local name = bu:GetName()
            local ic = _G[name .. "Icon"]
            local fl = _G[name .. "Flash"]
            local nt = _G[name .. "NormalTexture"]
            nt:SetAllPoints(bu)
            nt:SetVertexColor(config.color.normal.r, config.color.normal.g, config.color.normal.b, 1)
            fl:SetTexture(config.textures.flash)
            bu:SetPushedTexture(config.textures.pushed)
            bu:SetNormalTexture(config.textures.normal)
            ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            if not bu.bg then
                applyBackground(bu)
            end
            bu.rabs_styled = true
        end

        local function styleBag(bu)
            if not bu or (bu and bu.rabs_styled) then
                return
            end
            local name = bu:GetName()
            local ic = _G[name .. "IconTexture"]
            local nt = _G[name .. "NormalTexture"]
            nt:SetTexCoord(0, 1, 0, 1)
            nt:SetDrawLayer("BACKGROUND", -7)
            nt:SetVertexColor(0.4, 0.35, 0.35)
            nt:SetAllPoints(bu)
            local bo = bu.IconBorder
            bo:Hide()
            bo.Show = function()
            end
            ic:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
            ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
            bu:SetNormalTexture(config.textures.normal)
            bu:SetPushedTexture(config.textures.pushed)
            hooksecurefunc(bu,"SetNormalTexture",function(self, texture)
                if texture and texture ~= config.textures.normal then
                    self:SetNormalTexture(config.textures.normal)
                end
            end)
            bu.Back = CreateFrame("Frame", nil, bu, "BackdropTemplate")
            bu.Back:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
            bu.Back:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
            bu.Back:SetFrameLevel(bu:GetFrameLevel() - 1)
            bu.Back:SetBackdrop(backdrop)
            bu.Back:SetBackdropBorderColor(0, 0, 0, 0.9)
        end

        local function updateHotkey(self, actionButtonType)
            local ho = _G[self:GetName() .. "HotKey"]
            if ho and ho:IsShown() then
                ho:Hide()
            end
        end

        local function init()
            for i = 1, NUM_ACTIONBAR_BUTTONS do
                styleActionButton(_G["ActionButton" .. i])
                styleActionButton(_G["MultiBarBottomLeftButton" .. i])
                styleActionButton(_G["MultiBarBottomRightButton" .. i])
                styleActionButton(_G["MultiBarRightButton" .. i])
                styleActionButton(_G["MultiBarLeftButton" .. i])
            end
            for i = 0, 3 do
                styleBag(_G["CharacterBag" .. i .. "Slot"])
            end
            styleBag(MainMenuBarBackpackButton)
            for i = 1, 6 do
                styleActionButton(_G["OverrideActionBarButton" .. i])
            end
            styleLeaveButton(MainMenuBarVehicleLeaveButton)
            styleLeaveButton(rABS_LeaveVehicleButton)
            for i = 1, NUM_PET_ACTION_SLOTS do
                stylePetButton(_G["PetActionButton" .. i])
            end
            for i = 1, NUM_STANCE_SLOTS do
                styleStanceButton(_G["StanceButton" .. i])
            end
            for i = 1, NUM_POSSESS_SLOTS do
                stylePossessButton(_G["PossessButton" .. i])
            end

            styleExtraActionButton(ExtraActionButton1)
            styleExtraActionButton(ZoneAbilityFrame.SpellButton)
            SpellFlyoutBackgroundEnd:SetTexture(nil)
            SpellFlyoutHorizontalBackground:SetTexture(nil)
            SpellFlyoutVerticalBackground:SetTexture(nil)
            local function checkForFlyoutButtons(self)
                local NUM_FLYOUT_BUTTONS = 10
                for i = 1, NUM_FLYOUT_BUTTONS do
                    styleActionButton(_G["SpellFlyoutButton" .. i])
                end
            end
            SpellFlyout:HookScript("OnShow", checkForFlyoutButtons)

            if dominos then
                for i = 1, 60 do
                    styleActionButton(_G["DominosActionButton" .. i])
                end
            end
            if bartender then
                for i = 1, 120 do
                    styleActionButton(_G["BT4Button" .. i])
                    stylePetButton(_G["BT4PetButton" .. i])
                end
            end

            if not dominos and not bartender and (SUIDB.ACTIONBAR.HotKeys) then
                hooksecurefunc("ActionButton_UpdateHotkeys", updateHotkey)
            end
        end

        init()
    end
end