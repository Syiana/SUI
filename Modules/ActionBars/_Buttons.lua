local Module = SUI:NewModule("ActionBars.Buttons");

function Module.OnEnable()
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

  EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
  EventFrame:RegisterEvent("UPDATE_BINDINGS")

  if IsAddOnLoaded("Masque") and (dominos or bartender) then return end

  function Init()
    for i = 1, 12 do
      local NormalTextureList = {
          _G["ActionButton" ..i],
          _G["MultiBarBottomLeftButton" ..i],
          _G["MultiBarBottomRightButton" ..i],
          _G["MultiBarRightButton" ..i],
          _G["MultiBarLeftButton" ..i],
          _G["MultiBar5Button" ..i],
          _G["MultiBar6Button" ..i],
          _G["MultiBar7Button" ..i],
      }

      for j = 1, #NormalTextureList do
        local t = NormalTextureList[j]
        StyleButton(t, "Actionbar")
        UpdateHotkeys(t)
      end
    end

    for i = 1, 10 do
      local StanceButton = _G["StanceButton" ..i]
      local PetButton = _G["PetActionButton" ..i]
      StyleButton(StanceButton, "StanceOrPet")
      StyleButton(PetButton, "StanceOrPet")
    end
  end

  function StyleButton(Button, Type)
    Button.SUIStyled = false
    local Name = Button:GetName()
    local NormalTexture = _G[Name .. "NormalTexture"]
    local Icon = _G[Name .. "Icon"]
    local Cooldown = _G[Name .. "Cooldown"]

    if Button.SUIStyled == false then
      NormalTexture:SetDesaturated(true)
      NormalTexture:SetVertexColor(0, 0, 0)
      Cooldown:SetAllPoints()

      Icon:SetTexCoord(.08, .92, .08, .92)

      Button:SetNormalTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\UIActionBar")
      Button:GetNormalTexture():SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)

      local ButtonWidth, ButtonHeight = Button:GetSize()
      Button:GetNormalTexture():SetSize(ButtonWidth + 2, ButtonHeight + 1)
      Button.Shadow = CreateFrame("Frame", nil, Button, "BackdropTemplate")
      Button.Shadow:SetPoint("TOPLEFT", Button, "TOPLEFT", -3, 3)
      Button.Shadow:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", 2, -2)
      Button.Shadow:SetFrameLevel(Button:GetFrameLevel() - 1)
      Button.Shadow:SetBackdrop(Backdrop)
      Button.Shadow:SetBackdropBorderColor(0, 0, 0)
      Button:Show()

      Button.SUIStyled = true
    end
  end

  function UpdateHotkeys(Button)
    local Name = Button:GetName()
    local HotKey = _G[Name .. "HotKey"]
    local Macro = _G[Name .. "Name"]
    local Count = _G[Name .. "Count"]

    HotKey:SetFont(FONT, db.buttons.size, "OUTLINE")
    Macro:SetFont(FONT, db.buttons.size, "OUTLINE")
    Count:SetFont(FONT, 14, "OUTLINE")

    local HotKeyAlpha = db.buttons.key and 1 or 0
    local MacroAlpha = db.buttons.macro and 1 or 0

    HotKey:SetAlpha(HotKeyAlpha)
    Macro:SetAlpha(MacroAlpha)
  end

  EventFrame:SetScript("OnEvent", Init)
end