local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ModernUI = {}
ModernUI.__index = ModernUI

local THEMES = {
    White = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 70, 70),
    Purple = Color3.fromRGB(170, 100, 255),
    Yellow = Color3.fromRGB(255, 220, 70),
    Green = Color3.fromRGB(70, 255, 150),
    Blue = Color3.fromRGB(70, 150, 255)
}

local COLORS = {
    Background = Color3.fromRGB(0, 0, 0),
    Surface = Color3.fromRGB(12, 12, 18),
    SurfaceLight = Color3.fromRGB(18, 18, 24),
    Border = Color3.fromRGB(30, 30, 40),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(140, 140, 150),
    DarkGray = Color3.fromRGB(80, 80, 90),
    Accent = Color3.fromRGB(255, 255, 255)
}

local TWEEN_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SLOW_TWEEN = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

function ModernUI.new(config)
    local self = setmetatable({}, ModernUI)
    
    config = config or {}
    self.Title = config.Title or "Modern UI"
    self.SubTitle = config.SubTitle or "Library"
    self.Icon = config.Icon or "rbxassetid://7733955511"
    self.SaveFolder = "ModernUIConfig"
    self.AcrylicEnabled = false
    self.CurrentTheme = "White"
    self.FloatingButton = nil
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 999
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 720, 0, 420)
    self.MainFrame.Position = UDim2.new(0.5, -360, 0.5, -210)
    self.MainFrame.BackgroundColor3 = COLORS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.Active = true
    self.MainFrame.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = self.MainFrame
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = self.MainFrame
    
    self:CreateHeader()
    self:CreateSidebar()
    self:CreateContentArea()
    self:MakeDraggable()
    self:MakeResizable()
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.ConfigData = {}
    self.AccentElements = {}
    
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self:LoadConfig()
    self:ApplyTheme(self.CurrentTheme)
    self:ApplyAcrylic(self.AcrylicEnabled)
    
    return self
end

function ModernUI:CreateHeader()
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local IconFrame = Instance.new("ImageLabel")
    IconFrame.Name = "Icon"
    IconFrame.Size = UDim2.new(0, 26, 0, 26)
    IconFrame.Position = UDim2.new(0, 20, 0.5, -13)
    IconFrame.BackgroundTransparency = 1
    IconFrame.Image = self.Icon
    IconFrame.ImageColor3 = COLORS.White
    IconFrame.Parent = Header
    
    self.IconFrame = IconFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 300, 0, 20)
    TitleLabel.Position = UDim2.new(0, 56, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(0, 300, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 56, 0, 32)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.SubTitle
    SubtitleLabel.TextColor3 = COLORS.Gray
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -42, 0.5, -15)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = ""
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Size = UDim2.new(0, 16, 0, 16)
    CloseIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = "rbxassetid://7734053426"
    CloseIcon.ImageColor3 = COLORS.Gray
    CloseIcon.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        self:ShowConfirmDialog()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
    end)
    
    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Name = "Settings"
    SettingsButton.Size = UDim2.new(0, 30, 0, 30)
    SettingsButton.Position = UDim2.new(1, -78, 0.5, -15)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Text = ""
    SettingsButton.AutoButtonColor = false
    SettingsButton.Parent = Header
    
    local SettingsIcon = Instance.new("ImageLabel")
    SettingsIcon.Size = UDim2.new(0, 16, 0, 16)
    SettingsIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    SettingsIcon.BackgroundTransparency = 1
    SettingsIcon.Image = "rbxassetid://7734053495"
    SettingsIcon.ImageColor3 = COLORS.Gray
    SettingsIcon.Parent = SettingsButton
    
    SettingsButton.MouseButton1Click:Connect(function()
        self:ShowSettingsWindow()
    end)
    
    SettingsButton.MouseEnter:Connect(function()
        TweenService:Create(SettingsIcon, FAST_TWEEN, {ImageColor3 = COLORS.White, Rotation = 90}):Play()
    end)
    
    SettingsButton.MouseLeave:Connect(function()
        TweenService:Create(SettingsIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray, Rotation = 0}):Play()
    end)
    
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(1, -32, 0, 1)
    Divider.Position = UDim2.new(0, 16, 1, -1)
    Divider.BackgroundColor3 = COLORS.Border
    Divider.BorderSizePixel = 0
    Divider.Parent = Header
end

function ModernUI:CreateSidebar()
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -70)
    Sidebar.Position = UDim2.new(0, 16, 0, 62)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = self.MainFrame
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 0
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabList.Parent = Sidebar
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 6)
    ListLayout.Parent = TabList
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)
    end)
    
    self.TabList = TabList
end

function ModernUI:CreateContentArea()
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -208, 1, -82)
    ContentArea.Position = UDim2.new(0, 192, 0, 62)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ScrollBarThickness = 3
    ContentArea.ScrollBarImageColor3 = COLORS.Border
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentArea.Parent = self.MainFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.Parent = ContentArea
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 0)
    Padding.PaddingRight = UDim.new(0, 16)
    Padding.PaddingTop = UDim.new(0, 0)
    Padding.PaddingBottom = UDim.new(0, 16)
    Padding.Parent = ContentArea
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentArea.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 32)
    end)
    
    self.ContentArea = ContentArea
end

function ModernUI:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local Header = self.MainFrame:FindFirstChild("Header")
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end
    
    Header.InputBegan:Connect(onInputBegan)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function ModernUI:MakeResizable()
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    local ResizeHandle = Instance.new("Frame")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
    ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Parent = self.MainFrame
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = self.MainFrame.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.max(500, startSize.X.Offset + delta.X)
            local newHeight = math.max(300, startSize.Y.Offset + delta.Y)
            self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

function ModernUI:ToggleUI()
    local isVisible = self.MainFrame.Visible
    if isVisible then
        TweenService:Create(self.MainFrame, FAST_TWEEN, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        wait(0.25)
        self.MainFrame.Visible = false
    else
        self.MainFrame.Visible = true
        self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(self.MainFrame, TWEEN_INFO, {Size = UDim2.new(0, 720, 0, 420), Position = UDim2.new(0.5, -360, 0.5, -210)}):Play()
    end
end

function ModernUI:ShowConfirmDialog()
    local Overlay = Instance.new("Frame")
    Overlay.Name = "ConfirmOverlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = self.MainFrame
    
    TweenService:Create(Overlay, FAST_TWEEN, {BackgroundTransparency = 0.6}):Play()
    
    local Dialog = Instance.new("Frame")
    Dialog.Name = "Dialog"
    Dialog.Size = UDim2.new(0, 300, 0, 0)
    Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    Dialog.BackgroundColor3 = COLORS.Surface
    Dialog.BorderSizePixel = 0
    Dialog.ZIndex = 11
    Dialog.Parent = Overlay
    
    local DialogCorner = Instance.new("UICorner")
    DialogCorner.CornerRadius = UDim.new(0, 14)
    DialogCorner.Parent = Dialog
    
    TweenService:Create(Dialog, TWEEN_INFO, {Size = UDim2.new(0, 300, 0, 150)}):Play()
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -32, 0, 24)
    Title.Position = UDim2.new(0, 16, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = "Confirm Close"
    Title.TextColor3 = COLORS.White
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 11
    Title.Parent = Dialog
    
    local Message = Instance.new("TextLabel")
    Message.Size = UDim2.new(1, -32, 0, 40)
    Message.Position = UDim2.new(0, 16, 0, 45)
    Message.BackgroundTransparency = 1
    Message.Text = "Are you sure you want to close?"
    Message.TextColor3 = COLORS.Gray
    Message.TextSize = 12
    Message.Font = Enum.Font.Gotham
    Message.TextWrapped = true
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.ZIndex = 11
    Message.Parent = Dialog
    
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, -32, 0, 38)
    ButtonContainer.Position = UDim2.new(0, 16, 1, -54)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ZIndex = 11
    ButtonContainer.Parent = Dialog
    
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Padding = UDim.new(0, 8)
    ButtonLayout.Parent = ButtonContainer
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Name = "Cancel"
    CancelButton.Size = UDim2.new(0, 120, 1, 0)
    CancelButton.BackgroundColor3 = COLORS.SurfaceLight
    CancelButton.Text = "Cancel"
    CancelButton.TextColor3 = COLORS.White
    CancelButton.TextSize = 13
    CancelButton.Font = Enum.Font.GothamMedium
    CancelButton.AutoButtonColor = false
    CancelButton.ZIndex = 11
    CancelButton.LayoutOrder = 1
    CancelButton.Parent = ButtonContainer
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 8)
    CancelCorner.Parent = CancelButton
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Name = "Confirm"
    ConfirmButton.Size = UDim2.new(0, 120, 1, 0)
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ConfirmButton.Text = "Close"
    ConfirmButton.TextColor3 = COLORS.White
    ConfirmButton.TextSize = 13
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.AutoButtonColor = false
    ConfirmButton.ZIndex = 11
    ConfirmButton.LayoutOrder = 2
    ConfirmButton.Parent = ButtonContainer
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 8)
    ConfirmCorner.Parent = ConfirmButton
    
    ConfirmButton.MouseButton1Click:Connect(function()
        self:SaveConfig()
        TweenService:Create(Dialog, FAST_TWEEN, {Size = UDim2.new(0, 300, 0, 0)}):Play()
        TweenService:Create(Overlay, FAST_TWEEN, {BackgroundTransparency = 1}):Play()
        wait(0.2)
        self.ScreenGui:Destroy()
    end)
    
    CancelButton.MouseButton1Click:Connect(function()
        TweenService:Create(Dialog, FAST_TWEEN, {Size = UDim2.new(0, 300, 0, 0)}):Play()
        TweenService:Create(Overlay, FAST_TWEEN, {BackgroundTransparency = 1}):Play()
        wait(0.2)
        Overlay:Destroy()
    end)
    
    CancelButton.MouseEnter:Connect(function()
        TweenService:Create(CancelButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    CancelButton.MouseLeave:Connect(function()
        TweenService:Create(CancelButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    end)
    
    ConfirmButton.MouseEnter:Connect(function()
        TweenService:Create(ConfirmButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}):Play()
    end)
    
    ConfirmButton.MouseLeave:Connect(function()
        TweenService:Create(ConfirmButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
    end)
end

function ModernUI:ShowSettingsWindow()
    if self.SettingsWindow and self.SettingsWindow.Parent then
        self.SettingsWindow:Destroy()
    end
    
    local Overlay = Instance.new("Frame")
    Overlay.Name = "SettingsOverlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = self.MainFrame
    
    TweenService:Create(Overlay, FAST_TWEEN, {BackgroundTransparency = 0.6}):Play()
    
    local Settings = Instance.new("Frame")
    Settings.Name = "Settings"
    Settings.Size = UDim2.new(0, 400, 0, 0)
    Settings.Position = UDim2.new(0.5, -200, 0.5, -200)
    Settings.BackgroundColor3 = COLORS.Surface
    Settings.BorderSizePixel = 0
    Settings.ZIndex = 11
    Settings.Parent = Overlay
    
    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 14)
    SettingsCorner.Parent = Settings
    
    self.SettingsWindow = Overlay
    
    TweenService:Create(Settings, TWEEN_INFO, {Size = UDim2.new(0, 400, 0, 350)}):Play()
    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 11
    Header.Parent = Settings
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Settings"
    Title.TextColor3 = COLORS.White
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 11
    Title.Parent = Header
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundColor3 = COLORS.Background
    CloseBtn.Text = ""
    CloseBtn.AutoButtonColor = false
    CloseBtn.ZIndex = 11
    CloseBtn.Parent = Header
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 8)
    CloseBtnCorner.Parent = CloseBtn
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Size = UDim2.new(0, 14, 0, 14)
    CloseIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = "rbxassetid://7734053426"
    CloseIcon.ImageColor3 = COLORS.Gray
    CloseIcon.ZIndex = 11
    CloseIcon.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Settings, FAST_TWEEN, {Size = UDim2.new(0, 400, 0, 0)}):Play()
        TweenService:Create(Overlay, FAST_TWEEN, {BackgroundTransparency = 1}):Play()
        wait(0.2)
        Overlay:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, FAST_TWEEN, {BackgroundColor3 = COLORS.Background}):Play()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
    end)
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 50)
    Divider.BackgroundColor3 = COLORS.Border
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 11
    Divider.Parent = Settings
    
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, -40, 1, -110)
    Content.Position = UDim2.new(0, 20, 0, 60)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 3
    Content.ScrollBarImageColor3 = COLORS.Border
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.ZIndex = 11
    Content.Parent = Settings
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 15)
    ContentLayout.Parent = Content
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local ThemeLabel = Instance.new("TextLabel")
    ThemeLabel.Size = UDim2.new(1, 0, 0, 20)
    ThemeLabel.BackgroundTransparency = 1
    ThemeLabel.Text = "Theme"
    ThemeLabel.TextColor3 = COLORS.White
    ThemeLabel.TextSize = 13
    ThemeLabel.Font = Enum.Font.GothamBold
    ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
    ThemeLabel.ZIndex = 11
    ThemeLabel.LayoutOrder = 1
    ThemeLabel.Parent = Content
    
    local ThemeContainer = Instance.new("Frame")
    ThemeContainer.Size = UDim2.new(1, 0, 0, 80)
    ThemeContainer.BackgroundTransparency = 1
    ThemeContainer.ZIndex = 11
    ThemeContainer.LayoutOrder = 2
    ThemeContainer.Parent = Content
    
    local ThemeGrid = Instance.new("UIGridLayout")
    ThemeGrid.CellSize = UDim2.new(0, 50, 0, 50)
    ThemeGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    ThemeGrid.SortOrder = Enum.SortOrder.LayoutOrder
    ThemeGrid.Parent = ThemeContainer
    
    local themeOrder = {"White", "Red", "Purple", "Yellow", "Green", "Blue"}
    
    for i, themeName in ipairs(themeOrder) do
        local ThemeButton = Instance.new("TextButton")
        ThemeButton.Size = UDim2.new(0, 50, 0, 50)
        ThemeButton.BackgroundColor3 = THEMES[themeName]
        ThemeButton.Text = ""
        ThemeButton.AutoButtonColor = false
        ThemeButton.ZIndex = 11
        ThemeButton.LayoutOrder = i
        ThemeButton.Parent = ThemeContainer
        
        local ThemeCorner = Instance.new("UICorner")
        ThemeCorner.CornerRadius = UDim.new(0, 10)
        ThemeCorner.Parent = ThemeButton
        
        local Selected = Instance.new("ImageLabel")
        Selected.Size = UDim2.new(0, 20, 0, 20)
        Selected.Position = UDim2.new(0.5, -10, 0.5, -10)
        Selected.BackgroundTransparency = 1
        Selected.Image = "rbxassetid://7733964126"
        Selected.ImageColor3 = Color3.fromRGB(0, 0, 0)
        Selected.Visible = self.CurrentTheme == themeName
        Selected.ZIndex = 12
        Selected.Parent = ThemeButton
        
        ThemeButton.MouseButton1Click:Connect(function()
            self:ApplyTheme(themeName)
            for _, child in pairs(ThemeContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    local sel = child:FindFirstChildOfClass("ImageLabel")
                    if sel then
                        sel.Visible = false
                    end
                end
            end
            Selected.Visible = true
        end)
        
        ThemeButton.MouseEnter:Connect(function()
            TweenService:Create(ThemeButton, FAST_TWEEN, {Size = UDim2.new(0, 55, 0, 55)}):Play()
        end)
        
        ThemeButton.MouseLeave:Connect(function()
            TweenService:Create(ThemeButton, FAST_TWEEN, {Size = UDim2.new(0, 50, 0, 50)}):Play()
        end)
    end
    
    local AcrylicLabel = Instance.new("TextLabel")
    AcrylicLabel.Size = UDim2.new(1, 0, 0, 20)
    AcrylicLabel.BackgroundTransparency = 1
    AcrylicLabel.Text = "Acrylic Effect"
    AcrylicLabel.TextColor3 = COLORS.White
    AcrylicLabel.TextSize = 13
    AcrylicLabel.Font = Enum.Font.GothamBold
    AcrylicLabel.TextXAlignment = Enum.TextXAlignment.Left
    AcrylicLabel.ZIndex = 11
    AcrylicLabel.LayoutOrder = 3
    AcrylicLabel.Parent = Content
    
    local AcrylicToggle = Instance.new("Frame")
    AcrylicToggle.Size = UDim2.new(1, 0, 0, 40)
    AcrylicToggle.BackgroundColor3 = COLORS.Background
    AcrylicToggle.BorderSizePixel = 0
    AcrylicToggle.ZIndex = 11
    AcrylicToggle.LayoutOrder = 4
    AcrylicToggle.Parent = Content
    
    local AcrylicCorner = Instance.new("UICorner")
    AcrylicCorner.CornerRadius = UDim.new(0, 10)
    AcrylicCorner.Parent = AcrylicToggle
    
    local AcrylicText = Instance.new("TextLabel")
    AcrylicText.Size = UDim2.new(0.7, 0, 1, 0)
    AcrylicText.Position = UDim2.new(0, 14, 0, 0)
    AcrylicText.BackgroundTransparency = 1
    AcrylicText.Text = "Enable Transparency"
    AcrylicText.TextColor3 = COLORS.White
    AcrylicText.TextSize = 12
    AcrylicText.Font = Enum.Font.GothamMedium
    AcrylicText.TextXAlignment = Enum.TextXAlignment.Left
    AcrylicText.ZIndex = 11
    AcrylicText.Parent = AcrylicToggle
    
    local AcrylicButton = Instance.new("TextButton")
    AcrylicButton.Size = UDim2.new(0, 42, 0, 22)
    AcrylicButton.Position = UDim2.new(1, -56, 0.5, -11)
    AcrylicButton.BackgroundColor3 = self.AcrylicEnabled and COLORS.Accent or COLORS.SurfaceLight
    AcrylicButton.BorderSizePixel = 0
    AcrylicButton.Text = ""
    AcrylicButton.AutoButtonColor = false
    AcrylicButton.ZIndex = 11
    AcrylicButton.Parent = AcrylicToggle
    
    local AcrylicBtnCorner = Instance.new("UICorner")
    AcrylicBtnCorner.CornerRadius = UDim.new(1, 0)
    AcrylicBtnCorner.Parent = AcrylicButton
    
    local AcrylicCircle = Instance.new("Frame")
    AcrylicCircle.Size = UDim2.new(0, 18, 0, 18)
    AcrylicCircle.Position = self.AcrylicEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    AcrylicCircle.BackgroundColor3 = self.AcrylicEnabled and Color3.fromRGB(0, 0, 0) or COLORS.Gray
    AcrylicCircle.BorderSizePixel = 0
    AcrylicCircle.ZIndex = 11
    AcrylicCircle.Parent = AcrylicButton
    
    local AcrylicCircleCorner = Instance.new("UICorner")
    AcrylicCircleCorner.CornerRadius = UDim.new(1, 0)
    AcrylicCircleCorner.Parent = AcrylicCircle
    
    AcrylicButton.MouseButton1Click:Connect(function()
        self.AcrylicEnabled = not self.AcrylicEnabled
        self:ApplyAcrylic(self.AcrylicEnabled)
        
        if self.AcrylicEnabled then
            TweenService:Create(AcrylicButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
            TweenService:Create(AcrylicCircle, FAST_TWEEN, {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Position = UDim2.new(1, -20, 0.5, -9)
            }):Play()
        else
            TweenService:Create(AcrylicButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
            TweenService:Create(AcrylicCircle, FAST_TWEEN, {
                BackgroundColor3 = COLORS.Gray,
                Position = UDim2.new(0, 2, 0.5, -9)
            }):Play()
        end
    end)
    
    local SaveButton = Instance.new("TextButton")
    SaveButton.Size = UDim2.new(1, 0, 0, 40)
    SaveButton.BackgroundColor3 = COLORS.Accent
    SaveButton.Text = "Save Configuration"
    SaveButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    SaveButton.TextSize = 13
    SaveButton.Font = Enum.Font.GothamBold
    SaveButton.AutoButtonColor = false
    SaveButton.ZIndex = 11
    SaveButton.LayoutOrder = 5
    SaveButton.Parent = Content
    
    local SaveCorner = Instance.new("UICorner")
    SaveCorner.CornerRadius = UDim.new(0, 10)
    SaveCorner.Parent = SaveButton
    
    SaveButton.MouseButton1Click:Connect(function()
        self:SaveConfig()
        SaveButton.Text = "Saved!"
        wait(1)
        SaveButton.Text = "Save Configuration"
    end)
    
    SaveButton.MouseEnter:Connect(function()
        TweenService:Create(SaveButton, FAST_TWEEN, {BackgroundColor3 = Color3.new(
            COLORS.Accent.R * 0.9,
            COLORS.Accent.G * 0.9,
            COLORS.Accent.B * 0.9
        )}):Play()
    end)
    
    SaveButton.MouseLeave:Connect(function()
        TweenService:Create(SaveButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
    end)
end

function ModernUI:ApplyTheme(themeName)
    if not THEMES[themeName] then return end
    
    self.CurrentTheme = themeName
    COLORS.Accent = THEMES[themeName]
    
    for _, element in pairs(self.AccentElements) do
        if element and element.Parent then
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                TweenService:Create(element, FAST_TWEEN, {ImageColor3 = COLORS.Accent}):Play()
            elseif element:IsA("TextLabel") or element:IsA("TextButton") then
                TweenService:Create(element, FAST_TWEEN, {TextColor3 = COLORS.Accent}):Play()
            else
                TweenService:Create(element, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
            end
        end
    end
    
    self.ConfigData.Theme = themeName
    self:SaveConfig()
end

function ModernUI:ApplyAcrylic(enabled)
    local transparency = enabled and 0.3 or 0
    TweenService:Create(self.MainFrame, SLOW_TWEEN, {BackgroundTransparency = transparency}):Play()
    
    self.ConfigData.Acrylic = enabled
    self:SaveConfig()
end

function ModernUI:CreateTab(config)
    local Tab = {}
    
    config = config or {}
    local name = config.Name or "Tab"
    local icon = config.Icon or "rbxassetid://7733955511"
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 38)
    TabButton.BackgroundColor3 = COLORS.Background
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabList
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabButton
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 2, 0, 18)
    Indicator.Position = UDim2.new(0, 0, 0.5, -9)
    Indicator.BackgroundColor3 = COLORS.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = TabButton
    
    table.insert(self.AccentElements, Indicator)
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 16, 0, 16)
    IconLabel.Position = UDim2.new(0, 12, 0.5, -8)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon
    IconLabel.ImageColor3 = COLORS.Gray
    IconLabel.Parent = TabButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.Position = UDim2.new(0, 36, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TabButton
    
    local Container = Instance.new("Frame")
    Container.Name = name .. "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Visible = false
    Container.Parent = self.ContentArea
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.Parent = Container
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            TweenService:Create(TabButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            TweenService:Create(TabButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Background}):Play()
        end
    end)
    
    Tab.Button = TabButton
    Tab.Container = Container
    Tab.Indicator = Indicator
    Tab.IconLabel = IconLabel
    Tab.Label = Label
    Tab.Name = name
    
    table.insert(self.Tabs, Tab)
    
    if not self.CurrentTab then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function ModernUI:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Container.Visible = false
        t.Indicator.Visible = false
        TweenService:Create(t.Button, FAST_TWEEN, {BackgroundColor3 = COLORS.Background}):Play()
        TweenService:Create(t.IconLabel, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
        TweenService:Create(t.Label, FAST_TWEEN, {TextColor3 = COLORS.Gray}):Play()
    end
    
    tab.Container.Visible = true
    tab.Indicator.Visible = true
    TweenService:Create(tab.Button, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    TweenService:Create(tab.IconLabel, FAST_TWEEN, {ImageColor3 = COLORS.Accent}):Play()
    TweenService:Create(tab.Label, FAST_TWEEN, {TextColor3 = COLORS.White}):Play()
    
    self.CurrentTab = tab
end

function ModernUI:AddSection(tab, config)
    config = config or {}
    local name = config.Name or "Section"
    
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, 0, 0, 36)
    Section.BackgroundTransparency = 1
    Section.Parent = tab.Container
    
    local TempLabel = Instance.new("TextLabel")
    TempLabel.Text = "  " .. name .. "  "
    TempLabel.TextSize = 12
    TempLabel.Font = Enum.Font.GothamBold
    TempLabel.Parent = Section
    local textWidth = TempLabel.TextBounds.X
    TempLabel:Destroy()
    
    local totalWidth = Section.AbsoluteSize.X
    if totalWidth == 0 then
        totalWidth = 500
    end
    
    local leftLineWidth = (totalWidth - textWidth) / 2
    local rightLineWidth = (totalWidth - textWidth) / 2
    
    local LeftLine = Instance.new("Frame")
    LeftLine.Name = "LeftLine"
    LeftLine.Size = UDim2.new(0, leftLineWidth, 0, 2)
    LeftLine.Position = UDim2.new(0, 0, 0.5, -1)
    LeftLine.BackgroundColor3 = COLORS.Accent
    LeftLine.BorderSizePixel = 0
    LeftLine.Parent = Section
    
    table.insert(self.AccentElements, LeftLine)
    
    local LeftGradient = Instance.new("UIGradient")
    LeftGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Background),
        ColorSequenceKeypoint.new(0.5, COLORS.Accent),
        ColorSequenceKeypoint.new(1, COLORS.Accent)
    })
    LeftGradient.Rotation = 0
    LeftGradient.Parent = LeftLine
    
    local LeftCorner = Instance.new("UICorner")
    LeftCorner.CornerRadius = UDim.new(1, 0)
    LeftCorner.Parent = LeftLine
    
    local RightLine = Instance.new("Frame")
    RightLine.Name = "RightLine"
    RightLine.Size = UDim2.new(0, rightLineWidth, 0, 2)
    RightLine.Position = UDim2.new(1, -rightLineWidth, 0.5, -1)
    RightLine.BackgroundColor3 = COLORS.Accent
    RightLine.BorderSizePixel = 0
    RightLine.Parent = Section
    
    table.insert(self.AccentElements, RightLine)
    
    local RightGradient = Instance.new("UIGradient")
    RightGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Accent),
        ColorSequenceKeypoint.new(0.5, COLORS.Accent),
        ColorSequenceKeypoint.new(1, COLORS.Background)
    })
    RightGradient.Rotation = 0
    RightGradient.Parent = RightLine
    
    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(1, 0)
    RightCorner.Parent = RightLine
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(0, textWidth, 1, 0)
    SectionLabel.Position = UDim2.new(0.5, -textWidth / 2, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = name
    SectionLabel.TextColor3 = COLORS.Accent
    SectionLabel.TextSize = 12
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Parent = Section
    
    table.insert(self.AccentElements, SectionLabel)
    
    Section:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        local newTotalWidth = Section.AbsoluteSize.X
        if newTotalWidth > 0 then
            local newLeftWidth = (newTotalWidth - textWidth) / 2
            local newRightWidth = (newTotalWidth - textWidth) / 2
            
            LeftLine.Size = UDim2.new(0, newLeftWidth, 0, 2)
            RightLine.Size = UDim2.new(0, newRightWidth, 0, 2)
            RightLine.Position = UDim2.new(1, -newRightWidth, 0.5, -1)
            SectionLabel.Position = UDim2.new(0.5, -textWidth / 2, 0, 0)
        end
    end)
    
    return Section
end

function ModernUI:AddToggle(tab, config)
    config = config or {}
    local name = config.Name or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end
    
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.BackgroundColor3 = COLORS.Surface
    Toggle.BorderSizePixel = 0
    Toggle.Parent = tab.Container
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 42, 0, 22)
    ToggleButton.Position = UDim2.new(1, -56, 0.5, -11)
    ToggleButton.BackgroundColor3 = COLORS.SurfaceLight
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = Toggle
    
    local ToggleCorner2 = Instance.new("UICorner")
    ToggleCorner2.CornerRadius = UDim.new(1, 0)
    ToggleCorner2.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
    ToggleCircle.BackgroundColor3 = COLORS.Gray
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = default or false
    
    if toggled then
        ToggleButton.BackgroundColor3 = COLORS.Accent
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ToggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
    end
    
    local ConfigKey = "Toggle_" .. name
    if self.ConfigData[ConfigKey] ~= nil then
        toggled = self.ConfigData[ConfigKey]
        if toggled then
            ToggleButton.BackgroundColor3 = COLORS.Accent
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            ToggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
        end
    end
    
    table.insert(self.AccentElements, ToggleButton)
    
    local function updateToggle()
        if toggled then
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Position = UDim2.new(1, -20, 0.5, -9)
            }):Play()
        else
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {
                BackgroundColor3 = COLORS.Gray,
                Position = UDim2.new(0, 2, 0.5, -9)
            }):Play()
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        
        self.ConfigData[ConfigKey] = toggled
        self:SaveConfig()
        
        if callback then
            callback(toggled)
        end
    end)
    
    Toggle.MouseEnter:Connect(function()
        TweenService:Create(Toggle, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    end)
    
    Toggle.MouseLeave:Connect(function()
        TweenService:Create(Toggle, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    return Toggle
end
