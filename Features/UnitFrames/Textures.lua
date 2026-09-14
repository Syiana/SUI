--[[ SUI 2.0 - Features/UnitFrames/Textures.lua
    Statusbar texture (general.texture) on the health and power bars of the
    player, pet, target, focus, target-of-target and boss frames. The texture
    is set once and only re-applied where Blizzard swaps the bar art: power
    type changes, classification changes and vehicle art.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local PowerBarColor = PowerBarColor
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("UnitFrames.Texture", {
    category = "unitframes",
    toggle = function(db)
        return db.style ~= "Classic"
    end,
    watch = { "general" },
    reload = true, -- Blizzard's bar atlases cannot be restored cleanly
})

local managed = {} -- bar -> true

local function texture()
    return SUI.db.profile.general.texture
end

local function styleBar(bar)
    bar:SetStatusBarTexture(texture())
    local region = bar:GetStatusBarTexture()
    if region then
        region:SetDrawLayer("BORDER")
    end
end

local function colorPower(bar)
    local powerType = bar.powerType
    if not CanAccess(powerType) then
        return
    end
    if powerType == 0 then
        bar:SetStatusBarColor(0, 0.5, 1)
    else
        local color = powerType and PowerBarColor and PowerBarColor[powerType]
        if color and color.r then
            bar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end
end

local function styleFrame(frame)
    if frame.healthbar then
        styleBar(frame.healthbar)
        if frame.healthbar.AnimatedLossBar then
            styleBar(frame.healthbar.AnimatedLossBar)
        end
    end
    if frame.manabar then
        styleBar(frame.manabar)
        colorPower(frame.manabar)
    end
end

function F:OnLoad()
    local frames = UF.Frames()
    for i = 1, #frames do
        local frame = frames[i]
        if frame.healthbar then
            managed[frame.healthbar] = true
        end
        if frame.manabar then
            managed[frame.manabar] = true
        end
    end

    if UnitFrameManaBar_UpdateType then
        self:Hook("UnitFrameManaBar_UpdateType", function(bar)
            if managed[bar] then
                styleBar(bar)
                colorPower(bar)
            end
        end)
    end
    -- Retail swaps the health atlas on classification and vehicle changes.
    local targets = UF.TargetFrames()
    for i = 1, #targets do
        if targets[i].CheckClassification then
            self:Hook(targets[i], "CheckClassification", styleFrame)
        end
    end
    if PlayerFrame_ToPlayerArt then
        self:Hook("PlayerFrame_ToPlayerArt", styleFrame)
    end
    if PlayerFrame_ToVehicleArt then
        self:Hook("PlayerFrame_ToVehicleArt", styleFrame)
    end
end

function F:Apply()
    local frames = UF.Frames()
    for i = 1, #frames do
        styleFrame(frames[i])
    end
    local alternate = _G.AlternatePowerBar or _G.PlayerFrameAlternateManaBar
    if alternate and alternate.SetStatusBarTexture then
        styleBar(alternate)
        colorPower(alternate)
    end
end

function F:OnEnable()
    self:Apply()
end

function F:OnRefresh(key)
    if key == "texture" then
        self:Apply()
    end
end
