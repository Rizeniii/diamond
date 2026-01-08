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
    Accent = Color3.fromRGB(90, 140, 255)
}

local TWEEN_INFO = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SLOW_TWEEN = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

function ModernUI.new(title, subtitle)
    local self = setmetatable({}, ModernUI)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 850, 0, 550)
    self.MainFrame.Position = UDim2.new(0.5, -425, 0.5, -275)
    self.MainFrame.BackgroundColor3 = COLORS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.Active = true
    self.MainFrame.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
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
    
    self:CreateHeader(title, subtitle)
    self:CreateSidebar()
    self:CreateContentArea()
    self:MakeDraggable()
    self:MakeResizable()
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.MinimizedFrame = nil
    
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    return self
end

function ModernUI:CreateHeader(title, subtitle)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Name = "IconContainer"
    IconContainer.Size = UDim2.new(0, 50, 0, 50)
    IconContainer.Position = UDim2.new(0, 25, 0.5, -25)
    IconContainer.BackgroundColor3 = COLORS.Surface
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Header
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 14)
    IconCorner.Parent = IconContainer
    
    local IconFrame = Instance.new("ImageLabel")
    IconFrame.Name = "Icon"
    IconFrame.Size = UDim2.new(0, 28, 0, 28)
    IconFrame.Position = UDim2.new(0.5, -14, 0.5, -14)
    IconFrame.BackgroundTransparency = 1
    IconFrame.Image = "rbxassetid://7733955511"
    IconFrame.ImageColor3 = COLORS.White
    IconFrame.Parent = IconContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 350, 0, 24)
    TitleLabel.Position = UDim2.new(0, 85, 0, 16)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.TextSize = 17
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(0, 350, 0, 18)
    SubtitleLabel.Position = UDim2.new(0, 85, 0, 40)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = COLORS.Gray
    SubtitleLabel.TextSize = 12
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 36, 0, 36)
    CloseButton.Position = UDim2.new(1, -50, 0.5, -18)
    CloseButton.BackgroundColor3 = COLORS.Surface
    CloseButton.Text = ""
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton
    
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
        TweenService:Create(CloseButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        TweenService:Create(CloseIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
    end)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 36, 0, 36)
    MinimizeButton.Position = UDim2.new(1, -92, 0.5, -18)
    MinimizeButton.BackgroundColor3 = COLORS.Surface
    MinimizeButton.Text = ""
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 10)
    MinCorner.Parent = MinimizeButton
    
    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Size = UDim2.new(0, 16, 0, 16)
    MinIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Image = "rbxassetid://7734000129"
    MinIcon.ImageColor3 = COLORS.Gray
    MinIcon.Parent = MinimizeButton
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
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
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 1, -1)
    Divider.BackgroundColor3 = COLORS.Border
    Divider.BorderSizePixel = 0
    Divider.Parent = Header
end

function ModernUI:CreateSidebar()
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, -90)
    Sidebar.Position = UDim2.new(0, 20, 0, 80)
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
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = TabList
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    self.TabList = TabList
end

function ModernUI:CreateContentArea()
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -260, 1, -110)
    ContentArea.Position = UDim2.new(0, 240, 0, 80)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ScrollBarThickness = 4
    ContentArea.ScrollBarImageColor3 = COLORS.Border
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentArea.Parent = self.MainFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 12)
    ListLayout.Parent = ContentArea
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 0)
    Padding.PaddingRight = UDim.new(0, 20)
    Padding.PaddingTop = UDim.new(0, 0)
    Padding.PaddingBottom = UDim.new(0, 20)
    Padding.Parent = ContentArea
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentArea.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 40)
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
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
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
            local newWidth = math.max(600, startSize.X.Offset + delta.X)
            local newHeight = math.max(450, startSize.Y.Offset + delta.Y)
            self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
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
    Dialog.Size = UDim2.new(0, 340, 0, 180)
    Dialog.Position = UDim2.new(0.5, -170, 0.5, -90)
    Dialog.BackgroundColor3 = COLORS.Surface
    Dialog.BorderSizePixel = 0
    Dialog.ZIndex = 11
    Dialog.Parent = Overlay
    
    local DialogCorner = Instance.new("UICorner")
    DialogCorner.CornerRadius = UDim.new(0, 16)
    DialogCorner.Parent = Dialog
    
    Dialog.Size = UDim2.new(0, 340, 0, 0)
    TweenService:Create(Dialog, TWEEN_INFO, {Size = UDim2.new(0, 340, 0, 180)}):Play()
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 30)
    Title.Position = UDim2.new(0, 20, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = "Confirm Close"
    Title.TextColor3 = COLORS.White
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 11
    Title.Parent = Dialog
    
    local Message = Instance.new("TextLabel")
    Message.Size = UDim2.new(1, -40, 0, 50)
    Message.Position = UDim2.new(0, 20, 0, 55)
    Message.BackgroundTransparency = 1
    Message.Text = "Are you sure you want to close this window?"
    Message.TextColor3 = COLORS.Gray
    Message.TextSize = 13
    Message.Font = Enum.Font.Gotham
    Message.TextWrapped = true
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.ZIndex = 11
    Message.Parent = Dialog
    
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, -40, 0, 45)
    ButtonContainer.Position = UDim2.new(0, 20, 1, -65)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ZIndex = 11
    ButtonContainer.Parent = Dialog
    
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Padding = UDim.new(0, 10)
    ButtonLayout.Parent = ButtonContainer
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Name = "Cancel"
    CancelButton.Size = UDim2.new(0, 135, 1, 0)
    CancelButton.BackgroundColor3 = COLORS.SurfaceLight
    CancelButton.Text = "Cancel"
    CancelButton.TextColor3 = COLORS.White
    CancelButton.TextSize = 14
    CancelButton.Font = Enum.Font.GothamMedium
    CancelButton.AutoButtonColor = false
    CancelButton.ZIndex = 11
    CancelButton.LayoutOrder = 1
    CancelButton.Parent = ButtonContainer
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 10)
    CancelCorner.Parent = CancelButton
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Name = "Confirm"
    ConfirmButton.Size = UDim2.new(0, 135, 1, 0)
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ConfirmButton.Text = "Close"
    ConfirmButton.TextColor3 = COLORS.White
    ConfirmButton.TextSize = 14
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.AutoButtonColor = false
    ConfirmButton.ZIndex = 11
    ConfirmButton.LayoutOrder = 2
    ConfirmButton.Parent = ButtonContainer
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 10)
    ConfirmCorner.Parent = ConfirmButton
    
    ConfirmButton.MouseButton1Click:Connect(function()
        TweenService:Create(Dialog, FAST_TWEEN, {Size = UDim2.new(0, 340, 0, 0)}):Play()
        TweenService:Create(Overlay, FAST_TWEEN, {BackgroundTransparency = 1}):Play()
        wait(0.2)
        self.ScreenGui:Destroy()
    end)
    
    CancelButton.MouseButton1Click:Connect(function()
        TweenService:Create(Dialog, FAST_TWEEN, {Size = UDim2.new(0, 340, 0, 0)}):Play()
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

function ModernUI:Minimize()
    if self.MinimizedFrame then return end
    
    local MinFrame = Instance.new("Frame")
    MinFrame.Name = "MinimizedFrame"
    MinFrame.Size = UDim2.new(0, 450, 0, 110)
    MinFrame.Position = UDim2.new(0.5, -225, 0.5, -55)
    MinFrame.BackgroundColor3 = COLORS.Background
    MinFrame.BorderSizePixel = 0
    MinFrame.Parent = self.ScreenGui
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 18)
    MinCorner.Parent = MinFrame
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = MinFrame
    
    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, -4, 0, 2)
    Glow.Position = UDim2.new(0, 2, 0, 0)
    Glow.BackgroundColor3 = COLORS.Accent
    Glow.BorderSizePixel = 0
    Glow.Parent = MinFrame
    
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(1, 0)
    GlowCorner.Parent = Glow
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 60, 0, 60)
    IconContainer.Position = UDim2.new(0, 20, 0.5, -30)
    IconContainer.BackgroundColor3 = COLORS.Surface
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = MinFrame
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 16)
    IconCorner.Parent = IconContainer
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 34, 0, 34)
    Icon.Position = UDim2.new(0.5, -17, 0.5, -17)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://7733955511"
    Icon.ImageColor3 = COLORS.White
    Icon.Parent = IconContainer
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 250, 0, 26)
    Title.Position = UDim2.new(0, 95, 0, 28)
    Title.BackgroundTransparency = 1
    Title.Text = self.MainFrame.Header.Title.Text
    Title.TextColor3 = COLORS.White
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MinFrame
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 250, 0, 20)
    Subtitle.Position = UDim2.new(0, 95, 0, 54)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = self.MainFrame.Header.Subtitle.Text
    Subtitle.TextColor3 = COLORS.Gray
    Subtitle.TextSize = 12
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = MinFrame
    
    local RestoreButton = Instance.new("TextButton")
    RestoreButton.Size = UDim2.new(0, 48, 0, 48)
    RestoreButton.Position = UDim2.new(1, -68, 0.5, -24)
    RestoreButton.BackgroundColor3 = COLORS.Surface
    RestoreButton.Text = ""
    RestoreButton.AutoButtonColor = false
    RestoreButton.Parent = MinFrame
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(0, 12)
    RestoreCorner.Parent = RestoreButton
    
    local RestoreIcon = Instance.new("ImageLabel")
    RestoreIcon.Size = UDim2.new(0, 22, 0, 22)
    RestoreIcon.Position = UDim2.new(0.5, -11, 0.5, -11)
    RestoreIcon.BackgroundTransparency = 1
    RestoreIcon.Image = "rbxassetid://7734042071"
    RestoreIcon.ImageColor3 = COLORS.Gray
    RestoreIcon.Parent = RestoreButton
    
    RestoreButton.MouseButton1Click:Connect(function()
        self:Restore()
    end)
    
    RestoreButton.MouseEnter:Connect(function()
        TweenService:Create(RestoreButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
        TweenService:Create(RestoreIcon, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    RestoreButton.MouseLeave:Connect(function()
        TweenService:Create(RestoreButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        TweenService:Create(RestoreIcon, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
    end)
    
    self.MinimizedFrame = MinFrame
    self.MainFrame.Visible = false
    
    MinFrame.Position = UDim2.new(0.5, -225, 1, 150)
    TweenService:Create(MinFrame, SLOW_TWEEN, {Position = UDim2.new(0.5, -225, 0.5, -55)}):Play()
end

function ModernUI:Restore()
    if not self.MinimizedFrame then return end
    
    local tween = TweenService:Create(self.MinimizedFrame, SLOW_TWEEN, {Position = UDim2.new(0.5, -225, 1, 150)})
    tween:Play()
    
    tween.Completed:Connect(function()
        self.MinimizedFrame:Destroy()
        self.MinimizedFrame = nil
        self.MainFrame.Visible = true
    end)
end

function ModernUI:CreateTab(name, icon)
    local Tab = {}
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 48)
    TabButton.BackgroundColor3 = COLORS.Background
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabList
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabButton
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 24)
    Indicator.Position = UDim2.new(0, 0, 0.5, -12)
    Indicator.BackgroundColor3 = COLORS.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = TabButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 20, 0, 20)
    IconLabel.Position = UDim2.new(0, 16, 0.5, -10)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon or "rbxassetid://7733955511"
    IconLabel.ImageColor3 = COLORS.Gray
    IconLabel.Parent = TabButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 46, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 13
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
    ListLayout.Padding = UDim.new(0, 12)
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
    Tab.Components = {}
    
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
    TweenService:Create(tab.Indicator, FAST_TWEEN, {Size = UDim2.new(0, 3, 0, 24)}):Play()
    
    self.CurrentTab = tab
end

function ModernUI:CreateSection(tab, name)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, 0, 0, 40)
    Section.BackgroundTransparency = 1
    Section.Parent = tab.Container
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, 0)
    Line.BackgroundColor3 = COLORS.Border
    Line.BorderSizePixel = 0
    Line.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(0, 0, 1, 0)
    SectionLabel.Position = UDim2.new(0, 0, 0, 0)
    SectionLabel.BackgroundColor3 = COLORS.Background
    SectionLabel.BorderSizePixel = 0
    SectionLabel.Text = "  " .. name .. "  "
    SectionLabel.TextColor3 = COLORS.Gray
    SectionLabel.TextSize = 12
    SectionLabel.Font = Enum.Font.GothamMedium
    SectionLabel.Parent = Section
    
    SectionLabel.Size = UDim2.new(0, SectionLabel.TextBounds.X, 1, 0)
end

function ModernUI:CreateToggle(tab, name, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 50)
    Toggle.BackgroundColor3 = COLORS.Surface
    Toggle.BorderSizePixel = 0
    Toggle.Parent = tab.Container
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 18, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 52, 0, 28)
    ToggleButton.Position = UDim2.new(1, -70, 0.5, -14)
    ToggleButton.BackgroundColor3 = COLORS.SurfaceLight
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = Toggle
    
    local ToggleCorner2 = Instance.new("UICorner")
    ToggleCorner2.CornerRadius = UDim.new(1, 0)
    ToggleCorner2.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    ToggleCircle.BackgroundColor3 = COLORS.Gray
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = default or false
    
    if toggled then
        ToggleButton.BackgroundColor3 = COLORS.Accent
        ToggleCircle.BackgroundColor3 = COLORS.White
        ToggleCircle.Position = UDim2.new(1, -25, 0.5, -11)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {
                BackgroundColor3 = COLORS.White,
                Position = UDim2.new(1, -25, 0.5, -11)
            }):Play()
        else
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.SurfaceLight}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {
                BackgroundColor3 = COLORS.Gray,
                Position = UDim2.new(0, 3, 0.5, -11)
            }):Play()
        end
        
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
    Dropdown.Size = UDim2.new(1, 0, 0, 80)
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = tab.Container
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.Position = UDim2.new(0, 0, 0, 30)
    Container.BackgroundColor3 = COLORS.Surface
    Container.BorderSizePixel = 0
    Container.Parent = Dropdown
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 12)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 12
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
    SelectedLabel.Size = UDim2.new(1, -55, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 18, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = default or options[1] or ""
    SelectedLabel.TextColor3 = COLORS.White
    SelectedLabel.TextSize = 14
    SelectedLabel.Font = Enum.Font.GothamMedium
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.Parent = DropdownButton
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 18, 0, 18)
    Arrow.Position = UDim2.new(1, -36, 0.5, -9)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://7733717447"
    Arrow.ImageColor3 = COLORS.Gray
    Arrow.Rotation = 0
    Arrow.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 86)
    DropdownList.BackgroundColor3 = COLORS.Surface
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 5
    DropdownList.ClipsDescendants = true
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 12)
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
    ListPadding.PaddingLeft = UDim.new(0, 8)
    ListPadding.PaddingRight = UDim.new(0, 8)
    ListPadding.PaddingTop = UDim.new(0, 8)
    ListPadding.PaddingBottom = UDim.new(0, 8)
    ListPadding.Parent = ListContainer
    
    local isOpen = false
    local selectedOption = default or options[1]
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 40)
        OptionButton.BackgroundColor3 = COLORS.Background
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 6
        OptionButton.Parent = ListContainer
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 10)
        OptionCorner.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -40, 1, 0)
        OptionLabel.Position = UDim2.new(0, 14, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = COLORS.White
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.GothamMedium
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.ZIndex = 6
        OptionLabel.Parent = OptionButton
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 4, 0, 20)
        Indicator.Position = UDim2.new(1, -16, 0.5, -10)
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
            Indicator.Size = UDim2.new(0, 0, 0, 20)
            TweenService:Create(Indicator, FAST_TWEEN, {Size = UDim2.new(0, 4, 0, 20)}):Play()
            
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
        ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = true
        
        if isOpen then
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 180, ImageColor3 = COLORS.Accent}):Play()
            local targetHeight = math.min(220, ListLayout.AbsoluteContentSize.Y + 16)
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 96 + targetHeight)}):Play()
        else
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 0, ImageColor3 = COLORS.Gray}):Play()
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 80)}):Play()
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
    Dropdown.Size = UDim2.new(1, 0, 0, 80)
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = tab.Container
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.Position = UDim2.new(0, 0, 0, 30)
    Container.BackgroundColor3 = COLORS.Surface
    Container.BorderSizePixel = 0
    Container.Parent = Dropdown
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 12)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 12
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
    SelectedLabel.Size = UDim2.new(1, -55, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 18, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = "None selected"
    SelectedLabel.TextColor3 = COLORS.Gray
    SelectedLabel.TextSize = 14
    SelectedLabel.Font = Enum.Font.GothamMedium
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.Parent = DropdownButton
    
    updateLabel()
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 18, 0, 18)
    Arrow.Position = UDim2.new(1, -36, 0.5, -9)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://7733717447"
    Arrow.ImageColor3 = COLORS.Gray
    Arrow.Rotation = 0
    Arrow.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 86)
    DropdownList.BackgroundColor3 = COLORS.Surface
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 5
    DropdownList.ClipsDescendants = true
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 12)
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
    ListPadding.PaddingLeft = UDim.new(0, 8)
    ListPadding.PaddingRight = UDim.new(0, 8)
    ListPadding.PaddingTop = UDim.new(0, 8)
    ListPadding.PaddingBottom = UDim.new(0, 8)
    ListPadding.Parent = ListContainer
    
    local isOpen = false
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 40)
        OptionButton.BackgroundColor3 = COLORS.Background
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 6
        OptionButton.Parent = ListContainer
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 10)
        OptionCorner.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -40, 1, 0)
        OptionLabel.Position = UDim2.new(0, 14, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = COLORS.White
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.GothamMedium
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.ZIndex = 6
        OptionLabel.Parent = OptionButton
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 4, 0, 20)
        Indicator.Position = UDim2.new(1, -16, 0.5, -10)
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
                Indicator.Size = UDim2.new(0, 0, 0, 20)
                TweenService:Create(Indicator, FAST_TWEEN, {Size = UDim2.new(0, 4, 0, 20)}):Play()
            end
            
            updateLabel()
            
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
        ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = true
        
        if isOpen then
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 180, ImageColor3 = COLORS.Accent}):Play()
            local targetHeight = math.min(220, ListLayout.AbsoluteContentSize.Y + 16)
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 96 + targetHeight)}):Play()
        else
            TweenService:Create(Arrow, FAST_TWEEN, {Rotation = 0, ImageColor3 = COLORS.Gray}):Play()
            TweenService:Create(DropdownList, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(Dropdown, TWEEN_INFO, {Size = UDim2.new(1, 0, 0, 80)}):Play()
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
    Button.Size = UDim2.new(1, 0, 0, 50)
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
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = ButtonFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.Position = UDim2.new(0, 18, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ButtonFrame
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 18, 0, 18)
    Arrow.Position = UDim2.new(1, -36, 0.5, -9)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://7733717447"
    Arrow.ImageColor3 = COLORS.Gray
    Arrow.Rotation = -90
    Arrow.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0.92, 0)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.1), {Position = UDim2.new(1, -34, 0.5, -9)}):Play()
        wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.1), {Position = UDim2.new(1, -36, 0.5, -9)}):Play()
        
        if callback then
            callback()
        end
    end)
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, FAST_TWEEN, {BackgroundColor3 = COLORS.Accent}):Play()
        TweenService:Create(Arrow, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, FAST_TWEEN, {BackgroundColor3 = COLORS.Surface}):Play()
        TweenService:Create(Arrow, FAST_TWEEN, {ImageColor3 = COLORS.Gray}):Play()
    end)
    
    return Button
end

function ModernUI:CreateSlider(tab, name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 95)
    Slider.BackgroundColor3 = COLORS.Surface
    Slider.BorderSizePixel = 0
    Slider.Parent = tab.Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 12)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 24)
    Label.Position = UDim2.new(0, 18, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 80, 0, 24)
    ValueLabel.Position = UDim2.new(1, -98, 0, 15)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default or min)
    ValueLabel.TextColor3 = COLORS.Accent
    ValueLabel.TextSize = 15
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(0, 100, 0, 32)
    InputContainer.Position = UDim2.new(0, 18, 0, 50)
    InputContainer.BackgroundColor3 = COLORS.Background
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = Slider
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputContainer
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -12, 1, 0)
    TextBox.Position = UDim2.new(0, 6, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = tostring(default or min)
    TextBox.TextColor3 = COLORS.White
    TextBox.TextSize = 13
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = InputContainer
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -146, 0, 8)
    SliderTrack.Position = UDim2.new(0, 128, 0, 62)
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
    SliderHandle.Size = UDim2.new(0, 20, 0, 20)
    SliderHandle.Position = UDim2.new(0, -10, 0.5, -10)
    SliderHandle.BackgroundColor3 = COLORS.White
    SliderHandle.BorderSizePixel = 0
    SliderHandle.Parent = SliderTrack
    
    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(1, 0)
    HandleCorner.Parent = SliderHandle
    
    local HandleShadow = Instance.new("ImageLabel")
    HandleShadow.Size = UDim2.new(1, 20, 1, 20)
    HandleShadow.Position = UDim2.new(0, -10, 0, -10)
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
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        
        local useDecimals = (min % 1 ~= 0 or max % 1 ~= 0)
        local displayValue = useDecimals and string.format("%.2f", value) or tostring(math.floor(value))
        
        ValueLabel.Text = displayValue
        TextBox.Text = displayValue
        
        local percent = (value - min) / (max - min)
        TweenService:Create(SliderFill, FAST_TWEEN, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        TweenService:Create(SliderHandle, FAST_TWEEN, {Position = UDim2.new(percent, -10, 0.5, -10)}):Play()
        
        if callback then
            callback(value)
        end
    end
    
    updateSlider(currentValue)
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local relativeX = math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
            local percent = relativeX / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            updateSlider(value)
            
            TweenService:Create(SliderHandle, FAST_TWEEN, {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(percent, -12, 0.5, -12)}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
            local percent = relativeX / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            updateSlider(value)
            
            SliderHandle.Size = UDim2.new(0, 24, 0, 24)
            SliderHandle.Position = UDim2.new(percent, -12, 0.5, -12)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                local percent = (currentValue - min) / (max - min)
                TweenService:Create(SliderHandle, FAST_TWEEN, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(percent, -10, 0.5, -10)}):Play()
            end
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
    Notification.Size = UDim2.new(0, 380, 0, 90)
    Notification.Position = UDim2.new(1, 0, 1, -110)
    Notification.BackgroundColor3 = COLORS.Surface
    Notification.BorderSizePixel = 0
    Notification.Parent = self.ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 14)
    NotifCorner.Parent = Notification
    
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = Notification
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(1, -8, 0, 3)
    Accent.Position = UDim2.new(0, 4, 0, 4)
    Accent.BackgroundColor3 = COLORS.Accent
    Accent.BorderSizePixel = 0
    Accent.Parent = Notification
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = Accent
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 50, 0, 50)
    IconContainer.Position = UDim2.new(0, 20, 0.5, -25)
    IconContainer.BackgroundColor3 = COLORS.Background
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Notification
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = IconContainer
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 28, 0, 28)
    IconLabel.Position = UDim2.new(0.5, -14, 0.5, -14)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon or "rbxassetid://7733955511"
    IconLabel.ImageColor3 = COLORS.Accent
    IconLabel.Parent = IconContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -90, 0, 24)
    TitleLabel.Position = UDim2.new(0, 80, 0, 22)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = Notification
    
    local BodyLabel = Instance.new("TextLabel")
    BodyLabel.Size = UDim2.new(1, -90, 0, 30)
    BodyLabel.Position = UDim2.new(0, 80, 0, 46)
    BodyLabel.BackgroundTransparency = 1
    BodyLabel.Text = body
    BodyLabel.TextColor3 = COLORS.Gray
    BodyLabel.TextSize = 12
    BodyLabel.Font = Enum.Font.Gotham
    BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    BodyLabel.TextYAlignment = Enum.TextYAlignment.Top
    BodyLabel.TextWrapped = true
    BodyLabel.Parent = Notification
    
    Notification.Position = UDim2.new(1, 0, 1, -110)
    local tweenIn = TweenService:Create(Notification, TWEEN_INFO, {Position = UDim2.new(1, -400, 1, -110)})
    tweenIn:Play()
    
    task.delay(duration or 5, function()
        local tweenOut = TweenService:Create(Notification, TWEEN_INFO, {Position = UDim2.new(1, 0, 1, -110)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

return ModernUI
