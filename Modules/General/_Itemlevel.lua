-- credits to https://www.curseforge.com/wow/addons/bettercharacterpanel
local addonName, addon = ...;
local Module = SUI:NewModule("General.Inspect");
function Module:OnEnable()
    local db = SUI.db.profile.general.display.ilvl
    if (db) then
        local oPrint = print;
        local function print(...)
            if(true)then
                local msg = strjoin(" ",tostringall(...));
                oPrint("|cffea00ffS|r|cff00a2ffUI|r: ",msg);
            end
        end

        local buttonLayout = {
            [1]	= "left",
            [2]	= "left",
            [3]	= "left",
            [15] = "left",
            [5]	= "left",
            [9]	= "left",

            [10] = "right",
            [6] = "right",
            [7] = "right",
            [8] = "right",
            [11] = "right",
            [12] = "right",
            [13] = "right",
            [14] = "right",

            [16] = "center",
            [17] = "center",
        };

        local function ColorGradient(perc, ...)
            if perc >= 1 then
                local r, g, b = select(select('#', ...) - 2, ...);
                return r, g, b;
            elseif perc <= 0 then
                local r, g, b = ...;
                return r, g, b;
            end

            local num = select('#', ...) / 3;

            local segment, relperc = math.modf(perc*(num-1));
            local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...);

            return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc;
        end

        local function ColorGradientHP(perc)
            return ColorGradient(perc,1,0,0, 1,1,0, 0,1,0);
        end

        local enchantReplacementTable =
        {
            ["Stamina"] = "Stam",
            ["Intellect"] = "Int",
            ["Agility"] = "Agi",
            ["Strength"] = "Str",

            ["Mastery"] = "Mastery",
            ["Versatility"] = "Vers",
            ["Critical Strike"] = "Crit",
            ["Haste"] = "Haste",
            ["Avoidance"] = "Avoid",

            ["Minor Speed Increase"] = "Speed",
            ["Homebound Speed"] = "Speed & HS Red.",
            ["Plainsrunner's Breeze"] = "Speed",
            ["Graceful Avoidance"] = "Avoid",
            ["Regenerative Leech"] = "Leech",
            ["Watcher's Loam"] = "Stamina",
            ["Rider's Reassurance"] = "Mount Speed",
            ["Accelerated Agility"] = "Speed & Agi",
            ["Reserve of Intellect"] = "Mana & Int",
            ["Sustained Strength"] = "Stam & Str",
            ["Waking Stats"] = "Primary Stats",

            ["Shadowed Belt Clasp"] = "Stam",

            ["Incandescent Essence"] = "Essence",

            -- strip all +, we are starved for space
            ["+"] = "",
        };

        local function ProcessEnchantText(enchantText)
            for seek,replacement in pairs(enchantReplacementTable) do
                enchantText = enchantText:gsub(seek,replacement);
            end
            return enchantText;
        end

        local function CanEnchantSlot(unit, slot)
            -- all classes have something that increases power or survivability on chest/cloak/weapons/rings/wrist/boots/legs
            if(slot == 1 or slot == 5 or slot == 11 or slot == 12 or slot == 15 or slot == 16 or slot == 8 or slot == 9 or slot == 7 or slot == 6)then
                return true;
            end

            -- Offhand filtering smile :)
            if(slot == 17)then
                local offHandItemLink = GetInventoryItemLink(unit,slot);
                if(offHandItemLink)then
                    local itemEquipLoc = select(4,GetItemInfoInstant(offHandItemLink));
                    return itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_SHIELD";
                end
                return false;
            end

            return false;
        end

        local enchantPattern = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.*)');
        local enchantAtlasPattern = "(.*)|A:(.*):20:20|a";
        local function GetItemEnchatAsText(unit,slot)
            local data = C_TooltipInfo.GetInventoryItem(unit,slot);
            for _,line in ipairs(data.lines) do
                local text = line.leftText;
                local enchantText = string.match(text,enchantPattern);
                if (enchantText)then
                    -- DF adds an additional smol icon we store in atlas
                    local atlas = nil
                    if string.find(enchantText, "|A:") then
                        enchantText, atlas = string.match(enchantText, enchantAtlasPattern)
                    end

                    return atlas, ProcessEnchantText(enchantText)
                end
            end

            return nil, nil;
        end

        local function GetSocketTextures(unit,slot)
            local data = C_TooltipInfo.GetInventoryItem(unit,slot);
            local textures = {};
            for i,line in ipairs(data.lines) do
                TooltipUtil.SurfaceArgs(line);
                if line.gemIcon then
                    table.insert(textures, line.gemIcon);
                elseif line.socketType then
                    table.insert(textures, string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType));
                end
            end

            return textures;
        end

        local function AnchorTextureLeftOfParent(parent,textures)
            textures[1]:SetPoint("RIGHT",parent,"LEFT",-3,1);
            for i=2,4 do
                textures[i]:SetPoint("RIGHT",textures[i - 1],"LEFT",-2,0);
            end
        end

        local function AnchorTextureRightOfParent(parent,textures)
            textures[1]:SetPoint("LEFT",parent,"RIGHT",3,1);
            for i=2,4 do
                textures[i]:SetPoint("LEFT",textures[i - 1],"RIGHT",2,0);
            end
        end

        local function CreateAdditionalDisplayForButton(button)
            local parent = button:GetParent();
            local additionalFrame = CreateFrame("frame",nil,parent);
            additionalFrame:SetWidth(100);

            additionalFrame.ilvlDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline");

            additionalFrame.enchantDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline");
            additionalFrame.enchantDisplay:SetTextColor(0,1,0,1);

            additionalFrame.durabilityDisplay = CreateFrame("StatusBar", nil, additionalFrame);
            additionalFrame.durabilityDisplay:SetMinMaxValues(0,1);
            additionalFrame.durabilityDisplay:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
            additionalFrame.durabilityDisplay:GetStatusBarTexture():SetHorizTile(false);
            additionalFrame.durabilityDisplay:GetStatusBarTexture():SetVertTile(false);
            additionalFrame.durabilityDisplay:SetHeight(40);
            additionalFrame.durabilityDisplay:SetWidth(2.3);
            additionalFrame.durabilityDisplay:SetOrientation("VERTICAL");

            additionalFrame.socketDisplay = {};

            for i=1,4 do
                additionalFrame.socketDisplay[i] = additionalFrame:CreateTexture();
                additionalFrame.socketDisplay[i]:SetWidth(14);
                additionalFrame.socketDisplay[i]:SetHeight(14);
            end

            return additionalFrame;
        end

        local function positonLeft(button)
            local additionalFrame = button.BCPDisplay;

            additionalFrame:SetPoint("TOPLEFT",button,"TOPRIGHT");
            additionalFrame:SetPoint("BOTTOMLEFT",button,"BOTTOMRIGHT");

            additionalFrame.ilvlDisplay:SetPoint("BOTTOMLEFT",additionalFrame,"BOTTOMLEFT",10,2);
            additionalFrame.enchantDisplay:SetPoint("TOPLEFT",additionalFrame,"TOPLEFT",10,-7);

            additionalFrame.durabilityDisplay:SetPoint("TOPLEFT",button,"TOPLEFT",-6,0);
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT",button,"BOTTOMLEFT",-6,0);

            AnchorTextureRightOfParent(additionalFrame.ilvlDisplay,additionalFrame.socketDisplay);
        end

        local function positonRight(button)
            local additionalFrame = button.BCPDisplay;

            additionalFrame:SetPoint("TOPRIGHT",button,"TOPLEFT");
            additionalFrame:SetPoint("BOTTOMRIGHT",button,"BOTTOMLEFT");

            additionalFrame.ilvlDisplay:SetPoint("BOTTOMRIGHT",additionalFrame,"BOTTOMRIGHT",-10,2);
            additionalFrame.enchantDisplay:SetPoint("TOPRIGHT",additionalFrame,"TOPRIGHT",-10,-7);

            additionalFrame.durabilityDisplay:SetWidth(1.2);
            additionalFrame.durabilityDisplay:SetPoint("TOPRIGHT",button,"TOPRIGHT",4,0);
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",4,0);

            AnchorTextureLeftOfParent(additionalFrame.ilvlDisplay,additionalFrame.socketDisplay);
        end

        local function positonCenter(button)
            local additionalFrame = button.BCPDisplay;

            additionalFrame:SetPoint("BOTTOMLEFT",button,"BOTTOMLEFT",-100,0);
            additionalFrame:SetPoint("TOPRIGHT",button,"TOPRIGHT",0,-100);

            additionalFrame.durabilityDisplay:SetHeight(2);
            additionalFrame.durabilityDisplay:SetWidth(40);
            additionalFrame.durabilityDisplay:SetOrientation("HORIZONTAL");
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT",button,"BOTTOMLEFT",0,-2);
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,-2);

            additionalFrame.ilvlDisplay:SetPoint("BOTTOM",button,"TOP",0,7);

        --left center
            if(button:GetID() == 16)then
                additionalFrame.enchantDisplay:SetPoint("BOTTOMRIGHT",button,"BOTTOMLEFT",-5,0);

                AnchorTextureLeftOfParent(additionalFrame.ilvlDisplay,additionalFrame.socketDisplay);
            else
                additionalFrame.enchantDisplay:SetPoint("BOTTOMLEFT",button,"BOTTOMRIGHT",5,0);

                AnchorTextureRightOfParent(additionalFrame.ilvlDisplay,additionalFrame.socketDisplay);
            end
        end

        local function AnchorAdditionalDisplay(button)
            local layout = buttonLayout[button:GetID()];
            if(layout == "left")then
                positonLeft(button);
            elseif(layout == "right")then
                positonRight(button);
            elseif(layout == "center")then
                positonCenter(button);
            end
        end

        local function UpdateAdditionalDisplay(button,unit)
            local additionalFrame = button.BCPDisplay;
            local slot = button:GetID();
            local itemLink = GetInventoryItemLink(unit,slot);

            additionalFrame.lastGUID = UnitGUID(unit);

            if(not additionalFrame.prevItemLink or itemLink ~= additionalFrame.prevItemLink)then
                local itemiLvlText = "";
                if(itemLink)then
                    local ilvl = GetDetailedItemLevelInfo(itemLink);
                    local quality = GetInventoryItemQuality(unit, slot);
                    if(quality)then
                        local hex = select(4,GetItemQualityColor(quality));
                        itemiLvlText = "|c"..hex..ilvl.."|r";
                    else
                        itemiLvlText = ilvl;
                    end
                end
                additionalFrame.ilvlDisplay:SetText(itemiLvlText);

                local atlas, enchantText
                if itemLink then
                    atlas, enchantText = GetItemEnchatAsText(unit,slot);
                end
                local canEnchant = CanEnchantSlot(unit, slot);

                if(not enchantText)then
                    local shouldDisplayEchantMissingText = canEnchant and IsLevelAtEffectiveMaxLevel(UnitLevel(unit));
                    additionalFrame.enchantDisplay:SetText(shouldDisplayEchantMissingText and "|cffff0000No Enchant|r" or "");
                else
                    enchantText = string.sub(enchantText,0,26)
                    local enchantQuality = ""
                    if atlas then
                        enchantQuality = "|A:" .. atlas .. ":12:12|a"
                        -- color enchant text as green/blue/epic based on quality
                        if atlas == "Professions-ChatIcon-Quality-Tier3" then
                            enchantText = "|cffa335ee" .. enchantText .. "|r"
                        elseif atlas == "Professions-ChatIcon-Quality-Tier2" then
                            enchantText = "|cff0070dd" .. enchantText .. "|r"
                        else
                            enchantText = "|cff1eff00" .. enchantText .. "|r"
                        end
                    end

                    -- for symmetry, put quality on the left of offhand
                    if slot == 17 then
                        additionalFrame.enchantDisplay:SetText(enchantQuality .. enchantText)
                    else
                        additionalFrame.enchantDisplay:SetText("|cff1eff00" .. enchantText .. "|r" .. enchantQuality);
                    end
                end

                local textures = itemLink and GetSocketTextures(unit,slot) or {};
                for i=1,4 do
                    if(#textures >= i)then
                        additionalFrame.socketDisplay[i]:SetTexture(textures[i]);
                        additionalFrame.socketDisplay[i]:Show();
                    else
                        additionalFrame.socketDisplay[i]:Hide();
                    end
                end

                additionalFrame.prevItemLink = itemLink;
            end

            local currentDurablity, maxDurability = GetInventoryItemDurability(slot);
            local percDurability = currentDurablity and currentDurablity/maxDurability;

            if(not additionalFrame.prevDurability or additionalFrame.prevDurability ~= percDurability)then
                if(UnitIsUnit("player",unit) and percDurability and percDurability < 1)then
                    additionalFrame.durabilityDisplay:Show();
                    additionalFrame.durabilityDisplay:SetValue(percDurability);
                    additionalFrame.durabilityDisplay:SetStatusBarColor(ColorGradientHP(percDurability));
                else
                    additionalFrame.durabilityDisplay:Hide();
                end
                additionalFrame.prevDurability = percDurability;
            end
        end

        local function CreateInspectIlvlDisplay()
            local parent = InspectPaperDollItemsFrame;
            if(not parent.ilvlDisplay)then
                parent.ilvlDisplay = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline22");
                parent.ilvlDisplay:SetPoint("TOPRIGHT",parent,"TOPRIGHT",0,-20);
                parent.ilvlDisplay:SetPoint("BOTTOMLEFT",parent,"TOPRIGHT",-80,-67);
            end
        end

        local function UpdateInspectIlvlDisplay(unit)
            local ilvl = C_PaperDollInfo.GetInspectItemLevel(unit);
            local color;
            if (ilvl < 436) then
                color = "fafafa";
            elseif (ilvl < 450) then
                color = "1eff00";
            elseif (ilvl < 475) then
                color = "0070dd";
            elseif (ilvl < 485) then
                color = "a335ee";
            else
                color = "ff8000";
            end

            local parent = InspectPaperDollItemsFrame;
            parent.ilvlDisplay:SetText(string.format("|cff%s%d|r",color,ilvl));
        end

        hooksecurefunc("PaperDollItemSlotButton_Update",function(button)
            if(not buttonLayout[button:GetID()])then return; end

            if(not button.BCPDisplay)then
                button.BCPDisplay = CreateAdditionalDisplayForButton(button);
                AnchorAdditionalDisplay(button);
            end

            -- Everything indicates items are fully loaded. BUT in some rare cases socket information is not loaded
            -- There is no event that fires when item actually loads fully.... So frame later it is..... I hate it.....
            RunNextFrame(function() UpdateAdditionalDisplay(button,"player"); end);
        end);

        function addon:ADDON_LOADED(addonName)
            if(addonName == "Blizzard_InspectUI")then

                local talentButton = InspectPaperDollItemsFrame.InspectTalents;

                talentButton:SetSize(72,32);

                talentButton.Left:SetTexture(nil);
                talentButton.Left:SetTexCoord(0,1,0,1);
                talentButton.Left:ClearAllPoints();
                talentButton.Left:SetPoint("TOPLEFT");
                talentButton.Left:SetAtlas("uiframe-tab-left",true);
                talentButton.Left:SetHeight(36);

                talentButton.Right:SetTexture(nil);
                talentButton.Right:SetTexCoord(0,1,0,1);
                talentButton.Right:ClearAllPoints();
                talentButton.Right:SetPoint("TOPRIGHT",6);
                talentButton.Right:SetAtlas("uiframe-tab-right",true);
                talentButton.Right:SetHeight(36);

                talentButton.Middle:SetTexture(nil);
                talentButton.Middle:SetTexCoord(0,1,0,1);
                talentButton.Middle:ClearAllPoints();
                talentButton.Middle:SetPoint("LEFT",talentButton.Left,"RIGHT");
                talentButton.Middle:SetPoint("RIGHT",talentButton.Right,"LEFT");
                talentButton.Middle:SetAtlas("_uiframe-tab-center",true);
                talentButton.Middle:SetHeight(36);

                talentButton.LeftHighlight = talentButton:CreateTexture();
                talentButton.LeftHighlight:SetAtlas("uiframe-tab-left",true);
                talentButton.LeftHighlight:SetAlpha(0.4);
                talentButton.LeftHighlight:SetBlendMode("ADD");
                talentButton.LeftHighlight:SetPoint("TOPLEFT");
                talentButton.LeftHighlight:Hide();

                talentButton.RightHighlight = talentButton:CreateTexture();
                talentButton.RightHighlight:SetAtlas("uiframe-tab-right",true);
                talentButton.RightHighlight:SetAlpha(0.4);
                talentButton.RightHighlight:SetBlendMode("ADD");
                talentButton.RightHighlight:SetPoint("TOPRIGHT",6);
                talentButton.RightHighlight:Hide();

                talentButton.MiddleHighlight = talentButton:CreateTexture();
                talentButton.MiddleHighlight:SetAtlas("_uiframe-tab-center",true);
                talentButton.MiddleHighlight:SetAlpha(0.4);
                talentButton.MiddleHighlight:SetBlendMode("ADD");
                talentButton.MiddleHighlight:SetPoint("LEFT",talentButton.Left,"RIGHT");
                talentButton.MiddleHighlight:SetPoint("RIGHT",talentButton.Right,"LEFT");
                talentButton.MiddleHighlight:Hide();

                talentButton:SetNormalFontObject(GameFontNormalSmall);
                talentButton:SetHighlightFontObject(GameFontHighlightSmall);
                talentButton:ClearHighlightTexture();
                talentButton.Text:ClearAllPoints();
                talentButton.Text:SetPoint("CENTER",0,2);
                talentButton.Text:SetHeight(10);

                talentButton:HookScript("OnEnter",function(self)
                    for _,v in ipairs({"MiddleHighlight","LeftHighlight","RightHighlight"}) do
                        self[v]:Show();
                    end
                end);

                talentButton:HookScript("OnLeave",function(self)
                    for _,v in ipairs({"MiddleHighlight","LeftHighlight","RightHighlight"}) do
                        self[v]:Hide();
                    end
                end);

                talentButton:SetScript("OnMouseDown",nil);
                talentButton:SetScript("OnMouseUp",nil);
                talentButton:SetScript("OnShow",nil);
                talentButton:SetScript("OnEnable",nil);
                talentButton:SetScript("OnDisable",nil);

                talentButton:ClearAllPoints();
                talentButton:SetPoint("LEFT",InspectFrameTab3,"RIGHT",3,0);

                hooksecurefunc("InspectPaperDollItemSlotButton_Update",function(button)
                    if(not button.BCPDisplay)then
                        button.BCPDisplay = CreateAdditionalDisplayForButton(button);
                        AnchorAdditionalDisplay(button);
                    end
                    RunNextFrame(function()	UpdateAdditionalDisplay(button,InspectFrame.unit); end);
                end);

                hooksecurefunc("InspectPaperDollFrame_SetLevel",function()
                    if(not InspectFrame.unit)then return; end
                    CreateInspectIlvlDisplay();
                    UpdateInspectIlvlDisplay(InspectFrame.unit);
                end);
            end
        end

        local characterSlots = {
            "CharacterHeadSlot",
            "CharacterNeckSlot",
            "CharacterShoulderSlot",
            "CharacterChestSlot",
            "CharacterWaistSlot",
            "CharacterLegsSlot",
            "CharacterFeetSlot",
            "CharacterWristSlot",
            "CharacterHandsSlot",
            "CharacterFinger0Slot",
            "CharacterFinger1Slot",
            "CharacterTrinket0Slot",
            "CharacterTrinket1Slot",
            "CharacterBackSlot",
            "CharacterMainHandSlot",
            "CharacterSecondaryHandSlot",
        };

        local function updateAllCharacterSlots()
            for _,slot in ipairs(characterSlots) do
                local button = _G[slot];
                if(button)then
                    UpdateAdditionalDisplay(button,"player");
                end
            end
        end

        local lastUpdate = 0;
        function addon:SOCKET_INFO_UPDATE()
            if(CharacterFrame:IsShown())then
                local time = GetTime();
                if(time ~= lastUpdate)then
                    updateAllCharacterSlots();
                    lastUpdate = time;
                end
            end
        end

        -- fired when enchants are applied
        function addon:UNIT_INVENTORY_CHANGED(unit)
            if(unit == "player")then
                addon:SOCKET_INFO_UPDATE()
            end
        end

        local eventListener = CreateFrame("frame");
        eventListener:SetScript("OnEvent",function (self,event,...)
            addon[event](addon,...);
        end);
        eventListener:RegisterEvent("ADDON_LOADED");
        eventListener:RegisterEvent("SOCKET_INFO_UPDATE");
        eventListener:RegisterEvent("UNIT_INVENTORY_CHANGED");
    end
end
