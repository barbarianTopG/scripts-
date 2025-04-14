
-- MoonLight [Admin]
-- Telegram: t.me/henyscripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создание нового GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MoonLightAdmin"

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Font = Enum.Font.GothamBold
Title.Text = "MoonLight [Admin]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24

local CopyTelegramButton = Instance.new("TextButton")
CopyTelegramButton.Name = "CopyTelegramButton"
CopyTelegramButton.Parent = MainFrame
CopyTelegramButton.Position = UDim2.new(0.25, 0, 0.85, 0)
CopyTelegramButton.Size = UDim2.new(0.5, 0, 0.1, 0)
CopyTelegramButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CopyTelegramButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyTelegramButton.Font = Enum.Font.Gotham
CopyTelegramButton.TextSize = 18
CopyTelegramButton.Text = "Copy Telegram"

CopyTelegramButton.MouseButton1Click:Connect(function()
    setclipboard("t.me/henyscripts")
end)

-- Пример команды
local CommandBox = Instance.new("TextBox")
CommandBox.Name = "CommandBox"
CommandBox.Parent = MainFrame
CommandBox.Position = UDim2.new(0.05, 0, 0.2, 0)
CommandBox.Size = UDim2.new(0.9, 0, 0.1, 0)
CommandBox.PlaceholderText = "Enter command (e.g. fly, noclip)..."
CommandBox.Font = Enum.Font.Code
CommandBox.TextColor3 = Color3.fromRGB(200, 200, 200)
CommandBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CommandBox.TextSize = 16

CommandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local cmd = CommandBox.Text:lower()
        if cmd == "fly" then
            print("Fly command triggered")
            -- Здесь добавить реализацию fly
        elseif cmd == "noclip" then
            print("Noclip command triggered")
            -- Здесь добавить реализацию noclip
        else
            warn("Unknown command:", cmd)
        end
        CommandBox.Text = ""
    end
end)
