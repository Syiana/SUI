local Module = SUI:NewModule("Bags.Core");

function Module:OnEnable()
    local db = SUI.db.profile.bags or {}
    
    -- Bags module core functionality
    -- This module handles bag-related features and customizations
    
    -- Add any bag-specific functionality here if needed
    -- For now, this serves as a placeholder for the bags module
    
    if db.enabled ~= false then
        -- Bag customizations can be added here
        -- Currently handled by the Skins.Bags module
    end
end
