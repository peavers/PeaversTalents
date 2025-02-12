local _, addon = ...

local Utils = addon.Utils
local DataManager = addon.DataManager

local DropdownManager = addon.DropdownManager or {}
addon.DropdownManager = DropdownManager

local function InitializeDropdown(self, level, source, category, editBox)
    local info = UIDropDownMenu_CreateInfo()
    local classID, specID = Utils.GetPlayerClassAndSpec()
    local entries = DataManager.GetAvailableEntries(source, classID, specID, category)

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
        Utils.Debug("Selected key:", key)

        -- Since we already have the entries, find the matching one
        for _, entry in ipairs(entries) do
            if entry.key == key then
                editBox:SetText(entry.data.talentString or "")
                editBox:SetCursorPosition(0)
                UIDropDownMenu_SetText(self, entry.data.label or tostring(key))
                break
            end
        end
    end

    -- Sort entries by name if label exists
    table.sort(entries, function(a, b)
        if a.data.label and b.data.label then
            return a.data.label < b.data.label
        end
        return a.key < b.key
    end)

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

-- Update dropdown initializers with categories
function DropdownManager.InitializeArchonMythicDropdown(self, level)
    InitializeDropdown(self, level, "archon", "mythic", addon.exportDialog.mplusEdit)
end

function DropdownManager.InitializeArchonRaidDropdown(self, level)
    InitializeDropdown(self, level, "archon", "raid", addon.exportDialog.raidEdit)
end

function DropdownManager.InitializeWowheadMythicDropdown(self, level)
    InitializeDropdown(self, level, "wowhead", "mythic", addon.exportDialog.wowheadMplusEdit)
end

function DropdownManager.InitializeWowheadRaidDropdown(self, level)
    InitializeDropdown(self, level, "wowhead", "raid", addon.exportDialog.wowheadRaidEdit)
end

function DropdownManager.InitializeWowheadMiscDropdown(self, level)
    InitializeDropdown(self, level, "wowhead", "misc", addon.exportDialog.wowheadMiscEdit)
end

function DropdownManager.InitializeIcyVeinsMythicDropdown(self, level)
    InitializeDropdown(self, level, "icy-veins", "mythic", addon.exportDialog.icyveinsMplusEdit)
end

function DropdownManager.InitializeIcyVeinsRaidDropdown(self, level)
    InitializeDropdown(self, level, "icy-veins", "raid", addon.exportDialog.icyveinsRaidEdit)
end

function DropdownManager.InitializeIcyVeinsMiscDropdown(self, level)
    InitializeDropdown(self, level, "icy-veins", "misc", addon.exportDialog.icyveinsMiscEdit)
end

return DropdownManager
