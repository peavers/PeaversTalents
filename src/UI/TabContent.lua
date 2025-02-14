local _, addon = ...
local Utils = addon.Utils
local TabContent = addon.TabContent or {}
addon.TabContent = TabContent

function TabContent.CreateEditBox(parent, name)
    local editBox = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
    editBox:SetSize(380, 32)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject(ChatFontNormal)
    editBox:EnableMouse(true)
    return editBox
end

-- Configuration for different tab types
local TAB_CONFIGS = {
    archon = {
        sections = {
            {
                name = "Mythic+",
                dropdownInitializer = "InitializeArchonMythicDropdown",
                editBoxPrefix = "archonMythic"
            },
            {
                name = "Raid",
                dropdownInitializer = "InitializeArchonRaidDropdown",
                editBoxPrefix = "archonRaid"
            }
        },
        updateKey = "archon"
    },
    wowhead = {
        sections = {
            {
                name = "Mythic+",
                dropdownInitializer = "InitializeWowheadMythicDropdown",
                editBoxPrefix = "wowheadMythic"
            },
            {
                name = "Raid",
                dropdownInitializer = "InitializeWowheadRaidDropdown",
                editBoxPrefix = "wowheadRaid"
            },
            {
                name = "Misc",
                dropdownInitializer = "InitializeWowheadMiscDropdown",
                editBoxPrefix = "wowheadMisc"
            }
        },
        updateKey = "wowhead"
    },
    icyveins = {
        sections = {
            {
                name = "Mythic+",
                dropdownInitializer = "InitializeIcyVeinsMythicDropdown",
                editBoxPrefix = "icyveinsMythic"
            },
            {
                name = "Raid",
                dropdownInitializer = "InitializeIcyVeinsRaidDropdown",
                editBoxPrefix = "icyveinsRaid"
            },
            {
                name = "Misc",
                dropdownInitializer = "InitializeIcyVeinsMiscDropdown",
                editBoxPrefix = "icyveinsMisc"
            }
        },
        updateKey = "icy-veins"
    },
    ugg = {
        sections = {
            {
                name = "Mythic+",
                dropdownInitializer = "InitializeUggMythicDropdown",
                editBoxPrefix = "uggMythic"
            },
            {
                name = "Raid",
                dropdownInitializer = "InitializeUggRaidDropdown",
                editBoxPrefix = "uggRaid"
            }
        },
        updateKey = "ugg"
    }
}

-- Generic function to create a section (Mythic+, Raid, or Misc)
local function CreateSection(dialog, tab, section, prevElement, isFirst)
    local label = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
    if isFirst then
        label:SetPoint("TOPLEFT", addon.Config.DIALOG.PADDING.SIDE, -10)
    else
        label:SetPoint("TOPLEFT", prevElement, "BOTTOMLEFT", -195, -addon.Config.DIALOG.SECTION_SPACING)
    end
    label:SetText(section.name)

    local descKey = section.name:lower():gsub("%+", "plus") .. "Desc"
    dialog[descKey] = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dialog[descKey]:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

    -- Create the dropdown
    local dropdownName = "TalentExportDialog_" .. section.name:gsub("%+", "") .. "Dropdown"
    local dropdown = CreateFrame("Frame", dropdownName, tab, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", dialog[descKey], "BOTTOMLEFT", -15, -5)
    UIDropDownMenu_SetWidth(dropdown, 150)
    dialog[section.editBoxPrefix .. "Dropdown"] = dropdown

    -- Create the edit box
    local editBox = TabContent.CreateEditBox(tab, dropdownName:gsub("Dropdown", "Edit"))
    editBox:SetPoint("LEFT", dropdown, "RIGHT", 10, 2)
    dialog[section.editBoxPrefix .. "Edit"] = editBox

    -- Set up the dropdown initialization with the edit box reference
    local initFunc = function(frame, level)
        addon.DropdownManager[section.dropdownInitializer](frame, level, section.source, section.category, editBox)
    end
    UIDropDownMenu_Initialize(dropdown, initFunc)

    return editBox
end

-- Generic function to create any type of tab
local function CreateTab(dialog, tab, tabType)
    local config = TAB_CONFIGS[tabType]
    if not config then
        error("Unknown tab type: " .. tostring(tabType))
        return
    end

    local prevElement = nil
    for i, section in ipairs(config.sections) do
        prevElement = CreateSection(dialog, tab, section, prevElement, i == 1)
    end

    local instructionsText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    instructionsText:SetPoint("BOTTOM", tab, "BOTTOM", 0, 55)
    instructionsText:SetText("Updated " .. Utils.GetFormattedUpdate(config.updateKey))
    instructionsText:SetJustifyH("CENTER")
end

-- Create specific tab functions using the generic CreateTab function
function TabContent.CreateArchonTab(dialog, tab)
    CreateTab(dialog, tab, "archon")
end

function TabContent.CreateWowheadTab(dialog, tab)
    CreateTab(dialog, tab, "wowhead")
end

function TabContent.CreateIceyVeinsTab(dialog, tab)
    CreateTab(dialog, tab, "icyveins")
end

function TabContent.CreateUggTab(dialog, tab)
    CreateTab(dialog, tab, "ugg")
end

return TabContent
