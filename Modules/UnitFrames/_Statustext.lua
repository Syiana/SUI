local Module = SUI:NewModule("UnitFrames.Statustext");

function Module:OnEnable()
    local db = {
        textsize = SUI.db.profile.unitframes.textsize,
        module = SUI.db.profile.modules.unitframes
    }

    if (db.module) then
        StatusTexts = {
            -- Player Frame
            PlayerFrameHealthBarText,
            PlayerFrameHealthBarTextLeft,
            PlayerFrameHealthBarTextRight,
            PlayerFrameManaBarText,
            PlayerFrameManaBarTextLeft,
            PlayerFrameManaBarTextRight,

            -- Target Frame
            TargetFrameTextureFrame.HealthBarText,
            TargetFrameTextureFrame.HealthBarTextLeft,
            TargetFrameTextureFrame.HealthBarTextRight,
            TargetFrameTextureFrame.ManaBarText,
            TargetFrameTextureFrame.ManaBarTextLeft,
            TargetFrameTextureFrame.ManaBarTextRight,

            -- Pet Frame
            PetFrameHealthBarText,
            PetFrameHealthBarTextLeft,
            PetFrameHealthBarTextRight,
            PetFrameManaBarText,
            PetFrameManaBarTextLeft,
            PetFrameManaBarTextRight
        }

        MDF_StatusTexts = {
            select(14, TargetFrameTextureFrame:GetRegions()),
            select(15, TargetFrameTextureFrame:GetRegions()),
            select(16, TargetFrameTextureFrame:GetRegions()),
            select(17, TargetFrameTextureFrame:GetRegions()),
            select(18, TargetFrameTextureFrame:GetRegions()),
            select(19, TargetFrameTextureFrame:GetRegions())
        }

        if IsAddOnLoaded("ModernTargetFrame") then
            for _, statustext in pairs(MDF_StatusTexts) do
                statustext:SetFont(STANDARD_TEXT_FONT, db.textsize, "OUTLINE")
            end
        end

        for _, statustext in pairs(StatusTexts) do
            statustext:SetFont(STANDARD_TEXT_FONT, db.textsize, "OUTLINE")
        end
    end
end