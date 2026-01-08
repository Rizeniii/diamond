local UI = {}

function UI.CreateToggle(name, initialState, callback)
	local toggle = {}
	
	toggle.name = name
	toggle.state = initialState or false
	toggle.callback = callback
	
	local toggleFrame = Instance.new("Frame")
	local background = Instance.new("Frame")
	local circle = Instance.new("Frame")
	local nameLabel = Instance.new("TextLabel")
	
	toggleFrame.Name = "Toggle"
	toggleFrame.BackgroundTransparency = 1
	toggleFrame.Size = UDim2.new(1, 0, 0, 30)
	
	background.Name = "Background"
	background.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	background.BorderSizePixel = 0
	background.Position = UDim2.new(0, 100, 0.5, -10)
	background.Size = UDim2.new(0, 40, 0, 20)
	background.CornerRadius = UDim.new(0.5, 0)
	background.Parent = toggleFrame
	
	circle.Name = "Circle"
	circle.BackgroundColor3 = Color3.new(1, 1, 1)
	circle.BorderSizePixel = 0
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = toggle.state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	circle.CornerRadius = UDim.new(1, 0)
	circle.Parent = background
	
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.Size = UDim2.new(0, 90, 1, 0)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = toggleFrame
	
	local function updateState(newState)
		toggle.state = newState
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = game:GetService("TweenService"):Create(circle, tweenInfo, {
			Position = newState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
		})
		tween:Play()
		background.BackgroundColor3 = newState and Color3.new(1, 1, 1) or Color3.new(0.2, 0.2, 0.2)
		if toggle.callback then
			toggle.callback(newState)
		end
	end
	
	toggleFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateState(not toggle.state)
		end
	end)
	
	toggle.SetState = function(self, state)
		updateState(state)
	end
	
	toggle.GetState = function(self)
		return toggle.state
	end
	
	toggle.GetFrame = function(self)
		return toggleFrame
	end
	
	return toggle
end

function UI.CreateDropdown(name, options, multiSelect, defaultSelection, callback)
	local dropdown = {}
	
	dropdown.name = name
	dropdown.options = options or {}
	dropdown.multiSelect = multiSelect or false
	dropdown.selected = defaultSelection or (multiSelect and {} or nil)
	dropdown.callback = callback
	
	local dropdownFrame = Instance.new("Frame")
	local closedFrame = Instance.new("Frame")
	local nameLabel = Instance.new("TextLabel")
	local selectedLabel = Instance.new("TextLabel")
	local icon = Instance.new("ImageLabel")
	local optionsFrame = Instance.new("ScrollingFrame")
	
	dropdownFrame.Name = "Dropdown"
	dropdownFrame.BackgroundTransparency = 1
	dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
	dropdownFrame.ClipsDescendants = true
	
	closedFrame.Name = "ClosedFrame"
	closedFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	closedFrame.BorderSizePixel = 0
	closedFrame.Size = UDim2.new(1, 0, 0, 30)
	closedFrame.CornerRadius = UDim.new(0, 4)
	closedFrame.Parent = dropdownFrame
	
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.Size = UDim2.new(0, 100, 1, 0)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = closedFrame
	
	selectedLabel.Name = "Selected"
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.Position = UDim2.new(0, 120, 0, 0)
	selectedLabel.Size = UDim2.new(0, 150, 1, 0)
	selectedLabel.Font = Enum.Font.Gotham
	selectedLabel.Text = ""
	selectedLabel.TextColor3 = Color3.new(1, 1, 1)
	selectedLabel.TextSize = 14
	selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
	selectedLabel.Parent = closedFrame
	
	icon.Name = "Icon"
	icon.BackgroundTransparency = 1
	icon.Position = UDim2.new(1, -30, 0.5, -8)
	icon.Size = UDim2.new(0, 16, 0, 16)
	icon.Image = "rbxassetid://116845122064768"
	icon.Parent = closedFrame
	
	optionsFrame.Name = "Options"
	optionsFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	optionsFrame.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
	optionsFrame.Position = UDim2.new(0, 0, 1, 5)
	optionsFrame.Size = UDim2.new(1, 0, 0, 0)
	optionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	optionsFrame.ScrollBarThickness = 2
	optionsFrame.Visible = false
	optionsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	optionsFrame.Parent = dropdownFrame
	
	local function updateSelectionDisplay()
		if dropdown.multiSelect then
			local selectedNames = {}
			for _, option in ipairs(dropdown.selected) do
				table.insert(selectedNames, option)
			end
			selectedLabel.Text = table.concat(selectedNames, ", ")
		else
			selectedLabel.Text = dropdown.selected or ""
		end
	end
	
	local function createOption(optionName)
		local optionFrame = Instance.new("Frame")
		local highlight = Instance.new("Frame")
		local optionText = Instance.new("TextLabel")
		
		optionFrame.Name = "Option"
		optionFrame.BackgroundTransparency = 1
		optionFrame.Size = UDim2.new(1, 0, 0, 30)
		
		highlight.Name = "Highlight"
		highlight.BackgroundColor3 = Color3.new(1, 1, 1)
		highlight.BorderSizePixel = 0
		highlight.Position = UDim2.new(0, 5, 0.5, -10)
		highlight.Size = UDim2.new(0, 3, 0, 20)
		highlight.CornerRadius = UDim.new(0, 2)
		highlight.Visible = false
		highlight.Parent = optionFrame
		
		optionText.Name = "Text"
		optionText.BackgroundTransparency = 1
		optionText.Position = UDim2.new(0, 15, 0, 0)
		optionText.Size = UDim2.new(1, -15, 1, 0)
		optionText.Font = Enum.Font.Gotham
		optionText.Text = optionName
		optionText.TextColor3 = Color3.new(1, 1, 1)
		optionText.TextSize = 14
		optionText.TextXAlignment = Enum.TextXAlignment.Left
		optionText.Parent = optionFrame
		
		local function isSelected()
			if dropdown.multiSelect then
				for _, selected in ipairs(dropdown.selected) do
					if selected == optionName then
						return true
					end
				end
				return false
			else
				return dropdown.selected == optionName
			end
		end
		
		local function setSelected(selected)
			if dropdown.multiSelect then
				if selected then
					table.insert(dropdown.selected, optionName)
				else
					for i, selectedOption in ipairs(dropdown.selected) do
						if selectedOption == optionName then
							table.remove(dropdown.selected, i)
							break
						end
					end
				end
			else
				dropdown.selected = selected and optionName or nil
			end
			
			updateSelectionDisplay()
			
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tween = game:GetService("TweenService"):Create(highlight, tweenInfo, {
				Size = selected and UDim2.new(0, 3, 0, 20) or UDim2.new(0, 0, 0, 20)
			})
			tween:Play()
			highlight.Visible = true
			
			if dropdown.callback then
				dropdown.callback(dropdown.selected)
			end
		end
		
		if isSelected() then
			highlight.Size = UDim2.new(0, 3, 0, 20)
			highlight.Visible = true
		end
		
		optionFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if dropdown.multiSelect then
					setSelected(not isSelected())
				else
					setSelected(true)
				end
			end
		end)
		
		return optionFrame
	end
	
	local function populateOptions()
		for _, child in ipairs(optionsFrame:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		for _, option in ipairs(dropdown.options) do
			local optionFrame = createOption(option)
			optionFrame.Parent = optionsFrame
		end
	end
	
	local isOpen = false
	
	local function toggleOpen()
		isOpen = not isOpen
		
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		
		if isOpen then
			optionsFrame.Visible = true
			icon.Image = "rbxassetid://132854725146991"
			local tween = game:GetService("TweenService"):Create(optionsFrame, tweenInfo, {
				Size = UDim2.new(1, 0, 0, math.min(#dropdown.options * 30, 150))
			})
			tween:Play()
		else
			icon.Image = "rbxassetid://116845122064768"
			local tween = game:GetService("TweenService"):Create(optionsFrame, tweenInfo, {
				Size = UDim2.new(1, 0, 0, 0)
			})
			tween.Completed:Connect(function()
				if not isOpen then
					optionsFrame.Visible = false
				end
			end)
			tween:Play()
		end
	end
	
	closedFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			toggleOpen()
		end
	end)
	
	populateOptions()
	updateSelectionDisplay()
	
	dropdown.SetOptions = function(self, newOptions)
		dropdown.options = newOptions
		populateOptions()
	end
	
	dropdown.SetSelection = function(self, selection)
		if dropdown.multiSelect then
			dropdown.selected = selection or {}
		else
			dropdown.selected = selection
		end
		populateOptions()
		updateSelectionDisplay()
	end
	
	dropdown.GetSelection = function(self)
		return dropdown.selected
	end
	
	dropdown.GetFrame = function(self)
		return dropdownFrame
	end
	
	return dropdown
end

function UI.CreateButton(name, callback)
	local button = {}
	
	button.name = name
	button.callback = callback
	
	local buttonFrame = Instance.new("Frame")
	local background = Instance.new("Frame")
	local nameLabel = Instance.new("TextLabel")
	local arrow = Instance.new("ImageLabel")
	
	buttonFrame.Name = "Button"
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Size = UDim2.new(1, 0, 0, 40)
	
	background.Name = "Background"
	background.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	background.BorderSizePixel = 0
	background.Size = UDim2.new(1, 0, 1, 0)
	background.CornerRadius = UDim.new(0, 4)
	background.Parent = buttonFrame
	
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 15, 0, 0)
	nameLabel.Size = UDim2.new(1, -50, 1, 0)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = background
	
	arrow.Name = "Arrow"
	arrow.BackgroundTransparency = 1
	arrow.Position = UDim2.new(1, -30, 0.5, -8)
	arrow.Size = UDim2.new(0, 16, 0, 16)
	arrow.Image = "rbxassetid://110294213486252"
	arrow.Parent = background
	
	local function animateClick()
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = game:GetService("TweenService"):Create(background, tweenInfo, {
			BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
		})
		tween:Play()
		
		tween.Completed:Connect(function()
			local tweenBack = game:GetService("TweenService"):Create(background, tweenInfo, {
				BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			})
			tweenBack:Play()
		end)
	end
	
	buttonFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			animateClick()
			if button.callback then
				button.callback()
			end
		end
	end)
	
	button.GetFrame = function(self)
		return buttonFrame
	end
	
	return button
end

function UI.CreateSlider(name, minValue, maxValue, defaultValue, callback)
	local slider = {}
	
	slider.name = name
	slider.min = minValue or 0
	slider.max = maxValue or 100
	slider.value = defaultValue or slider.min
	slider.callback = callback
	
	local sliderFrame = Instance.new("Frame")
	local nameLabel = Instance.new("TextLabel")
	local inputBox = Instance.new("TextBox")
	local track = Instance.new("Frame")
	local fill = Instance.new("Frame")
	local handle = Instance.new("Frame")
	local valueLabel = Instance.new("TextLabel")
	
	sliderFrame.Name = "Slider"
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Size = UDim2.new(1, 0, 0, 50)
	
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.Size = UDim2.new(0, 100, 0, 20)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = sliderFrame
	
	inputBox.Name = "Input"
	inputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	inputBox.BorderSizePixel = 0
	inputBox.Position = UDim2.new(0, 110, 0, 0)
	inputBox.Size = UDim2.new(0, 60, 0, 20)
	inputBox.Font = Enum.Font.Gotham
	inputBox.Text = tostring(slider.value)
	inputBox.TextColor3 = Color3.new(1, 1, 1)
	inputBox.TextSize = 14
	inputBox.CornerRadius = UDim.new(0, 4)
	inputBox.Parent = sliderFrame
	
	track.Name = "Track"
	track.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	track.BorderSizePixel = 0
	track.Position = UDim2.new(0, 0, 0, 30)
	track.Size = UDim2.new(1, 0, 0, 4)
	track.CornerRadius = UDim.new(0, 2)
	track.Parent = sliderFrame
	
	fill.Name = "Fill"
	fill.BackgroundColor3 = Color3.new(1, 1, 1)
	fill.BorderSizePixel = 0
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.CornerRadius = UDim.new(0, 2)
	fill.Parent = track
	
	handle.Name = "Handle"
	handle.BackgroundColor3 = Color3.new(1, 1, 1)
	handle.BorderSizePixel = 0
	handle.Position = UDim2.new(0, -8, 0.5, -8)
	handle.Size = UDim2.new(0, 16, 0, 16)
	handle.CornerRadius = UDim.new(1, 0)
	handle.Parent = track
	
	valueLabel.Name = "Value"
	valueLabel.BackgroundTransparency = 1
	valueLabel.Position = UDim2.new(1, 10, 0, 30)
	valueLabel.Size = UDim2.new(0, 50, 0, 20)
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.Text = tostring(slider.value)
	valueLabel.TextColor3 = Color3.new(1, 1, 1)
	valueLabel.TextSize = 14
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.Parent = sliderFrame
	
	local function setValue(newValue)
		local clampedValue = math.clamp(newValue, slider.min, slider.max)
		slider.value = clampedValue
		
		local percentage = (clampedValue - slider.min) / (slider.max - slider.min)
		local trackWidth = track.AbsoluteSize.X
		local fillWidth = percentage * trackWidth
		local handlePosition = percentage * trackWidth
		
		fill.Size = UDim2.new(0, fillWidth, 1, 0)
		handle.Position = UDim2.new(0, handlePosition - 8, 0.5, -8)
		
		if math.floor(slider.value) == slider.value then
			valueLabel.Text = tostring(math.floor(slider.value))
			inputBox.Text = tostring(math.floor(slider.value))
		else
			valueLabel.Text = string.format("%.2f", slider.value)
			inputBox.Text = string.format("%.2f", slider.value)
		end
		
		if slider.callback then
			slider.callback(slider.value)
		end
	end
	
	local isDragging = false
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
		end
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = game:GetService("UserInputService"):GetMouseLocation()
			local trackPos = track.AbsolutePosition
			local trackWidth = track.AbsoluteSize.X
			
			local relativeX = math.clamp(mousePos.X - trackPos.X, 0, trackWidth)
			local percentage = relativeX / trackWidth
			local newValue = slider.min + (percentage * (slider.max - slider.min))
			
			setValue(newValue)
		end
	end)
	
	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = game:GetService("UserInputService"):GetMouseLocation()
			local trackPos = track.AbsolutePosition
			local trackWidth = track.AbsoluteSize.X
			
			local relativeX = math.clamp(mousePos.X - trackPos.X, 0, trackWidth)
			local percentage = relativeX / trackWidth
			local newValue = slider.min + (percentage * (slider.max - slider.min))
			
			setValue(newValue)
			isDragging = true
		end
	end)
	
	inputBox.FocusLost:Connect(function()
		local num = tonumber(inputBox.Text)
		if num then
			setValue(num)
		else
			inputBox.Text = tostring(slider.value)
		end
	end)
	
	setValue(slider.value)
	
	slider.SetValue = function(self, value)
		setValue(value)
	end
	
	slider.GetValue = function(self)
		return slider.value
	end
	
	slider.GetFrame = function(self)
		return sliderFrame
	end
	
	return slider
end

function UI.CreateTab(name, icon, callback)
	local tab = {}
	
	tab.name = name
	tab.icon = icon
	tab.callback = callback
	
	local tabFrame = Instance.new("Frame")
	local highlight = Instance.new("Frame")
	local iconLabel = Instance.new("ImageLabel")
	local nameLabel = Instance.new("TextLabel")
	
	tabFrame.Name = "Tab"
	tabFrame.BackgroundTransparency = 1
	tabFrame.Size = UDim2.new(1, 0, 0, 40)
	
	highlight.Name = "Highlight"
	highlight.BackgroundColor3 = Color3.new(1, 1, 1)
	highlight.BorderSizePixel = 0
	highlight.Position = UDim2.new(0, 5, 0.5, -15)
	highlight.Size = UDim2.new(0, 3, 0, 30)
	highlight.CornerRadius = UDim.new(0, 2)
	highlight.Visible = false
	highlight.Parent = tabFrame
	
	iconLabel.Name = "Icon"
	iconLabel.BackgroundTransparency = 1
	iconLabel.Position = UDim2.new(0, 15, 0.5, -12)
	iconLabel.Size = UDim2.new(0, 24, 0, 24)
	iconLabel.Image = icon
	iconLabel.Parent = tabFrame
	
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 50, 0, 0)
	nameLabel.Size = UDim2.new(1, -50, 1, 0)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = tabFrame
	
	local function setSelected(selected)
		highlight.Visible = selected
		tabFrame.BackgroundColor3 = selected and Color3.new(0.1, 0.1, 0.1) or Color3.new(0, 0, 0)
		tabFrame.BackgroundTransparency = selected and 0 or 1
	end
	
	tabFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if tab.callback then
				tab.callback()
			end
		end
	end)
	
	tab.SetSelected = function(self, selected)
		setSelected(selected)
	end
	
	tab.GetFrame = function(self)
		return tabFrame
	end
	
	return tab
end

function UI.CreateSection(name)
	local sectionFrame = Instance.new("Frame")
	local leftLine = Instance.new("Frame")
	local rightLine = Instance.new("Frame")
	local nameLabel = Instance.new("TextLabel")
	
	sectionFrame.Name = "Section"
	sectionFrame.BackgroundTransparency = 1
	sectionFrame.Size = UDim2.new(1, 0, 0, 40)
	
	leftLine.Name = "LeftLine"
	leftLine.BackgroundColor3 = Color3.new(1, 1, 1)
	leftLine.BorderSizePixel = 0
	leftLine.Position = UDim2.new(0, 0, 0.5, -1)
	leftLine.Size = UDim2.new(0.5, -60, 0, 2)
	
	local leftGradient = Instance.new("UIGradient")
	leftGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
	})
	leftGradient.Parent = leftLine
	
	leftLine.Parent = sectionFrame
	
	rightLine.Name = "RightLine"
	rightLine.BackgroundColor3 = Color3.new(0, 0, 0)
	rightLine.BorderSizePixel = 0
	rightLine.Position = UDim2.new(0.5, 60, 0.5, -1)
	rightLine.Size = UDim2.new(0.5, -60, 0, 2)
	
	local rightGradient = Instance.new("UIGradient")
	rightGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.5, 0.5)),
		ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
	})
	rightGradient.Parent = rightLine
	
	rightLine.Parent = sectionFrame
	
	nameLabel.Name = "Name"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0.5, -50, 0, 0)
	nameLabel.Size = UDim2.new(0, 100, 1, 0)
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = "= " .. name .. " ="
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 14
	nameLabel.Parent = sectionFrame
	
	return sectionFrame
end

function UI.CreateNotification(name, icon, title, body, duration)
	duration = duration or 5
	
	local notification = Instance.new("Frame")
	local background = Instance.new("Frame")
	local iconLabel = Instance.new("ImageLabel")
	local titleLabel = Instance.new("TextLabel")
	local bodyLabel = Instance.new("TextLabel")
	
	notification.Name = "Notification"
	notification.BackgroundTransparency = 1
	notification.Position = UDim2.new(1, -320, 1, -150)
	notification.Size = UDim2.new(0, 300, 0, 100)
	notification.AnchorPoint = Vector2.new(1, 1)
	
	background.Name = "Background"
	background.BackgroundColor3 = Color3.new(0, 0, 0)
	background.BorderColor3 = Color3.new(0.2, 0.2, 0.2)
	background.Size = UDim2.new(1, 0, 1, 0)
	background.CornerRadius = UDim.new(0, 8)
	background.Parent = notification
	
	iconLabel.Name = "Icon"
	iconLabel.BackgroundTransparency = 1
	iconLabel.Position = UDim2.new(0, 15, 0, 15)
	iconLabel.Size = UDim2.new(0, 50, 0, 50)
	iconLabel.Image = icon
	iconLabel.Parent = background
	
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 80, 0, 15)
	titleLabel.Size = UDim2.new(1, -95, 0, 25)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = background
	
	bodyLabel.Name = "Body"
	bodyLabel.BackgroundTransparency = 1
	bodyLabel.Position = UDim2.new(0, 80, 0, 45)
	bodyLabel.Size = UDim2.new(1, -95, 0, 40)
	bodyLabel.Font = Enum.Font.Gotham
	bodyLabel.Text = body
	bodyLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	bodyLabel.TextSize = 14
	bodyLabel.TextWrapped = true
	bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
	bodyLabel.Parent = background
	
	notification.Parent = game:GetService("CoreGui")
	
	notification:TweenPosition(UDim2.new(1, -320, 1, -150), "Out", "Quad", 0.3, true)
	
	task.delay(duration, function()
		notification:TweenPosition(UDim2.new(1, 320, 1, -150), "Out", "Quad", 0.3, true)
		task.wait(0.3)
		notification:Destroy()
	end)
	
	return notification
end

function UI.CreateWindow(title, subtitle)
	local window = {}
	
	local screenGui = Instance.new("ScreenGui")
	local mainFrame = Instance.new("Frame")
	local header = Instance.new("Frame")
	local scriptIcon = Instance.new("ImageLabel")
	local titleLabel = Instance.new("TextLabel")
	local subtitleLabel = Instance.new("TextLabel")
	local closeButton = Instance.new("TextButton")
	local minimizeButton = Instance.new("TextButton")
	local contentFrame = Instance.new("ScrollingFrame")
	local contentLayout = Instance.new("UIListLayout")
	
	screenGui.Name = "UIWindow"
	screenGui.ResetOnSpawn = false
	
	mainFrame.Name = "MainFrame"
	mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
	mainFrame.Size = UDim2.new(0, 500, 0, 400)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.CornerRadius = UDim.new(0, 8)
	mainFrame.Parent = screenGui
	
	header.Name = "Header"
	header.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, 60)
	header.CornerRadius = UDim.new(0, 8)
	header.Parent = mainFrame
	
	scriptIcon.Name = "ScriptIcon"
	scriptIcon.BackgroundTransparency = 1
	scriptIcon.Position = UDim2.new(0, 15, 0, 10)
	scriptIcon.Size = UDim2.new(0, 40, 0, 40)
	scriptIcon.Image = "rbxassetid://0"
	scriptIcon.Parent = header
	
	titleLabel.Name = "Title"
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 70, 0, 10)
	titleLabel.Size = UDim2.new(0, 300, 0, 25)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title or "UI Window"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 20
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header
	
	subtitleLabel.Name = "Subtitle"
	subtitleLabel.BackgroundTransparency = 1
	subtitleLabel.Position = UDim2.new(0, 70, 0, 35)
	subtitleLabel.Size = UDim2.new(0, 300, 0, 15)
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.Text = subtitle or ""
	subtitleLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	subtitleLabel.TextSize = 12
	subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subtitleLabel.Parent = header
	
	closeButton.Name = "CloseButton"
	closeButton.BackgroundTransparency = 1
	closeButton.Position = UDim2.new(1, -40, 0.5, -10)
	closeButton.Size = UDim2.new(0, 20, 0, 20)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.TextSize = 16
	closeButton.Parent = header
	
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Position = UDim2.new(1, -70, 0.5, -10)
	minimizeButton.Size = UDim2.new(0, 20, 0, 20)
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.Text = "-"
	minimizeButton.TextColor3 = Color3.new(1, 1, 1)
	minimizeButton.TextSize = 16
	minimizeButton.Parent = header
	
	contentFrame.Name = "Content"
	contentFrame.BackgroundTransparency = 1
	contentFrame.Position = UDim2.new(0, 15, 0, 70)
	contentFrame.Size = UDim2.new(1, -30, 1, -85)
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.ScrollBarThickness = 4
	contentFrame.ScrollBarImageColor3 = Color3.new(0.2, 0.2, 0.2)
	contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentFrame.Parent = mainFrame
	
	contentLayout.Name = "ContentLayout"
	contentLayout.Padding = UDim.new(0, 10)
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Parent = contentFrame
	
	local isMinimized = false
	local isDragging = false
	local dragStart, mainFrameStart
	
	local minimizedFrame = Instance.new("Frame")
	minimizedFrame.Name = "MinimizedFrame"
	minimizedFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	minimizedFrame.BorderSizePixel = 0
	minimizedFrame.Size = UDim2.new(0, 400, 0, 60)
	minimizedFrame.Position = UDim2.new(0.5, -200, 0.5, -30)
	minimizedFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	minimizedFrame.CornerRadius = UDim.new(0, 8)
	minimizedFrame.Visible = false
	minimizedFrame.Parent = screenGui
	
	local minimizedIcon = Instance.new("ImageLabel")
	minimizedIcon.Name = "Icon"
	minimizedIcon.BackgroundTransparency = 1
	minimizedIcon.Position = UDim2.new(0, 15, 0, 10)
	minimizedIcon.Size = UDim2.new(0, 40, 0, 40)
	minimizedIcon.Image = "rbxassetid://0"
	minimizedIcon.Parent = minimizedFrame
	
	local minimizedTitle = Instance.new("TextLabel")
	minimizedTitle.Name = "Title"
	minimizedTitle.BackgroundTransparency = 1
	minimizedTitle.Position = UDim2.new(0, 70, 0, 10)
	minimizedTitle.Size = UDim2.new(0, 200, 0, 25)
	minimizedTitle.Font = Enum.Font.GothamBold
	minimizedTitle.Text = title or "UI Window"
	minimizedTitle.TextColor3 = Color3.new(1, 1, 1)
	minimizedTitle.TextSize = 16
	minimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
	minimizedTitle.Parent = minimizedFrame
	
	local minimizedSubtitle = Instance.new("TextLabel")
	minimizedSubtitle.Name = "Subtitle"
	minimizedSubtitle.BackgroundTransparency = 1
	minimizedSubtitle.Position = UDim2.new(0, 70, 0, 35)
	minimizedSubtitle.Size = UDim2.new(0, 200, 0, 15)
	minimizedSubtitle.Font = Enum.Font.Gotham
	minimizedSubtitle.Text = subtitle or ""
	minimizedSubtitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	minimizedSubtitle.TextSize = 12
	minimizedSubtitle.TextXAlignment = Enum.TextXAlignment.Left
	minimizedSubtitle.Parent = minimizedFrame
	
	local restoreButton = Instance.new("TextButton")
	restoreButton.Name = "RestoreButton"
	restoreButton.BackgroundTransparency = 1
	restoreButton.Position = UDim2.new(1, -40, 0.5, -10)
	restoreButton.Size = UDim2.new(0, 20, 0, 20)
	restoreButton.Font = Enum.Font.GothamBold
	restoreButton.Text = "+"
	restoreButton.TextColor3 = Color3.new(1, 1, 1)
	restoreButton.TextSize = 16
	restoreButton.Parent = minimizedFrame
	
	local function toggleMinimize()
		isMinimized = not isMinimized
		
		if isMinimized then
			mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
			mainFrame.Visible = false
			minimizedFrame.Visible = true
			minimizedFrame:TweenSize(UDim2.new(0, 400, 0, 60), "Out", "Quad", 0.3, true)
		else
			minimizedFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
			task.wait(0.3)
			minimizedFrame.Visible = false
			mainFrame.Visible = true
			mainFrame:TweenSize(UDim2.new(0, 500, 0, 400), "Out", "Quad", 0.3, true)
		end
	end
	
	minimizeButton.MouseButton1Click:Connect(toggleMinimize)
	restoreButton.MouseButton1Click:Connect(toggleMinimize)
	
	closeButton.MouseButton1Click:Connect(function()
		local result = game:GetService("TextChatService").TextChannels.RBXGeneral:DisplaySystemMessage("Are you sure you want to close the window?")
		if result then
			screenGui:Destroy()
		end
	end)
	
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
			dragStart = input.Position
			mainFrameStart = mainFrame.Position
		end
	end)
	
	header.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				mainFrameStart.X.Scale,
				mainFrameStart.X.Offset + delta.X,
				mainFrameStart.Y.Scale,
				mainFrameStart.Y.Offset + delta.Y
			)
		end
	end)
	
	local isResizing = false
	local resizeStart, mainFrameStartSize
	
	local resizeHandle = Instance.new("Frame")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.Position = UDim2.new(1, -20, 1, -20)
	resizeHandle.Size = UDim2.new(0, 20, 0, 20)
	resizeHandle.Parent = mainFrame
	
	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isResizing = true
			resizeStart = input.Position
			mainFrameStartSize = mainFrame.Size
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - resizeStart
			local newSize = UDim2.new(
				mainFrameStartSize.X.Scale,
				mainFrameStartSize.X.Offset + delta.X,
				mainFrameStartSize.Y.Scale,
				mainFrameStartSize.Y.Offset + delta.Y
			)
			
			newSize = UDim2.new(
				newSize.X.Scale,
				math.max(300, newSize.X.Offset),
				newSize.Y.Scale,
				math.max(200, newSize.Y.Offset)
			)
			
			mainFrame.Size = newSize
		end
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isResizing = false
		end
	end)
	
	window.AddComponent = function(self, component)
		local frame = component:GetFrame()
		frame.Parent = contentFrame
	end
	
	window.Show = function(self)
		screenGui.Parent = game:GetService("CoreGui")
	end
	
	window.Hide = function(self)
		screenGui.Parent = nil
	end
	
	window.Destroy = function(self)
		screenGui:Destroy()
	end
	
	return window
end

return UI
