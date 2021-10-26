local Menu = SUI:NewModule("ActionBars.Menu");

local MenuFrame = CreateFrame('Frame', "MenuFrame", UIParent)
MenuFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

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

for _, v in ipairs(MICRO_BUTTONS) do v = _G[v]
  v:SetParent(MenuFrame)
end

CharacterMicroButton:ClearAllPoints()
CharacterMicroButton:SetPoint("BOTTOMLEFT", MenuFrame, 5, 3)

MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint('TOPRIGHT', -4, -4)
MicroButtonAndBagsBar:Hide()

function Menu:OnEnable()
  local db = SUI.db.profile.actionbar
  if (SUI:Color()) then
    MenuFrame:GetRegions():SetVertexColor(.15, .15, .15)
  end
  if (db.menu.mouseover) then
    MenuFrame:SetAlpha(0)
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
