local Module = SUI:NewModule("General.Cinematic");

function Module:OnEnable()
    local db = {
        cinematic = SUI.db.profile.general.automation.cinematic,
        module = SUI.db.profile.modules.general
    }

    if (db.cinematic and db.module) then
        local cinematic = CreateFrame("Frame")
        cinematic:RegisterEvent("CINEMATIC_START")
        cinematic:SetScript("OnEvent", function(_, event)
            if event == "CINEMATIC_START" then
                if not IsControlKeyDown() then
                    CinematicFrame_CancelCinematic()
                end
            end
        end)
        local PlayMovie_hook = MovieFrame_PlayMovie
        MovieFrame_PlayMovie = function(...)
            if IsControlKeyDown() then
                PlayMovie_hook(...)
            else
                GameMovieFinished()
            end
        end
    end
end
