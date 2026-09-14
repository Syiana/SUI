--[[
    Minimal fake WoW environment for smoke tests. It is NOT an emulator:
    unknown globals and methods return permissive "mock" objects so files can
    load and run their setup paths. Errors raised in SUI's own logic still
    surface. Treat findings as leads to verify, not as proof.
]]

local W = { errors = {}, events = {}, hooks = 0 }

-- Mock objects --------------------------------------------------------------
local MockMT = {}
local function mock(name)
    return setmetatable({ __mockname = name }, MockMT)
end
W.mock = mock
MockMT.__index = function(t, k)
    if k == "__mockname" then return nil end
    local v = mock(rawget(t, "__mockname") .. "." .. tostring(k))
    rawset(t, k, v)
    return v
end
MockMT.__call = function(self)
    return mock(rawget(self, "__mockname") .. "()")
end
MockMT.__tostring = function(self) return "mock:" .. tostring(rawget(self, "__mockname")) end
MockMT.__concat = function(a, b) return tostring(a) .. tostring(b) end
local zero = function() return 0 end
MockMT.__add, MockMT.__sub, MockMT.__mul, MockMT.__div, MockMT.__unm, MockMT.__mod = zero, zero, zero, zero, zero, zero
MockMT.__len = zero
MockMT.__lt = function() return false end
MockMT.__le = function() return false end

-- Frames ------------------------------------------------------------------------
local Region = {}
Region.__index = function(t, k)
    local m = rawget(Region, k)
    if m then return m end
    -- Unknown CamelCase keys behave like template children / methods; other keys are nil.
    if type(k) == "string" and k:match("^[A-Z]") then
        local v = mock((rawget(t, "__name") or rawget(t, "__kind")) .. "." .. k)
        rawset(t, k, v)
        return v
    end
    return nil
end

local registry = {} -- event -> set of frames
local allFrames = {}
local frameCount = 0

local function newObject(kind, name, parent)
    frameCount = frameCount + 1
    local o = setmetatable({
        __kind = kind, __name = name, __parent = parent, __scripts = {}, __shown = true,
        __points = {}, __regions = {}, __children = {}, __w = 100, __h = 20, __alpha = 1, __scale = 1,
        __text = "", __value = 0, __min = 0, __max = 1,
    }, Region)
    if name then _G[name] = o end
    if parent and type(parent) == "table" and rawget(parent, "__children") then
        local list = (kind == "Texture" or kind == "FontString") and parent.__regions or parent.__children
        list[#list + 1] = o
    end
    allFrames[#allFrames + 1] = o
    return o
end
W.newObject = newObject

function Region:GetObjectType() return self.__kind end
function Region:IsObjectType(t) return self.__kind == t end
function Region:GetName() return self.__name end
function Region:GetParent() return self.__parent end
function Region:SetParent(p) self.__parent = p end
function Region:Show() self.__shown = true; local s = self.__scripts.OnShow; if s then s(self) end end
function Region:Hide() self.__shown = false; local s = self.__scripts.OnHide; if s then s(self) end end
function Region:SetShown(v) if v then self:Show() else self:Hide() end end
function Region:IsShown() return self.__shown end
function Region:IsVisible() return self.__shown end
function Region:IsForbidden() return false end
function Region:IsProtected() return false end
function Region:SetScript(s, f) self.__scripts[s] = f end
function Region:GetScript(s) return self.__scripts[s] end
function Region:HasScript() return true end
function Region:HookScript(s, f)
    local old = self.__scripts[s]
    self.__scripts[s] = old and function(...) old(...); f(...) end or f
end
function Region:RegisterEvent(e)
    registry[e] = registry[e] or {}
    registry[e][self] = true
end
Region.RegisterUnitEvent = Region.RegisterEvent
function Region:UnregisterEvent(e) if registry[e] then registry[e][self] = nil end end
function Region:UnregisterAllEvents() for _, set in pairs(registry) do set[self] = nil end end
function Region:IsEventRegistered(e) return registry[e] and registry[e][self] or false end
function Region:CreateTexture(name) return newObject("Texture", name, self) end
function Region:CreateMaskTexture(name) return newObject("Texture", name, self) end
function Region:CreateFontString(name) return newObject("FontString", name, self) end
function Region:CreateLine(name) return newObject("Line", name, self) end
function Region:CreateAnimationGroup()
    local g = newObject("AnimationGroup", nil, self)
    function g:CreateAnimation() return newObject("Animation", nil, g) end
    return g
end
function Region:GetRegions() return unpack(self.__regions) end
function Region:GetNumRegions() return #self.__regions end
function Region:GetChildren() return unpack(self.__children) end
function Region:GetNumChildren() return #self.__children end
function Region:SetPoint(...) self.__points[#self.__points + 1] = { ... } end
function Region:ClearAllPoints() self.__points = {} end
function Region:GetPoint(i) local p = self.__points[i or 1]; if p then return p[1], p[2], p[3], p[4] or 0, p[5] or 0 end end
function Region:GetNumPoints() return #self.__points end
function Region:SetAllPoints() end
function Region:SetSize(w, h) self.__w, self.__h = w or 0, h or 0 end
function Region:SetWidth(w) self.__w = w or 0 end
function Region:SetHeight(h) self.__h = h or 0 end
function Region:GetWidth() return self.__w end
function Region:GetHeight() return self.__h end
function Region:GetSize() return self.__w, self.__h end
function Region:GetLeft() return 0 end
function Region:GetRight() return self.__w end
function Region:GetTop() return self.__h end
function Region:GetBottom() return 0 end
function Region:GetCenter() return self.__w / 2, self.__h / 2 end
function Region:GetRect() return 0, 0, self.__w, self.__h end
function Region:GetEffectiveScale() return 1 end
function Region:SetScale(s) self.__scale = s end
function Region:GetScale() return self.__scale end
function Region:SetAlpha(a) self.__alpha = a end
function Region:GetAlpha() return self.__alpha end
function Region:GetEffectiveAlpha() return self.__alpha end
function Region:SetText(t) self.__text = t end
function Region:GetText() return self.__text end
function Region:SetFormattedText(f, ...) self.__text = string.format(f, ...) end
function Region:GetStringWidth() return #tostring(self.__text) * 6 end
function Region:GetStringHeight() return 12 end
function Region:GetFont() return "Fonts\\FRIZQT__.TTF", 12, "" end
function Region:SetFont() return true end
function Region:GetTextColor() return 1, 1, 1, 1 end
function Region:GetVertexColor() return 1, 1, 1, 1 end
function Region:GetTexture() return "tex" end
function Region:GetTexCoord() return 0, 1, 0, 1 end
function Region:GetValue() return self.__value end
function Region:SetValue(v) self.__value = v; local s = self.__scripts.OnValueChanged; if s then s(self, v) end end
function Region:GetMinMaxValues() return self.__min, self.__max end
function Region:SetMinMaxValues(a, b) self.__min, self.__max = a, b end
function Region:GetStatusBarTexture() self.__sbt = self.__sbt or newObject("Texture", nil, self); return self.__sbt end
function Region:GetStatusBarColor() return 1, 1, 1, 1 end
function Region:GetNormalTexture() self.__nt = self.__nt or newObject("Texture", nil, self); return self.__nt end
function Region:GetPushedTexture() return self:GetNormalTexture() end
function Region:GetHighlightTexture() return self:GetNormalTexture() end
function Region:GetCheckedTexture() return self:GetNormalTexture() end
function Region:GetDisabledTexture() return self:GetNormalTexture() end
function Region:GetFontString() self.__fs = self.__fs or newObject("FontString", nil, self); return self.__fs end
function Region:GetFrameLevel() return 1 end
function Region:GetFrameStrata() return "MEDIUM" end
function Region:GetID() return 1 end
function Region:IsMouseOver() return false end
function Region:IsMouseEnabled() return true end
function Region:GetAttribute() return nil end
function Region:GetChecked() return false end
function Region:IsEnabled() return true end
function Region:GetNumLines() return 0 end
function Region:GetNumMessages() return 0 end
function Region:GetBackdrop() return nil end
function Region:GetBackdropColor() return 0, 0, 0, 1 end
function Region:GetBackdropBorderColor() return 0, 0, 0, 1 end
function Region:IsDragging() return false end
function Region:GetMaxLetters() return 255 end
function Region:GetCursorPosition() return 0 end
function Region:GetInlineHyperlinkAtCursor() return nil end
function Region:GetUnit() return nil end
function Region:GetItem() return nil end
function Region:GetSpell() return nil end
function Region:GetOwner() return nil end
function Region:GetAnchorType() return "ANCHOR_NONE" end
function Region:GetVerticalScroll() return 0 end
function Region:GetVerticalScrollRange() return 0 end
function Region:GetHorizontalScroll() return 0 end
function Region:GetScrollChild() return self.__scrollChild end
function Region:SetScrollChild(c) self.__scrollChild = c end
function Region:GetHyperlinksEnabled() return true end
function Region:GetFading() return true end
function Region:GetTimeVisible() return 120 end
function Region:GetFadeDuration() return 3 end
function Region:GetJustifyH() return "LEFT" end
function Region:GetJustifyV() return "MIDDLE" end
function Region:GetShadowOffset() return 1, -1 end
function Region:GetShadowColor() return 0, 0, 0, 1 end
function Region:GetDrawLayer() return "ARTWORK", 0 end
function Region:GetBlendMode() return "BLEND" end
function Region:GetAtlas() return nil end
function Region:IsDesaturated() return false end
function Region:GetBoundsRect() return 0, 0, 100, 20 end
function Region:GetHitRectInsets() return 0, 0, 0, 0 end
function Region:GetClampRectInsets() return 0, 0, 0, 0 end
function Region:IsMovable() return true end
function Region:IsUserPlaced() return false end
function Region:IsClampedToScreen() return false end
function Region:GetDontSavePosition() return false end
function Region:GetNumPoints() return #self.__points end

function W.CreateFrame(kind, name, parent, template)
    local f = newObject(kind or "Frame", name, parent)
    f.__template = template
    return f
end

function W.fire(event, ...)
    local set = registry[event]
    if not set then return end
    local list = {}
    for f in pairs(set) do list[#list + 1] = f end
    for _, f in ipairs(list) do
        local s = f.__scripts.OnEvent
        if s then
            local ok, err = xpcall(function(...) s(f, event, ...) end, debug.traceback, ...)
            if not ok then W.report("event " .. event, err) end
        end
    end
end

function W.tickUpdates(elapsed)
    for _, f in ipairs(allFrames) do
        local s = f.__scripts.OnUpdate
        if s and f.__shown then
            local ok, err = xpcall(s, debug.traceback, f, elapsed)
            if not ok then W.report("OnUpdate", err) end
        end
    end
end

function W.report(where, err)
    local key = tostring(err):match("^[^\n]*")
    if not W.errors[key] then
        W.errors[key] = { where = where, err = err, count = 0 }
        W.errors[#W.errors + 1] = key
    end
    W.errors[key].count = W.errors[key].count + 1
end

W.frameCount = function() return frameCount end
return W
