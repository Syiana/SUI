local MenuFrame = CreateFrame('Frame', "MenuFrame", MainMenuBar)
MenuFrame:SetMovable(true)
MenuFrame:SetUserPlaced(true)
MenuFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 5, 3)
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


for _, v in ipairs(MICRO_BUTTONS) do
    v = _G[v]
    v:SetParent(MenuFrame)
end

MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint('TOPRIGHT', -4, -4)
MicroButtonAndBagsBar:Hide()

MenuFrame:GetRegions():SetVertexColor(.15, .15, .15)

local ADDON, SUI = ...
SUI.MODULES.ACTIONBAR.Menu = function(DB) 

    if (DB.STATE) then
        if (DB.CONFIG.Menu) then
            MenuFrame:SetScript('OnEnter', function()
                MenuFrame:SetAlpha(1)
            end)
            MenuFrame:SetScript('OnLeave', function()
                if not (MouseIsOver(MenuFrame)) then
                    MenuFrame:SetAlpha(0)
                 end
            end)
        end
    end
end