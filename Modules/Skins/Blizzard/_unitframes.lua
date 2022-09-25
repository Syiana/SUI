local Module = SUI:NewModule("Skins.UnitFrames");
local addon, ns = ...

function Module:OnEnable()
  if (SUI:Color()) then
	--get the config values
	local cfg = ns.cfg
	local dragFrameList = ns.dragFrameList
  
	local addonlist = {
	["Shadowed Unit Frames"] = true, 
	["PitBull Unit Frames 4.0"] = true, 
	["X-Perl UnitFrames"] = true, 
	["Z-Perl UnitFrames"] = true, 
	["EasyFrames"] = true,
	["RougeUI"] = true, 
	["ElvUI"] = true, 
	["Uber UI Classic"] = true, 
	["whoaThickFrames_BCC"] = true, 
	["whoaUnitFrames_BCC"] = true, 
	["AbyssUI"] = true, 
	["KkthnxUI"] = true,
	["TextureScript"] = true,
	["DarkModeUI"] = true,
	["SUI"] = true,
	["RiizUI"] = true
	}
  
	local events = {
		"PLAYER_LOGIN",
		"PLAYER_ENTERING_WORLD",
		"GROUP_ROSTER_UPDATE"
	}
  
	---------------------------------------
	-- ACTIONS
	---------------------------------------
  
	-- REMOVING UGLY PARTS OF UI
	local ipairs = ipairs
	local pairs = pairs
  
	-- Classification
	local function ApplyThickness()
		hooksecurefunc('TargetFrame_CheckClassification', function(self, forceNormalTexture)
				local classification = UnitClassification(self.unit);
				if ( classification == "worldboss" or classification == "elite" ) then
					self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame-Elite")
					self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
				elseif ( classification == "rareelite" ) then
					self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame-Rare-Elite")
					self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
				elseif ( classification == "rare" ) then
					self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame-Rare")
					self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
				else
					self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame")
					self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end)
	
			--Player Name
	
			PlayerFrame.name:ClearAllPoints()
			PlayerFrame.name:SetPoint('TOP', PlayerFrameHealthBar, 0,15)
			
			--Rest Glow
	
			PlayerStatusTexture:SetTexture()
			PlayerRestGlow:SetAlpha(0)
	
			--Player Frame
	
			function LortiUIPlayerFrame(self)
				PlayerFrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetingFrame");
				self.name:Hide();
				self.name:ClearAllPoints();
				self.name:SetPoint("CENTER", PlayerFrame, "CENTER",50.5, 36);
				self.healthbar:SetPoint("TOPLEFT",106,-24);
				self.healthbar:SetHeight(26);
				self.healthbar.LeftText:ClearAllPoints();
				self.healthbar.LeftText:SetPoint("LEFT",self.healthbar,"LEFT",8,0);
				self.healthbar.RightText:ClearAllPoints();
				self.healthbar.RightText:SetPoint("RIGHT",self.healthbar,"RIGHT",-5,0);
				self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
				self.manabar:SetPoint("TOPLEFT",106,-52);
				self.manabar:SetHeight(13);
				self.manabar.LeftText:ClearAllPoints();
				self.manabar.LeftText:SetPoint("LEFT",self.manabar,"LEFT",8,0);
				self.manabar.RightText:ClearAllPoints();
				self.manabar.RightText:SetPoint("RIGHT",self.manabar,"RIGHT",-5,0);
				self.manabar.TextString:SetPoint("CENTER",self.manabar,"CENTER",0,0);
				PlayerFrameGroupIndicatorText:ClearAllPoints();
				PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame,"TOP",0,-20);
				PlayerFrameGroupIndicatorLeft:Hide();
				PlayerFrameGroupIndicatorMiddle:Hide();
				PlayerFrameGroupIndicatorRight:Hide();
			end
		hooksecurefunc("PlayerFrame_ToPlayerArt", LortiUIPlayerFrame)
			
			--Target Frame
	
			function LortiUITargetFrame (self, forceNormalTexture)
				local classification = UnitClassification(self.unit);
				self.highLevelTexture:SetPoint("CENTER", self.levelText, "CENTER", 0,0);
				self.nameBackground:Hide();
				self.name:SetPoint("LEFT", self, 15, 36);
				self.healthbar:SetSize(119, 26);
				self.healthbar:SetPoint("TOPLEFT", 5, -24);
				self.manabar:SetPoint("TOPLEFT", 7, -52);
				self.manabar:SetSize(119, 13);
				self.healthbar.LeftText:SetPoint("LEFT", self.healthbar, "LEFT", 8, 0);
				self.healthbar.RightText:SetPoint("RIGHT", self.healthbar, "RIGHT", -5, 0);
				self.healthbar.TextString:SetPoint("CENTER", self.healthbar, "CENTER", 0, 0);
				self.manabar.LeftText:SetPoint("LEFT", self.manabar, "LEFT", 8, 0);
				self.manabar.RightText:ClearAllPoints();
				self.manabar.RightText:SetPoint("RIGHT", self.manabar, "RIGHT", -5, 0);
				self.manabar.TextString:SetPoint("CENTER", self.manabar, "CENTER", 0, 0);
				if ( forceNormalTexture ) then
					self.haveElite = nil;
					self.Background:SetSize(119,42);
					self.Background:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 7, 35);
				else
					self.haveElite = true;
					self.Background:SetSize(119,42);
				end
				self.healthbar.lockColor = true;
				
			end
			hooksecurefunc("TargetFrame_CheckClassification", LortiUITargetFrame)
	
			--Target of Target Frame Texture
	
			TargetFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetofTargetFrame");
			TargetFrameToTHealthBar:SetHeight(8)
			FocusFrameToTTextureFrameTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-TargetofTargetFrame");
			FocusFrameToTHealthBar:SetHeight(8)
	end
	
	local function Classify(self, forceNormalTexture)
			local classification = UnitClassification(self.unit);
			if ( classification == "minus" ) then
				self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Minus");
				self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
				self.nameBackground:Hide();
				self.manabar.pauseUpdates = true;
				self.manabar:Hide();
				self.manabar.TextString:Hide();
				self.manabar.LeftText:Hide();
				self.manabar.RightText:Hide();
				forceNormalTexture = true;
			elseif ( classification == "worldboss" or classification == "elite" ) then
				self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Target\\elite")
				self.borderTexture:SetVertexColor(1, 1, 1)
			elseif ( classification == "rareelite" ) then
				self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Target\\rare-elite")
				self.borderTexture:SetVertexColor(1, 1, 1)
			elseif ( classification == "rare" ) then
				self.borderTexture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Target\\rare")
				self.borderTexture:SetVertexColor(1, 1, 1)
			else
				self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
				self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	end
		
	local function ColorRaid()
		for g = 1, NUM_RAID_GROUPS do
			local group = _G["CompactRaidGroup"..g.."BorderFrame"]
			if group then
				for _, region in pairs({group:GetRegions()}) do
					if region:IsObjectType("Texture") then
						region:SetVertexColor(unpack(SUI:Color(0.15)))
					end
				end
			end
	
			for m = 1, 5 do
				local frame = _G["CompactRaidGroup"..g.."Member"..m]
				if frame then
					groupcolored = true
					for _, region in pairs({frame:GetRegions()}) do
						if region:GetName():find("Border") then
							region:SetVertexColor(unpack(SUI:Color(0.15)))
						end
					end
				end
	
				local frame = _G["CompactRaidFrame"..m]
					if frame then
						singlecolored = true
						for _, region in pairs({frame:GetRegions()}) do
							if region:GetName():find("Border") then
								region:SetVertexColor(unpack(SUI:Color(0.15)))
							end
						end
					end
				end
			end
		
		for _, region in pairs({CompactRaidFrameContainerBorderFrame:GetRegions()}) do
			if region:IsObjectType("Texture") then
				region:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	end
	
		local function DarkFrames()
		for _,v in pairs({
			PlayerFrameAlternateManaBarBorder,
				PlayerFrameAlternateManaBarLeftBorder,
			PlayerFrameAlternateManaBarRightBorder,
			PlayerFrameAlternatePowerBarBorder,
			PlayerFrameAlternatePowerBarLeftBorder,
			PlayerFrameAlternatePowerBarRightBorder,
			PlayerFrameTexture,
			TargetFrameTextureFrameTexture,
			TargetFrameToTTextureFrameTexture,
			PetFrameTexture,
			PartyMemberFrame1Texture,
			PartyMemberFrame2Texture,
			PartyMemberFrame3Texture,
			PartyMemberFrame4Texture,
			PartyMemberFrame1PetFrameTexture,
			PartyMemberFrame2PetFrameTexture,
			PartyMemberFrame3PetFrameTexture,
			PartyMemberFrame4PetFrameTexture,
			CastingBarFrame.Border,
			FocusFrameToTTextureFrameTexture,
			TargetFrameSpellBar.Border,
			FocusFrameSpellBar.Border,
			MirrorTimer1Border,
			MirrorTimer2Border,
			MirrorTimer3Border,
			MiniMapTrackingButtonBorder,
			Rune1BorderTexture,
			Rune2BorderTexture,
			Rune3BorderTexture,
			Rune4BorderTexture,
			Rune5BorderTexture,
			Rune6BorderTexture,
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
			ArenaEnemyFrame5PetFrameTexture,
			ArenaPrepFrame1Texture,
			ArenaPrepFrame2Texture,
			ArenaPrepFrame3Texture,
			ArenaPrepFrame4Texture,
			ArenaPrepFrame5Texture,
			ArenaPrepFrame1SpecBorder,
			ArenaPrepFrame2SpecBorder,
			ArenaPrepFrame3SpecBorder,
			ArenaPrepFrame4SpecBorder,
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
			for _, region in pairs({CompactRaidFrameManager:GetRegions()}) do
				if region:IsObjectType("Texture") then
					region:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
			for _, region in pairs({CompactRaidFrameManagerContainerResizeFrame:GetRegions()}) do
				if region:GetName():find("Border") then
					region:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
			
			for _,v in pairs({
					MainMenuBarLeftEndCap,
					MainMenuBarRightEndCap,
					StanceBarLeft,
					StanceBarMiddle,
					StanceBarRight
			}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			for _,v in pairs({
				MinimapBorder,
				MinimapBorderTop,
				MiniMapMailBorder,
				MiniMapTrackingBorder,
				MiniMapBattlefieldBorder,
				MiniMapTrackingButtonBorder
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
			for _,v in pairs({
				LootFrameBg,
					LootFrameRightBorder,
				LootFrameLeftBorder,
				LootFrameTopBorder,
				LootFrameBottomBorder,
				LootFrameTopRightCorner,
				LootFrameTopLeftCorner,
				LootFrameBotRightCorner,
				LootFrameBotLeftCorner,
					LootFrameInsetInsetTopRightCorner,
					LootFrameInsetInsetTopLeftCorner,
				LootFrameInsetInsetBotRightCorner,
					LootFrameInsetInsetBotLeftCorner,
				LootFrameInsetInsetRightBorder,
				LootFrameInsetInsetLeftBorder,
				LootFrameInsetInsetTopBorder,
				LootFrameInsetInsetBottomBorder,
					LootFramePortraitFrame,
					ContainerFrame1BackgroundTop,
					ContainerFrame1BackgroundMiddle1,
					ContainerFrame1BackgroundBottom,
				ContainerFrame2BackgroundTop,
					ContainerFrame2BackgroundMiddle1,
					ContainerFrame2BackgroundBottom,
				ContainerFrame3BackgroundTop,
					ContainerFrame3BackgroundMiddle1,
					ContainerFrame3BackgroundBottom,
				ContainerFrame4BackgroundTop,
				ContainerFrame4BackgroundMiddle1,
				ContainerFrame4BackgroundBottom,
				ContainerFrame5BackgroundTop,
				ContainerFrame5BackgroundMiddle1,
				ContainerFrame5BackgroundBottom,
				ContainerFrame6BackgroundTop,
				ContainerFrame6BackgroundMiddle1,
				ContainerFrame6BackgroundBottom,
				ContainerFrame7BackgroundTop,
					ContainerFrame7BackgroundMiddle1,
					ContainerFrame7BackgroundBottom,
					ContainerFrame8BackgroundTop,
					ContainerFrame8BackgroundMiddle1,
					ContainerFrame8BackgroundBottom,
					ContainerFrame9BackgroundTop,
					ContainerFrame9BackgroundMiddle1,
					ContainerFrame9BackgroundBottom,
					ContainerFrame10BackgroundTop,
					ContainerFrame10BackgroundMiddle1,
					ContainerFrame10BackgroundBottom,
					ContainerFrame11BackgroundTop,
					ContainerFrame11BackgroundMiddle1,
					ContainerFrame11BackgroundBottom,
					MerchantFrameTopBorder,
					MerchantFrameBtnCornerRight,
					MerchantFrameBtnCornerLeft,
				MerchantFrameBottomRightBorder,
					MerchantFrameBottomLeftBorder,
					MerchantFrameButtonBottomBorder,
					MerchantFrameBg,
			}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		
		-- PlayerFrame:SetScale(1.3) 
		-- TargetFrame:SetScale(1.3) 
		-- FocusFrame:SetScale(1.3)
		-- PartyMemberFrame1:SetScale(1.5)
		-- PartyMemberFrame2:SetScale(1.5)
		-- PartyMemberFrame3:SetScale(1.5)
		-- PartyMemberFrame4:SetScale(1.5)
			for _,v in pairs({
				ArenaEnemyFrame1PVPIcon,
				ArenaEnemyFrame2PVPIcon,
			}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		
		-- TotemFrame
			for i = 1, MAX_TOTEMS do
					local _, totem = _G["TotemFrameTotem"..i]:GetChildren()
					totem:GetRegions():SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			--BANK
			local vectors = {BankFrame:GetRegions()}
			for i = 1, 3 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			--Darker color stuff
			for i,v in pairs({
				LootFrameInsetBg,
					LootFrameTitleBg,
				MerchantFrameTitleBg,
			}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			--PAPERDOLL/Characterframe
			local a, b, c, d, _, e = PaperDollFrame:GetRegions()
			for _, v in pairs({a, b, c, d, e })do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			-- WorldMapFrame
			local vectors = {WorldMapFrame.BorderFrame:GetRegions()}
			for i = 1, 12 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			-- GameTimeFrame
			local vectors = {GameTimeFrame:GetRegions()}
			for i = 6, 6 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end		
			-- GameMenuFrame
			local vectors = {GameMenuFrame:GetRegions()}
			for i = 1, 1 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			for i, v in pairs({
				GameMenuFrame.RightEdge,
				GameMenuFrame.LeftEdge,
				GameMenuFrame.BottomRightCorner,
				GameMenuFrame.BottomLeftCorner,
				GameMenuFrame.TopRightCorner,
				GameMenuFrame.TopLeftCorner,
				GameMenuFrame.BottomEdge,
				GameMenuFrame.TopEdge
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			-- Skilltab
			local a, b, c, d = SkillFrame:GetRegions()
			for _, v in pairs({a, b, c ,d }) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider }) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
				--Reputation Frame
			local a, b, c, d = ReputationFrame:GetRegions()
			for _, v in pairs({a, b, c, d }) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	end
	
	local function DarkerFrames()
		-- HONOR
		local vectors = {PVPFrame:GetRegions()}
		for i = 3, 7 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		--Character Tabs
	
		local a, b, c, d, e, f = CharacterFrameTab1:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f  = CharacterFrameTab2:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f  = CharacterFrameTab3:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f = CharacterFrameTab4:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f, _, h = CharacterFrameTab5:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- HelpFrame
		local vectors = {HelpFrame:GetRegions()}
		for i = 1, 1 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		for _, v in pairs({
			HelpFrameLeftBorder,
			HelpFrameRightBorder,
			HelpFrameBottomBorder,
			HelpFrameTopBorder,
			HelpFrameBotLeftCorner,
			HelpFrameBotRightCorner,
			HelpFrameTopRightCorner,
			HelpFrameTopLeftCorner,
			HelpFrameBtnCornerLeft,
			HelpFrameBtnCornerRight,
			HelpFrameButtonBottomBorder,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- VideoOptionsFrame
		local vectors = {VideoOptionsFrame:GetRegions()}
		for i = 1, 1 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		for _, v in pairs({
			VideoOptionsFrame.BottomEdge,
			VideoOptionsFrame.TopEdge,
			VideoOptionsFrame.LeftEdge,
			VideoOptionsFrame.RightEdge,
			VideoOptionsFrame.BottomLeftCorner,
			VideoOptionsFrame.TopLeftCorner,
			VideoOptionsFrame.BottomRightCorner,
			VideoOptionsFrame.TopRightCorner,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- InterfaceOptionsFrame
		local vectors = {InterfaceOptionsFrame:GetRegions()}
		for i = 1, 1 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		for _, v in pairs({
			InterfaceOptionsFrame.BottomEdge,
			InterfaceOptionsFrame.TopEdge,
			InterfaceOptionsFrame.LeftEdge,
			InterfaceOptionsFrame.RightEdge,
			InterfaceOptionsFrame.BottomLeftCorner,
			InterfaceOptionsFrame.TopLeftCorner,
			InterfaceOptionsFrame.BottomRightCorner,
			InterfaceOptionsFrame.TopRightCorner,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- AddonList
		local vectors = {AddonList:GetRegions()}
		for i = 1, 1 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		for _	, v in pairs({
			AddonListBotLeftCorner,
			AddonListBotRightCorner,
			AddonListTopLeftCorner,
			AddonListTopRightCorner,
			AddonListBottomBorder,
			AddonListTopBorder,
			AddonListRightBorder,
			AddonListLeftBorder,
			AddonListBottomLeftCorner,
			AddonListBottomRightCorner,
			AddonListTopLeftCorner,
			AddonListTopRightCorner,
			AddonListBtnCornerLeft,
			AddonListBtnCornerRight,
			AddonListButtonBottomBorder,
			AddonListInsetInsetBottomBorder,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- ACP											
		if (IsAddOnLoaded("ACP")) then
			local vectors = {ACP_AddonList:GetRegions()}
			for i = 1, 7 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	
		-- Social Frame
		local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
		for _, v in pairs({
			a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r,
			FriendsFrameInset:GetRegions(),
			WhoFrameListInset:GetRegions()
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		FriendsFrameInsetInsetBottomBorder:SetVertexColor(unpack(SUI:Color(0.15)))
		WhoFrameEditBoxInset:GetRegions():SetVertexColor(unpack(SUI:Color(0.15)))
		WhoFrameDropDownLeft:SetVertexColor(unpack(SUI:Color(0.15)))
		WhoFrameDropDownMiddle:SetVertexColor(unpack(SUI:Color(0.15)))
		WhoFrameDropDownRight:SetVertexColor(unpack(SUI:Color(0.15)))
	
		local a, b, c, d, e, f, g, h, i = WhoFrameEditBoxInset:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f = FriendsFrameTab1:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f = FriendsFrameTab2:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f  = FriendsFrameTab3:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f  = FriendsFrameTab4:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		-- MERCHANT
		local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
		for _, v in pairs({a, b, c ,d, e, f, g, h, j, k
	
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		
		-- RAIDINFOFRAME
		local vectors = {RaidInfoFrame:GetRegions()}
		for i = 6, 14 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
		
		--MerchantPortrait
		for _, v in pairs({
			MerchantFramePortrait
		}) do
			v:SetVertexColor(1, 1, 1)
		end
	
		-- Currency Frame
		local vectors = {TokenFrame:GetRegions()}
		for i = 1, 4 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	end
	
	local function ThirdFrames()
		--PETPAPERDOLL/PET Frame
		local vectors = {PetPaperDollFrame:GetRegions()}
		for i = 2, 5 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, _, c = PetPaperDollFrameCompanionFrame:GetRegions()
		for _, v in pairs({a, c}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- SPELLBOOK
		local _, a, b, c, d = SpellBookFrame:GetRegions()
		for _, v in pairs({a, b, c, d}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		for i = 1, MAX_SKILLLINE_TABS  do
			local vertex = _G["SpellBookSkillLineTab"..i]:GetRegions()
			vertex:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		if not SpellBookFrame.Material then
			SpellBookFrame.Material = SpellBookFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
			SpellBookFrame.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
			SpellBookFrame.Material:SetWidth(547)
			SpellBookFrame.Material:SetHeight(541)
			SpellBookFrame.Material:SetPoint('TOPLEFT', SpellBookFrame, 22, -74)
			SpellBookFrame.Material:SetVertexColor(.7, .7, .7)
		end
	
		-- Quest Log Frame
	
		local vectors = {QuestLogFrame:GetRegions()}
		for i = 2, 3 do
			vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		if IsAddOnLoaded("Leatrix_Plus") and LeaPlusDB["EnhanceQuestLog"] == "On" and not QuestLogFrame.Material then
			QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
			QuestLogFrame.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
			QuestLogFrame.Material:SetWidth(531)
			QuestLogFrame.Material:SetHeight(625)
			QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, -10, 0)
			QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
		else
			QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
			QuestLogFrame.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
			QuestLogFrame.Material:SetWidth(531)
			QuestLogFrame.Material:SetHeight(511)
			QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, -10, 0)
			QuestLogFrame.Material:SetVertexColor(.8, .8, .8)
		end
	
		-- Gossip Frame
		local a, b, c, d, e, f, g, h, i = GossipFrameGreetingPanel:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
			v:SetVertexColor(0.35,0.35,0.35)
		end
	
		if not GossipFrameGreetingPanel.Material then 
			GossipFrameGreetingPanel.Material = GossipFrameGreetingPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
			GossipFrameGreetingPanel.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
			GossipFrameGreetingPanel.Material:SetWidth(514)
			GossipFrameGreetingPanel.Material:SetHeight(522)
			GossipFrameGreetingPanel.Material:SetPoint('TOPLEFT', GossipFrameGreetingPanel, 22, -74)
			--QuestFrameRewardPanel.Material:SetVertexColor(0.7,0.7,0.7)
		end
	
		-- Quest Frame Reward panel
		local a, b, c, d, e, f, g, h, i = QuestFrameRewardPanel:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
			v:SetVertexColor(0.35,0.35,0.35)
		end
	
		if not QuestFrameRewardPanel.Material then
			QuestFrameRewardPanel.Material = QuestFrameRewardPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
			QuestFrameRewardPanel.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
			QuestFrameRewardPanel.Material:SetWidth(514)
			QuestFrameRewardPanel.Material:SetHeight(522)
			QuestFrameRewardPanel.Material:SetPoint('TOPLEFT', QuestFrameRewardPanel, 22, -74)
			--QuestFrameRewardPanel.Material:SetVertexColor(0.7,0.7,0.7)
		end
		
		--Mailbox
	
		for _, v in pairs({
			MailFrameBg,
			MailFrameBotLeftCorner,
			MailFrameBotRightCorner,
			MailFrameBottomBorder,
			MailFrameBtnCornerLeft,
			MailFrameBtnCornerRight,
			MailFrameButtonBottomBorder,
			MailFrameLeftBorder,
			MailFramePortraitFrame,
			MailFrameRightBorder,
			MailFrameTitleBg,
			MailFrameTopBorder,
			MailFrameTopLeftCorner,
			MailFrameTopRightCorner,
			MailFrameInsetInsetBottomBorder,
			MailFrameInsetInsetBotLeftCorner,
			MailFrameInsetInsetBotRightCorner,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f  = MailFrameTab1:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f  = MailFrameTab2:GetRegions()
		for _, v in pairs({a, b, c, d, e, f}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		--THINGS THAT SHOULD REMAIN THE REGULAR COLOR
		for _,v in pairs({
			BankPortraitTexture,
			BankFrameTitleText,
			MerchantFramePortrait,
			WhoFrameTotals
		}) do
			v:SetVertexColor(1, 1, 1)
		end
	
		for _,v in pairs({
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
			MainMenuXPBarTexture0,
			MainMenuXPBarTexture1,
			MainMenuXPBarTexture2,
			MainMenuXPBarTexture3,
			MainMenuXPBarTexture4,
			ReputationWatchBar.StatusBar.WatchBarTexture0,
			ReputationWatchBar.StatusBar.WatchBarTexture1,
			ReputationWatchBar.StatusBar.WatchBarTexture2,
			ReputationWatchBar.StatusBar.WatchBarTexture3,
			ReputationWatchBar.StatusBar.XPBarTexture0,
			ReputationWatchBar.StatusBar.XPBarTexture1,
			ReputationWatchBar.StatusBar.XPBarTexture2,
			ReputationWatchBar.StatusBar.XPBarTexture3,
	
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\Raid\\RaidPanel-Toggle")
	
		hooksecurefunc("GameTooltip_ShowCompareItem", function(self)
			if self then
				local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
				shoppingTooltip1:SetBackdropBorderColor(.05, .05, .05)
				shoppingTooltip2:SetBackdropBorderColor(.05, .05, .05)
			end
		end)
	
		GameTooltip:SetBackdropBorderColor(.05, .05, .05)
		GameTooltip.SetBackdropBorderColor = function() end
	
	
		local a, b, c, d, e, f, g, h, i = QuestFrameDetailPanel:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		if not QuestFrameDetailPanel.Material then
			QuestFrameDetailPanel.Material = QuestFrameDetailPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
			QuestFrameDetailPanel.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
			QuestFrameDetailPanel.Material:SetWidth(514)
			QuestFrameDetailPanel.Material:SetHeight(522)
			QuestFrameDetailPanel.Material:SetPoint('TOPLEFT', QuestFrameDetailPanel, 22, -74)
			QuestFrameDetailPanel.Material:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d, e, f, g, h, i = QuestFrameProgressPanel:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		QuestFrameProgressPanel.Material = QuestFrameProgressPanel:CreateTexture(nil, 'OVERLAY', nil, 7)
		QuestFrameProgressPanel.Material:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\Quest\\QuestBG")
		QuestFrameProgressPanel.Material:SetWidth(514)
		QuestFrameProgressPanel.Material:SetHeight(522)
		QuestFrameProgressPanel.Material:SetPoint('TOPLEFT', QuestFrameProgressPanel, 22, -74)
		QuestFrameProgressPanel.Material:SetVertexColor(unpack(SUI:Color(0.15)))
																						
		-- LFG/LFM Frame
		if(LFGFrame ~= nil) then
			LFGParentFrameBackground:SetVertexColor(unpack(SUI:Color(0.15)))
	
			local a, b, c, d, e, f  = LFGParentFrameTab1:GetRegions()
			for _, v in pairs({a, b, c, d, e, f}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			local a, b, c, d, e, f  = LFGParentFrameTab2:GetRegions()
			for _, v in pairs({a, b, c, d, e, f}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	
		-- Dropdown Lists
		for _, v in pairs({
			DropDownList1MenuBackdrop.BottomEdge,
			DropDownList1MenuBackdrop.BottomLeftCorner,
			DropDownList1MenuBackdrop.BottomRightCorner,
			DropDownList1MenuBackdrop.LeftEdge,
			DropDownList1MenuBackdrop.RightEdge,
			DropDownList1MenuBackdrop.TopEdge,
			DropDownList1MenuBackdrop.TopLeftCorner,
			DropDownList1MenuBackdrop.TopRightCorner,
			DropDownList2MenuBackdrop.BottomEdge,
			DropDownList2MenuBackdrop.BottomLeftCorner,
			DropDownList2MenuBackdrop.BottomRightCorner,
			DropDownList2MenuBackdrop.LeftEdge,
			DropDownList2MenuBackdrop.RightEdge,
			DropDownList2MenuBackdrop.TopEdge,
			DropDownList2MenuBackdrop.TopLeftCorner,
			DropDownList2MenuBackdrop.TopRightCorner,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- Color Picker Frame
	
		for _, v in pairs({
			ColorPickerFrame.BottomEdge,
			ColorPickerFrame.BottomLeftCorner,
			ColorPickerFrame.BottomRightCorner,
			ColorPickerFrame.LeftEdge,
			ColorPickerFrame.RightEdge,
			ColorPickerFrame.TopEdge,
			ColorPickerFrame.TopLeftCorner,
			ColorPickerFrame.TopRightCorner,
			ColorPickerFrameHeader,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- Keyring
	
		local a, b, c, d = KeyRingButton:GetRegions()
			for _, v in pairs({b}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		-- Action Bar Arrows
	
		local a, b, c, d = ActionBarUpButton:GetRegions()
			for _, v in pairs({a}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local a, b, c, d = ActionBarDownButton:GetRegions()
			for _, v in pairs({a}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		MainMenuBarPageNumber:SetVertexColor(unpack(SUI:Color(0.15)))
	
		for _, v in pairs({
			PlayerTitleDropDownLeft,
			PlayerTitleDropDownMiddle,
			PlayerTitleDropDownRight,
			PlayerTitleDropDownButtonNormalTexture,
		}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
		local _, b, c, d, e = BattlefieldFrame:GetRegions()
		for _, v in pairs({b, c, d, e}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	
	
		-- Scoreboard
			local a, b, c, d, e, f, _, _, _, _ ,_, l = WorldStateScoreFrame:GetRegions()
			for _, v in pairs({a, b, c, d, e, f, l}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end	
	end
	
	local function ThemeBlizzAddons(addon)
	
		-- Wardrobe
		local _, a, b, c, d = DressUpFrame:GetRegions()
		for _, v in pairs({a, b, c, d, e}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
			
		if CraftFrame ~= nil then
			local vectors = {CraftFrame:GetRegions()}
			for i = 1, 6 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
		
		if TradeFrame ~= nil then
			local vectors = {TradeFrame:GetRegions()}
			for i = 2, 1 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
			
			for _, v in pairs({
				TradeFrameBg,
				TradeFrameBottomBorder,
				TradeFrameButtonBottomBorder,
				TradeFrameLeftBorder,
				TradeFrameRightBorder,
				TradeFrameTitleBg,
				TradeFrameTopBorder,
				TradeFrameTopRightCorner,
				TradeFrameBtnCornerLeft,
				TradeFrameBtnCornerRight,
				TradeFramePortraitFrame,
				TradeRecipientLeftBorder,
				TradeRecipientBG,
				TradeRecipientPortraitFrame,
				TradeRecipientBotLeftCorner,
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	
		-- ItemSocketingFrame
		if ItemSocketingFrame ~= nil then
			local vectors = {ItemSocketingFrame:GetRegions()}
			for i = 2, 2 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
		
	-- Macro's
		if addon == "Blizzard_MacroUI" then
			local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r = MacroFrame:GetRegions()
			for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r})do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
			
			for _, v in pairs({
				MacroFrameTab1Left,
				MacroFrameTab1Right,
				MacroFrameTab1Middle,
				MacroFrameTab1LeftDisabled,
				MacroFrameTab1MiddleDisabled,
				MacroFrameTab1RightDisabled,
				MacroFrameTab2Left,
				MacroFrameTab2Right,
				MacroFrameTab2Middle,
				MacroFrameTab2LeftDisabled,
				MacroFrameTab2MiddleDisabled,
				MacroFrameTab2RightDisabled,
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
		end
		
	-- GlyphFrame
		if addon == "Blizzard_GlyphUI" then
			local vectors = {GlyphFrame:GetRegions()}
			for i = 1, 1 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			for _, v in pairs({
				GlyphFrameGlyph1Background,
				GlyphFrameGlyph2Background,
				GlyphFrameGlyph3Background,
				GlyphFrameGlyph4Background,
				GlyphFrameGlyph5Background,
				GlyphFrameGlyph1Ring,
				GlyphFrameGlyph2Ring,
				GlyphFrameGlyph3Ring,
				GlyphFrameGlyph4Ring,
				GlyphFrameGlyph5Ring,
				GlyphFrameGlyph1Setting,
				GlyphFrameGlyph2Setting,
				GlyphFrameGlyph3Setting,
				GlyphFrameGlyph4Setting,
				GlyphFrameGlyph5Setting,
			}) do
				v:SetVertexColor(1,1,1)
			end
		end
	
		-- CalendarFrame
		if addon == "Blizzard_Calendar" then
			local vectors = {CalendarFrame:GetRegions()}
			for i = 1, 13 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	
		if addon == "Blizzard_BindingUI" then
			-- KeyBindingFrame
			local vectors = {KeyBindingFrame:GetRegions()}
			for i = 1, 1 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			local vectors = {KeyBindingFrame.header:GetRegions()}
	
			for i = 1, 6 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			for _, v in pairs({
				KeyBindingFrame.BottomEdge,
				KeyBindingFrame.TopEdge,
				KeyBindingFrame.LeftEdge,
				KeyBindingFrame.RightEdge,
				KeyBindingFrame.BottomLeftCorner,
				KeyBindingFrame.TopLeftCorner,
				KeyBindingFrame.BottomRightCorner,
				KeyBindingFrame.TopRightCorner,
				KeyBindingFrameBottomBorder,
				KeyBindingFrameTopBorder,
				KeyBindingFrameRightBorder,
				KeyBindingFrameLeftBorder,
				KeyBindingFrameBottomLeftCorner,
				KeyBindingFrameBottomRightCorner,
				KeyBindingFrameTopLeftCorner,
				KeyBindingFrameTopRightCorner,
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	
			if addon == "Blizzard_TimeManager" then
				for _, v in pairs({StopwatchFrame:GetRegions()})do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				local a, b, c = StopwatchTabFrame:GetRegions()
				for _, v in pairs({a, b, c})do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r =  TimeManagerFrame:GetRegions()
				for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r})do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				for _, v in pairs({TimeManagerFrameInset:GetRegions()})do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				TimeManagerClockButton:GetRegions():SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			--RECOLOR Achievement
	
			if addon == "Blizzard_AchievementUI" then
				local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o = AchievementFrame:GetRegions()
				for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, m, n, o}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
			-- Barber
			if addon == "Blizzard_BarbershopUI" then
				local a, b, c = BarberShopFrame:GetRegions()
				for _, v in pairs({a, b, c}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
			--RECOLOR TALENTS
	
			if addon == "Blizzard_TalentUI" then
				local vectors = {PlayerTalentFrame:GetRegions()}
				for i = 2, 6 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				local vectors = {PlayerTalentFramePointsBar:GetRegions()}
				for i = 1, 4 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
				
				PlayerSpecTab1Background:SetVertexColor(unpack(SUI:Color(0.15)))
				PlayerSpecTab2Background:SetVertexColor(unpack(SUI:Color(0.15)))
			
				for _, v in pairs({
					PlayerTalentFrameScrollFrameBackgroundTop,
					PlayerTalentFrameScrollFrameBackgroundBottom,
					PlayerTalentFrameTab1LeftDisabled,
					PlayerTalentFrameTab1MiddleDisabled,
					PlayerTalentFrameTab1RightDisabled,
					PlayerTalentFrameTab2LeftDisabled,
					PlayerTalentFrameTab2MiddleDisabled,
					PlayerTalentFrameTab2RightDisabled,
					PlayerTalentFrameTab3LeftDisabled,
					PlayerTalentFrameTab3MiddleDisabled,
					PlayerTalentFrameTab3RightDisabled,
					PlayerTalentFrameTab4LeftDisabled,
					PlayerTalentFrameTab4MiddleDisabled,
					PlayerTalentFrameTab4RightDisabled,
				}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
			--RECOLOR TRADESKILL
			if addon == "Blizzard_TradeSkillUI" then
				local vectors = {TradeSkillFrame:GetRegions()}
				for i = 2, 6 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
			-- ClassTrainerFrame
			if addon == "Blizzard_TrainerUI" then
				local _, a, b, c, d, _, e, f, g, h = ClassTrainerFrame:GetRegions()
	
				for _, v in pairs({ a, b, c, d, e, f, g, h})do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
			-- InspectFrame/InspectTalentFrame/InspectPVPFrame
	
			if addon == "Blizzard_InspectUI" then
				for _, v in pairs({
					InspectTalentFramePointsBarBorderLeft,
					InspectTalentFramePointsBarBorderMiddle,
					InspectTalentFramePointsBarBorderRight,
					InspectTalentFramePointsBarBackground,
					InspectFrameTab1LeftDisabled,
					InspectFrameTab1MiddleDisabled,
					InspectFrameTab1RightDisabled,
					InspectFrameTab2LeftDisabled,
					InspectFrameTab2MiddleDisabled,
					InspectFrameTab2RightDisabled,
					InspectFrameTab3LeftDisabled,
					InspectFrameTab3MiddleDisabled,
					InspectFrameTab3RightDisabled,
				}) do
					v:SetVertexColor(unpack(SUI:Color(0.15)))
				end
				local vectors = {InspectPaperDollFrame:GetRegions()}
				for i = 1, 4 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				local vectors = {InspectPVPFrame:GetRegions()}
				for i = 1, 5 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				local vectors = {InspectTalentFrame:GetRegions()}
				for i = 1, 5 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
	
				local vectors = {InspectTalentFrameScrollFrame:GetRegions()}
				for i = 1, 2 do
					vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
				end
			end
	
		-- LFGListingFrame
		if addon == "Blizzard_LookingForGroupUI" then
			for _, v in pairs({
				LFGParentFrameTab1LeftDisabled,
				LFGParentFrameTab1MiddleDisabled,
				LFGParentFrameTab1RightDisabled,
				LFGParentFrameTab1LeftDisabled,
				LFGParentFrameTab1MiddleDisabled,
				LFGParentFrameTab1RightDisabled,
				LFGParentFrameTab2LeftDisabled,
				LFGParentFrameTab2MiddleDisabled,
				LFGParentFrameTab2RightDisabled,
			}) do
				v:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			local vectors = {LFGListingFrame:GetRegions()}
			for i = 1, 3 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
	
			local vectors = {LFGBrowseFrame:GetRegions()}
			for i = 1, 4 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	
		-- AuctionFrame
		if addon == "Blizzard_AuctionUI" then
			local vectors = {AuctionFrame:GetRegions()}
			for i = 2, 7 do
				vectors[i]:SetVertexColor(unpack(SUI:Color(0.15)))
			end
		end
	end
	
	
	local function OnLoad()
		TargetFrameToTPortrait:ClearAllPoints()
		TargetFrameToTPortrait:SetPoint("LEFT", TargetFrameToT, "LEFT", 4.8, -.5)
		FocusFrameToTPortrait:ClearAllPoints()
		FocusFrameToTPortrait:SetPoint("LEFT", FocusFrameToT, "LEFT", 4.8, -.5)
	end
	
	local lastTargetToTGuid = nil
	local lastFocusToTGuid = nil
	local CP = {}
	
	function CP:CreateToTPortraits()
		if not self.TargetToTPortrait then
			self.TargetToTPortrait = TargetFrameToT:CreateTexture(nil, "ARTWORK")
			self.TargetToTPortrait:SetSize(TargetFrameToT.portrait:GetSize())
			for i=1, TargetFrameToT.portrait:GetNumPoints() do
				self.TargetToTPortrait:SetPoint(TargetFrameToT.portrait:GetPoint(i))
			end
		end
	
		if not self.FocusToTPortrait then
			self.FocusToTPortrait = FocusFrameToT:CreateTexture(nil, "ARTWORK")
			self.FocusToTPortrait:SetSize(FocusFrameToT.portrait:GetSize())
			for i=1, FocusFrameToT.portrait:GetNumPoints() do
				self.FocusToTPortrait:SetPoint(FocusFrameToT.portrait:GetPoint(i))
			end
		end
	end
	
	local function PvPIcon()
		for _,v in pairs({
			PlayerPVPIcon,
			TargetFrameTextureFramePVPIcon,
			FocusFrameTextureFramePvPIcon,
		}) do
			v:SetAlpha(0.35)
		end
	
		for i=1,4 do
			_G["PartyMemberFrame"..i.."PVPIcon"]:SetAlpha(0)
			_G["PartyMemberFrame"..i.."NotPresentIcon"]:Hide()
			_G["PartyMemberFrame"..i.."NotPresentIcon"].Show = function() end
		end
	end
	
	local Framecolor = CreateFrame("Frame")
	Framecolor:RegisterEvent("ADDON_LOADED")
	Framecolor:SetScript("OnEvent", function(self, _, addon)
		DarkFrames()
		DarkerFrames()
		ThirdFrames()
		self:UnregisterEvent("ADDON_LOADED")
		self:SetScript("OnEvent", nil)
	end)
	
	-- This will never unregister, because no sane person loads all the addons during the session.
	local BlizzOfc = CreateFrame("Frame")
	BlizzOfc:RegisterEvent("ADDON_LOADED")
	BlizzOfc:SetScript("OnEvent", function(self, event, addon)
		if event then
			ThemeBlizzAddons(addon)
		end
	end)
	
	local function OnEvent(self, event)
		if (event == "PLAYER_LOGIN") then
			OnLoad()
			enable()
	
			for addon in pairs(addonlist) do
				if IsAddOnLoaded(addon) then
					self:UnregisterEvent("PLAYER_LOGIN")
					return
				end
			end
		end
	
		if (event == "PLAYER_ENTERING_WORLD") then
			PvPIcon()
	
			if CompactRaidGroup1 and not groupcolored == true then
				ColorRaid()
			end
	
			if CompactRaidFrame1 and not singlecolored == true then
				ColorRaid()
			end
		end
	
		if (event == "GROUP_ROSTER_UPDATE") then
			if CompactRaidGroup1 and not groupcolored == true then
				ColorRaid()
			end
	
			if CompactRaidFrame1 and not singlecolored == true then
				ColorRaid()
			end
		end
		
		self:UnregisterEvent("PLAYER_LOGIN")
	end
	
	local e = CreateFrame("Frame")
	for _, v in pairs(events) do e:RegisterEvent(v) end
	e:SetScript("OnEvent", OnEvent)
  end
end