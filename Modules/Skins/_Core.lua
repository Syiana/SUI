function SUI:AddMixin(frame)
  if not frame.SetBackdrop then
    Mixin(frame, BackdropTemplateMixin)
  end
end