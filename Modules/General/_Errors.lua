local Module = SUI:NewModule("General.Errors");

function Module:OnEnable()
    local event_frame = CreateFrame("Frame")
    local errormessage_blocks = {
      "Ability is not ready yet",
      "Another action is in progress",
      "Can't attack while mounted",
      "Can't do that while moving",
      "Item is not ready yet",
      "Not enough",
      "Nothing to attack",
      "Spell is not ready yet",
      "You have no target",
      "You can't do that yet"
    }
    local enable
    local onevent
    local uierrorsframe_addmessage
    local old_uierrosframe_addmessage
    old_uierrosframe_addmessage = UIErrorsFrame.AddMessage
    UIErrorsFrame.AddMessage = uierrorsframe_addmessage

    function uierrorsframe_addmessage(frame, text, red, green, blue, id)
      for i, v in ipairs(errormessage_blocks) do
        if text and text:match(v) then return end
      end
      old_uierrosframe_addmessage(frame, text, red, green, blue, id)
    end
end