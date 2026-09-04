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
    local Minimap = SUI:GetModule("Maps.Minimap", true)

    local function applyQueueIconPosition()
        -- the minimap module owns the anchoring, keep both in step
        if Minimap and Minimap.UpdateQueueIconPosition then
            Minimap:UpdateQueueIconPosition()
            return
        end

        QueueStatusButton:SetParent(UIParent)
        QueueStatusButton:ClearAllPoints()
        QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
    end

    local function queueIconPos(frame, layoutName, point, x, y)
        db.queueicon.point = point
        db.queueicon.x = x
        db.queueicon.y = y
    end

    LEM:AddFrame(QueueStatusButton, queueIconPos, { point = 'CENTER', x = 0, y = 0 })

    local inQueue

    LEM:RegisterCallback('enter', function()
        inQueue = QueueStatusButton:IsVisible()
        QueueStatusButton:Show()
    end)

    LEM:RegisterCallback('exit', function()
        if not inQueue then
            QueueStatusButton:Hide()
        end

        applyQueueIconPosition()
    end)

    LEM:RegisterCallback('layout', function(layoutName)
        applyQueueIconPosition()
    end)
end
