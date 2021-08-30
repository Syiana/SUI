SUI = LibStub("AceAddon-3.0"):NewAddon("SUI", "AceEvent-3.0")

function SUI:OnInitialize()
  local defaults = SUI:GetModule("Config.Defaults").profile
  self.db = LibStub("AceDB-3.0"):New("SUIDB", defaults, true)
  self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
end

function SUI:RefreshConfig()
  print("db changed");
end