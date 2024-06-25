local Module = SUI:NewModule("Misc.Fastloot");

function Module:OnEnable()
    local db = SUI.db.profile.misc.fastloot
    if (db) then
		-- Time delay
		local tDelay = 0

		-- Fast loot function
		local function FastLoot()
			if GetTime() - tDelay >= 0.3 then
				tDelay = GetTime()
				if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
					if TSMDestroyBtn and TSMDestroyBtn:IsShown() and TSMDestroyBtn:GetButtonState() == "DISABLED" then tDelay = GetTime() return end
					local lootMethod = GetLootMethod()
					if lootMethod == "master" then
						-- Master loot is enabled so fast loot if item should be auto looted
						local lootThreshold = GetLootThreshold()
						for i = GetNumLootItems(), 1, -1 do
							local lootIcon, lootName, lootQuantity, currencyID, lootQuality = GetLootSlotInfo(i)
							if lootQuality and lootThreshold and lootQuality < lootThreshold then
								LootSlot(i)
							end
						end
					else
						-- Master loot is disabled so fast loot regardless
						local grouped = IsInGroup()
						for i = GetNumLootItems(), 1, -1 do
							local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked = GetLootSlotInfo(i)
							local slotType = GetLootSlotType(i)
							if lootName and not locked then
								if not grouped then
									LootSlot(i)
								else
									if lootMethod == "freeforall" then
										if slotType == LOOT_SLOT_ITEM then
											LootSlot(i)
										end
									else
										LootSlot(i)
									end
								end
							end
						end
					end
					tDelay = GetTime()
				end
			end
		end

		-- Event frame
		local faster = CreateFrame("Frame")
		faster:RegisterEvent("LOOT_READY")
		faster:SetScript("OnEvent", FastLoot)
    end
end