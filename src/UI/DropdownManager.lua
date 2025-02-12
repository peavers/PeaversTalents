local _, addon = ...

local Utils = addon.Utils
local DataManager = addon.DataManager

local DropdownManager = addon.DropdownManager or {}
addon.DropdownManager = DropdownManager

local function InitializeDropdown(self, level, database, editBox, talentsKey)
	local info = UIDropDownMenu_CreateInfo()
	local classID, specID = Utils.GetPlayerClassAndSpec()
	local entries = DataManager.GetAvailableEntries(database, classID, specID)

	-- Check if there's no data
	if #entries == 0 then
		info.text = "No data found"
		info.disabled = true
		info.notClickable = true
		UIDropDownMenu_AddButton(info, level)
		UIDropDownMenu_SetText(self, "No data found")
		UIDropDownMenu_DisableDropDown(self)
		return
	end

    -- Set initial "Select" text if no selection has been made
    if UIDropDownMenu_GetText(self) == "" or UIDropDownMenu_GetText(self) == nil then
        UIDropDownMenu_SetText(self, "Select...")
    end

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

    for _, entry in ipairs(entries) do
        info.text = entry.data.label or entry.key
        info.value = entry.key
        info.disabled = false
        info.notClickable = false
        info.checked = (UIDropDownMenu_GetText(self) == info.text)
        UIDropDownMenu_AddButton(info, level)
    end

    UIDropDownMenu_EnableDropDown(self)
end

function DropdownManager.InitializeArchonMythicDropdown(self, level)
    InitializeDropdown(self, level, addon.ArchonMythicDB, addon.exportDialog.mplusEdit, "talentString")
end

function DropdownManager.InitializeArchonRaidDropdown(self, level)
    InitializeDropdown(self, level, addon.ArchonRaidDB, addon.exportDialog.raidEdit, "talentString")
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

function DropdownManager.InitializeIcyVeinsMythicDropdown(self, level)
    InitializeDropdown(self, level, addon.IcyVeinsMythicDB, addon.exportDialog.icyveinsMplusEdit, "talentString")
end

function DropdownManager.InitializeIcyVeinsRaidDropdown(self, level)
    InitializeDropdown(self, level, addon.IcyVeinsRaidDB, addon.exportDialog.icyveinsRaidEdit, "talentString")
end

function DropdownManager.InitializeIcyVeinsMiscDropdown(self, level)
    InitializeDropdown(self, level, addon.IcyVeinsMiscDB, addon.exportDialog.icyveinsMiscEdit, "talentString")
end

return DropdownManager
