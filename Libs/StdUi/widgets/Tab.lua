--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Tab', 4;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

----------------------------------------------------
--- TabPanel
----------------------------------------------------

local TabPanelMethods = {
	--- Runs callback thru all tabs, if callback returns truthy value, enumeration stops and function returns result
	EnumerateTabs = function(self, callback, ...)
		local result;

		for i = 1, #self.tabs do
			local tab = self.tabs[i];
			result = callback(tab, self, i, ...);
			if result then
				break
			end
		end

		return result;
	end,

	HideAllFrames = function(self)
		for _, tab in pairs(self.tabs) do
			if tab.frame then
				tab.frame:Hide();
			end
		end
	end,

	DrawButtons = function(self)
		local prevBtn;
		for _, tab in pairs(self.tabs) do
			if tab.button then
				tab.button:Hide();
			end

			local btn = tab.button;
			local btnContainer = self.buttonContainer;

			if not btn then
				btn = self.stdUi:Button(btnContainer, nil, self.buttonHeight);
				tab.button = btn;
				btn.tabFrame = self;

				btn:SetScript('OnClick', function(bt)
					bt.tabFrame:SelectTab(bt.tab.name);
				end);
			end

			btn.tab = tab;
			btn:SetText(tab.title);
			btn:ClearAllPoints();

			if self.vertical then
				btn:SetWidth(self.buttonWidth);
			else
				self.stdUi:ButtonAutoWidth(btn);
			end

			if self.vertical then
				if not prevBtn then
					self.stdUi:GlueTop(btn, btnContainer, 0, 0, 'CENTER');
				else
					self.stdUi:GlueBelow(btn, prevBtn, 0, -1);
				end
			else
				if not prevBtn then
					self.stdUi:GlueTop(btn, btnContainer, 0, 0, 'LEFT');
				else
					self.stdUi:GlueRight(btn, prevBtn, 5, 0);
				end
			end

			btn:Show();
			prevBtn = btn;
		end
	end,

	DrawFrames = function(self)
		for _, tab in pairs(self.tabs) do
			if not tab.frame then
				tab.frame = self.stdUi:Frame(self.container);
			end

			tab.frame:ClearAllPoints();
			tab.frame:SetAllPoints();

			if tab.layout then
				self.stdUi:BuildWindow(tab.frame, tab.layout);
				self.stdUi:EasyLayout(tab.frame, { padding = { top = 10 } });

				tab.frame:SetScript('OnShow', function(of)
					of:DoLayout();
				end);
			end

			if tab.onHide then
				tab.frame:SetScript('OnHide', tab.onHide);
			end
		end
	end,

	Update = function(self, newTabs)
		if newTabs then
			self.tabs = newTabs;
		end
		self:DrawButtons();
		self:DrawFrames();
	end,

	GetTabByName = function(self, name)
		for _, tab in pairs(self.tabs) do
			if tab.name == name then
				return tab;
			end
		end
	end,

	SelectTab = function(self, name)
		self.selected = name;
		if self.selectedTab then
			self.selectedTab.button:Enable();
		end

		self:HideAllFrames();
		local foundTab = self:GetTabByName(name);

		if foundTab.name == name and foundTab.frame then
			foundTab.button:Disable();
			foundTab.frame:Show();
			self.selectedTab = foundTab;
			return true;
		end
	end,

	GetSelectedTab = function(self)
		return self.selectedTab;
	end,

	DoLayout = function(self)
		-- redoing layout as container
		local tab = self:GetSelectedTab();
		if tab then
			if tab.frame and tab.frame.DoLayout then
				tab.frame:DoLayout();
			end
		end
	end
};

---
---local t = {
---    {
---        name = 'firstTab',
---        title = 'First',
---    },
---    {
---        name = 'secondTab',
---        title = 'Second',
---    },
---    {
---        name = 'thirdTab',
---        title = 'Third'
---    }
---}
function StdUi:TabPanel(parent, width, height, tabs, vertical, buttonWidth, buttonHeight)
	vertical = vertical or false;
	buttonWidth = buttonWidth or 160;
	buttonHeight = buttonHeight or 20;

	local tabFrame = self:Frame(parent, width, height);
	tabFrame.stdUi = self;
	tabFrame.tabs = tabs;
	tabFrame.vertical = vertical;
	tabFrame.buttonWidth = buttonWidth;
	tabFrame.buttonHeight = buttonHeight;

	tabFrame.buttonContainer = self:Frame(tabFrame);
	tabFrame.container = self:Panel(tabFrame);

	if vertical then
		tabFrame.buttonContainer:SetPoint('TOPLEFT', tabFrame, 'TOPLEFT', 0, 0);
		tabFrame.buttonContainer:SetPoint('BOTTOMLEFT', tabFrame, 'BOTTOMLEFT', 0, 0);
		tabFrame.buttonContainer:SetWidth(buttonWidth);

		tabFrame.container:SetPoint('TOPLEFT', tabFrame.buttonContainer, 'TOPRIGHT', 5, 0);
		tabFrame.container:SetPoint('BOTTOMLEFT', tabFrame.buttonContainer, 'BOTTOMRIGHT', 5, 0);
		tabFrame.container:SetPoint('TOPRIGHT', tabFrame, 'TOPRIGHT', 0, 0);
		tabFrame.container:SetPoint('BOTTOMRIGHT', tabFrame, 'BOTTOMRIGHT', 0, 0);
	else
		tabFrame.buttonContainer:SetPoint('TOPLEFT', tabFrame, 'TOPLEFT', 0, 0);
		tabFrame.buttonContainer:SetPoint('TOPRIGHT', tabFrame, 'TOPRIGHT', 0, 0);
		tabFrame.buttonContainer:SetHeight(buttonHeight);

		tabFrame.container:SetPoint('TOPLEFT', tabFrame.buttonContainer, 'BOTTOMLEFT', 0, -5);
		tabFrame.container:SetPoint('TOPRIGHT', tabFrame.buttonContainer, 'BOTTOMRIGHT', 0, -5);
		tabFrame.container:SetPoint('BOTTOMLEFT', tabFrame, 'BOTTOMLEFT', 0, 0);
		tabFrame.container:SetPoint('BOTTOMRIGHT', tabFrame, 'BOTTOMRIGHT', 0, 0);
	end

	for k, v in pairs(TabPanelMethods) do
		tabFrame[k] = v;
	end

	tabFrame:Update();
	if #tabFrame.tabs > 0 then
		tabFrame:SelectTab(tabFrame.tabs[1].name);
	end

	return tabFrame;
end

StdUi:RegisterModule(module, version);