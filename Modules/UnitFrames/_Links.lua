local Module = SUI:NewModule("UnitFrames.Links");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.links
    if (db) then
        local regionNames = { 'us', 'kr', 'eu', 'tw', 'cn' }
        local region = regionNames[GetCurrentRegion()]

        local function fixServerName(server)
            if not (server) then return end
            server = server:gsub("'(%u)", function(c) return c:lower() end):gsub("'", ""):gsub("%u", "-%1"):gsub(
                "^[-%s]+", ""):gsub("[^%w%s%-]", ""):gsub("%s", "-"):lower():gsub("%-+", "-")
            return server
        end

        local function generateURL(type, dropdownMenu)
            local url
            local name
            if dropdownMenu and dropdownMenu.name then
                name = dropdownMenu.name:lower()
            else
                print("|cffff00d5S|r|cff027bffUI|r: Cannot find player name to create character link.")
                return
            end

            local server = fixServerName(dropdownMenu.server) or fixServerName(GetNormalizedRealmName())
            if server == nil or server == "" then
                print("|cffff00d5S|r|cff027bffUI|r: Cannot find server to create character link.")
                return
            end

            if type == "warcraftlogs" then
                url = "https://classic.warcraftlogs.com/character/" .. region .. "/" .. server .. "/" .. name
            elseif type == "armory" then
                url = "https://www.classic-armory.org/character/" .. region .. "/cataclysm/" .. server .. "/" .. name
            elseif type == "ironforge" then
                url = "https://ironforge.pro/pvp/player/" .. server .. "/" .. name
            end
            if not url then
                print("|cffff00d5S|r|cff027bffUI|r: Character Link does not exist.")
                return
            end
            return url
        end

        local function popupLink(self)
            local url = generateURL(self.value, _G["UIDROPDOWNMENU_INIT_MENU"])
            if not url then return end
            StaticPopupDialogs["SUIpopup"] = nil
            StaticPopupDialogs["SUIpopup"] = {

                text = "|cffff00d5S|r|cff027bffUI|r\n\n|cffffcc00Copy the link below ( CTRL + C )|r",
                button1 = CLOSE,
                whileDead = true,
                hideOnEscape = true,
                hasEditBox = true,
                editBoxWidth = #url * 6.5,
                EditBoxOnEscapePressed = function(self)
                    self:GetParent():Hide()
                end,
                OnShow = function(self, data)
                    self.editBox:SetText(data.url)
                    self.editBox:HighlightText()
                    self.editBox:SetScript("OnKeyDown", function(_, key)
                        if key == "C" and IsControlKeyDown() then
                            C_Timer.After(0.3, function()
                                self.editBox:GetParent():Hide()
                                UIErrorsFrame:AddMessage("Link copied to clipboard")
                            end)
                        end
                    end)
                end,
            }
            StaticPopup_Show("SUIpopup", "", "", { url = url })
        end

        hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which)
            if (UIDROPDOWNMENU_MENU_LEVEL > 1) then
                return
            end
            if which == "TARGET" or which == "PET" or which == "OTHERPET" then
                return
            end

            local info = UIDropDownMenu_CreateInfo()
            local separatorInfo = {
                hasArrow = false,
                dist = 0,
                isTitle = true,
                isUninteractable = true,
                notCheckable = true,
                iconOnly = true,
                icon = "Interface\\Common\\UI-TooltipDivider-Transparent",
                tCoordLeft = 0,
                tCoordRight = 1,
                tCoordTop = 0,
                tCoordBottom = 1,
                tSizeX = 0,
                tSizeY = 8,
                tFitDropDownSizeX = true,
                iconInfo = {
                    tCoordLeft = 0,
                    tCoordRight = 1,
                    tCoordTop = 0,
                    tCoordBottom = 1,
                    tSizeX = 0,
                    tSizeY = 8,
                    tFitDropDownSizeX = true
                }
            }

            UIDropDownMenu_AddButton(separatorInfo);

            info.text = "Character Links"
            info.isTitle = true
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info)

            info = UIDropDownMenu_CreateInfo()
            info.isTitle = false
            info.owner = which
            info.notCheckable = 1
            info.func = popupLink

            info.text = "WarcraftLogs"
            info.value = "warcraftlogs"
            UIDropDownMenu_AddButton(info)

            info.text = "Armory"
            info.value = "armory"
            UIDropDownMenu_AddButton(info)

            info.text = "Ironforge"
            info.value = "ironforge"
            UIDropDownMenu_AddButton(info)
        end)
    end
end
