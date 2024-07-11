local Module = SUI:NewModule("Skins.SpellBook");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(SpellBookFrame)
        SUI:Skin(SpellBookFrameTabButton1)
        SUI:Skin(SpellBookFrameTabButton2)

        for i = 1, MAX_SPELLS do
            local subText = _G["SpellButton".. i .. "SubSpellName"]
            if (subText) then
                subText:SetTextColor(.8, .8, .8)
            end
        end

        for i = 1, GetNumSpellTabs() do
            SUI:Skin(_G["SpellBookSkillLineTab" .. i])
        end

        SpellBookPageText:SetTextColor(.8, .8, .8)
    end
end
