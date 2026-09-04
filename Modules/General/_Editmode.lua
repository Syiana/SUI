local Module = SUI:NewModule("General.Editmode");

function Module:OnEnable()
    local LEM = LibStub('LibEditMode')

    local db = {
        statsframe = SUI.db.profile.edit.statsframe,
    }

    -- Stats Frame
    local function statsFramePos(frame, layoutName, point, x, y)
        db.statsframe.point = point
        db.statsframe.x = x
        db.statsframe.y = y
    end

    LEM:AddFrame(StatsFrame, statsFramePos)

    LEM:RegisterCallback('layout', function(layoutName)
        StatsFrame:ClearAllPoints()
        StatsFrame:SetPoint(db.statsframe.point, db.statsframe.x, db.statsframe.y)
    end)

    -- The queue status icon is deliberately left alone. Blizzard repositions it from
    -- its own code and Edit Mode, so anchoring it ourselves turned into a fight we
    -- could not win: the drag was overwritten and it ended up somewhere else on exit.
end
