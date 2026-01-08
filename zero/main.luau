local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local COLORS = {
    Background = Color3.fromRGB(12, 12, 18),
    Secondary = Color3.fromRGB(18, 18, 26),
    Tertiary = Color3.fromRGB(24, 24, 34),
    Quaternary = Color3.fromRGB(30, 30, 42),
    Accent = Color3.fromRGB(138, 130, 255),
    AccentDark = Color3.fromRGB(100, 90, 200),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(170, 170, 190),
    DarkGray = Color3.fromRGB(90, 90, 110),
    Success = Color3.fromRGB(110, 255, 160),
    Error = Color3.fromRGB(255, 110, 110),
    Warning = Color3.fromRGB(255, 200, 100)
}

local ICONS = {
    DropdownClosed = "rbxassetid://116845122064768",
    DropdownOpen = "rbxassetid://132854725146991",
    Button = "rbxassetid://110294213486252"
}

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function createTween(instance, properties, duration, style)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function addGlow(frame, color, intensity)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 60, 1, 60)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or COLORS.Accent
    glow.ImageTransparency = intensity or 0.6
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
    ScreenGui.IgnoreGuiInset = true
    
    local success = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game:GetService("Lighting")
    
    local windowSize = isMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 850, 0, 580)
    local windowPosition = isMobile and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, -425, 0.5, -290)
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = windowPosition
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainShadow = Instance.new("ImageLabel")
    MainShadow.Name = "Shadow"
    MainShadow.Size = UDim2.new(1, 80, 1, 80)
    MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainShadow.BackgroundTransparency = 1
    MainShadow.Image = "rbxassetid://5028857084"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.4
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    MainShadow.ZIndex = 0
    MainShadow.Parent = MainFrame
    
    addGlow(MainFrame, self.AccentColor, 0.85)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, isMobile and 20 or 18)
    UICorner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, isMobile and 70 : 65)
    TopBar.BackgroundColor3 = COLORS.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, isMobile and 20 or 18)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 18)
    TopBarCover.Position = UDim2.new(0, 0, 1, -18)
    TopBarCover.BackgroundColor3 = COLORS.Secondary
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 3)
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.BackgroundColor3 = self.AccentColor
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = TopBar
    
    local AccentGradient = Instance.new("UIGradient")
    AccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.White),
        ColorSequenceKeypoint.new(0.5, self.AccentColor),
        ColorSequenceKeypoint.new(1, COLORS.White)
    }
    AccentGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    AccentGradient.Parent = AccentLine
    
    spawn(function()
        while AccentLine and AccentLine.Parent do
            createTween(AccentGradient, {Offset = Vector2.new(1, 0)}, 3, Enum.EasingStyle.Linear)
            wait(3)
            AccentGradient.Offset = Vector2.new(-1, 0)
        end
    end)
    
    local iconSize = isMobile and 50 or 48
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, iconSize, 0, iconSize)
    IconContainer.Position = UDim2.new(0, isMobile and 15 : 18, 0.5, -iconSize/2)
    IconContainer.BackgroundColor3 = self.AccentColor
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = TopBar
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 14)
    IconCorner.Parent = IconContainer
    
    addGlow(IconContainer, self.AccentColor, 0.75)
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, iconSize * 0.6, 0, iconSize * 0.6)
    IconLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = self.Icon
    IconLabel.ImageColor3 = COLORS.White
    IconLabel.Parent = IconContainer
    
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Size = UDim2.new(0, 450, 1, 0)
    TitleContainer.Position = UDim2.new(0, iconSize + (isMobile and 25 : 28), 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 28)
    TitleLabel.Position = UDim2.new(0, 0, 0, isMobile and 14 : 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = isMobile and 20 : 19
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.Parent = TitleContainer
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 20)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, isMobile and 38 : 36)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.Subtitle
    SubtitleLabel.TextColor3 = COLORS.Gray
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextSize = isMobile and 14 : 13
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    SubtitleLabel.Parent = TitleContainer
    
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Size = UDim2.new(0, isMobile and 90 : 100, 1, 0)
    ControlsContainer.Position = UDim2.new(1, isMobile and -100 : -110, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = TopBar
    
    local buttonSize = isMobile and 40 : 38
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -buttonSize/2)
    MinimizeButton.BackgroundColor3 = COLORS.Tertiary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = ""
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = ControlsContainer
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 11)
    MinCorner.Parent = MinimizeButton
    
    local MinIcon = Instance.new("TextLabel")
    MinIcon.Size = UDim2.new(1, 0, 1, 0)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Text = "−"
    MinIcon.TextColor3 = COLORS.White
    MinIcon.Font = Enum.Font.GothamBold
    MinIcon.TextSize = isMobile and 22 : 20
    MinIcon.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    CloseButton.Position = UDim2.new(0, isMobile and 50 : 52, 0.5, -buttonSize/2)
    CloseButton.BackgroundColor3 = COLORS.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = ""
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = ControlsContainer
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 11)
    CloseCorner.Parent = CloseButton
    
    addGlow(CloseButton, COLORS.Error, 0.7)
    
    local CloseIcon = Instance.new("TextLabel")
    CloseIcon.Size = UDim2.new(1, 0, 1, 0)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Text = "×"
    CloseIcon.TextColor3 = COLORS.White
    CloseIcon.Font = Enum.Font.GothamBold
    CloseIcon.TextSize = isMobile and 26 : 24
    CloseIcon.Parent = CloseButton
    
    MinimizeButton.MouseEnter:Connect(function()
        if not isMobile then
            createTween(MinimizeButton, {BackgroundColor3 = self.AccentColor}, 0.2)
        end
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        if not isMobile then
            createTween(MinimizeButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
        end
    end)
    
    CloseButton.MouseEnter:Connect(function()
        if not isMobile then
            createTween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
        end
    end)
    
    CloseButton.MouseLeave:Connect(function()
        if not isMobile then
            createTween(CloseButton, {BackgroundColor3 = COLORS.Error}, 0.2)
        end
    end)
    
    local sidebarWidth = isMobile and 0 : 210
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, sidebarWidth, 1, -(isMobile and 70 : 68))
    Sidebar.Position = UDim2.new(0, 0, 0, isMobile and 70 : 68)
    Sidebar.BackgroundColor3 = COLORS.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.ScrollBarImageColor3 = self.AccentColor
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Visible = not isMobile
    Sidebar.Parent = MainFrame
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 12)
    SidebarPadding.Parent = Sidebar
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 8)
    SidebarList.Parent = Sidebar
    
    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 24)
    end)
    
    local MobileTabBar = nil
    if isMobile then
        MobileTabBar = Instance.new("Frame")
        MobileTabBar.Name = "MobileTabBar"
        MobileTabBar.Size = UDim2.new(1, 0, 0, 60)
        MobileTabBar.Position = UDim2.new(0, 0, 0, 70)
        MobileTabBar.BackgroundColor3 = COLORS.Secondary
        MobileTabBar.BorderSizePixel = 0
        MobileTabBar.Parent = MainFrame
        
        local TabBarList = Instance.new("UIListLayout")
        TabBarList.FillDirection = Enum.FillDirection.Horizontal
        TabBarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabBarList.VerticalAlignment = Enum.VerticalAlignment.Center
        TabBarList.Padding = UDim.new(0, 10)
        TabBarList.Parent = MobileTabBar
        
        local TabBarPadding = Instance.new("UIPadding")
        TabBarPadding.PaddingLeft = UDim.new(0, 15)
        TabBarPadding.PaddingRight = UDim.new(0, 15)
        TabBarPadding.Parent = MobileTabBar
    end
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = isMobile and UDim2.new(1, 0, 1, -130) or UDim2.new(1, -sidebarWidth, 1, -68)
    ContentFrame.Position = isMobile and UDim2.new(0, 0, 0, 130) or UDim2.new(0, sidebarWidth, 0, 68)
    ContentFrame.BackgroundColor3 = COLORS.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = isMobile and 4 : 6
    ContentFrame.ScrollBarImageColor3 = self.AccentColor
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, isMobile and 15 : 14)
    ContentList.Parent = ContentFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, isMobile and 15 : 20)
    ContentPadding.PaddingLeft = UDim.new(0, isMobile and 15 : 20)
    ContentPadding.PaddingRight = UDim.new(0, isMobile and 15 : 20)
    ContentPadding.PaddingBottom = UDim.new(0, isMobile and 15 : 20)
    ContentPadding.Parent = ContentFrame
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + (isMobile and 30 : 40))
    end)
    
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Size = isMobile and UDim2.new(0.9, 0, 0, 80) or UDim2.new(0, 480, 0, 75)
    MinimizedFrame.Position = isMobile and UDim2.new(0.5, 0, 0.95, 0) or UDim2.new(0.5, -240, 0.95, -37.5)
    MinimizedFrame.AnchorPoint = isMobile and Vector2.new(0.5, 1) or Vector2.new(0.5, 0.5)
    MinimizedFrame.BackgroundColor3 = COLORS.Secondary
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = ScreenGui
    
    local MinFrameCorner = Instance.new("UICorner")
    MinFrameCorner.CornerRadius = UDim.new(0, isMobile and 20 : 38)
    MinFrameCorner.Parent = MinimizedFrame
    
    local MinFrameShadow = Instance.new("ImageLabel")
    MinFrameShadow.Size = UDim2.new(1, 50, 1, 50)
    MinFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    MinFrameShadow.BackgroundTransparency = 1
    MinFrameShadow.Image = "rbxassetid://5028857084"
    MinFrameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MinFrameShadow.ImageTransparency = 0.4
    MinFrameShadow.ScaleType = Enum.ScaleType.Slice
    MinFrameShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    MinFrameShadow.ZIndex = 0
    MinFrameShadow.Parent = MinimizedFrame
    
    addGlow(MinimizedFrame, self.AccentColor, 0.8)
    
    local MinAccentLine = Instance.new("Frame")
    MinAccentLine.Size = UDim2.new(1, 0, 0, 3)
    MinAccentLine.Position = UDim2.new(0, 0, 0, 0)
    MinAccentLine.BackgroundColor3 = self.AccentColor
    MinAccentLine.BorderSizePixel = 0
    MinAccentLine.Parent = MinimizedFrame
    
    local MinAccentCorner = Instance.new("UICorner")
    MinAccentCorner.CornerRadius = UDim.new(0, isMobile and 20 : 38)
    MinAccentCorner.Parent = MinAccentLine
    
    local minIconSize = isMobile and 55 : 52
    local MinIconContainer = Instance.new("Frame")
    MinIconContainer.Size = UDim2.new(0, minIconSize, 0, minIconSize)
    MinIconContainer.Position = UDim2.new(0, isMobile and 15 : 18, 0.5, -minIconSize/2)
    MinIconContainer.BackgroundColor3 = self.AccentColor
    MinIconContainer.BorderSizePixel = 0
    MinIconContainer.Parent = MinimizedFrame
    
    local MinIconCorner = Instance.new("UICorner")
    MinIconCorner.CornerRadius = UDim.new(1, 0)
    MinIconCorner.Parent = MinIconContainer
    
    addGlow(MinIconContainer, self.AccentColor, 0.7)
    
    local MinIcon2 = Instance.new("ImageLabel")
    MinIcon2.Size = UDim2.new(0, minIconSize * 0.65, 0, minIconSize * 0.65)
    MinIcon2.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinIcon2.AnchorPoint = Vector2.new(0.5, 0.5)
    MinIcon2.BackgroundTransparency = 1
    MinIcon2.Image = self.Icon
    MinIcon2.ImageColor3 = COLORS.White
    MinIcon2.Parent = MinIconContainer
    
    local MinTextContainer = Instance.new("Frame")
    MinTextContainer.Size = isMobile and UDim2.new(1, -140, 1, 0) or UDim2.new(0, 320, 1, 0)
    MinTextContainer.Position = UDim2.new(0, minIconSize + (isMobile and 20 : 25), 0, 0)
    MinTextContainer.BackgroundTransparency = 1
    MinTextContainer.Parent = MinimizedFrame
    
    local MinTitle = Instance.new("TextLabel")
    MinTitle.Size = UDim2.new(1, 0, 0, 32)
    MinTitle.Position = UDim2.new(0, 0, 0, isMobile and 16 : 15)
    MinTitle.BackgroundTransparency = 1
    MinTitle.Text = self.Title
    MinTitle.TextColor3 = COLORS.White
    MinTitle.Font = Enum.Font.GothamBold
    MinTitle.TextSize = isMobile and 17 : 16
    MinTitle.TextXAlignment = Enum.TextXAlignment.Left
    MinTitle.TextTruncate = Enum.TextTruncate.AtEnd
    MinTitle.Parent = MinTextContainer
    
    local MinSubtitle = Instance.new("TextLabel")
    MinSubtitle.Size = UDim2.new(1, 0, 0, 22)
    MinSubtitle.Position = UDim2.new(0, 0, 0, isMobile and 42 : 40)
    MinSubtitle.BackgroundTransparency = 1
    MinSubtitle.Text = self.Subtitle
    MinSubtitle.TextColor3 = COLORS.Gray
    MinSubtitle.Font = Enum.Font.Gotham
    MinSubtitle.TextSize = isMobile and 13 : 12
    MinSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    MinSubtitle.TextTruncate = Enum.TextTruncate.AtEnd
    MinSubtitle.Parent = MinTextContainer
    
    local restoreSize = isMobile and 60 : 58
    local RestoreButton = Instance.new("TextButton")
    RestoreButton.Size = UDim2.new(0, restoreSize, 0, restoreSize)
    RestoreButton.Position = UDim2.new(1, -(restoreSize + (isMobile and 12 : 15)), 0.5, -restoreSize/2)
    RestoreButton.BackgroundColor3 = self.AccentColor
    RestoreButton.BorderSizePixel = 0
    RestoreButton.Text = ""
    RestoreButton.AutoButtonColor = false
    RestoreButton.Parent = MinimizedFrame
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(1, 0)
    RestoreCorner.Parent = RestoreButton
    
    addGlow(RestoreButton, self.AccentColor, 0.65)
    
    local RestoreIcon = Instance.new("TextLabel")
    RestoreIcon.Size = UDim2.new(1, 0, 1, 0)
    RestoreIcon.BackgroundTransparency = 1
    RestoreIcon.Text = "+"
    RestoreIcon.TextColor3 = COLORS.White
    RestoreIcon.Font = Enum.Font.GothamBold
    RestoreIcon.TextSize = isMobile and 32 : 30
    RestoreIcon.Parent = RestoreButton
    
    RestoreButton.MouseEnter:Connect(function()
        if not isMobile then
            createTween(RestoreButton, {Size = UDim2.new(0, restoreSize + 6, 0, restoreSize + 6), Position = UDim2.new(1, -(restoreSize + 18), 0.5, -(restoreSize + 6)/2)}, 0.2, Enum.EasingStyle.Back)
        end
    end)
    
    RestoreButton.MouseLeave:Connect(function()
        if not isMobile then
            createTween(RestoreButton, {Size = UDim2.new(0, restoreSize, 0, restoreSize), Position = UDim2.new(1, -(restoreSize + 15), 0.5, -restoreSize/2)}, 0.2)
        end
    end)
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        createTween(MainFrame, {
            Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        }, 0.1, Enum.EasingStyle.Linear)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        local confirmSize = isMobile and UDim2.new(0.85, 0, 0, 200) or UDim2.new(0, 380, 0, 190)
        local ConfirmFrame = Instance.new("Frame")
        ConfirmFrame.Size = UDim2.new(0, 0, 0, 0)
        ConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        ConfirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        ConfirmFrame.BackgroundColor3 = COLORS.Secondary
        ConfirmFrame.BorderSizePixel = 0
        ConfirmFrame.ZIndex = 10
        ConfirmFrame.Parent = ScreenGui
        
        local ConfCorner = Instance.new("UICorner")
        ConfCorner.CornerRadius = UDim.new(0, 18)
        ConfCorner.Parent = ConfirmFrame
        
        local ConfShadow = Instance.new("ImageLabel")
        ConfShadow.Size = UDim2.new(1, 70, 1, 70)
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
        
        addGlow(ConfirmFrame, COLORS.Error, 0.75)
        
        local ConfAccent = Instance.new("Frame")
        ConfAccent.Size = UDim2.new(1, 0, 0, 4)
        ConfAccent.BackgroundColor3 = COLORS.Error
        ConfAccent.BorderSizePixel = 0
        ConfAccent.ZIndex = 11
        ConfAccent.Parent = ConfirmFrame
        
        local ConfAccentCorner = Instance.new("UICorner")
        ConfAccentCorner.CornerRadius = UDim.new(0, 18)
        ConfAccentCorner.Parent = ConfAccent
        
        local ConfText = Instance.new("TextLabel")
        ConfText.Size = UDim2.new(1, -40, 0, 90)
        ConfText.Position = UDim2.new(0, 20, 0, 35)
        ConfText.BackgroundTransparency = 1
        ConfText.Text = "Are you sure you want to close this interface?"
        ConfText.TextColor3 = COLORS.White
        ConfText.Font = Enum.Font.GothamBold
        ConfText.TextSize = isMobile and 17 : 16
        ConfText.TextWrapped = true
        ConfText.TextYAlignment = Enum.TextYAlignment.Top
        ConfText.ZIndex = 11
        ConfText.Parent = ConfirmFrame
        
        local buttonWidth = isMobile and 0.43 : 160
        local YesButton = Instance.new("TextButton")
        YesButton.Size = isMobile and UDim2.new(buttonWidth, 0, 0, 48) or UDim2.new(0, buttonWidth, 0, 48)
        YesButton.Position = UDim2.new(0, 20, 1, -68)
        YesButton.BackgroundColor3 = COLORS.Error
        YesButton.BorderSizePixel = 0
        YesButton.Text = "Yes, Close"
        YesButton.TextColor3 = COLORS.White
        YesButton.Font = Enum.Font.GothamBold
        YesButton.TextSize = isMobile and 15 : 14
        YesButton.AutoButtonColor = false
        YesButton.ZIndex = 11
        YesButton.Parent = ConfirmFrame
        
        local YesCorner = Instance.new("UICorner")
        YesCorner.CornerRadius = UDim.new(0, 12)
        YesCorner.Parent = YesButton
        
        addGlow(YesButton, COLORS.Error, 0.7)
        
        local NoButton = Instance.new("TextButton")
        NoButton.Size = isMobile and UDim2.new(buttonWidth, 0, 0, 48) or UDim2.new(0, buttonWidth, 0, 48)
        NoButton.Position = isMobile and UDim2.new(1, -20, 1, -68) or UDim2.new(1, -180, 1, -68)
        NoButton.AnchorPoint = isMobile and Vector2.new(1, 0) or Vector2.new(0, 0)
        NoButton.BackgroundColor3 = COLORS.Tertiary
        NoButton.BorderSizePixel = 0
        NoButton.Text = "Cancel"
        NoButton.TextColor3 = COLORS.White
        NoButton.Font = Enum.Font.GothamBold
        NoButton.TextSize = isMobile and 15 : 14
        NoButton.AutoButtonColor = false
        NoButton.ZIndex = 11
        NoButton.Parent = ConfirmFrame
        
        local NoCorner = Instance.new("UICorner")
        NoCorner.CornerRadius = UDim.new(0, 12)
        NoCorner.Parent = NoButton
        
        YesButton.MouseEnter:Connect(function()
            if not isMobile then
                createTween(YesButton, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
            end
        end)
        
        YesButton.MouseLeave:Connect(function()
            if not isMobile then
                createTween(YesButton, {BackgroundColor3 = COLORS.Error}, 0.2)
            end
        end)
        
        NoButton.MouseEnter:Connect(function()
            if not isMobile then
                createTween(NoButton, {BackgroundColor3 = self.AccentColor}, 0.2)
            end
        end)
        
        NoButton.MouseLeave:Connect(function()
            if not isMobile then
                createTween(NoButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
            end
        end)
        
        createTween(ConfirmFrame, {Size = confirmSize}, 0.4, Enum.EasingStyle.Back)
        createTween(Blur, {Size = 15}, 0.3)
        
        YesButton.MouseButton1Click:Connect(function()
            createTween(ConfirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
            createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
            createTween(Blur, {Size = 0}, 0.3)
            wait(0.4)
            ScreenGui:Destroy()
            Blur:Destroy()
        end)
        
        NoButton.MouseButton1Click:Connect(function()
            createTween(ConfirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
            createTween(Blur, {Size = 8}, 0.3)
            wait(0.3)
            ConfirmFrame:Destroy()
        end)
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self.IsMinimized = true
        createTween(Blur, {Size = 0}, 0.3)
        createTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        wait(0.4)
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        MinimizedFrame.Size = UDim2.new(0, 0, 0, 0)
        createTween(MinimizedFrame, {Size = isMobile and UDim2.new(0.9, 0, 0, 80) or UDim2.new(0, 480, 0, 75)}, 0.4, Enum.EasingStyle.Back)
    end)
    
    RestoreButton.MouseButton1Click:Connect(function()
        self.IsMinimized = false
        createTween(MinimizedFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        wait(0.3)
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        createTween(MainFrame, {Size = windowSize}, 0.4, Enum.EasingStyle.Back)
        createTween(Blur, {Size = 8}, 0.3)
    end)
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    createTween(MainFrame, {Size = windowSize}, 0.5, Enum.EasingStyle.Back)
    createTween(Blur, {Size = 8}, 0.4)
    
    self.GUI = ScreenGui
    self.MainFrame = MainFrame
    self.Sidebar = Sidebar
    self.ContentFrame = ContentFrame
    self.SidebarList = SidebarList
    self.ContentList = ContentList
    self.AccentColor = self.AccentColor
    self.MobileTabBar = MobileTabBar
    
    function self:CreateTab(name, icon)
        local tab = {}
        tab.Name = name
        tab.Icon = icon or ""
        tab.Components = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 52)
        TabButton.BackgroundColor3 = COLORS.Tertiary
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.ClipsDescendants = true
        TabButton.Parent = self.Sidebar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 13)
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
        TabIcon.Size = UDim2.new(0, 26, 0, 26)
        TabIcon.Position = UDim2.new(0, 20, 0.5, -13)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ImageColor3 = COLORS.Gray
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -60, 1, 0)
        TabLabel.Position = UDim2.new(0, 52, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = COLORS.Gray
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        local MobileTabButton = nil
        if isMobile and MobileTabBar then
            MobileTabButton = Instance.new("TextButton")
            MobileTabButton.Name = name
            MobileTabButton.Size = UDim2.new(0, 60, 0, 50)
            MobileTabButton.BackgroundColor3 = COLORS.Tertiary
            MobileTabButton.BackgroundTransparency = 1
            MobileTabButton.BorderSizePixel = 0
            MobileTabButton.Text = ""
            MobileTabButton.AutoButtonColor = false
            MobileTabButton.Parent = MobileTabBar
            
            local MobileTabCorner = Instance.new("UICorner")
            MobileTabCorner.CornerRadius = UDim.new(0, 12)
            MobileTabCorner.Parent = MobileTabButton
            
            local MobileTabIcon = Instance.new("ImageLabel")
            MobileTabIcon.Size = UDim2.new(0, 28, 0, 28)
            MobileTabIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            MobileTabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            MobileTabIcon.BackgroundTransparency = 1
            MobileTabIcon.Image = icon
            MobileTabIcon.ImageColor3 = COLORS.Gray
            MobileTabIcon.Parent = MobileTabButton
        end
        
        local TabContent = Instance.new("Frame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = self.ContentFrame
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, isMobile and 15 : 14)
        TabContentList.Parent = TabContent
        
        if not isMobile then
            TabButton.MouseEnter:Connect(function()
                if self.CurrentTab ~= tab then
                    createTween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
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
        end
        
        local function selectTab()
            for _, existingTab in pairs(self.Tabs) do
                local existingButton = existingTab.Button
                local existingIndicator = existingButton:FindFirstChild("Indicator")
                local existingIcon = existingButton:FindFirstChild("ImageLabel")
                local existingLabel = existingButton:FindFirstChild("TextLabel")
                
                createTween(existingButton, {BackgroundTransparency = 1}, 0.3)
                if existingIndicator then
                    createTween(existingIndicator, {Size = UDim2.new(0, 4, 0, 0)}, 0.3)
                end
                if existingIcon then
                    createTween(existingIcon, {ImageColor3 = COLORS.Gray}, 0.3)
                end
                if existingLabel then
                    createTween(existingLabel, {TextColor3 = COLORS.Gray}, 0.3)
                end
                existingTab.Content.Visible = false
                
                if existingTab.MobileButton then
                    createTween(existingTab.MobileButton, {BackgroundTransparency = 1}, 0.3)
                    local mobileIcon = existingTab.MobileButton:FindFirstChild("ImageLabel")
                    if mobileIcon then
                        createTween(mobileIcon, {ImageColor3 = COLORS.Gray}, 0.3)
                    end
                end
            end
            
            createTween(TabButton, {BackgroundTransparency = 0}, 0.3)
            createTween(TabIndicator, {Size = UDim2.new(0, 4, 0, 38)}, 0.3, Enum.EasingStyle.Back)
            createTween(TabIcon, {ImageColor3 = self.AccentColor}, 0.3)
            createTween(TabLabel, {TextColor3 = COLORS.White}, 0.3)
            TabContent.Visible = true
            self.CurrentTab = tab
            
            if MobileTabButton then
                createTween(MobileTabButton, {BackgroundTransparency = 0}, 0.3)
                local mobileIcon = MobileTabButton:FindFirstChild("ImageLabel")
                if mobileIcon then
                    createTween(mobileIcon, {ImageColor3 = self.AccentColor}, 0.3)
                end
            end
        end
        
        TabButton.MouseButton1Click:Connect(selectTab)
        if MobileTabButton then
            MobileTabButton.MouseButton1Click:Connect(selectTab)
        end
        
        tab.Button = TabButton
        tab.MobileButton = MobileTabButton
        tab.Content = TabContent
        tab.ContentList = TabContentList
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            selectTab()
        end
        
        function tab:AddToggle(name, default, callback)
            local toggle = {}
            toggle.Name = name
            toggle.Value = default or false
            toggle.Callback = callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, isMobile and -10 : -25, 0, isMobile and 60 : 58)
            ToggleFrame.BackgroundColor3 = COLORS.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 13)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = COLORS.Tertiary
            ToggleStroke.Thickness = 1
            ToggleStroke.Transparency = 0.5
            ToggleStroke.Parent = ToggleFrame
            
            addGlow(ToggleFrame, toggle.Value and self.AccentColor or COLORS.Tertiary, 0.9)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(0.65, -20, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 18, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = COLORS.White
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.TextSize = isMobile and 15 : 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextWrapped = true
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, isMobile and 54 : 52, 0, isMobile and 28 : 27)
            ToggleButton.Position = UDim2.new(1, isMobile and -66 : -70, 0.5, isMobile and -14 : -13.5)
            ToggleButton.BackgroundColor3 = toggle.Value and self.AccentColor or COLORS.DarkGray
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCorner2 = Instance.new("UICorner")
            ToggleCorner2.CornerRadius = UDim.new(1, 0)
            ToggleCorner2.Parent = ToggleButton
            
            local circleSize = isMobile and 22 : 21
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
            ToggleCircle.Position = toggle.Value and UDim2.new(1, -(circleSize + 3), 0.5, -circleSize/2) or UDim2.new(0, 3, 0.5, -circleSize/2)
            ToggleCircle.BackgroundColor3 = COLORS.White
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local CircleShadow = Instance.new("ImageLabel")
            CircleShadow.Size = UDim2.new(1, 12, 1, 12)
            CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            CircleShadow.BackgroundTransparency = 1
            CircleShadow.Image = "rbxassetid://5028857084"
            CircleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            CircleShadow.ImageTransparency = 0.65
            CircleShadow.ScaleType = Enum.ScaleType.Slice
            CircleShadow.SliceCenter = Rect.new(24, 24, 276, 276)
            CircleShadow.ZIndex = 0
            CircleShadow.Parent = ToggleCircle
            
            if not isMobile then
                ToggleFrame.MouseEnter:Connect(function()
                    createTween(ToggleStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                end)
                
                ToggleFrame.MouseLeave:Connect(function()
                    createTween(ToggleStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                end)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggle.Value = not toggle.Value
                
                local glow = ToggleFrame:FindFirstChild("Glow")
                if glow then
                    createTween(glow, {ImageColor3 = toggle.Value and self.AccentColor or COLORS.Tertiary}, 0.3)
                end
                
                createTween(ToggleButton, {BackgroundColor3 = toggle.Value and self.AccentColor or COLORS.DarkGray}, 0.3)
                createTween(ToggleCircle, {
                    Position = toggle.Value and UDim2.new(1, -(circleSize + 3), 0.5, -circleSize/2) or UDim2.new(0, 3, 0.5, -circleSize/2)
                }, 0.3, Enum.EasingStyle.Back)
                
                if toggle.Value then
                    createTween(ToggleCircle, {Size = UDim2.new(0, circleSize + 4, 0, circleSize + 4)}, 0.15)
                    wait(0.15)
                    createTween(ToggleCircle, {Size = UDim2.new(0, circleSize, 0, circleSize)}, 0.15)
                end
                
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
            DropdownFrame.Size = UDim2.new(1, isMobile and -10 : -25, 0, isMobile and 60 : 58)
            DropdownFrame.BackgroundColor3 = COLORS.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = false
            DropdownFrame.Parent = TabContent
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 13)
            DropCorner.Parent = DropdownFrame
            
            local DropStroke = Instance.new("UIStroke")
            DropStroke.Color = COLORS.Tertiary
            DropStroke.Thickness = 1
            DropStroke.Transparency = 0.5
            DropStroke.Parent = DropdownFrame
            
            addGlow(DropdownFrame, COLORS.Tertiary, 0.9)
            
            local DropdownHeader = Instance.new("TextButton")
            DropdownHeader.Size = UDim2.new(1, 0, 0, isMobile and 60 : 58)
            DropdownHeader.BackgroundTransparency = 1
            DropdownHeader.Text = ""
            DropdownHeader.AutoButtonColor = false
            DropdownHeader.Parent = DropdownFrame
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0.45, -20, 1, 0)
            DropLabel.Position = UDim2.new(0, 18, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = name
            DropLabel.TextColor3 = COLORS.White
            DropLabel.Font = Enum.Font.GothamMedium
            DropLabel.TextSize = isMobile and 15 : 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.TextWrapped = true
            DropLabel.Parent = DropdownHeader
            
            local DropSelected = Instance.new("TextLabel")
            DropSelected.Size = UDim2.new(0.5, 0, 1, 0)
            DropSelected.Position = UDim2.new(0.45, 0, 0, 0)
            DropSelected.BackgroundTransparency = 1
            DropSelected.Text = multiSelect and "" or (default or options[1])
            DropSelected.TextColor3 = self.AccentColor
            DropSelected.Font = Enum.Font.GothamBold
            DropSelected.TextSize = isMobile and 14 : 13
            DropSelected.TextXAlignment = Enum.TextXAlignment.Right
            DropSelected.TextTruncate = Enum.TextTruncate.AtEnd
            DropSelected.Parent = DropdownHeader
            
            local DropIcon = Instance.new("ImageLabel")
            DropIcon.Size = UDim2.new(0, isMobile and 22 : 20, 0, isMobile and 22 : 20)
            DropIcon.Position = UDim2.new(1, isMobile and -36 : -38, 0.5, isMobile and -11 : -10)
            DropIcon.BackgroundTransparency = 1
            DropIcon.Image = ICONS.DropdownClosed
            DropIcon.ImageColor3 = COLORS.Gray
            DropIcon.Rotation = 0
            DropIcon.Parent = DropdownHeader
            
            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Size = UDim2.new(1, 0, 0, 0)
            DropdownList.Position = UDim2.new(0, 0, 0, isMobile and 65 : 63)
            DropdownList.BackgroundColor3 = COLORS.Tertiary
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.ScrollBarThickness = isMobile and 3 : 4
            DropdownList.ScrollBarImageColor3 = self.AccentColor
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownList.Parent = DropdownFrame
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 13)
            ListCorner.Parent = DropdownList
            
            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = self.AccentColor
            ListStroke.Thickness = 1
            ListStroke.Transparency = 0.3
            ListStroke.Parent = DropdownList
            
            addGlow(DropdownList, self.AccentColor, 0.8)
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, isMobile and 5 : 4)
            OptionsLayout.Parent = DropdownList
            
            local OptionsPadding = Instance.new("UIPadding")
            OptionsPadding.PaddingTop = UDim.new(0, isMobile and 10 : 8)
            OptionsPadding.PaddingLeft = UDim.new(0, isMobile and 10 : 8)
            OptionsPadding.PaddingRight = UDim.new(0, isMobile and 10 : 8)
            OptionsPadding.PaddingBottom = UDim.new(0, isMobile and 10 : 8)
            OptionsPadding.Parent = DropdownList
            
            OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y + (isMobile and 20 : 16))
            end)
            
            if not isMobile then
                DropdownFrame.MouseEnter:Connect(function()
                    createTween(DropStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                end)
                
                DropdownFrame.MouseLeave:Connect(function()
                    if not dropdown.IsOpen then
                        createTween(DropStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                    end
                end)
            end
            
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
                OptionButton.Size = UDim2.new(1, isMobile and -20 : -16, 0, isMobile and 42 : 40)
                OptionButton.BackgroundColor3 = COLORS.Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = ""
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 11)
                OptionCorner.Parent = OptionButton
                
                local OptionIndicator = Instance.new("Frame")
                OptionIndicator.Size = UDim2.new(0, 0, 0, isMobile and 28 : 26)
                OptionIndicator.Position = UDim2.new(0, isMobile and 10 : 8, 0.5, isMobile and -14 : -13)
                OptionIndicator.BackgroundColor3 = self.AccentColor
                OptionIndicator.BorderSizePixel = 0
                OptionIndicator.Parent = OptionButton
                
                local IndicatorCorner2 = Instance.new("UICorner")
                IndicatorCorner2.CornerRadius = UDim.new(1, 0)
                IndicatorCorner2.Parent = OptionIndicator
                
                addGlow(OptionIndicator, self.AccentColor, 0.7)
                
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -30, 1, 0)
                OptionLabel.Position = UDim2.new(0, isMobile and 20 : 18, 0, 0)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Text = option
                OptionLabel.TextColor3 = COLORS.White
                OptionLabel.Font = Enum.Font.Gotham
                OptionLabel.TextSize = isMobile and 14 : 13
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.TextTruncate = Enum.TextTruncate.AtEnd
                OptionLabel.Parent = OptionButton
                
                if multiSelect then
                    for _, selected in pairs(dropdown.Selected) do
                        if selected == option then
                            OptionIndicator.Size = UDim2.new(0, 3, 0, isMobile and 28 : 26)
                            OptionButton.BackgroundColor3 = COLORS.Tertiary
                            break
                        end
                    end
                else
                    if dropdown.Selected == option then
                        OptionIndicator.Size = UDim2.new(0, 3, 0, isMobile and 28 : 26)
                        OptionButton.BackgroundColor3 = COLORS.Tertiary
                    end
                end
                
                if not isMobile then
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
                            createTween(OptionIndicator, {Size = UDim2.new(0, 0, 0, isMobile and 28 : 26)}, 0.3)
                            createTween(OptionButton, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                        else
                            table.insert(dropdown.Selected, option)
                            createTween(OptionIndicator, {Size = UDim2.new(0, 3, 0, isMobile and 28 : 26)}, 0.3, Enum.EasingStyle.Back)
                            createTween(OptionButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
                        end
                    else
                        for _, child in pairs(DropdownList:GetChildren()) do
                            if child:IsA("TextButton") then
                                local indicator = child:FindFirstChild("Frame")
                                if indicator then
                                    createTween(indicator, {Size = UDim2.new(0, 0, 0, isMobile and 28 : 26)}, 0.3)
                                end
                                if child ~= OptionButton then
                                    createTween(child, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                                end
                            end
                        end
                        
                        dropdown.Selected = option
                        createTween(OptionIndicator, {Size = UDim2.new(0, 3, 0, isMobile and 28 : 26)}, 0.3, Enum.EasingStyle.Back)
                        createTween(OptionButton, {BackgroundColor3 = COLORS.Tertiary}, 0.2)
                    end
                    
                    updateDropdown()
                    dropdown.Callback(dropdown.Selected)
                end)
            end
            
            DropdownHeader.MouseButton1Click:Connect(function()
                dropdown.IsOpen = not dropdown.IsOpen
                
                local glow = DropdownFrame:FindFirstChild("Glow")
                
                if dropdown.IsOpen then
                    if glow then
                        createTween(glow, {ImageColor3 = self.AccentColor}, 0.3)
                    end
                    createTween(DropIcon, {Rotation = 180, ImageColor3 = self.AccentColor}, 0.3)
                    DropdownList.Visible = true
                    local contentHeight = math.min(#options * (isMobile and 47 : 44) + (isMobile and 20 : 16), isMobile and 250 : 220)
                    createTween(DropdownList, {Size = UDim2.new(1, 0, 0, contentHeight)}, 0.3, Enum.EasingStyle.Back)
                    createTween(DropdownFrame, {Size = UDim2.new(1, isMobile and -10 : -25, 0, (isMobile and 65 : 63) + contentHeight)}, 0.3)
                    createTween(DropStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                else
                    if glow then
                        createTween(glow, {ImageColor3 = COLORS.Tertiary}, 0.3)
                    end
                    createTween(DropIcon, {Rotation = 0, ImageColor3 = COLORS.Gray}, 0.3)
                    createTween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                    createTween(DropdownFrame, {Size = UDim2.new(1, isMobile and -10 : -25, 0, isMobile and 60 : 58)}, 0.3)
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
            ButtonFrame.Size = UDim2.new(1, isMobile and -10 : -25, 0, isMobile and 60 : 58)
            ButtonFrame.BackgroundColor3 = COLORS.Secondary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 13)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = COLORS.Tertiary
            ButtonStroke.Thickness = 1
            ButtonStroke.Transparency = 0.5
            ButtonStroke.Parent = ButtonFrame
            
            addGlow(ButtonFrame, COLORS.Tertiary, 0.9)
            
            local ButtonElement = Instance.new("TextButton")
            ButtonElement.Size = UDim2.new(1, 0, 1, 0)
            ButtonElement.BackgroundTransparency = 1
            ButtonElement.Text = ""
            ButtonElement.AutoButtonColor = false
            ButtonElement.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -70, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 18, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = name
            ButtonLabel.TextColor3 = COLORS.White
            ButtonLabel.Font = Enum.Font.GothamMedium
            ButtonLabel.TextSize = isMobile and 15 : 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.TextWrapped = true
            ButtonLabel.Parent = ButtonElement
            
            local ButtonIcon = Instance.new("ImageLabel")
            ButtonIcon.Size = UDim2.new(0, isMobile and 22 : 20, 0, isMobile and 22 : 20)
            ButtonIcon.Position = UDim2.new(1, isMobile and -36 : -38, 0.5, isMobile and -11 : -10)
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Image = ICONS.Button
            ButtonIcon.ImageColor3 = COLORS.Gray
            ButtonIcon.Parent = ButtonElement
            
            if not isMobile then
                ButtonFrame.MouseEnter:Connect(function()
                    createTween(ButtonStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                    createTween(ButtonIcon, {ImageColor3 = self.AccentColor}, 0.2)
                    local glow = ButtonFrame:FindFirstChild("Glow")
                    if glow then
                        createTween(glow, {ImageColor3 = self.AccentColor}, 0.2)
                    end
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    createTween(ButtonStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                    createTween(ButtonIcon, {ImageColor3 = COLORS.Gray}, 0.2)
                    local glow = ButtonFrame:FindFirstChild("Glow")
                    if glow then
                        createTween(glow, {ImageColor3 = COLORS.Tertiary}, 0.2)
                    end
                end)
            end
            
            ButtonElement.MouseButton1Click:Connect(function()
                local glow = ButtonFrame:FindFirstChild("Glow")
                if glow then
                    createTween(glow, {ImageColor3 = self.AccentColor, ImageTransparency = 0.4}, 0.1)
                end
                
                createTween(ButtonFrame, {BackgroundColor3 = self.AccentColor}, 0.1)
                createTween(ButtonLabel, {TextColor3 = COLORS.Background}, 0.1)
                createTween(ButtonIcon, {ImageColor3 = COLORS.Background}, 0.1)
                createTween(ButtonStroke, {Color = self.AccentColor, Transparency = 0}, 0.1)
                
                wait(0.1)
                
                createTween(ButtonFrame, {BackgroundColor3 = COLORS.Secondary}, 0.2)
                createTween(ButtonLabel, {TextColor3 = COLORS.White}, 0.2)
                createTween(ButtonIcon, {ImageColor3 = isMobile and COLORS.Gray or self.AccentColor}, 0.2)
                createTween(ButtonStroke, {Color = COLORS.Tertiary, Transparency = 0.5}, 0.2)
                if glow then
                    createTween(glow, {ImageColor3 = COLORS.Tertiary, ImageTransparency = 0.9}, 0.2)
                end
                
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
            SliderFrame.Size = UDim2.new(1, isMobile and -10 : -25, 0, isMobile and 95 : 90)
            SliderFrame.BackgroundColor3 = COLORS.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 13)
            SliderCorner.Parent = SliderFrame
            
            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Color = COLORS.Tertiary
            SliderStroke.Thickness = 1
            SliderStroke.Transparency = 0.5
            SliderStroke.Parent = SliderFrame
            
            addGlow(SliderFrame, COLORS.Tertiary, 0.9)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -30, 0, 28)
            SliderLabel.Position = UDim2.new(0, 18, 0, 14)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = COLORS.White
            SliderLabel.Font = Enum.Font.GothamMedium
            SliderLabel.TextSize = isMobile and 15 : 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.TextWrapped = true
            SliderLabel.Parent = SliderFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(0, isMobile and 85 : 82, 0, isMobile and 38 : 36)
            InputBox.Position = UDim2.new(0, 18, 0, isMobile and 47 : 45)
            InputBox.BackgroundColor3 = COLORS.Tertiary
            InputBox.BorderSizePixel = 0
            InputBox.Text = hasDecimals and string.format("%.2f", slider.Value) or tostring(slider.Value)
            InputBox.TextColor3 = COLORS.White
            InputBox.Font = Enum.Font.GothamMedium
            InputBox.TextSize = isMobile and 14 : 13
            InputBox.PlaceholderText = "Value"
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = SliderFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 9)
            InputCorner.Parent = InputBox
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, isMobile and -140 : -135, 0, isMobile and 7 : 6)
            SliderTrack.Position = UDim2.new(0, isMobile and 113 : 110, 0, isMobile and 62.5 : 61)
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
            
            addGlow(SliderFill, self.AccentColor, 0.6)
            
            local handleSize = isMobile and 20 : 19
            local SliderHandle = Instance.new("Frame")
            SliderHandle.Size = UDim2.new(0, handleSize, 0, handleSize)
            SliderHandle.Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -handleSize/2, 0.5, -handleSize/2)
            SliderHandle.BackgroundColor3 = COLORS.White
            SliderHandle.BorderSizePixel = 0
            SliderHandle.Parent = SliderTrack
            
            local HandleCorner = Instance.new("UICorner")
            HandleCorner.CornerRadius = UDim.new(1, 0)
            HandleCorner.Parent = SliderHandle
            
            local HandleShadow = Instance.new("ImageLabel")
            HandleShadow.Size = UDim2.new(1, 14, 1, 14)
            HandleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
            HandleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
            HandleShadow.BackgroundTransparency = 1
            HandleShadow.Image = "rbxassetid://5028857084"
            HandleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            HandleShadow.ImageTransparency = 0.65
            HandleShadow.ScaleType = Enum.ScaleType.Slice
            HandleShadow.SliceCenter = Rect.new(24, 24, 276, 276)
            HandleShadow.ZIndex = 0
            HandleShadow.Parent = SliderHandle
            
            addGlow(SliderHandle, self.AccentColor, 0.7)
            
            local draggingSlider = false
            
            if not isMobile then
                SliderFrame.MouseEnter:Connect(function()
                    createTween(SliderStroke, {Transparency = 0, Color = self.AccentColor}, 0.2)
                    local glow = SliderFrame:FindFirstChild("Glow")
                    if glow then
                        createTween(glow, {ImageColor3 = self.AccentColor}, 0.2)
                    end
                end)
                
                SliderFrame.MouseLeave:Connect(function()
                    if not draggingSlider then
                        createTween(SliderStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                        local glow = SliderFrame:FindFirstChild("Glow")
                        if glow then
                            createTween(glow, {ImageColor3 = COLORS.Tertiary}, 0.2)
                        end
                    end
                end)
            end
            
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
                createTween(SliderHandle, {Position = UDim2.new(percentage, -handleSize/2, 0.5, -handleSize/2)}, 0.15)
                
                InputBox.Text = hasDecimals and string.format("%.2f", value) or tostring(math.floor(value))
                slider.Callback(value)
            end
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    createTween(SliderHandle, {Size = UDim2.new(0, handleSize + 4, 0, handleSize + 4)}, 0.2)
                    
                    local function update(inputPos)
                        local mousePos = inputPos.Position.X
                        local trackPos = SliderTrack.AbsolutePosition.X
                        local trackSize = SliderTrack.AbsoluteSize.X
                        local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                        local value = slider.Min + (percentage * (slider.Max - slider.Min))
                        updateSlider(value)
                    end
                    
                    update(input)
                    
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input2)
                        if (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) and draggingSlider then
                            update(input2)
                        end
                    end)
                    
                    local connection2
                    connection2 = UserInputService.InputEnded:Connect(function(input2)
                        if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                            draggingSlider = false
                            createTween(SliderHandle, {Size = UDim2.new(0, handleSize, 0, handleSize)}, 0.2)
                            if not isMobile then
                                createTween(SliderStroke, {Transparency = 0.5, Color = COLORS.Tertiary}, 0.2)
                                local glow = SliderFrame:FindFirstChild("Glow")
                                if glow then
                                    createTween(glow, {ImageColor3 = COLORS.Tertiary}, 0.2)
                                end
                            end
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
            SectionFrame.Size = UDim2.new(1, isMobile and -10 : -25, 0, isMobile and 45 : 42)
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
            SectionLabel.TextSize = isMobile and 15 : 14
            SectionLabel.AutomaticSize = Enum.AutomaticSize.X
            SectionLabel.Parent = SectionFrame
            
            local LeftLine = Instance.new("Frame")
            LeftLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 12, 0, 2)
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
            RightLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 12, 0, 2)
            RightLine.Position = UDim2.new(0.5, SectionLabel.TextBounds.X / 2 + 12, 0.5, -1)
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
                LeftLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 12, 0, 2)
                RightLine.Position = UDim2.new(0.5, SectionLabel.TextBounds.X / 2 + 12, 0.5, -1)
                RightLine.Size = UDim2.new(0.5, -SectionLabel.TextBounds.X / 2 - 12, 0, 2)
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
        
        local notifSize = isMobile and UDim2.new(0.9, 0, 0, 120) or UDim2.new(0, 400, 0, 115)
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 0, 0, 0)
        NotifFrame.Position = isMobile and UDim2.new(0.5, 0, 1, 0) or UDim2.new(1, 0, 1, -130)
        NotifFrame.AnchorPoint = isMobile and Vector2.new(0.5, 1) or Vector2.new(0, 0)
        NotifFrame.BackgroundColor3 = COLORS.Secondary
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = self.GUI
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 15)
        NotifCorner.Parent = NotifFrame
        
        local NotifShadow = Instance.new("ImageLabel")
        NotifShadow.Size = UDim2.new(1, 50, 1, 50)
        NotifShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        NotifShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        NotifShadow.BackgroundTransparency = 1
        NotifShadow.Image = "rbxassetid://5028857084"
        NotifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        NotifShadow.ImageTransparency = 0.4
        NotifShadow.ScaleType = Enum.ScaleType.Slice
        NotifShadow.SliceCenter = Rect.new(24, 24, 276, 276)
        NotifShadow.ZIndex = 0
        NotifShadow.Parent = NotifFrame
        
        addGlow(NotifFrame, self.AccentColor, 0.75)
        
        local NotifAccent = Instance.new("Frame")
        NotifAccent.Size = UDim2.new(0, 4, 1, 0)
        NotifAccent.BackgroundColor3 = self.AccentColor
        NotifAccent.BorderSizePixel = 0
        NotifAccent.Parent = NotifFrame
        
        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(0, 15)
        AccentCorner.Parent = NotifAccent
        
        addGlow(NotifAccent, self.AccentColor, 0.5)
        
        local iconSize = isMobile and 75 : 72
        local NotifIconContainer = Instance.new("Frame")
        NotifIconContainer.Size = UDim2.new(0, iconSize, 0, iconSize)
        NotifIconContainer.Position = UDim2.new(0, isMobile and 22 : 20, 0.5, -iconSize/2)
        NotifIconContainer.BackgroundColor3 = self.AccentColor
        NotifIconContainer.BorderSizePixel = 0
        NotifIconContainer.Parent = NotifFrame
        
        local IconContainerCorner = Instance.new("UICorner")
        IconContainerCorner.CornerRadius = UDim.new(0, 13)
        IconContainerCorner.Parent = NotifIconContainer
        
        addGlow(NotifIconContainer, self.AccentColor, 0.65)
        
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Size = UDim2.new(0, iconSize * 0.62, 0, iconSize * 0.62)
        NotifIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        NotifIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Image = notification.Icon
        NotifIcon.ImageColor3 = COLORS.White
        NotifIcon.Parent = NotifIconContainer
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, isMobile and -120 : -115, 0, 32)
        NotifTitle.Position = UDim2.new(0, isMobile and 107 : 102, 0, 22)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = notification.Title
        NotifTitle.TextColor3 = COLORS.White
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = isMobile and 17 : 16
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.TextYAlignment = Enum.TextYAlignment.Top
        NotifTitle.TextTruncate = Enum.TextTruncate.AtEnd
        NotifTitle.Parent = NotifFrame
        
        local NotifBody = Instance.new("TextLabel")
        NotifBody.Size = UDim2.new(1, isMobile and -120 : -115, 0, 50)
        NotifBody.Position = UDim2.new(0, isMobile and 107 : 102, 0, 52)
        NotifBody.BackgroundTransparency = 1
        NotifBody.Text = notification.Body
        NotifBody.TextColor3 = COLORS.Gray
        NotifBody.Font = Enum.Font.Gotham
        NotifBody.TextSize = isMobile and 14 : 13
        NotifBody.TextXAlignment = Enum.TextXAlignment.Left
        NotifBody.TextYAlignment = Enum.TextYAlignment.Top
        NotifBody.TextWrapped = true
        NotifBody.Parent = NotifFrame
        
        local targetPos = isMobile and UDim2.new(0.5, 0, 1, -130) or UDim2.new(1, -420, 1, -130)
        createTween(NotifFrame, {Size = notifSize, Position = targetPos}, 0.5, Enum.EasingStyle.Back)
        
        wait(notification.Duration)
        
        local exitPos = isMobile and UDim2.new(0.5, 0, 1, 20) or UDim2.new(1, 20, 1, -130)
        createTween(NotifFrame, {Position = exitPos, Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        wait(0.4)
        NotifFrame:Destroy()
        
        return notification
    end
    
    return self
end

return UILibrary
