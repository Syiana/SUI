local Module = SUI:NewModule("UnitFrames.Links");

function Module:OnEnable()
    local db = {
        links = SUI.db.profile.unitframes.links,
        module = SUI.db.profile.modules.unitframes
    }

    if (db.links and db.module) then
        local regionNames = { 'us', 'kr', 'eu', 'tw', 'cn' }
        local region = regionNames[GetCurrentRegion()]

        local function fixServerName(server)
            if not (server) then return end
            server = server:gsub("'(%u)", function(c) return c:lower() end):gsub("'", ""):gsub("%u", "-%1"):gsub(
                "^[-%s]+", ""):gsub("[^%w%s%-]", ""):gsub("%s", "-"):lower():gsub("%-+", "-")
            return server
        end

        local function generateURL(type, name, server)
            local url

            if not (name or server) then
                print("|cffff00d5S|r|cff027bffUI|r: Cannot find player name to create character link.")
                return
            end

            local server = fixServerName(server) or fixServerName(GetNormalizedRealmName())
            if server == nil or server == "" then
                print("|cffff00d5S|r|cff027bffUI|r: Cannot find server to create character link.")
                return
            end

            if type == "warcraftlogs" then
                url = "https://vanilla.warcraftlogs.com/character/" .. region .. "/" .. server .. "/" .. name
            elseif type == "armory" then
                url = "https://www.classic-armory.org/character/" .. region .. "/vanilla/" .. server .. "/" .. name
            elseif type == "ironforge" then
                url = "https://ironforge.pro/pvp/player/" .. server .. "/" .. name
            end
            if not url then
                print("|cffff00d5S|r|cff027bffUI|r: Character Link does not exist.")
                return
            end
            return url
        end

        local function popupLink(type, name, server)
            local url = generateURL(type, name, server)
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

        Menu.ModifyMenu("MENU_UNIT_SELF", function(ownerRegion, rootDescription, contextData)
            local name, server = UnitNameUnmodified(contextData.unit)

            rootDescription:CreateDivider()
            rootDescription:CreateTitle("Character Links")
            rootDescription:CreateButton("WarcraftLogs",
                function()
                    popupLink("warcraftlogs", name, server)
                end)
            rootDescription:CreateButton("Armory",
                function()
                    popupLink("armory", name, server)
                end)
        end)

        Menu.ModifyMenu("MENU_UNIT_PLAYER", function(ownerRegion, rootDescription, contextData)
            local name, server = UnitNameUnmodified(contextData.unit)
            rootDescription:CreateDivider()
            rootDescription:CreateTitle("Character Links")
            rootDescription:CreateButton("WarcraftLogs",
                function()
                    popupLink("warcraftlogs", name, server)
                end)
            rootDescription:CreateButton("Armory",
                function()
                    popupLink("armory", name, server)
                end)
        end)
    end
end
