local ADDON, SUI = ...
SUI.MODULES.RAIDFRAMES.Raid = function(DB) 
	if (DB and DB.STATE) then
        -- CONFIG
		local config = SUIDB.RAIDFRAMES.CONFIG
		
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
			rbar = _G["CompactRaidFrame" .. i .. "PowerBar"]
			Divider = _G["CompactRaidFrame" .. i .. "HorizDivider"]
			vleftseparator = _G["CompactRaidFrame" .. i .. "VertLeftBorder"]
			vrightseparator = _G["CompactRaidFrame" .. i .. "VertRightBorder"]
			htopseparator = _G["CompactRaidFrame" .. i .. "HorizTopBorder"]
			hbotseparator = _G["CompactRaidFrame" .. i .. "HorizBottomBorder"]
			bordertopleft = _G["CompactRaidFrameContainerBorderFrameBorderTopLeft"]
			bordertop = _G["CompactRaidFrameContainerBorderFrameBorderTop"]
			bordertopright = _G["CompactRaidFrameContainerBorderFrameBorderTopRight"]
			borderleft = _G["CompactRaidFrameContainerBorderFrameBorderLeft"]
			borderright = _G["CompactRaidFrameContainerBorderFrameBorderRight"]
			borderbottomleft = _G["CompactRaidFrameContainerBorderFrameBorderBottomLeft"]
			borderbottom = _G["CompactRaidFrameContainerBorderFrameBorderBottom"]
			borderbottomright = _G["CompactRaidFrameContainerBorderFrameBorderBottomRight"]
			if bar then
			--STATUSBAR
			bar:SetStatusBarTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\Raid-Bar-Hp-Fill")
			rbar:SetStatusBarTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\Raid-Bar-Resource-Fill")
			--DARK
			bordertopleft:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-UpperLeft")
			bordertop:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-UpperMiddle")
			bordertopright:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-UpperRight")
			borderleft:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-Left")
			borderright:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-Right")
			borderbottomleft:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-BottomLeft")
			borderbottom:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-BottomMiddle")
			borderbottomright:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\RaidBorder-BottomRight")
			vleftseparator:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\Raid-VSeparator")
			vrightseparator:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\Raid-VSeparator")
			htopseparator:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\Raid-HSeparator")
			hbotseparator:SetTexture("Interface\\AddOns\\SUI\\inc\\media\\raid\\Raid-HSeparator")

			Divider:SetVertexColor(.3, .3, .3)
			end
			i = i + 1
			until not bar
		end

		if (config.Textures) == true then
			if CompactRaidFrameContainer_AddUnitFrame then
				--self:UnregisterAllEvents()
				hooksecurefunc("CompactRaidFrameContainer_AddUnitFrame", update)
				hooksecurefunc("CompactUnitFrame_UpdateAll", update)
				update()
			end
		end

		--RAID BUFFS
		if (config.PartyBuffs) == true then
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
end end