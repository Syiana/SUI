local Module = SUI:NewModule("UnitFrames.Boss");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes
    if (db.style == 'Big') then
        function SUIBossFrames()
          for i = 1, MAX_BOSS_FRAMES do
            _G["Boss"..i.."TargetFrameHealthBar"]:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-StatusBar");
            _G["Boss"..i.."TargetFrameManaBar"]:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-StatusBar");
            _G["Boss"..i.."TargetFrameTextureFrameDeadText"]:ClearAllPoints();
            _G["Boss"..i.."TargetFrameTextureFrameDeadText"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameHealthBar"],"CENTER",0,0);
            _G["Boss"..i.."TargetFrameTextureFrameName"]:ClearAllPoints();
            _G["Boss"..i.."TargetFrameTextureFrameName"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrameManaBar"],"CENTER",0,0);
            _G["Boss"..i.."TargetFrameTextureFrameTexture"]:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-UNITFRAME-BOSS");
            _G["Boss"..i.."TargetFrameNameBackground"]:Hide();
            _G["Boss"..i.."TargetFrameHealthBar"]:SetSize(116,18);
            _G["Boss"..i.."TargetFrameHealthBar"]:ClearAllPoints();
            _G["Boss"..i.."TargetFrameHealthBar"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrame"],"CENTER",-51,18);
            _G["Boss"..i.."TargetFrameManaBar"]:SetSize(116,18);
            _G["Boss"..i.."TargetFrameManaBar"]:ClearAllPoints();
            _G["Boss"..i.."TargetFrameManaBar"]:SetPoint("CENTER",_G["Boss"..i.."TargetFrame"],"CENTER",-51,-3);
          end
        end
        SUIBossFrames();
    end
end