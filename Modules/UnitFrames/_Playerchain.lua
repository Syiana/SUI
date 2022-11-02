local Module = SUI:NewModule("UnitFrames.Playerchain");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.playerchain
    local style = SUI.db.profile.unitframes.style
    local size = SUI.db.profile.unitframes.size
    if (db == "rare" and style == "Default") then
        local icon = UIParent:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\CustomTextures.blp', true)
        icon:SetTexCoord(324/512, 484/512, 324/512, 482/512)
        icon:SetPoint("CENTER", PlayerFrame.PlayerFrameContainer.PlayerPortraitMask, "CENTER", -3, 0)
        icon:SetVertexColor(0.58, 0.58, 0.58)

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            if (size == 1) then
                icon:SetSize(72, 71)
            elseif (size == 1.1) then
                icon:SetSize(82, 81)
            elseif (size == 1.2) then
                icon:SetSize(92, 91)
            elseif (size ~= 1.3) then
                icon:SetSize(102, 101)
            end
        end)

        -- Set Rest Texture
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop.RestTexture:Hide()
    elseif (db == "rarewinged") then
        local icon = UIParent:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\CustomTextures.blp', true)
        icon:SetTexCoord(126/512, 324/512, 322/512, 484/512)
        icon:SetPoint("CENTER", PlayerFrame.PlayerFrameContainer.PlayerPortraitMask, "CENTER", -12, 0)
        icon:SetVertexColor(0.58, 0.58, 0.58)

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            if (size == 1) then
                icon:SetSize(89, 71)
            elseif (size == 1.1) then
                icon:SetSize(99, 81)
            elseif (size == 1.2) then
                icon:SetSize(109, 91)
            elseif (size ~= 1.3) then
                icon:SetSize(119, 101)
            end
        end)

        -- Set Rest Texture
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop.RestTexture:Hide()
    elseif (db == "elite") then
        local icon = UIParent:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\CustomTextures.blp', true)
        icon:SetTexCoord(324/512, 484/512, 324/512, 482/512)
        icon:SetPoint("CENTER", PlayerFrame.PlayerFrameContainer.PlayerPortraitMask, "CENTER", -3, 0)
        icon:SetVertexColor(0.96, 0.86, 0.49)

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            if (size == 1) then
                icon:SetSize(72, 71)
            elseif (size == 1.1) then
                icon:SetSize(82, 81)
            elseif (size == 1.2) then
                icon:SetSize(92, 91)
            elseif (size ~= 1.3) then
                icon:SetSize(102, 101)
            end
        end)

        -- Set Rest Texture
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop.RestTexture:Hide()
    elseif (db == "elitewinged") then
        local icon = UIParent:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\CustomTextures.blp', true)
        icon:SetSize(99, 81)
        icon:SetTexCoord(126/512, 324/512, 322/512, 484/512)
        icon:SetPoint("CENTER", PlayerFrame.PlayerFrameContainer.PlayerPortraitMask, "CENTER", -12, 0)
        icon:SetVertexColor(0.96, 0.86, 0.49)

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            if (size == 1) then
                icon:SetSize(89, 71)
            elseif (size == 1.1) then
                icon:SetSize(99, 81)
            elseif (size == 1.2) then
                icon:SetSize(109, 91)
            elseif (size ~= 1.3) then
                icon:SetSize(119, 101)
            end
        end)

        -- Set Rest Texture
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop.RestTexture:Hide()
    elseif (db == "dark") then
        local icon = UIParent:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\CustomTextures.blp', true)
        icon:SetTexCoord(324/512, 484/512, 324/512, 482/512)
        icon:SetPoint("CENTER", PlayerFrame.PlayerFrameContainer.PlayerPortraitMask, "CENTER", -3, 0)
        icon:SetVertexColor(0.15, 0.15, 0.15)

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            if (size == 1) then
                icon:SetSize(72, 71)
            elseif (size == 1.1) then
                icon:SetSize(82, 81)
            elseif (size == 1.2) then
                icon:SetSize(92, 91)
            elseif (size ~= 1.3) then
                icon:SetSize(102, 101)
            end
        end)
        
        -- Set Rest Texture
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop.RestTexture:Hide()
    elseif (db == "darkwinged") then
        local icon = UIParent:CreateTexture(nil, 'OVERLAY')
        icon:SetTexture('Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\CustomTextures.blp', true)
        icon:SetTexCoord(126/512, 324/512, 322/512, 484/512)
        icon:SetPoint("CENTER", PlayerFrame.PlayerFrameContainer.PlayerPortraitMask, "CENTER", -12, 0)
        icon:SetVertexColor(0.15, 0.15, 0.15)

        local Size = CreateFrame("Frame")
        Size:RegisterEvent("ADDON_LOADED")
        Size:RegisterEvent("PLAYER_LOGIN")
        Size:RegisterEvent("PLAYER_ENTERING_WORLD")
        Size:RegisterEvent("VARIABLES_LOADED")
        Size:SetScript("OnEvent", function()
            if (size == 1) then
                icon:SetSize(89, 71)
            elseif (size == 1.1) then
                icon:SetSize(99, 81)
            elseif (size == 1.2) then
                icon:SetSize(109, 91)
            elseif (size ~= 1.3) then
                icon:SetSize(119, 101)
            end
        end)

        -- Set Rest Texture
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop.RestTexture:Hide()
    end
end