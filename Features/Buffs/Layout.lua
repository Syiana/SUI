--[[ SUI 2.0 - Features/Buffs/Layout.lua
    Optional icon size, padding and icons per row for the player buff and
    debuff frames. Edit Mode owns these values, so SUI does not write them;
    it re-lays out the aura buttons right after Blizzard's grid layout,
    reusing Blizzard's anchor and direction. The grid layout object is only
    rebuilt when a setting or the Edit Mode orientation changes.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, wipe = _G, wipe

local F = SUI:NewFeature("Buffs.Layout", {
    category = "buffs",
    toggle = "layout",
    conflicts = { "BlizzBuffsFacade" },
})

local BUTTON_SIZE = 30 -- Blizzard's aura icon size at scale 1
local HOSTS = { BuffFrame = "buff", DebuffFrame = "debuff" }

local cache = {}  -- container -> { layout, horizontal, right, top, stride, padding }
local buffer = {}

local function gridLayout(container, settings, horizontal)
    local entry = cache[container]
    local right, top = container.addIconsToRight, container.addIconsToTop
    local stride, padding = settings.icons, settings.padding
    if not entry then
        entry = {}
        cache[container] = entry
    end
    if entry.layout and entry.horizontal == horizontal and entry.right == right and entry.top == top
        and entry.stride == stride and entry.padding == padding then
        return entry.layout
    end
    local create = horizontal and GridLayoutUtil.CreateStandardGridLayout or GridLayoutUtil.CreateVerticalGridLayout
    entry.layout = create(stride, padding, padding, right and 1 or -1, top and 1 or -1)
    entry.horizontal, entry.right, entry.top, entry.stride, entry.padding = horizontal, right, top, stride, padding
    return entry.layout
end

local function layout(container, auras, onlyEnabled, kind)
    local info = container.currentGridLayoutInfo
    if not info or not auras then
        return
    end
    local settings = F.db[kind]
    local scale = settings.size / BUTTON_SIZE
    wipe(buffer)
    for i = 1, #auras do
        local aura = auras[i]
        aura:SetScale(scale)
        if not onlyEnabled or aura.hasValidInfo or aura.isExample or aura.isAuraAnchor then
            buffer[#buffer + 1] = aura
        end
    end
    GridLayoutUtil.ApplyGridLayout(buffer, info.anchor, gridLayout(container, settings, info.isHorizontal))
end

function F:OnLoad()
    for host, kind in next, HOSTS do
        local frame = _G[host]
        local container = frame and frame.AuraContainer
        if container and container.UpdateGridLayout and GridLayoutUtil then
            self:Hook(container, "UpdateGridLayout", function(c, auras, onlyEnabled)
                layout(c, auras, onlyEnabled, kind)
            end)
        end
    end
end

function F:OnEnable()
    for host, kind in next, HOSTS do
        local frame = _G[host]
        if frame and frame.AuraContainer and GridLayoutUtil then
            layout(frame.AuraContainer, frame.auraFrames, frame.doNotAnchorDisabledFrames, kind)
        end
    end
end

F.OnRefresh = F.OnEnable

-- Put Blizzard's own layout back without calling into Edit Mode.
function F:OnDisable()
    for host in next, HOSTS do
        local frame = _G[host]
        local container = frame and frame.AuraContainer
        local info = container and container.currentGridLayoutInfo
        local auras = frame and frame.auraFrames
        if info and auras and info.layout then
            wipe(buffer)
            for i = 1, #auras do
                local aura = auras[i]
                aura:SetScale(container.iconScale or 1)
                if not frame.doNotAnchorDisabledFrames or aura.hasValidInfo or aura.isExample or aura.isAuraAnchor then
                    buffer[#buffer + 1] = aura
                end
            end
            GridLayoutUtil.ApplyGridLayout(buffer, info.anchor, info.layout)
        end
    end
end
