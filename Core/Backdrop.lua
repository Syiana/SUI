--[[
    SUI 2.0 - Core/Backdrop.lua

    BackdropTemplate recomputes its nine-slice coordinates from the frame's
    size on every OnSizeChanged. A backdrop hung off a Blizzard frame whose
    geometry is secret (cast bar icon, target aura, nameplate icon) makes
    that maths run on a secret number in SUI-tainted execution, which 12.x
    refuses ("attempt to perform arithmetic on local 'width'"), on every
    cast. ProtectBackdrop hides backdropInfo from Blizzard's handler and
    runs the same update from SUI only while the size is readable.

    Call SUI:ProtectBackdrop(frame) right after SetBackdrop on every
    BackdropTemplate frame anchored to a Blizzard frame.
]]

local _, ns = ...
local SUI = ns.SUI

local CanAccess = SUI.Compat.CanAccess

local function readable(value)
    return type(value) == "number" and CanAccess(value)
end

local function refresh(frame)
    local info = frame.suiBackdropInfo
    if not info then
        return
    end
    local width, height = frame:GetSize()
    if not readable(width) or not readable(height) then
        return
    end
    frame.backdropInfo = info
    frame:SetupTextureCoordinates()
    frame.backdropInfo = nil
end

function SUI:ProtectBackdrop(frame)
    if not frame or not frame.SetupTextureCoordinates or frame.suiBackdropInfo or not frame.backdropInfo then
        return frame
    end
    frame.suiBackdropInfo = frame.backdropInfo
    frame.backdropInfo = nil
    frame:HookScript("OnSizeChanged", refresh)
    refresh(frame)
    return frame
end
