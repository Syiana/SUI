--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);

if not StdUi then
	return
end

local module, version = 'Layout', 3;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

local TableInsert = tinsert;
local TableRemove = tremove;
local pairs = pairs;
local MathMax = math.max;
local MathFloor = math.floor;

local defaultLayoutConfig = {
	gutter  = 10,
	columns = 12,
	padding = {
		top    = 0,
		right  = 10,
		left   = 10,
		bottom = 10,
	}
};

local defaultRowConfig = {
	margin = {
		top    = 0,
		right  = 0,
		bottom = 15,
		left   = 0
	}
};

local defaultElementConfig = {
	margin = {
		top    = 0,
		right  = 0,
		bottom = 0,
		left   = 0
	}
};

local EasyLayoutRow = {
	AddElement      = function(self, frame, config)
		if not frame.layoutConfig then
			frame.layoutConfig = StdUi.Util.tableMerge(defaultElementConfig, config or {});
		elseif config then
			frame.layoutConfig = StdUi.Util.tableMerge(frame.layoutConfig, config or {});
		end

		TableInsert(self.elements, frame);
	end,

	AddElements     = function(self, ...)
		local r = { ... };
		local cfg = TableRemove(r, #r);

		if cfg.column == 'even' then
			cfg.column = MathFloor(self.parent.layout.columns / #r);
		end

		for i = 1, #r do
			self:AddElement(r[i], StdUi.Util.tableMerge(defaultElementConfig, cfg));
		end
	end,

	GetColumnsTaken = function(self)
		local columnsTaken = 0;
		local l = self.parent.layout;

		for i = 1, #self.elements do
			local lc = self.elements[i].layoutConfig;
			local col = lc.column or l.columns;
			columnsTaken = columnsTaken + col;
		end

		return columnsTaken;
	end,

	DrawRow = function(self, parentWidth, yOffset)
		yOffset = yOffset or 0;
		local l = self.parent.layout;
		local g = l.gutter;

		local rowMargin = self.config.margin;
		local totalHeight = 0;
		local columnsTaken = 0;
		local x = g + l.padding.left + rowMargin.left;

		-- if row has margins, cut down available width
		parentWidth = parentWidth - rowMargin.left - rowMargin.right;

		for i = 1, #self.elements do
			local frame = self.elements[i];

			frame:ClearAllPoints();

			-- Frame layout config
			local lc = frame.layoutConfig;
			local m = lc.margin;

			-- take full size
			if lc.fullSize then
				StdUi:GlueAcross(
					frame,
					self.parent,
					l.padding.left,
					-l.padding.top,
					-l.padding.right,
					l.padding.bottom
				);

				if frame.DoLayout then
					frame:DoLayout();
				end

				totalHeight = MathMax(totalHeight, frame:GetHeight() + m.bottom + m.top + rowMargin.top + rowMargin.bottom);
				return totalHeight;
			end

			local col = lc.column or l.columns;
			local w = (parentWidth / (l.columns / col)) - 2 * g;

			frame:SetWidth(w);

			if columnsTaken + col > self.parent.layout.columns then
				print('Element will not fit row capacity: ' .. l.columns);
				return totalHeight;
			end

			-- move it down by rowMargin and element margin
			frame:SetPoint('TOPLEFT', self.parent, 'TOPLEFT', x, yOffset - m.top - rowMargin.top);

			if lc.fullHeight then
				frame:SetPoint('BOTTOMLEFT', self.parent, 'BOTTOMLEFT', x, m.bottom + rowMargin.bottom);
			end

			--each element takes 1 gutter plus column * colWidth, while gutter is inclusive
			x = x + w + 2 * g; -- double the gutter because width subtracts gutter

			-- if that frame is container itself, do layout for it too
			if frame.DoLayout then
				frame:DoLayout();
			end

			totalHeight = MathMax(totalHeight, frame:GetHeight() + m.bottom + m.top + rowMargin.top + rowMargin.bottom);
			columnsTaken = columnsTaken + col;
		end

		return totalHeight;
	end
}

---EasyLayoutRow
---@param parent Frame
---@param config table
function StdUi:EasyLayoutRow(parent, config)
	---@class EasyLayoutRow
	local row = {
		parent   = parent,
		config   = self.Util.tableMerge(defaultRowConfig, config or {}),
		elements = {}
	};

	for k, v in pairs(EasyLayoutRow) do
		row[k] = v;
	end

	return row;
end

local EasyLayout = {
	---@return EasyLayoutRow
	AddRow = function(self, config)
		if not self.rows then
			self.rows = {};
		end

		local row = self.stdUi:EasyLayoutRow(self, config);
		TableInsert(self.rows, row);

		return row;
	end,

	DoLayout = function(self)
		local l = self.layout;
		local width = self:GetWidth() - l.padding.left - l.padding.right;

		local y = -l.padding.top;
		for i = 1, #self.rows do
			local row = self.rows[i];
			y = y - row:DrawRow(width, y);
		end
	end
};

function StdUi:EasyLayout(parent, config)
	parent.stdUi = self;
	parent.layout = self.Util.tableMerge(defaultLayoutConfig, config or {});

	for k, v in pairs(EasyLayout) do
		parent[k] = v;
	end
end

StdUi:RegisterModule(module, version);