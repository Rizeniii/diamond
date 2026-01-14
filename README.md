# Cat Hub UI

A modern Roblox UI library focused on clean visuals, smooth animations, and easy customization.  
Works on PC and mobile with built-in settings, themes, and persistent config.

---

## Basic Example Usage

```lua
local ModernUI = loadstring(game:HttpGet("URL_DO_SEU_SCRIPT"))()

local UI = ModernUI.new({
    Title = "Example UI",
    SubTitle = "Basic Usage",
    Icon = {
        "rbxassetid://138770682187300",
        "rbxassetid://110961158970233"
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

-- SECOND SECTION
UI:AddSection(MainTab, {
    Name = "Visual Settings"
})

-- SECOND TOGGLE
UI:AddToggle(MainTab, {
    Name = "ESP",
    Default = true,
    Callback = function(state)
        print("ESP:", state)
    end
})

-- SECOND DROPDOWN
UI:AddDropdown(MainTab, {
    Name = "ESP Color",
    Options = { "Red", "Green", "Blue" },
    Default = "Red",
    Callback = function(value)
        print("ESP Color:", value)
    end
})
