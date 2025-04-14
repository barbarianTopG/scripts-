-- MoonLight [Admin]
-- Telegram: t.me/henyscripts

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MoonLightAdmin"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 320)
frame.Position = UDim2.new(0.5, -225, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 16)

-- Gradient background
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(60, 60, 90)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 50))
}
gradient.Rotation = 45

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "MoonLight [Admin]"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 28

-- Telegram button
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.6, 0, 0.12, 0)
btn.Position = UDim2.new(0.2, 0, 0.8, 0)
btn.Text = "Copy Telegram"
btn.BackgroundColor3 = Color3.fromRGB(80, 80, 160)
btn.Font = Enum.Font.Gotham
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 18

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 12)

btn.MouseEnter:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 200)}):Play()
end)
btn.MouseLeave:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 160)}):Play()
end)
btn.MouseButton1Click:Connect(function()
	setclipboard("t.me/henyscripts")
end)

-- Command input
local input = Instance.new("TextBox", frame)
input.PlaceholderText = "Enter command..."
input.Size = UDim2.new(0.9, 0, 0.12, 0)
input.Position = UDim2.new(0.05, 0, 0.25, 0)
input.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.Font = Enum.Font.Code
input.TextSize = 16
local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0, 10)

input.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local command = input.Text:lower()
		if command == "fly" then
			print("Fly activated") -- Add real fly logic
		elseif command == "noclip" then
			print("Noclip activated") -- Add real noclip logic
		else
			warn("Unknown command:", command)
		end
		input.Text = ""
	end
end)

-- Show GUI animation
TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, -225, 0.5, -160)
}):Play()
