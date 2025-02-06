local _, addon = ...

local Utils = addon.Utils
local DataManager = addon.DataManager

local DropdownManager = addon.DropdownManager or {}
addon.DropdownManager = DropdownManager

local function InitializeDropdown(self, level, database, editBox, talentsKey)
	local info = UIDropDownMenu_CreateInfo()
	info.func = function(button)
		local key = button.value
		local classID, specID = Utils.GetPlayerClassAndSpec()

		Utils.Debug("Selected key:", key)

		if database[classID] and
			database[classID].specs and
			database[classID].specs[specID] then
			local data = database[classID].specs[specID][key]
			if data then
				editBox:SetText(data[talentsKey] or "")
				editBox:SetCursorPosition(0)
				UIDropDownMenu_SetText(self, data.label or key)
			end
		end
	end

	local classID, specID = Utils.GetPlayerClassAndSpec()
	local entries = DataManager.GetAvailableEntries(database, classID, specID)

	for _, entry in ipairs(entries) do
		info.text = entry.data.label or entry.key
		info.value = entry.key
		info.checked = (UIDropDownMenu_GetText(self) == info.text)
		UIDropDownMenu_AddButton(info, level)
	end
end

function DropdownManager.InitializeArchonMythicDropdown(self, level)
	InitializeDropdown(self, level, addon.dungeonTalents, addon.exportDialog.mplusEdit, "talentString")
end

function DropdownManager.InitializeArchonRaidDropdown(self, level)
	InitializeDropdown(self, level, addon.raidTalents, addon.exportDialog.raidEdit, "talentString")
end

function DropdownManager.InitializeWowheadMythicDropdown(self, level)
	InitializeDropdown(self, level, addon.WowheadMythicDB, addon.exportDialog.wowheadMplusEdit, "talentString")
end

function DropdownManager.InitializeWowheadRaidDropdown(self, level)
	InitializeDropdown(self, level, addon.WowheadRaidDB, addon.exportDialog.wowheadRaidEdit, "talentString")
end

function DropdownManager.InitializeWowheadMiscDropdown(self, level)
	InitializeDropdown(self, level, addon.WowheadMiscDB, addon.exportDialog.wowheadMiscEdit, "talentString")
end

return DropdownManager
