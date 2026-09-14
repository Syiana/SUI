--[[ SUI 2.0 - Features/UnitFrames/Portrait.lua
    Class portraits and frame size. Class icons replace the 3D portrait of
    players after Blizzard updates it. Frame size overrides the Edit Mode
    scale of the player, target and focus frames while it differs from 1;
    it is applied out of combat and again after Edit Mode sets its own size.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local _G, UnitIsPlayer, UnitClass = _G, UnitIsPlayer, UnitClass
local CanAccess = SUI.Compat.CanAccess

-- Class portraits -------------------------------------------------------------------------
local Portrait = SUI:NewFeature("UnitFrames.ClassPortrait", {
    category = "unitframes",
    toggle = function(db)
        return db.portrait == "ClassIcon"
    end,
})

local PORTRAIT_PATH = SUI.mediaPath .. [[Textures\ClassPortraits\]]
local portraits = {} -- class token -> path, built on first use

local function classIcon(frame)
    local portrait, unit = frame.portrait, frame.unit
    if not portrait or not unit or not UnitIsPlayer(unit) then
        return
    end
    local _, class = UnitClass(unit)
    if not CanAccess(class) or not class then
        return
    end
    local path = portraits[class]
    if not path then
        path = PORTRAIT_PATH .. class
        portraits[class] = path
    end
    portrait:SetTexture(path)
end

function Portrait:OnLoad()
    self:Hook("UnitFramePortrait_Update", classIcon)
end

function Portrait:OnEnable()
    local frames = UF.Frames()
    for i = 1, #frames do
        classIcon(frames[i])
    end
end

function Portrait:OnDisable()
    local frames = UF.Frames()
    for i = 1, #frames do
        local frame = frames[i]
        if frame.portrait and frame.unit then
            SetPortraitTexture(frame.portrait, frame.unit)
        end
    end
end

-- Frame size --------------------------------------------------------------------------------
local Size = SUI:NewFeature("UnitFrames.Size", {
    category = "unitframes",
    toggle = function(db)
        return db.player.size ~= 1 or db.target.size ~= 1 or db.focus.size ~= 1
    end,
})

local SIZED = { player = "PlayerFrame", target = "TargetFrame", focus = "FocusFrame" }

local function applySize(key)
    local frame = _G[SIZED[key]]
    local size = Size.db[key].size
    if not frame then
        return
    end
    if size ~= 1 then
        frame:SetScale(size)
    elseif frame.UpdateSystemSettingFrameSize then
        frame:UpdateSystemSettingFrameSize()
    else
        frame:SetScale(1)
    end
end

local function applyAll()
    for key in next, SIZED do
        applySize(key)
    end
end

function Size:OnLoad()
    for key, name in next, SIZED do
        local frame = _G[name]
        if frame and frame.UpdateSystemSettingFrameSize then
            self:Hook(frame, "UpdateSystemSettingFrameSize", function()
                if Size.db[key].size ~= 1 then
                    SUI:RunAfterCombat(function()
                        applySize(key)
                    end)
                end
            end)
        end
    end
end

function Size:OnEnable()
    SUI:RunAfterCombat(applyAll)
end

function Size:OnRefresh()
    SUI:RunAfterCombat(applyAll)
end

function Size:OnDisable()
    SUI:RunAfterCombat(applyAll)
end
