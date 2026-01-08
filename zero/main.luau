local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ModernUI = {}
ModernUI.__index = ModernUI

local COLORS = {
    Background = Color3.fromRGB(8, 8, 12),
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

function ModernUI.new(title, subtitle)
    local self = setmetatable({}, ModernUI)
    
    self.Title = title
    self.SubTitle = subtitle
    self.MinimizeKey = Enum.KeyCode.LeftControl
    self.SaveFolder = "ModernUIConfig"
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 999
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 580, 0, 460)
    self.MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
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
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = self.MainFrame
    
    self:CreateHeader()
    self:CreateSidebar()
    self:CreateContentArea()
    self:MakeDraggable()
    self:MakeResizable()
    self:SetupMinimizeKey()
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.MinimizedFrame = nil
    self.ConfigData = {}
    
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self:LoadConfig()
    
    return self
end

function ModernUI:CreateHeader()
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Name = "IconContainer"
    IconContainer.Size = UDim2.new(0, 38, 0, 38)
    IconContainer.Position = UDim2.new(0, 18, 0.5, -19)
    IconContainer.BackgroundColor3 = COLORS.Surface
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Header
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 10)
    IconCorner.Parent = IconContainer
    
    local IconFrame = Instance.new("ImageLabel")
    IconFrame.Name = "Icon"
    IconFrame.Size = UDim2.new(0, 22, 0, 22)
    IconFrame.Position = UDim2.new(0.5, -11, 0.5, -11)
    IconFrame.BackgroundTransparency = 1
    IconFrame.Image = "rbxassetid://7733955511"
    IconFrame.ImageColor3 = COLORS.White
    IconFrame.Parent = IconContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 300, 0, 20)
    TitleLabel.Position = UDim2.new(0, 64, 0, 12)
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
    SubtitleLabel.Position = UDim2.new(0, 64, 0, 32)
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
    CloseButton.BackgroundColor3 = COLORS.Surface
    CloseButton.Text = ""
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Size = UDim2.new(0, 14, 0, 14)
    CloseIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Image = "rbxassetid://7734053426"
    CloseIcon.ImageColor3 = COLORS.Gray
    CloseIcon.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        self:ShowConfirmDialog()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
    end)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -78, 0.5, -15)
    MinimizeButton.BackgroundColor3 = COLORS.Surface
    MinimizeButton.Text = ""
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Size = UDim2.new(0, 14, 0, 14)
    MinIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Image = "rbxassetid://7734000129"
    MinIcon.ImageColor3 = COLORS.Gray
    MinIcon.Parent = MinimizeButton
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
        TweenService:Create(MinIcon, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        TweenService:Create(MinIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
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
    Sidebar.Size = UDim2.new(0, 140, 1, -70)
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
    ContentArea.Size = UDim2.new(1, -188, 1, -82)
    ContentArea.Position = UDim2.new(0, 172, 0, 62)
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
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
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
            local newWidth = math.max(400, startSize.X.Offset + delta.X)
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

function ModernUI:SetupMinimizeKey()
    if UserInputService.KeyboardEnabled then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == self.MinimizeKey then
                self:ToggleUI()
            end
        end)
    end
end

function ModernUI:ToggleUI()
    self.MainFrame.Visible = not self.MainFrame.Visible
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
    Dialog.Size = UDim2.new(0, 300, 0, 150)
    Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    Dialog.BackgroundColor3 = COLORS.Surface
    Dialog.BorderSizePixel = 0
    Dialog.ZIndex = 11
    Dialog.Parent = Overlay
    
    local DialogCorner = Instance.new("UICorner")
    DialogCorner.CornerRadius = UDim.new(0, 14)
    DialogCorner.Parent = Dialog
    
    Dialog.Size = UDim2.new(0, 300, 0, 0)
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

function ModernUI:CreateTab(name, icon)
    local Tab = {}
    
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
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 16, 0, 16)
    IconLabel.Position = UDim2.new(0, 12, 0.5, -8)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon or "rbxassetid://7733955511"
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
    TweenService:Create(tab.Indicator, FAST_TWEEN, {Size = UDim2.new(0, 2, 0, 18)}):Play()
    
    self.CurrentTab = tab
end

function ModernUI:CreateSection(tab, name)
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
        totalWidth = 380
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
end

function ModernUI:CreateToggle(tab, name, default, callback)
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
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        ToggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
    end
    
    local ConfigKey = "Toggle_" .. name
    if self.ConfigData[ConfigKey] ~= nil then
        toggled = self.ConfigData[ConfigKey]
        if toggled then
            ToggleButton.BackgroundColor3 = COLORS.Accent
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
            ToggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {
                BackgroundColor3 = Color3.fromRGB(8, 8, 12),
                Position = UDim2.new(1, -20, 0.5, -9)
            }):Play()
        else
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {
                BackgroundColor3 = COLORS.Gray,
                Position = UDim2.new(0, 2, 0.5, -9)
            }):Play()
        end
        
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

function ModernUI:CreateDropdown(tab, name, options, default, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 66)
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = tab.Container
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.Position = UDim2.new(0, 0, 0, 26)
    Container.BackgroundColor3 = COLORS.Surface
    Container.BorderSizePixel = 0
    Container.Parent = Dropdown
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Dropdown
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.AutoButtonColor = false
    DropdownButton.Parent = Container
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, -45, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 14, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = default or options[1] or ""
    SelectedLabel.TextColor3 = COLORS.White
    SelectedLabel.TextSize = 13
    SelectedLabel.Font = Enum.Font.GothamMedium
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.Parent = DropdownButton
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -28, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://7733717447"
    Arrow.ImageColor3 = COLORS.Gray
    Arrow.Rotation = 0
    Arrow.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 72)
    DropdownList.BackgroundColor3 = COLORS.Surface
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 5
    DropdownList.ClipsDescendants = true
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 10)
    ListCorner.Parent = DropdownList
    
    local ListContainer = Instance.new("ScrollingFrame")
    ListContainer.Size = UDim2.new(1, 0, 1, 0)
    ListContainer.BackgroundTransparency = 1
    ListContainer.BorderSizePixel = 0
    ListContainer.ScrollBarThickness = 0
    ListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListContainer.ZIndex = 6
    ListContainer.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = ListContainer
    
    local ListPadding = Instance.new("UIPadding")
    ListPadding.PaddingLeft = UDim.new(0, 6)
    ListPadding.PaddingRight = UDim.new(0, 6)
    ListPadding.PaddingTop = UDim.new(0, 6)
    ListPadding.PaddingBottom = UDim.new(0, 6)
    ListPadding.Parent = ListContainer
    
    local isOpen = false
    local selectedOption = default or options[1]
    
    local ConfigKey = "Dropdown_" .. name
    if self.ConfigData[ConfigKey] ~= nil then
        selectedOption = self.ConfigData[ConfigKey]
        SelectedLabel.Text = selectedOption
    end
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 32)
        OptionButton.BackgroundColor3 = COLORS.Background
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 6
        OptionButton.Parent = ListContainer
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 8)
        OptionCorner.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -32, 1, 0)
        OptionLabel.Position = UDim2.new(0, 12, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = COLORS.White
        OptionLabel.TextSize = 12
        OptionLabel.Font = Enum.Font.GothamMedium
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.ZIndex = 6
        OptionLabel.Parent = OptionButton
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Position = UDim2.new(1, -12, 0.5, -8)
        Indicator.BackgroundColor3 = COLORS.Accent
        Indicator.BorderSizePixel = 0
        Indicator.Visible = option == selectedOption
        Indicator.ZIndex = 6
        Indicator.Parent = OptionButton
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            SelectedLabel.Text = option
            
            for _, child in ipairs(ListContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    local ind = child:FindFirstChild("Frame")
                    if ind then
                        ind.Visible = false
                    end
                end
            end
            
            Indicator.Visible = true
            Indicator.Size = UDim2.new(0, 0, 0, 16)
            TweenService:Create(Indicator, FAST_TWEEN, {Size = UDim2.new(0, 3, 0, 16)}):Play()
            
            self.ConfigData[ConfigKey] = selectedOption
            self:SaveConfig()
            
            if callback then
                callback(option)
            end
        end)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Background}):Play()
        end)
    end
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = true
        
        if isOpen then
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 180, ImageColor3 = COLORS.Accent}):Play()
            local targetHeight = math.min(180, ListLayout.AbsoluteContentSize.Y + 12)
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 82 + targetHeight)}):Play()
        else
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 0, ImageColor3 = COLORS.Gray}):Play()
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 66)}):Play()
            wait(0.4)
            if not isOpen then
                DropdownList.Visible = false
            end
        end
    end)
    
    Container.MouseEnter:Connect(function()
        TweenService:Create(Container, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    end)
    
    Container.MouseLeave:Connect(function()
        TweenService:Create(Container, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    return Dropdown
end

function ModernUI:CreateMultiDropdown(tab, name, options, defaults, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "MultiDropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 66)
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = tab.Container
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.Position = UDim2.new(0, 0, 0, 26)
    Container.BackgroundColor3 = COLORS.Surface
    Container.BorderSizePixel = 0
    Container.Parent = Dropdown
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Dropdown
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.AutoButtonColor = false
    DropdownButton.Parent = Container
    
    local selectedOptions = defaults or {}
    
    local ConfigKey = "MultiDropdown_" .. name
    if self.ConfigData[ConfigKey] ~= nil then
        selectedOptions = self.ConfigData[ConfigKey]
    end
    
    local function updateLabel()
        if #selectedOptions == 0 then
            SelectedLabel.Text = "None selected"
            SelectedLabel.TextColor3 = COLORS.Gray
        elseif #selectedOptions == 1 then
            SelectedLabel.Text = selectedOptions[1]
            SelectedLabel.TextColor3 = COLORS.White
        else
            SelectedLabel.Text = #selectedOptions .. " selected"
            SelectedLabel.TextColor3 = COLORS.Accent
        end
    end
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, -45, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 14, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = "None selected"
    SelectedLabel.TextColor3 = COLORS.Gray
    SelectedLabel.TextSize = 13
    SelectedLabel.Font = Enum.Font.GothamMedium
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.Parent = DropdownButton
    
    updateLabel()
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -28, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://7733717447"
    Arrow.ImageColor3 = COLORS.Gray
    Arrow.Rotation = 0
    Arrow.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 72)
    DropdownList.BackgroundColor3 = COLORS.Surface
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 5
    DropdownList.ClipsDescendants = true
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 10)
    ListCorner.Parent = DropdownList
    
    local ListContainer = Instance.new("ScrollingFrame")
    ListContainer.Size = UDim2.new(1, 0, 1, 0)
    ListContainer.BackgroundTransparency = 1
    ListContainer.BorderSizePixel = 0
    ListContainer.ScrollBarThickness = 0
    ListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListContainer.ZIndex = 6
    ListContainer.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = ListContainer
    
    local ListPadding = Instance.new("UIPadding")
    ListPadding.PaddingLeft = UDim.new(0, 6)
    ListPadding.PaddingRight = UDim.new(0, 6)
    ListPadding.PaddingTop = UDim.new(0, 6)
    ListPadding.PaddingBottom = UDim.new(0, 6)
    ListPadding.Parent = ListContainer
    
    local isOpen = false
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 32)
        OptionButton.BackgroundColor3 = COLORS.Background
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 6
        OptionButton.Parent = ListContainer
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 8)
        OptionCorner.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -32, 1, 0)
        OptionLabel.Position = UDim2.new(0, 12, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = COLORS.White
        OptionLabel.TextSize = 12
        OptionLabel.Font = Enum.Font.GothamMedium
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.ZIndex = 6
        OptionLabel.Parent = OptionButton
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Position = UDim2.new(1, -12, 0.5, -8)
        Indicator.BackgroundColor3 = COLORS.Accent
        Indicator.BorderSizePixel = 0
        Indicator.Visible = table.find(selectedOptions, option) ~= nil
        Indicator.ZIndex = 6
        Indicator.Parent = OptionButton
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator
        
        OptionButton.MouseButton1Click:Connect(function()
            local index = table.find(selectedOptions, option)
            
            if index then
                table.remove(selectedOptions, index)
                Indicator.Visible = false
            else
                table.insert(selectedOptions, option)
                Indicator.Visible = true
                Indicator.Size = UDim2.new(0, 0, 0, 16)
                TweenService:Create(Indicator, FAST_TWEEN, {Size = UDim2.new(0, 3, 0, 16)}):Play()
            end
            
            updateLabel()
            
            self.ConfigData[ConfigKey] = selectedOptions
            self:SaveConfig()
            
            if callback then
                callback(selectedOptions)
            end
        end)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Background}):Play()
        end)
    end
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = true
        
        if isOpen then
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 180, ImageColor3 = COLORS.Accent}):Play()
            local targetHeight = math.min(180, ListLayout.AbsoluteContentSize.Y + 12)
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 82 + targetHeight)}):Play()
        else
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 0, ImageColor3 = COLORS.Gray}):Play()
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 66)}):Play()
            wait(0.4)
            if not isOpen then
                DropdownList.Visible = false
            end
        end
    end)
    
    Container.MouseEnter:Connect(function()
        TweenService:Create(Container, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    end)
    
    Container.MouseLeave:Connect(function()
        TweenService:Create(Container, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    return Dropdown
end

function ModernUI:CreateButton(tab, name, callback)
    local Button = Instance.new("Frame")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundTransparency = 1
    Button.Parent = tab.Container
    
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
    ButtonFrame.BackgroundColor3 = COLORS.Surface
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = Button
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ButtonFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ButtonFrame
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -28, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://7733717447"
    Arrow.ImageColor3 = COLORS.Gray
    Arrow.Rotation = -90
    Arrow.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0.92, 0)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.1), {Position = UDim2.new(1, -26, 0.5, -7)}):Play()
        wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.1), {Position = UDim2.new(1, -28, 0.5, -7)}):Play()
        
        if callback then
            callback()
        end
    end)
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
        TweenService:Create(Arrow, FAST_TWEEN, {ImageColor3 = Color3.fromRGB(8, 8, 12)}):Play()
        TweenService:Create(Label, FAST_TWEEN, {TextColor3 = Color3.fromRGB(8, 8, 12)}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        TweenService:Create(Arrow, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
        TweenService:Create(Label, FAST_TWEEN, {TextColor3 = COLORS.White}):Play()
    end)
    
    return Button
end

function ModernUI:CreateSlider(tab, name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 76)
    Slider.BackgroundColor3 = COLORS.Surface
    Slider.BorderSizePixel = 0
    Slider.Parent = tab.Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.Position = UDim2.new(0, 14, 0, 12)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 70, 0, 20)
    ValueLabel.Position = UDim2.new(1, -84, 0, 12)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default or min)
    ValueLabel.TextColor3 = COLORS.Accent
    ValueLabel.TextSize = 14
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(0, 80, 0, 26)
    InputContainer.Position = UDim2.new(0, 14, 0, 40)
    InputContainer.BackgroundColor3 = COLORS.Background
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = Slider
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 7)
    InputCorner.Parent = InputContainer
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -10, 1, 0)
    TextBox.Position = UDim2.new(0, 5, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = tostring(default or min)
    TextBox.TextColor3 = COLORS.White
    TextBox.TextSize = 12
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = InputContainer
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -120, 0, 6)
    SliderTrack.Position = UDim2.new(0, 104, 0, 50)
    SliderTrack.BackgroundColor3 = COLORS.Background
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = Slider
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = COLORS.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderHandle = Instance.new("Frame")
    SliderHandle.Size = UDim2.new(0, 16, 0, 16)
    SliderHandle.Position = UDim2.new(0, -8, 0.5, -8)
    SliderHandle.BackgroundColor3 = COLORS.White
    SliderHandle.BorderSizePixel = 0
    SliderHandle.Parent = SliderTrack
    
    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(1, 0)
    HandleCorner.Parent = SliderHandle
    
    local HandleShadow = Instance.new("ImageLabel")
    HandleShadow.Size = UDim2.new(1, 16, 1, 16)
    HandleShadow.Position = UDim2.new(0, -8, 0, -8)
    HandleShadow.BackgroundTransparency = 1
    HandleShadow.Image = "rbxassetid://5554236805"
    HandleShadow.ImageColor3 = COLORS.Accent
    HandleShadow.ImageTransparency = 0.5
    HandleShadow.ScaleType = Enum.ScaleType.Slice
    HandleShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    HandleShadow.ZIndex = 0
    HandleShadow.Parent = SliderHandle
    
    local currentValue = default or min
    local dragging = false
    local activeInput = nil
    
    local ConfigKey = "Slider_" .. name
    if self.ConfigData[ConfigKey] ~= nil then
        currentValue = self.ConfigData[ConfigKey]
    end
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        
        local useDecimals = (min % 1 ~= 0 or max % 1 ~= 0)
        local displayValue = useDecimals and string.format("%.2f", value) or tostring(math.floor(value))
        
        ValueLabel.Text = displayValue
        TextBox.Text = displayValue
        
        local percent = (value - min) / (max - min)
        local xPos = percent * SliderTrack.AbsoluteSize.X
        
        SliderFill.Size = UDim2.new(0, xPos, 1, 0)
        SliderHandle.Position = UDim2.new(0, xPos - 8, 0.5, -8)
        
        self.ConfigData[ConfigKey] = currentValue
        self:SaveConfig()
        
        if callback then
            callback(value)
        end
    end
    
    updateSlider(currentValue)
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            activeInput = input
            local relativeX = math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
            local percent = relativeX / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            updateSlider(value)
            
            SliderHandle.Size = UDim2.new(0, 20, 0, 20)
            SliderHandle.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
        end
    end)
    
    SliderTrack.InputChanged:Connect(function(input)
        if dragging and input == activeInput then
            local relativeX = math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
            local percent = relativeX / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            updateSlider(value)
            
            SliderHandle.Size = UDim2.new(0, 20, 0, 20)
            SliderHandle.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
        end
    end)
    
    SliderTrack.InputEnded:Connect(function(input)
        if input == activeInput then
            dragging = false
            activeInput = nil
            local percent = (currentValue - min) / (max - min)
            local xPos = percent * SliderTrack.AbsoluteSize.X
            TweenService:Create(SliderHandle, FAST_TWEEN, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, xPos - 8, 0.5, -8)}):Play()
        end
    end)
    
    TextBox.FocusLost:Connect(function()
        local value = tonumber(TextBox.Text)
        if value then
            if value > max then
                value = max
            elseif value < min then
                value = min
            end
            updateSlider(value)
        else
            TextBox.Text = tostring(currentValue)
        end
    end)
    
    InputContainer.MouseEnter:Connect(function()
        TweenService:Create(InputContainer, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    end)
    
    InputContainer.MouseLeave:Connect(function()
        TweenService:Create(InputContainer, FAST_TWEEN, {BackgroundColor3 = COLORS.Background}):Play()
    end)
    
    Slider.MouseEnter:Connect(function()
        TweenService:Create(Slider, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
    end)
    
    Slider.MouseLeave:Connect(function()
        TweenService:Create(Slider, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
    end)
    
    return Slider
end

function ModernUI:CreateNotification(title, body, icon, duration)
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(0, 320, 0, 80)
    Notification.Position = UDim2.new(1, 0, 1, -90)
    Notification.BackgroundColor3 = COLORS.Surface
    Notification.BorderSizePixel = 0
    Notification.Parent = self.ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = Notification
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 24, 1, 24)
    Shadow.Position = UDim2.new(0, -12, 0, -12)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = Notification
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(1, -8, 0, 2)
    Accent.Position = UDim2.new(0, 4, 0, 4)
    Accent.BackgroundColor3 = COLORS.Accent
    Accent.BorderSizePixel = 0
    Accent.Parent = Notification
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = Accent
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 42, 0, 42)
    IconContainer.Position = UDim2.new(0, 16, 0.5, -21)
    IconContainer.BackgroundColor3 = COLORS.Background
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Notification
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 10)
    IconCorner.Parent = IconContainer
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 24, 0, 24)
    IconLabel.Position = UDim2.new(0.5, -12, 0.5, -12)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon or "rbxassetid://7733955511"
    IconLabel.ImageColor3 = COLORS.Accent
    IconLabel.Parent = IconContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -76, 0, 20)
    TitleLabel.Position = UDim2.new(0, 68, 0, 22)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = Notification
    
    local BodyLabel = Instance.new("TextLabel")
    BodyLabel.Size = UDim2.new(1, -76, 0, 24)
    BodyLabel.Position = UDim2.new(0, 68, 0, 42)
    BodyLabel.BackgroundTransparency = 1
    BodyLabel.Text = body
    BodyLabel.TextColor3 = COLORS.Gray
    BodyLabel.TextSize = 11
    BodyLabel.Font = Enum.Font.Gotham
    BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    BodyLabel.TextYAlignment = Enum.TextYAlignment.Top
    BodyLabel.TextWrapped = true
    BodyLabel.Parent = Notification
    
    Notification.Position = UDim2.new(1, 0, 1, -90)
    local tweenIn = TweenService:Create(Notification, TWEEN_INFO, {Position = UDim2.new(1, -340, 1, -90)})
    tweenIn:Play()
    
    task.delay(duration or 5, function()
        local tweenOut = TweenService:Create(Notification, TWEEN_INFO, {Position = UDim2.new(1, 0, 1, -90)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

function ModernUI:CreateFloatingButton(shape, image, hasBorder, borderColor, callback)
    local size = shape == "circle" and UDim2.new(0, 56, 0, 56) or UDim2.new(0, 56, 0, 56)
    
    local Button = Instance.new("TextButton")
    Button.Name = "FloatingButton"
    Button.Size = size
    Button.Position = UDim2.new(1, -80, 1, -80)
    Button.BackgroundColor3 = COLORS.Surface
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.ZIndex = 50
    Button.Parent = self.ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = shape == "circle" and UDim.new(1, 0) or UDim.new(0, 16)
    Corner.Parent = Button
    
    if hasBorder then
        local Border = Instance.new("UIStroke")
        Border.Color = borderColor or COLORS.Accent
        Border.Thickness = 2
        Border.Parent = Button
    end
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 24, 1, 24)
    Shadow.Position = UDim2.new(0, -12, 0, -12)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 49
    Shadow.Parent = Button
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 28, 0, 28)
    Icon.Position = UDim2.new(0.5, -14, 0.5, -14)
    Icon.BackgroundTransparency = 1
    Icon.Image = image or "rbxassetid://7733955511"
    Icon.ImageColor3 = COLORS.White
    Icon.ZIndex = 51
    Icon.Parent = Button
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local wasDragged = false
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
            wasDragged = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                wasDragged = true
            end
            Button.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if not wasDragged and callback then
                    callback()
                end
            end
        end
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent, Size = UDim2.new(0, 60, 0, 60)}):Play()
        TweenService:Create(Icon, FAST_TWEEN, {ImageColor3 = Color3.fromRGB(8, 8, 12)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface, Size = size}):Play()
        TweenService:Create(Icon, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    return Button
end

function ModernUI:SaveConfig()
    if not self.SaveFolder then return end
    
    local success, err = pcall(function()
        local json = game:GetService("HttpService"):JSONEncode(self.ConfigData)
        writefile(self.SaveFolder .. ".json", json)
    end)
end

function ModernUI:LoadConfig()
    if not self.SaveFolder then return end
    
    local success, err = pcall(function()
        if isfile(self.SaveFolder .. ".json") then
            local json = readfile(self.SaveFolder .. ".json")
            self.ConfigData = game:GetService("HttpService"):JSONDecode(json)
        end
    end)
end

return ModernUI
