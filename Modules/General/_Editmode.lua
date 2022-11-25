local Module = SUI:NewModule("General.Editmode");

function Module:OnEnable()
    local LEM = LibStub('LibEditMode')

    local db = {
        statsframe = SUI.db.profile.edit.statsframe,
        queueicon = SUI.db.profile.edit.queueicon,
        micromenu = SUI.db.profile.edit.micromenu,
        bagbar = SUI.db.profile.edit.bagbar,
        microvis = SUI.db.profile.actionbar.menu.micromenu,
        bagvis = SUI.db.profile.actionbar.menu.bagbar
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
        QueueStatusButton:ClearAllPoints()
        QueueStatusButton:SetPoint(db.queueicon.point, UIParent, db.queueicon.point, db.queueicon.x, db.queueicon.y)
    end)

    -- Micro Menu
    local function microMenuPos(frame, layoutName, point, x, y)
        db.micromenu.point = point
        db.micromenu.x = x
        db.micromenu.y = y
    end

    LEM:AddFrame(MicroMenu, microMenuPos)

    LEM:RegisterCallback('enter', function()
        if db.microvis == 'hide' then
            MicroMenu:Show()
        elseif db.microvis == 'mouse_over' then
            MicroMenu:SetAlpha(1)
        end
    end)

    LEM:RegisterCallback('exit', function()
        if db.microvis == 'mouse_over' then
            MicroMenu:SetAlpha(0)
        elseif db.microvis == 'hide' then
            MicroMenu:Hide()
        end
    end)

    LEM:RegisterCallback('layout', function(layoutName)
        MicroMenu:ClearAllPoints()
        MicroMenu:SetPoint(db.micromenu.point, UIParent, db.micromenu.point, db.micromenu.x, db.micromenu.y)
    end)

    -- Bag Bar
    local function bagBarPos(frame, layoutName, point, x, y)
        db.bagbar.point = point
        db.bagbar.x = x
        db.bagbar.y = y
    end

    LEM:AddFrame(BagBar, bagBarPos)

    LEM:RegisterCallback('enter', function()
        if db.bagvis == 'hide' then
            BagBar:Show()
        elseif db.bagvis == 'mouse_over' then
            BagBar:SetAlpha(1)
        end
    end)

    LEM:RegisterCallback('exit', function()
        if db.bagvis == 'mouse_over' then
            BagBar:SetAlpha(0)
        elseif db.bagvis == 'hide' then
            BagBar:Hide()
        end
    end)

    LEM:RegisterCallback('layout', function(layoutName)
        BagBar:ClearAllPoints()
        BagBar:SetPoint(db.bagbar.point, UIParent, db.bagbar.point, db.bagbar.x, db.bagbar.y)
    end)
end
