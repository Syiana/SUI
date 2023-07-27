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

				if name:find('CompactPartyFrame') then
					if SUI:Color() then
						self.horizDivider:SetVertexColor(.3, .3, .3)
						for _, region in pairs({ CompactPartyFrameBorderFrame:GetRegions() }) do
							if region:IsObjectType("Texture") then
								region:SetVertexColor(unpack(SUI:Color(0.15)))
							end
						end
					end
				end

				self.vertLeftBorder:Hide()
				self.vertRightBorder:Hide()
				self.horizTopBorder:Hide()
				self.horizBottomBorder:Hide()
			end
			--end
		end

		hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
			updateTextures(self)
		end)

		local function updateSize(self)
			if self:IsForbidden() then return end
			local name = self:GetName()
		
			if name and name:match("CompactPartyFrame") then
				self:SetWidth(db.width)
				self:SetHeight(db.height)
				self.statusText:ClearAllPoints()
				self.statusText:SetPoint("CENTER", self, "CENTER")
				self.centerStatusIcon:ClearAllPoints()
				self.centerStatusIcon:SetPoint("CENTER", self, "CENTER")
			end
		end

		-- Hide Titles
		CompactPartyFrameTitle:Hide()

		-- Update PartyFrame Size
		if (db.size) then
			hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
				updateSize(self)
			end)
		end
	end
end