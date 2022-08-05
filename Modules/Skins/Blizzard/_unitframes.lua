local Module = SUI:NewModule("Skins.UnitFrames");
local addon, ns = ...

function Module:OnEnable()
  if (SUI:Color()) then
        --get the addon namespace
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

  -- v:SetVertexColor(.35, .35, .35) GREY
  -- v:SetVertexColor(.05, .05, .05) DARKEST

  ---------------------------------------
  -- ACTIONS
  ---------------------------------------

  -- REMOVING UGLY PARTS OF UI

	local event_frame = CreateFrame('Frame')
	local enable


  -- COLORING FRAMES
	local CF=CreateFrame("Frame")
	CF:RegisterEvent("PLAYER_ENTERING_WORLD")
	CF:RegisterEvent("GROUP_ROSTER_UPDATE")

	hooksecurefunc('TargetFrame_CheckClassification', function(self, forceNormalTexture)
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
			self.borderTexture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\Target\\elite")
			self.borderTexture:SetVertexColor(1, 1, 1)
		elseif ( classification == "rareelite" ) then
			self.borderTexture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\Target\\rare-elite")
			self.borderTexture:SetVertexColor(1, 1, 1)
		elseif ( classification == "rare" ) then
			self.borderTexture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\Target\\rare")
			self.borderTexture:SetVertexColor(1, 1, 1)
		else
			self.borderTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
			self.borderTexture:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	end)

	function ColorRaid()
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

	CF:SetScript("OnEvent", function(self, event)
		ColorRaid()
		CF:SetScript("OnUpdate", function()
			if CompactRaidGroup1 and not groupcolored == true then
				ColorRaid()
			end
			if CompactRaidFrame1 and not singlecolored == true then
				ColorRaid()
			end
		end)
		if event == "GROUP_ROSTER_UPDATE" then return end
		if not (IsAddOnLoaded("Shadowed Unit Frames")
				or IsAddOnLoaded("PitBull Unit Frames 4.0")
				or IsAddOnLoaded("X-Perl UnitFrames")) then
			
            for i, v in pairs({
				PlayerFrameTexture,
				PlayerFrameAlternateManaBarBorder,
				PlayerFrameAlternateManaBarLeftBorder,
				PlayerFrameAlternateManaBarRightBorder,
				PlayerFrameAlternatePowerBarBorder,
				PlayerFrameAlternatePowerBarLeftBorder,
				PlayerFrameAlternatePowerBarRightBorder,
  				PetFrameTexture,
				PartyMemberFrame1Texture,
				PartyMemberFrame2Texture,
				PartyMemberFrame3Texture,
				PartyMemberFrame4Texture,
				PartyMemberFrame1PetFrameTexture,
				PartyMemberFrame2PetFrameTexture,
				PartyMemberFrame3PetFrameTexture,
				PartyMemberFrame4PetFrameTexture,
   				TargetFrameToTTextureFrameTexture,
				FocusFrameToTTextureFrameTexture,
				CastingBarFrame.Border,
				TargetFrameSpellBar.Border,
				FocusFrameSpellBar.Border,
        		MirrorTimer1Border,
        		MirrorTimer2Border,
        		MirrorTimer3Border,
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

			CompactRaidFrameManagerToggleButton:SetNormalTexture("Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\Raid\\RaidPanel-Toggle")

			hooksecurefunc("GameTooltip_ShowCompareItem", function(self, anchorFrame)
				if self then
					local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
					shoppingTooltip1:SetBackdropBorderColor(.05, .05, .05)
					shoppingTooltip2:SetBackdropBorderColor(.05, .05, .05)
				end
			end)

			GameTooltip:SetBackdropBorderColor(.05, .05, .05)
			GameTooltip.SetBackdropBorderColor = function() end

			for i, v in pairs({
				PlayerPVPIcon,
				TargetFrameTextureFramePVPIcon,
				-- FocusFrameTextureFramePVPIcon
			}) do
				v:SetAlpha(0.35)
			end

			for i=1, 4 do
				_G["PartyMemberFrame"..i.."PVPIcon"]:SetAlpha(0)
				_G["PartyMemberFrame"..i.."NotPresentIcon"]:Hide()
				_G["PartyMemberFrame"..i.."NotPresentIcon"].Show = function() end
			end

			PlayerFrameGroupIndicator:SetAlpha(0)
			PlayerHitIndicator:SetText(nil)
			PlayerHitIndicator.SetText = function() end
			PetHitIndicator:SetText(nil)
			PetHitIndicator.SetText = function() end
		else
			CastingBarFrameBorder:SetVertexColor(unpack(SUI:Color(0.15)))
		end
	end)

 -- COLORING THE MAIN BAR
for i, v in pairs({
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
}) do
   v:SetVertexColor(unpack(SUI:Color(0.15)))
end

if IsAddOnLoaded("BattleForAzerothUI") then
    for i, v in pairs({
        ActionBarArtSmallTexture,
        MicroMenuArtTexture,
    }) do
        v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
end

local function OnEvent(self, event, addon)

	-- RECOLOR CLOCK and STOPWATCH Frames
    if addon == "Blizzard_TimeManager" then
        TimeManagerClockButton:GetRegions():SetVertexColor(unpack(SUI:Color(0.15)))
		StopwatchFrame:GetRegions():SetVertexColor(unpack(SUI:Color(0.15)))
		StopwatchTabFrame:GetRegions():SetVertexColor(unpack(SUI:Color(0.15)))

		local a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r =  TimeManagerFrame:GetRegions()
		for _, v in pairs({a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
    end

	-- RECOLOR TALENTS Frame
	if addon == "Blizzard_TalentUI" then
		local _, a, b, c, d, _, _, _, _, _, e, f, g = PlayerTalentFrame:GetRegions()

		for _, v in pairs({a, b, c, d, e, f, g}) do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
    end

	-- RECOLOR TRADESKILL Frame
	if addon == "Blizzard_TradeSkillUI" then
		local _, a, b, c, d, _, e, f, g, h = TradeSkillFrame:GetRegions()

		for _, v in pairs({ a, b, c, d, e, f, g, h})do
			v:SetVertexColor(unpack(SUI:Color(0.15)))
		end
    end

	-- Unregister when finished recoloring.
	if (IsAddOnLoaded("Blizzard_TalentUI")
			and IsAddOnLoaded("Blizzard_TimeManager")
			and IsAddOnLoaded("Blizzard_TradeSkillUI")) then
		self:UnregisterEvent(event)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", OnEvent)

 -- RECOLOR GRYPHONS
for i, v in pairs({
    MainMenuBarLeftEndCap,
    MainMenuBarRightEndCap,
    StanceBarLeft,
    StanceBarMiddle,
	StanceBarRight
}) do
   v:SetVertexColor(unpack(SUI:Color(0.15)))
end

 -- RECOLOR MINIMAP
for i, v in pairs({
	MinimapBorder,
	MinimapBorderTop,
	MiniMapMailBorder,
	MiniMapTrackingBorder
}) do
   v:SetVertexColor(unpack(SUI:Color(0.15)))
end

for i, v in pairs({
	--LOOT FRAME
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
	--EACH BAG
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

	-- Frames that's not colored for some reason
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

-- BANK
local a, b, c, d, _, e = BankFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
   v:SetVertexColor(unpack(SUI:Color(0.15)))
end

--Darker color stuff
for i, v in pairs({
    LootFrameInsetBg,
    LootFrameTitleBg,
	MerchantFrameTitleBg,
}) do
   v:SetVertexColor(unpack(SUI:Color(0.15)))
end

--PAPERDOLL/Characterframe
local a, b, c, d, _, e = PaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
   v:SetVertexColor(unpack(SUI:Color(0.15)))
end

-- Spellbook Frame
local _, a, b, c, d = SpellBookFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
	v:SetVertexColor(unpack(SUI:Color(0.15)))
end

-- Skilltab
local a, b, c, d = SkillFrame:GetRegions()
for _, v in pairs({a, b, c ,d}) do
    v:SetVertexColor(unpack(SUI:Color(0.15)))
end
for _, v in pairs({ReputationDetailCorner, ReputationDetailDivider}) do
    v:SetVertexColor(unpack(SUI:Color(0.15)))
end
-- Reputation Frame
local a, b, c, d = ReputationFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
    v:SetVertexColor(unpack(SUI:Color(0.15)))
end

-- HONOR Frame
local a, b, c, d = PVPFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
	v:SetVertexColor(unpack(SUI:Color(0.15)))
end

-- MERCHANT
local _, a, b, c, d, _, _, _, e, f, g, h, j, k = MerchantFrame:GetRegions()
for _, v in pairs({a, b, c ,d, e, f, g, h, j, k}) do
	v:SetVertexColor(unpack(SUI:Color(0.15)))
end
--MerchantPortrait
for i, v in pairs({
    MerchantFramePortrait
}) do
   v:SetVertexColor(1, 1, 1)
end

--PETPAPERDOLL/PET Frame
local a, b, c, d, _, e = PetPaperDollFrame:GetRegions()
for _, v in pairs({a, b, c, d, e}) do
	v:SetVertexColor(unpack(SUI:Color(0.15)))
end

-- SPELLBOOK
local _, a, b, c, d = SpellBookFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
    v:SetVertexColor(unpack(SUI:Color(0.15)))
end

SpellBookFrame.Material = SpellBookFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
SpellBookFrame.Material:SetTexture[[Interface\AddOns\SUI\Media\Textures\UnitFrames\Quest\QuestBG.tga]]
SpellBookFrame.Material:SetWidth(547)
SpellBookFrame.Material:SetHeight(541)
SpellBookFrame.Material:SetPoint('TOPLEFT', SpellBookFrame, 22, -74)
SpellBookFrame.Material:SetVertexColor(unpack(SUI:Color(0.15)))

-- Social Frame
local a, b, c, d, e, f, g, _, i, j, k, l, n, o, p, q, r, _, _ = FriendsFrame:GetRegions()
for _, v in pairs({
	a, b, c, d, e, f, g, h, i, j, k, l, n, o, p, q, r,
	FriendsFrameInset:GetRegions(),
	WhoFrameListInset:GetRegions()
}) do
	v:SetVertexColor(unpack(SUI:Color(0.15)))
end

-- Quest Log Frame
local _, _, a, b, c, d = QuestLogFrame:GetRegions()
for _, v in pairs({a, b, c, d}) do
	v:SetVertexColor(unpack(SUI:Color(0.15)))
end
 
QuestLogFrame.Material = QuestLogFrame:CreateTexture(nil, 'OVERLAY', nil, 7)
QuestLogFrame.Material:SetTexture[[Interface\AddOns\SUI\Media\Textures\UnitFrames\Quest\QuestBG.tga]]
QuestLogFrame.Material:SetWidth(514)
QuestLogFrame.Material:SetHeight(400)
QuestLogFrame.Material:SetPoint('TOPLEFT', QuestLogDetailScrollFrame, 0, 0)
QuestLogFrame.Material:SetVertexColor(.7, .7, .7)

-- THINGS THAT SHOULD REMAIN THE REGULAR COLOR
for i, v in pairs({
	BankPortraitTexture,
	BankFrameTitleText,
	MerchantFramePortrait,
	WhoFrameTotals
}) do
   v:SetVertexColor(1, 1, 1)
end



    --for i, v in pairs({
      --PlayerFrameTexture,
      --PlayerFrameAlternateManaBarBorder,
      --PlayerFrameAlternateManaBarLeftBorder,
      --PlayerFrameAlternateManaBarRightBorder,
      --PlayerFrameAlternatePowerBarBorder,
      --PlayerFrameAlternatePowerBarLeftBorder,
      --PlayerFrameAlternatePowerBarRightBorder,
      --PetFrameTexture,
      --PartyMemberFrame1Texture,
      --PartyMemberFrame2Texture,
      --PartyMemberFrame3Texture,
      --PartyMemberFrame4Texture,
     -- PartyMemberFrame1PetFrameTexture,
      --PartyMemberFrame2PetFrameTexture,
      --PartyMemberFrame3PetFrameTexture,
      --PartyMemberFrame4PetFrameTexture,
      --TargetFrameToTTextureFrameTexture,
      --FocusFrameToTTextureFrameTexture,
      --CastingBarFrame.Border,
      --TargetFrameSpellBar.Border,
      --FocusFrameSpellBar.Border,
      --MirrorTimer1Border,
      --MirrorTimer2Border,
      --MirrorTimer3Border,
    --}) do
      --v:SetVertexColor(unpack(SUI:Color(0.15)))
    --end

    -- SUI:SetScript("OnEvent", function(self, event)
    --   ColorRaid()
    --   PlayerFrameGroupIndicator:SetAlpha(0)
    --   PlayerHitIndicator:SetText(nil)
    --   PlayerHitIndicator.SetText = function()
    --   end
    --   PetHitIndicator:SetText(nil)
    --   PetHitIndicator.SetText = function()
    --   end
    --   for _, child in pairs({WarlockPowerFrame:GetChildren()}) do
    --     for _, region in pairs({child:GetRegions()}) do
    --       if region:GetDrawLayer() == "BORDER" then
    --         region:SetVertexColor(unpack(color.secondary))
    --       end
    --     end
    --   end

    -- end)
  end
end