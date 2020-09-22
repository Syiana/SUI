--[[SUI COMBAT v1.0]]

local CF=CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)

if not SUIDB.MODULES.INCOMBAT == true then return end 

CTT = CreateFrame("Frame")
CTT:SetPoint("Right", TargetFrame, 0)
CTT:SetSize(30, 30)
CTT.t = CTT:CreateTexture(nil, BORDER)
CTT.t:SetAllPoints()
CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CTT:Hide()

local function FrameOnUpdate(self)
    if UnitAffectingCombat("target") then
        self:Show()
    else
        self:Hide()
    end
end
local g = CreateFrame("Frame")
g:SetScript(
    "OnUpdate",
    function(self)
        FrameOnUpdate(CTT)
    end
)

CFT = CreateFrame("Frame")
CFT:SetPoint("Right", FocusFrame, 0)
CFT:SetSize(30, 30)
CFT.t = CFT:CreateTexture(nil, BORDER)
CFT.t:SetAllPoints()
CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CFT:Hide()

local function FrameOnUpdate(self)
    if UnitAffectingCombat("focus") then
        self:Show()
    else
        self:Hide()
    end
end
local g = CreateFrame("Frame")
g:SetScript(
    "OnUpdate",
    function(self)
        FrameOnUpdate(CFT)
    end
)

end)