local _, addon = ...

-- Initialize ConfigUI.lua namespace
local ConfigUI = {}
addon.ConfigUI = ConfigUI

-- Access PeaversCommons utilities
local PeaversCommons = _G.PeaversCommons
local ConfigUIUtils = PeaversCommons.ConfigUIUtils
local FrameUtils = PeaversCommons.FrameUtils

-- Creates and initializes the options panel
function ConfigUI:InitializeOptions()
    -- Use the ConfigUIUtils to create a standard settings panel
    local panel = ConfigUIUtils.CreateSettingsPanel(
        "Settings",
        "Import talent builds from popular sources"
    )
    
    local content = panel.content
    local yPos = panel.yPos
    local baseSpacing = panel.baseSpacing
    
    -- Add information section
    local infoHeader, newY = FrameUtils.CreateSectionHeader(content, "How to Use", baseSpacing, yPos)
    yPos = newY - 10
    
    -- Create information text
    local infoText = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    infoText:SetPoint("TOPLEFT", baseSpacing + 15, yPos)
    infoText:SetWidth(450)
    infoText:SetJustifyH("LEFT")
    infoText:SetSpacing(2)
    infoText:SetText(
        "This addon adds a 'Builds' button to your talent UI that allows you to import talent builds from popular sources.\n\n" ..
        "1. Open your talent UI (press 'N' by default)\n" ..
        "2. Click the 'Builds' button next to the search box\n" ..
        "3. Select a source (Archon, Wowhead, Icy Veins, or U.GG)\n" ..
        "4. Choose a build category (Mythic, Raid, etc.)\n" ..
        "5. Select a specific build from the dropdown\n" ..
        "6. Click 'Import' to apply the build to your character"
    )
    
    -- Calculate height of text and update yPos
    local textHeight = infoText:GetStringHeight() + 20
    yPos = yPos - textHeight
    
    -- Update content height
    panel:UpdateContentHeight(yPos)
    
    return panel
end

-- Initialize the configuration UI when called
function ConfigUI:Initialize()
    self.panel = self:InitializeOptions()
end
