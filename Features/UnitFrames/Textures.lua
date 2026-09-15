--[[ SUI 2.0 - Features/UnitFrames/Textures.lua
    Statusbar texture (general.texture) on the health and power bars of the
    player, pet, target, focus, target-of-target and boss frames, and on the
    power bars of every other unit frame (party, arena). The texture is set
    once and only re-applied where Blizzard swaps the bar art: power type
    changes, classification changes and vehicle art. "Default" keeps
    Blizzard's bars; the Classic style keeps them too except on boss frames.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local PowerBarColor = PowerBarColor
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("UnitFrames.Texture", {
    category = "unitframes",
    toggle = function()
        return not UF.BlizzardTexture()
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

local function classic()
    return F.db.style == "Classic"
end

local function isBoss(frame)
    return frame.isBossFrame or (frame.GetName and (frame:GetName() or ""):find("^Boss%d"))
end

local function styleFrame(frame)
    if classic() and not isBoss(frame) then
        return
    end
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
            -- 1.x: all unit frame power bars, none while the Classic style is on.
            if (managed[bar] or bar.unitFrame) and not classic() then
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
    if alternate and alternate.SetStatusBarTexture and not classic() then
        styleBar(alternate)
        colorPower(alternate)
    end
end

function F:OnEnable()
    self:Apply()
end

function F:OnRefresh(key)
    if key == "texture" or key == "style" then
        self:Apply()
    end
end
