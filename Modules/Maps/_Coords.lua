local Module = SUI:NewModule("Maps.Coords");

function Module:OnEnable()
	local db = SUI.db.profile.maps.coords
	if (db) then
		local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
		coords:SetFrameLevel(WorldMapFrame.BorderFrame:GetFrameLevel() + 2)
		coords:SetFrameStrata(WorldMapFrame.BorderFrame:GetFrameStrata())
		coords.PlayerText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		coords.PlayerText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer, "BOTTOM", 5, 20)
		coords.PlayerText:SetJustifyH("LEFT")
		coords.PlayerText:SetText(UnitName("player") .. ": 0,0")

		coords.MouseText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		coords.MouseText:SetJustifyH("LEFT")
		coords.MouseText:SetPoint("BOTTOMLEFT", coords.PlayerText, "TOPLEFT", 0, 5)
		coords.MouseText:SetText(": 0,0")

		local int = 0
		WorldMapFrame:HookScript("OnUpdate", function(self)
			int = int + 1
			if int >= 3 then
				local UnitMap = C_Map.GetBestMapForUnit("player")
				local x, y = 0, 0

				if UnitMap then
					local GetPlayerMapPosition = C_Map.GetPlayerMapPosition(UnitMap, "player")
					if GetPlayerMapPosition then
						x, y = GetPlayerMapPosition:GetXY()
					end
				end

				x = math.floor(100 * x)
				y = math.floor(100 * y)
				if x ~= 0 and y ~= 0 then
					coords.PlayerText:SetText(UnitName("player") .. ": " .. x .. "," .. y)
				else
					coords.PlayerText:SetText(UnitName("player") .. ": " .. "|cffff0000" .. "|r")
				end

				local scale = WorldMapFrame.ScrollContainer:GetEffectiveScale()
				local width = WorldMapFrame.ScrollContainer:GetWidth()
				local height = WorldMapFrame.ScrollContainer:GetHeight()
				local centerX, centerY = WorldMapFrame.ScrollContainer:GetCenter()
				local x, y = GetCursorPosition()
				local adjustedX = (x / scale - (centerX - (width / 2))) / width
				local adjustedY = (centerY + (height / 2) - y / scale) / height

				if adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
					adjustedX = math.floor(100 * adjustedX)
					adjustedY = math.floor(100 * adjustedY)
					coords.MouseText:SetText("Mouse: " .. adjustedX .. "," .. adjustedY)
				else
					coords.MouseText:SetText("|cffff0000" .. "|r")
				end
				int = 0
			end
		end)
	end
end
