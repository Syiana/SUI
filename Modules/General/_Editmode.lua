local Module = SUI:NewModule("General.Editmode");

function Module:OnEnable()
    local LEM = LibStub('LibEditMode')

    local db = {
        statsframe = SUI.db.profile.edit.statsframe,
        queueicon = SUI.db.profile.edit.queueicon,
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

    -- Queue Status Icon
    local function queueIconPos(frame, layoutName, point, x, y)
        db.queueicon.point = point
        db.queueicon.x = x
        db.queueicon.y = y
    end

    LEM:AddFrame(QueueStatusButton, queueIconPos)

    LEM:RegisterCallback('enter', function()
        if QueueStatusButton:IsVisible() then
            inQueue = true
        else
            inQueue = false
        end
        QueueStatusButton:Show()
    end)

    LEM:RegisterCallback('exit', function()
        if not inQueue then
            QueueStatusButton:Hide()
        end
    end)

    LEM:RegisterCallback('layout', function(layoutName)
        QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
    end)
end
