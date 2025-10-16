if getgenv().moonlight then
	warn("MoonLight Hub: Already executed!")
	return
end;
getgenv().moonlight = true;
if not game:IsLoaded() then
	game.Loaded:Wait()
end;
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")
local MarketplaceService = game:GetService("MarketplaceService")
local localPlayer = Players.LocalPlayer;
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local playerGui = localPlayer:WaitForChild("PlayerGui")
local fishingZones = Workspace.zones:WaitForChild("fishing")
local teleportSpots = Workspace.world.spawns:WaitForChild("TpSpots")
local npcsFolder = Workspace.world:WaitForChild("npcs")
local autoCastMode = "Legit"
local autoShakeMode = "Navigation"
local autoReelMode = "Legit"
local selectedWalkOnWaterZone = "Ocean"
local isAutoCastEnabled = false;
local isAutoShakeEnabled = false;
local isAutoReelEnabled = false;
local isCharacterFrozen = false;
local isNoclipEnabled = false;
local isAutoAcceptTradeEnabled = false;
local shakeConnection, reelConnection, dayOnlyConnection, gpsConnection, noclipConnection = nil;
local teleportLocations = {}
for _, spot in pairs(teleportSpots:GetChildren()) do
	if not table.find(teleportLocations, spot.Name) then
		table.insert(teleportLocations, spot.Name)
	end
end;
if UserInputService.TouchEnabled then
	local mobileButtonGui = Instance.new("ScreenGui", game.CoreGui)
	mobileButtonGui.Name = "MoonlightMobileButton"
	local mainFrame = Instance.new("Frame", mobileButtonGui)
	mainFrame.AnchorPoint = Vector2.new(1, 0)
	mainFrame.BackgroundTransparency = 0.8;
	mainFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	mainFrame.Position = UDim2.new(1, -60, 0, 10)
	mainFrame.Size = UDim2.new(0, 45, 0, 45)
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(1, 0)
	local textButton = Instance.new("TextButton", mainFrame)
	textButton.BackgroundTransparency = 1;
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.Text = "Open"
	textButton.TextColor3 = Color3.fromRGB(220, 125, 255)
	textButton.TextSize = 20;
	textButton.MouseButton1Click:Connect(function()
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
	end)
end;
local productName = MarketplaceService:GetProductInfo(16732694052).Name;
local Window = Fluent:CreateWindow({
	Title = productName .. " | MoonLight",
	SubTitle = "by Heny",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Theme = "Aqua",
	MinimizeKey = Enum.KeyCode.RightControl
})
local Tabs = {
	Home = Window:AddTab({
		Title = "Home",
		Icon = "home"
	}),
	Main = Window:AddTab({
		Title = "Main",
		Icon = "list"
	}),
	Items = Window:AddTab({
		Title = "Items",
		Icon = "box"
	}),
	Teleports = Window:AddTab({
		Title = "Teleports",
		Icon = "map-pin"
	}),
	Misc = Window:AddTab({
		Title = "Misc",
		Icon = "file-text"
	}),
	Trade = Window:AddTab({
		Title = "Trade",
		Icon = "gift"
	})
}
local Options = Fluent.Options;
local function showNotification(content)
	Fluent:Notify({
		Title = "MoonLight Hub",
		Content = content,
		Duration = 5
	})
end;
localPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)
task.spawn(function()
	while task.wait(10) do
		ReplicatedStorage.events.afk:FireServer(false)
	end
end)
local function handleAutoCast()
	if not character then
		return
	end;
	local currentTool = character:FindFirstChildOfClass("Tool")
	if not currentTool or currentTool:FindFirstChild("bobber") then
		return
	end;
	if autoCastMode == "Legit" then
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, localPlayer, 0)
		local connection;
		connection = humanoidRootPart.ChildAdded:Connect(function(child)
			if child.Name == "power" and child:FindFirstChild("powerbar", true) then
				child.powerbar.bar:GetPropertyChangedSignal("Size"):Connect(function()
					if child.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
						VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, localPlayer, 0)
						if connection then
							connection:Disconnect()
						end
					end
				end)
			end
		end)
	elseif autoCastMode == "Blatant" then
		if currentTool and currentTool:FindFirstChild("values") and currentTool.Name:find("Rod") then
			task.wait(0.5)
			currentTool.events.cast:FireServer(math.random(90, 99))
		end
	end
end;
local function handleAutoShake()
	local button = playerGui:FindFirstChild("shakeui", true) and playerGui.shakeui.safezone:FindFirstChild("button")
	if not button then
		return
	end;
	if autoShakeMode == "Navigation" then
		GuiService.SelectedObject = button;
		task.wait(0.1)
		if GuiService.SelectedObject == button then
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		end;
		task.wait(0.1)
		GuiService.SelectedObject = nil
	elseif autoShakeMode == "Mouse" then
		local pos, size = button.AbsolutePosition, button.AbsoluteSize;
		local center = pos + (size / 2)
		VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, true, localPlayer, 0)
		VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, false, localPlayer, 0)
	end
end;
local function startAutoShake()
	if shakeConnection or not isAutoShakeEnabled then
		return
	end;
	shakeConnection = RunService.RenderStepped:Connect(handleAutoShake)
end;
local function stopAutoShake()
	if shakeConnection then
		shakeConnection:Disconnect()
		shakeConnection = nil
	end
end;
local function handleLegitReel()
	local bar = playerGui:FindFirstChild("reel", true) and playerGui.reel:FindFirstChild("bar")
	if not bar then
		return
	end;
	local playerBar, fish = bar:FindFirstChild("playerbar"), bar:FindFirstChild("fish")
	if playerBar and fish then
		playerBar.Position = fish.Position
	end
end;
local function startAutoReel()
	if not isAutoReelEnabled then
		return
	end;
	local playerBar = playerGui:FindFirstChild("reel", true) and playerGui.reel.bar:FindFirstChild("playerbar")
	if not playerBar then
		return
	end;
	if autoReelMode == "Legit" then
		if reelConnection then
			return
		end;
		playerBar.Position = UDim2.new(0, 0, -35, 0)
		task.wait(2)
		reelConnection = RunService.RenderStepped:Connect(handleLegitReel)
	elseif autoReelMode == "Blatant" then
		playerBar:GetPropertyChangedSignal("Position"):Wait()
		ReplicatedStorage.events.reelfinished:FireServer(100, false)
	end
end;
local function stopAutoReel()
	if reelConnection then
		reelConnection:Disconnect()
		reelConnection = nil
	end
end;
local function sellHandItem()
	local originalCFrame = humanoidRootPart.CFrame;
	humanoidRootPart.CFrame = CFrame.new(464, 151, 232)
	task.wait(0.5)
	npcsFolder["Marc Merchant"].merchant.sell:InvokeServer()
	task.wait(1)
	humanoidRootPart.CFrame = originalCFrame
end;
local function sellAllItems()
	local originalCFrame = humanoidRootPart.CFrame;
	humanoidRootPart.CFrame = CFrame.new(464, 151, 232)
	task.wait(0.5)
	npcsFolder["Marc Merchant"].merchant.sellall:InvokeServer()
	task.wait(1)
	humanoidRootPart.CFrame = originalCFrame
end;
Tabs.Home:AddButton({
	Title = "Copy Telegram Link",
	Description = "Join our main community!",
	Callback = function()
		setclipboard("https://t.me/henyscripts")
	end
})
local mainSection = Tabs.Main:AddSection("Auto Fishing")
mainSection:AddToggle("autoCast", {
	Title = "Auto Cast",
	Default = false
}):OnChanged(function()
	isAutoCastEnabled = Options.autoCast.Value;
	if isAutoCastEnabled then
		local rodName = ReplicatedStorage.playerstats[localPlayer.Name].Stats.rod.Value;
		if localPlayer.Backpack:FindFirstChild(rodName) then
			character.Humanoid:EquipTool(localPlayer.Backpack:FindFirstChild(rodName))
		end;
		task.wait(1)
		handleAutoCast()
	end
end)
mainSection:AddToggle("autoShake", {
	Title = "Auto Shake",
	Default = false
}):OnChanged(function()
	isAutoShakeEnabled = Options.autoShake.Value;
	if isAutoShakeEnabled then
		startAutoShake()
	else
		stopAutoShake()
	end
end)
mainSection:AddToggle("autoReel", {
	Title = "Auto Reel",
	Default = false
}):OnChanged(function()
	isAutoReelEnabled = Options.autoReel.Value;
	if isAutoReelEnabled then
		startAutoReel()
	else
		stopAutoReel()
	end
end)
mainSection:AddToggle("freezeCharacter", {
	Title = "Freeze Character",
	Default = false
}):OnChanged(function()
	isCharacterFrozen = Options.freezeCharacter.Value;
	local originalCFrame = humanoidRootPart.CFrame;
	task.spawn(function()
		while isCharacterFrozen and humanoidRootPart do
			humanoidRootPart.CFrame = originalCFrame;
			task.wait()
		end
	end)
end)
local modeSection = Tabs.Main:AddSection("Fishing Modes")
modeSection:AddDropdown("autoCastMode", {
	Title = "Auto Cast Mode",
	Values = {
		"Legit",
		"Blatant"
	},
	Default = autoCastMode
}):OnChanged(function(v)
	autoCastMode = v
end)
modeSection:AddDropdown("autoShakeMode", {
	Title = "Auto Shake Mode",
	Values = {
		"Navigation",
		"Mouse"
	},
	Default = autoShakeMode
}):OnChanged(function(v)
	autoShakeMode = v
end)
modeSection:AddDropdown("autoReelMode", {
	Title = "Auto Reel Mode",
	Values = {
		"Legit",
		"Blatant"
	},
	Default = autoReelMode
}):OnChanged(function(v)
	autoReelMode = v
end)
local sellSection = Tabs.Items:AddSection("Sell Items")
sellSection:AddButton({
	Title = "Sell Hand Item",
	Callback = sellHandItem
})
sellSection:AddButton({
	Title = "Sell All Items",
	Callback = sellAllItems
})
local treasureSection = Tabs.Items:AddSection("Treasure")
treasureSection:AddButton({
	Title = "Teleport to Jack Marrow",
	Callback = function()
		humanoidRootPart.CFrame = CFrame.new(-2824.36, 214.31, 1518.13)
	end
})
treasureSection:AddButton({
	Title = "Repair Map",
	Callback = function()
		if localPlayer.Backpack:FindFirstChild("Treasure Map") then
			character.Humanoid:EquipTool(localPlayer.Backpack["Treasure Map"])
			npcsFolder["Jack Marrow"].treasure.repairmap:InvokeServer()
		end
	end
})
treasureSection:AddButton({
	Title = "Collect Treasure",
	Callback = function()
		for _, p in pairs(Workspace:GetDescendants()) do
			if p:IsA("ProximityPrompt") then
				p.HoldDuration = 0
			end
		end;
		for _, p in pairs(Workspace.world.chests:GetDescendants()) do
			if p:IsA("Part") and p:FindFirstChild("ChestSetup") then
				humanoidRootPart.CFrame = p.CFrame;
				for _, pr in pairs(p:GetDescendants()) do
					if pr.Name == "ProximityPrompt" then
						fireproximityprompt(pr)
					end
				end;
				task.wait(1)
			end
		end
	end
})
local teleportSection = Tabs.Teleports:AddSection("Select Teleport")
local islandDropdown = teleportSection:AddDropdown("islandTp", {
	Title = "Area Teleport",
	Values = teleportLocations,
	Default = nil
})
islandDropdown:OnChanged(function(value)
	if value and humanoidRootPart and teleportSpots:FindFirstChild(value) then
		humanoidRootPart.CFrame = teleportSpots[value].CFrame + Vector3.new(0, 5, 0)
		islandDropdown:SetValue(nil)
	end
end)
local charSection = Tabs.Misc:AddSection("Character")
charSection:AddToggle("noclip", {
	Title = "Noclip",
	Default = false
}):OnChanged(function()
	isNoclipEnabled = Options.noclip.Value
end)
charSection:AddSlider("walkSpeed", {
	Title = "Walk Speed",
	Min = 16,
	Max = 200,
	Default = 16,
	Rounding = 1
}):OnChanged(function(v)
	if character.Humanoid then
		character.Humanoid.WalkSpeed = v
	end
end)
charSection:AddSlider("jumpHeight", {
	Title = "Jump Height",
	Min = 50,
	Max = 200,
	Default = 50,
	Rounding = 1
}):OnChanged(function(v)
	if character.Humanoid then
		character.Humanoid.JumpPower = v
	end
end)
charSection:AddToggle("walkOnWater", {
	Title = "Walk On Water",
	Default = false
}):OnChanged(function()
	for _, zone in pairs(fishingZones:GetChildren()) do
		if zone.Name == selectedWalkOnWaterZone then
			zone.CanCollide = Options.walkOnWater.Value
		end;
		if selectedWalkOnWaterZone == "Ocean" and zone.Name == "Deep Ocean" then
			zone.CanCollide = Options.walkOnWater.Value
		end
	end
end)
charSection:AddDropdown("walkOnWaterZone", {
	Title = "Walk On Water Zone",
	Values = {
		"Ocean",
		"Desolate Deep",
		"The Depths"
	},
	Default = "Ocean"
}):OnChanged(function(v)
	selectedWalkOnWaterZone = v
end)
local miscSection = Tabs.Misc:AddSection("Miscellaneous")
miscSection:AddToggle("removeFog", {
	Title = "Remove Fog",
	Default = false
}):OnChanged(function()
	if Options.removeFog.Value then
		if game.Lighting:FindFirstChild("Sky") then
			game.Lighting.Sky.Parent = game.Lighting.bloom
		end
	else
		if game.Lighting.bloom:FindFirstChild("Sky") then
			game.Lighting.bloom.Sky.Parent = game.Lighting
		end
	end
end)
miscSection:AddToggle("dayOnly", {
	Title = "Day Only",
	Default = false
}):OnChanged(function()
	if Options.dayOnly.Value then
		dayOnlyConnection = RunService.Heartbeat:Connect(function()
			game.Lighting.TimeOfDay = "12:00:00"
		end)
	elseif dayOnlyConnection then
		dayOnlyConnection:Disconnect()
		dayOnlyConnection = nil
	end
end)
miscSection:AddButton({
	Title = "Load Infinite-Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})
miscSection:AddButton({
	Title = "Copy Position",
	Description = "Copies your current position to the clipboard.",
	Callback = function()
		setclipboard("CFrame.new(" .. tostring(humanoidRootPart.Position) .. ")")
	end
})
playerGui.DescendantAdded:Connect(function(descendant)
	if isAutoShakeEnabled and descendant.Name == "button" and descendant.Parent and descendant.Parent.Name == "safezone" then
		startAutoShake()
	end;
	if isAutoReelEnabled and descendant.Name == "playerbar" and descendant.Parent and descendant.Parent.Name == "bar" then
		startAutoReel()
	end
end)
playerGui.DescendantRemoving:Connect(function(descendant)
	if descendant.Name == "playerbar" and descendant.Parent and descendant.Parent.Name == "bar" then
		stopAutoReel()
		if isAutoCastEnabled then
			task.wait(1)
			handleAutoCast()
		end
	end
end)
noclipConnection = RunService.Stepped:Connect(function()
	if isNoclipEnabled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)
Window:SelectTab(1)
showNotification("Executed!")
