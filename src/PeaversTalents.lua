local _, addon = ...

local Utils = addon.Utils or {}
addon.Utils = Utils

local DataManager = addon.DataManager or {}
addon.DataManager = DataManager

local DropdownManager = addon.DropdownManager or {}
addon.DropdownManager = DropdownManager

local UIComponents = addon.UIComponents or {}
addon.UIComponents = UIComponents

local TabContent = addon.TabContent or {}
addon.TabContent = TabContent

local EventHandler = addon.EventHandler or {}
addon.EventHandler = EventHandler

-- Create the export dialog
local function CreateExportDialog()
    local dialog = CreateFrame("Frame", "TalentExportDialog", UIParent, "DefaultPanelTemplate")
    addon.exportDialog = dialog

    dialog:SetSize(addon.Config.DIALOG.WIDTH, addon.Config.DIALOG.HEIGHT + 30)
    dialog:SetPoint("CENTER")
    dialog:SetFrameStrata("DIALOG")
    dialog:SetFrameLevel(100)

    -- Create basic frame elements
    dialog.TitleBg = UIComponents.CreateTitleBackground(dialog)
    dialog.CloseButton = UIComponents.CreateCloseButton(dialog)

    -- Initialize tab system
    dialog.Tabs = {}
    dialog.TabContents = {}

    -- Create tabs
    dialog.Tabs[1] = UIComponents.CreateTab(dialog, 1, "Archon")
    dialog.Tabs[2] = UIComponents.CreateTab(dialog, 2, "Wowhead")
    dialog.Tabs[3] = UIComponents.CreateTab(dialog, 3, "Icy Veins")

    PanelTemplates_SetNumTabs(dialog, 3)
    PanelTemplates_SetTab(dialog, 1)

    -- Create tab contents
    for i = 1, 3 do
        dialog.TabContents[i] = UIComponents.CreateTabContent(dialog)
    end

    -- Fill tab contents
    local tab1 = dialog.TabContents[1]
    tab1:Show()
    TabContent.CreateArchonTab(dialog, tab1)

    local tab2 = dialog.TabContents[2]
    TabContent.CreateWowheadTab(dialog, tab2)

    local tab3 = dialog.TabContents[3]
    TabContent.CreateIceyVeinsTab(dialog, tab3)

    -- Frame behavior
    dialog:SetMovable(true)
    dialog:EnableMouse(true)
    dialog:RegisterForDrag("LeftButton")
    dialog:SetScript("OnDragStart", dialog.StartMoving)
    dialog:SetScript("OnDragStop", dialog.StopMovingOrSizing)
    tinsert(UISpecialFrames, dialog:GetName())

    -- OnShow handler
    dialog:SetScript("OnShow", function()
        local classID, specID = Utils.GetPlayerClassAndSpec()

        -- Update Archon dropdowns
        if #DataManager.GetAvailableEntries(addon.dungeonTalents, classID, specID) > 0 then
            UIDropDownMenu_Initialize(dialog.mplusDropdown, addon.DropdownManager.InitializeArchonMythicDropdown)
        end

        if #DataManager.GetAvailableEntries(addon.raidTalents, classID, specID) > 0 then
            UIDropDownMenu_Initialize(dialog.raidDropdown, addon.DropdownManager.InitializeArchonRaidDropdown)
        end

        -- Update Wowhead dropdowns
        if #DataManager.GetAvailableEntries(addon.WowheadMythicDB, classID, specID) > 0 then
            UIDropDownMenu_Initialize(dialog.wowheadMplusDropdown, addon.DropdownManager.InitializeWowheadMythicDropdown)
        end

        if #DataManager.GetAvailableEntries(addon.WowheadRaidDB, classID, specID) > 0 then
            UIDropDownMenu_Initialize(dialog.wowheadRaidDropdown, addon.DropdownManager.InitializeWowheadRaidDropdown)
        end

        if #DataManager.GetAvailableEntries(addon.WowheadMiscDB, classID, specID) > 0 then
            UIDropDownMenu_Initialize(dialog.wowheadMiscDropdown, addon.DropdownManager.InitializeWowheadMiscDropdown)
        end

        if not dialog.hideHooked and talentFrame then
            talentFrame:HookScript("OnHide", function()
                dialog:Hide()
            end)
            dialog.hideHooked = true
        end
    end)

    dialog:SetScript("OnHide", function()
        dialog:ClearAllPoints()
        dialog:SetPoint("CENTER")
    end)

    return dialog
end

-- Show the export dialog
function addon.ShowExportDialog()
    Utils.Debug("Showing export dialog")
    local dialog = addon.exportDialog or CreateExportDialog()
    dialog:Show()
end

-- Initialize events
EventHandler.Initialize()
