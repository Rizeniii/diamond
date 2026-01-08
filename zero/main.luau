local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

local Theme = {
    Background = Color3.fromRGB(5, 5, 5),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(100, 100, 100),
    DarkGray = Color3.fromRGB(30, 30, 30)
}

function Library:CreateWindow(Config)
    local Window = {
        CurrentTab = nil,
        Minimized = false
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 10, 0, 10)
    Icon.BackgroundTransparency = 1
    Icon.Image = Config.Icon or ""
    Icon.Parent = Header

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0, 200, 0, 20)
    TitleText.Position = UDim2.new(0, 60, 0, 12)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Config.Title or "UI Library"
    TitleText.TextColor3 = Theme.White
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 18
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = Header

    local SubtitleText = Instance.new("TextLabel")
    SubtitleText.Size = UDim2.new(0, 200, 0, 15)
    SubtitleText.Position = UDim2.new(0, 60, 0, 32)
    SubtitleText.BackgroundTransparency = 1
    SubtitleText.Text = Config.Subtitle or "Interface"
    SubtitleText.TextColor3 = Theme.White
    SubtitleText.Font = Enum.Font.Gotham
    SubtitleText.TextSize = 12
    SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleText.Parent = Header

    local ButtonsContainer = Instance.new("Frame")
    ButtonsContainer.Size = UDim2.new(0, 80, 0, 30)
    ButtonsContainer.Position = UDim2.new(1, -90, 0, 15)
    ButtonsContainer.BackgroundTransparency = 1
    ButtonsContainer.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.White
    CloseBtn.TextSize = 16
    CloseBtn.Parent = ButtonsContainer

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.White
    MinBtn.TextSize = 20
    MinBtn.Parent = ButtonsContainer

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -60)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -150, 1, -70)
    TabContainer.Position = UDim2.new(0, 145, 0, 65)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = Sidebar
    TabList.Padding = UDim.new(0, 5)

    local ContentPages = Instance.new("Folder")
    ContentPages.Name = "Pages"
    ContentPages.Parent = TabContainer

    local function CreateTab(name, icon)
        local Tab = {}
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 35)
        TabBtn.BackgroundColor3 = Theme.White
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "    " .. name
        TabBtn.TextColor3 = Theme.White
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 1, 0)
        Indicator.BackgroundColor3 = Theme.White
        Indicator.BorderSizePixel = 0
        Indicator.BackgroundTransparency = 1
        Indicator.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = ContentPages

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentPages:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v.Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                end 
            end
            Page.Visible = true
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.9}):Play()
        end)

        function Tab:CreateToggle(name, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Page

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Theme.White
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local Outer = Instance.new("Frame")
            Outer.Size = UDim2.new(0, 40, 0, 20)
            Outer.Position = UDim2.new(1, -50, 0.5, -10)
            Outer.BackgroundColor3 = Theme.Gray
            Outer.BorderSizePixel = 0
            Outer.Parent = ToggleFrame

            local Inner = Instance.new("Frame")
            Inner.Size = UDim2.new(0, 16, 0, 16)
            Inner.Position = UDim2.new(0, 2, 0.5, -8)
            Inner.BackgroundColor3 = Theme.White
            Inner.BorderSizePixel = 0
            Inner.Parent = Outer

            local Toggled = false
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    local targetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local targetColor = Toggled and Theme.White or Theme.Gray
                    TweenService:Create(Inner, TweenInfo.new(0.3), {Position = targetPos}):Play()
                    TweenService:Create(Outer, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
                    callback(Toggled)
                end
            end)
        end

        function Tab:CreateButton(name, callback)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
            ButtonFrame.BackgroundColor3 = Theme.Background
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = "  " .. name
            ButtonFrame.TextColor3 = Theme.White
            ButtonFrame.Font = Enum.Font.Gotham
            ButtonFrame.TextSize = 14
            ButtonFrame.TextXAlignment = Enum.TextXAlignment.Left
            ButtonFrame.Parent = Page

            local Arrow = Instance.new("ImageLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -30, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://110294213486252"
            Arrow.ImageColor3 = Theme.White
            Arrow.Parent = ButtonFrame

            ButtonFrame.MouseButton1Click:Connect(function()
                local originalPos = Arrow.Position
                TweenService:Create(Arrow, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                task.wait(0.1)
                TweenService:Create(Arrow, TweenInfo.new(0.1), {Position = originalPos}):Play()
                callback()
            end)
        end

        function Tab:CreateSlider(name, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -20, 0, 50)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Theme.White
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -40, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(min)
            ValueLabel.TextColor3 = Theme.White
            ValueLabel.Parent = SliderFrame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -10, 0, 2)
            Track.Position = UDim2.new(0, 5, 0, 35)
            Track.BackgroundColor3 = Theme.Gray
            Track.BorderSizePixel = 0
            Track.Parent = SliderFrame

            local Handle = Instance.new("Frame")
            Handle.Size = UDim2.new(0, 12, 0, 12)
            Handle.Position = UDim2.new(0, 0, 0.5, -6)
            Handle.BackgroundColor3 = Theme.White
            Handle.BorderSizePixel = 0
            Handle.Parent = Track

            local dragging = false
            Handle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mousePos = UIS:GetMouseLocation().X
                    local trackPos = Track.AbsolutePosition.X
                    local trackSize = Track.AbsoluteSize.X
                    local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                    Handle.Position = UDim2.new(percent, -6, 0.5, -6)
                    local val = math.floor(min + (max - min) * percent)
                    ValueLabel.Text = tostring(val)
                    callback(val)
                end
            end)
        end

        function Tab:CreateSeparator(name)
            local SepFrame = Instance.new("Frame")
            SepFrame.Size = UDim2.new(1, -20, 0, 20)
            SepFrame.BackgroundTransparency = 1
            SepFrame.Parent = Page

            local SepLabel = Instance.new("TextLabel")
            SepLabel.Size = UDim2.new(1, 0, 1, 0)
            SepLabel.BackgroundTransparency = 1
            SepLabel.Text = "======= " .. name .. " ======="
            SepLabel.TextColor3 = Theme.Gray
            SepLabel.Font = Enum.Font.Gotham
            SepLabel.TextSize = 12
            SepLabel.Parent = SepFrame
        end

        return Tab
    end

    MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            MainFrame.Size = UDim2.new(0, 250, 0, 60)
            Sidebar.Visible = false
            TabContainer.Visible = false
            MinBtn.Text = "+"
        else
            MainFrame.Size = UDim2.new(0, 550, 0, 350)
            Sidebar.Visible = true
            TabContainer.Visible = true
            MinBtn.Text = "-"
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    Window.CreateTab = CreateTab
    return Window
end

function Library:Notification(Config)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 250, 0, 80)
    NotificationFrame.Position = UDim2.new(1, 10, 1, -90)
    NotificationFrame.BackgroundColor3 = Theme.Background
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = CoreGui:FindFirstChild("UILibrary")

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 10, 0.5, -20)
    Icon.BackgroundTransparency = 1
    Icon.Image = Config.Icon or ""
    Icon.Parent = NotificationFrame

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -60, 0, 20)
    TitleText.Position = UDim2.new(0, 60, 0, 15)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Config.Title or "Notification"
    TitleText.TextColor3 = Theme.White
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = NotificationFrame

    local BodyText = Instance.new("TextLabel")
    BodyText.Size = UDim2.new(1, -60, 0, 30)
    BodyText.Position = UDim2.new(0, 60, 0, 35)
    BodyText.BackgroundTransparency = 1
    BodyText.Text = Config.Content or "Body Text"
    BodyText.TextColor3 = Theme.White
    BodyText.Font = Enum.Font.Gotham
    BodyText.TextSize = 12
    BodyText.TextXAlignment = Enum.TextXAlignment.Left
    BodyText.TextWrapped = true
    BodyText.Parent = NotificationFrame

    TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -260, 1, -90)}):Play()
    task.delay(3, function()
        TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 10, 1, -90)}):Play()
        task.wait(0.5)
        NotificationFrame:Destroy()
    end)
end

return Library
