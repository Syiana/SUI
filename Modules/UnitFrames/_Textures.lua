            -- TEXTURE
            function SUIManaTexture (manaBar)
                local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
                local info = PowerBarColor[powerToken];
                if ( info ) then
                    if ( not manaBar.lockColor ) then
                        if not ( info.atlas ) and ( config.TEXTURES ) then
                            manaBar:SetStatusBarTexture("Interface\\Addons\\SUI\\Media\\Textures\\UnitFrames\\UI-StatusBar");
                        end
                    end
                end
            end
            hooksecurefunc("UnitFrameManaBar_UpdateType", SUIManaTexture)