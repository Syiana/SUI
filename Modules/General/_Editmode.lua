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
    --
    -- Blizzard reanchors and rescales this button from several places: its own
    -- UpdatePosition, the minimap layout and Edit Mode. Moving the button itself
    -- means fighting all of them over screen coordinates, and losing. So we never
    -- move it. It sits pinned to the centre of a holder we own, and Edit Mode drags
    -- the holder instead. The hooks below only ever restore that fixed relationship,
    -- which is a fight we cannot lose because Blizzard has no opinion on the holder.
    local queueHolder = CreateFrame("Frame", "SUIQueueStatusHolder", UIParent)
    queueHolder:SetSize(QueueStatusButton:GetWidth(), QueueStatusButton:GetHeight())
    queueHolder:SetPoint(db.queueicon.point, db.queueicon.x, db.queueicon.y)

    QueueStatusButton:SetParent(queueHolder)
    QueueStatusButton:ClearAllPoints()
    QueueStatusButton:SetPoint("CENTER", queueHolder)

    local repinning = false
    hooksecurefunc(QueueStatusButton, "SetPoint", function()
        if repinning then
            return
        end

        repinning = true
        QueueStatusButton:ClearAllPoints()
        QueueStatusButton:SetPoint("CENTER", queueHolder)
        repinning = false
    end)

    local queueScale = 0.8
    hooksecurefunc(QueueStatusButton, "SetScale", function(self, scale)
        if scale ~= queueScale then
            self:SetScale(queueScale)
        end
    end)
    QueueStatusButton:SetScale(queueScale)

    local function queueIconPos(frame, layoutName, point, x, y)
        db.queueicon.point = point
        db.queueicon.x = x
        db.queueicon.y = y
    end

    LEM:AddFrame(queueHolder, queueIconPos, { point = 'CENTER', x = 0, y = 0 })

    local inQueue

    LEM:RegisterCallback('enter', function()
        -- Show the button while editing so there is something to aim at, but only
        -- put it back to hidden afterwards if it was not a live queue.
        inQueue = QueueStatusButton:IsVisible()
        QueueStatusButton:Show()
    end)

    LEM:RegisterCallback('exit', function()
        if not inQueue then
            QueueStatusButton:Hide()
        end
    end)

    LEM:RegisterCallback('layout', function(layoutName)
        queueHolder:ClearAllPoints()
        queueHolder:SetPoint(db.queueicon.point, db.queueicon.x, db.queueicon.y)
    end)
end
