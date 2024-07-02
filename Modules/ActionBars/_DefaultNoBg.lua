local Module = SUI:NewModule("ActionBars.DefaultNoBg");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.actionbar.style,
        module = SUI.db.profile.modules.actionbar
    }

    if (db.style == 'DefaultNoBg' and db.module) then
        MainMenuBarTexture0:Hide()
        MainMenuBarTexture1:Hide()
        MainMenuBarTexture2:Hide()
        MainMenuBarTexture3:Hide()
        MainMenuMaxLevelBar0:Hide()
        MainMenuMaxLevelBar1:Hide()
        MainMenuMaxLevelBar2:Hide()
        MainMenuMaxLevelBar3:Hide()
        MainMenuBarTextureExtender:Hide()
    end
end
