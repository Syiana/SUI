--[[
    SUI 2.0 - Features/Chat/PixelScroll.lua

    Smooth mouse wheel scrolling: each wheel notch moves a target by
    "Scroll Speed" lines and the view eases towards it. The whole-line part
    goes through SetScrollOffset; where the frame renders its lines in a
    FontStringContainer (retail) the fraction is shown as a pixel shift of that
    container. Shift/Ctrl + wheel keep Blizzard's jump behaviour. The update
    loop only runs while a frame is animating. On Retail 12.x writing the
    scroll offset from add-on code can taint the chat display, hence off by
    default.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local next, min, max, floor, abs, wipe = next, math.min, math.max, math.floor, math.abs, wipe

local F = SUI:NewFeature("Chat.PixelScroll", {
    category = "chat",
    toggle = "settings.pixelscroll",
})

local state = {}     -- chat frame -> { pos, target, points }
local animating = {} -- chat frame -> true
local running = false

local function maxOffset(frame)
    if frame.GetMaxScrollRange then
        return frame:GetMaxScrollRange() or 0
    end
    return max(frame:GetNumMessages() - 1, 0)
end

-- Moves the line container dy pixels from its original anchors.
local function shift(frame, s, dy)
    local container = frame.FontStringContainer
    if not container then
        return
    end
    local points = s.points
    if not points then
        points = {}
        for i = 1, container:GetNumPoints() do
            points[i] = { container:GetPoint(i) }
        end
        s.points = points
    end
    container:ClearAllPoints()
    for i = 1, #points do
        local p = points[i]
        container:SetPoint(p[1], p[2], p[3], p[4], p[5] + dy)
    end
end

local function tick(elapsed)
    local k = min(1, elapsed * 12)
    for frame, s in next, animating do
        s.pos = s.pos + (s.target - s.pos) * k
        if abs(s.target - s.pos) < 0.02 then
            s.pos = s.target
            animating[frame] = nil
        end
        local line = floor(s.pos)
        if line ~= frame:GetScrollOffset() then
            frame:SetScrollOffset(line)
        end
        local _, size = frame:GetFont()
        shift(frame, s, -(s.pos - line) * ((size or 12) + (frame.GetSpacing and frame:GetSpacing() or 0)))
    end
    if not next(animating) then
        running = false
        F:StopUpdate()
    end
end

local function onWheel(frame, delta)
    if not F.enabled or IsShiftKeyDown() or IsControlKeyDown() then
        return
    end
    local s = state[frame]
    local top = maxOffset(frame)
    if not animating[frame] then
        -- Blizzard already stepped one line; start from where the view was.
        s.pos = min(max(frame:GetScrollOffset() - delta, 0), top)
        s.target = s.pos
    end
    s.target = min(max(s.target + delta * F.db.settings.scrollspeed, 0), top)
    frame:SetScrollOffset(floor(s.pos))
    animating[frame] = true
    if not running then
        running = true
        F:StartUpdate(tick)
    end
end

function F:Watch(frame)
    if not state[frame] then
        state[frame] = { pos = 0, target = 0 }
        frame:HookScript("OnMouseWheel", onWheel)
    end
end

function F:OnLoad()
    Chat.OnNewFrame(self, "Watch")
end

function F:OnEnable()
    Chat.EachFrame(self.Watch, self)
end

function F:OnDisable()
    for frame in next, animating do
        local s = state[frame]
        frame:SetScrollOffset(floor(s.target))
        shift(frame, s, 0)
    end
    wipe(animating)
    running = false
end
