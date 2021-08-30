--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Grid', 4;
if not StdUi:UpgradeNeeded(module, version) then return end;

--- Creates frame list that reuses frames and is based on array data
--- @param parent Frame
--- @param create function
--- @param update function
--- @param data table
--- @param padding number
--- @param oX number
--- @param oY number
--- @param limitFn function
function StdUi:ObjectList(parent, itemsTable, create, update, data, padding, oX, oY, limitFn)
	local this = self;
	oX = oX or 1;
	oY = oY or -1;
	padding = padding or 0;

	if not itemsTable then
		itemsTable = {};
	end

	for i = 1, #itemsTable do
		itemsTable[i]:Hide();
	end

	local totalHeight = -oY;

	local i = 1;
	for key, value in pairs(data) do
		local itemFrame = itemsTable[i];

		if not itemFrame then
			if type(create) == 'string' then
				-- create a widget and anchor it to
				itemsTable[i] = this[create](this, parent);
			else
				itemsTable[i] = create(parent, value, i, key);
			end
			itemFrame = itemsTable[i];
		end

		-- If you create simple widget you need to handle anchoring yourself
		update(parent, itemFrame, value, i, key);
		itemFrame:Show();

		totalHeight = totalHeight + itemFrame:GetHeight();
		if i == 1 then
			-- glue first item to offset
			this:GlueTop(itemFrame, parent, oX, oY, 'LEFT');
		else
			-- glue next items to previous
			this:GlueBelow(itemFrame, itemsTable[i - 1], 0, -padding);
			totalHeight = totalHeight + padding;
		end

		if limitFn and limitFn(i, totalHeight, itemFrame:GetHeight()) then
			break;
		end

		i = i + 1;
	end

	return itemsTable, totalHeight;
end

--- Creates frame list that reuses frames and is based on array data
--- @param parent Frame
--- @param create function
--- @param update function
--- @param data table
--- @param paddingX number
--- @param paddingY number
--- @param oX number
--- @param oY number
function StdUi:ObjectGrid(parent, itemsMatrix, create, update, data, paddingX, paddingY, oX, oY)
	oX = oX or 1;
	oY = oY or -1;
	paddingX = paddingX or 0;
	paddingY = paddingY or 0;

	if not itemsMatrix then
		itemsMatrix = {};
	end

	for y = 1, #itemsMatrix do
		for x = 1, #itemsMatrix[y] do
			itemsMatrix[y][x]:Hide();
		end
	end

	for rowI = 1, #data do
		local row = data[rowI];

		for colI = 1, #row do
			if not itemsMatrix[rowI] then
				-- whole row does not exist yet
				itemsMatrix[rowI] = {};
			end

			local itemFrame = itemsMatrix[rowI][colI];

			if not itemFrame then
				if type(create) == 'string' then
					-- create a widget and set parent it to
					itemFrame = self[create](self, parent);
				else
					itemFrame = create(parent, data[rowI][colI], rowI, colI);
				end
				itemsMatrix[rowI][colI] = itemFrame;
			end

			-- If you create simple widget you need to handle anchoring yourself
			update(parent, itemFrame, data[rowI][colI], rowI, colI);
			itemFrame:Show();

			if rowI == 1 and colI == 1 then
				-- glue first item to offset
				self:GlueTop(itemFrame, parent, oX, oY, 'LEFT');
			else
				if colI == 1 then
					-- glue first item in column to previous row
					self:GlueBelow(itemFrame, itemsMatrix[rowI - 1][colI], 0, -paddingY, 'LEFT');
				else
					-- glue next column to previous column
					self:GlueRight(itemFrame, itemsMatrix[rowI][colI - 1], paddingX, 0);
				end
			end
		end
	end
end

StdUi:RegisterModule(module, version);