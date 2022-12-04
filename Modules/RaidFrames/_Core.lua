local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
	local db = SUI.db.profile.raidframes
	if db then
		local function updateTextures(self)
			if self:IsForbidden() then return end
			local name = self:GetName()
			if name and name:match("^Compact") then
				if db.texture ~= [[Interface\Default]] then
					self.healthBar:SetStatusBarTexture(db.texture)
					self.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
					self.powerBar:SetStatusBarTexture(db.texture)
					self.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
					self.myHealPrediction:SetTexture(db.texture)
					self.otherHealPrediction:SetTexture(db.texture)
				end

				if self:GetName():find('CompactPartyFrame') then
					if SUI:Color() then
						self.horizDivider:SetVertexColor(.3, .3, .3)
						CompactPartyFrameBorderFrameBorderTopLeft:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderTop:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderTopRight:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderLeft:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderRight:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderBottomLeft:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderBottom:SetVertexColor(unpack(SUI:Color(0.15)))
						CompactPartyFrameBorderFrameBorderBottomRight:SetVertexColor(unpack(SUI:Color(0.15)))
					end
				end

				self.vertLeftBorder:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-VSeparator]])
				self.vertRightBorder:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-VSeparator]])
				self.horizTopBorder:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-HSeparator]])
				self.horizBottomBorder:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-HSeparator]])
			end
			--end
		end

		hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
			updateTextures(self)
		end)

		local function updateSize()
			for i = 1, 5 do
				_G["CompactPartyFrameMember" .. i]:SetWidth(db.width)
				_G["CompactPartyFrameMember" .. i]:SetHeight(db.height)
				_G["CompactPartyFrameMember" .. i .. "StatusText"]:ClearAllPoints()
				_G["CompactPartyFrameMember" .. i .. "StatusText"]:SetPoint("CENTER", _G["CompactPartyFrameMember" .. i], "CENTER")
				_G["CompactPartyFrameMember" .. i .. "CenterStatusIcon"]:ClearAllPoints()
				_G["CompactPartyFrameMember" .. i .. "CenterStatusIcon"]:SetPoint("CENTER", _G["CompactPartyFrameMember" .. i],
					"CENTER")
			end
		end

		-- Hide Titles
		CompactPartyFrameTitle:Hide()

		-- Update PartyFrame Size
		if (db.size) then
			local Size = CreateFrame("Frame")
			Size:RegisterEvent("ADDON_LOADED")
			Size:RegisterEvent("PLAYER_LOGIN")
			Size:RegisterEvent("VARIABLES_LOADED")
			Size:RegisterEvent("PLAYER_ENTERING_WORLD")
			Size:RegisterEvent("GROUP_ROSTER_UPDATE")
			Size:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
			Size:SetScript("OnEvent", updateSize)

			hooksecurefunc(C_EditMode, "OnEditModeExit", updateSize)
		end
	end
end
