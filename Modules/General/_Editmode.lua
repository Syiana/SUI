local Module = SUI:NewModule("General.Editmode");

function Module:OnEnable()
    local db = {
        edit = SUI.db.profile.edit.statsframe,
        stats = SUI.db.profile.general.display
    }

    local LEM = LibStub('LibEditMode')

    local function onPositionChanged(frame, layoutName, point, x, y)
        -- from here you can save the position into a savedvariable
        db.edit[layoutName].point = point
        db.edit[layoutName].x = x
        db.edit[layoutName].y = y
    end

    local defaultPosition = {
        point = 'BOTTOMLEFT',
        x = 5,
        y = 3,
    }

    LEM:AddFrame(StatsFrame, onPositionChanged, defaultPosition)

    -- additional (anonymous) callbacks
    LEM:RegisterCallback('enter', function()
        StatsFrame:Show()
    end)
    LEM:RegisterCallback('exit', function()
        if not db.stats.ms and db.stats.fps then
            StatsFrame:Hide()
        end
    end)

    LEM:RegisterCallback('layout', function(layoutName)
        -- this will be called every time the Edit Mode layout is changed (which also happens at login),
        -- use it to load the saved button position from savedvariables and position it
        if not db.edit then
            db.edit = {}
        end
        if not db.edit[layoutName] then
            db.edit[layoutName] = CopyTable(defaultPosition)
        end

        StatsFrame:ClearAllPoints()
        StatsFrame:SetPoint(db.edit[layoutName].point, db.edit[layoutName].x, db.edit[layoutName].y)
    end)

    print(LEM:IsInEditMode())
    print(LEM:GetActiveLayoutName())
end