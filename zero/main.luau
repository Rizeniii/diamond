local UI = {}

local ExtremelyDarkBlack = Color3.fromRGB(10, 10, 10)
local White = Color3.fromRGB(255, 255, 255)
local Gray = Color3.fromRGB(120, 120, 120)
local DarkGray = Color3.fromRGB(60, 60, 60)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function createTweenInfo(duration, easingStyle)
	return TweenInfo.new(duration, easingStyle, Enum.EasingDirection.InOut)
end

function UI:CreateMainWindow(title, subtitle)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MainUI"
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.7, 0, 0.8, 0)
	frame.Position = UDim2.new(0.15, 0, 0.1, 0)
	frame.BackgroundColor3 = ExtremelyDarkBlack
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 60)
	header.BackgroundColor3 = ExtremelyDarkBlack
	header.BorderSizePixel = 0
	header.Parent = frame

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 50, 0, 50)
	icon.Position = UDim2.new(0, 15, 0.5, -25)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://116845122064768"
	icon.Parent = header

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.6, 0, 0, 30)
	titleLabel.Position = UDim2.new(0, 80, 0, 10)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = White
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 24
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header

	local subtitleLabel = Instance.new("TextLabel")
	subtitleLabel.Size = UDim2.new(0.6, 0, 0, 20)
	subtitleLabel.Position = UDim2.new(0, 80, 0, 35)
	subtitleLabel.BackgroundTransparency = 1
	subtitleLabel.Text = subtitle
	subtitleLabel.TextColor3 = Gray
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.TextSize = 16
	subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subtitleLabel.Parent = header

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 40, 0, 40)
	closeButton.Position = UDim2.new(1, -50, 0.5, -20)
	closeButton.BackgroundColor3 = ExtremelyDarkBlack
	closeButton.Text = "X"
	closeButton.TextColor3 = White
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 20
	closeButton.Parent = header

	closeButton.MouseButton1Click:Connect(function()
		if game:GetService("MarketplaceService"):PromptPurchaseConfirmation(frame) then
			screenGui:Destroy()
		end
	end)

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Size = UDim2.new(0, 40, 0, 40)
	minimizeButton.Position = UDim2.new(1, -100, 0.5, -20)
	minimizeButton.BackgroundColor3 = ExtremelyDarkBlack
	minimizeButton.Text = "-"
	minimizeButton.TextColor3 = White
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 20
	minimizeButton.Parent = header

	local minimized = false
	minimizeButton.MouseButton1Click:Connect(function()
		if minimized then
			frame.Size = UDim2.new(0.7, 0, 0.8, 0)
			frame.Position = UDim2.new(0.15, 0, 0.1, 0)
			minimized = false
		else
			frame.Size = UDim2.new(0, 300, 0, 120)
			frame.Position = UDim2.new(0.5, -150, 0.5, -60)
			minimized = true
		end
		TweenService:Create(frame, createTweenInfo(0.4, Enum.EasingStyle.Quad), {Size = frame.Size, Position = frame.Position}):Play()
	end)

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, -60)
	content.Position = UDim2.new(0, 0, 0, 60)
	content.BackgroundTransparency = 1
	content.Parent = frame

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 250, 1, 0)
	sidebar.BackgroundColor3 = ExtremelyDarkBlack
	sidebar.BorderSizePixel = 0
	sidebar.Parent = content

	local mainContent = Instance.new("Frame")
	mainContent.Size = UDim2.new(1, -250, 1, 0)
	mainContent.Position = UDim2.new(0, 250, 0, 0)
	mainContent.BackgroundTransparency = 1
	mainContent.Parent = content

	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	return {
		Frame = frame,
		Sidebar = sidebar,
		Content = mainContent,
		AddTab = function(self, name, iconId)
			local tab = Instance.new("TextButton")
			tab.Size = UDim2.new(1, 0, 0, 50)
			tab.BackgroundTransparency = 1
			tab.Text = name
			tab.TextColor3 = White
			tab.Font = Enum.Font.Gotham
			tab.TextSize = 18
			tab.TextXAlignment = Enum.TextXAlignment.Left

			local icon = Instance.new("ImageLabel")
			icon.Size = UDim2.new(0, 30, 0, 30)
			icon.Position = UDim2.new(0, 15, 0.5, -15)
			icon.BackgroundTransparency = 1
			icon.Image = iconId or ""
			icon.Parent = tab

			local indicator = Instance.new("Frame")
			indicator.Size = UDim2.new(0, 4, 1, 0)
			indicator.Position = UDim2.new(0, 0, 0, 0)
			indicator.BackgroundColor3 = White
			indicator.Visible = false
			indicator.Parent = tab

			tab.Parent = self.Sidebar

			return tab
		end,
		AddSection = function(self, sectionName)
			local separator = Instance.new("Frame")
			separator.Size = UDim2.new(1, 0, 0, 40)
			separator.BackgroundTransparency = 1
			separator.Parent = self.Content

			local lineLeft = Instance.new("Frame")
			lineLeft.Size = UDim2.new(0.4, -60, 0, 2)
			lineLeft.Position = UDim2.new(0, 0, 0.5, -1)
			lineLeft.BackgroundColor3 = White
			lineLeft.BorderSizePixel = 0
			lineLeft.Parent = separator

			local gradient = Instance.new("UIGradient")
			gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, White),
				ColorSequenceKeypoint.new(0.5, Gray),
				ColorSequenceKeypoint.new(1, ExtremelyDarkBlack)
			}
			gradient.Parent = lineLeft

			local text = Instance.new("TextLabel")
			text.Size = UDim2.new(0, 120, 1, 0)
			text.Position = UDim2.new(0.5, -60, 0, 0)
			text.BackgroundTransparency = 1
			text.Text = sectionName
			text.TextColor3 = White
			text.Font = Enum.Font.GothamBold
			text.TextSize = 18
			text.Parent = separator

			local lineRight = Instance.new("Frame")
			lineRight.Size = UDim2.new(0.4, -60, 0, 2)
			lineRight.Position = UDim2.new(0.6, 0, 0.5, -1)
			lineRight.BackgroundColor3 = White
			lineRight.BorderSizePixel = 0
			lineRight.Parent = separator

			local gradientRight = gradient:Clone()
			gradientRight.Rotation = 180
			gradientRight.Parent = lineRight
		end,
		AddToggle = function(self, name)
			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, -40, 0, 50)
			container.BackgroundTransparency = 1
			container.Parent = self.Content

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.7, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = name
			label.TextColor3 = White
			label.Font = Enum.Font.Gotham
			label.TextSize = 16
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local toggle = Instance.new("Frame")
			toggle.Size = UDim2.new(0, 50, 0, 24)
			toggle.Position = UDim2.new(1, -70, 0.5, -12)
			toggle.BackgroundColor3 = Gray
			toggle.BorderSizePixel = 0
			toggle.Parent = container

			local circle = Instance.new("Frame")
			circle.Size = UDim2.new(0, 20, 0, 20)
			circle.Position = UDim2.new(0, 2, 0.5, -10)
			circle.BackgroundColor3 = White
			circle.BorderSizePixel = 0
			circle.Parent = toggle

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 12)
			corner.Parent = toggle

			local circleCorner = Instance.new("UICorner")
			circleCorner.CornerRadius = UDim.new(0, 10)
			circleCorner.Parent = circle

			local enabled = false
			toggle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					enabled = not enabled
					if enabled then
						TweenService:Create(toggle, createTweenInfo(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = White}):Play()
						TweenService:Create(circle, createTweenInfo(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 28, 0.5, -10)}):Play()
					else
						TweenService:Create(toggle, createTweenInfo(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Gray}):Play()
						TweenService:Create(circle, createTweenInfo(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
					end
				end
			end)

			return container
		end,
		AddDropdown = function(self, name, options, multiple)
			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, -40, 0, 50)
			container.BackgroundTransparency = 1
			container.Parent = self.Content

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.4, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = name
			label.TextColor3 = White
			label.Font = Enum.Font.Gotham
			label.TextSize = 16
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local dropdown = Instance.new("Frame")
			dropdown.Size = UDim2.new(0.6, 0, 0, 40)
			dropdown.Position = UDim2.new(0.4, 0, 0.5, -20)
			dropdown.BackgroundColor3 = Gray
			dropdown.BorderSizePixel = 0
			dropdown.Parent = container

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = dropdown

			local selectedText = Instance.new("TextLabel")
			selectedText.Size = UDim2.new(1, -40, 1, 0)
			selectedText.Position = UDim2.new(0, 10, 0, 0)
			selectedText.BackgroundTransparency = 1
			selectedText.Text = options[1]
			selectedText.TextColor3 = White
			selectedText.Font = Enum.Font.Gotham
			selectedText.TextSize = 16
			selectedText.TextXAlignment = Enum.TextXAlignment.Left
			selectedText.Parent = dropdown

			local icon = Instance.new("ImageLabel")
			icon.Size = UDim2.new(0, 24, 0, 24)
			icon.Position = UDim2.new(1, -34, 0.5, -12)
			icon.BackgroundTransparency = 1
			icon.Image = "rbxassetid://116845122064768"
			icon.Parent = dropdown

			local list = Instance.new("Frame")
			list.Size = UDim2.new(1, 0, 0, #options * 40)
			list.Position = UDim2.new(0, 0, 1, 5)
			list.BackgroundColor3 = ExtremelyDarkBlack
			list.BorderSizePixel = 1
			list.BorderColor3 = Gray
			list.Visible = false
			list.Parent = dropdown

			local layout = Instance.new("UIListLayout")
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout.Parent = list

			local selected = {options[1]}
			for _, opt in ipairs(options) do
				local option = Instance.new("TextButton")
				option.Size = UDim2.new(1, 0, 0, 40)
				option.BackgroundTransparency = 1
				option.Text = opt
				option.TextColor3 = White
				option.Font = Enum.Font.Gotham
				option.TextSize = 16
				option.TextXAlignment = Enum.TextXAlignment.Left
				option.Parent = list

				local indicator = Instance.new("Frame")
				indicator.Size = UDim2.new(0, 4, 1, 0)
				indicator.Position = UDim2.new(0, 0, 0, 0)
				indicator.BackgroundColor3 = White
				indicator.Visible = (opt == selected[1])
				indicator.Parent = option

				option.MouseButton1Click:Connect(function()
					if multiple then
						if table.find(selected, opt) then
							table.remove(selected, table.find(selected, opt))
							indicator.Visible = false
						else
							table.insert(selected, opt)
							indicator.Visible = true
						end
						selectedText.Text = table.concat(selected, ", ")
					else
						selected = {opt}
						selectedText.Text = opt
						indicator.Visible = true
						for _, child in ipairs(list:GetChildren()) do
							if child:IsA("TextButton") and child ~= option then
								child:FindFirstChild("Frame").Visible = false
							end
						end
					end
					TweenService:Create(indicator, createTweenInfo(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 4, 1, 0)}):Play()
				end)
			end

			dropdown.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					list.Visible = not list.Visible
					icon.Image = list.Visible and "rbxassetid://132854725146991" or "rbxassetid://116845122064768"
					TweenService:Create(list, createTweenInfo(0.3, Enum.EasingStyle.Quad), {Size = list.Visible and UDim2.new(1, 0, 0, #options * 40) or UDim2.new(1, 0, 0, 0)}):Play()
				end
			end)

			return container
		end,
		AddButton = function(self, name)
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -40, 0, 50)
			button.BackgroundColor3 = DarkGray
			button.Text = name
			button.TextColor3 = White
			button.Font = Enum.Font.GothamBold
			button.TextSize = 18
			button.BorderSizePixel = 0
			button.Parent = self.Content

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 10)
			corner.Parent = button

			local arrow = Instance.new("ImageLabel")
			arrow.Size = UDim2.new(0, 24, 0, 24)
			arrow.Position = UDim2.new(1, -40, 0.5, -12)
			arrow.BackgroundTransparency = 1
			arrow.Image = "rbxassetid://110294213486252"
			arrow.Parent = button

			button.MouseButton1Down:Connect(function()
				TweenService:Create(button, createTweenInfo(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = White}):Play()
			end)
			button.MouseButton1Up:Connect(function()
				TweenService:Create(button, createTweenInfo(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = DarkGray}):Play()
			end)

			return button
		end,
		AddSlider = function(self, name, min, max)
			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, -40, 0, 70)
			container.BackgroundTransparency = 1
			container.Parent = self.Content

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.4, 0, 0, 30)
			label.BackgroundTransparency = 1
			label.Text = name
			label.TextColor3 = White
			label.Font = Enum.Font.Gotham
			label.TextSize = 16
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local input = Instance.new("TextBox")
			input.Size = UDim2.new(0, 80, 0, 30)
			input.Position = UDim2.new(0, 0, 0, 30)
			input.BackgroundColor3 = DarkGray
			input.TextColor3 = White
			input.Font = Enum.Font.Gotham
			input.TextSize = 16
			input.Text = tostring(min)
			input.Parent = container

			local track = Instance.new("Frame")
			track.Size = UDim2.new(0.6, 0, 0, 6)
			track.Position = UDim2.new(0.4, 0, 0, 40)
			track.BackgroundColor3 = Gray
			track.BorderSizePixel = 0
			track.Parent = container

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = White
			fill.BorderSizePixel = 0
			fill.Parent = track

			local handle = Instance.new("Frame")
			handle.Size = UDim2.new(0, 20, 0, 20)
			handle.Position = UDim2.new(0, -10, 0.5, -10)
			handle.BackgroundColor3 = White
			handle.BorderSizePixel = 0
			handle.Parent = track

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 10)
			corner.Parent = handle

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Size = UDim2.new(0, 60, 0, 30)
			valueLabel.Position = UDim2.new(1, -80, 0, 30)
			valueLabel.BackgroundTransparency = 1
			valueLabel.Text = tostring(min)
			valueLabel.TextColor3 = White
			valueLabel.Font = Enum.Font.Gotham
			valueLabel.TextSize = 16
			valueLabel.Parent = container

			local current = min
			local function update(value)
				current = math.clamp(value, min, max)
				local percent = (current - min) / (max - min)
				TweenService:Create(fill, createTweenInfo(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
				TweenService:Create(handle, createTweenInfo(0.1), {Position = UDim2.new(percent, -10, 0.5, -10)}):Play()
				valueLabel.Text = string.format(max % 1 == 0 and "%.0f" or "%.2f", current)
				input.Text = valueLabel.Text
			end

			input.FocusLost:Connect(function()
				local num = tonumber(input.Text)
				if num then
					update(num)
				end
			end)

			local draggingSlider = false
			handle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = true
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = input.Position.X
					local trackPos = track.AbsolutePosition.X
					local trackSize = track.AbsoluteSize.X
					local percent = math.clamp((pos - trackPos) / trackSize, 0, 1)
					update(min + percent * (max - min))
				end
			end)

			return container
		end,
		AddNotification = function(self, iconId, title, body)
			local notif = Instance.new("Frame")
			notif.Size = UDim2.new(0, 400, 0, 120)
			notif.Position = UDim2.new(1, -420, 1, -140)
			notif.BackgroundColor3 = ExtremelyDarkBlack
			notif.BorderSizePixel = 0
			notif.Parent = screenGui

			local icon = Instance.new("ImageLabel")
			icon.Size = UDim2.new(0, 80, 0, 80)
			icon.Position = UDim2.new(0, 20, 0.5, -40)
			icon.BackgroundTransparency = 1
			icon.Image = iconId
			icon.Parent = notif

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Size = UDim2.new(1, -120, 0, 30)
			titleLabel.Position = UDim2.new(0, 110, 0, 20)
			titleLabel.BackgroundTransparency = 1
			titleLabel.Text = title
			titleLabel.TextColor3 = White
			titleLabel.Font = Enum.Font.GothamBold
			titleLabel.TextSize = 20
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.Parent = notif

			local bodyLabel = Instance.new("TextLabel")
			bodyLabel.Size = UDim2.new(1, -120, 0, 60)
			bodyLabel.Position = UDim2.new(0, 110, 0, 50)
			bodyLabel.BackgroundTransparency = 1
			bodyLabel.Text = body
			bodyLabel.TextColor3 = White
			bodyLabel.Font = Enum.Font.Gotham
			bodyLabel.TextSize = 16
			bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
			bodyLabel.TextWrapped = true
			bodyLabel.Parent = notif

			TweenService:Create(notif, createTweenInfo(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -420, 1, -140)}):Play()
			task.delay(5, function()
				TweenService:Create(notif, createTweenInfo(0.5), {Position = UDim2.new(1, 20, 1, -140)}):Play()
				task.delay(0.5, function() notif:Destroy() end)
			end)
		end
	}
end

return UI
