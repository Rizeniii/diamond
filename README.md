# Cat Hub UI

A modern Roblox UI library focused on clean visuals, smooth animations, and easy customization.  
Works on PC and mobile with built-in settings, themes, and persistent config.

---

## Features

- 🎨 6 Built-in themes (White, Red, Purple, Yellow, Green, Blue)
- 💾 Automatic config saving/loading
- 📱 Mobile & PC support
- 🎯 Draggable & resizable windows
- 🔔 Notification system
- 🌊 Acrylic transparency effects
- 🖼️ Custom background images
- ⚙️ Built-in settings window
- 🎮 Floating button for quick access
- 💬 Discord invite integration

---

## Basic Example Usage

```lua
local ModernUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rizeniii/diamond/refs/heads/main/zero/main.luau"))()

local UI = ModernUI.new({
    Title = "Example UI",
    SubTitle = "Basic Usage",
    Icon = {
        "rbxassetid://138770682187300",
        "rbxassetid://110961158970233"
    },
    IconFPS = 0.1,
    FloatingButton = {
        Icon = {"rbxassetid://138770682187300", "rbxassetid://110961158970233"},
        Size = 52,
        Position = UDim2.new(1, -70, 0.5, -26)
    }
})

-- TAB
local MainTab = UI:CreateTab({
    Name = "Main",
    Icon = {
        "rbxassetid://138770682187300",
        "rbxassetid://110961158970233"
    }
})

-- DISCORD INVITE
UI:AddInviteDiscord(MainTab, {
    Name = "My Discord Server",
    Link = "discord.gg/example",
    Icon = "rbxassetid://138770682187300",
    ButtonText = "Join"
})

-- SECTION
UI:AddSection(MainTab, {
    Name = "Core Features"
})

-- TOGGLE
UI:AddToggle(MainTab, {
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

-- DROPDOWN
UI:AddDropdown(MainTab, {
    Name = "Select Mode",
    Options = { "Easy", "Normal", "Hard" },
    Default = "Normal",
    Callback = function(value)
        print("Selected Mode:", value)
    end
})

-- MULTI DROPDOWN
UI:AddMultiDropdown(MainTab, {
    Name = "Select Items",
    Options = { "Sword", "Gun", "Fruit" },
    Default = { "Sword" },
    Callback = function(selected)
        print("Selected Items:", table.concat(selected, ", "))
    end
})

-- BUTTON
UI:AddButton(MainTab, {
    Name = "Execute Action",
    Callback = function()
        print("Button clicked!")
    end
})

-- SLIDER
UI:AddSlider(MainTab, {
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        print("Walk Speed:", value)
    end
})
API Reference
Window Creation
ModernUI.new({
    Title = "Window Title",
    SubTitle = "Subtitle Text",
    Icon = {"rbxassetid://id1", "rbxassetid://id2"}, -- Array of icons for animation
    IconFPS = 0.1, -- Animation speed
    FloatingButton = {
        Icon = {"rbxassetid://id1", "rbxassetid://id2"},
        Size = 52,
        Position = UDim2.new(1, -70, 0.5, -26)
    }
})
Tab Creation
UI:CreateTab({
    Name = "Tab Name",
    Icon = {"rbxassetid://id1", "rbxassetid://id2"}
})
Elements
Section
UI:AddSection(tab, {
    Name = "Section Name"
})
Discord Invite
UI:AddInviteDiscord(tab, {
    Name = "Discord Server Name",
    Link = "discord.gg/invite",
    Icon = "rbxassetid://servericon",
    ButtonText = "Join" -- Optional, defaults to "Join"
})
Toggle
UI:AddToggle(tab, {
    Name = "Toggle Name",
    Default = false,
    Callback = function(state)
        -- Your code here
    end
})
Dropdown
UI:AddDropdown(tab, {
    Name = "Dropdown Name",
    Options = { "Option1", "Option2", "Option3" },
    Default = "Option1",
    Callback = function(selected)
        -- Your code here
    end
})
Multi Dropdown
UI:AddMultiDropdown(tab, {
    Name = "Multi Select",
    Options = { "Option1", "Option2", "Option3" },
    Default = { "Option1" },
    Callback = function(selected)
        -- selected is an array of selected options
    end
})
Button
UI:AddButton(tab, {
    Name = "Button Name",
    Callback = function()
        -- Your code here
    end
})
Slider
UI:AddSlider(tab, {
    Name = "Slider Name",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        -- Your code here
    end
})
Notification System
UI:Notify({
    Title = "Notification Title",
    Body = "Notification message",
    Icon = {"rbxassetid://id1", "rbxassetid://id2"},
    Duration = 5 -- Seconds
})
Theme Management
-- Apply theme
UI:ApplyTheme("Red") -- White, Red, Purple, Yellow, Green, Blue

-- Apply acrylic effect
UI:ApplyAcrylic(true) -- true = transparent, false = solid

-- Apply background image
UI:ApplyBackgroundImage("rbxassetid://imageid", 0.3) -- transparency 0-1
Floating Button
-- Update floating button dynamically
UI:UpdateFloatingButton({
    Icon = {"rbxassetid://newid1", "rbxassetid://newid2"},
    Size = 60,
    Position = UDim2.new(1, -80, 0.5, -30)
})
Utility Functions
-- Toggle UI visibility
UI:ToggleUI()

-- Save config manually
UI:SaveConfig()

-- Load config manually
UI:LoadConfig()
