local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local COLORS = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(20, 20, 28),
    Tertiary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(120, 120, 255),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(160, 160, 180),
    DarkGray = Color3.fromRGB(80, 80, 100),
    Success = Color3.fromRGB(100, 255, 150),
    Error = Color3.fromRGB(255, 100, 100)
}

local ICONS = {
    DropdownClosed = "rbxassetid://116845122064768",
    DropdownOpen = "rbxassetid://132854725146991",
    Button = "rbxassetid://110294213486252"
}

local function createTween(instance, properties, duration, style)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function addGlow(frame, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or COLORS.Accent
    glow.ImageTransparency = 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.ZIndex = 0
    glow.Parent = frame
    return glow
end

function UILibrary.new(config)
    local self = {}
    self.Title = config.Title or "UI Library"
    self.Subtitle = config.Subtitle or "Modern Interface"
    self.Icon = config.Icon or ""
    self.AccentColor = config.AccentColor or COLORS.Accent
    self.Components = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game:GetService("Lighting")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 800, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainShadow = Instance.new("ImageLabel")
    MainShadow.Name = "Shadow"
    MainShadow.Size = UDim2.new(1, 60, 1, 60)
    MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainShadow.BackgroundTransparency = 1
    MainShadow.Image = "rbxassetid://5028857084"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.5
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    MainShadow.ZIndex = 0
    MainShadow.Parent = MainFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundColor3 = COLORS.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 16)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 16)
    TopBarCover.Position = UDim2.new(0, 0, 1, -16)
    TopBarCover.BackgroundColor3 = COLORS.Secondary
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.BackgroundColor3 = self.AccentColor
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = TopBar
    
    local AccentGradient = Instance.new("UIGradient")
    AccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, self.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    AccentGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    AccentGradient.Parent = AccentLine
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 45, 0, 45)
    IconContainer.Position = UDim2.new(0, 15, 0.5, -22.5)
    IconContainer.BackgroundColor3 = self.AccentColor
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = TopBar
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = IconContainer
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 28, 0, 28)
    IconLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = self.Icon
    IconLabel.ImageColor3 = COLORS.White
    IconLabel.Parent = IconContainer
    
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Size = UDim2.new(0, 400, 1, 0)
    TitleContainer.Position = UDim2.new(0, 70, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 25)
    TitleLabel.Position = UDim2.new(0, 0, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleContainer
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 18)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, 35)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.Subtitle
    SubtitleLabel.TextColor3 = COLORS.Gray
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextSize = 13
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TitleContainer
    
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Size = UDim2.new(0, 100, 1, 0)
    ControlsContainer.Position = UDim2.new(1, -110, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = TopBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 36, 0, 36)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -18)
    MinimizeButton.BackgroundColor3 = COLORS.Tertiary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = ""
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = ControlsContainer
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 10)
    MinCorner.Parent = MinimizeButton
    
    local MinIcon = Instance.new("TextLabel")
    MinIcon.Size = UDim2.new(1, 0, 1, 0)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Text = "−"
    MinIcon.TextColor3 = COLORS.White
    MinIcon.Font = Enum.Font.GothamBold
    MinIcon.TextSize = 20
    MinIcon.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 36, 0, 36)
    CloseButton.Position = UDim2.new(0, 50, 0.5, -18)
    CloseButton.BackgroundColor3 = COLORS.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = ""
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = ControlsContainer
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton
    
    local CloseIcon = Instance.new("TextLabel")
    CloseIcon.Size = UDim2.new(1, 0, 1, 0)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Text = "×"
    CloseIcon.TextColor3 = COLORS.White
    CloseIcon.Font = Enum.Font.GothamBold
    CloseIcon.TextSize = 24
    CloseIcon.Parent = CloseButton
    
    MinimizeButton.MouseEnter:Connect(function()
        createTween(MinimizeButton, {BackgroundColor3 = COLORS.Accent}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        createTween(MinimizeButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
    end)
    
    CloseButton.MouseEnter:Connect(function()
        createTween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        createTween(CloseButton, {BackgroundColor3 = COLORS.Error}, 0.2)
    end)
    
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -62)
    Sidebar.Position = UDim2.new(0, 0, 0, 62)
    Sidebar.BackgroundColor3 = COLORS.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.ScrollBarImageColor3 = COLORS.Accent
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = MainFrame
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 8)
    SidebarList.Parent = Sidebar
    
    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 20)
    end)
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -200, 1, -62)
    ContentFrame.Position = UDim2.new(0, 200, 0, 62)
    ContentFrame.BackgroundColor3 = COLORS.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = COLORS.Accent
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 12)
    ContentList.Parent = ContentFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 20)
    ContentPadding.PaddingLeft = UDim.new(0, 20)
    ContentPadding.PaddingRight = UDim.new(0, 20)
    ContentPadding.PaddingBottom = UDim.new(0, 20)
    ContentPadding.Parent = ContentFrame
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 40)
    end)
    
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Size = UDim2.new(0, 450, 0, 70)
    MinimizedFrame.Position = UDim2.new(0.5, -225, 0.95, -35)
    MinimizedFrame.BackgroundColor3 = COLORS.Secondary
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = ScreenGui
    
    local MinFrameCorner = Instance.new("UICorner")
    MinFrameCorner.CornerRadius = UDim.new(0, 35)
    MinFrameCorner.Parent = MinimizedFrame
    
    local MinFrameShadow = Instance.new("ImageLabel")
    MinFrameShadow.Size = UDim2.new(1, 40, 1, 40)
    MinFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    MinFrameShadow.BackgroundTransparency = 1
    MinFrameShadow.Image = "rbxassetid://5028857084"
    MinFrameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MinFrameShadow.ImageTransparency = 0.5
    MinFrameShadow.ScaleType = Enum.ScaleType.Slice
    MinFrameShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    MinFrameShadow.ZIndex = 0
    MinFrameShadow.Parent = MinimizedFrame
    
    local MinAccentLine = Instance.new("Frame")
    MinAccentLine.Size = UDim2.new(1, 0, 0, 2)
    MinAccentLine.Position = UDim2.new(0, 0, 0, 0)
    MinAccentLine.BackgroundColor3 = self.AccentColor
    MinAccentLine.BorderSizePixel = 0
    MinAccentLine.Parent = MinimizedFrame
    
    local MinAccentCorner = Instance.new("UICorner")
    MinAccentCorner.CornerRadius = UDim.new(0, 35)
    MinAccentCorner.Parent = MinAccentLine
    
    local MinIconContainer = Instance.new("Frame")
    MinIconContainer.Size = UDim2.new(0, 50, 0, 50)
    MinIconContainer.Position = UDim2.new(0, 15, 0.5, -25)
    MinIconContainer.BackgroundColor3 = self.AccentColor
    MinIconContainer.BorderSizePixel = 0
    MinIconContainer.Parent = MinimizedFrame
    
    local MinIconCorner = Instance.new("UICorner")
    MinIconCorner.CornerRadius = UDim.new(1, 0)
    MinIconCorner.Parent = MinIconContainer
    
    local MinIcon2 = Instance.new("ImageLabel")
    MinIcon2.Size = UDim2.new(0, 32, 0, 32)
    MinIcon2.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinIcon2.AnchorPoint = Vector2.new(0.5, 0.5)
    MinIcon2.BackgroundTransparency = 1
    MinIcon2.Image = self.Icon
    MinIcon2.ImageColor3 = COLORS.White
    MinIcon2.Parent = MinIconContainer
    
    local MinTextContainer = Instance.new("Frame")
    MinTextContainer.Size = UDim2.new(0, 300, 1, 0)
    MinTextContainer.Position = UDim2.new(0, 75, 0, 0)
    MinTextContainer.BackgroundTransparency = 1
    MinTextContainer.Parent = MinimizedFrame
    
    local MinTitle = Instance.new("TextLabel")
    MinTitle.Size = UDim2.new(1, 0, 0, 30)
    MinTitle.Position = UDim2.new(0, 0, 0, 15)
    MinTitle.BackgroundTransparency = 1
    MinTitle.Text = self.Title
    MinTitle.TextColor3 = COLORS.White
    MinTitle.Font = Enum.Font.GothamBold
    MinTitle.TextSize = 16
    MinTitle.TextXAlignment = Enum.TextXAlignment.Left
    MinTitle.Parent = MinTextContainer
    
    local MinSubtitle = Instance.new("TextLabel")
    MinSubtitle.Size = UDim2.new(1, 0, 0, 20)
    MinSubtitle.Position = UDim2.new(0, 0, 0, 38)
    MinSubtitle.BackgroundTransparency = 1
    MinSubtitle.Text = self.Subtitle
    MinSubtitle.TextColor3 = COLORS.Gray
    MinSubtitle.Font = Enum.Font.Gotham
    MinSubtitle.TextSize = 12
    MinSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    MinSubtitle.Parent = MinTextContainer
    
    local RestoreButton = Instance.new("TextButton")
    RestoreButton.Size = UDim2.new(0, 55, 0, 55)
    RestoreButton.Position = UDim2.new(1, -65, 0.5, -27.5)
    RestoreButton.BackgroundColor3 = self.AccentColor
    RestoreButton.BorderSizePixel = 0
    RestoreButton.Text = ""
    RestoreButton.AutoButtonColor = false
    RestoreButton.Parent = MinimizedFrame
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(1, 0)
    RestoreCorner.Parent = RestoreButton
    
    local RestoreIcon = Instance.new("TextLabel")
    RestoreIcon.Size = UDim2.new(1, 0, 1, 0)
    RestoreIcon.BackgroundTransparency = 1
    RestoreIcon.Text = "+"
    RestoreIcon.TextColor3 = COLORS.White
    RestoreIcon.Font = Enum.Font.GothamBold
    RestoreIcon.TextSize = 28
    RestoreIcon.Parent = RestoreButton
    
    RestoreButton.MouseEnter:Connect(function()
        createTween(RestoreButton, {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(1, -67.5, 0.5, -30)}, 0.2)
    end)
    
    RestoreButton.MouseLeave:Connect(function()
        createTween(RestoreButton, {Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(1, -65, 0.5, -27.5)}, 0.2)
    end)
    
    local dragging = false
    local dragInput, mousePos, framePos
    
    TopBar.InputBegan:Connect(function(input)
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
            createTween(MainFrame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Size = UDim2.new(0, 350, 0, 180)
        ConfirmFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
        ConfirmFrame.BackgroundColor3 = COLORS.Secondary
        ConfirmFrame.BorderSizePixel = 0
        ConfirmFrame.ZIndex = 10
        ConfirmFrame.Parent = ScreenGui
        
        local ConfCorner = Instance.new("UICorner")
        ConfCorner.CornerRadius = UDim.new(0, 16)
        ConfCorner.Parent = ConfirmFrame
        
        local ConfShadow = Instance.new("ImageLabel")
        ConfShadow.Size = UDim2.new(1, 60, 1, 60)
        ConfShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        ConfShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        ConfShadow.BackgroundTransparency = 1
        ConfShadow.Image = "rbxassetid://5028857084"
        ConfShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        ConfShadow.ImageTransparency = 0.3
        ConfShadow.ScaleType = Enum.ScaleType.Slice
        ConfShadow.SliceCenter = Rect.new(24, 24, 276, 276)
        ConfShadow.ZIndex = 9
        ConfShadow.Parent = ConfirmFrame
        
        local ConfAccent = Instance.new("Frame")
        ConfAccent.Size = UDim2.new(1, 0, 0, 3)
        ConfAccent.BackgroundColor3 = COLORS.Error
        ConfAccent.BorderSizePixel = 0
        ConfAccent.ZIndex = 11
        ConfAccent.Parent = ConfirmFrame
        
        local ConfAccentCorner = Instance.new("UICorner")
        ConfAccentCorner.CornerRadius = UDim.new(0, 16)
        ConfAccentCorner.Parent = ConfAccent
        
        local ConfText = Instance.new("TextLabel")
        ConfText.Size = UDim2.new(1, -40, 0, 80)
        ConfText.Position = UDim2.new(0, 20, 0, 30)
        ConfText.BackgroundTransparency = 1
        ConfText.Text = "Are you sure you want to close this interface?"
        ConfText.TextColor3 = COLORS.White
        ConfText.Font = Enum.Font.GothamBold
        ConfText.TextSize = 16
        ConfText.TextWrapped = true
        ConfText.TextYAlignment = Enum.TextYAlignment.Top
        ConfText.ZIndex = 11
        ConfText.Parent = ConfirmFrame
        
        local YesButton = Instance.new("TextButton")
        YesButton.Size = UDim2.new(0, 150, 0, 45)
        YesButton.Position = UDim2.new(0, 20, 1, -65)
        YesButton.BackgroundColor3 = COLORS.Error
        YesButton.BorderSizePixel = 0
        YesButton.Text = "Yes, Close"
        YesButton.TextColor3 = COLORS.White
        YesButton.Font = Enum.Font.GothamBold
        YesButton.TextSize = 14
        YesButton.AutoButtonColor = false
        YesButton.ZIndex = 11
        YesButton.Parent = ConfirmFrame
        
        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 12)
        YesCorner.Parent = YesButton
        
        local NoButton = Instance.new("TextButton")
        NoButton.Size = UDim2.new(0, 150, 0, 45)
        NoButton.Position = UDim2.new(1, -170, 1, -65)
        NoButton.BackgroundColor3 = COLORS.Tertiary
        NoButton.BorderSizePixel = 0
        NoButton.Text = "Cancel"
        NoButton.TextColor3 = COLORS.White
        NoButton.Font = Enum.Font.GothamBold
        NoButton.TextSize = 14
        NoButton.AutoButtonColor = false
        NoButton.ZIndex = 11
        NoButton.Parent = ConfirmFrame
        
        local NoCorner = Instance.new("UICorner")
        NoCorner.CornerRadius = UDim.new(0, 12)
        NoCorner.Parent = NoButton
        
        YesButton.MouseEnter:Connect(function()
            createTween(YesButton, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}, 0.2)
        end)
        
        YesButton.MouseLeave:Connect(function()
            createTween(YesButton, {BackgroundColor3 = COLORS.Error}, 0.2)
        end)
        
        NoButton.MouseEnter:Connect(function()
            createTween(NoButton, {BackgroundColor3 = COLORS.Accent}, 0.2)
        end)
        
        NoButton.MouseLeave:Connect(function()
            createTween(NoButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
        end)
        
        ConfirmFrame.Size = UDim2.new(0, 0, 0, 0)
        ConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        createTween(ConfirmFrame, {Size = UDim2.new(0, 350, 0, 180), Position = UDim2.new(0.5, -175, 0.5, -90)}, 0.3, Enum.EasingStyle.Back)
        
        YesButton.MouseButton1Click:Connect(function()
            createTween(ConfirmFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
            createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Back)
            wait(0.4)
            ScreenGui:Destroy()
            Blur:Destroy()
        end)
        
        NoButton.MouseButton1Click:Connect(function()
            createTween(ConfirmFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back)
            wait(0.3)
            ConfirmFrame:Destroy()
        end)
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self.IsMinimized = true
        createTween(Blur, {Size = 0}, 0.3)
        createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Back)
        wait(0.4)
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        MinimizedFrame.Size = UDim2.new(0, 0, 0, 0)
        MinimizedFrame.Position = UDim2.new(0.5, 0, 0.95, 0)
        createTween(MinimizedFrame, {Size = UDim2.new(0, 450, 0, 70), Position = UDim2.new(0.5, -225, 0.95, -35)}, 0.4, Enum.EasingStyle.Back)
    end)
    
    RestoreButton.MouseButton1Click:Connect(function()
        self.IsMinimized = false
        createTween(MinimizedFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.95, 0)}, 0.3, Enum.EasingStyle.Back)
        wait(0.3)
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        createTween(MainFrame, {Size = UDim2.new(0, 800, 0, 550), Position = UDim2.new(0.5, -400, 0.5, -275)}, 0.4, Enum.EasingStyle.Back)
        createTween(Blur, {Size = 8}, 0.3)
    end)
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    createTween(MainFrame, {Size = UDim2.new(0, 800, 0, 550), Position = UDim2.new(0.5, -400, 0.5, -275)}, 0.5, Enum.EasingStyle.Back)
    createTween(Blur, {Size = 8}, 0.3)
    
    self.GUI = ScreenGui
    self.MainFrame = MainFrame
    self.Sidebar = Sidebar
    self.ContentFrame = ContentFrame
    self.SidebarList = SidebarList
    self.ContentList = ContentList
    self.AccentColor = self.AccentColor
    
    function self:CreateTab(name, icon)
        local tab = {}
        tab.Name = name
        tab.Icon = icon or ""
        tab.Components = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 50)
        TabButton.BackgroundColor3 = COLORS.Tertiary
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.ClipsDescendants = true
        TabButton.Parent = self.Sidebar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 12)
        TabCorner.Parent = TabButton
        
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 4, 0, 0)
        TabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        TabIndicator.AnchorPoint = Vector2.new(0, 0.5)
        TabIndicator.BackgroundColor3 = self.AccentColor
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Parent = TabButton
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = TabIndicator
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 18, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ImageColor3 = COLORS.Gray
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -55, 1, 0)
        TabLabel.Position = UDim2.new(0, 50, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = COLORS.Gray
        TabLabel.Font = Enum.Font.GothamMedium
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
        TabContentList.Padding = UDim.new(0, 12)
        TabContentList.Parent = TabContent
        
        TabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                createTween(TabButton, {BackgroundTransparency = 0.7}, 0.2)
                createTween(TabIcon, {ImageColor3 = COLORS.White}, 0.2)
                createTween(TabLabel, {TextColor3 = COLORS.White}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                createTween(TabButton, {BackgroundTransparency = 1}, 0.2)
                createTween(TabIcon, {ImageColor3 = COLORS.Gray}, 0.2)
                createTween(TabLabel, {TextColor3 = COLORS.Gray}, 0.2)
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(self.Tabs) do
                local existingButton = existingTab.Button
                local existingIndicator = existingButton:FindFirstChild("Indicator")
                local existingIcon = existingButton:FindFirstChild("ImageLabel")
                local existingLabel = existingButton:FindFirstChild("TextLabel")
                
                createTween(existingButton, {BackgroundTransparency = 1}, 0.3)
                createTween(existingIndicator, {Size = UDim2.new(0, 4, 0, 0)}, 0.3)
                createTween(existingIcon, {ImageColor3 = COLORS.Gray}, 0.3)
                createTween(existingLabel, {TextColor3 = COLORS.Gray}, 0.3)
                existingTab.Content.Visible = false
            end
            
            createTween(TabButton, {BackgroundTransparency = 0}, 0.3)
            createTween(TabIndicator, {Size = UDim2.new(0, 4, 0, 35)}, 0.3, Enum.EasingStyle.Back)
            createTween(TabIcon, {ImageColor3 = self.AccentColor}, 0.3)
            createTween(TabLabel, {TextColor3 = COLORS.White}, 0.3)
            TabContent.Visible = true
            self.CurrentTab = tab
        end)
        
        tab.Button = TabButton
        tab.Content = TabContent
        tab.ContentList = TabContentList
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            createTween(TabButton, {BackgroundTransparency = 0}, 0.3)
            createTween(TabIndicator, {Size = UDim2.new(0, 4, 0, 35)}, 0.3)
            createTween(TabIcon, {ImageColor3 = self.AccentColor}, 0.3)
            createTween(TabLabel, {TextColor3 = COLORS.White}, 0.3)
            TabContent.Visible = true
            self.CurrentTab = tab
        end
        
        function tab:AddToggle(name, default, callback)
            local toggle = {}
            toggle.Name = name
            toggle.Value = default or false
            toggle.Callback = callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -20, 0, 55)
            ToggleFrame.BackgroundColor3 = COLORS.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 12)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = COLORS.Tertiary
            ToggleStroke.Thickness = 1
            ToggleStroke.Transparency = 0.5
            ToggleStroke.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.7, -20, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 18, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = COLORS.White
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 26)
            ToggleButton.Position = UDim2.new(1, -68, 0.5, -13)
            ToggleButton.BackgroundColor3 = toggle.Value and self.AccentColor or COLORS.DarkGray
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCorner2 = Instance.new("UICorner")
            ToggleCorner2.CornerRadius = UDim.new(1, 0)
            ToggleCorner2.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircle.Position = toggle.Value and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            ToggleCircle.BackgroundColor3 = COLORS.White
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local CircleShadow = Instance.new("ImageLabel")
            CircleShadow.Size = UDim2.new(1, 10, 1, 10)
            CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            CircleShadow.BackgroundTransparency = 1
            CircleShadow.Image = "rbxassetid://5028857084"
            CircleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            CircleShadow.ImageTransparency = 0.7
            CircleShadow.ScaleType = Enum.ScaleType.Slice
            CircleShadow.SliceCenter = Rect.new(24, 24, 276, 276)
            CircleShadow.ZIndex = 0
            CircleShadow.Parent = ToggleCircle
            
            ToggleFrame.MouseEnter:Connect(function()
                createTween(ToggleStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                createTween(ToggleStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
            end)
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggle.Value = not toggle.Value
                
                createTween(ToggleButton, {BackgroundColor3 = toggle.Value and self.AccentColor or COLORS.DarkGray}, 0.3)
                createTween(ToggleCircle, {
                    Position = toggle.Value and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                }, 0.3, Enum.EasingStyle.Back)
                
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
            DropdownFrame.Size = UDim2.new(1, -20, 0, 55)
            DropdownFrame.BackgroundColor3 = COLORS.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = false
            DropdownFrame.Parent = TabContent
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 12)
            DropCorner.Parent = DropdownFrame
            
            local DropStroke = Instance.new("UIStroke")
            DropStroke.Color = COLORS.Tertiary
            DropStroke.Thickness = 1
            DropStroke.Transparency = 0.5
            DropStroke.Parent = DropdownFrame
            
            local DropdownHeader = Instance.new("TextButton")
            DropdownHeader.Size = UDim2.new(1, 0, 0, 55)
            DropdownHeader.BackgroundTransparency = 1
            DropdownHeader.Text = ""
            DropdownHeader.AutoButtonColor = false
            DropdownHeader.Parent = DropdownFrame
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0.5, -20, 1, 0)
            DropLabel.Position = UDim2.new(0, 18, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = name
            DropLabel.TextColor3 = COLORS.White
            DropLabel.Font = Enum.Font.GothamMedium
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropdownHeader
            
            local DropSelected = Instance.new("TextLabel")
            DropSelected.Size = UDim2.new(0.45, 0, 1, 0)
            DropSelected.Position = UDim2.new(0.5, 0, 0, 0)
            DropSelected.BackgroundTransparency = 1
            DropSelected.Text = multiSelect and "" or (default or options[1])
            DropSelected.TextColor3 = self.AccentColor
            DropSelected.Font = Enum.Font.GothamBold
            DropSelected.TextSize = 13
            DropSelected.TextXAlignment = Enum.TextXAlignment.Right
            DropSelected.TextTruncate = Enum.TextTruncate.AtEnd
            DropSelected.Parent = DropdownHeader
            
            local DropIcon = Instance.new("ImageLabel")
            DropIcon.Size = UDim2.new(0, 20, 0, 20)
            DropIcon.Position = UDim2.new(1, -35, 0.5, -10)
            DropIcon.BackgroundTransparency = 1
            DropIcon.Image = ICONS.DropdownClosed
            DropIcon.ImageColor3 = COLORS.Gray
            DropIcon.Rotation = 0
            DropIcon.Parent = DropdownHeader
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 0, 60)
            DropdownList.BackgroundColor3 = COLORS.Tertiary
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = self.AccentColor
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.Parent = DropdownFrame
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 12)
            ListCorner.Parent = DropdownList
            
            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = self.AccentColor
            ListStroke.Thickness = 1
            ListStroke.Transparency = 0.3
            ListStroke.Parent = DropdownList
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 4)
            OptionsLayout.Parent = DropdownList
            
            local OptionsPadding = Instance.new("UIPadding")
            OptionsPadding.PaddingTop = UDim.new(0, 8)
            OptionsPadding.PaddingLeft = UDim.new(0, 8)
            OptionsPadding.PaddingRight = UDim.new(0, 8)
            OptionsPadding.PaddingBottom = UDim.new(0, 8)
            OptionsPadding.Parent = DropdownList
            
            OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y + 16)
            end)
            
            DropdownFrame.MouseEnter:Connect(function()
                createTween(DropStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
            end)
            
            DropdownFrame.MouseLeave:Connect(function()
                if not dropdown.IsOpen then
                    createTween(DropStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                end
            end)
            
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
                OptionButton.Size = UDim2.new(1, -16, 0, 38)
                OptionButton.BackgroundColor3 = COLORS.Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = ""
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 10)
                OptionCorner.Parent = OptionButton
                
                local OptionIndicator = Instance.new("Frame")
                OptionIndicator.Size = UDim2.new(0, 0, 0, 25)
                OptionIndicator.Position = UDim2.new(0, 8, 0.5, -12.5)
                OptionIndicator.BackgroundColor3 = self.AccentColor
                OptionIndicator.BorderSizePixel = 0
                OptionIndicator.Parent = OptionButton
                
                local IndicatorCorner2 = Instance.new("UICorner")
                IndicatorCorner2.CornerRadius = UDim.new(1, 0)
                IndicatorCorner2.Parent = OptionIndicator
                
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -25, 1, 0)
                OptionLabel.Position = UDim2.new(0, 18, 0, 0)
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
                            OptionIndicator.Size = UDim2.new(0, 3, 0, 25)
                            OptionButton.BackgroundColor3 = COLORS.Tertiary
                            break
                        end
                    end
                else
                    if dropdown.Selected == option then
                        OptionIndicator.Size = UDim2.new(0, 3, 0, 25)
                        OptionButton.BackgroundColor3 = COLORS.Tertiary
                    end
                end
                
                OptionButton.MouseEnter:Connect(function()
                    createTween(OptionButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    local isSelected = false
                    if multiSelect then
                        for _, selected in pairs(dropdown.Selected) do
                            if selected == option then
                                isSelected = true
                                break
                            end
                        end
                    else
                        isSelected = dropdown.Selected == option
                    end
                    
                    if not isSelected then
                        createTween(OptionButton, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                    end
                end)
                
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
                            createTween(OptionIndicator, {Size = UDim2.new(0, 0, 0, 25)}, 0.3)
                            createTween(OptionButton, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                        else
                            table.insert(dropdown.Selected, option)
                            createTween(OptionIndicator, {Size = UDim2.new(0, 3, 0, 25)}, 0.3, Enum.EasingStyle.Back)
                            createTween(OptionButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
                        end
                    else
                        for _, child in pairs(DropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                local indicator = child:FindFirstChild("Frame")
                                if indicator then
                                    createTween(indicator, {Size = UDim2.new(0, 0, 0, 25)}, 0.3)
                                end
                                if child ~= OptionButton then
                                    createTween(child, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                                end
                            end
                        end
                        
                        dropdown.Selected = option
                        createTween(OptionIndicator, {Size = UDim2.new(0, 3, 0, 25)}, 0.3, Enum.EasingStyle.Back)
                        createTween(OptionButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
                    end
                    
                    updateDropdown()
                    dropdown.Callback(dropdown.Selected)
                end)
            end
            
            DropdownHeader.MouseButton1Click:Connect(function()
                dropdown.IsOpen = not dropdown.IsOpen
                
                if dropdown.IsOpen then
                    createTween(DropIcon, {Rotation = 180, ImageColor3 = self.AccentColor}, 0.3)
                    DropdownList.Visible = true
                    local contentHeight = math.min(#options * 42 + 16, 200)
                    createTween(DropdownList, {Size = UDim2.new(1, 0, 0, contentHeight)}, 0.3, Enum.EasingStyle.Back)
                    createTween(DropdownFrame, {Size = UDim2.new(1, -20, 0, 60 + contentHeight)}, 0.3)
                    createTween(DropStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                else
                    createTween(DropIcon, {Rotation = 0, ImageColor3 = COLORS.Gray}, 0.3)
                    createTween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                    createTween(DropdownFrame, {Size = UDim2.new(1, -20, 0, 55)}, 0.3)
                    createTween(DropStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
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
            ButtonFrame.Size = UDim2.new(1, -20, 0, 55)
            ButtonFrame.BackgroundColor3 = COLORS.Secondary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 12)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = COLORS.Tertiary
            ButtonStroke.Thickness = 1
            ButtonStroke.Transparency = 0.5
            ButtonStroke.Parent = ButtonFrame
            
            local ButtonElement = Instance.new("TextButton")
            ButtonElement.Size = UDim2.new(1, 0, 1, 0)
            ButtonElement.BackgroundTransparency = 1
            ButtonElement.Text = ""
            ButtonElement.AutoButtonColor = false
            ButtonElement.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -60, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 18, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = name
            ButtonLabel.TextColor3 = COLORS.White
            ButtonLabel.Font = Enum.Font.GothamMedium
            ButtonLabel.TextSize = 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = ButtonElement
            
            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
            ButtonIcon.Position = UDim2.new(1, -35, 0.5, -10)
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Image = ICONS.Button
            ButtonIcon.ImageColor3 = COLORS.Gray
            ButtonIcon.Parent = ButtonElement
            
            ButtonFrame.MouseEnter:Connect(function()
                createTween(ButtonStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                createTween(ButtonIcon, {ImageColor3 = self.AccentColor}, 0.2)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                createTween(ButtonStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                createTween(ButtonIcon, {ImageColor3 = COLORS.Gray}, 0.2)
            end)
            
            ButtonElement.MouseButton1Click:Connect(function()
                createTween(ButtonFrame, {BackgroundColor3 = self.AccentColor}, 0.1)
                createTween(ButtonLabel, {TextColor3 = COLORS.Background}, 0.1)
                createTween(ButtonIcon, {ImageColor3 = COLORS.Background}, 0.1)
                
                wait(0.1)
                
                createTween(ButtonFrame, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                createTween(ButtonLabel, {TextColor3 = COLORS.White}, 0.2)
                createTween(ButtonIcon, {ImageColor3 = self.AccentColor}, 0.2)
                
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
            SliderFrame.Size = UDim2.new(1, -20, 0, 85)
            SliderFrame.BackgroundColor3 = COLORS.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 12)
            SliderCorner.Parent = SliderFrame
            
            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Color = COLORS.Tertiary
            SliderStroke.Thickness = 1
            SliderStroke.Transparency = 0.5
            SliderStroke.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -30, 0, 25)
            SliderLabel.Position = UDim2.new(0, 18, 0, 12)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = COLORS.White
            SliderLabel.Font = Enum.Font.GothamMedium
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(0, 80, 0, 35)
            InputBox.Position = UDim2.new(0, 18, 0, 40)
            InputBox.BackgroundColor3 = COLORS.Tertiary
            InputBox.BorderSizePixel = 0
            InputBox.Text = hasDecimals and string.format("%.2f", slider.Value) or tostring(slider.Value)
            InputBox.TextColor3 = COLORS.White
            InputBox.Font = Enum.Font.GothamMedium
            InputBox.TextSize = 13
            InputBox.PlaceholderText = "Value"
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = SliderFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
            InputCorner.Parent = InputBox
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -130, 0, 6)
            SliderTrack.Position = UDim2.new(0, 108, 0, 54.5)
            SliderTrack.BackgroundColor3 = COLORS.Tertiary
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderFrame
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = self.AccentColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local SliderHandle = Instance.new("Frame")
            SliderHandle.Size = UDim2.new(0, 18, 0, 18)
            SliderHandle.Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -9, 0.5, -9)
            SliderHandle.BackgroundColor3 = COLORS.White
            SliderHandle.BorderSizePixel = 0
            SliderHandle.Parent = SliderTrack
            
            local HandleCorner = Instance.new("UICorner")
            HandleCorner.CornerRadius = UDim.new(1, 0)
            HandleCorner.Parent = SliderHandle
            
            local HandleShadow = Instance.new("ImageLabel")
            HandleShadow.Size = UDim2.new(1, 12, 1, 12)
            HandleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            HandleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            HandleShadow.BackgroundTransparency = 1
            HandleShadow.Image = "rbxassetid://5028857084"
            HandleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            HandleShadow.ImageTransparency = 0.7
            HandleShadow.ScaleType = Enum.ScaleType.Slice
            HandleShadow.SliceCenter = Rect.new(24, 24, 276, 276)
            HandleShadow.ZIndex = 0
            HandleShadow.Parent = SliderHandle
            
            local draggingSlider = false
            
            SliderFrame.MouseEnter:Connect(function()
                createTween(SliderStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
            end)
            
            SliderFrame.MouseLeave:Connect(function()
                if not draggingSlider then
                    createTween(SliderStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                end
            end)
            
            InputBox.Focused:Connect(function()
                createTween(InputBox, {BackgroundColor3 = COLORS.Secondary}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function()
                createTween(InputBox, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
                
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
            
            local function updateSlider(value)
                value = math.clamp(value, slider.Min, slider.Max)
                slider.Value = value
                
                local percentage = (value - slider.Min) / (slider.Max - slider.Min)
                
                createTween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.15)
                createTween(SliderHandle, {Position = UDim2.new(percentage, -9, 0.5, -9)}, 0.15)
                
                InputBox.Text = hasDecimals and string.format("%.2f", value) or tostring(math.floor(value))
                slider.Callback(value)
            end
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    createTween(SliderHandle, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -11, 0.5, -11)}, 0.2)
                    
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
                            createTween(SliderHandle, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -9, 0.5, -9)}, 0.2)
                            createTween(SliderStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                            connection:Disconnect()
                            connection2:Disconnect()
                        end
                    end)
                end
            end)
            
            table.insert(tab.Components, slider)
            return slider
        end
        
        function tab:AddSection(name)
            local section = {}
            section.Name = name
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -20, 0, 40)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(0, 0, 1, 0)
            SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = "  " .. name .. "  "
            SectionLabel.TextColor3 = COLORS.White
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 14
            SectionLabel.AutomaticSize = Enum.AutomaticSize.X
            SectionLabel.Parent = SectionFrame
            
            local LeftLine = Instance.new("Frame")
            LeftLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 10, 0, 2)
            LeftLine.Position = UDim2.new(0, 0, 0.5, -1)
            LeftLine.BorderSizePixel = 0
            LeftLine.Parent = SectionFrame
            
            local LeftGradient = Instance.new("UIGradient")
            LeftGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, COLORS.Background),
                ColorSequenceKeypoint.new(0.5, COLORS.Gray),
                ColorSequenceKeypoint.new(1, self.AccentColor)
            }
            LeftGradient.Parent = LeftLine
            
            local RightLine = Instance.new("Frame")
            RightLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 10, 0, 2)
            RightLine.Position = UDim2.new(0.5, SectionLabel.TextBounds.X / 2 + 10, 0.5, -1)
            RightLine.BorderSizePixel = 0
            RightLine.Parent = SectionFrame
            
            local RightGradient = Instance.new("UIGradient")
            RightGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, self.AccentColor),
                ColorSequenceKeypoint.new(0.5, COLORS.Gray),
                ColorSequenceKeypoint.new(1, COLORS.Background)
            }
            RightGradient.Parent = RightLine
            
            SectionLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
                LeftLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 10, 0, 2)
                RightLine.Position = UDim2.new(0.5, SectionLabel.TextBounds.X / 2 + 10, 0.5, -1)
                RightLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 10, 0, 2)
            end)
            
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
        NotifFrame.Size = UDim2.new(0, 380, 0, 110)
        NotifFrame.Position = UDim2.new(1, 400, 1, -130)
        NotifFrame.BackgroundColor3 = COLORS.Secondary
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = self.GUI
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 14)
        NotifCorner.Parent = NotifFrame
        
        local NotifShadow = Instance.new("ImageLabel")
        NotifShadow.Size = UDim2.new(1, 40, 1, 40)
        NotifShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        NotifShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        NotifShadow.BackgroundTransparency = 1
        NotifShadow.Image = "rbxassetid://5028857084"
        NotifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        NotifShadow.ImageTransparency = 0.5
        NotifShadow.ScaleType = Enum.ScaleType.Slice
        NotifShadow.SliceCenter = Rect.new(24, 24, 276, 276)
        NotifShadow.ZIndex = 0
        NotifShadow.Parent = NotifFrame
        
        local NotifAccent = Instance.new("Frame")
        NotifAccent.Size = UDim2.new(0, 4, 1, 0)
        NotifAccent.BackgroundColor3 = self.AccentColor
        NotifAccent.BorderSizePixel = 0
        NotifAccent.Parent = NotifFrame
        
        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(0, 14)
        AccentCorner.Parent = NotifAccent
        
        local NotifIconContainer = Instance.new("Frame")
        NotifIconContainer.Size = UDim2.new(0, 70, 0, 70)
        NotifIconContainer.Position = UDim2.new(0, 20, 0.5, -35)
        NotifIconContainer.BackgroundColor3 = self.AccentColor
        NotifIconContainer.BorderSizePixel = 0
        NotifIconContainer.Parent = NotifFrame
        
        local IconContainerCorner = Instance.new("UICorner")
        IconContainerCorner.CornerRadius = UDim.new(0, 12)
        IconContainerCorner.Parent = NotifIconContainer
        
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Size = UDim2.new(0, 45, 0, 45)
        NotifIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        NotifIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Image = notification.Icon
        NotifIcon.ImageColor3 = COLORS.White
        NotifIcon.Parent = NotifIconContainer
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -110, 0, 30)
        NotifTitle.Position = UDim2.new(0, 100, 0, 20)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = notification.Title
        NotifTitle.TextColor3 = COLORS.White
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = 16
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.TextYAlignment = Enum.TextYAlignment.Top
        NotifTitle.Parent = NotifFrame
        
        local NotifBody = Instance.new("TextLabel")
        NotifBody.Size = UDim2.new(1, -110, 0, 45)
        NotifBody.Position = UDim2.new(0, 100, 0, 50)
        NotifBody.BackgroundTransparency = 1
        NotifBody.Text = notification.Body
        NotifBody.TextColor3 = COLORS.Gray
        NotifBody.Font = Enum.Font.Gotham
        NotifBody.TextSize = 13
        NotifBody.TextXAlignment = Enum.TextXAlignment.Left
        NotifBody.TextYAlignment = Enum.TextYAlignment.Top
        NotifBody.TextWrapped = true
        NotifBody.Parent = NotifFrame
        
        createTween(NotifFrame, {Position = UDim2.new(1, -400, 1, -130)}, 0.5, Enum.EasingStyle.Back)
        
        wait(notification.Duration)
        
        createTween(NotifFrame, {Position = UDim2.new(1, 20, 1, -130)}, 0.4, Enum.EasingStyle.Back)
        wait(0.4)
        NotifFrame:Destroy()
        
        return notification
    end
    
    return self
end

return UILibrary
