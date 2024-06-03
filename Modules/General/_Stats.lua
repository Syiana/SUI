local Module = SUI:NewModule("General.Stats");

StatsFrame = CreateFrame("Frame", "StatsFrame", UIParent)
local movable = false

if movable == false then
  StatsFrame:ClearAllPoints()
  StatsFrame:SetPoint('BOTTOMLEFT', UIParent, "BOTTOMLEFT", 5, 5)
end

if movable == true then
  StatsFrame:EnableMouse(true)
  StatsFrame:ClearAllPoints()
  StatsFrame:SetPoint('BOTTOMLEFT', UIParent, "BOTTOMLEFT", 5, 3)
  StatsFrame:SetClampedToScreen(true)
  StatsFrame:SetMovable(true)
  StatsFrame:SetUserPlaced(true)
  StatsFrame:SetFrameLevel(4)
  StatsFrame:SetScript("OnMouseDown",	function()
    StatsFrame:ClearAllPoints()
    StatsFrame:StartMoving()
  end)
  StatsFrame:SetScript("OnMouseUp", function()
    StatsFrame:StopMovingOrSizing()
  end)
end

function Module:OnEnable()
  local db = SUI.db.profile.general
  if (db.display.fps or db.display.ms) then
    local font = STANDARD_TEXT_FONT
    local fontSize = 13
    local fontFlag = "THINOUTLINE"
    local textAlign = "CENTER"
    local customColor = db.color
    local useShadow = true
    local color

    if customColor == false then
      color = {r = 1, g = 1, b = 1}
    else
      local _, class = UnitClass("player")
      color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
    end

    local function status()
      local function getFPS() return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps" end
      local function getLatencyWorld() return "|c00ffffff" .. select(4, GetNetStats()) .. "|r ms" end
      local function getLatency() return "|c00ffffff" .. select(3, GetNetStats()) .. "|r ms" end
      if (db.display.fps and db.display.ms) then
        return getFPS() .. " " .. getLatency()
      elseif (db.display.fps)  then
        return getFPS()
      elseif (db.display.ms) then
        return getLatency()
      end
    end

    StatsFrame:SetWidth(50)
    StatsFrame:SetHeight(fontSize)
    StatsFrame.text = StatsFrame:CreateFontString(nil, "BACKGROUND")
    StatsFrame.text:SetPoint(textAlign, StatsFrame)
    StatsFrame.text:SetFont(font, fontSize, fontFlag)
    if useShadow then
      StatsFrame.text:SetShadowOffset(1, -1)
      StatsFrame.text:SetShadowColor(0, 0, 0)
    end
    StatsFrame.text:SetTextColor(color.r, color.g, color.b)

    local lastUpdate = 0

    local function update(self, elapsed)
      lastUpdate = lastUpdate + elapsed
      if lastUpdate > 1 then
        lastUpdate = 0
        StatsFrame.text:SetText(status())
        self:SetWidth(StatsFrame.text:GetStringWidth())
        self:SetHeight(StatsFrame.text:GetStringHeight())
      end
    end

    StatsFrame:SetScript("OnUpdate", update)
  end
end