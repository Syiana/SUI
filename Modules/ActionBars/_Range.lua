local Range = SUI:NewModule("ActionBars.Range");

function Range:OnEnable()
  local db = SUI.db.profile.actionbar

  if (db.buttons.range) then
    local _G = _G;

    function RedRange_ActionButton_UpdateUsable(actionBarButton)
        if (actionBarButton.UpdateUsable ~= nil) then
            hooksecurefunc(actionBarButton, "UpdateUsable", function(self)
                local action = self.action;
                local icon = self.icon;
                local isUsable, notEnoughMana = IsUsableAction(action)
                local normalTexture = self.NormalTexture;
                if ( not normalTexture ) then
                    return;
                end
                if (ActionHasRange(action) and IsActionInRange(action) == false) then
                    icon:SetVertexColor(.8, .1, .1);
                    normalTexture:SetVertexColor(.8, .1, .1);
                    self.redRangeRed = true;
                elseif (self.redRangeRed) then
                    if (isUsable) then
                        icon:SetVertexColor(1, 1, 1);
                        normalTexture:SetVertexColor(1, 1, 1);
                        self.redRangeRed = false;
                    elseif (notEnoughMana) then
                        icon:SetVertexColor(.5, .5, 1);
                        normalTexture:SetVertexColor(.5, .5, 1);
                        self.redRangeRed = false;
                    else
                        icon:SetVertexColor(.4, .4, .4);
                        normalTexture:SetVertexColor(1, 1, 1);
                        self.redRangeRed = false;
                    end
                end
            end)
        end
    end
    
    function RedRange_ActionButton_UpdateRangeIndicator(self, checksRange, inRange)
        if ( checksRange and not inRange ) then
            local icon = self.icon;
            local normalTexture = self.NormalTexture;
            icon:SetVertexColor(.8, .1, .1);
            if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
                normalTexture:SetVertexColor(.8, .1, .1);
            end
            self.redRangeRed = true;
        elseif (self.redRangeRed) then
            local icon = self.icon;
            local normalTexture = self.NormalTexture;
            local action = self.action;
            if (action) then
                local isUsable, notEnoughMana = IsUsableAction(action)
                if (isUsable) then
                    icon:SetVertexColor(1, 1, 1);
                    if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
                        normalTexture:SetVertexColor(1, 1, 1);
                    end
                elseif (notEnoughMana) then
                    icon:SetVertexColor(.5, .5, 1);
                    if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
                        normalTexture:SetVertexColor(.5, .5, 1);
                    end
                else
                    icon:SetVertexColor(.3, .3, .3);
                    if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
                        normalTexture:SetVertexColor(1, 1, 1);
                    end
                end
            else
                icon:SetVertexColor(1, 1, 1);
                if (normalTexture ~= nil) and (next(normalTexture) ~= nil) then
                    normalTexture:SetVertexColor(1, 1, 1);
                end
            end
            self.redRangeRed = false;
        end
    end
    
    if (not REDRANGEICONS_HOOKED) then
        hooksecurefunc("ActionButton_UpdateRangeIndicator", RedRange_ActionButton_UpdateRangeIndicator);
        for i = 1, 12 do
            local actionButton
            actionButton = _G["ExtraActionButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["ActionButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["MultiBarBottomLeftButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["MultiBarBottomRightButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["MultiBarLeftButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["MultiBarRightButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["PetActionButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton = _G["StanceButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton =  _G["PossessButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
            actionButton =  _G["OverrideActionBarButton"..i]
            if (actionButton) then
                RedRange_ActionButton_UpdateUsable(actionButton)
            end
        end
        REDRANGEICONS_HOOKED = true
    end
    
  end

end