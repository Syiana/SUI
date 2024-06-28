local Module = SUI:NewModule("Skins.Item");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(ItemTextFrame)
        SUI:Skin(ItemTextScrollFrame)
        ItemTextPageText:HookScript("OnUpdate", function(self)
            select(1, self:GetRegions()):SetVertexColor(.8, .8, .8)
        end)
    end
end
