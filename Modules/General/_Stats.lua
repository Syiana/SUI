local Module = SUI:NewModule("General.Stats");

function Module:OnEnable()
    local db = {
        display = SUI.db.profile.general.display,
        statsframe = SUI.db.profile.edit.statsframe
    }

    StatsFrame = CreateFrame("Frame", "StatsFrame", UIParent)
    StatsFrame:ClearAllPoints()
    StatsFrame:SetPoint(db.statsframe.point, UIParent, db.statsframe.point, db.statsframe.x, db.statsframe.y)

    if (db.display.fps or db.display.ms) then
        local font = STANDARD_TEXT_FONT
        local fontSize = 13
        local fontFlag = "THINOUTLINE"
        local textAlign = "CENTER"
        local customColor = db.color
        local useShadow = true
        local color

        if customColor == false then
            color = { r = 1, g = 1, b = 1 }
        else
            local _, class = UnitClass("player")
            color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
        end

        local function status()
            local function getFPS() return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps" end

            local function getLatency() return "|c00ffffff" .. select(4, GetNetStats()) .. "|r ms" end

            if (db.display.fps and db.display.ms) then
                return getFPS() .. " " .. getLatency()
            elseif (db.display.fps) then
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
