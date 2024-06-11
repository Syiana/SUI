local Module = SUI:NewModule("Maps.Minimap");

function Module:OnEnable()
    local db = SUI.db.profile.maps
    if (db) then
        if not (db.minimap) then
            MinimapCluster:Hide()
            return
        end
        if not (IsAddOnLoaded("SexyMap")) then
            if (SUI:Color()) then
                for i, v in pairs({
                    MinimapBorder,
                    MiniMapMailBorder,
                    QueueStatusMinimapButtonBorder,
                    select(1, TimeManagerClockButton:GetRegions())
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
            select(2, TimeManagerClockButton:GetRegions()):SetVertexColor(1, 1, 1)

            MinimapZoneText:SetPoint("CENTER", Minimap, 0, 80)
            Minimap:EnableMouseWheel(true)
            Minimap:SetScript("OnMouseWheel", function(self, z)
                local c = Minimap:GetZoom()
                if (z > 0 and c < 5) then
                    Minimap:SetZoom(c + 1)
                elseif (z < 0 and c > 0) then
                    Minimap:SetZoom(c - 1)
                end
            end)

            Minimap:SetScript("OnMouseUp", function(self, btn)
                if btn == "RightButton" then
                    _G.GameTimeFrame:Click()
                elseif btn == "MiddleButton" then
                    _G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
                else
                    _G.Minimap_OnClick(self)
                end
            end)
        end
    end
end
