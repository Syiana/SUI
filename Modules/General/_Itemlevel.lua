-- credits to https://www.curseforge.com/wow/addons/bettercharacterpanel
local addonName, addon = ...;
local Module = SUI:NewModule("General.Inspect");
function Module:OnEnable()
    local db = SUI.db.profile.general.display.ilvl
    if (db) then
        local oPrint = print;
        local function print(...)
            if (true) then
                local msg = strjoin(" ", tostringall(...));
                oPrint("|cff6600ccBetterCharacterPanel|r: " .. GetTime() .. " :", msg);
            end
        end

        local NUM_SOCKET_TEXTURES = 3;

        local buttonLayout =
        {
            [INVSLOT_HEAD] = "left",
            [INVSLOT_NECK] = "left",
            [INVSLOT_SHOULDER] = "left",
            [INVSLOT_BACK] = "left",
            [INVSLOT_CHEST] = "left",
            [INVSLOT_WRIST] = "left",

            [INVSLOT_HAND] = "right",
            [INVSLOT_WAIST] = "right",
            [INVSLOT_LEGS] = "right",
            [INVSLOT_FEET] = "right",
            [INVSLOT_FINGER1] = "right",
            [INVSLOT_FINGER2] = "right",
            [INVSLOT_TRINKET1] = "right",
            [INVSLOT_TRINKET2] = "right",

            [INVSLOT_MAINHAND] = "center",
            [INVSLOT_OFFHAND] = "center",
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

            local segment, relperc = math.modf(perc * (num - 1));
            local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...);

            return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc;
        end

        local function ColorGradientHP(perc)
            return ColorGradient(perc, 1, 0, 0, 1, 1, 0, 0, 1, 0);
        end

        local enchantReplacementTable =
        {
            ["Stamina"] = "Stam",
            ["Intellect"] = "Int",
            ["Agility"] = "Agi",
            ["Strength"] = "Str",
            ["Mastery"] = "Mast",
            ["Versatility"] = "Vers",
            ["Critical Strike"] = "Crit",
            ["Haste"] = "Haste",
            ["Avoidance"] = "Avoid",
            ["Minor Speed Increase"] = "Speed",

            -- Dragonflight Enchants
            ["Homebound Speed"] = "Speed & HS Red.",
            ["Plainsrunner's Breeze"] = "Speed",
            ["Graceful Avoidance"] = "Avoid",
            ["Regenerative Leech"] = "Leech",
            ["Watcher's Loam"] = "Stam",
            ["Rider's Reassurance"] = "Mount Speed",
            ["Accelerated Agility"] = "Speed & Agi",
            ["Reserve of Intellect"] = "Mana & Int",
            ["Sustained Strength"] = "Stam & Str",
            ["Waking Stats"] = "Primary Stat",
            ["Shadowed Belt Clasp"] = "Stamina",
            ["Incandescent Essence"] = "Essence",

            -- TWW Enchants
            ["Cavalry's March"] = "Mount Speed",
            ["Scout's March"] = "Speed",
            ["Defender's March"] = "Stam",
            ["Council's Intellect"] = "Mana & Int",
            ["Stormrider's Agility"] = "Speed & Agi",
            ["Crystalline Radiance"] = "Primary Stat",
            ["Oathsworn's Strength"] = "Stam & Str",
            ["Chant of Armored Avoidance"] = "Avoid",
            ["Chant of Armored Leech"] = "Leech",
            ["Chant of Armored Speed"] = "Speed",
            ["Chant of Winged Grace"] = "Avoid & Falldmg",
            ["Chant of Leeching Fangs"] = "Leech & Reg",
            ["Chant of Burrowing Rapidity"] = "Speed & HS Red.",
            ["Authority of Air"] = "Auth. of Air",
            ["Authority of Fiery Resolve"] = "Fiery Resolve",
            ["Authority of Radiant Power"] = "Radiant Power",
            ["Authority of the Depths"] = "Auth. of Depths",
            ["Authority of Storms"] = "Auth. of Storms",


            -- strip all +, we are starved for space
            ["+"] = "",
        };

        local function ProcessEnchantText(enchantText)
            for seek, replacement in pairs(enchantReplacementTable) do
                enchantText = enchantText:gsub(seek, replacement);
            end
            return enchantText;
        end

        local slotsThatHaveEnchants = {
            [INVSLOT_HEAD] = false,
            [INVSLOT_BACK] = true,
            [INVSLOT_CHEST] = true,
            [INVSLOT_WRIST] = true,
            [INVSLOT_WAIST] = true,
            [INVSLOT_LEGS] = true,
            [INVSLOT_FEET] = true,
            [INVSLOT_FINGER1] = true,
            [INVSLOT_FINGER2] = true,
            [INVSLOT_MAINHAND] = true,
        };

        local function CanEnchantSlot(unit, slot)
            -- all classes have something that increases power or survivability on chest/cloak/weapons/rings/wrist/boots/legs
            if (slotsThatHaveEnchants[slot]) then
                return true;
            end

            -- Offhand filtering smile :)
            if (slot == INVSLOT_OFFHAND) then
                local offHandItemLink = GetInventoryItemLink(unit, slot);
                if (offHandItemLink) then
                    local itemEquipLoc = select(4, GetItemInfoInstant(offHandItemLink));
                    return itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_SHIELD";
                end
                return false;
            end

            return false;
        end

        local enchantPattern = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.*)');
        local enchantAtlasPattern = "(.*)%s*|A:(.*):20:20|a";
        local enchatColoredPatten = "|cn(.*):(.*)|r";
        local function GetItemEnchantAsText(unit, slot)
            local data = C_TooltipInfo.GetInventoryItem(unit, slot);
            for _, line in ipairs(data.lines) do
                local text = line.leftText;
                local enchantText = string.match(text, enchantPattern);
                if (enchantText) then
                    local maybeEnchantText, atlas;
                    local maybeEnchantColor, maybeEnchantTextColored = enchantText:match(enchatColoredPatten);
                    if (maybeEnchantColor) then
                        enchantText = maybeEnchantTextColored;
                    else
                        maybeEnchantText, atlas = enchantText:match(enchantAtlasPattern);
                        enchantText = maybeEnchantText or enchantText;
                    end

                    return atlas, ProcessEnchantText(enchantText)
                end
            end

            return nil, nil;
        end

        local function GetSocketTextures(unit, slot)
            local data = C_TooltipInfo.GetInventoryItem(unit, slot);
            local textures = {};
            for i, line in ipairs(data.lines) do
                TooltipUtil.FindLinesFromData(line);
                if line.gemIcon then
                    table.insert(textures, line.gemIcon);
                elseif line.socketType then
                    table.insert(textures,
                        string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType));
                end
            end

            return textures;
        end

        local function AnchorTextureLeftOfParent(parent, textures)
            textures[1]:SetPoint("RIGHT", parent, "LEFT", -3, 1);
            for i = 2, NUM_SOCKET_TEXTURES do
                textures[i]:SetPoint("RIGHT", textures[i - 1], "LEFT", -2, 0);
            end
        end

        local function AnchorTextureRightOfParent(parent, textures)
            textures[1]:SetPoint("LEFT", parent, "RIGHT", 3, 1);
            for i = 2, NUM_SOCKET_TEXTURES do
                textures[i]:SetPoint("LEFT", textures[i - 1], "RIGHT", 2, 0);
            end
        end

        local function CreateAdditionalDisplayForButton(button)
            local parent = button:GetParent();
            local additionalFrame = CreateFrame("frame", nil, parent);
            additionalFrame:SetWidth(100);

            additionalFrame.ilvlDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline");

            additionalFrame.enchantDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline");
            additionalFrame.enchantDisplay:SetTextColor(0, 1, 0, 1);

            additionalFrame.durabilityDisplay = CreateFrame("StatusBar", nil, additionalFrame);
            additionalFrame.durabilityDisplay:SetMinMaxValues(0, 1);
            additionalFrame.durabilityDisplay:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
            additionalFrame.durabilityDisplay:GetStatusBarTexture():SetHorizTile(false);
            additionalFrame.durabilityDisplay:GetStatusBarTexture():SetVertTile(false);
            additionalFrame.durabilityDisplay:SetHeight(40);
            additionalFrame.durabilityDisplay:SetWidth(2.3);
            additionalFrame.durabilityDisplay:SetOrientation("VERTICAL");

            additionalFrame.socketDisplay = {};

            for i = 1, NUM_SOCKET_TEXTURES do
                additionalFrame.socketDisplay[i] = additionalFrame:CreateTexture();
                additionalFrame.socketDisplay[i]:SetWidth(14);
                additionalFrame.socketDisplay[i]:SetHeight(14);
            end

            return additionalFrame;
        end

        local function positonLeft(button)
            local additionalFrame = button.BCPDisplay;

            additionalFrame:SetPoint("TOPLEFT", button, "TOPRIGHT");
            additionalFrame:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT");

            additionalFrame.ilvlDisplay:SetPoint("BOTTOMLEFT", additionalFrame, "BOTTOMLEFT", 10, 2);
            additionalFrame.enchantDisplay:SetPoint("TOPLEFT", additionalFrame, "TOPLEFT", 10, -7);

            additionalFrame.durabilityDisplay:SetPoint("TOPLEFT", button, "TOPLEFT", -6, 0);
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -6, 0);

            AnchorTextureRightOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay);
        end

        local function positonRight(button)
            local additionalFrame = button.BCPDisplay;

            additionalFrame:SetPoint("TOPRIGHT", button, "TOPLEFT");
            additionalFrame:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT");

            additionalFrame.ilvlDisplay:SetPoint("BOTTOMRIGHT", additionalFrame, "BOTTOMRIGHT", -10, 2);
            additionalFrame.enchantDisplay:SetPoint("TOPRIGHT", additionalFrame, "TOPRIGHT", -10, -7);

            additionalFrame.durabilityDisplay:SetWidth(1.2);
            additionalFrame.durabilityDisplay:SetPoint("TOPRIGHT", button, "TOPRIGHT", 4, 0);
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, 0);

            AnchorTextureLeftOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay);
        end

        local function positonCenter(button)
            local additionalFrame = button.BCPDisplay;

            additionalFrame:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -100, 0);
            additionalFrame:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, -100);

            additionalFrame.durabilityDisplay:SetHeight(2);
            additionalFrame.durabilityDisplay:SetWidth(40);
            additionalFrame.durabilityDisplay:SetOrientation("HORIZONTAL");
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, -2);
            additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -2);

            additionalFrame.ilvlDisplay:SetPoint("BOTTOM", button, "TOP", 0, 7);

            --left center
            if (button:GetID() == 16) then
                additionalFrame.enchantDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 0);

                AnchorTextureLeftOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay);
            else
                additionalFrame.enchantDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 0);

                AnchorTextureRightOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay);
            end
        end

        local function AnchorAdditionalDisplay(button)
            local layout = buttonLayout[button:GetID()];
            if (layout == "left") then
                positonLeft(button);
            elseif (layout == "right") then
                positonRight(button);
            elseif (layout == "center") then
                positonCenter(button);
            end
        end

        local function UpdateAdditionalDisplay(button, unit)
            local additionalFrame = button.BCPDisplay;
            local slot = button:GetID();
            local itemLink = GetInventoryItemLink(unit, slot);

            additionalFrame.lastGUID = UnitGUID(unit);

            if (not additionalFrame.prevItemLink or itemLink ~= additionalFrame.prevItemLink) then
                local itemiLvlText = "";
                if (itemLink) then
                    local ilvl = C_Item.GetDetailedItemLevelInfo(itemLink);
                    local quality = GetInventoryItemQuality(unit, slot);
                    if (quality) then
                        local hex = select(4, C_Item.GetItemQualityColor(quality));
                        itemiLvlText = "|c" .. hex .. ilvl .. "|r";
                    else
                        itemiLvlText = ilvl;
                    end
                end
                additionalFrame.ilvlDisplay:SetText(itemiLvlText);

                local atlas, enchantText
                if itemLink then
                    atlas, enchantText = GetItemEnchantAsText(unit, slot);
                end

                local canEnchant = CanEnchantSlot(unit, slot);

                if (not enchantText) then
                    local shouldDisplayEchantMissingText = canEnchant and IsLevelAtEffectiveMaxLevel(UnitLevel(unit));
                    additionalFrame.enchantDisplay:SetText(shouldDisplayEchantMissingText and "|cffff0000No Enchant|r" or
                    "");
                else
                    enchantText = string.sub(enchantText, 0, 18);
                    local enchantQuality = "";
                    if atlas then
                        enchantQuality = "|A:" .. atlas .. ":12:12|a";
                    end

                    -- for symmetry, put quality on the left of offhand
                    if slot == INVSLOT_OFFHAND then
                        additionalFrame.enchantDisplay:SetText(enchantQuality .. enchantText);
                    else
                        additionalFrame.enchantDisplay:SetText(enchantText .. enchantQuality);
                    end
                end

                local textures = itemLink and GetSocketTextures(unit, slot) or {};
                for i = 1, NUM_SOCKET_TEXTURES do
                    local socketTexture = additionalFrame.socketDisplay[i];
                    if (#textures >= i) then
                        socketTexture:SetTexture(textures[i]);
                        socketTexture:SetVertexColor(1, 1, 1);
                        socketTexture:Show();
                    else
                        if (slot == INVSLOT_NECK or slot == INVSLOT_FINGER1 or slot == INVSLOT_FINGER2) then
                            if i == 3 then return end
                            socketTexture:SetTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic");
                            socketTexture:SetVertexColor(1, 0, 0);
                            socketTexture:Show();
                        else
                            socketTexture:Hide();
                        end
                    end
                end

                additionalFrame.prevItemLink = itemLink;
            end

            local currentDurablity, maxDurability = GetInventoryItemDurability(slot);
            local percDurability = currentDurablity and currentDurablity / maxDurability;

            if (not additionalFrame.prevDurability or additionalFrame.prevDurability ~= percDurability) then
                if (UnitIsUnit("player", unit) and percDurability and percDurability < 1) then
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
            if (not parent.ilvlDisplay) then
                parent.ilvlDisplay = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline22");
                parent.ilvlDisplay:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -20);
                parent.ilvlDisplay:SetPoint("BOTTOMLEFT", parent, "TOPRIGHT", -80, -67);
            end
        end

        local LEGENDARY_ITEM_LEVEL = 483;
        local STEP_ITEM_LEVEL = 17;

        local levelThresholds = {};
        for i = 4, 1, -1 do
            levelThresholds[i] = LEGENDARY_ITEM_LEVEL - (STEP_ITEM_LEVEL * (i - 1));
        end

        local function UpdateInspectIlvlDisplay(unit)
            local ilvl = C_PaperDollInfo.GetInspectItemLevel(unit);
            local color;
            if (ilvl < levelThresholds[4]) then
                color = "fafafa";
            elseif (ilvl < levelThresholds[3]) then
                color = "1eff00";
            elseif (ilvl < levelThresholds[2]) then
                color = "0070dd";
            elseif (ilvl < levelThresholds[1]) then
                color = "a335ee";
            else
                color = "ff8000";
            end

            local parent = InspectPaperDollItemsFrame;
            parent.ilvlDisplay:SetText(string.format("|cff%s%d|r", color, ilvl));
        end

        local updateButton = function(button, unit)
            if (not buttonLayout[button:GetID()]) then return; end

            if (not button.BCPDisplay) then
                button.BCPDisplay = CreateAdditionalDisplayForButton(button);
                AnchorAdditionalDisplay(button);
            end

            UpdateAdditionalDisplay(button, unit);
        end

        hooksecurefunc("PaperDollItemSlotButton_Update", function(button) updateButton(button, "player"); end);

        function addon:ADDON_LOADED(addonName)
            if (addonName == "Blizzard_InspectUI") then
                local talentButton = InspectPaperDollItemsFrame.InspectTalents;

                talentButton:SetSize(72, 32);

                talentButton.Left:SetTexture(nil);
                talentButton.Left:SetTexCoord(0, 1, 0, 1);
                talentButton.Left:ClearAllPoints();
                talentButton.Left:SetPoint("TOPLEFT");
                talentButton.Left:SetAtlas("uiframe-tab-left", true);
                talentButton.Left:SetHeight(36);

                talentButton.Right:SetTexture(nil);
                talentButton.Right:SetTexCoord(0, 1, 0, 1);
                talentButton.Right:ClearAllPoints();
                talentButton.Right:SetPoint("TOPRIGHT", 6);
                talentButton.Right:SetAtlas("uiframe-tab-right", true);
                talentButton.Right:SetHeight(36);

                talentButton.Middle:SetTexture(nil);
                talentButton.Middle:SetTexCoord(0, 1, 0, 1);
                talentButton.Middle:ClearAllPoints();
                talentButton.Middle:SetPoint("LEFT", talentButton.Left, "RIGHT");
                talentButton.Middle:SetPoint("RIGHT", talentButton.Right, "LEFT");
                talentButton.Middle:SetAtlas("_uiframe-tab-center", true);
                talentButton.Middle:SetHeight(36);

                talentButton.LeftHighlight = talentButton:CreateTexture();
                talentButton.LeftHighlight:SetAtlas("uiframe-tab-left", true);
                talentButton.LeftHighlight:SetAlpha(0.4);
                talentButton.LeftHighlight:SetBlendMode("ADD");
                talentButton.LeftHighlight:SetPoint("TOPLEFT");
                talentButton.LeftHighlight:Hide();

                talentButton.RightHighlight = talentButton:CreateTexture();
                talentButton.RightHighlight:SetAtlas("uiframe-tab-right", true);
                talentButton.RightHighlight:SetAlpha(0.4);
                talentButton.RightHighlight:SetBlendMode("ADD");
                talentButton.RightHighlight:SetPoint("TOPRIGHT", 6);
                talentButton.RightHighlight:Hide();

                talentButton.MiddleHighlight = talentButton:CreateTexture();
                talentButton.MiddleHighlight:SetAtlas("_uiframe-tab-center", true);
                talentButton.MiddleHighlight:SetAlpha(0.4);
                talentButton.MiddleHighlight:SetBlendMode("ADD");
                talentButton.MiddleHighlight:SetPoint("LEFT", talentButton.Left, "RIGHT");
                talentButton.MiddleHighlight:SetPoint("RIGHT", talentButton.Right, "LEFT");
                talentButton.MiddleHighlight:Hide();

                talentButton:SetNormalFontObject(GameFontNormalSmall);
                talentButton:SetHighlightFontObject(GameFontHighlightSmall);
                talentButton:ClearHighlightTexture();
                talentButton.Text:ClearAllPoints();
                talentButton.Text:SetPoint("CENTER", 0, 2);
                talentButton.Text:SetHeight(10);

                talentButton:HookScript("OnEnter", function(self)
                    for _, v in ipairs({ "MiddleHighlight", "LeftHighlight", "RightHighlight" }) do
                        self[v]:Show();
                    end
                end);

                talentButton:HookScript("OnLeave", function(self)
                    for _, v in ipairs({ "MiddleHighlight", "LeftHighlight", "RightHighlight" }) do
                        self[v]:Hide();
                    end
                end);

                talentButton:SetScript("OnMouseDown", nil);
                talentButton:SetScript("OnMouseUp", nil);
                talentButton:SetScript("OnShow", nil);
                talentButton:SetScript("OnEnable", nil);
                talentButton:SetScript("OnDisable", nil);

                talentButton:ClearAllPoints();
                talentButton:SetPoint("LEFT", InspectFrameTab3, "RIGHT", 3, 0);

                hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
                    updateButton(button, InspectFrame.unit);
                end);

                hooksecurefunc("InspectPaperDollFrame_SetLevel", function()
                    if (not InspectFrame.unit) then return; end
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
            for _, slot in ipairs(characterSlots) do
                local button = _G[slot];
                if (button) then
                    UpdateAdditionalDisplay(button, "player");
                end
            end
        end

        local lastUpdate = 0;
        function addon:SOCKET_INFO_UPDATE()
            if (CharacterFrame:IsShown()) then
                local time = GetTime();
                if (time ~= lastUpdate) then
                    updateAllCharacterSlots();
                    lastUpdate = time;
                end
            end
        end

        -- fired when enchants are applied
        function addon:UNIT_INVENTORY_CHANGED(unit)
            if (unit == "player") then
                addon:SOCKET_INFO_UPDATE()
            end
        end

        -- cache list
        local gemsWeCareAbout = {
            -- Dragonflight Gems
            192989, -- Increased Primary Stat and Versatility Rank 1
            192990, -- Increased Primary Stat and Versatility Rank 2
            192991, -- Increased Primary Stat and Versatility Rank 3

            192983, -- Increased Primary Stat and Haste Rank 1
            192984, -- Increased Primary Stat and Haste Rank 2
            192985, -- Increased Primary Stat and Haste Rank 3

            192980, -- Increased Primary Stat and Critical Strike Rank 1
            192981, -- Increased Primary Stat and Critical Strike Rank 2
            192982, -- Increased Primary Stat and Critical Strike Rank 3

            192986, -- Increased Primary Stat and Mastery Rank 1
            192987, -- Increased Primary Stat and Mastery Rank 2
            192988, -- Increased Primary Stat and Mastery Rank 3

            192943, -- Increased Haste and Critical Strike
            192944, -- Increased Haste and Critical Strike
            192945, -- Increased Haste and Critical Strike

            192946, -- Increased Haste and Mastery
            192947, -- Increased Haste and Mastery
            192948, -- Increased Haste and Mastery

            192950, -- Increased Haste and Versatility
            192951, -- Increased Haste and Versatility
            192952, -- Increased Haste and Versatility

            192953, -- Increased Haste
            192954, -- Increased Haste
            192955, -- Increased Haste

            192959, -- Increased Mastery and Haste
            192960, -- Increased Mastery and Haste
            192961, -- Increased Mastery and Haste

            192956, -- Increased Mastery and Critical Strike
            192957, -- Increased Mastery and Critical Strike
            192958, -- Increased Mastery and Critical Strike

            192962, -- Increased Mastery and Versatility
            192963, -- Increased Mastery and Versatility
            192964, -- Increased Mastery and Versatility

            192965, -- Increased Mastery
            192966, -- Increased Mastery
            192967, -- Increased Mastery

            192917, -- Increased Critical Strike and Haste
            192918, -- Increased Critical Strike and Haste
            192919, -- Increased Critical Strike and Haste

            192923, -- Increased Critical Strike and Versatility
            192924, -- Increased Critical Strike and Versatility
            192925, -- Increased Critical Strike and Versatility

            192920, -- Increased Critical Strike and Mastery
            192921, -- Increased Critical Strike and Mastery
            192922, -- Increased Critical Strike and Mastery

            192926, -- Increased Critical Strike
            192927, -- Increased Critical Strike
            192928, -- Increased Critical Strike

            192933, -- Increased Versatility and Haste
            192934, -- Increased Versatility and Haste
            192935, -- Increased Versatility and Haste

            192929, -- Increased Versatility and Critical Strike
            192931, -- Increased Versatility and Critical Strike
            192932, -- Increased Versatility and Critical Strike

            192936, -- Increased Versatility and Mastery
            192937, -- Increased Versatility and Mastery
            192938, -- Increased Versatility and Mastery

            192940, -- Increased Versatility
            192941, -- Increased Versatility
            192942, -- Increased Versatility

            192971, -- Increased Stamina and Haste
            192972, -- Increased Stamina and Haste
            192973, -- Increased Stamina and Haste

            192968, -- Increased Stamina and Critical Strike
            192969, -- Increased Stamina and Critical Strike
            192970, -- Increased Stamina and Critical Strike

            192977, -- Increased Stamina and Versatility
            192978, -- Increased Stamina and Versatility
            192979, -- Increased Stamina and Versatility

            192974, -- Increased Stamina and Mastery
            192975, -- Increased Stamina and Mastery
            192976, -- Increased Stamina and Mastery

            -- TWW Gems
            217113, -- Cubic Blasphemia Rank 1
            217114, -- Cubic Blasphemia Rank 2
            217115, -- Cubic Blasphemia Rank 3

            213738, -- Insightful Blasphemite Rank 1
            213739, -- Insightful Blasphemite Rank 1
            213740, -- Insightful Blasphemite Rank 1

            213741, -- Culminating Blasphemite Rank 1
            213742, -- Culminating Blasphemite Rank 2
            213743, -- Culminating Blasphemite Rank 3

            213744, -- Elusive Blasphemite Rank 1
            213745, -- Elusive Blasphemite Rank 1
            213746, -- Elusive Blasphemite Rank 1

            213747, -- Enduring Bloodstone
            213748, -- Cognitive Bloodstone
            213749, -- Enduring Bloodstone

            434555, -- Masterful Sapphire
            434556, -- Masterful Sapphire
            434557, -- Masterful Sapphire

            213453, -- Quick Ruby
            213454, -- Quick Ruby
            213455, -- Quick Ruby

            213456, -- Masterful Ruby
            213457, -- Masterful Ruby
            213458, -- Masterful Ruby

            213459, -- Versatile Ruby
            213460, -- Versatile Ruby
            213461, -- Versatile Ruby

            213462, -- Deadly Ruby
            213463, -- Deadly Ruby
            213464, -- Deadly Ruby

            213465, -- Deadly Sapphire
            213466, -- Deadly Sapphire
            213467, -- Deadly Sapphire

            213468, -- Quick Sapphire
            213469, -- Quick Sapphire
            213470, -- Quick Sapphire

            213474, -- Versatile Sapphire
            213475, -- Versatile Sapphire
            213476, -- Versatile Sapphire

            213477, -- Deadly Emerald
            213478, -- Deadly Emerald
            213479, -- Deadly Emerald

            213480, -- Masterful Emerald
            213481, -- Masterful Emerald
            213482, -- Masterful Emerald

            213483, -- Versatile Emerald
            213484, -- Versatile Emerald
            213485, -- Versatile Emerald

            213486, -- Quick Emerald
            213487, -- Quick Emerald
            213488, -- Quick Emerald

            213489, -- Deadly Onyx
            213490, -- Deadly Onyx
            213491, -- Deadly Onyx

            213492, -- Quick Onyx
            213493, -- Quick Onyx
            213494, -- Quick Onyx

            213495, -- Versatile Onyx
            213496, -- Versatile Onyx
            213497, -- Versatile Onyx

            213498, -- Masterful Onyx
            213499, -- Masterful Onyx
            213500, -- Masterful Onyx

            213501, -- Deadly Amber
            213502, -- Deadly Amber
            213503, -- Deadly Amber

            213504, -- Quick Amber
            213505, -- Quick Amber
            213506, -- Quick Amber

            213507, -- Masterful Amber
            213508, -- Masterful Amber
            213509, -- Masterful Amber

            213510, -- Versatile Amber
            213511, -- Versatile Amber
            213512, -- Versatile Amber

            213515, -- Solid Amber
            213516, -- Solid Amber
            213517, -- Solid Amber
        };

        -- There is no escaping the cache!!!
        function addon:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
            for _, gemID in ipairs(gemsWeCareAbout) do
                C_Item.GetItemInfo(gemID);
            end
        end

        local eventListener = CreateFrame("frame");
        eventListener:SetScript("OnEvent", function(self, event, ...)
            addon[event](addon, ...);
        end);
        eventListener:RegisterEvent("ADDON_LOADED");
        eventListener:RegisterEvent("SOCKET_INFO_UPDATE");
        eventListener:RegisterEvent("UNIT_INVENTORY_CHANGED");
        eventListener:RegisterEvent("PLAYER_ENTERING_WORLD");
    end
end