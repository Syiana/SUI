function SUIExpBar_Update()
    local currXP = UnitXP("player");
    local nextXP = UnitXPMax("player");
    local level = UnitLevel("player");

    local isCapped = false;
    if (GameLimitedMode_IsActive()) then
        local rLevel = GetRestrictedAccountData();
        if UnitLevel("player") >= rLevel then
            isCapped = true;
            SUIExpBar:SetMinMaxValues(0,1);
            SUIExpBar:SetValue(1)
            SUIExpBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0);
        end
    end
    if (not isCapped) then
        local min, max = math.min(0, currXP), nextXP;
        SUIExpBar:SetMinMaxValues(min,max);
        SUIExpBar:SetValue(currXP)
    end
end

function SUIExpBar_UpdateTextString()
    TextStatusBar_UpdateTextString(SUIExpBar);
    if (GameLimitedMode_IsActive()) then
        local rLevel = GetRestrictedAccountData();
        if (UnitLevel("player") >= rLevel) then
            local nextXP = UnitXPMax("player");
            local trialXP = UnitTrialXP("player");
            SUIExpBar.TextString:SetText(SUIExpBar.prefix.." "..trialXP.." / "..nextXP);
        end
    end
end

function SUIExpBar_OnEnter(self)
    ShowTextStatusBarText(self);
    SUIExpBar_UpdateTextString();
    local label = XPBAR_LABEL;
    if (GameLimitedMode_IsActive()) then
        local rLevel = GetRestrictedAccountData();
        if UnitLevel("player") >= rLevel then
            local trialXP = UnitTrialXP("player");
            local bankedLevels = UnitTrialBankedLevels("player");
            if (trialXP > 0) then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                local text = TRIAL_CAP_BANKED_XP_TOOLTIP;
                if (bankedLevels > 0) then
                    text = TRIAL_CAP_BANKED_LEVELS_TOOLTIP:format(bankedLevels);
                end
                GameTooltip:SetText(text, nil, nil, nil, nil, true);
                GameTooltip:Show();
                return
            else
                label = label.." "..RED_FONT_COLOR_CODE..CAP_REACHED_TRIAL.."|r";
            end
        end
    end

    GameTooltip_AddNewbieTip(self, label, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_XPBAR, 1);
    GameTooltip.canAddRestStateLine = 1;
end

function SUIExhaustionToolTipText()
	local exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier = GetRestState();
	exhaustionStateMultiplier = exhaustionStateMultiplier * 100;

	local tooltipText = format(EXHAUST_TOOLTIP1, exhaustionStateName, exhaustionStateMultiplier);
	local append = nil;
	if ( ((exhaustionStateID == 4) or (exhaustionStateID == 5)) and not IsResting() ) then
		append = EXHAUST_TOOLTIP2;
	end

	if ( append ) then
		tooltipText = tooltipText..append;
	end

	if ( GetCVar("showNewbieTips") ~= "1" ) then
		GameTooltip:SetText(tooltipText);
	else
		if ( GameTooltip.canAddRestStateLine ) then
			GameTooltip:AddLine("\n"..tooltipText);
			GameTooltip:Show();
			GameTooltip.canAddRestStateLine = nil;
		end
	end
end