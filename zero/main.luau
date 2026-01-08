local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

local Theme = {
    Background = Color3.fromRGB(5, 5, 5),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(120, 120, 120),
    DarkGray = Color3.fromRGB(30, 30, 30)
}

function Library:CreateWindow(Config)
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DiamondUILibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 45, 0, 45)
    Icon.Position = UDim2.new(0, 10, 0, 7)
    Icon.BackgroundTransparency = 1
    Icon.Image = Config.Icon or ""
    Icon.Parent = Header

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(0, 200, 0, 20)
    TitleText.Position = UDim2.new(0, 65, 0, 12)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = Config.Title or "UI Library"
    TitleText.TextColor3 = Theme.White
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 18
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = Header

    local SubtitleText = Instance.new("TextLabel")
    SubtitleText.Size = UDim2.new(0, 200, 0, 15)
    SubtitleText.Position = UDim2.new(0, 65, 0, 32)
    SubtitleText.BackgroundTransparency = 1
    SubtitleText.Text = Config.Subtitle or "Interface"
    SubtitleText.TextColor3 = Theme.White
    SubtitleText.Font = Enum.Font.Gotham
    SubtitleText.TextSize = 12
    SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleText.Parent = Header

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -60)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.Parent = Sidebar

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -150, 1, -70)
    Container.Position = UDim2.new(0, 145, 0, 65)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    function Window:CreateTab(name, iconId)
        local Tab = { Active = false }
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -5, 0, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "      " .. name
        TabBtn.TextColor3 = Theme.White
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId or ""
        TabIcon.Parent = TabBtn

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0.6, 0)
        Indicator.Position = UDim2.new(0, 0, 0.2, 0)
        Indicator.BackgroundColor3 = Theme.White
        Indicator.BorderSizePixel = 0
        Indicator.BackgroundTransparency = 1
        Indicator.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Parent = Container

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
            Page.Visible = true
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.9, BackgroundColor3 = Theme.White}):Play()
        end)

        function Tab:CreateToggle(name, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Theme.White
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local Outer = Instance.new("Frame")
            Outer.Size = UDim2.new(0, 38, 0, 20)
            Outer.Position = UDim2.new(1, -48, 0.5, -10)
            Outer.BackgroundColor3 = Theme.Gray
            Outer.BorderSizePixel = 0
            Outer.Parent = ToggleFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Outer

            local Inner = Instance.new("Frame")
            Inner.Size = UDim2.new(0, 16, 0, 16)
            Inner.Position = UDim2.new(0, 2, 0.5, -8)
            Inner.BackgroundColor3 = Theme.White
            Inner.BorderSizePixel = 0
            Inner.Parent = Outer
            
            local UICorner2 = Instance.new("UICorner")
            UICorner2.CornerRadius = UDim.new(1, 0)
            UICorner2.Parent = Inner

            local Toggled = false
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    local pos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local color = Toggled and Theme.White or Theme.Gray
                    TweenService:Create(Inner, TweenInfo.new(0.2), {Position = pos}):Play()
                    TweenService:Create(Outer, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
                    callback(Toggled)
                end
            end)
        end

        function Tab:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Button.BorderSizePixel = 0
            Button.Text = "  " .. name
            Button.TextColor3 = Theme.White
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.Parent = Page

            local Arrow = Instance.new("ImageLabel")
            Arrow.Size = UDim2.new(0, 18, 0, 18)
            Arrow.Position = UDim2.new(1, -28, 0.5, -9)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://110294213486252"
            Arrow.Parent = Button

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
                callback()
            end)
        end

        function Tab:CreateSlider(name, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 55)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Theme.White
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -30, 0, 3)
            Track.Position = UDim2.new(0, 15, 0, 40)
            Track.BackgroundColor3 = Theme.Gray
            Track.BorderSizePixel = 0
            Track.Parent = SliderFrame

            local Handle = Instance.new("Frame")
            Handle.Size = UDim2.new(0, 12, 0, 12)
            Handle.Position = UDim2.new(0, 0, 0.5, -6)
            Handle.BackgroundColor3 = Theme.White
            Handle.BorderSizePixel = 0
            Handle.Parent = Track

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Handle

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(min)
            ValueLabel.TextColor3 = Theme.White
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextSize = 13
            ValueLabel.Parent = SliderFrame

            local dragging = false
            local function update()
                local pos = math.clamp((UIS:GetMouseLocation().X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Handle.Position = UDim2.new(pos, -6, 0.5, -6)
                local val = math.floor(min + (max - min) * pos)
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            Handle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            RunService.RenderStepped:Connect(function() if dragging then update() end end)
        end

        function Tab:CreateSeparator(name)
            local SepFrame = Instance.new("Frame")
            SepFrame.Size = UDim2.new(1, -10, 0, 30)
            SepFrame.BackgroundTransparency = 1
            SepFrame.Parent = Page

            local Text = Instance.new("TextLabel")
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.BackgroundTransparency = 1
            Text.Text = "======= " .. name:upper() .. " ======="
            Text.TextColor3 = Theme.Gray
            Text.Font = Enum.Font.GothamBold
            Text.TextSize = 11
            Text.Parent = SepFrame
        end

        table.insert(Window.Tabs, {Btn = TabBtn, Page = Page, Indicator = Indicator})
        return Tab
    end

    return Window
end

function Library:Notification(Config)
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 260, 0, 70)
    Notif.Position = UDim2.new(1, 10, 1, -80)
    Notif.BackgroundColor3 = Theme.Background
    Notif.BorderSizePixel = 0
    Notif.Parent = CoreGui:FindFirstChild("DiamondUILibrary") or CoreGui:FindFirstChild("UILibrary")

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 10, 0.5, -20)
    Icon.BackgroundTransparency = 1
    Icon.Image = Config.Icon or ""
    Icon.Parent = Notif

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 0, 20)
    Title.Position = UDim2.new(0, 60, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title or "Notificação"
    Title.TextColor3 = Theme.White
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notif

    local Body = Instance.new("TextLabel")
    Body.Size = UDim2.new(1, -60, 0, 30)
    Body.Position = UDim2.new(0, 60, 0, 30)
    Body.BackgroundTransparency = 1
    Body.Text = Config.Content or ""
    Body.TextColor3 = Theme.White
    Body.Font = Enum.Font.Gotham
    Body.TextSize = 12
    Body.TextXAlignment = Enum.TextXAlignment.Left
    Body.TextWrapped = true
    Body.Parent = Notif

    TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 1, -80)}):Play()
    task.delay(3.5, function()
        TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 1, -80)}):Play()
        task.wait(0.5)
        Notif:Destroy()
    end)
end

return Library
