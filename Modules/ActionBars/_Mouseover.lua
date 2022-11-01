local Module = SUI:NewModule("ActionBars.Mouseover");

function Module:OnEnable()
    db = SUI.db.profile.actionbar.bars
    if (db.bar1) then
        -- Create own pair of MainMenuBar
        local MainMenuBarHover = {
            ActionButton1,
            ActionButton2,
            ActionButton3,
            ActionButton4,
            ActionButton5,
            ActionButton6,
            ActionButton7,
            ActionButton8,
            ActionButton9,
            ActionButton10,
            ActionButton11,
            ActionButton12,
        }

        -- Hide MainMenuBar
        MainMenuBar:SetAlpha(0)

        -- Show MainMenuBar on Hover
        for _, Bar1 in pairs(MainMenuBarHover) do
            Bar1:SetScript('OnEnter', function()
                MainMenuBar:SetAlpha(1)
            end)

            Bar1:SetScript('OnLeave', function()
                MainMenuBar:SetAlpha(0)
            end)
        end
    end
    if (db.bar2) then
        -- Create own pair of MultiBarBottomLeft
        local MultiBarBottomLeftHover = {
            MultiBarBottomLeftButton1,
            MultiBarBottomLeftButton2,
            MultiBarBottomLeftButton3,
            MultiBarBottomLeftButton4,
            MultiBarBottomLeftButton5,
            MultiBarBottomLeftButton6,
            MultiBarBottomLeftButton7,
            MultiBarBottomLeftButton8,
            MultiBarBottomLeftButton9,
            MultiBarBottomLeftButton10,
            MultiBarBottomLeftButton11,
            MultiBarBottomLeftButton12,
        }

        -- Hide MultiBarBottomLeft
        MultiBarBottomLeft:SetAlpha(0)

        -- Show MultiBarBottomLeft on Hover
        for _, Bar2 in pairs(MultiBarBottomLeftHover) do
            Bar2:SetScript('OnEnter', function()
                MultiBarBottomLeft:SetAlpha(1)
            end)

            Bar2:SetScript('OnLeave', function()
                MultiBarBottomLeft:SetAlpha(0)
            end)
        end
    end
    if (db.bar3) then
        -- Create own pair of MultiBarBottomRight
        local MultiBarBottomRightHover = {
            MultiBarBottomRightButton1,
            MultiBarBottomRightButton2,
            MultiBarBottomRightButton3,
            MultiBarBottomRightButton4,
            MultiBarBottomRightButton5,
            MultiBarBottomRightButton6,
            MultiBarBottomRightButton7,
            MultiBarBottomRightButton8,
            MultiBarBottomRightButton9,
            MultiBarBottomRightButton10,
            MultiBarBottomRightButton11,
            MultiBarBottomRightButton12,
        }

        -- Hide MultiBarBottomRight
        MultiBarBottomRight:SetAlpha(0)

        -- Show MultiBarBottomRight on Hover
        for _, Bar3 in pairs(MultiBarBottomRightHover) do
            Bar3:SetScript('OnEnter', function()
                MultiBarBottomRight:SetAlpha(1)
            end)

            Bar3:SetScript('OnLeave', function()
                MultiBarBottomRight:SetAlpha(0)
            end)
        end
    end
    if (db.bar4) then
        -- Create own pair of MultiBarRight
        local MultiBarRightHover = {
            MultiBarRightButton1,
            MultiBarRightButton2,
            MultiBarRightButton3,
            MultiBarRightButton4,
            MultiBarRightButton5,
            MultiBarRightButton6,
            MultiBarRightButton7,
            MultiBarRightButton8,
            MultiBarRightButton9,
            MultiBarRightButton10,
            MultiBarRightButton11,
            MultiBarRightButton12,
        }

        -- Hide MultiBarRight
        MultiBarRight:SetAlpha(0)

        -- Show MultiBarRight on Hover
        for _, Bar4 in pairs(MultiBarRightHover) do
            Bar4:SetScript('OnEnter', function()
                MultiBarRight:SetAlpha(1)
            end)

            Bar4:SetScript('OnLeave', function()
                MultiBarRight:SetAlpha(0)
            end)
        end
    end
    if (db.bar5) then
        -- Create own pair of MultiBarLeft
        local MultiBarLeftHover = {
            MultiBarLeftButton1,
            MultiBarLeftButton2,
            MultiBarLeftButton3,
            MultiBarLeftButton4,
            MultiBarLeftButton5,
            MultiBarLeftButton6,
            MultiBarLeftButton7,
            MultiBarLeftButton8,
            MultiBarLeftButton9,
            MultiBarLeftButton10,
            MultiBarLeftButton11,
            MultiBarLeftButton12,
        }

        -- Hide MultiBarLeft
        MultiBarLeft:SetAlpha(0)

        -- Show MultiBarLeft on Hover
        for _, Bar5 in pairs(MultiBarLeftHover) do
            Bar5:SetScript('OnEnter', function()
                MultiBarLeft:SetAlpha(1)
            end)

            Bar5:SetScript('OnLeave', function()
                MultiBarLeft:SetAlpha(0)
            end)
        end
    end
    if (db.bar6) then
        -- Create own pair of MultiBar5
        local MultiBar5Hover = {
            MultiBar5Button1,
            MultiBar5Button2,
            MultiBar5Button3,
            MultiBar5Button4,
            MultiBar5Button5,
            MultiBar5Button6,
            MultiBar5Button7,
            MultiBar5Button8,
            MultiBar5Button9,
            MultiBar5Button10,
            MultiBar5Button11,
            MultiBar5Button12,
        }

        -- Hide MultiBar5
        MultiBar5:SetAlpha(0)

        -- Show MultiBar5 on Hover
        for _, Bar6 in pairs(MultiBar5Hover) do
            Bar6:SetScript('OnEnter', function()
                MultiBar5:SetAlpha(1)
            end)

            Bar6:SetScript('OnLeave', function()
                MultiBar5:SetAlpha(0)
            end)
        end
    end
    if (db.bar7) then
        -- Create own pair of MultiBar6
        local MultiBar6Hover = {
            MultiBar6Button1,
            MultiBar6Button2,
            MultiBar6Button3,
            MultiBar6Button4,
            MultiBar6Button5,
            MultiBar6Button6,
            MultiBar6Button7,
            MultiBar6Button8,
            MultiBar6Button9,
            MultiBar6Button10,
            MultiBar6Button11,
            MultiBar6Button12,
        }

        -- Hide MultiBar6
        MultiBar6:SetAlpha(0)

        -- Show MultiBar6 on Hover
        for _, Bar7 in pairs(MultiBar6Hover) do
            Bar7:SetScript('OnEnter', function()
                MultiBar6:SetAlpha(1)
            end)

            Bar7:SetScript('OnLeave', function()
                MultiBar6:SetAlpha(0)
            end)
        end
    end
    if (db.bar8) then
        -- Create own pair of MultiBar7
        local MultiBar7Hover = {
            MultiBar7Button1,
            MultiBar7Button2,
            MultiBar7Button3,
            MultiBar7Button4,
            MultiBar7Button5,
            MultiBar7Button6,
            MultiBar7Button7,
            MultiBar7Button8,
            MultiBar7Button9,
            MultiBar7Button10,
            MultiBar7Button11,
            MultiBar7Button12,
        }

        -- Hide MultiBar7
        MultiBar7:SetAlpha(0)

        -- Show MultiBar7 on Hover
        for _, Bar8 in pairs(MultiBar7Hover) do
            Bar8:SetScript('OnEnter', function()
                MultiBar7:SetAlpha(1)
            end)

            Bar8:SetScript('OnLeave', function()
                MultiBar7:SetAlpha(0)
            end)
        end
    end
end