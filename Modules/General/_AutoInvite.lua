local Module = SUI:NewModule("General.AutoInvite");

function Module:OnEnable()
	local db = {
		autoinv = SUI.db.profile.general.automation.invite,
		module = SUI.db.profile.modules.general
	}

	if (db.autoinv and db.module) then
		local acceptInvite = CreateFrame("Frame")
		acceptInvite:RegisterEvent("PARTY_INVITE_REQUEST")
		acceptInvite:RegisterEvent("GROUP_ROSTER_UPDATE")

		local function GetQueueStatusButton()
			return QueueStatusButton or MiniMapLFGFrameIcon
		end

		local hideStatic
		local function autoInvite(_, event, _, _, _, _, _, _, guid)
			if event == 'PARTY_INVITE_REQUEST' then
				if not guid or guid == '' or IsInGroup() then return end
		
				local queueButton = GetQueueStatusButton() -- don't auto accept during a queue
				if queueButton and queueButton:IsShown() then return end
		
				if BNGetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) or IsGuildMember(guid) then
					hideStatic = true
					AcceptGroup()
				end
			elseif event == 'GROUP_ROSTER_UPDATE' and hideStatic then
				if LFGInvitePopup then -- invited in custom created group
					StaticPopupSpecial_Hide(LFGInvitePopup)
				end
		
				StaticPopup_Hide('PARTY_INVITE')
				hideStatic = false
			end
		end

		acceptInvite:SetScript("OnEvent", autoInvite)
	end
end