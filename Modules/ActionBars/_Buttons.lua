local Module = SUI:NewModule("ActionBars.Buttons");

function Module:OnEnable()

    if (SUI:Color()) then
        local EventFrame = CreateFrame("Frame")
        local FONT = STANDARD_TEXT_FONT
        local dominos = IsAddOnLoaded("Dominos")
        local bartender = IsAddOnLoaded("Bartender4")
        local db = { buttons = SUI.db.profile.actionbar.buttons }

        local Backdrop = {
            bgFile = "",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 5,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        }

        local Bars = {
            _G["MultiBarBottomLeft"],
            _G["MultiBarBottomRight"],
            _G["MultiBarRight"],
            _G["MultiBarLeft"],
            _G["MultiBarRight"],
            _G["MultiBar5"],
            _G["MultiBar6"],
            _G["MultiBar7"],
        }

        EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        EventFrame:RegisterEvent("UPDATE_BINDINGS")

        function Init()
            for j = 1, #Bars do
                local Bar = Bars[j]
                if Bar then
                    local Num = Bar.numButtonsShowable
                    StyleAction(Bar, Num)
                end
            end

            local DefaultActionBarShowable = _G["MainMenuBar"].numButtonsShowable

            for i = 1, DefaultActionBarShowable do
                local Button = _G["ActionButton" .. i]

                UpdateHotkeys(Button)

                if IsAddOnLoaded("Masque") and IsAddOnLoaded("MasqueBlizzBars") then return end
                StyleButton(Button, "Actionbar")

            end

            for i = 1, 10 do
                local StanceButton = _G["StanceButton" .. i]
                local PetButton = _G["PetActionButton" .. i]

                StyleButton(StanceButton, "StanceOrPet")
                StyleButton(PetButton, "StanceOrPet")
            end
        end

        function StyleAction(Bar, Num)
            for i = 1, Num do
                local Name = Bar:GetName()
                local Button = _G[Name .. "Button" .. i]

                StyleButton(Button, "Actionbar")
                UpdateHotkeys(Button)
            end
        end

        function StyleButton(Button, Type)
            local Name = Button:GetName()
            local NormalTexture = _G[Name .. "NormalTexture"]
            local Icon = _G[Name .. "Icon"]
            local Cooldown = _G[Name .. "Cooldown"]

            if Button.Shadow == nil then
                NormalTexture:SetDesaturated(true)
                NormalTexture:SetVertexColor(unpack(SUI:Color(0.15)))

                Cooldown:ClearAllPoints()
                Cooldown:SetPoint("TOPLEFT", Button, "TOPLEFT", 1, -2)
                Cooldown:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", -2, 2)

                Icon:SetTexCoord(.08, .92, .08, .92)

                Button:SetNormalTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\UIActionBar")
                Button:GetNormalTexture():SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)

                local ButtonWidth, ButtonHeight = Button:GetSize()
                Button:GetNormalTexture():SetSize(ButtonWidth + 2, ButtonHeight + 1)
                
                
                if bartender then
                   if Type ~= "Stance" and Type ~= "Pet" then
                        Button:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
                        Button:GetNormalTexture():SetSize(ButtonWidth + 6, ButtonHeight + 5)
                   end
                end

                Button.Shadow = CreateFrame("Frame", nil, Button, "BackdropTemplate")
                Button.Shadow:SetPoint("TOPLEFT", Button, "TOPLEFT", -3, 3)
                Button.Shadow:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", 2, -2)
                Button.Shadow:SetFrameLevel(Button:GetFrameLevel() - 1)
                Button.Shadow:SetBackdrop(Backdrop)
                Button.Shadow:SetBackdropBorderColor(unpack(SUI:Color(0.15)))
                --Button.Shadow:SetBackdropBorderColor(0, 0, 0)
            end
        end

        function UpdateHotkeys(Button)
            local Name = Button:GetName()
            local HotKey = _G[Name .. "HotKey"]
            local Macro = _G[Name .. "Name"]
            local Count = _G[Name .. "Count"]

            HotKey:SetFont(FONT, db.buttons.size, "OUTLINE")
            Macro:SetFont(FONT, db.buttons.size, "OUTLINE")
            Count:SetFont(FONT, db.buttons.size, "OUTLINE")

            local HotKeyAlpha = db.buttons.key and 1 or 0
            local MacroAlpha = db.buttons.macro and 1 or 0

            HotKey:SetAlpha(HotKeyAlpha)
            Macro:SetAlpha(MacroAlpha)
        end

        if dominos then
            if IsAddOnLoaded("Masque") then return end
            for i = 1, 120 do
                local ActionButton = _G["DominosActionButton" .. i]
                if ActionButton then
                    StyleButton(ActionButton)
                end
            end

            for i = 1, 10 do
                local PetButton = _G["DominosPetActionButton" .. i]
                local StanceButton = _G["DominosStanceButton" .. i]

                if PetButton then
                    StyleButton(PetButton)
                end

                if StanceButton then
                    StyleButton(StanceButton)
                end
            end
        end

        if bartender then
            if IsAddOnLoaded("Masque") then return end
            for i = 1, 180 do
                local ActionButton = _G["BT4Button" .. i]
                if ActionButton then
                    StyleButton(ActionButton)
                end
            end

            for i = 1, 10 do
                local PetButton = _G["BT4PetButton" .. i]
                local StanceButton = _G["BT4StanceButton" .. i]

                if PetButton then
                    StyleButton(PetButton, "Pet")
                end

                if StanceButton then
                    StyleButton(StanceButton, "Stance")
                end
            end
        end

        EventFrame:SetScript("OnEvent", Init)
    end
end
