local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local COLORS = {
    Background = Color3.fromRGB(10, 10, 10),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(128, 128, 128),
    Black = Color3.fromRGB(0, 0, 0)
}

local ICONS = {
    DropdownClosed = "rbxassetid://116845122064768",
    DropdownOpen = "rbxassetid://132854725146991",
    Button = "rbxassetid://110294213486252"
}

local function createTween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

function UILibrary.new(config)
    local self = {}
    self.Title = config.Title or "UI Library"
    self.Subtitle = config.Subtitle or "Subtitle"
    self.Icon = config.Icon or ""
    self.Components = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 80)
    Header.BackgroundColor3 = COLORS.Background
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderLeft = Instance.new("Frame")
    HeaderLeft.Name = "Left"
    HeaderLeft.Size = UDim2.new(0.7, 0, 1, 0)
    HeaderLeft.BackgroundTransparency = 1
    HeaderLeft.Parent = Header
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 50, 0, 50)
    IconLabel.Position = UDim2.new(0, 15, 0.5, -25)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = self.Icon
    IconLabel.ImageColor3 = COLORS.White
    IconLabel.Parent = HeaderLeft
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 400, 0, 30)
    TitleLabel.Position = UDim2.new(0, 75, 0, 15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = HeaderLeft
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(0, 400, 0, 20)
    SubtitleLabel.Position = UDim2.new(0, 75, 0, 45)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.Subtitle
    SubtitleLabel.TextColor3 = COLORS.Gray
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextSize = 14
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = HeaderLeft
    
    local HeaderRight = Instance.new("Frame")
    HeaderRight.Name = "Right"
    HeaderRight.Size = UDim2.new(0.3, 0, 1, 0)
    HeaderRight.Position = UDim2.new(0.7, 0, 0, 0)
    HeaderRight.BackgroundTransparency = 1
    HeaderRight.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
    CloseButton.BackgroundColor3 = COLORS.Background
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = COLORS.White
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = HeaderRight
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -100, 0.5, -20)
    MinimizeButton.BackgroundColor3 = COLORS.Background
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = COLORS.White
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 24
    MinimizeButton.Parent = HeaderRight
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeButton
    
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -80)
    Sidebar.Position = UDim2.new(0, 0, 0, 80)
    Sidebar.BackgroundColor3 = COLORS.Background
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 4
    Sidebar.ScrollBarImageColor3 = COLORS.Gray
    Sidebar.Parent = MainFrame
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -150, 1, -80)
    ContentFrame.Position = UDim2.new(0, 150, 0, 80)
    ContentFrame.BackgroundColor3 = COLORS.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = COLORS.Gray
    ContentFrame.Parent = MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = ContentFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    ContentPadding.Parent = ContentFrame
    
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Size = UDim2.new(0, 400, 0, 80)
    MinimizedFrame.Position = UDim2.new(0.5, -200, 0.5, -40)
    MinimizedFrame.BackgroundColor3 = COLORS.Background
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = ScreenGui
    
    local MinCornerFrame = Instance.new("UICorner")
    MinCornerFrame.CornerRadius = UDim.new(0, 8)
    MinCornerFrame.Parent = MinimizedFrame
    
    local MinStroke = Instance.new("UIStroke")
    MinStroke.Color = COLORS.Gray
    MinStroke.Thickness = 2
    MinStroke.Parent = MinimizedFrame
    
    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Size = UDim2.new(0, 50, 0, 50)
    MinIcon.Position = UDim2.new(0, 15, 0.5, -25)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Image = self.Icon
    MinIcon.ImageColor3 = COLORS.White
    MinIcon.Parent = MinimizedFrame
    
    local MinTitle = Instance.new("TextLabel")
    MinTitle.Size = UDim2.new(0, 250, 0, 30)
    MinTitle.Position = UDim2.new(0, 75, 0, 15)
    MinTitle.BackgroundTransparency = 1
    MinTitle.Text = self.Title
    MinTitle.TextColor3 = COLORS.White
    MinTitle.Font = Enum.Font.GothamBold
    MinTitle.TextSize = 16
    MinTitle.TextXAlignment = Enum.TextXAlignment.Left
    MinTitle.Parent = MinimizedFrame
    
    local MinSubtitle = Instance.new("TextLabel")
    MinSubtitle.Size = UDim2.new(0, 250, 0, 20)
    MinSubtitle.Position = UDim2.new(0, 75, 0, 45)
    MinSubtitle.BackgroundTransparency = 1
    MinSubtitle.Text = self.Subtitle
    MinSubtitle.TextColor3 = COLORS.Gray
    MinSubtitle.Font = Enum.Font.Gotham
    MinSubtitle.TextSize = 12
    MinSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    MinSubtitle.Parent = MinimizedFrame
    
    local RestoreButton = Instance.new("TextButton")
    RestoreButton.Size = UDim2.new(0, 50, 0, 50)
    RestoreButton.Position = UDim2.new(1, -65, 0.5, -25)
    RestoreButton.BackgroundColor3 = COLORS.Background
    RestoreButton.BorderSizePixel = 0
    RestoreButton.Text = "+"
    RestoreButton.TextColor3 = COLORS.White
    RestoreButton.Font = Enum.Font.GothamBold
    RestoreButton.TextSize = 24
    RestoreButton.Parent = MinimizedFrame
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(0, 6)
    RestoreCorner.Parent = RestoreButton
    
    local dragging = false
    local dragInput, mousePos, framePos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Size = UDim2.new(0, 300, 0, 150)
        ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
        ConfirmFrame.BackgroundColor3 = COLORS.Background
        ConfirmFrame.BorderSizePixel = 0
        ConfirmFrame.Parent = ScreenGui
        
        local ConfCorner = Instance.new("UICorner")
        ConfCorner.CornerRadius = UDim.new(0, 8)
        ConfCorner.Parent = ConfirmFrame
        
        local ConfStroke = Instance.new("UIStroke")
        ConfStroke.Color = COLORS.White
        ConfStroke.Thickness = 2
        ConfStroke.Parent = ConfirmFrame
        
        local ConfText = Instance.new("TextLabel")
        ConfText.Size = UDim2.new(1, -20, 0, 60)
        ConfText.Position = UDim2.new(0, 10, 0, 20)
        ConfText.BackgroundTransparency = 1
        ConfText.Text = "Are you sure you want to close?"
        ConfText.TextColor3 = COLORS.White
        ConfText.Font = Enum.Font.Gotham
        ConfText.TextSize = 16
        ConfText.TextWrapped = true
        ConfText.Parent = ConfirmFrame
        
        local YesButton = Instance.new("TextButton")
        YesButton.Size = UDim2.new(0, 120, 0, 40)
        YesButton.Position = UDim2.new(0, 20, 1, -60)
        YesButton.BackgroundColor3 = COLORS.White
        YesButton.Text = "Yes"
        YesButton.TextColor3 = COLORS.Background
        YesButton.Font = Enum.Font.GothamBold
        YesButton.TextSize = 14
        YesButton.Parent = ConfirmFrame
        
        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 6)
        YesCorner.Parent = YesButton
        
        local NoButton = Instance.new("TextButton")
        NoButton.Size = UDim2.new(0, 120, 0, 40)
        NoButton.Position = UDim2.new(1, -140, 1, -60)
        NoButton.BackgroundColor3 = COLORS.Gray
        NoButton.Text = "No"
        NoButton.TextColor3 = COLORS.White
        NoButton.Font = Enum.Font.GothamBold
        NoButton.TextSize = 14
        NoButton.Parent = ConfirmFrame
        
        local NoCorner = Instance.new("UICorner")
        NoCorner.CornerRadius = UDim.new(0, 6)
        NoCorner.Parent = NoButton
        
        YesButton.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        NoButton.MouseButton1Click:Connect(function()
            ConfirmFrame:Destroy()
        end)
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self.IsMinimized = true
        createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        createTween(MinimizedFrame, {Size = UDim2.new(0, 400, 0, 80)}, 0.3)
    end)
    
    RestoreButton.MouseButton1Click:Connect(function()
        self.IsMinimized = false
        createTween(MinimizedFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
        createTween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
    end)
    
    self.GUI = ScreenGui
    self.MainFrame = MainFrame
    self.Sidebar = Sidebar
    self.ContentFrame = ContentFrame
    self.SidebarList = SidebarList
    self.ContentList = ContentList
    
    function self:CreateTab(name, icon)
        local tab = {}
        tab.Name = name
        tab.Icon = icon or ""
        tab.Components = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.BackgroundColor3 = COLORS.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.Parent = self.Sidebar
        
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 3, 1, 0)
        TabIndicator.Position = UDim2.new(0, 0, 0, 0)
        TabIndicator.BackgroundColor3 = COLORS.White
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Visible = false
        TabIndicator.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 15, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ImageColor3 = COLORS.White
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -50, 1, 0)
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = COLORS.White
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = self.ContentFrame
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 10)
        TabContentList.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(self.Tabs) do
                existingTab.Button:FindFirstChild("Indicator").Visible = false
                existingTab.Content.Visible = false
            end
            
            TabIndicator.Visible = true
            TabContent.Visible = true
            self.CurrentTab = tab
            
            createTween(TabButton, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}, 0.2)
        end)
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.ContentList = TabContentList
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            TabIndicator.Visible = true
            TabContent.Visible = true
            self.CurrentTab = tab
        end
        
        function tab:AddToggle(name, default, callback)
            local toggle = {}
            toggle.Name = name
            toggle.Value = default or false
            toggle.Callback = callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -30, 0, 40)
            ToggleFrame.BackgroundColor3 = COLORS.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = COLORS.White
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 24)
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
            ToggleButton.BackgroundColor3 = toggle.Value and COLORS.White or COLORS.Gray
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = toggle.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            ToggleCircle.BackgroundColor3 = COLORS.Background
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggle.Value = not toggle.Value
                
                createTween(ToggleButton, {BackgroundColor3 = toggle.Value and COLORS.White or COLORS.Gray}, 0.3)
                createTween(ToggleCircle, {Position = toggle.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.3)
                
                toggle.Callback(toggle.Value)
            end)
            
            table.insert(tab.Components, toggle)
            return toggle
        end
        
        function tab:AddDropdown(name, options, default, multiSelect, callback)
            local dropdown = {}
            dropdown.Name = name
            dropdown.Options = options or {}
            dropdown.Selected = multiSelect and {} or (default or options[1])
            dropdown.MultiSelect = multiSelect or false
            dropdown.Callback = callback or function() end
            dropdown.IsOpen = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -30, 0, 40)
            DropdownFrame.BackgroundColor3 = COLORS.Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            
            local DropdownHeader = Instance.new("TextButton")
            DropdownHeader.Size = UDim2.new(1, 0, 0, 40)
            DropdownHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            DropdownHeader.BorderSizePixel = 0
            DropdownHeader.Text = ""
            DropdownHeader.Parent = DropdownFrame
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropdownHeader
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0.5, 0, 1, 0)
            DropLabel.Position = UDim2.new(0, 10, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = name
            DropLabel.TextColor3 = COLORS.White
            DropLabel.Font = Enum.Font.Gotham
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropdownHeader
            
            local DropSelected = Instance.new("TextLabel")
            DropSelected.Size = UDim2.new(0.4, 0, 1, 0)
            DropSelected.Position = UDim2.new(0.5, 0, 0, 0)
            DropSelected.BackgroundTransparency = 1
            DropSelected.Text = multiSelect and "" or (default or options[1])
            DropSelected.TextColor3 = COLORS.White
            DropSelected.Font = Enum.Font.GothamBold
            DropSelected.TextSize = 13
            DropSelected.TextXAlignment = Enum.TextXAlignment.Right
            DropSelected.Parent = DropdownHeader
            
            local DropIcon = Instance.new("ImageLabel")
            DropIcon.Size = UDim2.new(0, 20, 0, 20)
            DropIcon.Position = UDim2.new(1, -30, 0.5, -10)
            DropIcon.BackgroundTransparency = 1
            DropIcon.Image = ICONS.DropdownClosed
            DropIcon.ImageColor3 = COLORS.White
            DropIcon.Parent = DropdownHeader
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 0, 45)
            DropdownList.BackgroundColor3 = COLORS.Black
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.Parent = DropdownFrame
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = DropdownList
            
            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = COLORS.Gray
            ListStroke.Thickness = 1
            ListStroke.Parent = DropdownList
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 2)
            OptionsLayout.Parent = DropdownList
            
            local function updateDropdown()
                if multiSelect then
                    local selectedText = ""
                    for i, opt in pairs(dropdown.Selected) do
                        selectedText = selectedText .. opt
                        if i < #dropdown.Selected then
                            selectedText = selectedText .. ", "
                        end
                    end
                    DropSelected.Text = selectedText
                else
                    DropSelected.Text = dropdown.Selected
                end
            end
            
            for _, option in pairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, -10, 0, 35)
                OptionButton.BackgroundColor3 = COLORS.Black
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = ""
                OptionButton.Parent = DropdownList
                
                local OptionIndicator = Instance.new("Frame")
                OptionIndicator.Size = UDim2.new(0, 3, 1, 0)
                OptionIndicator.Position = UDim2.new(0, 0, 0, 0)
                OptionIndicator.BackgroundColor3 = COLORS.White
                OptionIndicator.BorderSizePixel = 0
                OptionIndicator.Visible = false
                OptionIndicator.Parent = OptionButton
                
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -15, 1, 0)
                OptionLabel.Position = UDim2.new(0, 10, 0, 0)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Text = option
                OptionLabel.TextColor3 = COLORS.White
                OptionLabel.Font = Enum.Font.Gotham
                OptionLabel.TextSize = 13
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.Parent = OptionButton
                
                if multiSelect then
                    for _, selected in pairs(dropdown.Selected) do
                        if selected == option then
                            OptionIndicator.Visible = true
                            break
                        end
                    end
                else
                    if dropdown.Selected == option then
                        OptionIndicator.Visible = true
                    end
                end
                
                OptionButton.MouseButton1Click:Connect(function()
                    if multiSelect then
                        local found = false
                        local foundIndex = 0
                        for i, selected in pairs(dropdown.Selected) do
                            if selected == option then
                                found = true
                                foundIndex = i
                                break
                            end
                        end
                        
                        if found then
                            table.remove(dropdown.Selected, foundIndex)
                            createTween(OptionIndicator, {Size = UDim2.new(0, 0, 1, 0)}, 0.2)
                            wait(0.2)
                            OptionIndicator.Visible = false
                            OptionIndicator.Size = UDim2.new(0, 3, 1, 0)
                        else
                            table.insert(dropdown.Selected, option)
                            OptionIndicator.Visible = true
                            createTween(OptionIndicator, {Size = UDim2.new(0, 3, 1, 0)}, 0.2)
                        end
                    else
                        for _, child in pairs(DropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                local indicator = child:FindFirstChild("Frame")
                                if indicator then
                                    indicator.Visible = false
                                end
                            end
                        end
                        
                        dropdown.Selected = option
                        OptionIndicator.Visible = true
                        createTween(OptionIndicator, {Size = UDim2.new(0, 3, 1, 0)}, 0.2)
                    end
                    
                    updateDropdown()
                    dropdown.Callback(dropdown.Selected)
                end)
            end
            
            DropdownHeader.MouseButton1Click:Connect(function()
                dropdown.IsOpen = not dropdown.IsOpen
                
                if dropdown.IsOpen then
                    DropIcon.Image = ICONS.DropdownOpen
                    DropdownList.Visible = true
                    local contentHeight = #options * 37
                    createTween(DropdownList, {Size = UDim2.new(1, 0, 0, contentHeight)}, 0.3)
                    createTween(DropdownFrame, {Size = UDim2.new(1, -30, 0, 45 + contentHeight)}, 0.3)
                else
                    DropIcon.Image = ICONS.DropdownClosed
                    createTween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                    createTween(DropdownFrame, {Size = UDim2.new(1, -30, 0, 40)}, 0.3)
                    wait(0.3)
                    DropdownList.Visible = false
                end
            end)
            
            table.insert(tab.Components, dropdown)
            return dropdown
        end
        
        function tab:AddButton(name, callback)
            local button = {}
            button.Name = name
            button.Callback = callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, -30, 0, 40)
            ButtonFrame.BackgroundColor3 = COLORS.Background
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonElement = Instance.new("TextButton")
            ButtonElement.Size = UDim2.new(1, 0, 1, 0)
            ButtonElement.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ButtonElement.BorderSizePixel = 0
            ButtonElement.Text = ""
            ButtonElement.Parent = ButtonFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonElement
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -50, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = name
            ButtonLabel.TextColor3 = COLORS.White
            ButtonLabel.Font = Enum.Font.Gotham
            ButtonLabel.TextSize = 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = ButtonElement
            
            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
            ButtonIcon.Position = UDim2.new(1, -30, 0.5, -10)
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Image = ICONS.Button
            ButtonIcon.ImageColor3 = COLORS.White
            ButtonIcon.Parent = ButtonElement
            
            ButtonElement.MouseButton1Click:Connect(function()
                createTween(ButtonElement, {BackgroundColor3 = COLORS.White}, 0.1)
                createTween(ButtonLabel, {TextColor3 = COLORS.Background}, 0.1)
                createTween(ButtonIcon, {ImageColor3 = COLORS.Background}, 0.1)
                
                wait(0.1)
                
                createTween(ButtonElement, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.1)
                createTween(ButtonLabel, {TextColor3 = COLORS.White}, 0.1)
                createTween(ButtonIcon, {ImageColor3 = COLORS.White}, 0.1)
                
                button.Callback()
            end)
            
            table.insert(tab.Components, button)
            return button
        end
        
        function tab:AddSlider(name, min, max, default, callback)
            local slider = {}
            slider.Name = name
            slider.Min = min or 0
            slider.Max = max or 100
            slider.Value = default or min or 0
            slider.Callback = callback or function() end
            
            local hasDecimals = (min % 1 ~= 0) or (max % 1 ~= 0)
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -30, 0, 70)
            SliderFrame.BackgroundColor3 = COLORS.Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 25)
            SliderLabel.Position = UDim2.new(0, 10, 0, 0)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = COLORS.White
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(0, 70, 0, 30)
            InputBox.Position = UDim2.new(0, 10, 0, 30)
            InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            InputBox.BorderSizePixel = 0
            InputBox.Text = hasDecimals and string.format("%.2f", slider.Value) or tostring(slider.Value)
            InputBox.TextColor3 = COLORS.White
            InputBox.Font = Enum.Font.Gotham
            InputBox.TextSize = 13
            InputBox.Parent = SliderFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 4)
            InputCorner.Parent = InputBox
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -100, 0, 4)
            SliderTrack.Position = UDim2.new(0, 90, 0, 43)
            SliderTrack.BackgroundColor3 = COLORS.Gray
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderFrame
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = COLORS.White
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local SliderHandle = Instance.new("Frame")
            SliderHandle.Size = UDim2.new(0, 16, 0, 16)
            SliderHandle.Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -8, 0.5, -8)
            SliderHandle.BackgroundColor3 = COLORS.White
            SliderHandle.BorderSizePixel = 0
            SliderHandle.Parent = SliderTrack
            
            local HandleCorner = Instance.new("UICorner")
            HandleCorner.CornerRadius = UDim.new(1, 0)
            HandleCorner.Parent = SliderHandle
            
            local draggingSlider = false
            
            local function updateSlider(value)
                value = math.clamp(value, slider.Min, slider.Max)
                slider.Value = value
                
                local percentage = (value - slider.Min) / (slider.Max - slider.Min)
                
                createTween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                createTween(SliderHandle, {Position = UDim2.new(percentage, -8, 0.5, -8)}, 0.1)
                
                InputBox.Text = hasDecimals and string.format("%.2f", value) or tostring(math.floor(value))
                slider.Callback(value)
            end
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    
                    local function update()
                        local mousePos = UserInputService:GetMouseLocation().X
                        local trackPos = SliderTrack.AbsolutePosition.X
                        local trackSize = SliderTrack.AbsoluteSize.X
                        local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                        local value = slider.Min + (percentage * (slider.Max - slider.Min))
                        updateSlider(value)
                    end
                    
                    update()
                    
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input2)
                        if input2.UserInputType == Enum.UserInputType.MouseMovement and draggingSlider then
                            update()
                        end
                    end)
                    
                    local connection2
                    connection2 = UserInputService.InputEnded:Connect(function(input2)
                        if input2.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSlider = false
                            connection:Disconnect()
                            connection2:Disconnect()
                        end
                    end)
                end
            end)
            
            InputBox.FocusLost:Connect(function()
                local value = tonumber(InputBox.Text)
                if value then
                    if value > slider.Max then
                        value = slider.Max
                    elseif value < slider.Min then
                        value = slider.Min
                    end
                    updateSlider(value)
                else
                    InputBox.Text = hasDecimals and string.format("%.2f", slider.Value) or tostring(slider.Value)
                end
            end)
            
            table.insert(tab.Components, slider)
            return slider
        end
        
        function tab:AddSection(name)
            local section = {}
            section.Name = name
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -30, 0, 30)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent
            
            local LeftLine = Instance.new("Frame")
            LeftLine.Size = UDim2.new(0.35, -60, 0, 2)
            LeftLine.Position = UDim2.new(0, 0, 0.5, -1)
            LeftLine.BorderSizePixel = 0
            LeftLine.Parent = SectionFrame
            
            local LeftGradient = Instance.new("UIGradient")
            LeftGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, COLORS.White),
                ColorSequenceKeypoint.new(0.5, COLORS.Gray),
                ColorSequenceKeypoint.new(1, COLORS.Black)
            }
            LeftGradient.Parent = LeftLine
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(0.3, 0, 1, 0)
            SectionLabel.Position = UDim2.new(0.35, 0, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name
            SectionLabel.TextColor3 = COLORS.White
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 14
            SectionLabel.Parent = SectionFrame
            
            local RightLine = Instance.new("Frame")
            RightLine.Size = UDim2.new(0.35, -60, 0, 2)
            RightLine.Position = UDim2.new(0.65, 60, 0.5, -1)
            RightLine.BorderSizePixel = 0
            RightLine.Parent = SectionFrame
            
            local RightGradient = Instance.new("UIGradient")
            RightGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, COLORS.Black),
                ColorSequenceKeypoint.new(0.5, COLORS.Gray),
                ColorSequenceKeypoint.new(1, COLORS.White)
            }
            RightGradient.Parent = RightLine
            
            table.insert(tab.Components, section)
            return section
        end
        
        return tab
    end
    
    function self:Notify(config)
        local notification = {}
        notification.Title = config.Title or "Notification"
        notification.Body = config.Body or ""
        notification.Icon = config.Icon or ""
        notification.Duration = config.Duration or 5
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 350, 0, 100)
        NotifFrame.Position = UDim2.new(1, 370, 1, -120)
        NotifFrame.BackgroundColor3 = COLORS.Background
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = self.GUI
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = NotifFrame
        
        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = COLORS.Gray
        NotifStroke.Thickness = 1
        NotifStroke.Parent = NotifFrame
        
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Size = UDim2.new(0, 60, 0, 60)
        NotifIcon.Position = UDim2.new(0, 15, 0.5, -30)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Image = notification.Icon
        NotifIcon.ImageColor3 = COLORS.White
        NotifIcon.Parent = NotifFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -90, 0, 30)
        NotifTitle.Position = UDim2.new(0, 85, 0, 15)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = notification.Title
        NotifTitle.TextColor3 = COLORS.White
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = 16
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.TextYAlignment = Enum.TextYAlignment.Top
        NotifTitle.Parent = NotifFrame
        
        local NotifBody = Instance.new("TextLabel")
        NotifBody.Size = UDim2.new(1, -90, 0, 45)
        NotifBody.Position = UDim2.new(0, 85, 0, 45)
        NotifBody.BackgroundTransparency = 1
        NotifBody.Text = notification.Body
        NotifBody.TextColor3 = COLORS.Gray
        NotifBody.Font = Enum.Font.Gotham
        NotifBody.TextSize = 13
        NotifBody.TextXAlignment = Enum.TextXAlignment.Left
        NotifBody.TextYAlignment = Enum.TextYAlignment.Top
        NotifBody.TextWrapped = true
        NotifBody.Parent = NotifFrame
        
        createTween(NotifFrame, {Position = UDim2.new(1, -370, 1, -120)}, 0.5)
        
        wait(notification.Duration)
        
        createTween(NotifFrame, {Position = UDim2.new(1, 20, 1, -120)}, 0.5)
        wait(0.5)
        NotifFrame:Destroy()
        
        return notification
    end
    
    return self
end

return UILibrary
