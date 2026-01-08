local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ModernUI = {}
ModernUI.__index = ModernUI

local COLORS = {
    Black = Color3.fromRGB(0, 0, 0),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(128, 128, 128)
}

local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST_TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

function ModernUI.new(title, subtitle)
    local self = setmetatable({}, ModernUI)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 700, 0, 500)
    self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    self.MainFrame.BackgroundColor3 = COLORS.Black
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.Active = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.MainFrame
    
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
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = COLORS.Black
    Header.BorderSizePixel = 0
    Header.Parent = self.MainFrame
    
    local IconFrame = Instance.new("ImageLabel")
    IconFrame.Name = "Icon"
    IconFrame.Size = UDim2.new(0, 40, 0, 40)
    IconFrame.Position = UDim2.new(0, 15, 0.5, -20)
    IconFrame.BackgroundTransparency = 1
    IconFrame.Image = "rbxassetid://7733955511"
    IconFrame.ImageColor3 = COLORS.White
    IconFrame.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 300, 0, 22)
    TitleLabel.Position = UDim2.new(0, 65, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(0, 300, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 65, 0, 34)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = COLORS.Gray
    SubtitleLabel.TextSize = 13
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = Header
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -45, 0.5, -15)
    CloseButton.BackgroundColor3 = COLORS.Black
    CloseButton.Text = "X"
    CloseButton.TextColor3 = COLORS.White
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        self:ShowConfirmDialog()
    end)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -80, 0.5, -15)
    MinimizeButton.BackgroundColor3 = COLORS.Black
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = COLORS.White
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = MinimizeButton
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 1, 0)
    Divider.BackgroundColor3 = COLORS.Gray
    Divider.BorderSizePixel = 0
    Divider.Parent = Header
end

function ModernUI:CreateSidebar()
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -60)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundColor3 = COLORS.Black
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = self.MainFrame
    
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(0, 1, 1, 0)
    Divider.Position = UDim2.new(1, 0, 0, 0)
    Divider.BackgroundColor3 = COLORS.Gray
    Divider.BorderSizePixel = 0
    Divider.Parent = Sidebar
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 4
    TabList.ScrollBarImageColor3 = COLORS.Gray
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = Sidebar
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = TabList
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    self.TabList = TabList
end

function ModernUI:CreateContentArea()
    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -155, 1, -65)
    ContentArea.Position = UDim2.new(0, 155, 0, 65)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ScrollBarThickness = 4
    ContentArea.ScrollBarImageColor3 = COLORS.Gray
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentArea.Parent = self.MainFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = ContentArea
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.Parent = ContentArea
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentArea.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    self.ContentArea = ContentArea
end

function ModernUI:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local Header = self.MainFrame:FindFirstChild("Header")
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Parent = self.MainFrame
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = self.MainFrame.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(500, startSize.X.Offset + delta.X)
            local newHeight = math.max(400, startSize.Y.Offset + delta.Y)
            self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function ModernUI:ShowConfirmDialog()
    local Overlay = Instance.new("Frame")
    Overlay.Name = "ConfirmOverlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = self.MainFrame
    
    local Dialog = Instance.new("Frame")
    Dialog.Name = "Dialog"
    Dialog.Size = UDim2.new(0, 300, 0, 150)
    Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    Dialog.BackgroundColor3 = COLORS.Black
    Dialog.BorderSizePixel = 1
    Dialog.BorderColor3 = COLORS.Gray
    Dialog.ZIndex = 11
    Dialog.Parent = Overlay
    
    local DialogCorner = Instance.new("UICorner")
    DialogCorner.CornerRadius = UDim.new(0, 8)
    DialogCorner.Parent = Dialog
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Confirm Close"
    Title.TextColor3 = COLORS.White
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 11
    Title.Parent = Dialog
    
    local Message = Instance.new("TextLabel")
    Message.Size = UDim2.new(1, -20, 0, 40)
    Message.Position = UDim2.new(0, 10, 0, 45)
    Message.BackgroundTransparency = 1
    Message.Text = "Are you sure you want to close?"
    Message.TextColor3 = COLORS.Gray
    Message.TextSize = 13
    Message.Font = Enum.Font.Gotham
    Message.TextWrapped = true
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.ZIndex = 11
    Message.Parent = Dialog
    
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Size = UDim2.new(0, 130, 0, 35)
    ConfirmButton.Position = UDim2.new(0, 10, 1, -45)
    ConfirmButton.BackgroundColor3 = COLORS.White
    ConfirmButton.Text = "Yes"
    ConfirmButton.TextColor3 = COLORS.Black
    ConfirmButton.TextSize = 14
    ConfirmButton.Font = Enum.Font.GothamBold
    ConfirmButton.ZIndex = 11
    ConfirmButton.Parent = Dialog
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 6)
    ConfirmCorner.Parent = ConfirmButton
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Size = UDim2.new(0, 130, 0, 35)
    CancelButton.Position = UDim2.new(1, -140, 1, -45)
    CancelButton.BackgroundColor3 = COLORS.Black
    CancelButton.BorderSizePixel = 1
    CancelButton.BorderColor3 = COLORS.Gray
    CancelButton.Text = "Cancel"
    CancelButton.TextColor3 = COLORS.White
    CancelButton.TextSize = 14
    CancelButton.Font = Enum.Font.Gotham
    CancelButton.ZIndex = 11
    CancelButton.Parent = Dialog
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 6)
    CancelCorner.Parent = CancelButton
    
    ConfirmButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    CancelButton.MouseButton1Click:Connect(function()
        Overlay:Destroy()
    end)
end

function ModernUI:Minimize()
    if self.MinimizedFrame then return end
    
    local MinFrame = Instance.new("Frame")
    MinFrame.Name = "MinimizedFrame"
    MinFrame.Size = UDim2.new(0, 400, 0, 100)
    MinFrame.Position = UDim2.new(0.5, -200, 0.5, -50)
    MinFrame.BackgroundColor3 = COLORS.Black
    MinFrame.BorderSizePixel = 1
    MinFrame.BorderColor3 = COLORS.Gray
    MinFrame.Parent = self.ScreenGui
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinFrame
    
    local TopDivider = Instance.new("Frame")
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 0)
    TopDivider.BackgroundColor3 = COLORS.White
    TopDivider.BorderSizePixel = 0
    TopDivider.Parent = MinFrame
    
    local BottomDivider = Instance.new("Frame")
    BottomDivider.Size = UDim2.new(1, 0, 0, 1)
    BottomDivider.Position = UDim2.new(0, 0, 1, -1)
    BottomDivider.BackgroundColor3 = COLORS.White
    BottomDivider.BorderSizePixel = 0
    BottomDivider.Parent = MinFrame
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0, 20, 0.5, -25)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://7733955511"
    Icon.ImageColor3 = COLORS.White
    Icon.Parent = MinFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 0, 24)
    Title.Position = UDim2.new(0, 80, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = self.MainFrame.Header.Title.Text
    Title.TextColor3 = COLORS.White
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MinFrame
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 200, 0, 18)
    Subtitle.Position = UDim2.new(0, 80, 0, 50)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = self.MainFrame.Header.Subtitle.Text
    Subtitle.TextColor3 = COLORS.Gray
    Subtitle.TextSize = 12
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = MinFrame
    
    local RestoreButton = Instance.new("TextButton")
    RestoreButton.Size = UDim2.new(0, 40, 0, 40)
    RestoreButton.Position = UDim2.new(1, -60, 0.5, -20)
    RestoreButton.BackgroundColor3 = COLORS.Black
    RestoreButton.Text = "+"
    RestoreButton.TextColor3 = COLORS.White
    RestoreButton.TextSize = 24
    RestoreButton.Font = Enum.Font.GothamBold
    RestoreButton.Parent = MinFrame
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(0, 6)
    RestoreCorner.Parent = RestoreButton
    
    RestoreButton.MouseButton1Click:Connect(function()
        self:Restore()
    end)
    
    self.MinimizedFrame = MinFrame
    self.MainFrame.Visible = false
    
    TweenService:Create(MinFrame, TWEEN_INFO, {Size = UDim2.new(0, 400, 0, 100)}):Play()
end

function ModernUI:Restore()
    if not self.MinimizedFrame then return end
    
    local tween = TweenService:Create(self.MinimizedFrame, TWEEN_INFO, {Size = UDim2.new(0, 0, 0, 0)})
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
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = COLORS.Black
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabList
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 1, 0)
    Indicator.Position = UDim2.new(0, 0, 0, 0)
    Indicator.BackgroundColor3 = COLORS.White
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = TabButton
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 20, 0, 20)
    IconLabel.Position = UDim2.new(0, 15, 0.5, -10)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon or "rbxassetid://7733955511"
    IconLabel.ImageColor3 = COLORS.Gray
    IconLabel.Parent = TabButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 45, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.Gray
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
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
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = Container
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
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
        t.IconLabel.ImageColor3 = COLORS.Gray
        t.Label.TextColor3 = COLORS.Gray
    end
    
    tab.Container.Visible = true
    tab.Indicator.Visible = true
    tab.IconLabel.ImageColor3 = COLORS.White
    tab.Label.TextColor3 = COLORS.White
    
    TweenService:Create(tab.Indicator, FAST_TWEEN, {Size = UDim2.new(0, 3, 1, 0)}):Play()
    
    self.CurrentTab = tab
end

function ModernUI:CreateSection(tab, name)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, 0, 0, 40)
    Section.BackgroundTransparency = 1
    Section.Parent = tab.Container
    
    local LeftGradient = Instance.new("Frame")
    LeftGradient.Size = UDim2.new(0.35, 0, 0, 1)
    LeftGradient.Position = UDim2.new(0, 0, 0.5, 0)
    LeftGradient.BackgroundColor3 = COLORS.Gray
    LeftGradient.BorderSizePixel = 0
    LeftGradient.Parent = Section
    
    local LeftGrad = Instance.new("UIGradient")
    LeftGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Black),
        ColorSequenceKeypoint.new(1, COLORS.Gray)
    })
    LeftGrad.Parent = LeftGradient
    
    local RightGradient = Instance.new("Frame")
    RightGradient.Size = UDim2.new(0.35, 0, 0, 1)
    RightGradient.Position = UDim2.new(0.65, 0, 0.5, 0)
    RightGradient.BackgroundColor3 = COLORS.Gray
    RightGradient.BorderSizePixel = 0
    RightGradient.Parent = Section
    
    local RightGrad = Instance.new("UIGradient")
    RightGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.Gray),
        ColorSequenceKeypoint.new(1, COLORS.Black)
    })
    RightGrad.Parent = RightGradient
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(0.3, 0, 1, 0)
    SectionLabel.Position = UDim2.new(0.35, 0, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = name
    SectionLabel.TextColor3 = COLORS.Gray
    SectionLabel.TextSize = 12
    SectionLabel.Font = Enum.Font.Gotham
    SectionLabel.Parent = Section
end

function ModernUI:CreateToggle(tab, name, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.BackgroundTransparency = 1
    Toggle.Parent = tab.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 24)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    ToggleButton.BackgroundColor3 = COLORS.Gray
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = Toggle
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
    ToggleCircle.BackgroundColor3 = COLORS.White
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = default or false
    
    if toggled then
        ToggleButton.BackgroundColor3 = COLORS.White
        ToggleCircle.Position = UDim2.new(1, -21, 0.5, -9)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.White}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            TweenService:Create(ToggleButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Gray}):Play()
            TweenService:Create(ToggleCircle, FAST_TWEEN, {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
        
        if callback then
            callback(toggled)
        end
    end)
    
    return Toggle
end

function ModernUI:CreateDropdown(tab, name, options, default, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 40)
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = tab.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Dropdown
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 35)
    DropdownButton.Position = UDim2.new(0, 0, 0, 22)
    DropdownButton.BackgroundColor3 = COLORS.Gray
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = ""
    DropdownButton.AutoButtonColor = false
    DropdownButton.Parent = Dropdown
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = DropdownButton
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, -45, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = default or options[1] or ""
    SelectedLabel.TextColor3 = COLORS.White
    SelectedLabel.TextSize = 13
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.Parent = DropdownButton
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -26, 0.5, -8)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://116845122064768"
    Arrow.ImageColor3 = COLORS.White
    Arrow.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 60)
    DropdownList.BackgroundColor3 = COLORS.Black
    DropdownList.BorderSizePixel = 1
    DropdownList.BorderColor3 = COLORS.Gray
    DropdownList.Visible = false
    DropdownList.ZIndex = 5
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 0)
    ListLayout.Parent = DropdownList
    
    local isOpen = false
    local selectedOption = default or options[1]
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 35)
        OptionButton.BackgroundColor3 = COLORS.Black
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 6
        OptionButton.Parent = DropdownList
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -45, 1, 0)
        OptionLabel.Position = UDim2.new(0, 10, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = COLORS.White
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.ZIndex = 6
        OptionLabel.Parent = OptionButton
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 1, -10)
        Indicator.Position = UDim2.new(1, -10, 0, 5)
        Indicator.BackgroundColor3 = COLORS.White
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
            
            for _, child in ipairs(DropdownList:GetChildren()) do
                if child:IsA("TextButton") then
                    local ind = child:FindFirstChild("Frame")
                    if ind then
                        ind.Visible = false
                    end
                end
            end
            
            Indicator.Visible = true
            TweenService:Create(Indicator, FAST_TWEEN, {Size = UDim2.new(0, 3, 1, -10)}):Play()
            
            if callback then
                callback(option)
            end
        end)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Black}):Play()
        end)
    end
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            DropdownList.Size = UDim2.new(1, 0, 0, math.min(200, ListLayout.AbsoluteContentSize.Y))
        end
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = isOpen
        
        if isOpen then
            Arrow.Image = "rbxassetid://132854725146991"
            TweenService:Create(DropdownList, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, math.min(200, ListLayout.AbsoluteContentSize.Y))}):Play()
            TweenService:Create(Dropdown, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, 70 + math.min(200, ListLayout.AbsoluteContentSize.Y))}):Play()
        else
            Arrow.Image = "rbxassetid://116845122064768"
            TweenService:Create(DropdownList, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(Dropdown, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, 40)}):Play()
            wait(0.15)
            DropdownList.Visible = false
        end
    end)
    
    return Dropdown
end

function ModernUI:CreateMultiDropdown(tab, name, options, defaults, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "MultiDropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 40)
    Dropdown.BackgroundTransparency = 1
    Dropdown.Parent = tab.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Dropdown
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 35)
    DropdownButton.Position = UDim2.new(0, 0, 0, 22)
    DropdownButton.BackgroundColor3 = COLORS.Gray
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = ""
    DropdownButton.AutoButtonColor = false
    DropdownButton.Parent = Dropdown
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = DropdownButton
    
    local selectedOptions = defaults or {}
    
    local function updateLabel()
        if #selectedOptions == 0 then
            SelectedLabel.Text = "None selected"
        elseif #selectedOptions == 1 then
            SelectedLabel.Text = selectedOptions[1]
        else
            SelectedLabel.Text = #selectedOptions .. " selected"
        end
    end
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, -45, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = "None selected"
    SelectedLabel.TextColor3 = COLORS.White
    SelectedLabel.TextSize = 13
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.Parent = DropdownButton
    
    updateLabel()
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -26, 0.5, -8)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://116845122064768"
    Arrow.ImageColor3 = COLORS.White
    Arrow.Parent = DropdownButton
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 60)
    DropdownList.BackgroundColor3 = COLORS.Black
    DropdownList.BorderSizePixel = 1
    DropdownList.BorderColor3 = COLORS.Gray
    DropdownList.Visible = false
    DropdownList.ZIndex = 5
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 0)
    ListLayout.Parent = DropdownList
    
    local isOpen = false
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 35)
        OptionButton.BackgroundColor3 = COLORS.Black
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 6
        OptionButton.Parent = DropdownList
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -45, 1, 0)
        OptionLabel.Position = UDim2.new(0, 10, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = COLORS.White
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.ZIndex = 6
        OptionLabel.Parent = OptionButton
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 1, -10)
        Indicator.Position = UDim2.new(1, -10, 0, 5)
        Indicator.BackgroundColor3 = COLORS.White
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
                TweenService:Create(Indicator, FAST_TWEEN, {Size = UDim2.new(0, 3, 1, -10)}):Play()
            end
            
            updateLabel()
            
            if callback then
                callback(selectedOptions)
            end
        end)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, FAST_TWEEN, {BackgroundColor3 = COLORS.Black}):Play()
        end)
    end
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            DropdownList.Size = UDim2.new(1, 0, 0, math.min(200, ListLayout.AbsoluteContentSize.Y))
        end
    end)
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        DropdownList.Visible = isOpen
        
        if isOpen then
            Arrow.Image = "rbxassetid://132854725146991"
            TweenService:Create(DropdownList, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, math.min(200, ListLayout.AbsoluteContentSize.Y))}):Play()
            TweenService:Create(Dropdown, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, 70 + math.min(200, ListLayout.AbsoluteContentSize.Y))}):Play()
        else
            Arrow.Image = "rbxassetid://116845122064768"
            TweenService:Create(DropdownList, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(Dropdown, FAST_TWEEN, {Size = UDim2.new(1, 0, 0, 40)}):Play()
            wait(0.15)
            DropdownList.Visible = false
        end
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
    ButtonFrame.BackgroundColor3 = COLORS.Gray
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = Button
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ButtonFrame
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -26, 0.5, -8)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://110294213486252"
    Arrow.ImageColor3 = COLORS.White
    Arrow.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0.9, 0)}):Play()
        wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        
        if callback then
            callback()
        end
    end)
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, FAST_TWEEN, {BackgroundColor3 = COLORS.White}):Play()
        TweenService:Create(Label, FAST_TWEEN, {TextColor3 = COLORS.Black}):Play()
        TweenService:Create(Arrow, FAST_TWEEN, {ImageColor3 = COLORS.Black}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, FAST_TWEEN, {BackgroundColor3 = COLORS.Gray}):Play()
        TweenService:Create(Label, FAST_TWEEN, {TextColor3 = COLORS.White}):Play()
        TweenService:Create(Arrow, FAST_TWEEN, {ImageColor3 = COLORS.White}):Play()
    end)
    
    return Button
end

function ModernUI:CreateSlider(tab, name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 65)
    Slider.BackgroundTransparency = 1
    Slider.Parent = tab.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = COLORS.White
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 18)
    ValueLabel.Position = UDim2.new(1, -65, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default or min)
    ValueLabel.TextColor3 = COLORS.White
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Size = UDim2.new(0, 80, 0, 30)
    TextBoxFrame.Position = UDim2.new(0, 0, 0, 25)
    TextBoxFrame.BackgroundColor3 = COLORS.Gray
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Parent = Slider
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBoxFrame
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -10, 1, 0)
    TextBox.Position = UDim2.new(0, 5, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = tostring(default or min)
    TextBox.TextColor3 = COLORS.White
    TextBox.TextSize = 13
    TextBox.Font = Enum.Font.Gotham
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = TextBoxFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -95, 0, 6)
    SliderTrack.Position = UDim2.new(0, 90, 0, 37)
    SliderTrack.BackgroundColor3 = COLORS.Gray
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = Slider
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = COLORS.White
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
        TweenService:Create(SliderHandle, FAST_TWEEN, {Position = UDim2.new(percent, -8, 0.5, -8)}):Play()
        
        if callback then
            callback(value)
        end
    end
    
    updateSlider(currentValue)
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativeX = math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
            local percent = relativeX / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            updateSlider(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
            local percent = relativeX / SliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
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
    
    return Slider
end

function ModernUI:CreateNotification(title, body, icon, duration)
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(0, 350, 0, 80)
    Notification.Position = UDim2.new(1, -370, 1, -100)
    Notification.BackgroundColor3 = COLORS.Black
    Notification.BorderSizePixel = 1
    Notification.BorderColor3 = COLORS.Gray
    Notification.Parent = self.ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notification
    
    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Size = UDim2.new(0, 50, 0, 50)
    IconLabel.Position = UDim2.new(0, 15, 0.5, -25)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = icon or "rbxassetid://7733955511"
    IconLabel.ImageColor3 = COLORS.White
    IconLabel.Parent = Notification
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 0, 22)
    TitleLabel.Position = UDim2.new(0, 75, 0, 15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = COLORS.White
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = Notification
    
    local BodyLabel = Instance.new("TextLabel")
    BodyLabel.Size = UDim2.new(1, -80, 0, 35)
    BodyLabel.Position = UDim2.new(0, 75, 0, 40)
    BodyLabel.BackgroundTransparency = 1
    BodyLabel.Text = body
    BodyLabel.TextColor3 = COLORS.Gray
    BodyLabel.TextSize = 12
    BodyLabel.Font = Enum.Font.Gotham
    BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    BodyLabel.TextYAlignment = Enum.TextYAlignment.Top
    BodyLabel.TextWrapped = true
    BodyLabel.Parent = Notification
    
    Notification.Position = UDim2.new(1, 0, 1, -100)
    TweenService:Create(Notification, TWEEN_INFO, {Position = UDim2.new(1, -370, 1, -100)}):Play()
    
    task.delay(duration or 5, function()
        local tweenOut = TweenService:Create(Notification, TWEEN_INFO, {Position = UDim2.new(1, 0, 1, -100)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

return ModernUI
