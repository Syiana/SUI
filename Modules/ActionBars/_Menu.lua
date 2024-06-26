local Module = SUI:NewModule("ActionBars.Menu");

function Module:OnEnable()
    local db = SUI.db.profile.actionbar

    if (db.style == 'Small' or db.style == 'BFA' or db.style == 'BFATransparent') then
        -- Bag Buttons Table
        local BagButtons = {
            MainMenuBarBackpackButton,
            CharacterBag0Slot,
            CharacterBag1Slot,
            CharacterBag2Slot,
            CharacterBag3Slot
        }
        -- MicroMenu
        local ignore

        local function setFrameAlpha(b, a)
            if ignore then return end
            ignore = true
            if b:IsMouseOver() then
                b:SetAlpha(1)
            else
                b:SetAlpha(0)
            end
            ignore = nil
        end

        local function showFrame(name)
            if name == "MicroMenu" then
                for _, frame in ipairs(MICRO_BUTTONS) do
                    ignore = true
                    _G[frame]:SetAlpha(1)
                    ignore = nil
                end
            elseif name == "BagButtons" then
                for frame, _ in pairs(BagButtons) do
                    frame = BagButtons[frame]

                    ignore = true
                    frame:SetAlpha(1)
                    ignore = nil
                end
            end
        end

        local function hideFrame(name)
            if name == "MicroMenu" then
                for _, frame in ipairs(MICRO_BUTTONS) do
                    ignore = true
                    _G[frame]:SetAlpha(0)
                    ignore = nil
                end
            elseif name == "BagButtons" then
                for frame, _ in pairs(BagButtons) do
                    frame = BagButtons[frame]

                    ignore = true
                    frame:SetAlpha(0)
                    ignore = nil
                end
            end
        end

        -- MicroMenu Position
        MoveMicroButtons("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -275, 0)

        local vehicle = CreateFrame("Frame")
        vehicle:RegisterEvent("UNIT_ENTERED_VEHICLE")
        vehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
        vehicle:HookScript("OnEvent", function(self, event, unit)
            if unit == "player" then
                if event == "UNIT_EXITED_VEHICLE" then
                    MoveMicroButtons("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -275, 0)
                    if (GetNumShapeshiftForms() > 0) then
                        SUIStanceBar:Show()
                    end
                else
                    SUIStanceBar:Hide()
                end
            end
        end)

        -- Bag Buttons Position
        MainMenuBarBackpackButton:ClearAllPoints()
        MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -2.5, 40)

        -- MicroMenu Mouseover
        if (db.menu.mouseovermicro) then
            for _, frame in ipairs(MICRO_BUTTONS) do
                frame = _G[frame]
                hooksecurefunc(frame, "SetAlpha", setFrameAlpha)
                frame:HookScript("OnEnter", function()
                    showFrame("MicroMenu")
                end)
                frame:HookScript("OnLeave", function()
                    hideFrame("MicroMenu")
                end)
                frame:SetAlpha(0)
            end
        end

        -- Bag Buttons Mouseover
        if (db.menu.mouseoverbags) then
            -- Bags bar
            for frame, _ in pairs(BagButtons) do
                frame = BagButtons[frame]

                hooksecurefunc(frame, "SetAlpha", setFrameAlpha)
                frame:HookScript("OnEnter", function()
                    showFrame("BagButtons")
                end)
                frame:HookScript("OnLeave", function()
                    hideFrame("BagButtons")
                end)
                frame:SetAlpha(0)
            end
        end
    end
end