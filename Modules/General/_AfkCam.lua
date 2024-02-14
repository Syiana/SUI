local Module = SUI:NewModule("General.AfkCam");

function Module:OnEnable()
    local db = SUI.db.profile.general.cosmetic.afkscreen
    if (db) then
        local PName = UnitName("player")
        local PLevel = UnitLevel("player")
        local PClass = select(2, UnitClass("player"))
        local PRace = select(2, UnitRace("player"))
        local PFaction = UnitFactionGroup("player")
        local color = RAID_CLASS_COLORS[PClass]
        local PGuild = " "

        local font = STANDARD_TEXT_FONT
        local blank = [[Interface\AddOns\SUI\textures\blank.tga]]
        local normTex = [[Interface\AddOns\SUI\textures\normTex.tga]]

        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_GUILD_UPDATE")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")

        local function UpdateColor(t)
            if t == template then return end

            if t == "Transparent" then
                local balpha = 1
                if t == "Transparent" then balpha = 0.7 end
                local borderr, borderg, borderb = { .125, .125, .125 }
                local backdropr, backdropg, backdropb = { .05, .05, .05 }
                local backdropa = balpha
            end

            local template = t
        end

        local function SetTemplate(f, t, tex)
            if tex then
                local texture = normTex
            else
                local texture = blank
            end

            UpdateColor(t)
        end

        local function addapi(object)
            local mt = getmetatable(object).__index
            if not object.SetTemplate then mt.SetTemplate = SetTemplate end
        end

        local handled = { ["Frame"] = true }
        local object = CreateFrame("Frame")
        addapi(object)
        addapi(object:CreateTexture())
        addapi(object:CreateFontString())

        object = EnumerateFrames()
        while object do
            if not handled[object:GetObjectType()] then
                addapi(object)
                handled[object:GetObjectType()] = true
            end

            object = EnumerateFrames(object)
        end

        local AFKPanel = CreateFrame("Frame", "AFKPanel", nil)
        AFKPanel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -2, -2)
        AFKPanel:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", 2, 150)
        AFKPanel:SetTemplate("Transparent")
        AFKPanel:Hide()

        local AFKPanelTop = CreateFrame("Frame", "AFKPanelTop", nil)
        AFKPanelTop:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -2, 2)
        AFKPanelTop:SetPoint("BOTTOMRIGHT", UIParent, "TOPRIGHT", 2, -80)
        AFKPanelTop:SetTemplate("Transparent")
        AFKPanelTop:SetFrameStrata("FULLSCREEN")
        AFKPanelTop:Hide()

        AFKPanelTop.Text = AFKPanelTop:CreateFontString(nil, "OVERLAY")
        AFKPanelTop.Text:SetPoint("CENTER", AFKPanelTop, "CENTER", 0, 0)
        AFKPanelTop.Text:SetFont(font, 40, "OUTLINE")
        AFKPanelTop.Text:SetText("AFK")
        AFKPanelTop.Text:SetTextColor(color.r, color.g, color.b)

        AFKPanelTop.DateText = AFKPanelTop:CreateFontString(nil, "OVERLAY")
        AFKPanelTop.DateText:SetPoint("BOTTOMLEFT", AFKPanelTop, "BOTTOMRIGHT", -100, 44)
        AFKPanelTop.DateText:SetFont(font, 15, "OUTLINE")

        AFKPanelTop.ClockText = AFKPanelTop:CreateFontString(nil, "OVERLAY")
        AFKPanelTop.ClockText:SetPoint("BOTTOMLEFT", AFKPanelTop, "BOTTOMRIGHT", -100, 20)
        AFKPanelTop.ClockText:SetFont(font, 20, "OUTLINE")

        AFKPanelTop.PlayerNameText = AFKPanelTop:CreateFontString(nil, "OVERLAY")
        AFKPanelTop.PlayerNameText:SetPoint("LEFT", AFKPanelTop, "LEFT", 25, 19)
        AFKPanelTop.PlayerNameText:SetFont(font, 26, "OUTLINE")
        AFKPanelTop.PlayerNameText:SetText(PName)
        AFKPanelTop.PlayerNameText:SetTextColor(color.r, color.g, color.b)

        AFKPanel.Text = AFKPanelTop:CreateFontString(nil, "OVERLAY")
        AFKPanel.Text:SetPoint("CENTER", AFKPanel, "CENTER", 0, 15)
        AFKPanel.Text:SetFont(font, 110, "OUTLINE")
        AFKPanel.Text:SetText("|cffea00ffS|r|cff00a2ffUI|r")

        -- Set Up the Player Model
        AFKPanel.playerModel = CreateFrame('PlayerModel', nil, AFKPanel);
        AFKPanel.playerModel:SetSize(800, 1000)
        AFKPanel.playerModel:SetPoint("RIGHT", AFKPanel, "RIGHT", 250, 110)
        AFKPanel.playerModel:SetUnit('player');
        AFKPanel.playerModel:SetAnimation(0);
        AFKPanel.playerModel:SetRotation(math.rad(-15));
        AFKPanel.playerModel:SetCamDistanceScale(1.8);

        if IsInGuild() then
            frame:SetScript("OnEvent", function()
                if IsInGuild() then
                    local guildName = GetGuildInfo("player")

                    if guildName then
                        AFKPanelTop.GuildText = AFKPanelTop:CreateFontString(nil, "OVERLAY")
                        AFKPanelTop.GuildText:SetPoint("LEFT", AFKPanelTop, "LEFT", 25, -3)
                        AFKPanelTop.GuildText:SetFont(font, 15, "OUTLINE")
                        AFKPanelTop.GuildText:SetText("|cff0394ff" .. guildName .. "|r")
                    end
                end
            end)

            AFKPanelTop.PlayerInfoText = AFKPanelTop:CreateFontString(nil, "OVERLAY")
            AFKPanelTop.PlayerInfoText:SetPoint("LEFT", AFKPanelTop, "LEFT", 25, -20)
            AFKPanelTop.PlayerInfoText:SetFont(font, 15, "OUTLINE")
            AFKPanelTop.PlayerInfoText:SetText(LEVEL .. " " .. PLevel .. " " .. PFaction .. " " .. PClass)
        else
            AFKPanelTop.PlayerInfoText = AFKPanelTop:CreateFontString(nil, "OVERLAY")
            AFKPanelTop.PlayerInfoText:SetPoint("LEFT", AFKPanelTop, "LEFT", 25, -3)
            AFKPanelTop.PlayerInfoText:SetFont(font, 15, "OUTLINE")
            AFKPanelTop.PlayerInfoText:SetText(LEVEL .. " " .. PLevel .. " " .. PFaction .. " " .. PClass)
        end

        local interval = 0
        AFKPanelTop:SetScript("OnUpdate", function(self, elapsed)
            interval = interval - elapsed
            if (interval <= 0) then
                AFKPanelTop.ClockText:SetText(format("%s", date("%H:%M:%S")))
                AFKPanelTop.DateText:SetText(format("%s", date("%a %b/%d")))
                interval = 0.5
            end
        end)

        local isActive = false
        local OnEvent = function(self, event, unit)
            if event == "PLAYER_FLAGS_CHANGED" then
                local isArena, isRegistered = C_PvP.IsArena()
                if unit == "player" then
                    if UnitIsAFK(unit) and not UnitIsDead(unit) and not InCombatLockdown() and not isArena then
                        MoveViewRightStart(0.1)
                        AFKPanel:Show()
                        AFKPanelTop:Show()
                        Minimap:Hide()
                        isActive = true
                    elseif not UnitIsAFK(unit) and not InCombatLockdown() then
                        MoveViewRightStop()
                        AFKPanel:Hide()
                        AFKPanelTop:Hide()
                        Minimap:Show()
                        isActive = false
                    end
                end
            elseif event == "PLAYER_LEAVING_WORLD" then
                MoveViewRightStop()
            elseif event == "PLAYER_DEAD" then
                if UnitIsAFK("player") then
                    MoveViewRightStop()
                    AFKPanel:Hide()
                    AFKPanelTop:Hide()
                    Minimap:Show()
                end
            end
        end

        AFKPanel:RegisterEvent("PLAYER_ENTERING_WORLD")
        AFKPanel:RegisterEvent("PLAYER_LEAVING_WORLD")
        AFKPanel:RegisterEvent("PLAYER_FLAGS_CHANGED")
        AFKPanel:SetScript("OnEvent", OnEvent)
        AFKPanel:SetScript("OnShow", function(self)
            UIParent:SetAlpha(0);
            PartyFrame:Hide()
            CompactRaidFrameContainer:Hide()
        end)

        AFKPanel:SetScript("OnHide", function(self)
            UIFrameFadeOut(UIParent, 0.5, 0, 1)
            PartyFrame:Show()
            CompactRaidFrameContainer:Show()
        end)

        local leaveAFK = CreateFrame("Frame")
        leaveAFK:RegisterEvent("PLAYER_LEAVE_COMBAT")
        leaveAFK:RegisterEvent("PLAYER_REGEN_ENABLED")
        leaveAFK:SetScript("OnEvent", function()
            if isActive and not UnitIsAFK("player") then
                MoveViewRightStop()
                AFKPanel:Hide()
                AFKPanelTop:Hide()
                Minimap:Show()
                isActive = false
            end
        end)
    end
end
