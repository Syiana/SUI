local MenuFrame = CreateFrame('Frame', "MenuFrame", MainMenuBar)
MenuFrame:SetMovable(true)
MenuFrame:SetUserPlaced(true)
MenuFrame:SetPoint('BOTTOMRIGHT', UIParent, "BOTTOMRIGHT", 5, 3)
MenuFrame:SetScript("OnDragStart", function(self) print('test') end)

local BagsBarTexture = MenuFrame:CreateTexture("texture")
BagsBarTexture:SetAtlas('hud-MicroBagBar', true)
BagsBarTexture:SetPoint('CENTER')
BagsBarTexture:Show()

local Width, Height = BagsBarTexture:GetSize()
MenuFrame:SetSize(Width, Height)

MainMenuBarBackpackButton:SetParent(MenuFrame)
CharacterBag0Slot:SetParent(MenuFrame)
CharacterBag1Slot:SetParent(MenuFrame)
CharacterBag2Slot:SetParent(MenuFrame)
CharacterBag3Slot:SetParent(MenuFrame)

MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint('TOPRIGHT', -4, -4)
MicroButtonAndBagsBar:Hide()

MenuFrame:GetRegions():SetVertexColor(.15, .15, .15)

local ADDON, SUI = ...
SUI.MODULES.ACTIONBAR.Menu = function(DB) 

    if (DB.STATE) then
        if (DB.CONFIG.Menu) then

            local ignore

            frames = {BagsBarTexture, MainMenuBarBackpackButton, CharacterBag0Slot, 
            CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot}

            MenuFrame:SetScript('OnEnter', function() 
                for i,v in ipairs(frames) do
                    v:Show()
                end
                for _, v in ipairs(MICRO_BUTTONS) do
                    v = _G[v]
                    v:SetAlpha(1)
                end
      
            end)
            MenuFrame:SetScript('OnLeave', function() 
                if ignore then return end
                for i,v in ipairs(frames) do
                    v:Hide()
                end
                for _, v in ipairs(MICRO_BUTTONS) do
                    v = _G[v]
                    v:SetAlpha(0)
                end
      
            end)

            for _, v in ipairs(MICRO_BUTTONS) do
                v = _G[v]

                v:HookScript("OnEnter", function() ignore = true end)
                v:HookScript("OnLeave", function() ignore = false end)
            end
        end
    end
end