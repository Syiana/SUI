-- Blizzard's BackdropTemplate recomputes its nine-slice texture coordinates from
-- the frame's own width and height on every OnSizeChanged. When we hang one of
-- those off a Blizzard frame whose geometry is secret -- a cast bar icon, a target
-- aura, a nameplate icon -- that maths runs on a secret number inside execution we
-- tainted merely by creating the frame, and 12.1 does not allow it:
--
--   Backdrop.lua:226: attempt to perform arithmetic on local 'width'
--   (a secret number value, while execution tainted by 'SUI')
--
-- OnSizeChanged fires on every cast, so this arrives thousands of times a session.
-- Hide backdropInfo from Blizzard's handler and drive the update from ours, which
-- runs the very same Blizzard routine but only while the size is readable.

-- 12.0 secret values; keep this callable on builds that do not expose it
local canaccessvalue = canaccessvalue or function() return true end

local function isReadable(frame, method)
    local ok, value = pcall(frame[method], frame)
    return ok and type(value) == "number" and canaccessvalue(value)
end

local function refreshBackdrop(frame)
    local backdropInfo = frame.SUIBackdropInfo
    if not backdropInfo then
        return
    end

    if not isReadable(frame, "GetWidth") or not isReadable(frame, "GetHeight") then
        return
    end

    frame.backdropInfo = backdropInfo
    frame:SetupTextureCoordinates()
    frame.backdropInfo = nil
end

--- Keep a BackdropTemplate frame of ours off Blizzard's resize path.
--- Call it once, right after SetBackdrop.
--- @param frame Frame a frame created from BackdropTemplate
--- @return Frame the same frame, for chaining
function SUI:ProtectBackdrop(frame)
    if not frame or not frame.SetupTextureCoordinates or frame.SUIBackdropInfo then
        return frame
    end

    frame.SUIBackdropInfo = frame.backdropInfo
    frame.backdropInfo = nil

    frame:HookScript("OnSizeChanged", refreshBackdrop)
    refreshBackdrop(frame)

    return frame
end
