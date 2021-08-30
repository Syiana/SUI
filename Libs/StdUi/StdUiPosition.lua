--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Position', 2;
if not StdUi:UpgradeNeeded(module, version) then return end;

-- Points
local Center = 'CENTER';

local Top = 'TOP';
local Bottom = 'BOTTOM';
local Left = 'LEFT';
local Right = 'RIGHT';

local TopLeft = 'TOPLEFT';
local TopRight = 'TOPRIGHT';
local BottomLeft = 'BOTTOMLEFT';
local BottomRight = 'BOTTOMRIGHT';

StdUi.Anchors = {
	Center = Center,

	Top = Top,
	Bottom = Bottom,
	Left = Left,
	Right = Right,

	TopLeft = TopLeft,
	TopRight = TopRight,
	BottomLeft = BottomLeft,
	BottomRight = BottomRight,
}

--- Glues object below referenced object
function StdUi:GlueBelow(object, referencedObject, x, y, align)
	if align == Left then
		object:SetPoint(TopLeft, referencedObject, BottomLeft, x, y);
	elseif align == Right then
		object:SetPoint(TopRight, referencedObject, BottomRight, x, y);
	else
		object:SetPoint(Top, referencedObject, Bottom, x, y);
	end
end

--- Glues object above referenced object
function StdUi:GlueAbove(object, referencedObject, x, y, align)
	if align == Left then
		object:SetPoint(BottomLeft, referencedObject, TopLeft, x, y);
	elseif align == Right then
		object:SetPoint(BottomRight, referencedObject, TopRight, x, y);
	else
		object:SetPoint(Bottom, referencedObject, Top, x, y);
	end
end

function StdUi:GlueTop(object, referencedObject, x, y, align)
	if align == Left then
		object:SetPoint(TopLeft, referencedObject, TopLeft, x, y);
	elseif align == Right then
		object:SetPoint(TopRight, referencedObject, TopRight, x, y);
	else
		object:SetPoint(Top, referencedObject, Top, x, y);
	end
end

function StdUi:GlueBottom(object, referencedObject, x, y, align)
	if align == Left then
		object:SetPoint(BottomLeft, referencedObject, BottomLeft, x, y);
	elseif align == Right then
		object:SetPoint(BottomRight, referencedObject, BottomRight, x, y);
	else
		object:SetPoint(Bottom, referencedObject, Bottom, x, y);
	end
end

function StdUi:GlueRight(object, referencedObject, x, y, inside)
	if inside then
		object:SetPoint(Right, referencedObject, Right, x, y);
	else
		object:SetPoint(Left, referencedObject, Right, x, y);
	end
end

function StdUi:GlueLeft(object, referencedObject, x, y, inside)
	if inside then
		object:SetPoint(Left, referencedObject, Left, x, y);
	else
		object:SetPoint(Right, referencedObject, Left, x, y);
	end
end

function StdUi:GlueAfter(object, referencedObject, topX, topY, bottomX, bottomY)
	if topX and topY then
		object:SetPoint(TopLeft, referencedObject, TopRight, topX, topY);
	end
	if bottomX and bottomY then
		object:SetPoint(BottomLeft, referencedObject, BottomRight, bottomX, bottomY);
	end
end

function StdUi:GlueBefore(object, referencedObject, topX, topY, bottomX, bottomY)
	if topX and topY then
		object:SetPoint(TopRight, referencedObject, TopLeft, topX, topY);
	end
	if bottomX and bottomY then
		object:SetPoint(BottomRight, referencedObject, BottomLeft, bottomX, bottomY);
	end
end

-- More advanced positioning functions
function StdUi:GlueAcross(object, referencedObject, topLeftX, topLeftY, bottomRightX, bottomRightY)
	object:SetPoint(TopLeft, referencedObject, TopLeft, topLeftX, topLeftY);
	object:SetPoint(BottomRight, referencedObject, BottomRight, bottomRightX, bottomRightY);
end

-- Glues object to opposite side of anchor
function StdUi:GlueOpposite(object, referencedObject, x, y, anchor)
	if anchor == 'TOP' then 			object:SetPoint('BOTTOM', referencedObject, anchor, x, y);
	elseif anchor == 'BOTTOM' then		object:SetPoint('TOP', referencedObject, anchor, x, y);
	elseif anchor == 'LEFT' then		object:SetPoint('RIGHT', referencedObject, anchor, x, y);
	elseif anchor == 'RIGHT' then		object:SetPoint('LEFT', referencedObject, anchor, x, y);
	elseif anchor == 'TOPLEFT' then		object:SetPoint('BOTTOMRIGHT', referencedObject, anchor, x, y);
	elseif anchor == 'TOPRIGHT' then	object:SetPoint('BOTTOMLEFT', referencedObject, anchor, x, y);
	elseif anchor == 'BOTTOMLEFT' then	object:SetPoint('TOPRIGHT', referencedObject, anchor, x, y);
	elseif anchor == 'BOTTOMRIGHT' then	object:SetPoint('TOPLEFT', referencedObject, anchor, x, y);
	else								object:SetPoint('CENTER', referencedObject, anchor, x, y);
	end
end

StdUi:RegisterModule(module, version);