local Module = SUI:NewModule("General.Commands");

function Module:OnEnable()
    SlashCmdList["RELOAD"] = function()
        ReloadUI()
    end
    SLASH_RELOAD1 = "/rl"
    SLASH_FSTACK1 = "/fs"
    SlashCmdList["SUI"] = function()
        SUI:Config()
    end
    SlashCmdList["FSTACK"] = function()
        UIParentLoadAddOn("Blizzard_DebugTools");
        local showHiddenArg, showRegionsArg, showAnchorsArg;
        local pattern = "^%s*(%S+)(.*)$";
        showHiddenArg, msg = string.match(msg or "", pattern);
        showRegionsArg, msg = string.match(msg or "", pattern);
        showAnchorsArg, msg = string.match(msg or "", pattern);
        -- If no parameters are passed the defaults specified by these cvars are used instead.
        local showHiddenDefault = FrameStackTooltip_IsShowHiddenEnabled();
        local showRegionsDefault = FrameStackTooltip_IsShowRegionsEnabled();
        local showAnchorsDefault = FrameStackTooltip_IsShowAnchorsEnabled();
        local showHidden = StringToBoolean(showHiddenArg or "", showHiddenDefault);
        local showRegions = StringToBoolean(showRegionsArg or "", showRegionsDefault);
        local showAnchors = StringToBoolean(showAnchorsArg or "", showAnchorsDefault);
        FrameStackTooltip_Toggle(showHidden, showRegions, showAnchors);
    end
    SLASH_SUI1 = "/sui"
end
