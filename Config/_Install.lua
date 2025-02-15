local Module = SUI:NewModule("Config.Install");

function Module:OnEnable()
    if not (SUI.db.profile.install) then
        local Install = CreateFrame("Frame", UIParent)
        Install:SetWidth(GetScreenWidth())
        Install:SetHeight(GetScreenHeight())
        Install:SetPoint("CENTER", 0, 0)
        Install:EnableMouse(true)
        Install:SetFrameStrata("HIGH")
        Install.text = Install:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        Install.text:SetScale(4)
        Install.text:SetPoint("CENTER", 0, 30)
        Install.text:SetText("Welcome to |cffea00ffS|r|cff00a2ffUI|r")

        local Texture = Install:CreateTexture(nil, "BACKGROUND")
        Texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")
        Texture:SetAllPoints(Install)
        Install.texture = Texture

        local Subtitle = CreateFrame("Frame", "Subtitle", Install)
        Subtitle:SetSize(250, 50)
        Subtitle:SetPoint("CENTER", Install, 0, 90)
        Subtitle.text = Subtitle:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        Subtitle.text:SetPoint("CENTER", 0, 0)
        Subtitle.text:SetText("The Dark Side of World of Warcraft")
        Subtitle.text:SetScale(1.4)

        local Author = CreateFrame("Frame", "Author", Install)
        Author:SetSize(250, 50)
        Author:SetPoint("CENTER", Subtitle, 0, -15)
        Author.text = Author:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        Author.text:SetPoint("CENTER", 0, 0)
        Author.text:SetText("maintained by |cff00a2ffmuleyo|r")
        Author.text:SetScale(0.9)

        local Button = CreateFrame("Button", "Start", Install, "UIPanelButtonTemplate")
        Button:SetPoint("CENTER", 0, 25)
        Button:SetSize(100, 25)
        Button:SetText("Start")
        Button:SetNormalTexture("Interface\\Common\\bluemenu-main")
        Button:GetNormalTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
        Button:GetNormalTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
        Button:SetHighlightTexture("Interface\\Common\\bluemenu-main")
        Button:GetHighlightTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
        Button:GetHighlightTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
        Button:SetScript("OnClick", function()
            SUI.db.profile.install = true
            SUI.db.profile.reset = true
            local fadeInfo = {};
            fadeInfo.mode = "OUT";
            fadeInfo.timeToFade = 0.4;
            fadeInfo.finishedFunc = function()
                Install:Hide()
                SUI:Config()
            end
            UIFrameFade(Install, fadeInfo);
        end)
    end
end
