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

            -- Focus Frame
            FocusFrameTextureFrame.HealthBarText,
            FocusFrameTextureFrame.HealthBarTextLeft,
            FocusFrameTextureFrame.HealthBarTextRight,
            FocusFrameTextureFrame.ManaBarText,
            FocusFrameTextureFrame.ManaBarTextLeft,
            FocusFrameTextureFrame.ManaBarTextRight,

            -- Pet Frame
            PetFrameHealthBarText,
            PetFrameHealthBarTextLeft,
            PetFrameHealthBarTextRight,
            PetFrameManaBarText,
            PetFrameManaBarTextLeft,
            PetFrameManaBarTextRight
        }

        for _, statustext in pairs(StatusTexts) do
            statustext:SetFont(STANDARD_TEXT_FONT, db.textsize, "OUTLINE")
        end
    end
end