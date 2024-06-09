local Core = SUI:NewModule("Skins.Core");

function Core:OnEnable()
	local db = SUI.db.profile.general
	local color = SUI:Color()

	if (db and color) then
		--Frames
		for i, v in pairs({
			GameMenuFrame.Border.TopEdge,
			GameMenuFrame.Border.RightEdge,
			GameMenuFrame.Border.BottomEdge,
			GameMenuFrame.Border.LeftEdge,
			GameMenuFrame.Border.TopRightCorner,
			GameMenuFrame.Border.TopLeftCorner,
			GameMenuFrame.Border.BottomLeftCorner,
			GameMenuFrame.Border.BottomRightCorner,
			StaticPopup1.Border.TopEdge,
			StaticPopup1.Border.RightEdge,
			StaticPopup1.Border.BottomEdge,
			StaticPopup1.Border.LeftEdge,
			StaticPopup1.Border.TopRightCorner,
			StaticPopup1.Border.TopLeftCorner,
			StaticPopup1.Border.BottomLeftCorner,
			StaticPopup1.Border.BottomRightCorner
		}) do
			v:SetVertexColor(color)
		end

		-- add backdrop mixin if required
		local function addBackDropMixin(frame)
			if not frame.SetBackdrop then
				Mixin(frame, BackdropTemplateMixin)
			end
		end

		-- Tooltip
		local function styleTooltip(self, style)
			addBackDropMixin(self)
			backdrop = {
				bgFile = "Interface\\Buttons\\WHITE8x8",
				bgColor = { 0.03, 0.03, 0.03, 0.9 },
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				borderColor = { 0.03, 0.03, 0.03, 0.9 },
				itemBorderColorAlpha = 0.9,
				azeriteBorderColor = { 1, 0.3, 0, 0.9 },
				tile = false,
				tileEdge = false,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 3, right = 3, top = 3, bottom = 3 }
			}
			self:SetBackdrop(backdrop)
			self:SetBackdropColor(unpack(backdrop.bgColor))
			local _, itemLink = self:GetItem()
			if itemLink then
				local azerite = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) or
					C_AzeriteItem.IsAzeriteItemByID(itemLink) or false
				local _, _, itemRarity = GetItemInfo(itemLink)
				local r, g, b = 1, 1, 1
				if itemRarity then r, g, b = GetItemQualityColor(itemRarity) end
				if azerite and backdrop.azeriteBorderColor then
					self:SetBackdropBorderColor(backdrop.azeriteBorderColor)
				else
					self:SetBackdropBorderColor(r, g, b, backdrop.itemBorderColorAlpha)
				end
			else
				self:SetBackdropBorderColor(backdrop.borderColor)
			end
		end

		hooksecurefunc("SharedTooltip_SetBackdropStyle", styleTooltip)
		local tooltips = { GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip, ItemRefShoppingTooltip1,
			ItemRefShoppingTooltip2, WorldMapTooltip,
			WorldMapCompareTooltip1, WorldMapCompareTooltip2, SmallTextTooltip }
		for i, tooltip in next, tooltips do styleTooltip(tooltip) end

		-- Unitframes
		for i, v in pairs(
			{
				PlayerFrameTexture,
				TargetFrameTextureFrameTexture,
				PlayerFrameAlternateManaBarBorder,
				PlayerFrameAlternateManaBarLeftBorder,
				PlayerFrameAlternateManaBarRightBorder,
				PaladinPowerBarFrameBG,
				PaladinPowerBarFrameBankBG,
				ComboPointPlayerFrame.Background,
				ComboPointPlayerFrame.Combo1.PointOff,
				ComboPointPlayerFrame.Combo2.PointOff,
				ComboPointPlayerFrame.Combo3.PointOff,
				ComboPointPlayerFrame.Combo4.PointOff,
				ComboPointPlayerFrame.Combo5.PointOff,
				ComboPointPlayerFrame.Combo6.PointOff,
				AlternatePowerBarBorder,
				AlternatePowerBarLeftBorder,
				AlternatePowerBarRightBorder,
				PetFrameTexture,
				PartyMemberFrame1Texture,
				PartyMemberFrame2Texture,
				PartyMemberFrame3Texture,
				PartyMemberFrame4Texture,
				PartyMemberFrame1PetFrameTexture,
				PartyMemberFrame2PetFrameTexture,
				PartyMemberFrame3PetFrameTexture,
				PartyMemberFrame4PetFrameTexture,
				FocusFrameTextureFrameTexture,
				TargetFrameToTTextureFrameTexture,
				FocusFrameToTTextureFrameTexture,
				Boss1TargetFrameTextureFrameTexture,
				Boss2TargetFrameTextureFrameTexture,
				Boss3TargetFrameTextureFrameTexture,
				Boss4TargetFrameTextureFrameTexture,
				Boss5TargetFrameTextureFrameTexture,
				Boss1TargetFrameSpellBar.Border,
				Boss2TargetFrameSpellBar.Border,
				Boss3TargetFrameSpellBar.Border,
				Boss4TargetFrameSpellBar.Border,
				Boss5TargetFrameSpellBar.Border,
				CastingBarFrame.Border,
				FocusFrameSpellBar.Border,
				TargetFrameSpellBar.Border,
			}
		) do
			v:SetVertexColor(color)
		end

		-- Raidframe
		local SUI = CreateFrame("Frame")
		SUI:RegisterEvent("PLAYER_ENTERING_WORLD")
		SUI:RegisterEvent("GROUP_ROSTER_UPDATE")

		function ColorRaid()
			for g = 1, NUM_RAID_GROUPS do
				local group = _G["CompactRaidGroup" .. g .. "BorderFrame"]
				if group then
					for _, region in pairs({ group:GetRegions() }) do
						if region:IsObjectType("Texture") then
							region:SetVertexColor(.15, .15, .15)
						end
					end
				end
				for m = 1, 5 do
					local frame = _G["CompactRaidGroup" .. g .. "Member" .. m]
					if frame then
						groupcolored = true
						for _, region in pairs({ frame:GetRegions() }) do
							if region:GetName():find("Border") then
								region:SetVertexColor(.15, .15, .15)
							end
						end
					end
					local frame = _G["CompactRaidFrame" .. m]
					if frame then
						singlecolored = true
						for _, region in pairs({ frame:GetRegions() }) do
							if region:GetName():find("Border") then
								region:SetVertexColor(.15, .15, .15)
							end
						end
					end
				end
			end
			for _, region in pairs({ CompactRaidFrameContainerBorderFrame:GetRegions() }) do
				if region:IsObjectType("Texture") then
					region:SetVertexColor(.15, .15, .15)
				end
			end
		end

		SUI:SetScript("OnEvent", function(self, event)
			ColorRaid()
			PlayerFrameGroupIndicator:SetAlpha(0)
			PlayerHitIndicator:SetText(nil)
			PlayerHitIndicator.SetText = function()
			end
			PetHitIndicator:SetText(nil)
			PetHitIndicator.SetText = function()
			end
			for _, child in pairs({ WarlockPowerFrame:GetChildren() }) do
				for _, region in pairs({ child:GetRegions() }) do
					if region:GetDrawLayer() == "BORDER" then
						region:SetVertexColor(.15, .15, .15)
					end
				end
			end

		end)

		for _, region in pairs({ CompactRaidFrameManager:GetRegions() }) do
			if region:IsObjectType("Texture") then
				region:SetVertexColor(.15, .15, .15)
			end
		end
		for _, region in pairs({ CompactRaidFrameManagerContainerResizeFrame:GetRegions() }) do
			if region:GetName():find("Border") then
				region:SetVertexColor(.15, .15, .15)
			end
		end
		CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidPanel-Toggle")
		for i = 1, 4 do
			_G["PartyMemberFrame" .. i .. "PVPIcon"]:SetAlpha(0)
			_G["PartyMemberFrame" .. i .. "NotPresentIcon"]:Hide()
			_G["PartyMemberFrame" .. i .. "NotPresentIcon"].Show = function()
			end
		end

		-- Bags
		for i = 1, 5 do
			_G["ContainerFrame" .. i .. "BackgroundTop"]:SetVertexColor(.2, .2, .2)
			_G["ContainerFrame" .. i .. "BackgroundMiddle1"]:SetVertexColor(.2, .2, .2)
			_G["ContainerFrame" .. i .. "BackgroundMiddle2"]:SetVertexColor(.2, .2, .2)
			_G["ContainerFrame" .. i .. "BackgroundBottom"]:SetVertexColor(.2, .2, .2)
		end
		BackpackTokenFrame:GetRegions():SetVertexColor(.2, .2, .2)

		-- Actionbar
		for i, v in pairs(
			{

				MainMenuBarArtFrameBackground.BackgroundLarge,
				MainMenuBarArtFrameBackground.BackgroundSmall,
				StatusTrackingBarManager.SingleBarLarge,
				StatusTrackingBarManager.SingleBarSmall,
				SlidingActionBarTexture0,
				SlidingActionBarTexture1,
				MainMenuBarTexture0,
				MainMenuBarTexture1,
				MainMenuBarTexture2,
				MainMenuBarTexture3,
				MainMenuMaxLevelBar0,
				MainMenuMaxLevelBar1,
				MainMenuMaxLevelBar2,
				MainMenuMaxLevelBar3,
				MainMenuXPBarTextureLeftCap,
				MainMenuXPBarTextureRightCap,
				MainMenuXPBarTextureMid,
				ReputationWatchBarTexture0,
				ReputationWatchBarTexture1,
				ReputationWatchBarTexture2,
				ReputationWatchBarTexture3,
				ReputationXPBarTexture0,
				ReputationXPBarTexture1,
				ReputationXPBarTexture2,
				ReputationXPBarTexture3,
			}
		) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs(
			{
				MainMenuBarArtFrame.LeftEndCap,
				MainMenuBarArtFrame.RightEndCap,
				StanceBarLeft,
				StanceBarMiddle,
				StanceBarRight
			}
		) do
			v:SetVertexColor(.2, .2, .2)
		end
		ActionBarUpButton:GetRegions():SetVertexColor(.4, .4, .4)
		ActionBarDownButton:GetRegions():SetVertexColor(.4, .4, .4)

		-- Minimap

		for _, region in pairs({ StopwatchFrame:GetRegions() }) do
			region:SetVertexColor(.15, .15, .15)
		end


		--LFD
		for i, v in pairs({
			LFDRoleCheckPopup.Border.TopEdge,
			LFDRoleCheckPopup.Border.RightEdge,
			LFDRoleCheckPopup.Border.BottomEdge,
			LFDRoleCheckPopup.Border.LeftEdge,
			LFDRoleCheckPopup.Border.TopRightCorner,
			LFDRoleCheckPopup.Border.TopLeftCorner,
			LFDRoleCheckPopup.Border.BottomLeftCorner,
			LFDRoleCheckPopup.Border.BottomRightCorner,
			PVPReadyDialog.Border.TopEdge,
			PVPReadyDialog.Border.RightEdge,
			PVPReadyDialog.Border.BottomEdge,
			PVPReadyDialog.Border.LeftEdge,
			PVPReadyDialog.Border.TopRightCorner,
			PVPReadyDialog.Border.TopLeftCorner,
			PVPReadyDialog.Border.BottomLeftCorner,
			PVPReadyDialog.Border.BottomRightCorner,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Timer
		TimerTracker:HookScript("OnEvent", function(self, event, timerType, timeSeconds, totalTime)
			for i = 1, #self.timerList do
				_G['TimerTrackerTimer' .. i .. 'StatusBarBorder']:SetVertexColor(.3, .3, .3)
			end
		end)


		-- SpellBook
		for i, v in pairs({ SpellBookFrame.NineSlice.TopEdge,
			SpellBookFrame.NineSlice.RightEdge,
			SpellBookFrame.NineSlice.LeftEdge,
			SpellBookFrame.NineSlice.TopEdge,
			SpellBookFrame.NineSlice.BottomEdge,
			SpellBookFrame.NineSlice.PortraitFrame,
			SpellBookFrame.NineSlice.TopRightCorner,
			SpellBookFrame.NineSlice.TopLeftCorner,
			SpellBookFrame.NineSlice.BottomLeftCorner,
			SpellBookFrame.NineSlice.BottomRightCorner,
			SpellBookFrameInset.NineSlice.BottomEdge, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			SpellBookFrame.Bg,
			SpellBookFrame.TitleBg,
			SpellBookFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		SpellBookFrameInset:SetAlpha(0)

		-- PvE/Pvp
		for i, v in pairs({ PVEFrame.NineSlice.TopEdge,
			PVEFrame.NineSlice.TopRightCorner,
			PVEFrame.NineSlice.RightEdge,
			PVEFrame.NineSlice.BottomRightCorner,
			PVEFrame.NineSlice.BottomEdge,
			PVEFrame.NineSlice.BottomLeftCorner,
			PVEFrame.NineSlice.LeftEdge,
			PVEFrame.NineSlice.TopLeftCorner }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			PVEFrame.Bg,
			PVEFrame.TitleBg,
			LFDQueueFrameBackground,
			LFDParentFrameRoleBackground,
			PVEFrameLeftInset.NineSlice.TopEdge,
			PVEFrameLeftInset.NineSlice.TopRightCorner,
			PVEFrameLeftInset.NineSlice.RightEdge,
			PVEFrameLeftInset.NineSlice.BottomRightCorner,
			PVEFrameLeftInset.NineSlice.BottomEdge,
			PVEFrameLeftInset.NineSlice.BottomLeftCorner,
			PVEFrameLeftInset.NineSlice.LeftEdge,
			PVEFrameLeftInset.NineSlice.TopLeftCorner,
			LFDParentFrameInset.NineSlice.TopEdge,
			LFDParentFrameInset.NineSlice.TopRightCorner,
			LFDParentFrameInset.NineSlice.RightEdge,
			LFDParentFrameInset.NineSlice.BottomRightCorner,
			LFDParentFrameInset.NineSlice.BottomEdge,
			LFDParentFrameInset.NineSlice.BottomLeftCorner,
			LFDParentFrameInset.NineSlice.LeftEdge,
			LFDParentFrameInset.NineSlice.TopLeftCorner,
			RaidFinderFrameRoleInset.NineSlice.TopEdge,
			RaidFinderFrameRoleInset.NineSlice.TopRightCorner,
			RaidFinderFrameRoleInset.NineSlice.RightEdge,
			RaidFinderFrameRoleInset.NineSlice.BottomRightCorner,
			RaidFinderFrameRoleInset.NineSlice.BottomEdge,
			RaidFinderFrameRoleInset.NineSlice.BottomLeftCorner,
			RaidFinderFrameRoleInset.NineSlice.LeftEdge,
			RaidFinderFrameRoleInset.NineSlice.TopLeftCorner,
			RaidFinderFrameBottomInset.NineSlice.TopEdge,
			RaidFinderFrameBottomInset.NineSlice.TopRightCorner,
			RaidFinderFrameBottomInset.NineSlice.RightEdge,
			RaidFinderFrameBottomInset.NineSlice.BottomRightCorner,
			RaidFinderFrameBottomInset.NineSlice.BottomEdge,
			RaidFinderFrameBottomInset.NineSlice.BottomLeftCorner,
			RaidFinderFrameBottomInset.NineSlice.LeftEdge,
			RaidFinderFrameBottomInset.NineSlice.TopLeftCorner,
			LFGListFrame.CategorySelection.Inset.NineSlice.TopEdge,
			LFGListFrame.CategorySelection.Inset.NineSlice.TopRightCorner,
			LFGListFrame.CategorySelection.Inset.NineSlice.RightEdge,
			LFGListFrame.CategorySelection.Inset.NineSlice.BottomRightCorner,
			LFGListFrame.CategorySelection.Inset.NineSlice.BottomEdge,
			LFGListFrame.CategorySelection.Inset.NineSlice.BottomLeftCorner,
			LFGListFrame.CategorySelection.Inset.NineSlice.LeftEdge,
			LFGListFrame.CategorySelection.Inset.NineSlice.TopLeftCorner,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			PVEFrameTopFiligree,
			PVEFrameBottomFiligree,
			PVEFrameBlueBg,
			LFGListFrame.CategorySelection.Inset.CustomBG
		}) do
			v:SetVertexColor(.5, .5, .5)
		end

		-- Friends
		for i, v in pairs({
			FriendsFrame.NineSlice.TopEdge,
			FriendsFrame.NineSlice.TopEdge,
			FriendsFrame.NineSlice.TopRightCorner,
			FriendsFrame.NineSlice.RightEdge,
			FriendsFrame.NineSlice.BottomRightCorner,
			FriendsFrame.NineSlice.BottomEdge,
			FriendsFrame.NineSlice.BottomLeftCorner,
			FriendsFrame.NineSlice.LeftEdge,
			FriendsFrame.NineSlice.TopLeftCorner,
			FriendsFriendsFrame.Border.TopEdge,
			FriendsFriendsFrame.Border.RightEdge,
			FriendsFriendsFrame.Border.BottomEdge,
			FriendsFriendsFrame.Border.LeftEdge,
			FriendsFriendsFrame.Border.TopRightCorner,
			FriendsFriendsFrame.Border.TopLeftCorner,
			FriendsFriendsFrame.Border.BottomLeftCorner,
			FriendsFriendsFrame.Border.BottomRightCorner,
		}) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			FriendsFrame.Bg,
			FriendsFrame.TitleBg,
			FriendsFrameInset.NineSlice.TopEdge,
			FriendsFrameInset.NineSlice.TopEdge,
			FriendsFrameInset.NineSlice.TopRightCorner,
			FriendsFrameInset.NineSlice.RightEdge,
			FriendsFrameInset.NineSlice.BottomRightCorner,
			FriendsFrameInset.NineSlice.BottomEdge,
			FriendsFrameInset.NineSlice.BottomLeftCorner,
			FriendsFrameInset.NineSlice.LeftEdge,
			FriendsFrameInset.NineSlice.TopLeftCorner
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			FriendsListFrameScrollFrameTop,
			FriendsListFrameScrollFrameMiddle,
			FriendsListFrameScrollFrameBottom,
			FriendsListFrameScrollFrameThumbTexture,
			FriendsListFrameScrollFrameScrollUpButton.Normal,
			FriendsListFrameScrollFrameScrollDownButton.Normal,
			FriendsListFrameScrollFrameScrollUpButton.Disabled,
			FriendsListFrameScrollFrameScrollDownButton.Disabled,

		}) do
			v:SetVertexColor(.4, .4, .4)
		end

		-- Map
		for i, v in pairs({ WorldMapFrame.BorderFrame.NineSlice.TopEdge,
			WorldMapFrame.BorderFrame.NineSlice.TopEdge,
			WorldMapFrame.BorderFrame.NineSlice.TopEdge,
			WorldMapFrame.BorderFrame.NineSlice.TopRightCorner,
			WorldMapFrame.BorderFrame.NineSlice.RightEdge,
			WorldMapFrame.BorderFrame.NineSlice.BottomRightCorner,
			WorldMapFrame.BorderFrame.NineSlice.BottomEdge,
			WorldMapFrame.BorderFrame.NineSlice.BottomLeftCorner,
			WorldMapFrame.BorderFrame.NineSlice.LeftEdge,
			WorldMapFrame.BorderFrame.NineSlice.TopLeftCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			WorldMapFrame.NavBar.InsetBorderBottom,
			WorldMapFrame.NavBar.InsetBorderBottomLeft,
			WorldMapFrame.NavBar.InsetBorderBottomRight,
			WorldMapFrame.NavBar.InsetBorderLeft,
			WorldMapFrame.NavBar.InsetBorderRight,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			WorldMapFrame.BorderFrame.Bg,
			WorldMapFrame.BorderFrame.TitleBg,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Channels
		for i, v in pairs({ ChannelFrame.NineSlice.TopEdge,
			ChannelFrame.NineSlice.TopEdge,
			ChannelFrame.NineSlice.TopRightCorner,
			ChannelFrame.NineSlice.RightEdge,
			ChannelFrame.NineSlice.BottomRightCorner,
			ChannelFrame.NineSlice.BottomEdge,
			ChannelFrame.NineSlice.BottomLeftCorner,
			ChannelFrame.NineSlice.LeftEdge,
			ChannelFrame.NineSlice.TopLeftCorner,
			ChannelFrame.LeftInset.NineSlice.BottomEdge,
			ChannelFrame.LeftInset.NineSlice.BottomLeftCorner,
			ChannelFrame.LeftInset.NineSlice.BottomRightCorner,
			ChannelFrame.RightInset.NineSlice.BottomEdge,
			ChannelFrame.RightInset.NineSlice.BottomLeftCorner,
			ChannelFrame.RightInset.NineSlice.BottomRightCorner,
			ChannelFrameInset.NineSlice.BottomEdge, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			ChannelFrame.Bg,
			ChannelFrame.TitleBg,
			ChannelFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Chat
		for i, v in pairs({ ChatFrame1EditBoxLeft,
			ChatFrame1EditBoxRight,
			ChatFrame1EditBoxMid,
			ChatFrame2EditBoxLeft,
			ChatFrame2EditBoxRight,
			ChatFrame2EditBoxMid,
			ChatFrame3EditBoxLeft,
			ChatFrame3EditBoxRight,
			ChatFrame3EditBoxMid,
			ChatFrame4EditBoxLeft,
			ChatFrame4EditBoxRight,
			ChatFrame4EditBoxMid,
			ChatFrame5EditBoxLeft,
			ChatFrame5EditBoxRight,
			ChatFrame5EditBoxMid,
			ChatFrame6EditBoxLeft,
			ChatFrame6EditBoxRight,
			ChatFrame6EditBoxMid,
			ChatFrame7EditBoxLeft,
			ChatFrame7EditBoxRight,
			ChatFrame7EditBoxMid, }) do
			v:SetVertexColor(.15, .15, .15)
		end

		-- Mail
		for i, v in pairs({
			MailFrame.NineSlice.TopEdge,
			MailFrame.NineSlice.TopRightCorner,
			MailFrame.NineSlice.RightEdge,
			MailFrame.NineSlice.BottomRightCorner,
			MailFrame.NineSlice.BottomEdge,
			MailFrame.NineSlice.BottomLeftCorner,
			MailFrame.NineSlice.LeftEdge,
			MailFrame.NineSlice.TopLeftCorner,
			OpenMailFrame.NineSlice.TopEdge,
			OpenMailFrame.NineSlice.TopRightCorner,
			OpenMailFrame.NineSlice.RightEdge,
			OpenMailFrame.NineSlice.BottomRightCorner,
			OpenMailFrame.NineSlice.BottomEdge,
			OpenMailFrame.NineSlice.BottomLeftCorner,
			OpenMailFrame.NineSlice.LeftEdge,
			OpenMailFrame.NineSlice.TopLeftCorner,
		}) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			MailFrameInset.NineSlice.TopEdge,
			MailFrameInset.NineSlice.TopRightCorner,
			MailFrameInset.NineSlice.RightEdge,
			MailFrameInset.NineSlice.BottomRightCorner,
			MailFrameInset.NineSlice.BottomEdge,
			MailFrameInset.NineSlice.BottomLeftCorner,
			MailFrameInset.NineSlice.LeftEdge,
			MailFrameInset.NineSlice.TopLeftCorner,
			OpenMailFrameInset.NineSlice.TopEdge,
			OpenMailFrameInset.NineSlice.TopRightCorner,
			OpenMailFrameInset.NineSlice.RightEdge,
			OpenMailFrameInset.NineSlice.BottomRightCorner,
			OpenMailFrameInset.NineSlice.BottomEdge,
			OpenMailFrameInset.NineSlice.BottomLeftCorner,
			OpenMailFrameInset.NineSlice.LeftEdge,
			OpenMailFrameInset.NineSlice.TopLeftCorner,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			MailFrame.Bg,
			MailFrame.TitleBg,
			OpenMailFrame.Bg,
			OpenMailFrame.TitleBg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Merchant
		for i, v in pairs({ MerchantFrame.NineSlice.TopEdge,
			MerchantFrame.NineSlice.RightEdge,
			MerchantFrame.NineSlice.BottomEdge,
			MerchantFrame.NineSlice.LeftEdge,
			MerchantFrame.NineSlice.TopRightCorner,
			MerchantFrame.NineSlice.TopLeftCorner,
			MerchantFrame.NineSlice.BottomLeftCorner,
			MerchantFrame.NineSlice.BottomRightCorner,
			StackSplitFrame.SingleItemSplitBackground, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			MerchantFrame.Bg,
			MerchantFrame.TitleBg,
			MerchantFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Addonlist
		for i, v in pairs({
			AddonList.NineSlice.TopEdge,
			AddonList.NineSlice.RightEdge,
			AddonList.NineSlice.BottomEdge,
			AddonList.NineSlice.LeftEdge,
			AddonList.NineSlice.TopRightCorner,
			AddonList.NineSlice.TopLeftCorner,
			AddonList.NineSlice.BottomLeftCorner,
			AddonList.NineSlice.BottomRightCorner,
		}) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			AddonListInset.NineSlice.TopEdge,
			AddonListInset.NineSlice.TopRightCorner,
			AddonListInset.NineSlice.RightEdge,
			AddonListInset.NineSlice.BottomRightCorner,
			AddonListInset.NineSlice.BottomEdge,
			AddonListInset.NineSlice.BottomLeftCorner,
			AddonListInset.NineSlice.LeftEdge,
			AddonListInset.NineSlice.TopLeftCorner,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			AddonListBg,
			AddonList.TitleBg,
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			AddonListScrollFrameScrollBarTop,
			AddonListScrollFrameScrollBarMiddle,
			AddonListScrollFrameScrollBarBottom,
			AddonListScrollFrameScrollBarThumbTexture,
			AddonListScrollFrameScrollBarScrollUpButton.Normal,
			AddonListScrollFrameScrollBarScrollDownButton.Normal,
			AddonListScrollFrameScrollBarScrollUpButton.Disabled,
			AddonListScrollFrameScrollBarScrollDownButton.Disabled,

		}) do
			v:SetVertexColor(.4, .4, .4)
		end

		-- Gossip (e.g NPC dialog frame and interactions)
		for i, v in pairs({
			GossipFrame.NineSlice.TopEdge,
			GossipFrame.NineSlice.RightEdge,
			GossipFrame.NineSlice.BottomEdge,
			GossipFrame.NineSlice.LeftEdge,
			GossipFrame.NineSlice.TopRightCorner,
			GossipFrame.NineSlice.TopLeftCorner,
			GossipFrame.NineSlice.BottomLeftCorner,
			GossipFrame.NineSlice.BottomRightCorner,
		}) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			GossipFrameInset.NineSlice.TopEdge,
			GossipFrameInset.NineSlice.RightEdge,
			GossipFrameInset.NineSlice.BottomEdge,
			GossipFrameInset.NineSlice.LeftEdge,
			GossipFrameInset.NineSlice.TopRightCorner,
			GossipFrameInset.NineSlice.TopLeftCorner,
			GossipFrameInset.NineSlice.BottomLeftCorner,
			GossipFrameInset.NineSlice.BottomRightCorner
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			GossipFrame.Bg,
			GossipFrame.TitleBg,
			GossipFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			GossipGreetingScrollFrameTop,
			GossipGreetingScrollFrameMiddle,
			GossipGreetingScrollFrameBottom,
			GossipGreetingScrollFrameScrollBarThumbTexture,
			GossipGreetingScrollFrameScrollBarScrollUpButton.Normal,
			GossipGreetingScrollFrameScrollBarScrollDownButton.Normal,
			GossipGreetingScrollFrameScrollBarScrollUpButton.Disabled,
			GossipGreetingScrollFrameScrollBarScrollDownButton.Disabled,

		}) do
			v:SetVertexColor(.4, .4, .4)
		end

		-- Bank
		for i, v in pairs({ BankFrame.NineSlice.TopEdge,
			BankFrame.NineSlice.RightEdge,
			BankFrame.NineSlice.BottomEdge,
			BankFrame.NineSlice.LeftEdge,
			BankFrame.NineSlice.TopRightCorner,
			BankFrame.NineSlice.TopLeftCorner,
			BankFrame.NineSlice.BottomLeftCorner,
			BankFrame.NineSlice.BottomRightCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			BankFrame.Bg,
			BankFrame.TitleBg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Quest
		for i, v in pairs({ QuestFrame.NineSlice.TopEdge,
			QuestFrame.NineSlice.RightEdge,
			QuestFrame.NineSlice.BottomEdge,
			QuestFrame.NineSlice.LeftEdge,
			QuestFrame.NineSlice.TopRightCorner,
			QuestFrame.NineSlice.TopLeftCorner,
			QuestFrame.NineSlice.BottomLeftCorner,
			QuestFrame.NineSlice.BottomRightCorner,
			QuestFrameInset.NineSlice.BottomEdge,
			QuestLogPopupDetailFrame.NineSlice.TopEdge,
			QuestLogPopupDetailFrame.NineSlice.RightEdge,
			QuestLogPopupDetailFrame.NineSlice.BottomEdge,
			QuestLogPopupDetailFrame.NineSlice.LeftEdge,
			QuestLogPopupDetailFrame.NineSlice.TopRightCorner,
			QuestLogPopupDetailFrame.NineSlice.TopLeftCorner,
			QuestLogPopupDetailFrame.NineSlice.BottomLeftCorner,
			QuestLogPopupDetailFrame.NineSlice.BottomRightCorner,
			QuestLogPopupDetailFrame.NineSlice.BottomEdge,
			QuestNPCModelTopBorder,
			QuestNPCModelRightBorder,
			QuestNPCModelTopRightCorner,
			QuestNPCModelBottomRightCorner,
			QuestNPCModelBottomBorder,
			QuestNPCModelBottomLeftCorner,
			QuestNPCModelLeftBorder,
			QuestNPCModelTopLeftCorner,
			QuestNPCModelTextTopBorder,
			QuestNPCModelTextRightBorder,
			QuestNPCModelTextTopRightCorner,
			QuestNPCModelTextBottomRightCorner,
			QuestNPCModelTextBottomBorder,
			QuestNPCModelTextBottomLeftCorner,
			QuestNPCModelTextLeftBorder,
			QuestNPCModelTextTopLeftCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			QuestFrame.Bg,
			QuestFrame.TitleBg,
			QuestFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		--FIXSL Blizz thinks it is good to add more then 1 QuestFrame
		-- for i, v in pairs({
		-- 	QuestScrollFrameScrollBarTop,
		-- 	QuestScrollFrameScrollBarMiddle,
		-- 	QuestScrollFrameScrollBarBottom,
		-- 	QuestScrollFrameScrollBarThumbTexture,
		-- 	QuestScrollFrameScrollBarScrollUpButton.Normal,
		-- 	QuestScrollFrameScrollBarScrollDownButton.Normal,
		-- 	QuestScrollFrameScrollBarScrollUpButton.Disabled,
		-- 	QuestScrollFrameScrollBarScrollDownButton.Disabled,

		-- }) do
		-- 	v:SetVertexColor(.4, .4, .4)
		-- end

		-- DressUP
		for i, v in pairs({ DressUpFrame.NineSlice.TopEdge,
			DressUpFrame.NineSlice.RightEdge,
			DressUpFrame.NineSlice.BottomEdge,
			DressUpFrame.NineSlice.LeftEdge,
			DressUpFrame.NineSlice.TopRightCorner,
			DressUpFrame.NineSlice.TopLeftCorner,
			DressUpFrame.NineSlice.BottomLeftCorner,
			DressUpFrame.NineSlice.BottomRightCorner,
			DressUpFrameInset.NineSlice.BottomEdge, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			DressUpFrame.Bg,
			DressUpFrame.TitleBg,
			DressUpFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			DressUpFrameInset.NineSlice.TopEdge,
			DressUpFrameInset.NineSlice.TopRightCorner,
			DressUpFrameInset.NineSlice.RightEdge,
			DressUpFrameInset.NineSlice.BottomRightCorner,
			DressUpFrameInset.NineSlice.BottomEdge,
			DressUpFrameInset.NineSlice.BottomLeftCorner,
			DressUpFrameInset.NineSlice.LeftEdge,
			DressUpFrameInset.NineSlice.TopLeftCorner
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- LootFrame
		for i, v in pairs({ LootFrame.NineSlice.TopEdge,
			LootFrame.NineSlice.RightEdge,
			LootFrame.NineSlice.BottomEdge,
			LootFrame.NineSlice.LeftEdge,
			LootFrame.NineSlice.TopRightCorner,
			LootFrame.NineSlice.TopLeftCorner,
			LootFrame.NineSlice.BottomLeftCorner,
			LootFrame.NineSlice.BottomRightCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({ LootFrame.NineSlice.TopEdge,
			LootFrameInset.NineSlice.RightEdge,
			LootFrameInset.NineSlice.BottomEdge,
			LootFrameInset.NineSlice.LeftEdge,
			LootFrameInset.NineSlice.TopRightCorner,
			LootFrameInset.NineSlice.TopLeftCorner,
			LootFrameInset.NineSlice.BottomLeftCorner,
			LootFrameInset.NineSlice.BottomRightCorner, }) do
			v:SetVertexColor(.3, .3, .3)
		end
		for i, v in pairs({
			LootFrame.Bg,
			LootFrame.TitleBg,
			LootFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- -- HelpFrame
		-- for i, v in pairs({ HelpFrameTopBorder,
		-- 	HelpFrameRightBorder,
		-- 	HelpFrameTopRightCorner,
		-- 	HelpFrameBottomRightCorner,
		-- 	HelpFrameBottomBorder,
		-- 	HelpFrameBottomLeftCorner,
		-- 	HelpFrameLeftBorder,
		-- 	HelpFrameTopLeftCorner,
		--  	HelpFrameVertDivTop,
		-- 	HelpFrameVertDivMiddle,
		-- 	HelpFrameVertDivBottom,
		-- 	HelpFrameHeaderTopBorder,
		-- 	HelpFrameHeaderTopRightCorner,
		-- 	HelpFrameHeaderRightBorder,
		-- 	HelpFrameHeaderBottomRightCorner,
		-- 	HelpFrameHeaderBottomBorder,
		-- 	HelpFrameHeaderBottomLeftCorner,
		-- 	HelpFrameHeaderLeftBorder,
		-- 	HelpFrameHeaderTopLeftCorner,
		-- 	HelpFrameLeftInset.NineSlice.LeftEdge,
		--  	HelpFrameLeftInset.NineSlice.BottomEdge,
		-- 	HelpBrowser.BrowserInset.NineSlice.BottomEdge,
		-- 	HelpFrameMainInset.NineSlice.BottomEdge, }) do
		-- 		v:SetVertexColor(.15, .15, .15)
		-- end

		-- ItemTextFrame
		for i, v in pairs({ ItemTextFrame.NineSlice.TopEdge,
			ItemTextFrame.NineSlice.RightEdge,
			ItemTextFrame.NineSlice.BottomEdge,
			ItemTextFrame.NineSlice.LeftEdge,
			ItemTextFrame.NineSlice.TopRightCorner,
			ItemTextFrame.NineSlice.TopLeftCorner,
			ItemTextFrame.NineSlice.BottomLeftCorner,
			ItemTextFrame.NineSlice.BottomRightCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end

		-- PetitionFrame
		for i, v in pairs({ PetitionFrame.NineSlice.TopEdge,
			PetitionFrame.NineSlice.RightEdge,
			PetitionFrame.NineSlice.BottomEdge,
			PetitionFrame.NineSlice.LeftEdge,
			PetitionFrame.NineSlice.TopRightCorner,
			PetitionFrame.NineSlice.TopLeftCorner,
			PetitionFrame.NineSlice.BottomLeftCorner,
			PetitionFrame.NineSlice.BottomRightCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			PetitionFrame.Bg,
			PetitionFrame.TitleBg,
			PetitionFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-- Guild Register Frame (pt?) & Tabard Frame
		for i, v in pairs({ GuildRegistrarFrame.NineSlice.TopEdge,
			GuildRegistrarFrame.NineSlice.RightEdge,
			GuildRegistrarFrame.NineSlice.BottomEdge,
			GuildRegistrarFrame.NineSlice.LeftEdge,
			GuildRegistrarFrame.NineSlice.TopRightCorner,
			GuildRegistrarFrame.NineSlice.TopLeftCorner,
			GuildRegistrarFrame.NineSlice.BottomLeftCorner,
			GuildRegistrarFrame.NineSlice.BottomRightCorner,
			TabardFrame.NineSlice.TopEdge,
			TabardFrame.NineSlice.RightEdge,
			TabardFrame.NineSlice.BottomEdge,
			TabardFrame.NineSlice.LeftEdge,
			TabardFrame.NineSlice.TopRightCorner,
			TabardFrame.NineSlice.TopLeftCorner,
			TabardFrame.NineSlice.BottomLeftCorner,
			TabardFrame.NineSlice.BottomRightCorner, }) do
			v:SetVertexColor(.15, .15, .15)
		end
		for i, v in pairs({
			GuildRegistrarFrame.Bg,
			GuildRegistrarFrame.TitleBg,
			GuildRegistrarFrameInset.Bg,
			TabardFrame.Bg,
			TabardFrame.TitleBg,
			TabardFrameInset.Bg
		}) do
			v:SetVertexColor(.3, .3, .3)
		end

		-------------- Frames that need a load to work properly --------------
		-- Specialization
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_TalentUI" then
				for i, v in pairs({
					PlayerTalentFrame.NineSlice.TopEdge,
					PlayerTalentFrame.NineSlice.RightEdge,
					PlayerTalentFrame.NineSlice.BottomEdge,
					PlayerTalentFrame.NineSlice.LeftEdge,
					PlayerTalentFrame.NineSlice.TopRightCorner,
					PlayerTalentFrame.NineSlice.TopLeftCorner,
					PlayerTalentFrame.NineSlice.BottomLeftCorner,
					PlayerTalentFrame.NineSlice.BottomRightCorner,
					PlayerTalentFrame.NineSlice.BottomEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.TopEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.RightEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.LeftEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.TopRightCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.TopLeftCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomLeftCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomRightCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomEdge,
				}) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					PlayerTalentFrameInset.NineSlice.RightEdge,
					PlayerTalentFrameInset.NineSlice.BottomEdge,
					PlayerTalentFrameInset.NineSlice.LeftEdge,
					PlayerTalentFrameInset.NineSlice.TopRightCorner,
					PlayerTalentFrameInset.NineSlice.TopLeftCorner,
					PlayerTalentFrameInset.NineSlice.BottomLeftCorner,
					PlayerTalentFrameInset.NineSlice.BottomRightCorner,
					PlayerTalentFrameInset.NineSlice.BottomEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.TopEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.RightEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.LeftEdge,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.TopRightCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.TopLeftCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomLeftCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomRightCorner,
					PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomEdge,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarThumbTexture,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarTop,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarMiddle,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarBottom,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollUpButton.Normal,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollDownButton.Normal,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollUpButton.Disabled,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollDownButton.Disabled
				}) do
					v:SetVertexColor(.4, .4, .4)
				end
				for i, v in pairs({
					PVEFrameTopFiligree,
					PVEFrameBottomFiligree,
					PVEFrameBlueBg,
					LFGListFrame.CategorySelection.Inset.CustomBG
				}) do
					v:SetVertexColor(.5, .5, .5)
				end
				for i, v in pairs({
					PlayerTalentFrame.Bg,
					PlayerTalentFrame.TitleBg,
					PlayerTalentFrameInset.Bg,
					PlayerTalentFrameTalentsPvpTalentFrameTalentListBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					PlayerTalentFrameTalents.bg
				}) do
					v:SetVertexColor(.5, .5, .5)
				end
				_G.select(1, PlayerTalentFrameSpecialization:GetRegions()):SetVertexColor(.4, .4, .4)
				_G.select(5, PlayerTalentFrameSpecialization:GetRegions()):SetVertexColor(.5, .5, .5)
				_G.select(6, PlayerTalentFrameSpecialization:GetRegions()):SetVertexColor(.5, .5, .5)
			end
		end)

		-- Collections
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_Collections" then
				for i, v in pairs({
					CollectionsJournal.NineSlice.TopEdge,
					CollectionsJournal.NineSlice.TopRightCorner,
					CollectionsJournal.NineSlice.RightEdge,
					CollectionsJournal.NineSlice.BottomRightCorner,
					CollectionsJournal.NineSlice.BottomEdge,
					CollectionsJournal.NineSlice.BottomLeftCorner,
					CollectionsJournal.NineSlice.LeftEdge,
					CollectionsJournal.NineSlice.TopLeftCorner
				}) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					CollectionsJournal.Bg,
					CollectionsJournal.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					MountJournal.LeftInset.NineSlice.TopEdge,
					MountJournal.LeftInset.NineSlice.TopRightCorner,
					MountJournal.LeftInset.NineSlice.TopLeftCorner,
					MountJournal.LeftInset.NineSlice.RightEdge,
					MountJournal.LeftInset.NineSlice.BottomRightCorner,
					MountJournal.LeftInset.NineSlice.BottomEdge,
					MountJournal.LeftInset.NineSlice.BottomLeftCorner,
					MountJournal.LeftInset.NineSlice.LeftEdge,
					MountJournal.BottomLeftInset.NineSlice.TopEdge,
					MountJournal.BottomLeftInset.NineSlice.TopRightCorner,
					MountJournal.BottomLeftInset.NineSlice.TopLeftCorner,
					MountJournal.BottomLeftInset.NineSlice.RightEdge,
					MountJournal.BottomLeftInset.NineSlice.BottomRightCorner,
					MountJournal.BottomLeftInset.NineSlice.BottomEdge,
					MountJournal.BottomLeftInset.NineSlice.BottomLeftCorner,
					MountJournal.BottomLeftInset.NineSlice.LeftEdge,
					MountJournal.RightInset.NineSlice.TopEdge,
					MountJournal.RightInset.NineSlice.TopRightCorner,
					MountJournal.RightInset.NineSlice.TopLeftCorner,
					MountJournal.RightInset.NineSlice.RightEdge,
					MountJournal.RightInset.NineSlice.BottomRightCorner,
					MountJournal.RightInset.NineSlice.BottomEdge,
					MountJournal.RightInset.NineSlice.BottomLeftCorner,
					MountJournal.RightInset.NineSlice.LeftEdge,
					ToyBox.iconsFrame.NineSlice.TopEdge,
					ToyBox.iconsFrame.NineSlice.RightEdge,
					ToyBox.iconsFrame.NineSlice.BottomEdge,
					ToyBox.iconsFrame.NineSlice.LeftEdge,
					ToyBox.iconsFrame.NineSlice.TopRightCorner,
					ToyBox.iconsFrame.NineSlice.TopLeftCorner,
					ToyBox.iconsFrame.NineSlice.BottomLeftCorner,
					ToyBox.iconsFrame.NineSlice.BottomRightCorner,
					ToyBox.iconsFrame.NineSlice.BottomEdge,
					HeirloomsJournal.iconsFrame.NineSlice.TopEdge,
					HeirloomsJournal.iconsFrame.NineSlice.RightEdge,
					HeirloomsJournal.iconsFrame.NineSlice.BottomEdge,
					HeirloomsJournal.iconsFrame.NineSlice.LeftEdge,
					HeirloomsJournal.iconsFrame.NineSlice.TopRightCorner,
					HeirloomsJournal.iconsFrame.NineSlice.TopLeftCorner,
					HeirloomsJournal.iconsFrame.NineSlice.BottomLeftCorner,
					HeirloomsJournal.iconsFrame.NineSlice.BottomRightCorner,
					HeirloomsJournal.iconsFrame.NineSlice.BottomEdge,
					PetJournalLeftInset.NineSlice.TopEdge,
					PetJournalLeftInset.NineSlice.RightEdge,
					PetJournalLeftInset.NineSlice.BottomEdge,
					PetJournalLeftInset.NineSlice.LeftEdge,
					PetJournalLeftInset.NineSlice.TopRightCorner,
					PetJournalLeftInset.NineSlice.TopLeftCorner,
					PetJournalLeftInset.NineSlice.BottomLeftCorner,
					PetJournalLeftInset.NineSlice.BottomRightCorner,
					PetJournalLeftInset.NineSlice.BottomEdge,
					PetJournalPetCardInset.NineSlice.TopEdge,
					PetJournalPetCardInset.NineSlice.RightEdge,
					PetJournalPetCardInset.NineSlice.BottomEdge,
					PetJournalPetCardInset.NineSlice.LeftEdge,
					PetJournalPetCardInset.NineSlice.TopRightCorner,
					PetJournalPetCardInset.NineSlice.TopLeftCorner,
					PetJournalPetCardInset.NineSlice.BottomLeftCorner,
					PetJournalPetCardInset.NineSlice.BottomRightCorner,
					PetJournalPetCardInset.NineSlice.BottomEdge,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					MountJournalListScrollFrameScrollBarThumbTexture,
					MountJournalListScrollFrameScrollBarTop,
					MountJournalListScrollFrameScrollBarMiddle,
					MountJournalListScrollFrameScrollBarBottom,
					MountJournalListScrollFrameScrollBarScrollUpButton.Normal,
					MountJournalListScrollFrameScrollBarScrollDownButton.Normal,
					MountJournalListScrollFrameScrollBarScrollUpButton.Disabled,
					MountJournalListScrollFrameScrollBarScrollDownButton.Disabled,
					PetJournalListScrollFrameScrollBarThumbTexture,
					PetJournalListScrollFrameScrollBarTop,
					PetJournalListScrollFrameScrollBarMiddle,
					PetJournalListScrollFrameScrollBarBottom,
					PetJournalListScrollFrameScrollBarScrollUpButton.Normal,
					PetJournalListScrollFrameScrollBarScrollDownButton.Normal,
					PetJournalListScrollFrameScrollBarScrollUpButton.Disabled,
					PetJournalListScrollFrameScrollBarScrollDownButton.Disabled,
				}) do
					v:SetVertexColor(.4, .4, .4)
				end
			end
		end)

		-- AdventureGuide
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_EncounterJournal" then
				for i, v in pairs({ EncounterJournal.NineSlice.TopEdge,
					EncounterJournal.NineSlice.RightEdge,
					EncounterJournal.NineSlice.BottomEdge,
					EncounterJournal.NineSlice.LeftEdge,
					EncounterJournal.NineSlice.TopRightCorner,
					EncounterJournal.NineSlice.TopLeftCorner,
					EncounterJournal.NineSlice.BottomLeftCorner,
					EncounterJournal.NineSlice.BottomRightCorner,
					EncounterJournalInset.NineSlice.BottomEdge, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				EncounterJournalInset:SetAlpha(0)
				for i, v in pairs({
					EncounterJournal.Bg,
					EncounterJournal.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- Communities
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_Communities" then
				for i, v in pairs({
					CommunitiesFrame.NineSlice.TopEdge,
					CommunitiesFrame.NineSlice.RightEdge,
					CommunitiesFrame.NineSlice.BottomEdge,
					CommunitiesFrame.NineSlice.LeftEdge,
					CommunitiesFrame.NineSlice.TopRightCorner,
					CommunitiesFrame.NineSlice.TopLeftCorner,
					CommunitiesFrame.NineSlice.BottomLeftCorner,
					CommunitiesFrame.NineSlice.BottomRightCorner,
					CommunitiesFrame.GuildMemberDetailFrame.Border.TopEdge,
					CommunitiesFrame.GuildMemberDetailFrame.Border.RightEdge,
					CommunitiesFrame.GuildMemberDetailFrame.Border.BottomEdge,
					CommunitiesFrame.GuildMemberDetailFrame.Border.LeftEdge,
					CommunitiesFrame.GuildMemberDetailFrame.Border.TopRightCorner,
					CommunitiesFrame.GuildMemberDetailFrame.Border.TopLeftCorner,
					CommunitiesFrame.GuildMemberDetailFrame.Border.BottomLeftCorner,
					CommunitiesFrame.GuildMemberDetailFrame.Border.BottomRightCorner,
				}) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					CommunitiesFrame.Bg,
					CommunitiesFrame.TitleBg,
					CommunitiesFrameInset.Bg,
					CommunitiesFrame.MemberList.ColumnDisplay.Background,

				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					CommunitiesFrameInset.NineSlice.TopEdge,
					CommunitiesFrameInset.NineSlice.RightEdge,
					CommunitiesFrameInset.NineSlice.BottomEdge,
					CommunitiesFrameInset.NineSlice.LeftEdge,
					CommunitiesFrameInset.NineSlice.TopRightCorner,
					CommunitiesFrameInset.NineSlice.TopLeftCorner,
					CommunitiesFrameInset.NineSlice.BottomLeftCorner,
					CommunitiesFrameInset.NineSlice.BottomRightCorner,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.TopEdge,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.RightEdge,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.BottomEdge,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.LeftEdge,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.TopRightCorner,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.TopLeftCorner,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.BottomLeftCorner,
					CommunitiesFrameCommunitiesList.InsetFrame.NineSlice.BottomRightCorner,
					CommunitiesFrame.ChatEditBox.Left,
					CommunitiesFrame.ChatEditBox.Mid,
					CommunitiesFrame.ChatEditBox.Right,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.TopEdge,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.RightEdge,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.BottomEdge,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.LeftEdge,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.TopRightCorner,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.TopLeftCorner,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.BottomLeftCorner,
					CommunitiesFrame.Chat.InsetFrame.NineSlice.BottomRightCorner,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.TopEdge,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.RightEdge,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.BottomEdge,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.LeftEdge,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.TopRightCorner,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.TopLeftCorner,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.BottomLeftCorner,
					CommunitiesFrame.MemberList.InsetFrame.NineSlice.BottomRightCorner,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					CommunitiesFrameCommunitiesList.TopFiligree,
					CommunitiesFrameCommunitiesList.BottomFiligree,
					CommunitiesFrameCommunitiesList.Bg
				}) do
					v:SetVertexColor(.5, .5, .5)
				end
				for i, v in pairs({
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.thumbTexture,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollBarTop,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollBarMiddle,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollBarBottom,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollUpButton.Normal,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollDownButton.Normal,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollUpButton.Disabled,
					CommunitiesFrame.MemberList.ListScrollFrame.scrollBar.ScrollDownButton.Disabled,
					CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
					CommunitiesFrameCommunitiesListListScrollFrameTop,
					CommunitiesFrameCommunitiesListListScrollFrameMiddle,
					CommunitiesFrameCommunitiesListListScrollFrameBottom,
					CommunitiesFrameCommunitiesListListScrollFrameScrollUpButton.Normal,
					CommunitiesFrameCommunitiesListListScrollFrameScrollDownButton.Normal,
					CommunitiesFrameCommunitiesListListScrollFrameScrollUpButton.Disabled,
					CommunitiesFrameCommunitiesListListScrollFrameScrollDownButton.Disabled,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.thumbTexture,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollBarTop,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollBarMiddle,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollBarBottom,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollUp.Normal,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollDown.Normal,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollUp.Disabled,
					CommunitiesFrame.Chat.MessageFrame.ScrollBar.ScrollDown.Disabled,
				}) do
					v:SetVertexColor(.4, .4, .4)
				end
			end
		end)

		-- Macro
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_MacroUI" then
				for i, v in pairs({ MacroFrame.NineSlice.TopEdge,
					MacroFrame.NineSlice.RightEdge,
					MacroFrame.NineSlice.BottomEdge,
					MacroFrame.NineSlice.LeftEdge,
					MacroFrame.NineSlice.TopRightCorner,
					MacroFrame.NineSlice.TopLeftCorner,
					MacroFrame.NineSlice.BottomLeftCorner,
					MacroFrame.NineSlice.BottomRightCorner }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					MacroFrameInset.NineSlice.TopEdge,
					MacroFrameInset.NineSlice.TopRightCorner,
					MacroFrameInset.NineSlice.RightEdge,
					MacroFrameInset.NineSlice.BottomRightCorner,
					MacroFrameInset.NineSlice.BottomEdge,
					MacroFrameInset.NineSlice.BottomLeftCorner,
					MacroFrameInset.NineSlice.LeftEdge,
					MacroFrameInset.NineSlice.TopLeftCorner,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					MacroFrame.Bg,
					MacroFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					MacroButtonScrollFrameTop,
					MacroButtonScrollFrameMiddle,
					MacroButtonScrollFrameBottom,
					MacroButtonScrollFrameScrollBarThumbTexture,
					MacroButtonScrollFrameScrollBarScrollUpButton.Normal,
					MacroButtonScrollFrameScrollBarScrollDownButton.Normal,
					MacroButtonScrollFrameScrollBarScrollUpButton.Disabled,
					MacroButtonScrollFrameScrollBarScrollDownButton.Disabled,
				}) do
					v:SetVertexColor(.4, .4, .4)
				end
				MacroHorizontalBarLeft:Hide();
				--fix
				--_G.select(2, MacroFrame:GetRegions()):Hide()
			end
		end)

		-- AuctionHouse
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_AuctionHouseUI" then
				for i, v in pairs({ AuctionHouseFrame.NineSlice.TopEdge,
					AuctionHouseFrame.NineSlice.RightEdge,
					AuctionHouseFrame.NineSlice.BottomEdge,
					AuctionHouseFrame.NineSlice.LeftEdge,
					AuctionHouseFrame.NineSlice.TopRightCorner,
					AuctionHouseFrame.NineSlice.TopLeftCorner,
					AuctionHouseFrame.NineSlice.BottomLeftCorner,
					AuctionHouseFrame.NineSlice.BottomRightCorner,
					AuctionHouseFrame.NineSlice.BottomEdge,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.TopEdge,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.RightEdge,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomEdge,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.LeftEdge,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.TopRightCorner,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.TopLeftCorner,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomLeftCorner,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomRightCorner,
					AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomEdge,
					AuctionHouseFrame.BuyDialog.Border.TopEdge,
					AuctionHouseFrame.BuyDialog.Border.RightEdge,
					AuctionHouseFrame.BuyDialog.Border.BottomEdge,
					AuctionHouseFrame.BuyDialog.Border.LeftEdge,
					AuctionHouseFrame.BuyDialog.Border.TopRightCorner,
					AuctionHouseFrame.BuyDialog.Border.TopLeftCorner,
					AuctionHouseFrame.BuyDialog.Border.BottomLeftCorner,
					AuctionHouseFrame.BuyDialog.Border.BottomRightCorner,
					AuctionHouseFrame.BuyDialog.Border.BottomEdge, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					AuctionHouseFrame.Bg,
					AuctionHouseFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- FlightMap
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_FlightMap" then
				for i, v in pairs({ FlightMapFrame.BorderFrame.NineSlice.TopEdge,
					FlightMapFrame.BorderFrame.NineSlice.RightEdge,
					FlightMapFrame.BorderFrame.NineSlice.BottomEdge,
					FlightMapFrame.BorderFrame.NineSlice.LeftEdge,
					FlightMapFrame.BorderFrame.NineSlice.TopRightCorner,
					FlightMapFrame.BorderFrame.NineSlice.TopLeftCorner,
					FlightMapFrame.BorderFrame.NineSlice.BottomLeftCorner,
					FlightMapFrame.BorderFrame.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					FlightMapFrame.Bg,
					FlightMapFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- TradeSkill
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_TradeSkillUI" then
				for i, v in pairs({ TradeSkillFrame.NineSlice.TopEdge,
					TradeSkillFrame.NineSlice.RightEdge,
					TradeSkillFrame.NineSlice.BottomEdge,
					TradeSkillFrame.NineSlice.LeftEdge,
					TradeSkillFrame.NineSlice.TopRightCorner,
					TradeSkillFrame.NineSlice.TopLeftCorner,
					TradeSkillFrame.NineSlice.BottomLeftCorner,
					TradeSkillFrame.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					TradeSkillFrame.Bg,
					TradeSkillFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- Inspect
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_InspectUI" then
				for i, v in pairs({ InspectFrame.NineSlice.TopEdge,
					InspectFrame.NineSlice.RightEdge,
					InspectFrame.NineSlice.BottomEdge,
					InspectFrame.NineSlice.LeftEdge,
					InspectFrame.NineSlice.TopRightCorner,
					InspectFrame.NineSlice.TopLeftCorner,
					InspectFrame.NineSlice.BottomLeftCorner,
					InspectFrame.NineSlice.BottomRightCorner,
					InspectFrameInset.NineSlice.BottomEdge, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					InspectFrame.Bg,
					InspectFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					InspectFrameInset.NineSlice.RightEdge,
					InspectFrameInset.NineSlice.LeftEdge,
					InspectFrameInset.NineSlice.TopEdge,
					InspectFrameInset.NineSlice.BottomEdge,
					InspectFrameInset.NineSlice.PortraitFrame,
					InspectFrameInset.NineSlice.TopRightCorner,
					InspectFrameInset.NineSlice.TopLeftCorner,
					InspectFrameInset.NineSlice.BottomLeftCorner,
					InspectFrameInset.NineSlice.BottomRightCorner,
					InspectModelFrameBorderLeft,
					InspectModelFrameBorderRight,
					InspectModelFrameBorderTop,
					InspectModelFrameBorderTopLeft,
					InspectModelFrameBorderTopRight,
					InspectModelFrameBorderBottom,
					InspectModelFrameBorderBottomLeft,
					InspectModelFrameBorderBottomRight,
					InspectModelFrameBorderBottom2
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					InspectFeetSlotFrame,
					InspectHandsSlotFrame,
					InspectWaistSlotFrame,
					InspectLegsSlotFrame,
					InspectFinger0SlotFrame,
					InspectFinger1SlotFrame,
					InspectTrinket0SlotFrame,
					InspectTrinket1SlotFrame,
					InspectWristSlotFrame,
					InspectTabardSlotFrame,
					InspectShirtSlotFrame,
					InspectChestSlotFrame,
					InspectBackSlotFrame,
					InspectShoulderSlotFrame,
					InspectNeckSlotFrame,
					InspectHeadSlotFrame,
					InspectMainHandSlotFrame,
					InspectSecondaryHandSlotFrame
				}) do
					v:SetAlpha(0)
				end
				_G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
				_G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()
			end
		end)

		-- Wardrobe/Transmogrify
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_Collections" or name == "Blizzard_Wardrobe" then
				for i, v in pairs({
					WardrobeFrame.NineSlice.TopEdge,
					WardrobeFrame.NineSlice.RightEdge,
					WardrobeFrame.NineSlice.BottomEdge,
					WardrobeFrame.NineSlice.LeftEdge,
					WardrobeFrame.NineSlice.TopRightCorner,
					WardrobeFrame.NineSlice.TopLeftCorner,
					WardrobeFrame.NineSlice.BottomLeftCorner,
					WardrobeFrame.NineSlice.BottomRightCorner,
				}) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					WardrobeFrame.Bg,
					WardrobeFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.TopEdge,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.RightEdge,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.BottomEdge,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.LeftEdge,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.TopRightCorner,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.TopLeftCorner,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.BottomLeftCorner,
					WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice.BottomRightCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.TopEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.RightEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.BottomEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.LeftEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.TopRightCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.TopLeftCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.BottomLeftCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice.BottomRightCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.TopEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.RightEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.BottomEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.LeftEdge,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.TopRightCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.TopLeftCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.BottomLeftCorner,
					WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice.BottomRightCorner
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					WardrobeCollectionFrameScrollFrameScrollBarBottom,
					WardrobeCollectionFrameScrollFrameScrollBarMiddle,
					WardrobeCollectionFrameScrollFrameScrollBarTop,
					WardrobeCollectionFrameScrollFrameScrollBarThumbTexture,
					WardrobeCollectionFrameScrollFrameScrollBarScrollUpButton.Normal,
					WardrobeCollectionFrameScrollFrameScrollBarScrollDownButton.Normal,
					WardrobeCollectionFrameScrollFrameScrollBarScrollUpButton.Disabled,
					WardrobeCollectionFrameScrollFrameScrollBarScrollDownButton.Disabled,
				}) do
					v:SetVertexColor(.4, .4, .4)
				end
			end
		end)

		-- ClassTrainer/FlightMaster
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_TrainerUI" then
				for i, v in pairs({ ClassTrainerFrame.NineSlice.TopEdge,
					ClassTrainerFrame.NineSlice.RightEdge,
					ClassTrainerFrame.NineSlice.BottomEdge,
					ClassTrainerFrame.NineSlice.LeftEdge,
					ClassTrainerFrame.NineSlice.TopRightCorner,
					ClassTrainerFrame.NineSlice.TopLeftCorner,
					ClassTrainerFrame.NineSlice.BottomLeftCorner,
					ClassTrainerFrame.NineSlice.BottomRightCorner }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					ClassTrainerFrame.Bg,
					ClassTrainerFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- Achievement
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_AchievementUI" then
				for i, v in pairs({ AchievementFrameHeaderRight,
					AchievementFrameHeaderLeft,
					AchievementFrameWoodBorderTopLeft,
					AchievementFrameWoodBorderBottomLeft,
					AchievementFrameWoodBorderTopRight,
					AchievementFrameWoodBorderBottomRight,
					AchievementFrameMetalBorderBottom,
					AchievementFrameMetalBorderBottomLeft,
					AchievementFrameMetalBorderBottomRight,
					AchievementFrameMetalBorderLeft,
					AchievementFrameMetalBorderRight,
					AchievementFrameMetalBorderTop,
					AchievementFrameMetalBorderTopLeft,
					AchievementFrameMetalBorderTopRight, }) do
					v:SetVertexColor(.15, .15, .15)
				end
			end
		end)

		-- Azerite
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_AzeriteUI" then
				for i, v in pairs({ AzeriteEmpoweredItemUI.BorderFrame.NineSlice.TopEdge,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.RightEdge,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.BottomEdge,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.LeftEdge,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.TopRightCorner,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.TopLeftCorner,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.BottomLeftCorner,
					AzeriteEmpoweredItemUI.BorderFrame.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					AzeriteEmpoweredItemUI.BorderFrame.Bg,
					AzeriteEmpoweredItemUI.BorderFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- AlliedRaces
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_AlliedRacesUI" then
				for i, v in pairs({ AlliedRacesFrame.NineSlice.TopEdge,
					AlliedRacesFrame.NineSlice.RightEdge,
					AlliedRacesFrame.NineSlice.BottomEdge,
					AlliedRacesFrame.NineSlice.LeftEdge,
					AlliedRacesFrame.NineSlice.TopRightCorner,
					AlliedRacesFrame.NineSlice.TopLeftCorner,
					AlliedRacesFrame.NineSlice.BottomLeftCorner,
					AlliedRacesFrame.NineSlice.BottomRightCorner,
					AlliedRacesFrameInset.NineSlice.BottomEdge, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					AlliedRacesFrame.Bg,
					AlliedRacesFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- Inslands
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_IslandsQueueUI" then
				for i, v in pairs({ IslandsQueueFrame.NineSlice.TopEdge,
					IslandsQueueFrame.NineSlice.RightEdge,
					IslandsQueueFrame.NineSlice.BottomEdge,
					IslandsQueueFrame.NineSlice.LeftEdge,
					IslandsQueueFrame.NineSlice.TopRightCorner,
					IslandsQueueFrame.NineSlice.TopLeftCorner,
					IslandsQueueFrame.NineSlice.BottomLeftCorner,
					IslandsQueueFrame.NineSlice.BottomRightCorner,
					IslandsQueueFrame.ArtOverlayFrame.PortraitFrame, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					IslandsQueueFrame.Bg,
					IslandsQueueFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- GarrisonCapacitive
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_GarrisonUI" then
				for i, v in pairs({ GarrisonCapacitiveDisplayFrame.NineSlice.TopEdge,
					GarrisonCapacitiveDisplayFrame.NineSlice.RightEdge,
					GarrisonCapacitiveDisplayFrame.NineSlice.BottomEdge,
					GarrisonCapacitiveDisplayFrame.NineSlice.LeftEdge,
					GarrisonCapacitiveDisplayFrame.NineSlice.TopRightCorner,
					GarrisonCapacitiveDisplayFrame.NineSlice.TopLeftCorner,
					GarrisonCapacitiveDisplayFrame.NineSlice.BottomLeftCorner,
					GarrisonCapacitiveDisplayFrame.NineSlice.BottomRightCorner,
					GarrisonCapacitiveDisplayFrameInset.NineSlice.BottomEdge, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					GarrisonCapacitiveDisplayFrame.Bg,
					GarrisonCapacitiveDisplayFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- Calendar
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_Calendar" then
				for i, v in pairs({ CalendarFrameTopMiddleTexture,
					CalendarFrameRightTopTexture,
					CalendarFrameRightMiddleTexture,
					CalendarFrameRightBottomTexture,
					CalendarFrameBottomRightTexture,
					CalendarFrameBottomMiddleTexture,
					CalendarFrameBottomLeftTexture,
					CalendarFrameLeftMiddleTexture,
					CalendarFrameLeftTopTexture,
					CalendarFrameLeftBottomTexture,
					CalendarFrameTopLeftTexture,
					CalendarFrameTopRightTexture,
					CalendarCreateEventFrame.Border.TopEdge,
					CalendarCreateEventFrame.Border.RightEdge,
					CalendarCreateEventFrame.Border.BottomEdge,
					CalendarCreateEventFrame.Border.LeftEdge,
					CalendarCreateEventFrame.Border.TopRightCorner,
					CalendarCreateEventFrame.Border.TopLeftCorner,
					CalendarCreateEventFrame.Border.BottomLeftCorner,
					CalendarCreateEventFrame.Border.BottomRightCorner,
					CalendarViewHolidayFrame.Border.TopEdge,
					CalendarViewHolidayFrame.Border.RightEdge,
					CalendarViewHolidayFrame.Border.BottomEdge,
					CalendarViewHolidayFrame.Border.LeftEdge,
					CalendarViewHolidayFrame.Border.TopRightCorner,
					CalendarViewHolidayFrame.Border.TopLeftCorner,
					CalendarViewHolidayFrame.Border.BottomLeftCorner,
					CalendarViewHolidayFrame.Border.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
			end
		end)

		-- Calendar

		-- AzeriteRespec
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_AzeriteRespecUI" then
				for i, v in pairs({ AzeriteRespecFrame.NineSlice.TopEdge,
					AzeriteRespecFrame.NineSlice.RightEdge,
					AzeriteRespecFrame.NineSlice.BottomEdge,
					AzeriteRespecFrame.NineSlice.LeftEdge,
					AzeriteRespecFrame.NineSlice.TopRightCorner,
					AzeriteRespecFrame.NineSlice.TopLeftCorner,
					AzeriteRespecFrame.NineSlice.BottomLeftCorner,
					AzeriteRespecFrame.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					AzeriteRespecFrame.Bg,
					AzeriteRespecFrame.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- ScrappingMachineFrame
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_ScrappingMachineUI" then
				for i, v in pairs({ ScrappingMachineFrame.NineSlice.TopEdge,
					ScrappingMachineFrame.NineSlice.RightEdge,
					ScrappingMachineFrame.NineSlice.BottomEdge,
					ScrappingMachineFrame.NineSlice.LeftEdge,
					ScrappingMachineFrame.NineSlice.TopRightCorner,
					ScrappingMachineFrame.NineSlice.TopLeftCorner,
					ScrappingMachineFrame.NineSlice.BottomLeftCorner,
					ScrappingMachineFrame.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
			end
		end)

		-- ScrappingMachineFrame
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_TimeManager" then
				for i, v in pairs({ TimeManagerFrame.NineSlice.TopEdge,
					TimeManagerFrame.NineSlice.RightEdge,
					TimeManagerFrame.NineSlice.BottomEdge,
					TimeManagerFrame.NineSlice.LeftEdge,
					TimeManagerFrame.NineSlice.TopRightCorner,
					TimeManagerFrame.NineSlice.TopLeftCorner,
					TimeManagerFrame.NineSlice.BottomLeftCorner,
					TimeManagerFrame.NineSlice.BottomRightCorner,
					TimeManagerFrameInset.NineSlice.TopEdge,
					TimeManagerFrameInset.NineSlice.RightEdge,
					TimeManagerFrameInset.NineSlice.BottomEdge,
					TimeManagerFrameInset.NineSlice.LeftEdge,
					TimeManagerFrameInset.NineSlice.TopRightCorner,
					TimeManagerFrameInset.NineSlice.TopLeftCorner,
					StopwatchFrameBackgroundLeft, }) do
					v:SetVertexColor(.15, .15, .15)
				end
			end
		end)

		-- AzeriteEssenceUI
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_AzeriteEssenceUI" then
				for i, v in pairs({ AzeriteEssenceUI.NineSlice.TopEdge,
					AzeriteEssenceUI.NineSlice.RightEdge,
					AzeriteEssenceUI.NineSlice.BottomEdge,
					AzeriteEssenceUI.NineSlice.LeftEdge,
					AzeriteEssenceUI.NineSlice.TopRightCorner,
					AzeriteEssenceUI.NineSlice.TopLeftCorner,
					AzeriteEssenceUI.NineSlice.BottomLeftCorner,
					AzeriteEssenceUI.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
				for i, v in pairs({
					AzeriteEssenceUI.Bg,
					AzeriteEssenceUI.TitleBg
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					AzeriteEssenceUI.LeftInset.NineSlice.TopEdge,
					AzeriteEssenceUI.LeftInset.NineSlice.TopRightCorner,
					AzeriteEssenceUI.LeftInset.NineSlice.RightEdge,
					AzeriteEssenceUI.LeftInset.NineSlice.BottomRightCorner,
					AzeriteEssenceUI.LeftInset.NineSlice.BottomEdge,
					AzeriteEssenceUI.LeftInset.NineSlice.BottomLeftCorner,
					AzeriteEssenceUI.LeftInset.NineSlice.LeftEdge,
					AzeriteEssenceUI.LeftInset.NineSlice.TopLeftCorner,
					AzeriteEssenceUI.RightInset.NineSlice.TopEdge,
					AzeriteEssenceUI.RightInset.NineSlice.TopRightCorner,
					AzeriteEssenceUI.RightInset.NineSlice.RightEdge,
					AzeriteEssenceUI.RightInset.NineSlice.BottomRightCorner,
					AzeriteEssenceUI.RightInset.NineSlice.BottomEdge,
					AzeriteEssenceUI.RightInset.NineSlice.BottomLeftCorner,
					AzeriteEssenceUI.RightInset.NineSlice.LeftEdge,
					AzeriteEssenceUI.RightInset.NineSlice.TopLeftCorner,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				for i, v in pairs({
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollBarBottom,
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollBarMiddle,
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollBarTop,
					AzeriteEssenceUI.EssenceList.ScrollBar.thumbTexture,
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollUpButton.Normal,
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollDownButton.Normal,
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollUpButton.Disabled,
					AzeriteEssenceUI.EssenceList.ScrollBar.ScrollDownButton.Disabled,
				}) do
					v:SetVertexColor(.4, .4, .4)
				end
			end
		end)

		-- PvP UI
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_PVPUI" then
				for i, v in pairs({
					HonorFrame.BonusFrame.WorldBattlesTexture,
					ConquestFrame.RatedBGTexture,
				}) do
					v:SetVertexColor(.2, .2, .2)
				end
				for i, v in pairs({
					PVPQueueFrame.HonorInset.NineSlice.TopEdge,
					PVPQueueFrame.HonorInset.NineSlice.TopRightCorner,
					PVPQueueFrame.HonorInset.NineSlice.RightEdge,
					PVPQueueFrame.HonorInset.NineSlice.BottomRightCorner,
					PVPQueueFrame.HonorInset.NineSlice.BottomEdge,
					PVPQueueFrame.HonorInset.NineSlice.BottomLeftCorner,
					PVPQueueFrame.HonorInset.NineSlice.LeftEdge,
					PVPQueueFrame.HonorInset.NineSlice.TopLeftCorner,
					HonorFrame.Inset.NineSlice.TopEdge,
					HonorFrame.Inset.NineSlice.TopRightCorner,
					HonorFrame.Inset.NineSlice.RightEdge,
					HonorFrame.Inset.NineSlice.BottomRightCorner,
					HonorFrame.Inset.NineSlice.BottomEdge,
					HonorFrame.Inset.NineSlice.BottomLeftCorner,
					HonorFrame.Inset.NineSlice.LeftEdge,
					HonorFrame.Inset.NineSlice.TopLeftCorner,
					ConquestFrame.Inset.NineSlice.TopEdge,
					ConquestFrame.Inset.NineSlice.TopRightCorner,
					ConquestFrame.Inset.NineSlice.RightEdge,
					ConquestFrame.Inset.NineSlice.BottomRightCorner,
					ConquestFrame.Inset.NineSlice.BottomEdge,
					ConquestFrame.Inset.NineSlice.BottomLeftCorner,
					ConquestFrame.Inset.NineSlice.LeftEdge,
					ConquestFrame.Inset.NineSlice.TopLeftCorner,
					ConquestFrame.ConquestBar.Border,
					HonorFrame.ConquestBar.Border,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
				PVPQueueFrame.HonorInset:Hide();
			end
		end)

		-- Arena
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_ArenaUI" and not (C_AddOns.IsAddOnLoaded("Shadowed Unit Frames")) then
				for i, v in pairs(
					{
						ArenaEnemyFrame1Texture,
						ArenaEnemyFrame2Texture,
						ArenaEnemyFrame3Texture,
						ArenaEnemyFrame4Texture,
						ArenaEnemyFrame5Texture,
						ArenaEnemyFrame1SpecBorder,
						ArenaEnemyFrame2SpecBorder,
						ArenaEnemyFrame3SpecBorder,
						ArenaEnemyFrame4SpecBorder,
						ArenaEnemyFrame5SpecBorder,
						ArenaEnemyFrame1PetFrameTexture,
						ArenaEnemyFrame2PetFrameTexture,
						ArenaEnemyFrame3PetFrameTexture,
						ArenaEnemyFrame4PetFrameTexture,
						ArenaEnemyFrame5PetFrameTexture
					}
				) do
					v:SetVertexColor(.15, .15, .15)
				end
			elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or
				(event == "PLAYER_ENTERING_WORLD" and instanceType == "arena")
			then
				for i, v in pairs(
					{
						ArenaPrepFrame1Texture,
						ArenaPrepFrame2Texture,
						ArenaPrepFrame3Texture,
						ArenaPrepFrame4Texture,
						ArenaPrepFrame5Texture,
						ArenaPrepFrame1SpecBorder,
						ArenaPrepFrame2SpecBorder,
						ArenaPrepFrame3SpecBorder,
						ArenaPrepFrame4SpecBorder,
						ArenaPrepFrame5SpecBorder
					}
				) do
					v:SetVertexColor(.15, .15, .15)
				end
			end

			if C_AddOns.IsAddOnLoaded("Blizzard_ArenaUI") then
				for i, v in pairs(
					{
						ArenaEnemyFrame1Texture,
						ArenaEnemyFrame2Texture,
						ArenaEnemyFrame3Texture,
						ArenaEnemyFrame4Texture,
						ArenaEnemyFrame5Texture,
						ArenaEnemyFrame1SpecBorder,
						ArenaEnemyFrame2SpecBorder,
						ArenaEnemyFrame3SpecBorder,
						ArenaEnemyFrame4SpecBorder,
						ArenaEnemyFrame5SpecBorder,
						ArenaEnemyFrame1PetFrameTexture,
						ArenaEnemyFrame2PetFrameTexture,
						ArenaEnemyFrame3PetFrameTexture,
						ArenaEnemyFrame4PetFrameTexture,
						ArenaEnemyFrame5PetFrameTexture
					}
				) do
					v:SetVertexColor(.15, .15, .15)
				end
			end
		end)

		-- Challenges
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_ChallengesUI" then
				for i, v in pairs({
					ChallengesFrameInset.NineSlice.TopEdge,
					ChallengesFrameInset.NineSlice.TopRightCorner,
					ChallengesFrameInset.NineSlice.RightEdge,
					ChallengesFrameInset.NineSlice.BottomRightCorner,
					ChallengesFrameInset.NineSlice.BottomEdge,
					ChallengesFrameInset.NineSlice.BottomLeftCorner,
					ChallengesFrameInset.NineSlice.LeftEdge,
					ChallengesFrameInset.NineSlice.TopLeftCorner,
				}) do
					v:SetVertexColor(.3, .3, .3)
				end
			end
		end)

		-- Archaeology
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(self, event, name)
			if name == "Blizzard_ArchaeologyUI" then
				for i, v in pairs({ ArchaeologyFrame.NineSlice.TopEdge,
					ArchaeologyFrame.NineSlice.RightEdge,
					ArchaeologyFrame.NineSlice.BottomEdge,
					ArchaeologyFrame.NineSlice.LeftEdge,
					ArchaeologyFrame.NineSlice.TopRightCorner,
					ArchaeologyFrame.NineSlice.TopLeftCorner,
					ArchaeologyFrame.NineSlice.BottomLeftCorner,
					ArchaeologyFrame.NineSlice.BottomRightCorner, }) do
					v:SetVertexColor(.15, .15, .15)
				end
			end
		end)

	end
end
