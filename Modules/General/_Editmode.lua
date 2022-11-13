local Module = SUI:NewModule("General.Editmode");

function Module:OnEnable()
    --local db = SUI.db.profile.edit.statsframe
    local db = {
        statsframe = SUI.db.profile.edit.statsframe
    }

    local LEM = LibStub('LibEditMode')

    local function statsFramePosition(frame, layoutName, point, x, y)
        db.statsframe.point = point
        db.statsframe.x = x
        db.statsframe.y = y
    end

    LEM:AddFrame(StatsFrame, statsFramePosition)

    LEM:RegisterCallback('layout', function(layoutName)
        StatsFrame:ClearAllPoints()
        StatsFrame:SetPoint(db.statsframe.point, db.statsframe.x, db.statsframe.y)
    end)
end