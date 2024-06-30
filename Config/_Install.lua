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
        Install.text:SetText("Welcome to |cffff00d5S|r|cff027bffUI|r")

        local Texture = Install:CreateTexture(nil, "BACKGROUND")
        Texture:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background]])
        Texture:SetAllPoints(Install)
        Install.texture = Texture

        local Subtittle = CreateFrame("Frame", "Subtittle", Install)
        Subtittle:SetSize(250, 50)
        Subtittle:SetPoint("CENTER", Install, 0, 90)
        Subtittle.text = Subtittle:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        Subtittle.text:SetPoint("CENTER", 0, 0)
        Subtittle.text:SetText("The Dark Side of World of Warcraft")
        Subtittle.text:SetScale(1.4)

        local Author = CreateFrame("Frame", "Author", Install)
        Author:SetSize(250, 50)
        Author:SetPoint("CENTER", Subtittle, 0, -15)
        Author.text = Author:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
        Author.text:SetPoint("CENTER", 0, 0)
        Author.text:SetText("created by |cfff58cbaSyiana|r @2015")
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
