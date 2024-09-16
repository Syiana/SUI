local Module = SUI:NewModule("General.Fonts");

function Module:OnInitialize()
    local font = SUI.db.profile.general.font
    if (font ~= STANDARD_TEXT_FONT) then
        local ForcedFontSize = { 9, 9, 14, 14, 12, 64, 64 }

        STANDARD_TEXT_FONT       = font
        UNIT_NAME_FONT           = font
        DAMAGE_TEXT_FONT         = font
        NAMEPLATE_FONT           = font
        NAMEPLATE_SPELLCAST_FONT = font
        UNIT_NAME_FONT_ROMAN     = font

        local FontObjects = {
            SystemFont_NamePlateCastBar,
            SystemFont_NamePlateFixed,
            SystemFont_LargeNamePlateFixed,
            SystemFont_LargeNamePlate,
            SystemFont_NamePlate,
            SystemFont_World,
            SystemFont_World_ThickOutline,
            SystemFont_Outline_Small,
            SystemFont_Outline,
            SystemFont_InverseShadow_Small,
            SystemFont_Med2,
            SystemFont_Med3,
            SystemFont_Shadow_Med3,
            SystemFont_Huge1,
            SystemFont_Huge1_Outline,
            SystemFont_OutlineThick_Huge2,
            SystemFont_OutlineThick_Huge4,
            SystemFont_OutlineThick_WTF,
            NumberFont_GameNormal,
            NumberFont_Shadow_Small,
            NumberFont_OutlineThick_Mono_Small,
            NumberFont_Shadow_Med,
            NumberFont_Normal_Med,
            NumberFont_Outline_Med,
            NumberFont_Outline_Large,
            NumberFont_Outline_Huge,
            Fancy22Font,
            QuestFont_Huge,
            QuestFont_Outline_Huge,
            QuestFont_Super_Huge,
            QuestFont_Super_Huge_Outline,
            SplashHeaderFont,
            Game11Font,
            Game12Font,
            Game13Font,
            Game13FontShadow,
            Game15Font,
            Game18Font,
            Game20Font,
            Game24Font,
            Game27Font,
            Game30Font,
            Game32Font,
            Game36Font,
            Game48Font,
            Game48FontShadow,
            Game60Font,
            Game72Font,
            Game11Font_o1,
            Game12Font_o1,
            Game13Font_o1,
            Game15Font_o1,
            QuestFont_Enormous,
            DestinyFontLarge,
            CoreAbilityFont,
            DestinyFontHuge,
            QuestFont_Shadow_Small,
            MailFont_Large,
            SpellFont_Small,
            InvoiceFont_Med,
            InvoiceFont_Small,
            Tooltip_Med,
            Tooltip_Small,
            AchievementFont_Small,
            ReputationDetailFont,
            FriendsFont_Normal,
            FriendsFont_Small,
            FriendsFont_Large,
            FriendsFont_UserText,
            GameFont_Gigantic,
            GameFontNormalMed3,
            ChatBubbleFont,
            Fancy16Font,
            Fancy18Font,
            Fancy20Font,
            Fancy24Font,
            Fancy27Font,
            Fancy30Font,
            Fancy32Font,
            Fancy48Font,
            SystemFont_Tiny2,
            SystemFont_Tiny,
            SystemFont_Shadow_Small,
            SystemFont_Small,
            SystemFont_Small2,
            SystemFont_Shadow_Small2,
            SystemFont_Shadow_Med1_Outline,
            SystemFont_Shadow_Med1,
            QuestFont_Large,
            SystemFont_Large,
            SystemFont_Shadow_Large_Outline,
            SystemFont_Shadow_Med2,
            SystemFont_Shadow_Large,
            SystemFont_Shadow_Large2,
            SystemFont_Shadow_Huge1,
            SystemFont_Huge2,
            SystemFont_Shadow_Huge2,
            SystemFont_Shadow_Huge3,
            SystemFont_Shadow_Outline_Huge3,
            SystemFont_Shadow_Outline_Huge2,
            SystemFont_Med1,
            SystemFont_WTF2,
            SystemFont_Outline_WTF2,
            GameTooltipHeader,
            System_IME,
            Number12Font_o1,
            ObjectiveTrackerLineFont,
            ObjectiveTrackerHeaderFont,
            Game15Font_Shadow
        }

        for i, FontObject in pairs(FontObjects) do
            local _, size, style = FontObject:GetFont()
            FontObject:SetFont(font, ForcedFontSize[i] or size, style)
        end

        local function SetFont(obj, optSize)
            local fontName = obj:GetFont()
            obj:SetFont(fontName, optSize, "OUTLINE")
        end
        
        -- Set Font Size for Nameplate Names
        SetFont(SystemFont_LargeNamePlate, 8)
        SetFont(SystemFont_NamePlate, 8)
        SetFont(SystemFont_LargeNamePlateFixed, 8)
        SetFont(SystemFont_NamePlateFixed, 8)
    end
end