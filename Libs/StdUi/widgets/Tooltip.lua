--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Tooltip', 3;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

StdUi.tooltips = {};
StdUi.frameTooltips = {};

----------------------------------------------------
--- Tooltip
----------------------------------------------------

local TooltipEvents = {
	OnEnter = function(self)
		local tip = self.stdUiTooltip;
		tip:SetOwner(tip.owner or UIParent, tip.anchor or 'ANCHOR_NONE');

		if type(tip.text) == 'string' then
			tip:SetText(tip.text,
				tip.stdUi.config.font.color.r,
				tip.stdUi.config.font.color.g,
				tip.stdUi.config.font.color.b,
				tip.stdUi.config.font.color.a
			);
		elseif type(tip.text) == 'function' then
			tip.text(tip);
		end

		tip:Show();
		tip:ClearAllPoints();
		tip.stdUi:GlueOpposite(tip, tip.owner, 0, 0, tip.anchor);
	end,

	OnLeave = function(self)
		local tip = self.stdUiTooltip;
		tip:Hide();
	end
}

--- Standard blizzard tooltip
---@return GameTooltip
function StdUi:Tooltip(owner, text, tooltipName, anchor, automatic)
	--- @type GameTooltip
	local tip;

	if tooltipName and self.tooltips[tooltipName] then
		tip = self.tooltips[tooltipName];
	else
		tip = CreateFrame('GameTooltip', tooltipName, UIParent, 'GameTooltipTemplate');
		self:ApplyBackdrop(tip, 'panel');
	end

	tip.owner = owner;
	tip.anchor = anchor;
	tip.text = text;
	tip.stdUi = self;
	owner.stdUiTooltip = tip;

	if automatic then
		for k, v in pairs(TooltipEvents) do
			owner:HookScript(k, v);
		end
	end

	return tip;
end

----------------------------------------------------
--- Tooltip
----------------------------------------------------

local FrameTooltipMethods = {
	SetText         = function(self, text, r, g, b)
		if r and g and b then
			text = self.stdUi.Util.WrapTextInColor(text, r, g, b, 1);
		end
		self.text:SetText(text);

		self:RecalculateSize();
	end,

	GetText         = function(self)
		return self.text:GetText();
	end,

	AddLine         = function(self, text, r, g, b)
		local txt = self:GetText();
		if not txt then
			txt = '';
		else
			txt = txt .. '\n'
		end
		if r and g and b then
			text = self.stdUi.Util.WrapTextInColor(text, r, g, b, 1);
		end
		self:SetText(txt .. text);
	end,

	RecalculateSize = function(self)
		self:SetSize(
			self.text:GetWidth() + self.padding * 2,
			self.text:GetHeight() + self.padding * 2
		);
	end
};

local OnShowFrameTooltip = function(self)
	self:RecalculateSize();
	self:ClearAllPoints();
	self.stdUi:GlueOpposite(self, self.owner, 0, 0, self.anchor);
end

local FrameTooltipEvents = {
	OnEnter = function(self)
		self.stdUiTooltip:Show();
	end,

	OnLeave = function(self)
		self.stdUiTooltip:Hide();
	end,
};

function StdUi:FrameTooltip(owner, text, tooltipName, anchor, automatic, manualPosition)
	local tip;

	if tooltipName and self.frameTooltips[tooltipName] then
		tip = self.frameTooltips[tooltipName];
	else
		tip = self:Panel(owner, 10, 10);
		tip.stdUi = self;
		tip:SetFrameStrata('TOOLTIP');
		self:ApplyBackdrop(tip, 'panel');

		tip.padding = self.config.tooltip.padding;

		tip.text = self:FontString(tip, '');
		self:GlueTop(tip.text, tip, tip.padding, -tip.padding, 'LEFT');

		for k, v in pairs(FrameTooltipMethods) do
			tip[k] = v;
		end

		if not manualPosition then
			hooksecurefunc(tip, 'Show', OnShowFrameTooltip);
		end
	end

	tip.owner = owner;
	tip.anchor = anchor;

	owner.stdUiTooltip = tip;

	if type(text) == 'string' then
		tip:SetText(text);
	elseif type(text) == 'function' then
		text(tip);
	end

	if automatic then
		for k, v in pairs(FrameTooltipEvents) do
			owner:HookScript(k, v);
		end
	end

	return tip;
end

StdUi:RegisterModule(module, version);