-- LocalScript
-- Положи в StarterPlayer > StarterPlayerScripts (или StarterGui)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Удаляем старое меню, если есть
local old = playerGui:FindFirstChild("TradeMenuGui")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "TradeMenuGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Главная рамка (чёрный фон, маленькая — влезает на телефон)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 130, 0, 90)
frame.Position = UDim2.new(0.5, -65, 0.5, -45)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 70)
stroke.Thickness = 1
stroke.Parent = frame

-- Заголовок (за него можно перетаскивать меню)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "Trade"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = frame

-- Функция создания кнопки
local function makeButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 26)
	btn.Position = UDim2.new(0, 8, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.AutoButtonColor = true
	btn.Parent = frame

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn

	return btn
end

local freezeBtn = makeButton("Freeze Trade", 24)
local acceptBtn = makeButton("Accept Trade", 55)

-- Состояние заморозки
local frozen = false

freezeBtn.MouseButton1Click:Connect(function()
	frozen = not frozen
	freezeBtn.Text = frozen and "Unfreeze Trade" or "Freeze Trade"
	freezeBtn.BackgroundColor3 = frozen and Color3.fromRGB(0, 90, 160) or Color3.fromRGB(35, 35, 35)

	-- TODO: сюда вставь вызов своего RemoteEvent, например:
	-- game.ReplicatedStorage.TradeRemotes.FreezeTrade:FireServer(frozen)
	print("Freeze Trade:", frozen)
end)

acceptBtn.MouseButton1Click:Connect(function()
	-- TODO: сюда вставь вызов своего RemoteEvent, например:
	-- game.ReplicatedStorage.TradeRemotes.AcceptTrade:FireServer()
	print("Accept Trade pressed")
end)

-- Перетаскивание (работает и мышкой, и пальцем)
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
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

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
