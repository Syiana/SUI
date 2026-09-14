local Module = SUI:NewModule("RaidFrames.Core");

function Module:ApplyRaidScale()
	local db = SUI.db.profile.raidframes
	local scale = db and db.raidscale or 1
	if scale == 1 or InCombatLockdown() then
		return
	end

	if CompactRaidFrameContainer and not CompactRaidFrameContainer:IsForbidden() then
		pcall(CompactRaidFrameContainer.SetScale, CompactRaidFrameContainer, scale)
	end
end

function Module:ApplyPartyScale()
	local db = SUI.db.profile.raidframes
	local scale = db and db.partyscale or 1
	local scaled = false
	if scale == 1 or InCombatLockdown() then
		return
	end

	if PartyFrame and not PartyFrame:IsForbidden() then
		pcall(PartyFrame.SetScale, PartyFrame, scale)
		scaled = true
	end

	if CompactPartyFrame and not CompactPartyFrame:IsForbidden() then
		pcall(CompactPartyFrame.SetScale, CompactPartyFrame, scale)
		scaled = true
	end

	if not scaled then
		for i = 1, 4 do
			local frame = _G["PartyMemberFrame" .. i]
			if frame and not frame:IsForbidden() then
				pcall(frame.SetScale, frame, scale)
			end
		end
	end
end

function Module:RefreshLayout()
	self:ApplyRaidScale()
	self:ApplyPartyScale()
end

function Module:OnEnable()
	local db = SUI.db.profile.raidframes
	if db then
		local function updateTextures(self)
			if self:IsForbidden() then return end
			if self and self:GetName() then
				local name = self:GetName()
				if name and name:match("^Compact") then
					if self:IsForbidden() then return end
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
						if self.horizDivider then
							self.horizDivider:SetVertexColor(.3, .3, .3)
						end
						for _, region in pairs({ CompactPartyFrameBorderFrame:GetRegions() }) do
							if region:IsObjectType("Texture") then
								region:SetVertexColor(unpack(SUI:Color(0.15)))
							end
							end
						end
					end

				if self.vertLeftBorder then self.vertLeftBorder:Hide() end
				if self.vertRightBorder then self.vertRightBorder:Hide() end
				if self.horizTopBorder then self.horizTopBorder:Hide() end
				if self.horizBottomBorder then self.horizBottomBorder:Hide() end
				end
			end
		end

		hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
			updateTextures(self)
		end)

		local function updateSize(self)
			if self:IsForbidden() then return end
			if self and self:GetName() then
				local name = self:GetName()

				if name and name:match("^CompactPartyFrameMember") then
					if not InCombatLockdown() then
						self:SetWidth(db.width)
						self:SetHeight(db.height)
						self.statusText:ClearAllPoints()
						self.statusText:SetPoint("CENTER", self, "CENTER")
						self.centerStatusIcon:ClearAllPoints()
						self.centerStatusIcon:SetPoint("CENTER", self, "CENTER")
					end
				elseif name and name:match("^CompactPartyFramePet") then
					if self:IsForbidden() then return end
					if not InCombatLockdown() then
						self:SetWidth(db.width)
					end
				end
			end
		end

		-- Hide Titles
		CompactPartyFrameTitle:Hide()

		-- Update PartyFrame Size
		if (db.size) then
			local eventFrame = CreateFrame("Frame")
			eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			eventFrame:SetScript("OnEvent", function(_, event)
				local partyFrames = {
					CompactPartyFrameMember1,
					CompactPartyFrameMember2,
					CompactPartyFrameMember3,
					CompactPartyFrameMember4,
					CompactPartyFrameMember5
				}

				if event == "PLAYER_REGEN_DISABLED" then
					CompactPartyFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
					for i = 1, #partyFrames do
						partyFrames[i]:UnregisterEvent("UNIT_PET")
					end
				else
					CompactPartyFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
					for i = 1, #partyFrames do
						partyFrames[i]:RegisterEvent("UNIT_PET")
						updateSize(partyFrames[i])
					end
				end
			end)

			hooksecurefunc("CompactUnitFrame_UpdateAll", function(self)
				updateSize(self)
			end)
		end

		if db.raidscale ~= 1 and CompactRaidFrameContainer and CompactRaidFrameContainer.ApplyToFrames then
			hooksecurefunc(CompactRaidFrameContainer, "ApplyToFrames", function()
				C_Timer.After(0.1, function()
					Module:ApplyRaidScale()
				end)
			end)
		end

		local eventFrame = CreateFrame("Frame")
		eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		eventFrame:RegisterEvent("UI_SCALE_CHANGED")
		eventFrame:SetScript("OnEvent", function()
			if db.raidscale == 1 and db.partyscale == 1 then
				return
			end

			C_Timer.After(0.1, function()
				Module:RefreshLayout()
			end)
		end)

		if db.raidscale ~= 1 or db.partyscale ~= 1 then
			C_Timer.After(0.1, function()
				Module:RefreshLayout()
			end)
		end
	end
end
