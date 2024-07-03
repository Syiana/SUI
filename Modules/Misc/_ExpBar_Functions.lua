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
    SUIExhaustionTick.timer = 1;

    GameTooltip_AddNewbieTip(self, label, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_XPBAR, 1);
    GameTooltip.canAddRestStateLine = 1;
end

function SUIExhaustionTick_OnLoad(self)
	SUIExhaustionTick:RegisterEvent("PLAYER_ENTERING_WORLD");
	SUIExhaustionTick:RegisterEvent("PLAYER_XP_UPDATE");
	SUIExhaustionTick:RegisterEvent("UPDATE_EXHAUSTION");
	SUIExhaustionTick:RegisterEvent("PLAYER_LEVEL_UP");
	SUIExhaustionTick:RegisterEvent("PLAYER_UPDATE_RESTING");
end

function SUIExhaustionTick_OnEvent(self, event, ...)
	if (IsRestrictedAccount()) then
		local rlevel = GetRestrictedAccountData();
		if (UnitLevel("player") >= rlevel) then
			SUIExpBar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0);
			SUIExhaustionTick:Hide();
			SUIExhaustionLevelFillBar:Hide();
			self:UnregisterAllEvents();
			return;
		end
	end
	if ((event == "PLAYER_ENTERING_WORLD") or (event == "PLAYER_XP_UPDATE") or (event == "UPDATE_EXHAUSTION") or (event == "PLAYER_LEVEL_UP")) then
		local playerCurrXP = UnitXP("player");
		local playerMaxXP = UnitXPMax("player");
		local exhaustionThreshold = GetXPExhaustion();
		local exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier;
		exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier = GetRestState();
		if (exhaustionStateID >= 3) then
			SUIExhaustionTick:SetPoint("CENTER", "SUIExpBar", "RIGHT", 0, 0);
		end

		if (not exhaustionThreshold) then
			SUIExhaustionTick:Hide();
			SUIExhaustionLevelFillBar:Hide();
		else
			local exhaustionTickSet = max(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * SUIExpBar:GetWidth(), 0);
			SUIExhaustionTick:ClearAllPoints();
			if (exhaustionTickSet > SUIExpBar:GetWidth()) then
				SUIExhaustionTick:Hide();
				SUIExhaustionLevelFillBar:Hide();
			else
				SUIExhaustionTick:Show();
				SUIExhaustionTick:SetPoint("CENTER", "SUIExpBar", "LEFT", exhaustionTickSet, 0);
				SUIExhaustionLevelFillBar:Show();
				SUIExhaustionLevelFillBar:SetPoint("TOPRIGHT", "SUIExpBar", "TOPLEFT", exhaustionTickSet, 0);
			end
		end

		-- Hide exhaustion tick if player is max level or XP is turned off
		if ( UnitLevel("player") == GetMaxPlayerLevel() ) then
			SUIExhaustionTick:Hide();
		end
	end
	if ((event == "PLAYER_ENTERING_WORLD") or (event == "UPDATE_EXHAUSTION")) then
		local exhaustionStateID = GetRestState();
		if (exhaustionStateID == 1) then
			SUIExpBar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0);
			SUIExhaustionLevelFillBar:SetVertexColor(0.0, 0.39, 0.88, 0.15);
			SUIExhaustionTickHighlight:SetVertexColor(0.0, 0.39, 0.88);
		elseif (exhaustionStateID == 2) then
			SUIExpBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0);
			SUIExhaustionLevelFillBar:SetVertexColor(0.58, 0.0, 0.55, 0.15);
			SUIExhaustionTickHighlight:SetVertexColor(0.58, 0.0, 0.55);
		end

	end
	if ( not SUIExpBar:IsShown() ) then
		SUIExhaustionTick:Hide();
	end
end

function SUIExhaustionToolTipText()
	if ( GetCVar("showNewbieTips") ~= "1" ) then
		local x,y = SUIExhaustionTick:GetCenter();
		if ( SUIExhaustionTick:IsVisible() ) then
			if ( x >= ( GetScreenWidth() / 2 ) ) then
				GameTooltip:SetOwner(SUIExhaustionTick, "ANCHOR_LEFT");
			else
				GameTooltip:SetOwner(SUIExhaustionTick, "ANCHOR_RIGHT");
			end
		else
			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		end
	end

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

function SUIExhaustionTick_OnUpdate(self, elapsed)
    self:Hide()
	if ( self.timer ) then
		if ( self.timer < 0 ) then
			SUIExhaustionToolTipText();
			self.timer = nil;
		else
			self.timer = self.timer - elapsed;
		end
	end
end