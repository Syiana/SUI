local Menu = SUI:NewModule("ActionBars.Menu");

function Menu:OnEnable()
    if IsAddOnLoaded('Bartender4') or IsAddOnLoaded('Dominos') then return end
    local db = {
        micromenu = SUI.db.profile.actionbar.menu.micromenu,
        bagbar = SUI.db.profile.actionbar.menu.bagbar,
        bagPos = SUI.db.profile.edit.bagbar,
        microPos = SUI.db.profile.edit.micromenu
    }

    local MicroButtonAndBagsBarButtons = {
        CharacterMicroButton,
        SpellbookMicroButton,
        TalentMicroButton,
        AchievementMicroButton,
        QuestLogMicroButton,
        GuildMicroButton,
        LFDMicroButton,
        CollectionsMicroButton,
        EJMicroButton,
        StoreMicroButton,
        MainMenuMicroButton,
        MainMenuBarBackpackButton,
        CharacterBag0Slot,
        CharacterBag1Slot,
        CharacterBag2Slot,
        CharacterBag3Slot,
    }

    local function moveMicroMenu()
        local MICRO_BUTTONS = {
            "CharacterMicroButton",
            "SpellbookMicroButton",
            "TalentMicroButton",
            "AchievementMicroButton",
            "QuestLogMicroButton",
            "GuildMicroButton",
            "LFDMicroButton",
            "EJMicroButton",
            "CollectionsMicroButton",
            "MainMenuMicroButton",
            "HelpMicroButton",
            "StoreMicroButton",
        }

        for i = 1, #MICRO_BUTTONS do
            _G[MICRO_BUTTONS[i]]:SetParent(MicroMenu);
            if i == 1 then
                _G[MICRO_BUTTONS[i]]:SetPoint("BOTTOMLEFT", MicroMenu, "BOTTOMLEFT", 5, 5)
            end
        end

        MicroButtonAndBagsBar:UnregisterAllEvents()
        MicroButtonAndBagsBar:Hide()
    end

    local function moveBagBar()
        local BAG_BUTTONS = {
            "MainMenuBarBackpackButton",
            "BagBarExpandToggle",
            "CharacterBag0Slot",
            "CharacterBag1Slot",
            "CharacterBag2Slot",
            "CharacterBag3Slot",
            "CharacterReagentBag0Slot"
        }

        for i = 1, #BAG_BUTTONS do
            _G[BAG_BUTTONS[i]]:SetParent(BagBar);
            if i == 1 then
                _G[BAG_BUTTONS[i]]:SetPoint("BOTTOMRIGHT", BagBar, "BOTTOMRIGHT", -5, 5)
            end
        end
    end

    -- Micro Menu
    MicroMenu = CreateFrame("Frame", "MicroMenu", UIParent)
    MicroMenu:ClearAllPoints()
    MicroMenu:SetSize(230, 35)
    MicroMenu:SetPoint(db.microPos.point, UIParent, db.microPos.point, db.microPos.x, db.microPos.y)

    MicroMenu:RegisterEvent("ADDON_LOADED")
    MicroMenu:RegisterEvent("PLAYER_LOGIN")
    MicroMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
    MicroMenu:RegisterEvent("VARIABLES_LOADED")
    MicroMenu:RegisterEvent("PET_BATTLE_CLOSE")
    MicroMenu:RegisterEvent("UNIT_EXITED_VEHICLE")
    MicroMenu:RegisterEvent("UNIT_EXITING_VEHICLE")
    MicroMenu:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
    MicroMenu:SetScript("OnEvent", moveMicroMenu)
    UIParent:HookScript("OnShow", moveMicroMenu)

    -- Bag Buttons
    MainMenuBarBackpackButton:ClearAllPoints()
    BagBar = CreateFrame("Frame", "BagBar", UIParent)
    BagBar:SetSize(215, 60)
    BagBar:SetPoint(db.bagPos.point, UIParent, db.bagPos.point, db.bagPos.x, db.bagPos.y)

    BagBar:RegisterEvent("ADDON_LOADED")
    BagBar:RegisterEvent("PLAYER_LOGIN")
    BagBar:RegisterEvent("PLAYER_ENTERING_WORLD")
    BagBar:RegisterEvent("VARIABLES_LOADED")
    BagBar:SetScript("OnEvent", moveBagBar)

    for _, button in pairs(MicroButtonAndBagsBarButtons) do
        button:GetNormalTexture():SetVertexColor(0.65, 0.65, 0.65)
    end
end
