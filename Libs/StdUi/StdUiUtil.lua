--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Util', 10;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

local TableGetN = table.getn;
local TableInsert = tinsert;
local TableSort = table.sort;

--- @param frame Frame
function StdUi:MarkAsValid(frame, valid)
	if not frame.SetBackdrop then
		Mixin(frame, BackdropTemplateMixin)
	end
	if not valid then
		frame:SetBackdropBorderColor(1, 0, 0, 1);
		frame.origBackdropBorderColor = { frame:GetBackdropBorderColor() };
	else
		frame:SetBackdropBorderColor(
			self.config.backdrop.border.r,
			self.config.backdrop.border.g,
			self.config.backdrop.border.b,
			self.config.backdrop.border.a
		);
		frame.origBackdropBorderColor = { frame:GetBackdropBorderColor() };
	end
end

StdUi.Util = {
	--- @param self EditBox
	editBoxValidator    = function(self)
		self.value = self:GetText();

		self.stdUi:MarkAsValid(self, true);
		return true;
	end,

	--- @param self EditBox
	moneyBoxValidator   = function(self)
		local text = self:GetText();
		text = text:trim();
		local total, gold, silver, copper, isValid = StdUi.Util.parseMoney(text);

		if not isValid or total == 0 then
			self.stdUi:MarkAsValid(self, false);
			return false;
		end

		self:SetText(StdUi.Util.formatMoney(total));
		self.value = total;

		self.stdUi:MarkAsValid(self, true);
		return true;
	end,

	--- @param self EditBox
	moneyBoxValidatorExC   = function(self)
		local text = self:GetText();
		text = text:trim();
		local total, gold, silver, copper, isValid = StdUi.Util.parseMoney(text);

		if not isValid or total == 0 or (copper and tonumber(copper) > 0) then
			self.stdUi:MarkAsValid(self, false);
			return false;
		end

		self:SetText(StdUi.Util.formatMoney(total, true));
		self.value = total;

		self.stdUi:MarkAsValid(self, true);
		return true;
	end,

	--- @param self EditBox
	numericBoxValidator = function(self)
		local text = self:GetText();
		text = text:trim();

		local value = tonumber(text);

		if value == nil then
			self.stdUi:MarkAsValid(self, false);
			return false;
		end

		if self.maxValue and self.maxValue < value then
			self.stdUi:MarkAsValid(self, false);
			return false;
		end

		if self.minValue and self.minValue > value then
			self.stdUi:MarkAsValid(self, false);
			return false;
		end

		self.value = value;

		self.stdUi:MarkAsValid(self, true);

		return true;
	end,

	--- @param self EditBox
	spellValidator      = function(self)
		local text = self:GetText();
		text = text:trim();
		local name, _, icon, _, _, _, spellId = GetSpellInfo(text);

		if not name then
			self.stdUi:MarkAsValid(self, false);
			return false;
		end

		self:SetText(name);
		self.value = spellId;
		self.icon:SetTexture(icon);

		self.stdUi:MarkAsValid(self, true);
		return true;
	end,

	parseMoney          = function(text)
		text = StdUi.Util.stripColors(text);
		local total = 0;
		local cFound, _, copper = string.find(text, '(%d+)c$');
		if cFound then
			text = string.gsub(text, '(%d+)c$', '');
			text = text:trim();
			total = tonumber(copper);
		end

		local sFound, _, silver = string.find(text, '(%d+)s$');
		if sFound then
			text = string.gsub(text, '(%d+)s$', '');
			text = text:trim();
			total = total + tonumber(silver) * 100;
		end

		local gFound, _, gold = string.find(text, '(%d+)g$');
		if gFound then
			text = string.gsub(text, '(%d+)g$', '');
			text = text:trim();
			total = total + tonumber(gold) * 100 * 100;
		end

		local left = tonumber(text:len());
		local isValid = (text:len() == 0 and total > 0);

		return total, gold, silver, copper, isValid;
	end,

	formatMoney         = function(money, excludeCopper)
		if type(money) ~= 'number' then
			return money;
		end

		money = tonumber(money);
		local goldColor = '|cfffff209';
		local silverColor = '|cff7b7b7a';
		local copperColor = '|cffac7248';

		local gold = floor(money / COPPER_PER_GOLD);
		local silver = floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER);
		local copper = floor(money % COPPER_PER_SILVER);

		local output = '';

		if gold > 0 then
			output = format('%s%i%s ', goldColor, gold, '|rg');
		end

		if gold > 0 or silver > 0 then
			output = format('%s%s%02i%s ', output, silverColor, silver, '|rs');
		end

		if not excludeCopper then
			output = format('%s%s%02i%s ', output, copperColor, copper, '|rc');
		end

		return output:trim();
	end,

	stripColors         = function(text)
		text = string.gsub(text, '|c%x%x%x%x%x%x%x%x', '');
		text = string.gsub(text, '|r', '');
		return text;
	end,

	WrapTextInColor     = function(text, r, g, b, a)
		local hex = string.format(
			'%02x%02x%02x%02x',
			Clamp(a * 255, 0, 255),
			Clamp(r * 255, 0, 255),
			Clamp(g * 255, 0, 255),
			Clamp(b * 255, 0, 255)
		);

		return WrapTextInColorCode(text, hex);
	end,

	tableCount          = function(tab)
		local n = #tab;

		if n == 0 then
			for _ in pairs(tab) do
				n = n + 1;
			end
		end

		return n;
	end,

	tableMerge          = function(default, new)
		local result = {};
		for k, v in pairs(default) do
			if type(v) == 'table' then
				if new[k] then
					result[k] = StdUi.Util.tableMerge(v, new[k]);
				else
					result[k] = v;
				end
			else
				result[k] = new[k] or default[k];
			end
		end

		for k, v in pairs(new) do
			if not result[k] then
				result[k] = v;
			end
		end

		return result;
	end,

	stringSplit         = function(separator, input, limit)
		return { strsplit(separator, input, limit) };
	end,

	--- Ordered pairs

	__genOrderedIndex   = function(t)
		local orderedIndex = {};

		for key in pairs(t) do
			TableInsert(orderedIndex, key)
		end

		TableSort(orderedIndex, function(a, b)
			if not t[a].order or not t[b].order then
				return a < b;
			end

			return t[a].order < t[b].order;
		end);

		return orderedIndex;
	end,

	orderedNext         = function(t, state)
		local key;

		if state == nil then
			-- the first time, generate the index
			t.__orderedIndex = StdUi.Util.__genOrderedIndex(t);
			key = t.__orderedIndex[1];
		else
			-- fetch the next value
			for i = 1, TableGetN(t.__orderedIndex) do
				if t.__orderedIndex[i] == state then
					key = t.__orderedIndex[i + 1];
				end
			end
		end

		if key then
			return key, t[key];
		end

		-- no more value to return, cleanup
		t.__orderedIndex = nil;
		return
	end,

	orderedPairs        = function(t)
		return StdUi.Util.orderedNext, t, nil;
	end,

	roundPrecision      = function(value, precision)
		local multiplier = 10 ^ (precision or 0);
		return math.floor(value * multiplier + 0.5) / multiplier;
	end
};

StdUi:RegisterModule(module, version);
