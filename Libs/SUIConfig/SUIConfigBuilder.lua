--- @type SUIConfig
local SUIConfig = LibStub and LibStub('SUIConfig', true);
if not SUIConfig then
	return
end

local module, version = 'Builder', 7;
if not SUIConfig:UpgradeNeeded(module, version) then
	return
end

local util = SUIConfig.Util;

-- Dotted key access ("a.b.c"). Plain find: a pattern '.' would match any key.
local function setDatabaseValue(db, key, value)
	local start = 1;
	while true do
		local dot = key:find('.', start, true);
		if not dot then
			db[key:sub(start)] = value;
			return
		end
		local subKey = key:sub(start, dot - 1);
		if type(db[subKey]) ~= 'table' then
			db[subKey] = {};
		end
		db = db[subKey];
		start = dot + 1;
	end
end

local function getDatabaseValue(db, key)
	local start = 1;
	while db ~= nil do
		local dot = key:find('.', start, true);
		if not dot then
			return db[key:sub(start)];
		end
		db = db[key:sub(start, dot - 1)];
		start = dot + 1;
	end
end

SUIConfig.GetDatabaseValue = getDatabaseValue;
SUIConfig.SetDatabaseValue = setDatabaseValue;

-- An element is shown unless it is limited to other clients or hidden by a predicate.
-- The host add-on may set SUIConfig.IsClientSupported(clients).
local function isVisible(self, info)
	if type(info) ~= 'table' then
		return false
	end
	if info.clients and self.IsClientSupported and not self.IsClientSupported(info.clients) then
		return false
	end
	if type(info.hidden) == 'function' then
		return not info.hidden(info)
	end
	return not info.hidden
end
SUIConfig.IsElementVisible = isVisible;

---BuildElement
--@param frame Frame
--@param row EasyLayoutRow
--@param info table
--@param dataKey string
--@param db table
function SUIConfig:BuildElement(frame, row, info, dataKey, db)
	local element;

	local genericChangeEvent = function(el, value)
		if el.accessor then
			el.accessor.set(el.dataKey, value, info);
		else
			setDatabaseValue(el.dbReference, el.dataKey, value);
		end
		if el.onChange then
			el:onChange(value);
		end
	end

	local hasLabel = false;
	if info.type == 'checkbox' then
		element = self:Checkbox(frame, info.label, nil, nil, info.tooltip);
	elseif info.type == 'editBox' then
		element = self:EditBox(frame, nil, 20);
	elseif info.type == 'multiLineBox' then
		element = self:MultiLineBox(frame, 300, info.height or 20, info.text or '');
	elseif info.type == 'dropdown' then
		element = self:Dropdown(frame, 300, 20, info.options or {}, nil, info.multi or nil, info.assoc or false);
	elseif info.type == 'autocomplete' then
		element = self:Autocomplete(frame, 300, 20, '');

		if info.validator then
			element.validator = info.validator;
		end
		if info.transformer then
			element.transformer = info.transformer;
		end
		if info.buttonCreate then
			element.buttonCreate = info.buttonCreate;
		end
		if info.buttonUpdate then
			element.buttonUpdate = info.buttonUpdate;
		end
		if info.items then
			element:SetItems(info.items);
		end
	elseif info.type == 'slider' or info.type == 'sliderWithBox' then
		element = self:SliderWithBox(frame, nil, 32, 0, info.min or 0, info.max or 2);

		if info.step then
			element:SetValueStep(info.step);
		end

		if info.precision then
			element:SetPrecision(info.precision);
		elseif info.step and info.step < 1 then
			local stepString = tostring(info.step);
			local decimals = stepString:match("%.(%d+)");
			element:SetPrecision(decimals and #decimals or 0);
		end
	elseif info.type == 'color' then
		element = self:ColorInput(frame, info.label, 100, 20, info.color, info.update, info.cancel);
	elseif info.type == 'button' then
		element = self:Button(frame, nil, 20, info.text or '');

		if info.onClick then
			element:SetScript('OnClick', info.onClick);
		end
	elseif info.type == 'header' then
		element = self:Header(frame, info.label);
	elseif info.type == 'label' then
		element = self:Label(frame, info.label);
	elseif info.type == 'texture' then
		element = self:Texture(frame, info.width or 24, info.height or 24, info.texture);
	elseif info.type == 'panel' then  -- Containers
		element = self:Panel(frame, 300, 20);
	elseif info.type == 'scroll' then
		element = self:ScrollFrame(
			frame,
			300,
			info.height or 20,
			type(info.scrollChild) == 'table' and info.scrollChild or nil
		);
		if type(info.scrollChild) == 'function' then
			info.scrollChild(element);
		end
	elseif info.type == 'fauxScroll' then
		element = self:FauxScrollFrame(
			frame,
			300,
			info.height or 20,
			info.displayCount or 5,
			info.lineHeight or 22,
			type(info.scrollChild) == 'table' and info.scrollChild or nil
		);
		if type(info.scrollChild) == 'function' then
			info.scrollChild(element);
		end
	elseif info.type == 'tab' then
		element = self:TabPanel(
			frame,
			300,
			20,
			info.tabs or {},
			info.vertical or false,
			info.buttonWidth,
			info.buttonHeight
		);
	elseif info.type == 'custom' then
		element = info.createFunction(frame, row, info, dataKey, db);
	end

	if not element then
		print('Could not build element with type: ', info.type);
	end

	-- Widgets can have initialization code
	if info.init then
		info.init(element);
	end

	element.dbReference = db;
	element.dataKey = dataKey;
	if info.onChange then
		element.onChange = info.onChange;
	end

	if element.hasLabel then
		hasLabel = true;
	end

	local canHaveLabel = info.type ~= 'checkbox' and
		info.type ~= 'header' and
		info.type ~= 'label' and
		info.type ~= 'color';

	if info.label and canHaveLabel then
		self:AddLabel(frame, element, info.label);
		hasLabel = true;
	end

	if info.initialValue then
		if element.SetChecked then
			element:SetChecked(info.initialValue);
		elseif element.SetColor then
			element:SetColor(info.initialValue);
		elseif element.SetValue then
			element:SetValue(info.initialValue);
		end
	end

	-- Setting onValueChanged disqualifies from any writes to database
	if info.onValueChanged then
		element.OnValueChanged = info.onValueChanged;
	elseif db then
		local iVal;
		if db.__accessor then
			element.accessor = db.__accessor;
			iVal = db.__accessor.get(dataKey, info);
		else
			iVal = getDatabaseValue(db, dataKey);
		end

		if info.type == 'checkbox' then
			element:SetChecked(iVal)
		elseif element.SetColor then
			element:SetColor(iVal);
		elseif element.SetValue then
			element:SetValue(iVal);
		end

		element.OnValueChanged = genericChangeEvent;
	end

	-- Technically, every frame can be a container
	if info.children then
		self:BuildWindow(element, info.children);
		self:EasyLayout(element, { padding = { top = 10 } });

		element:SetScript('OnShow', function(of)
			of:DoLayout();
		end);
	end

	row:AddElement(element, {
		column = info.column or 12,
		fullSize = info.fullSize or false,
		fullHeight = info.fullHeight or false,
		margin = info.layoutMargins or {
			top = (hasLabel and 20 or 0)
		}
	});

	return element;
end

---BuildRow
--@param frame Frame
--@param info table
--@param db table
function SUIConfig:BuildRow(frame, info, db)
	local anyVisible = false;
	for _, element in pairs(info) do
		if isVisible(self, element) then
			anyVisible = true;
			break
		end
	end
	if not anyVisible then
		return
	end

	local row = frame:AddRow();

	for key, element in util.orderedPairs(info) do
		if not isVisible(self, element) then
			-- filtered for this client
		else
		local dataKey = element.key or key or nil;

		local el = self:BuildElement(frame, row, element, dataKey, db);
		if element then
			if not frame.elements then
				frame.elements = {};
			end

			frame.elements[key] = el;
		end
		end
	end
end

---BuildWindow
--@param frame Frame
--@param info table
function SUIConfig:BuildWindow(frame, info)
	-- info.get(key, element) / info.set(key, value, element) replace direct table writes.
	local db = info.database or nil;
	if info.get and info.set then
		db = { __accessor = { get = info.get, set = info.set } };
	end

	assert(info.rows, 'Rows are required in order to build table');
	local rows = info.rows;

	self:EasyLayout(frame, info.layoutConfig);

	for _, row in util.orderedPairs(rows) do
		self:BuildRow(frame, row, db);
	end

	frame:DoLayout();
end

SUIConfig:RegisterModule(module, version);
