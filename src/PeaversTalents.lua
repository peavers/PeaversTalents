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

-- Helper function to check if data addon is loaded and accessible
local function CheckDataAddonLoaded()
    if not PeaversTalentsData then
        Utils.Debug("PeaversTalentsData addon not found!")
        return false
    end
    return true
end

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
    dialog.Tabs[4] = UIComponents.CreateTab(dialog, 4, "U.GG")

    PanelTemplates_SetNumTabs(dialog, 4)
    PanelTemplates_SetTab(dialog, 1)

    -- Create tab contents
    for i = 1, 4 do
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

    local tab4 = dialog.TabContents[4]
    TabContent.CreateUggTab(dialog, tab4)

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

        -- Check if data addon is loaded
        if not CheckDataAddonLoaded() then
            return
        end

        -- Get all available sources
        local sources = PeaversTalentsData.API.GetSources()

        -- Initialize Archon dropdowns
        if Utils.TableContains(sources, "archon") then
            local builds = PeaversTalentsData.API.GetBuilds(classID, specID, "archon")
            if builds and #builds > 0 then
                UIDropDownMenu_Initialize(dialog.archonMythicDropdown, addon.DropdownManager.InitializeArchonMythicDropdown)
                UIDropDownMenu_Initialize(dialog.archonRaidDropdown, addon.DropdownManager.InitializeArchonRaidDropdown)
            end
        end

        -- Initialize Wowhead dropdowns
        if Utils.TableContains(sources, "wowhead") then
            local builds = PeaversTalentsData.API.GetBuilds(classID, specID, "wowhead")
            if builds and #builds > 0 then
                UIDropDownMenu_Initialize(dialog.wowheadMythicDropdown, addon.DropdownManager.InitializeWowheadMythicDropdown)
                UIDropDownMenu_Initialize(dialog.wowheadRaidDropdown, addon.DropdownManager.InitializeWowheadRaidDropdown)
                UIDropDownMenu_Initialize(dialog.wowheadMiscDropdown, addon.DropdownManager.InitializeWowheadMiscDropdown)
            end
        end

        -- Initialize Icy Veins dropdowns
        if Utils.TableContains(sources, "icy-veins") then
            local builds = PeaversTalentsData.API.GetBuilds(classID, specID, "icy-veins")
            if builds and #builds > 0 then
                UIDropDownMenu_Initialize(dialog.icyveinsMythicDropdown, addon.DropdownManager.InitializeIcyVeinsMythicDropdown)
                UIDropDownMenu_Initialize(dialog.icyveinsRaidDropdown, addon.DropdownManager.InitializeIcyVeinsRaidDropdown)
                UIDropDownMenu_Initialize(dialog.icyveinsMiscDropdown, addon.DropdownManager.InitializeIcyVeinsMiscDropdown)
            end
        end

		-- Initialize U.GG dropdowns
		if Utils.TableContains(sources, "ugg") then
			local builds = PeaversTalentsData.API.GetBuilds(classID, specID, "ugg")
			if builds and #builds > 0 then
				UIDropDownMenu_Initialize(dialog.uggMythicDropdown, addon.DropdownManager.InitializeUggMythicDropdown)
				UIDropDownMenu_Initialize(dialog.uggRaidDropdown, addon.DropdownManager.InitializeUggRaidDropdown)
			end
		end

        -- Handle tab visibility based on available data
        for i, tab in ipairs(dialog.Tabs) do
            local source = i == 1 and "archon" or i == 2 and "wowhead" or i == 3 and "icy-veins" or i == 4 and "ugg"
            local hasData = Utils.TableContains(sources, source) and
                           PeaversTalentsData.API.GetBuilds(classID, specID, source) and
                           #PeaversTalentsData.API.GetBuilds(classID, specID, source) > 0

            if hasData then
                tab:Show()
            else
                tab:Hide()
            end
        end

        -- Hook the hide script if not already done
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

-- Helper function for source checking
function Utils.TableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

-- Initialize events
EventHandler.Initialize()
