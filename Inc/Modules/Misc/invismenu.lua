local CF=CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)

if not SUIDB.MODULES.INVISBAGS == true then return end

local ignore
MicroButtonAndBagsBar:Hide()

local function setAlpha(b, a)
	if ignore then return end
	ignore = true
	if b:IsMouseOver() then
		b:SetAlpha(1)
	else
		b:SetAlpha(0)
	end
	ignore = nil
end

local function showFoo(self)
    for _, v in ipairs(MICRO_BUTTONS) do
        ignore = true
        _G[v]:SetAlpha(1)
        ignore = nil
    end
end

local function hideFoo(self)
    for _, v in ipairs(MICRO_BUTTONS) do
        ignore = true
        _G[v]:SetAlpha(0)
        ignore = nil
    end
end

for _, v in ipairs(MICRO_BUTTONS) do
    v = _G[v]
    hooksecurefunc(v, "SetAlpha", setAlpha)
    v:HookScript("OnEnter", showFoo)
    v:HookScript("OnLeave", hideFoo)
    v:SetAlpha(0)
end

end)