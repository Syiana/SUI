local expBar = SUI:NewModule("Misc.ExpBar");

function expBar:OnEnable()
    local db = {
        expbar = SUI.db.profile.misc.expbar,
        style = SUI.db.profile.actionbar.style,
        texture = SUI.db.profile.general.texture,
        module = SUI.db.profile.modules.misc
    }

    if (db.expbar and db.style == 'Small' and db.module) then
        -- Reposition Exp Bar
        SUIExpBar:ClearAllPoints()
        SUIExpBar:SetPoint("LEFT", SUIMainMenuBar, "LEFT", 1, -30)
        SUIExpBar:SetWidth(SUIMainMenuBar:GetWidth()-5.5)

        -- Status Text
        SUIExpBarText:SetFont([[Fonts\ARIALN.TTF]], 11, 'OUTLINE')

        -- Set Texture
        if (db.texture ~= 'Default') then
            SUIExpBar:SetStatusBarTexture(db.texture)
        end

        -- Add Border to ExpBar
        SUIExpBarBorder = CreateFrame("Frame", SUIExpBarBorder, SUIExpBar, "BackdropTemplate")
        SUIExpBarBorder:SetPoint("LEFT", SUIExpBar, "LEFT", -1.5, 0)
        SUIExpBarBorder:SetSize(SUIExpBar:GetWidth()+3, SUIExpBar:GetHeight()+2)
        SUIExpBarBorder:SetBackdrop({
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            tileEdge = false,
            edgeSize = 6.5,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })

        SUIExpBarBorder:SetBackdropBorderColor(unpack(SUI:Color(.15)))

        -- Check Level
        local expBar = CreateFrame("Frame")
        expBar:RegisterEvent("PLAYER_ENTERING_WORLD")
        expBar:RegisterEvent("PLAYER_LEVEL_UP")
        expBar:HookScript("OnEvent", function()
            local rLevel =  GetMaxLevelForExpansionLevel(GetClampedCurrentExpansionLevel())
            if UnitLevel("player") >= rLevel then
                SUIExpBar:Hide()
            else
                SUIExpBar:Show()
            end
        end)
    else
        SUIExpBar:Hide()
    end
end