-- Animation Speed Controller GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local currentSpeed = 1.0
local speedEnabled = false

-- GUI Parent Setup (handles exploit environment compatibility)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimSpeedGUI"
screenGui.ResetOnSpawn = false

if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
    screenGui.Parent = CoreGui
else
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end

-- Main Window
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 270)
frame.Position = UDim2.new(0.5, -110, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Header Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Anim Speed GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Button Container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -45)
container.Position = UDim2.new(0, 10, 0, 40)
container.BackgroundTransparency = 1
container.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 7)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = container

-- Helper Function to Create Styled Buttons
local function createButton(text, order, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 240, 240)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSansSemibold
    button.LayoutOrder = order
    button.BorderSizePixel = 0
    button.Parent = container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Core Speed Enforcement Logic
local function applySpeed(speed)
    local char = localPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(speed)
    end
end

-- Continuously enforce speed on newly triggered tracks
RunService.RenderStepped:Connect(function()
    if speedEnabled then
        applySpeed(currentSpeed)
    end
end)

-- GUI Buttons
createButton("Freeze Speed (0.0x)", 1, function()
    currentSpeed = 0
    speedEnabled = true
end)

createButton("Slow Speed (1.2x)", 2, function()
    currentSpeed = 1.2
    speedEnabled = true
end)

createButton("Normal Speed (2.5x)", 3, function()
    currentSpeed = 2.5
    speedEnabled = true
end)

createButton("Fast Speed (3.5x)", 4, function()
    currentSpeed = 3.5
    speedEnabled = true
end)

createButton("Reset Default (1.0x)", 5, function()
    currentSpeed = 1.0
    speedEnabled = false
    applySpeed(1.0)
end)
