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

function TabContent.CreateArchonTab(dialog, tab)
	-- Mythic+ Section
	local mplusLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	mplusLabel:SetPoint("TOPLEFT", addon.Config.DIALOG.PADDING.SIDE, -10)
	mplusLabel:SetText("Mythic+")

	dialog.mplusDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.mplusDesc:SetPoint("TOPLEFT", mplusLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.mplusDropdown = CreateFrame("Frame", "TalentExportDialog_MplusDropdown", tab, "UIDropDownMenuTemplate")
	dialog.mplusDropdown:SetPoint("TOPLEFT", dialog.mplusDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.mplusDropdown, 150)
	UIDropDownMenu_Initialize(dialog.mplusDropdown, addon.DropdownManager.InitializeArchonMythicDropdown)

	dialog.mplusEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_MplusEdit")
	dialog.mplusEdit:SetPoint("LEFT", dialog.mplusDropdown, "RIGHT", 10, 2)

	-- Raid Section
	local raidLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	raidLabel:SetPoint("TOPLEFT", dialog.mplusEdit, "BOTTOMLEFT", -195, -addon.Config.DIALOG.SECTION_SPACING)
	raidLabel:SetText("Raid")

	dialog.raidDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.raidDesc:SetPoint("TOPLEFT", raidLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.raidDropdown = CreateFrame("Frame", "TalentExportDialog_RaidDropdown", tab, "UIDropDownMenuTemplate")
	dialog.raidDropdown:SetPoint("TOPLEFT", dialog.raidDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.raidDropdown, 150)
	UIDropDownMenu_Initialize(dialog.raidDropdown, addon.DropdownManager.InitializeArchonRaidDropdown)

	dialog.raidEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_RaidEdit")
	dialog.raidEdit:SetPoint("LEFT", dialog.raidDropdown, "RIGHT", 10, 2)

	local instructionsText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	instructionsText:SetPoint("BOTTOM", tab, "BOTTOM", 0, 55)
	instructionsText:SetText("Select a build to copy the latest talent string | Builds as of " .. Utils.GetFormattedLocalTime(addon.ArchonMythicDB.updated))
	instructionsText:SetJustifyH("CENTER")
end

function TabContent.CreateWowheadTab(dialog, tab)
	-- Mythic+ Section
	local mplusLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	mplusLabel:SetPoint("TOPLEFT", addon.Config.DIALOG.PADDING.SIDE, -10)
	mplusLabel:SetText("Mythic+")

	dialog.wowheadMplusDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.wowheadMplusDesc:SetPoint("TOPLEFT", mplusLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.wowheadMplusDropdown = CreateFrame("Frame", "TalentExportDialog_WowheadMplusDropdown", tab, "UIDropDownMenuTemplate")
	dialog.wowheadMplusDropdown:SetPoint("TOPLEFT", dialog.wowheadMplusDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.wowheadMplusDropdown, 150)
	UIDropDownMenu_Initialize(dialog.wowheadMplusDropdown, addon.DropdownManager.InitializeWowheadMythicDropdown)

	dialog.wowheadMplusEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_WowheadMplusEdit")
	dialog.wowheadMplusEdit:SetPoint("LEFT", dialog.wowheadMplusDropdown, "RIGHT", 10, 2)

	-- Raid Section
	local raidLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	raidLabel:SetPoint("TOPLEFT", dialog.wowheadMplusEdit, "BOTTOMLEFT", -195, -addon.Config.DIALOG.SECTION_SPACING)
	raidLabel:SetText("Raid")

	dialog.wowheadRaidDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.wowheadRaidDesc:SetPoint("TOPLEFT", raidLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.wowheadRaidDropdown = CreateFrame("Frame", "TalentExportDialog_WowheadRaidDropdown", tab, "UIDropDownMenuTemplate")
	dialog.wowheadRaidDropdown:SetPoint("TOPLEFT", dialog.wowheadRaidDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.wowheadRaidDropdown, 150)
	UIDropDownMenu_Initialize(dialog.wowheadRaidDropdown, addon.DropdownManager.InitializeWowheadRaidDropdown)

	dialog.wowheadRaidEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_WowheadRaidEdit")
	dialog.wowheadRaidEdit:SetPoint("LEFT", dialog.wowheadRaidDropdown, "RIGHT", 10, 2)

	-- Misc Section
	local miscLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	miscLabel:SetPoint("TOPLEFT", dialog.wowheadRaidEdit, "BOTTOMLEFT", -195, -addon.Config.DIALOG.SECTION_SPACING)
	miscLabel:SetText("Misc")

	dialog.wowheadMiscDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.wowheadMiscDesc:SetPoint("TOPLEFT", miscLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.wowheadMiscDropdown = CreateFrame("Frame", "TalentExportDialog_WowheadMiscDropdown", tab, "UIDropDownMenuTemplate")
	dialog.wowheadMiscDropdown:SetPoint("TOPLEFT", dialog.wowheadMiscDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.wowheadMiscDropdown, 150)
	UIDropDownMenu_Initialize(dialog.wowheadMiscDropdown, addon.DropdownManager.InitializeWowheadMiscDropdown)

	dialog.wowheadMiscEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_WowheadMiscEdit")
	dialog.wowheadMiscEdit:SetPoint("LEFT", dialog.wowheadMiscDropdown, "RIGHT", 10, 2)

	local instructionsText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	instructionsText:SetPoint("BOTTOM", tab, "BOTTOM", 0, 55)
	instructionsText:SetText("Select a build to copy the latest talent string | Builds as of " .. Utils.GetFormattedLocalTime(addon.WowheadMythicDB.updated))
	instructionsText:SetJustifyH("CENTER")
end

function TabContent.CreateIceyVeinsTab(dialog, tab)
	-- Mythic+ Section
	local mplusLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	mplusLabel:SetPoint("TOPLEFT", addon.Config.DIALOG.PADDING.SIDE, -10)
	mplusLabel:SetText("Mythic+")

	dialog.iceveinsMplusDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.iceveinsMplusDesc:SetPoint("TOPLEFT", mplusLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.iceveinsMplusDropdown = CreateFrame("Frame", "TalentExportDialog_IceveinsMplusDropdown", tab, "UIDropDownMenuTemplate")
	dialog.iceveinsMplusDropdown:SetPoint("TOPLEFT", dialog.iceveinsMplusDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.iceveinsMplusDropdown, 150)
	UIDropDownMenu_Initialize(dialog.iceveinsMplusDropdown, addon.DropdownManager.InitializeIcyVeinsMythicDropdown)

	dialog.iceveinsMplusEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_IcyVeinsMplusEdit")
	dialog.iceveinsMplusEdit:SetPoint("LEFT", dialog.iceveinsMplusDropdown, "RIGHT", 10, 2)

	-- Raid Section
	local raidLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	raidLabel:SetPoint("TOPLEFT", dialog.iceveinsMplusEdit, "BOTTOMLEFT", -195, -addon.Config.DIALOG.SECTION_SPACING)
	raidLabel:SetText("Raid")

	dialog.iceveinsRaidDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.iceveinsRaidDesc:SetPoint("TOPLEFT", raidLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.iceveinsRaidDropdown = CreateFrame("Frame", "TalentExportDialog_IcyVeinsRaidDropdown", tab, "UIDropDownMenuTemplate")
	dialog.iceveinsRaidDropdown:SetPoint("TOPLEFT", dialog.iceveinsRaidDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.iceveinsRaidDropdown, 150)
	UIDropDownMenu_Initialize(dialog.iceveinsRaidDropdown, addon.DropdownManager.InitializeIcyVeinsRaidDropdown)

	dialog.iceveinsRaidEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_IcyVeinsRaidEdit")
	dialog.iceveinsRaidEdit:SetPoint("LEFT", dialog.iceveinsRaidDropdown, "RIGHT", 10, 2)

	-- Misc Section
	local miscLabel = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	miscLabel:SetPoint("TOPLEFT", dialog.iceveinsRaidEdit, "BOTTOMLEFT", -195, -addon.Config.DIALOG.SECTION_SPACING)
	miscLabel:SetText("Misc")

	dialog.iceveinsMiscDesc = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	dialog.iceveinsMiscDesc:SetPoint("TOPLEFT", miscLabel, "BOTTOMLEFT", 0, -addon.Config.DIALOG.PADDING.LABEL)

	dialog.iceveinsMiscDropdown = CreateFrame("Frame", "TalentExportDialog_IcyVeinsMiscDropdown", tab, "UIDropDownMenuTemplate")
	dialog.iceveinsMiscDropdown:SetPoint("TOPLEFT", dialog.iceveinsMiscDesc, "BOTTOMLEFT", -15, -5)
	UIDropDownMenu_SetWidth(dialog.iceveinsMiscDropdown, 150)
	UIDropDownMenu_Initialize(dialog.iceveinsMiscDropdown, addon.DropdownManager.InitializeIcyVeinsMiscDropdown)

	dialog.iceveinsMiscEdit = TabContent.CreateEditBox(tab, "TalentExportDialog_IcyVeinsMiscEdit")
	dialog.iceveinsMiscEdit:SetPoint("LEFT", dialog.iceveinsMiscDropdown, "RIGHT", 10, 2)

	local instructionsText = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	instructionsText:SetPoint("BOTTOM", tab, "BOTTOM", 0, 55)
	instructionsText:SetText("Select a build to copy the latest talent string | Builds as of " .. Utils.GetFormattedLocalTime(addon.IcyVeinsMythicDB.updated))
	instructionsText:SetJustifyH("CENTER")
end

return TabContent
