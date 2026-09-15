--[[
    SUI 2.0 - Features/General/Stats.lua

    A small movable text with FPS, latency and movement speed. It refreshes
    on a 0.2s timer like 1.x and never uses OnUpdate.
    The position is stored by SUI.Movers under the 1.x key "statsframe".
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat
local floor, format = math.floor, string.format
local GetFramerate, GetNetStats, GetUnitSpeed = GetFramerate, GetNetStats, GetUnitSpeed

local F = SUI:NewFeature("General.Stats", {
    category = "general",
    toggle = function(db)
        local display = db.display
        return display.fps or display.ms or display.movementSpeed
    end,
})

local FONT_SIZE = 13
local RUN_SPEED = 7 -- BASE_MOVEMENT_SPEED

local function speedPercent()
    local speed = GetUnitSpeed("player")
    if C_PlayerInfo and C_PlayerInfo.GetGlidingInfo then
        local gliding, _, forward = C_PlayerInfo.GetGlidingInfo()
        if Compat.CanAccess(gliding) and gliding and forward then
            speed = forward
        end
    end
    if not Compat.CanAccess(speed) then
        return 0
    end
    return floor(speed / (BASE_MOVEMENT_SPEED or RUN_SPEED) * 100)
end

function F:OnLoad()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(50, FONT_SIZE)
    frame.editModeName = "SUI Stats"
    local label = frame:CreateFontString(nil, "OVERLAY")
    label:SetPoint("CENTER")
    label:SetShadowOffset(1, -1)
    label:SetShadowColor(0, 0, 0)
    frame.text = label
    self.frame = frame

    SUI.Movers:Add(frame, "statsframe", { point = "BOTTOMLEFT", x = 5, y = 3 }, { label = "Stats" })

    -- Values fill the pattern slots in 1.x order: fps, ms, speed.
    self.update = function()
        local display = self.db.display
        local a, b, c, n = 0, 0, 0, 0
        if display.fps then
            a, n = floor(GetFramerate()), 1
        end
        if display.ms then
            local ms = select(4, GetNetStats())
            if n == 0 then a = ms else b = ms end
            n = n + 1
        end
        if display.movementSpeed then
            local speed = speedPercent()
            if n == 0 then a = speed elseif n == 1 then b = speed else c = speed end
        end
        label:SetFormattedText(self.pattern, a, b, c)
        local width = label:GetStringWidth()
        if width ~= self.width then
            self.width = width
            frame:SetWidth(width > 0 and width or 50)
        end
    end
end

-- Builds the colour-coded pattern for the enabled values, in 1.x order.
function F:Layout()
    local display = self.db.display
    local _, class = UnitClass("player")
    local r, g, b = Compat.GetClassColor(class)
    local color = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
    local parts, n = {}, 0
    if display.fps then
        n = n + 1
        parts[n] = "|cffffffff%d|r " .. color .. "fps|r"
    end
    if display.ms then
        n = n + 1
        parts[n] = "|cffffffff%d|r " .. color .. "ms|r"
    end
    if display.movementSpeed then
        n = n + 1
        parts[n] = "|cffffffff%d%%|r " .. color .. "speed|r"
    end
    self.pattern = table.concat(parts, " ")
    self.frame.text:SetFont(self.db.font, FONT_SIZE, "THINOUTLINE")

    self:CancelTimers()
    self:NewTicker(0.2, self.update) -- 1.x refresh rate
    self.update()
end

function F:OnEnable()
    self.frame:Show()
    self:Layout()
end

function F:OnRefresh(key)
    if key == "font" or (key and key:find("^display%.")) then
        self:Layout()
    end
end

function F:OnDisable()
    self.frame:Hide()
end
