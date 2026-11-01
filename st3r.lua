local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetRPNameColor")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local colors = {
    Color3.fromRGB(0, 100, 255), -- Bleu
    Color3.fromRGB(255, 0, 180)  -- Rose
}

local isRunning = false
local isLocked = false
local speed = 0.10

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ST3R"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Interface ST3R
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

-- Cadenas 30 x 30
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

-- Cadenas toujours collé à ST3R
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

-- Alternance bleu et rose
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

-- Activation
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning

    if isRunning then
        toggleButton.Text = "ST3R : ON"
        toggleButton.BackgroundColor3 = colors[2]
    else
        toggleButton.Text = "ST3R : OFF"
        toggleButton.BackgroundColor3 = colors[1]
    end
end)
