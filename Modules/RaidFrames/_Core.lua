local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
	local db = SUI.db.profile.raidframes

	if (db) then
		local function updateTextures(self)
			if self:IsForbidden() then return end
			if self and self:GetName() then
				local name = self:GetName()
				if name and name:match("^Compact") then
					if self:IsForbidden() then return end
					if db.texture ~= 'Default' then
						self.healthBar:SetStatusBarTexture(db.texture)
						self.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
						self.powerBar:SetStatusBarTexture(db.texture)
						self.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
					end

					self.vertLeftBorder:Hide()
					self.vertRightBorder:Hide()
					self.horizTopBorder:Hide()
					self.horizBottomBorder:Hide()
				end
			end
		end

		hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
			updateTextures(self)
		end)
	end
end
