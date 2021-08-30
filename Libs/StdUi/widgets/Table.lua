--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Table', 2;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

local TableInsert = tinsert;
local StringLength = strlen;

----------------------------------------------------
--- Table
----------------------------------------------------

--- Draws table in a panel according to data, example:
--- local columns = {
---        {header = 'Name', index = 'name', width = 20, align = 'RIGHT'},
---        {header = 'Price', index = 'price', width = 60},
--- };
--- local data {
---        {name = 'Item one', price = 12.22},
---        {name = 'Item two', price = 11.11},
---        {name = 'Item three', price = 10.12},
--- }

local TableMethods = {
	SetColumns = function(self, columns)
		self.columns = columns;
	end,

	SetData = function(self, data)
		self.tableData = data;
	end,

	AddRow = function(self, row)
		if not self.tableData then
			self.tableData = {};
		end

		TableInsert(self.tableData, row);
	end,

	DrawHeaders = function(self)
		if not self.headers then
			self.headers = {};
		end

		local marginLeft = 0;
		for i = 1, #self.columns do
			local col = self.columns[i];

			if col.header and StringLength(col.header) > 0 then
				if not self.headers[i] then
					self.headers[i] = {
						text = self.stdUi:FontString(self, ''),
					};
				end

				local column = self.headers[i];

				column.text:SetText(col.header);
				column.text:SetWidth(col.width);
				column.text:SetHeight(self.rowHeight);
				column.text:ClearAllPoints();
				if col.align then
					column.text:SetJustifyH(col.align);
				end

				self.stdUi:GlueTop(column.text, self, marginLeft, 0, 'LEFT');
				marginLeft = marginLeft + col.width;

				column.index = col.index
				column.width = col.width
			end
		end
	end,

	DrawData = function(self)
		if not self.rows then
			self.rows = {};
		end

		local marginTop = -self.rowHeight;
		for y = 1, #self.tableData do
			local row = self.tableData[y];

			local marginLeft = 0;
			for x = 1, #self.columns do
				local col = self.columns[x];

				if not self.rows[y] then
					self.rows[y] = {};
				end

				if not self.rows[y][x] then
					self.rows[y][x] = {
						text = self.stdUi:FontString(self, '');
					};
				end

				local cell = self.rows[y][x];

				cell.text:SetText(row[col.index]);
				cell.text:SetWidth(col.width);
				cell.text:SetHeight(self.rowHeight);
				cell.text:ClearAllPoints();
				if col.align then
					cell.text:SetJustifyH(col.align);
				end

				self.stdUi:GlueTop(cell.text, self, marginLeft, marginTop, 'LEFT');
				marginLeft = marginLeft + col.width;
			end

			marginTop = marginTop - self.rowHeight;
		end
	end,

	DrawTable = function(self)
		self:DrawHeaders();
		self:DrawData();
	end
};

function StdUi:Table(parent, width, height, rowHeight, columns, data)
	local panel = self:Panel(parent, width, height);
	panel.stdUi = self;
	panel.rowHeight = rowHeight;

	for k, v in pairs(TableMethods) do
		panel[k] = v;
	end

	panel:SetColumns(columns);
	panel:SetData(data);
	panel:DrawTable();

	return panel;
end

StdUi:RegisterModule(module, version);