local ADDON, SUI = ...
SUI.CONFIG.GUI = function()
	local Created = false
	local function CreateConfig()

		local SOUND_OFF = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
		local SOUND_ON = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

		local function SUISplit(input)
			local t={}
			for str in string.gmatch(input, "([^.]+)") do
				table.insert(t, str)
			end
			return t
		end

		local function SUIGetDB(key)
			key = SUISplit(key)
			local db = SUIDB
			for i = 1, #key - 1 do
				db = db[key[i]]
			end
			return db[key[#key]]
		end

		local function SUIChangeDB(key, val)
			key = SUISplit(key)
			local db = SUIDB
			for i = 1, #key - 1 do
				db = db[key[i]]
			end
			db[key[#key]] = val
		end

		local function SUIColorCallback(restore)
			local r,g,b = ColorPickerFrame:GetColorRGB()
			local Color = {
				["r"] = r,
				["g"] = g,
				["b"] = b
			}
			SUIChangeDB('COLOR.custom', Color)
		end
		
		local function SUIColorPicker(changedCallback)
			ColorPickerFrame:SetColorRGB(SUIDB.COLOR.custom.r,SUIDB.COLOR.custom.g,SUIDB.COLOR.custom.b)
			ColorPickerFrame.func = changedCallback;
			ColorPickerFrame:Hide()
			ColorPickerFrame:Show()
		end

		local function SUICreateView(name)
			if(SUIConfig.Sidebar.Button)then
				Anchor = SUIConfig.Sidebar.Button
				Pos1 = -0
				Pos2 = -40
			else
				Anchor = SUIConfig.Sidebar
				Pos1 = -10
				Pos2 = 5
			end
			--Button
			SUIConfig.Sidebar.Button = CreateFrame("Button", name, SUIConfig.Sidebar)
			SUIConfig.Sidebar.Button:SetPoint("TOPLEFT", Anchor, "TOPLEFT", Pos1, Pos2)
			SUIConfig.Sidebar.Button:SetWidth(200)
			SUIConfig.Sidebar.Button:SetHeight(50)

			--Icon
			SUIConfig.Sidebar.Button.Icon = SUIConfig.Sidebar.Button:CreateTexture("Icon", "OVERLAY")
			SUIConfig.Sidebar.Button.Icon:SetPoint("LEFT", 20, 0)
			SUIConfig.Sidebar.Button.Icon:SetTexture("Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Config\\" .. name)
			SUIConfig.Sidebar.Button.Icon:SetSize(27, 27)

			--Selection
			SUIConfig.Sidebar.Button.Selection = SUIConfig.Sidebar.Button:CreateTexture("Selection", "BACKGROUND")
			SUIConfig.Sidebar.Button.Selection:Hide()
			SUIConfig.Sidebar.Button.Selection:SetPoint("CENTER", SUIConfig.Sidebar.Button)
			SUIConfig.Sidebar.Button.Selection:SetTexture("Interface\\Common\\bluemenu-main")
			SUIConfig.Sidebar.Button.Selection:SetSize(193, 47)
			SUIConfig.Sidebar.Button.Selection:SetTexCoord(0.00390625, 0.87890625, 0.59179688, 0.66992188)
			SUIConfig.Sidebar.Button.Selection:SetVertexColor(0.265, 0.320, 0.410, 1)
	
			--Text
			SUIConfig.Sidebar.Button.Font = SUIConfig.Sidebar.Button:CreateFontString("Normal", SUIConfig, "GameFontNormal")
			SUIConfig.Sidebar.Button.Font:SetPoint("CENTER")
			--SUIConfig.Sidebar.Button.Font:SetTextColor(0.99,0.99,0.99,1)
			SUIConfig.Sidebar.Button.Font:SetText(name)

			--Textures
			SUIConfig.Sidebar.Button:SetNormalTexture("Interface\\Common\\bluemenu-main")
			SUIConfig.Sidebar.Button:GetNormalTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
			SUIConfig.Sidebar.Button:GetNormalTexture():SetVertexColor(0.135, 0.175, 0.250, 1)
			SUIConfig.Sidebar.Button:SetHighlightTexture("Interface\\Common\\bluemenu-main")
			SUIConfig.Sidebar.Button:GetHighlightTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
			SUIConfig.Sidebar.Button:GetHighlightTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
	
			SUIConfig.Sidebar.Button:SetScript("OnClick",function(self, button, down)
				for i,v in ipairs(SUIConfig.Sidebar.Buttons) do
					_G['SUIConfig.View.' .. v]:Hide()
				end
				_G['SUIConfig.View.' .. name]:Show()

				local MenuButtons = { SUIConfig.Sidebar:GetChildren() };
				for _, MenuButton in ipairs(MenuButtons) do
					MenuButton.Selection:Hide();
					MenuButton:GetNormalTexture():SetVertexColor(0.135, 0.175, 0.250, 1)
					MenuButton.Font:SetFontObject(GameFontNormal)
				end
				self.Selection:Show()
				self:GetNormalTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
				self.Font:SetFontObject(GameFontHighlight)
			end)

			SUIConfig.View = CreateFrame("Frame", 'SUIConfig.View.' .. name, SUIConfig.Content, "BackdropTemplate")
			SUIConfig.View:SetPoint("RIGHT")
			SUIConfig.View:SetWidth(500)
			SUIConfig.View:SetHeight(360)
			SUIConfig.View:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			})
			SUIConfig.View:Hide()
		end
	
		local function SUICreateButton(text, point1, anchor, point2, pos1, pos2, width, height)
			SUIConfig.Button = CreateFrame("Button", nil, _G[anchor], "UIPanelButtonTemplate")
			SUIConfig.Button:SetPoint(point1, anchor, point2, pos1, pos2)
			SUIConfig.Button:SetSize(width, height)
			SUIConfig.Button:SetText(text)
			--Textures
			SUIConfig.Button:SetNormalTexture("Interface\\Common\\bluemenu-main")
			SUIConfig.Button:GetNormalTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
			SUIConfig.Button:GetNormalTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
			SUIConfig.Button:SetHighlightTexture("Interface\\Common\\bluemenu-main")
			SUIConfig.Button:GetHighlightTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
			SUIConfig.Button:GetHighlightTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
		end
	
		local function SUICreateText(text, anchor, point, pos1, pos2)
			SUIConfig.Font = _G[anchor]:CreateFontString(nil, _G[anchor], "GameFontNormalLarge")
			SUIConfig.Font:SetPoint(point, _G[anchor], pos1, pos2)
			SUIConfig.Font:SetText(text)
		end
	
		local function SUICreateCheck(name, anchor, pos1, pos2, tooltip, key)
			SUIConfig.Checkbox = CreateFrame("CheckButton", nil, _G[anchor], "InterfaceOptionsCheckButtonTemplate")
			SUIConfig.Checkbox:SetPoint("TOPLEFT", anchor, "TOPLEFT", pos1, pos2)
			SUIConfig.Checkbox.Text:SetText(name)
			SUIConfig.Checkbox.tooltipText = (tooltip)
			SUIConfig.Checkbox:SetScript("OnShow",function(frame)
				frame:SetChecked(SUIGetDB(key))
			end)
			
			SUIConfig.Checkbox:SetScript("OnClick",function(frame)
				local check = frame:GetChecked()
				PlaySound(check and SOUND_ON or SOUND_OFF)
				if check then
					DEFAULT_CHAT_FRAME:AddMessage(name .. " Enabled", 0, 1, 0)
					SUIChangeDB(key, true)
				else
					DEFAULT_CHAT_FRAME:AddMessage(name .. " Disabled", 1, 0, 0)
					SUIChangeDB(key, false)
				end
			end)
		end

		local function SUICreateDrop(text, point1, anchor, point2, pos1, pos2, key)
			Dropdown = CreateFrame("frame", "dropdown" .. text, _G[anchor], "UIDropDownMenuTemplate")
			Dropdown:SetPoint(point1, anchor, point2, pos1, pos2)
			Dropdown.Title = Dropdown:CreateFontString(nil, nil, "GameFontNormal")
			Dropdown.Title:SetPoint("LEFT", Dropdown, "RIGHT", -20, 24)
			Dropdown.Title:SetText(text)


			
			Dropdown.Left:SetVertexColor(0.265, 0.320, 0.410, 1)
			Dropdown.Middle:SetVertexColor(0.265, 0.320, 0.410, 1)
			Dropdown.Right:SetVertexColor(0.265, 0.320, 0.410, 1)

			Dropdown.Button:GetNormalTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
			Dropdown.Button:GetHighlightTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
			Dropdown.Button:GetPushedTexture():SetVertexColor(0.265, 0.320, 0.410, 1)

			local db = SUIGetDB(key)

			UIDropDownMenu_SetText(Dropdown, db.SELECTED)
			--UIDropDownMenu_SetSelectedName(Dropdown, db.SELECTED)
			UIDropDownMenu_Initialize(Dropdown, function(self, color)
				local info = UIDropDownMenu_CreateInfo()
				info.func = self.SetValue
				for k,v in pairs(db.OPTIONS) do
					info.text, info.arg1 = k, k
					UIDropDownMenu_AddButton(info)
				end
			end)

			function Dropdown:SetValue(value)
				local self = _G["dropdown" .. text]
				SUIChangeDB(key .. '.SELECTED', value)
				self.Text:SetText(value);
			end

		end

		local function SUICreateElements()

			--FRAME
			SUIConfig = CreateFrame("Frame", "SUIConfig", UIParent, "ButtonFrameTemplate")
			SUIConfig:Hide()
			SUIConfigPortrait:SetTexture("Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Config\\sui")
			SUIConfig:SetSize(700, 450)
			SUIConfig:SetPoint("CENTER")
			SUIConfig:SetClampedToScreen(true)
			SUIConfig:EnableMouse(true)
			SUIConfig:SetMovable(true)
			SUIConfig:RegisterForDrag("LeftButton")
			SUIConfig:SetScript("OnDragStart",function(self)self:StartMoving()end)
			SUIConfig:SetScript("OnDragStop",function(self)self:StopMovingOrSizing()end)
			SUIConfig:SetFrameStrata("FULLSCREEN")
			
			SUIConfig.Title = SUIConfig:CreateFontString(nil, SUIConfig, "GameFontNormalLarge")
			SUIConfig.Title:SetPoint("TOP", 0, -30)
			SUIConfig.Title:SetFont("Fonts\\FRIZQT__.TTF", 20)
			SUIConfig.Title:SetText("|cfff58cbaS|r|cff009cffUI|r")

			SUIConfig.Version = SUIConfig:CreateFontString(nil, SUIConfig, "GameFontNormalLarge")
			SUIConfig.Version:SetPoint("TOP", 35, -37)
			SUIConfig.Version:SetFont("Fonts\\FRIZQT__.TTF", 12)
			SUIConfig.Version:SetText("v" .. GetAddOnMetadata("SUI", "version"))

			SUIConfig.Twitch =  SUIConfig:CreateTexture()
			SUIConfig.Twitch:SetTexture("Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Config\\twitch")
			SUIConfig.Twitch:SetPoint("BOTTOMRIGHT",-40,7)
			SUIConfig.Twitch:SetSize(13, 14)
			

			SUIConfig.Discord =  SUIConfig:CreateTexture()
			SUIConfig.Discord:SetTexture("Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Config\\discord")
			SUIConfig.Discord:SetPoint("BOTTOMRIGHT",-15,6)
			SUIConfig.Discord:SetSize(17, 16)
			
			for i, v in pairs(
				{
				SUIConfig.Bg,
				SUIConfig.TitleBg
				}
				) do
				v:SetVertexColor(0.175, 0.2, 0.250)
			end
			for i, v in pairs(
				{
				SUIConfig.PortraitFrame,
				SUIConfig.NineSlice.TopEdge,
				SUIConfig.NineSlice.BottomEdge,
				SUIConfig.NineSlice.RightEdge,
				SUIConfig.NineSlice.LeftEdge,
				SUIConfig.NineSlice.TopLeftCorner,
				SUIConfig.NineSlice.BottomLeftCorner,
				SUIConfig.NineSlice.TopRightCorner,
				SUIConfig.NineSlice.BottomRightCorner,
				SUIConfig.Inset.NineSlice.TopEdge,
				SUIConfig.Inset.NineSlice.BottomEdge,
				SUIConfig.Inset.NineSlice.RightEdge,
				SUIConfig.Inset.NineSlice.LeftEdge,
				SUIConfig.Inset.NineSlice.TopLeftCorner,
				SUIConfig.Inset.NineSlice.TopRightCorner,
				SUIConfig.Inset.NineSlice.BottomLeftCorner,
				SUIConfig.Inset.NineSlice.BottomRightCorner,
				}
				) do
				v:SetVertexColor(0.135, 0.175, 0.250)
			end
		
			--CONTENT
			SUIConfig.Content = CreateFrame("Frame", 'SUIConfig.Content', SUIConfig, "BackdropTemplate")
			SUIConfig.Content:SetPoint("CENTER", -1, -16)
			SUIConfig.Content:SetWidth(685)
			SUIConfig.Content:SetHeight(360)
			SUIConfig.Content:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			})
			--SIDEBAR
			SUIConfig.Sidebar = CreateFrame("Frame", 'SUIConfig.Sidebar', SUIConfig.Content, "BackdropTemplate")
			SUIConfig.Sidebar:SetPoint("LEFT")
			SUIConfig.Sidebar:SetWidth(185)
			SUIConfig.Sidebar:SetHeight(360)
			SUIConfig.Sidebar:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
			SUIConfig.Sidebar.Buttons =  {	'General', 'Frames', 'Plates', 'Buffs', 'Bars', 'Map', 'Chat', 'Misc', 'FAQ'}
			for i,v in ipairs(SUIConfig.Sidebar.Buttons) do SUICreateView(v) end
			_G['SUIConfig.View.General']:Show()
			--_G['SUIConfig.Sidebar.General']:Hide()

		--VIEW General
			--SUICreateButton('Color', 'TOPRIGHT', 'SUIConfig.View.Interface', "TOPRIGHT", -30, -40, 80, 25)
			--SUIConfig.Button:SetScript("OnClick",function(self, button, down)
			--	SUIColorPicker(SUIColorCallback)
			--end)
			SUICreateText('General', 'SUIConfig.View.General', 'TOPLEFT', 15, -20)

			SUICreateDrop('Theme', 'TOPLEFT', 'SUIConfig.View.General', "TOPLEFT", 15, -65, 'THEMES')


			SUICreateDrop('Texture', 'TOP', 'SUIConfig.View.General', "TOP", -60, -65, 'TEXTURES')

			SUICreateDrop('Font', 'TOPRIGHT', 'SUIConfig.View.General', "TOPRIGHT", -135, -65, 'FONTS')

			SUICreateText('Automation', 'SUIConfig.View.General', 'TOPLEFT', 15, -110)
			SUICreateCheck('AutoRepair', 'SUIConfig.View.General', 30,-130, 'test', 'MISC.STATE')
			SUICreateCheck('AutoSell', 'SUIConfig.View.General', 150,-130, 'test', 'MISC.STATE')
			SUICreateCheck('AutoDelete', 'SUIConfig.View.General', 270,-130, 'test', 'MISC.STATE')
			--SUICreateCheck('AutoDelete', 'SUIConfig.View.Misc', 390,-120, 'test', 'MODULES.TEXTURES')
			SUICreateCheck('Release', 'SUIConfig.View.General', 30,-160, 'test', 'MISC.STATE')
			SUICreateCheck('Resurrect', 'SUIConfig.View.General', 150,-160, 'test', 'MISC.STATE')
			--SUICreateCheck('AutoDelete', 'SUIConfig.View.Misc', 270,-150, 'test', 'MODULES.TEXTURES')
			--SUICreateCheck('AutoDelete', 'SUIConfig.View.Misc', 390,-150, 'test', 'MODULES.TEXTURES')

			-- AFKCam
			-- SUICreateText('AFKCam', 'SUIConfig.View.General', 'TOPLEFT', 15, -290)
			-- SUICreateCheck('Title', 'SUIConfig.View.General', 30,-310, 'Hide GarrisonIcon', 'MINIMAP.Garrison')
			-- SUICreateCheck('Guild', 'SUIConfig.View.General', 150,-310, 'Hide Clock', 'MINIMAP.Clock')
			-- SUICreateCheck('Rating', 'SUIConfig.View.General', 270,-310, 'Hide Calender', 'MINIMAP.Date')

		--VIEW FRAMES
			SUICreateText('Unitframes', 'SUIConfig.View.Frames', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Frames', 30,-40, 'test', 'UNITFRAMES.STATE')
			SUICreateButton('Scale', 'TOPRIGHT', 'SUIConfig.View.Frames', "TOPRIGHT", -30, -40, 80, 25)
	
			SUICreateText('Options', 'SUIConfig.View.Frames', 'TOPLEFT', 25, -75)
			SUICreateCheck('BigFrames', 'SUIConfig.View.Frames', 30,-95, 'test', 'UNITFRAMES.CONFIG.BigFrames')
			SUICreateCheck('ClassColor', 'SUIConfig.View.Frames', 150,-95, 'test', 'UNITFRAMES.CONFIG.ClassColor')
			SUICreateCheck('FactionColor', 'SUIConfig.View.Frames', 270,-95, 'test', 'UNITFRAMES.CONFIG.FactionColor')
			--SUICreateCheck('FactionColor', 'SUIConfig.View.Unitframes', 390,-95, 'test', 'UNITFRAMES.FactionColor')

			SUICreateText('Show/Hide Elements', 'SUIConfig.View.Frames', 'TOPLEFT', 25, -130)
			SUICreateCheck('StatusGlow', 'SUIConfig.View.Frames', 30,-150, 'test', 'UNITFRAMES.CONFIG.StatusGlow')
			SUICreateCheck('Background', 'SUIConfig.View.Frames', 150,-150, 'test', 'UNITFRAMES.CONFIG.Background')
			SUICreateCheck('PrestigeBadge', 'SUIConfig.View.Frames', 270,-150, 'test', 'UNITFRAMES.CONFIG.PvPBadge')
			--SUICreateCheck('PrestigeBadge', 'SUIConfig.View.Unitframes', 390,-150, 'test', 'UNITFRAMES.PrestigeBadge')

			SUICreateText('RaidFrames', 'SUIConfig.View.Frames', 'TOPLEFT', 15, -190)
			SUICreateCheck('Enable', 'SUIConfig.View.Frames', 30,-210, 'test', 'RAIDFRAMES.STATE')

			SUICreateText('Options', 'SUIConfig.View.Frames', 'TOPLEFT', 25, -245)
			-- SUICreateCheck('SpellIcon', 'SUIConfig.View.Frames', 30,-265, 'test', 'CASTBARS.CONFIG.Range')
			-- SUICreateCheck('CastTimer', 'SUIConfig.View.Frames', 150,-265, 'test', 'CASTBARS.CONFIG.Flash')

		--VIEW PLATES
			SUICreateText('Tooltip', 'SUIConfig.View.Plates', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Plates', 30,-40, 'test', 'TOOLTIP.STATE')

			SUICreateText('Options', 'SUIConfig.View.Plates', 'TOPLEFT', 25, -75)
			SUICreateCheck('MouseAnchor', 'SUIConfig.View.Plates', 30,-95, 'test', 'TOOLTIP.CONFIG.OnMouse')
			SUICreateCheck('LifeOnTop', 'SUIConfig.View.Plates', 150,-95, 'test', 'TOOLTIP.CONFIG.LifeTop')
			-- SUICreateCheck('Shortbar', 'SUIConfig.View.Plates', 270,-95, 'test', 'ACTIONBAR.CONFIG.Shortbar')
			-- SUICreateCheck('Stats', 'SUIConfig.View.Plates', 390,-95, 'test', 'ACTIONBAR.CONFIG.Stats')

			-- SUICreateText('Hide Elements', 'SUIConfig.View.Plates', 'TOPLEFT', 25, -130)
			-- SUICreateCheck('Hotkeys', 'SUIConfig.View.Plates', 30,-150, 'test', 'ACTIONBAR.CONFIG.HotKeys')
			-- SUICreateCheck('Macros', 'SUIConfig.View.Plates', 150,-150, 'test', 'ACTIONBAR.CONFIG.Macros')
			-- SUICreateCheck('Gryphones', 'SUIConfig.View.Plates', 270,-150, 'test', 'ACTIONBAR.CONFIG.Gryphones')
			-- SUICreateCheck('Menu', 'SUIConfig.View.Plates', 390,-150, 'test', 'ACTIONBAR.CONFIG.Menu')

			SUICreateText('Nameplates', 'SUIConfig.View.Plates', 'TOPLEFT', 15, -135)
			SUICreateCheck('Enable', 'SUIConfig.View.Plates', 30,-155, 'test', 'NAMEPLATE.STATE')

		--VIEW BUFFS
			SUICreateText('Buffs', 'SUIConfig.View.Buffs', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Buffs', 30,-40, 'test', 'BUFFS.STATE')

		--VIEW BARS
			SUICreateText('Actionbar', 'SUIConfig.View.Bars', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Bars', 30,-40, 'test', 'ACTIONBAR.STATE')

			SUICreateText('Options', 'SUIConfig.View.Bars', 'TOPLEFT', 25, -75)
			SUICreateCheck('RangeColor', 'SUIConfig.View.Bars', 30,-95, 'test', 'ACTIONBAR.CONFIG.Range')
			SUICreateCheck('ButtonFlash', 'SUIConfig.View.Bars', 150,-95, 'test', 'ACTIONBAR.CONFIG.Flash')
			SUICreateCheck('Shortbar', 'SUIConfig.View.Bars', 270,-95, 'test', 'ACTIONBAR.CONFIG.Shortbar')
			SUICreateCheck('Stats', 'SUIConfig.View.Bars', 390,-95, 'test', 'ACTIONBAR.CONFIG.Stats')
	
			SUICreateText('Hide Elements', 'SUIConfig.View.Bars', 'TOPLEFT', 25, -130)
			SUICreateCheck('Hotkeys', 'SUIConfig.View.Bars', 30,-150, 'test', 'ACTIONBAR.CONFIG.HotKeys.Hide')
			SUICreateCheck('Macros', 'SUIConfig.View.Bars', 150,-150, 'test', 'ACTIONBAR.CONFIG.Macros.Hide')
			SUICreateCheck('Gryphones', 'SUIConfig.View.Bars', 270,-150, 'test', 'ACTIONBAR.CONFIG.Gryphones')
			SUICreateCheck('Menu', 'SUIConfig.View.Bars', 390,-150, 'test', 'ACTIONBAR.CONFIG.Menu')

			SUICreateText('Castbars', 'SUIConfig.View.Bars', 'TOPLEFT', 15, -190)
			SUICreateCheck('Enable', 'SUIConfig.View.Bars', 30,-210, 'test', 'CASTBARS.STATE')

			SUICreateText('Options', 'SUIConfig.View.Bars', 'TOPLEFT', 25, -245)
			SUICreateCheck('CastIcon', 'SUIConfig.View.Bars', 30,-265, 'test', 'CASTBARS.CONFIG.Icon')
			SUICreateCheck('CastTimer', 'SUIConfig.View.Bars', 150,-265, 'test', 'CASTBARS.CONFIG.Timer')

		--VIEW CHAT
			SUICreateText('Chat', 'SUIConfig.View.Chat', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Chat', 30,-40, 'test', 'CHAT.STATE')

		--VIEW MAP
			SUICreateText('Minimap', 'SUIConfig.View.Map', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Map', 30,-40, 'test', 'MINIMAP.STATE')
	
			SUICreateText('Hide Elements', 'SUIConfig.View.Map', 'TOPLEFT', 25, -75)
			SUICreateCheck('Garrison', 'SUIConfig.View.Map', 30,-95, 'Hide GarrisonIcon', 'MINIMAP.CONFIG.Garrison')
			SUICreateCheck('Clock', 'SUIConfig.View.Map', 115,-95, 'Hide Clock', 'MINIMAP.CONFIG.Clock')
			SUICreateCheck('Date', 'SUIConfig.View.Map', 180,-95, 'Hide Calender', 'MINIMAP.CONFIG.Date')
			SUICreateCheck('Tracking', 'SUIConfig.View.Map', 240,-95, 'Hide TrackIcon', 'MINIMAP.CONFIG.Tracking')
			SUICreateCheck('WorldMap', 'SUIConfig.View.Map', 320,-95, 'Hide MapIcon', 'MINIMAP.CONFIG.WorldMap')
			
			SUICreateText('Custom', 'SUIConfig.View.Map', 'TOPLEFT', 25, -130)
			SUICreateCheck('Icon', 'SUIConfig.View.Map', 30,-150, 'test', 'MINIMAP.CONFIG.ClassSymbol')
			SUICreateCheck('Gestures', 'SUIConfig.View.Map', 90,-150, 'test', 'MINIMAP.CONFIG.CustomGestics')
	
		--VIEW MISC
			SUICreateText('Misc', 'SUIConfig.View.Misc', 'TOPLEFT', 15, -20)
			SUICreateCheck('Enable', 'SUIConfig.View.Misc', 30,-40, 'test', 'MISC.STATE')

		--VIEW FAQ
			SUICreateText('Help', 'SUIConfig.View.FAQ', 'TOPLEFT', 15, -20)
			SUICreateButton('Reset', 'TOPRIGHT', 'SUIConfig.View.FAQ', "TOPRIGHT", -30, -40, 80, 25)
			SUIConfig.Button:SetScript("OnClick",function(self, button, down)
				SUIDB = nil
			end)

			SUICreateButton("Save", "TOPRIGHT", 'SUIConfig', "TOPRIGHT", -120, -30, 100, 25)
			SUIConfig.Button:SetScript("OnClick",function(self, button, down)
				ReloadUI()
			end)
			SUICreateButton("Edit", "TOPRIGHT", 'SUIConfig', "TOPRIGHT", -10, -30, 100, 25)
			SUIConfig.Button:SetScript("OnClick",function(self, button, down)
				SUIConfig:Hide()
				SUIEdit(true)
			end)
		end

		SUICreateElements()
		Created = true
		SUIConfig:Show()
	end

	local activ = false
	function openSUI()
		if activ == false then
			CreateConfig()
			activ = true
		else
			SUIConfig:Show()
		end
	end
	
	GameMenuFrame.Header:Hide()
	local frame = CreateFrame("Button","UIPanelButtonTemplateTest",
	GameMenuFrame, "UIPanelButtonTemplate")
	frame:SetHeight(20)
	frame:SetWidth(145)
	frame:SetText("|cfff58cbaS|r|cff009cffUI|r")
	frame:ClearAllPoints()
	frame:SetPoint("TOP", 0, -11)
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick", function()
		openSUI()
		ToggleGameMenu();
	end)
	SlashCmdList["SUI"] = function() openSUI() end
	SLASH_SUI1 = "/SUI"

end