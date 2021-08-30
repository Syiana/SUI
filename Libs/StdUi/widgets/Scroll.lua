--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Scroll', 6;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

local round = function(num)
	return math.floor(num + .5);
end

----------------------------------------------------
--- ScrollFrame
----------------------------------------------------

StdUi.ScrollBarEvents = {

	UpDownButtonOnClick = function(self)
		local scrollBar = self.scrollBar;
		local scrollFrame = scrollBar.scrollFrame;
		local scrollStep = scrollBar.scrollStep or (scrollFrame:GetHeight() / 2);

		if self.direction == 1 then
			scrollBar:SetValue(scrollBar:GetValue() - scrollStep);
		else
			scrollBar:SetValue(scrollBar:GetValue() + scrollStep);
		end
	end,

	OnValueChanged      = function(self, value)
		self.scrollFrame:SetVerticalScroll(value);
	end
};

StdUi.ScrollFrameEvents = {
	OnMouseWheel         = function(self, value, scrollBar)
		scrollBar = scrollBar or self.scrollBar;
		local scrollStep = scrollBar.scrollStep or scrollBar:GetHeight() / 2;

		if value > 0 then
			scrollBar:SetValue(scrollBar:GetValue() - scrollStep);
		else
			scrollBar:SetValue(scrollBar:GetValue() + scrollStep);
		end
	end,

	OnScrollRangeChanged = function(self, _, yRange)
		-- xRange
		local scrollbar = self.scrollBar;
		if not yRange then
			yRange = self:GetVerticalScrollRange();
		end

		-- Accounting for very small ranges
		yRange = math.floor(yRange);

		local value = math.min(scrollbar:GetValue(), yRange);
		scrollbar:SetMinMaxValues(0, yRange);
		scrollbar:SetValue(value);

		local scrollDownButton = scrollbar.ScrollDownButton;
		local scrollUpButton = scrollbar.ScrollUpButton;
		local thumbTexture = scrollbar.ThumbTexture;

		if yRange == 0 then
			if self.scrollBarHideable then
				scrollbar:Hide();
				scrollDownButton:Hide();
				scrollUpButton:Hide();
				thumbTexture:Hide();
			else
				scrollDownButton:Disable();
				scrollUpButton:Disable();
				scrollDownButton:Show();
				scrollUpButton:Show();
				if (not self.noScrollThumb) then
					thumbTexture:Show();
				end
			end
		else
			scrollDownButton:Show();
			scrollUpButton:Show();
			scrollbar:Show();
			if not self.noScrollThumb then
				thumbTexture:Show();
			end
			-- The 0.005 is to account for precision errors
			if yRange - value > 0.005 then
				scrollDownButton:Enable();
			else
				scrollDownButton:Disable();
			end
		end
	end,

	OnVerticalScroll     = function(self, offset)
		local scrollBar = self.scrollBar;
		scrollBar:SetValue(offset);

		local _, max = scrollBar:GetMinMaxValues();
		scrollBar.ScrollUpButton:SetEnabled(offset ~= 0);
		scrollBar.ScrollDownButton:SetEnabled((scrollBar:GetValue() - max) ~= 0);
	end
}

StdUi.ScrollFrameMethods = {
	SetScrollStep = function(self, scrollStep)
		scrollStep = round(scrollStep);
		self.scrollBar.scrollStep = scrollStep;
		self.scrollBar:SetValueStep(scrollStep);
	end,

	GetChildFrames = function(self)
		return self.scrollBar, self.scrollChild, self.scrollBar.ScrollUpButton, self.scrollBar.ScrollDownButton;
	end,

	UpdateSize     = function(self, newWidth, newHeight)
		self:SetSize(newWidth, newHeight);
		self.scrollFrame:ClearAllPoints();

		-- scrollbar width and margins
		self.scrollFrame:SetSize(newWidth - self.scrollBarWidth - 5, newHeight - 4);
		self.stdUi:GlueAcross(self.scrollFrame, self, 2, -2, -self.scrollBarWidth - 2, 2);

		-- panel of scrollBar
		self.scrollBar.panel:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -2, -2);
		self.scrollBar.panel:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -2, 2);

		if self.scrollChild then
			self.scrollChild:SetWidth(self.scrollFrame:GetWidth());
			self.scrollChild:SetHeight(self.scrollFrame:GetHeight());
		end
	end
};

function StdUi:ScrollFrame(parent, width, height, scrollChild)
	local panel = self:Panel(parent, width, height);
	panel.stdUi = self;
	panel.offset = 0;
	panel.scrollBarWidth = 16;

	local scrollFrame = CreateFrame('ScrollFrame', nil, panel);
	local scrollBar = self:ScrollBar(panel, panel.scrollBarWidth);
	scrollBar:SetMinMaxValues(0, 0);
	scrollBar:SetValue(0);

	scrollBar:SetScript('OnValueChanged', self.ScrollBarEvents.OnValueChanged);
	scrollBar.ScrollUpButton.direction = 1;
	scrollBar.ScrollDownButton.direction = -1;
	scrollBar.ScrollDownButton:SetScript('OnClick', self.ScrollBarEvents.UpDownButtonOnClick);
	scrollBar.ScrollUpButton:SetScript('OnClick', self.ScrollBarEvents.UpDownButtonOnClick);
	scrollBar.ScrollDownButton:Disable();
	scrollBar.ScrollUpButton:Disable();

	if self.noScrollThumb then
		scrollBar.ThumbTexture:Hide();
	end

	scrollBar.scrollFrame = scrollFrame;
	scrollFrame.scrollBar = scrollBar;
	scrollFrame.panel = panel;

	panel.scrollBar = scrollBar;
	panel.scrollFrame = scrollFrame;

	for k, v in pairs(self.ScrollFrameMethods) do
		panel[k] = v;
	end

	for k, v in pairs(self.ScrollFrameEvents) do
		scrollFrame:SetScript(k, v);
	end

	if not scrollChild then
		scrollChild = CreateFrame('Frame', nil, scrollFrame);
		scrollChild:SetWidth(scrollFrame:GetWidth());
		scrollChild:SetHeight(scrollFrame:GetHeight());
	else
		scrollChild:SetParent(scrollFrame);
	end
	panel.scrollChild = scrollChild;

	panel:UpdateSize(width, height);

	scrollFrame:SetScrollChild(scrollChild);
	scrollFrame:EnableMouse(true);
	scrollFrame:SetClampedToScreen(true);
	scrollFrame:SetClipsChildren(true);

	scrollChild:SetPoint('RIGHT', scrollFrame, 'RIGHT', 0, 0);

	scrollFrame.scrollChild = scrollChild;

	return panel;
end


----------------------------------------------------
--- FauxScrollFrame
----------------------------------------------------

StdUi.FauxScrollFrameMethods = {
	GetOffset        = function(self)
		return self.offset or 0;
	end,

	--- Performs vertical scroll
	DoVerticalScroll = function(self, value, itemHeight, updateFunction)
		local scrollBar = self.scrollBar;
		itemHeight = itemHeight or self.lineHeight;

		scrollBar:SetValue(value);
		self.offset = floor((value / itemHeight) + 0.5);

		if updateFunction then
			updateFunction(self);
		end
	end,

	--- Redraws items in case of manual update from outside without changing parameters
	Redraw           = function(self)
		self:Update(
			self.itemCount or #self.scrollChild.items,
			self.displayCount,
			self.lineHeight
		);
	end,

	UpdateItemsCount = function(self, newCount)
		self.itemCount = newCount;
		self:Update(
			newCount,
			self.displayCount,
			self.lineHeight
		);
	end,

	Update           = function(self, numItems, numToDisplay, buttonHeight)
		local scrollBar, scrollChildFrame, scrollUpButton, scrollDownButton = self:GetChildFrames();

		local showScrollBar;
		if numItems == nil or numToDisplay == nil then
			return;
		end

		if numItems > numToDisplay then
			showScrollBar = 1;
		else
			scrollBar:SetValue(0);
		end

		if self:IsShown() then
			local scrollFrameHeight = 0;
			local scrollChildHeight = 0;

			if numItems > 0 then
				scrollFrameHeight = (numItems - numToDisplay) * buttonHeight;
				scrollChildHeight = numItems * buttonHeight;
				if (scrollFrameHeight < 0) then
					scrollFrameHeight = 0;
				end
				scrollChildFrame:Show();
			else
				scrollChildFrame:Hide();
			end

			local maxRange = (numItems - numToDisplay) * buttonHeight;
			if maxRange < 0 then
				maxRange = 0;
			end

			scrollBar:SetMinMaxValues(0, maxRange);
			self:SetScrollStep(buttonHeight);
			scrollBar:SetStepsPerPage(numToDisplay - 1);
			scrollChildFrame:SetHeight(scrollChildHeight);

			-- Arrow button handling
			if scrollBar:GetValue() == 0 then
				scrollUpButton:Disable();
			else
				scrollUpButton:Enable();
			end

			if (scrollBar:GetValue() - scrollFrameHeight) == 0 then
				scrollDownButton:Disable();
			else
				scrollDownButton:Enable();
			end
		end

		return showScrollBar;
	end,
};

local OnVerticalScrollUpdate = function(self)
	self:Redraw();
end;

StdUi.FauxScrollFrameEvents = {
	OnVerticalScroll = function(self, value)
		value = round(value);
		local panel = self.panel;

		panel:DoVerticalScroll(
			value,
			panel.lineHeight,
			OnVerticalScrollUpdate
		);
	end
};

--- Works pretty much the same as scroll frame however it does not have smooth scroll and only display a certain amount
--- of items
function StdUi:FauxScrollFrame(parent, width, height, displayCount, lineHeight, scrollChild)
	local panel = self:ScrollFrame(parent, width, height, scrollChild);

	panel.lineHeight = lineHeight;
	panel.displayCount = displayCount;

	for k, v in pairs(self.FauxScrollFrameMethods) do
		panel[k] = v;
	end

	for k, v in pairs(self.FauxScrollFrameEvents) do
		panel.scrollFrame:SetScript(k, v);
	end

	return panel;
end

----------------------------------------------------
--- HybridScrollFrame
----------------------------------------------------
StdUi.HybridScrollFrameMethods = {
	Update                = function(self, totalHeight)
		local range = floor(totalHeight - self.scrollChild:GetHeight() + 0.5);

		if range > 0 and self.scrollBar then
			local _, maxVal = self.scrollBar:GetMinMaxValues();

			if math.floor(self.scrollBar:GetValue()) >= math.floor(maxVal) then
				self.scrollBar:SetMinMaxValues(0, range);

				if range < maxVal then
					if math.floor(self.scrollBar:GetValue()) ~= math.floor(range) then
						self.scrollBar:SetValue(range);
					else
						-- If we've scrolled to the bottom, we need to recalculate the offset.
						self:SetOffset(self, range);
					end
				end
			else
				self.scrollBar:SetMinMaxValues(0, range)
			end

			self.scrollBar:Enable();
			self:UpdateScrollBarState();
			self.scrollBar:Show();
		elseif self.scrollBar then
			self.scrollBar:SetValue(0);
			if self.scrollBar.doNotHide then
				self.scrollBar:Disable();
				self.scrollBar.ScrollUpButton:Disable();
				self.scrollBar.ScrollDownButton:Disable();
				self.scrollBar.ThumbTexture:Hide();
			else
				self.scrollBar:Hide();
			end
		end

		self.range = range;
		self.totalHeight = totalHeight;
		self.scrollFrame:UpdateScrollChildRect();
	end,

	SetData = function(self, data)
		self.data = data;
	end,

	SetUpdateFunction = function(self, updateFn)
		self.updateFn = updateFn;
	end,

	UpdateScrollBarState    = function(self, currValue)
		if not currValue then
			currValue = self.scrollBar:GetValue();
		end

		self.scrollBar.ScrollUpButton:Enable();
		self.scrollBar.ScrollDownButton:Enable();

		local minVal, maxVal = self.scrollBar:GetMinMaxValues();
		if currValue >= maxVal then
			self.scrollBar.ThumbTexture:Show();
			if self.scrollBar.ScrollDownButton then
				self.scrollBar.ScrollDownButton:Disable()
			end
		end

		if currValue <= minVal then
			self.scrollBar.ThumbTexture:Show();
			if self.scrollBar.ScrollUpButton then
				self.scrollBar.ScrollUpButton:Disable();
			end
		end
	end,

	GetOffset             = function(self)
		return math.floor(self.offset or 0), (self.offset or 0);
	end,

	SetOffset             = function(self, offset)
		local items = self.items;
		local itemHeight = self.itemHeight;
		local element, overflow;

		local scrollHeight = 0;

		if self.dynamic then
			--This is for frames where items will have different heights
			if offset < itemHeight then
				-- a little optimization
				element, scrollHeight = 0, offset;
			else
				element, scrollHeight = self.dynamic(offset);
			end
		else
			element = offset / itemHeight;
			overflow = element - math.floor(element);
			scrollHeight = overflow * itemHeight;
		end

		if math.floor(self.offset or 0) ~= math.floor(element) and self.updateFn then
			self.offset = element;
			self:UpdateItems();
		else
			self.offset = element;
		end

		self.scrollFrame:SetVerticalScroll(scrollHeight);
	end,

	CreateItems         = function(self, data, create, update, padding, oX, oY)
		local scrollChild = self.scrollChild;
		local itemHeight = 0;
		local numItems = #data;
		--initialPoint = initialPoint or 'TOPLEFT';
		--initialRelative = initialRelative or 'TOPLEFT';
		--point = point or 'TOPLEFT';
		--relativePoint = relativePoint or 'BOTTOMLEFT';
		--offsetX = offsetX or 0;
		--offsetY = offsetY or 0;

		if not self.items then
			self.items = {};
		end

		self.data = data;
		self.createFn = create;
		self.updateFn = update;
		self.itemPadding = padding;

		self.stdUi:ObjectList(scrollChild, self.items, create, update, data, padding, oX, oY,
			function (i, totalHeight, lih)
			return totalHeight > self:GetHeight() + lih;
		end);

		if self.items[1] then
			itemHeight = round(self.items[1]:GetHeight() + padding);
		end
		self.itemHeight = itemHeight;

		local totalHeight = numItems * itemHeight;
		self.scrollFrame:SetVerticalScroll(0);

		local scrollBar = self.scrollBar;
		scrollBar:SetMinMaxValues(0, totalHeight);
		scrollBar.itemHeight = itemHeight;
		self:SetScrollStep(itemHeight / 2);

		-- one additional item was added above. Need to remove that,
		-- and one more to make the current bottom the new top (and vice versa)
		scrollBar:SetStepsPerPage(numItems - 2);
		scrollBar:SetValue(0);

		self:Update(totalHeight);
	end,

	UpdateItems = function(self)
		local count = #self.data;

		local offset = self:GetOffset();
		local items = self:GetItems();

		for i = 1, #items do
			local item = items[i];

			local index = offset + i;
			if index <= count  then
				self.updateFn(self.scrollChild, item, self.data[index], index, i);
			end
		end

		local firstButton = items[1];
		local totalHeight = 0;
		if firstButton then
			totalHeight = count * (firstButton:GetHeight() + self.itemPadding);
		end

		self:Update(totalHeight, self:GetHeight());
	end,

	GetItems            = function(self)
		return self.items;
	end,

	SetDoNotHideScrollBar = function(self, doNotHide)
		if not self.scrollBar or self.scrollBar.doNotHide == doNotHide then
			return ;
		end

		self.scrollBar.doNotHide = doNotHide;
		self:Update(self.totalHeight or 0, self.scrollChild:GetHeight());
	end,

	ScrollToIndex         = function(self, index, getHeightFunc)
		local totalHeight = 0;
		local scrollFrameHeight = self:GetHeight();

		for i = 1, index do
			local entryHeight = getHeightFunc(i);

			if i == index then
				local offset = 0;

				-- we don't need to do anything if the entry is fully displayed with the scroll all the way up
				if totalHeight + entryHeight > scrollFrameHeight then
					if (entryHeight > scrollFrameHeight) then
						-- this entry is larger than the entire scrollframe, put it at the top
						offset = totalHeight;
					else
						-- otherwise place it in the center
						local diff = scrollFrameHeight - entryHeight;
						offset = totalHeight - diff / 2;
					end

					-- because of valuestep our positioning might change
					-- we'll do the adjustment ourselves to make sure the entry ends up above the center rather than below
					local valueStep = self.scrollBar:GetValueStep();
					offset = offset + valueStep - mod(offset, valueStep);

					-- but if we ended up moving the entry so high up that its top is not visible, move it back down
					if offset > totalHeight then
						offset = offset - valueStep;
					end
				end

				self.scrollBar:SetValue(offset);
				break;
			end

			totalHeight = totalHeight + entryHeight;
		end
	end
};

local HybridScrollBarOnValueChanged = function(self, value)
	local widget = self.scrollFrame.panel;
	value = round(value);
	widget:SetOffset(value);
	widget:UpdateScrollBarState(value);
end

function StdUi:HybridScrollFrame(parent, width, height, scrollChild)
	local panel = self:ScrollFrame(parent, width, height, scrollChild);

	panel.scrollBar:SetScript('OnValueChanged', HybridScrollBarOnValueChanged);

	panel.scrollFrame:SetScript('OnScrollRangeChanged', nil);
	panel.scrollFrame:SetScript('OnVerticalScroll', nil);

	for k, v in pairs(self.HybridScrollFrameMethods) do
		panel[k] = v;
	end

	--for k, v in pairs(self.HybridScrollFrameEvents) do
	--	panel.scrollFrame:SetScript(k, v);
	--end


	return panel;
end

StdUi:RegisterModule(module, version);