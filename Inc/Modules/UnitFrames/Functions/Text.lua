            -- DEAD TEXT
            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues",function(self)
                local deadText = DEAD;
                local ghostText = "Ghost";
        
                if UnitIsDead("player") or UnitIsGhost("player") then
                    PlayerFrameHealthBarText:SetFontObject(GameFontNormalSmall);
                    for i, v in pairs({	PlayerFrameHealthBar.LeftText, PlayerFrameHealthBar.RightText, PlayerFrameManaBar.LeftText, PlayerFrameManaBar.RightText, PlayerFrameTextureFrameManaBarText, PlayerFrameManaBar }) do v:SetAlpha(0); end
                    if GetCVar("statusTextDisplay")=="BOTH" then
                        PlayerFrameHealthBarText:Show();
                    end
                    if UnitIsDead("player") then
                        PlayerFrameHealthBarText:SetText(deadText);
                    elseif UnitIsGhost("player") then
                        PlayerFrameHealthBarText:SetText(ghostText);
                    end
                elseif not UnitIsDead("player") and not UnitIsGhost("player") then
                    PlayerFrameHealthBarText:SetFontObject(TextStatusBarText);
                    for i, v in pairs({	PlayerFrameHealthBar.LeftText, PlayerFrameHealthBar.RightText, PlayerFrameManaBar.LeftText, PlayerFrameManaBar.RightText, PlayerFrameTextureFrameManaBarText, PlayerFrameManaBar }) do v:SetAlpha(1); end
                end
        
                if UnitExists("target") and UnitIsDead("target") or UnitIsGhost("target") then
                    TargetFrameTextureFrameHealthBarText:SetFontObject(GameFontNormalSmall);
                    if GetCVar("statusTextDisplay")=="BOTH" then
                        TargetFrameTextureFrameHealthBarText:Show();
                    end
                    for i, v in pairs({	TargetFrameHealthBar.LeftText, TargetFrameHealthBar.RightText, TargetFrameManaBar.LeftText, TargetFrameManaBar.RightText, TargetFrameTextureFrameManaBarText, TargetFrameManaBar }) do v:SetAlpha(0); end
                    if UnitIsGhost("target") and not UnitIsDead("target") then
                        TargetFrameTextureFrameHealthBarText:SetText(ghostText);
                    end
                elseif not UnitIsDead("target") and not UnitIsGhost("target") then
                    TargetFrameTextureFrameHealthBarText:SetFontObject(TextStatusBarText);
                    for i, v in pairs({	TargetFrameHealthBar.LeftText, TargetFrameHealthBar.RightText, TargetFrameManaBar.LeftText, TargetFrameManaBar.RightText, TargetFrameTextureFrameManaBarText, TargetFrameManaBar }) do v:SetAlpha(1); end
                end
        
                if UnitExists("focus") and UnitIsDead("focus") or UnitIsGhost("focus") then
                    FocusFrameTextureFrameHealthBarText:SetFontObject(GameFontNormalSmall);
                    if GetCVar("statusTextDisplay")=="BOTH" then
                        FocusFrameTextureFrameHealthBarText:Show();
                    end
                    for i, v in pairs({	FocusFrameHealthBar.LeftText, FocusFrameHealthBar.RightText, FocusFrameManaBar.LeftText, FocusFrameManaBar.RightText, FocusFrameTextureFrameManaBarText, FocusFrameManaBar }) do v:SetAlpha(0); end
                    if UnitIsGhost("focus") then
                        FocusFrameTextureFrameHealthBarText:SetText(ghostText);
                    end
                elseif not UnitIsDead("focus") and not UnitIsGhost("focus") then
                    FocusFrameTextureFrameHealthBarText:SetFontObject(TextStatusBarText);
                    for i, v in pairs({	FocusFrameHealthBar.LeftText, FocusFrameHealthBar.RightText, FocusFrameManaBar.LeftText, FocusFrameManaBar.RightText, FocusFrameTextureFrameManaBarText, FocusFrameManaBar }) do v:SetAlpha(1); end
                end
            end)
        