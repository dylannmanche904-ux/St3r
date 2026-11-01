local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetRPNameColor")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Couleurs rouge et noir
local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 0, 0)
}

local isRunning = false
local isLocked = false
local speed = 0.10

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ST3R"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Bouton principal
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.fromOffset(160, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = colors[1]
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "ST3R : OFF"
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleButton

-- Cadenas
local lockButton = Instance.new("TextButton")
lockButton.Size = UDim2.fromOffset(30, 30)
lockButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
lockButton.TextColor3 = Color3.new(1, 1, 1)
lockButton.TextSize = 20
lockButton.Text = "🔓"
lockButton.Parent = screenGui

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 6)
lockCorner.Parent = lockButton

-- Cadenas collé au bouton
RunService.RenderStepped:Connect(function()
    lockButton.Position = UDim2.fromOffset(
        toggleButton.AbsolutePosition.X + toggleButton.AbsoluteSize.X + 5,
        toggleButton.AbsolutePosition.Y + 10
    )
end)

-- Verrouillage
lockButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    toggleButton.Draggable = not isLocked
    lockButton.Text = isLocked and "🔒" or "🔓"
end)

-- Alternance rouge et noir
task.spawn(function()
    local colorIndex = 1

    while true do
        if isRunning then
            Event:FireServer(colors[colorIndex])
            colorIndex = (colorIndex % #colors) + 1
            task.wait(speed)
        else
            task.wait(0.2)
        end
    end
end)

-- Activation ON/OFF
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning

    if isRunning then
        toggleButton.Text = "ST3R : ON"
        toggleButton.BackgroundColor3 = colors[1]
    else
        toggleButton.Text = "ST3R : OFF"
        toggleButton.BackgroundColor3 = colors[2]
    end
end)
