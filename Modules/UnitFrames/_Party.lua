local Module = SUI:NewModule("UnitFrames.Party");

function Module:OnEnable()
    local db = {
      unitframes = SUI.db.profile.unitframes,
      texture = SUI.db.profile.general.texture
    }

    if (db.unitframes.style == 'Big') then
      function SUIPartyFrames()
        local useCompact = GetCVarBool("useCompactPartyFrames");
        if IsInGroup(player) and (not IsInRaid(player)) and (not useCompact) then
            for i = 1, 4 do
              if (db.texture ~= 'Default') then
                  _G["PartyMemberFrame"..i.."HealthBar"]:SetStatusBarTexture(db.texture);
                  _G["PartyMemberFrame"..i.."ManaBar"]:SetStatusBarTexture(db.texture);
              end
              _G["PartyMemberFrame"..i.."Name"]:SetSize(75,10);
              _G["PartyMemberFrame"..i.."Texture"]:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-PartyFrame");
              _G["PartyMemberFrame"..i.."Flash"]:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\unitframes\\UI-PARTYFRAME-FLASH");
              _G["PartyMemberFrame"..i.."HealthBar"]:ClearAllPoints();
              _G["PartyMemberFrame"..i.."HealthBar"]:SetPoint("TOPLEFT", 45, -13);
              _G["PartyMemberFrame"..i.."HealthBar"]:SetHeight(12);
              _G["PartyMemberFrame"..i.."ManaBar"]:ClearAllPoints();
              _G["PartyMemberFrame"..i.."ManaBar"]:SetPoint("TOPLEFT", 45, -26);
              _G["PartyMemberFrame"..i.."ManaBar"]:SetHeight(5);
              --_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:ClearAllPoints();
              --_G["PartyMemberFrame"..i.."HealthBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "LEFT", 0, 0);
              --_G["PartyMemberFrame"..i.."HealthBarTextRight"]:ClearAllPoints();
              --_G["PartyMemberFrame"..i.."HealthBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0);
              --_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "LEFT", 0, 0);
              --_G["PartyMemberFrame"..i.."ManaBarTextLeft"]:ClearAllPoints();
              --_G["PartyMemberFrame"..i.."ManaBarTextRight"]:ClearAllPoints();
              --_G["PartyMemberFrame"..i.."ManaBarTextRight"]:SetPoint("RIGHT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0);
              --_G["PartyMemberFrame"..i.."HealthBarText"]:ClearAllPoints();
              --_G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("CENTER", _G["PartyMemberFrame"..i.."HealthBar"], "CENTER", 0, 0);
              --_G["PartyMemberFrame"..i.."ManaBarText"]:ClearAllPoints();
              --_G["PartyMemberFrame"..i.."ManaBarText"]:SetPoint("CENTER", _G["PartyMemberFrame"..i.."ManaBar"], "CENTER", 0, 0);
            end
        end
      end
      hooksecurefunc("UnitFrame_Update", SUIPartyFrames)
      hooksecurefunc("PartyMemberFrame_ToPlayerArt", SUIPartyFrames)
    end
end