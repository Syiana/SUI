local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
  local db = SUI.db.profile.raidframes
	if (db) then
		-- HIDE RAIDFRAMERESIZE
		local n, w, h = "CompactUnitFrameProfilesGeneralOptionsFrame"
		h, w = _G[n .. "HeightSlider"], _G[n .. "WidthSlider"]
		h:SetMinMaxValues(1, 200)
		w:SetMinMaxValues(1, 200)

		--BLACK SKIN
		local function update()
			local i, bar = 1
			repeat
			bar = _G["CompactRaidFrame" .. i .. "HealthBar"]
			local rbar = _G["CompactRaidFrame" .. i .. "PowerBar"]
			local Divider = _G["CompactRaidFrame" .. i .. "HorizDivider"]
			local vleftseparator = _G["CompactRaidFrame" .. i .. "VertLeftBorder"]
			local vrightseparator = _G["CompactRaidFrame" .. i .. "VertRightBorder"]
			local htopseparator = _G["CompactRaidFrame" .. i .. "HorizTopBorder"]
			local hbotseparator = _G["CompactRaidFrame" .. i .. "HorizBottomBorder"]
			local bordertopleft = _G["CompactRaidFrameContainerBorderFrameBorderTopLeft"]
			local bordertop = _G["CompactRaidFrameContainerBorderFrameBorderTop"]
			local bordertopright = _G["CompactRaidFrameContainerBorderFrameBorderTopRight"]
			local borderleft = _G["CompactRaidFrameContainerBorderFrameBorderLeft"]
			local borderright = _G["CompactRaidFrameContainerBorderFrameBorderRight"]
			local borderbottomleft = _G["CompactRaidFrameContainerBorderFrameBorderBottomLeft"]
			local borderbottom = _G["CompactRaidFrameContainerBorderFrameBorderBottom"]
			local borderbottomright = _G["CompactRaidFrameContainerBorderFrameBorderBottomRight"]
			if bar then
				--STATUSBAR
				if (db.texture ~= 'Default') then
					bar:SetStatusBarTexture(db.texture)
					rbar:SetStatusBarTexture(db.texture)
				end
				--DARK
				bordertopleft:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-UpperLeft")
				bordertop:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-UpperMiddle")
				bordertopright:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-UpperRight")
				borderleft:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-Left")
				borderright:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-Right")
				borderbottomleft:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-BottomLeft")
				borderbottom:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-BottomMiddle")
				borderbottomright:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-BottomRight")
				vleftseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-VSeparator")
				vrightseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-VSeparator")
				htopseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-HSeparator")
				hbotseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-HSeparator")

				Divider:SetVertexColor(.3, .3, .3)
			end
			i = i + 1
			until not bar
		end

		if (SUI:Color()) then
			if CompactRaidFrameContainer_AddUnitFrame then
				--self:UnregisterAllEvents()
				hooksecurefunc("CompactRaidFrameContainer_AddUnitFrame", update)
				hooksecurefunc("CompactUnitFrame_UpdateAll", update)
				update()
			end
		end

		--RAID BUFFS
		if (db.partybuffs) == true then
			for i = 1, 4 do
				local f = _G["PartyMemberFrame" .. i]
				f:UnregisterEvent("UNIT_AURA")
				local g = CreateFrame("Frame")
				g:RegisterEvent("UNIT_AURA")
				g:SetScript(
					"OnEvent",
					function(self, event, a1)
						if a1 == f.unit then
							RefreshDebuffs(f, a1, 20, nil, 1)
						else
							if a1 == f.unit .. "pet" then
								PartyMemberFrame_RefreshPetDebuffs(f)
							end
						end
					end
				)
				local b = _G[f:GetName() .. "Debuff1"]
				b:ClearAllPoints()
				b:SetPoint("LEFT", f, "RIGHT", -7, 5)
				for j = 5, 20 do
					local l = f:GetName() .. "Debuff"
					local n = l .. j
					local c = CreateFrame("Frame", n, f, "PartyDebuffFrameTemplate")
					c:SetPoint("LEFT", _G[l .. (j - 1)], "RIGHT")
				end
			end
		end

		for i = 1, 4 do
			local f = _G["PartyMemberFrame" .. i]
			f:UnregisterEvent("UNIT_AURA")
			local g = CreateFrame("Frame")
			g:RegisterEvent("UNIT_AURA")
			g:SetScript(
				"OnEvent",
				function(self, event, a1)
					if a1 == f.unit then
						RefreshBuffs(f, a1, 20, nil, 1)
					end
				end
			)
			for j = 1, 20 do
				local l = f:GetName() .. "Buff"
				local n = l .. j
				local c = CreateFrame("Frame", n, f, "TargetBuffFrameTemplate")
				c:EnableMouse(false)
				if j == 1 then
					c:SetPoint("TOPLEFT", 48, -32)
				else
					c:SetPoint("LEFT", _G[l .. (j - 1)], "RIGHT", 1, 0)
				end
			end
		end
	end
end