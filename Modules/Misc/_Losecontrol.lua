local Module = SUI:NewModule("Misc.Losecontrol");

function Module:OnEnable()
    local db = SUI.db.profile.misc.losecontrol
    if (db) then
        LossOfControlFrame:ClearAllPoints()
        LossOfControlFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        select(1, LossOfControlFrame:GetRegions()):SetAlpha(0)
        select(2, LossOfControlFrame:GetRegions()):SetAlpha(0)
        select(3, LossOfControlFrame:GetRegions()):SetAlpha(0)
    end
end
