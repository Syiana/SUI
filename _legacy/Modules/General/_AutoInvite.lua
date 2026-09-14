local Module = SUI:NewModule("General.AutoInvite");

function Module:OnEnable()
	local db = SUI.db.profile.general.automation.invite
	if db then
		local acceptInvite = CreateFrame("Frame")
		acceptInvite:RegisterEvent("PARTY_INVITE_REQUEST")
		acceptInvite:RegisterEvent("GROUP_ROSTER_UPDATE")

		local function GetQueueStatusButton()
			return _G.QueueStatusButton or _G.MiniMapLFGFrame
		end

		local hide
		local function autoInvite(event, _, _, _, _, _, _, inviterGUID)
			if event == 'PARTY_INVITE_REQUEST' then
				if not inviterGUID or inviterGUID == '' or IsInGroup() then return end
		
				local queueButton = GetQueueStatusButton() -- don't auto accept during a queue
				if queueButton and queueButton:IsShown() then return end
		
				if CH.BNGetGameAccountInfoByGUID(inviterGUID) or C_FriendList_IsFriend(inviterGUID) or IsGuildMember(inviterGUID) then
					hide = true
					AcceptGroup()
				end
			elseif event == 'GROUP_ROSTER_UPDATE' and hideStatic then
				if _G.LFGInvitePopup then -- invited in custom created group
					StaticPopupSpecial_Hide(_G.LFGInvitePopup)
				end
		
				StaticPopup_Hide('PARTY_INVITE')
				hide = nil
			end
		end

		acceptInvite:SetScript("OnEvent", autoInvite)
	end
end