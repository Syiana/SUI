--[[
--TEXTURE
local function SetTextures()
	if SUIDB.MODULES.TEXTURES == true then
		for _, StatusBarTextures in pairs(
			{
				PlayerFrameHealthBar,
				TargetFrameHealthBar,
				TargetFrameToTHealthBar,
				FocusFrameHealthBar,
				FocusFrameToTHealthBar,
				PlayerFrameHealthBar.AnimatedLossBar,
				PartyMemberFrame1HealthBar,
				PartyMemberFrame2HealthBar,
				PartyMemberFrame3HealthBar,
				PartyMemberFrame4HealthBar,
				--PartyMemberFrame1ManaBar,
				--PartyMemberFrame2ManaBar,
				--PartyMemberFrame3ManaBar,
				--PartyMemberFrame4ManaBar,
				CastingBarFrame,
				TargetFrameSpellBar,
				FocusFrameSpellBar
			}
		) do
			StatusBarTextures:SetStatusBarTexture("Interface\\Addons\\SUI\\inc\\inc\\media\\unitframes\\UI-StatusBar")
		end
	end
	end
	
	hooksecurefunc("UnitFrameHealthBar_Update",function(self)
		SetTextures()
	end)
	
	hooksecurefunc("HealthBar_OnValueChanged",function(self)
		SetTextures()
	end)
	
	hooksecurefunc("UnitFrameManaBar_UpdateType",function(manaBar)
		SetTextures()
	end)
]]