local Module = SUI:NewModule("RaidFrames.Show");

function Module:OnEnable()
	local db = SUI.db.profile.maps

	local t = {
		Blizzard_CompactRaidFrames = true,
		Blizzard_CUFProfiles = true
	}

	-- Thou shalt not hard disable the Raid Frames
	hooksecurefunc("C_AddOns.DisableAddOn", function(addon)
		if t[addon] then
			C_AddOns.EnableAddOn(addon)
		end
	end)

	-- So It Has Come To This
	if not C_AddOns.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
		for k in pairs(t) do
			C_AddOns.EnableAddOn(k)
		end

		local old = SetItemRef

		function SetItemRef(...)
			local link = ...
			if link == "reload" then
				ReloadUI()
			else
				old(...)
			end
		end

		print("|cff33FF99ShowRaidFrame:|r Requires |cffFF8040|Hreload|h[Reload]|h|r")
		return
	end

	local noop = function()
	end

	-- Thou shalt not hide the Raid Frames
	for _, v in ipairs({ CompactRaidFrameManager, CompactRaidFrameContainer }) do
		v.UnregisterAllEvents = noop
		v.UnregisterEvent = noop

		-- taints the raid frames; nothing to do about it
		v.Hide = noop -- stops other addons from hiding the raid frames
		v:Show() -- shows the raid frames before other addons can possibly disable :Show
	end

	-- yes I'm a noob with libraries >.<
	if not FixRaidTaint then
		local container = CompactRaidFrameContainer

		local t = {
			discrete = "flush",
			flush = "discrete"
		}

		-- refresh the (tainted) raid frames after combat
		local function OnEvent(self)
			-- secure (probably not) or still in combat somehow
			if issecurevariable("CompactRaidFrame1") or InCombatLockdown() or not container:IsShown() then
				return
			end

			-- Bug #1: left/joined players not updated
			-- Bug #2: sometimes selecting different than the intended target

			-- change back and forth from flush <-> discrete
			local mode = container.groupMode                  -- groupMode changes after _SetGroupMode calls
			CompactRaidFrameContainer_SetGroupMode(container, t[mode]) -- forth
			CompactRaidFrameContainer_SetGroupMode(container, mode) -- back
		end

		local f = CreateFrame("Frame", "FixRaidTaint")
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		f:SetScript("OnEvent", OnEvent)

		f.version = 0.2
	end

	-- sets the USE_RAID_STYLE_PARTY_FRAMES CVar
	SetCVar("useCompactPartyFrames", 1)

	-- maybe disable the option to show party frames since we can't hide the raid frames anymore
	--CompactUnitFrameProfilesRaidStylePartyFrames:Disable()
end
