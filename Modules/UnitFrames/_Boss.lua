local Module = SUI:NewModule("UnitFrames.Boss");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.unitframes,
        module = SUI.db.profile.modules.unitframes
    }

    if (db.style == 'Big' and db.module) then
        function SUIBossFrames()
            for i = 1, MAX_BOSS_FRAMES do
                _G["Boss" .. i .. "TargetFrameHealthBar"]:SetStatusBarTexture(
                "Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-StatusBar");
                _G["Boss" .. i .. "TargetFrameManaBar"]:SetStatusBarTexture(
                "Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-StatusBar");
                _G["Boss" .. i .. "TargetFrameTextureFrameDeadText"]:ClearAllPoints();
                _G["Boss" .. i .. "TargetFrameTextureFrameDeadText"]:SetPoint("CENTER",
                    _G["Boss" .. i .. "TargetFrameHealthBar"], "CENTER", 0, 0);
                _G["Boss" .. i .. "TargetFrameTextureFrameName"]:ClearAllPoints();
                _G["Boss" .. i .. "TargetFrameTextureFrameName"]:SetPoint("CENTER", _G["Boss" .. i .. "TargetFrameManaBar"],
                    "CENTER", 0, 0);
                _G["Boss" .. i .. "TargetFrameTextureFrameTexture"]:SetTexture([[Interface\Addons\SUI\Media\Textures\unitframes\UI-UNITFRAME-BOSS]]);
                _G["Boss" .. i .. "TargetFrameNameBackground"]:Hide();
                _G["Boss" .. i .. "TargetFrameHealthBar"]:SetSize(116, 18);
                _G["Boss" .. i .. "TargetFrameHealthBar"]:ClearAllPoints();
                _G["Boss" .. i .. "TargetFrameHealthBar"]:SetPoint("CENTER", _G["Boss" .. i .. "TargetFrame"], "CENTER",
                    -51, 18);
                _G["Boss" .. i .. "TargetFrameManaBar"]:SetSize(116, 18);
                _G["Boss" .. i .. "TargetFrameManaBar"]:ClearAllPoints();
                _G["Boss" .. i .. "TargetFrameManaBar"]:SetPoint("CENTER", _G["Boss" .. i .. "TargetFrame"], "CENTER",
                    -51, -3);
                -- _G["Boss"..i.."TargetFrameTextureFrameHealthBarTextLeft"]:ClearAllPoints();
                -- _G["Boss"..i.."TargetFrameTextureFrameHealthBarTextLeft"]:SetPoint("LEFT",_G["Boss"..i.."TargetFrameHealthBar"],"LEFT",0,0);
                -- _G["Boss"..i.."TargetFrameTextureFrameHealthBarTextRight"]:ClearAllPoints();
                -- _G["Boss"..i.."TargetFrameTextureFrameHealthBarTextRight"]:SetPoint("RIGHT",_G["Boss"..i.."TargetFrameHealthBar"],"RIGHT",0,0);
                -- _G["Boss"..i.."TargetFrameTextureFrameHealthBarText"]:ClearAllPoints();
                -- _G["Boss"..i.."TargetFrameTextureFrameHealthBarText"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameHealthBar"],"CENTER",0,0);
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarTextLeft"]:ClearAllPoints();
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarTextLeft"]:SetPoint("LEFT",_G["Boss"..i.."TargetFrameManaBar"],"LEFT",0,0);
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarTextRight"]:ClearAllPoints();
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarTextRight"]:SetPoint("RIGHT",_G["Boss"..i.."TargetFrameManaBar"],"RIGHT",0,0);
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarText"]:ClearAllPoints();
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarText"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameManaBar"],"CENTER",0,0);
            end
        end

        function SUIBossFramesText()
            for i = 1, MAX_BOSS_FRAMES do
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarTextLeft"]:SetText(" ");
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarTextRight"]:SetText(" ");
                -- _G["Boss"..i.."TargetFrameTextureFrameManaBarText"]:SetText(" ");
            end
        end

        hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", SUIBossFramesText)
        SUIBossFrames();
    end
end
