-- Auto-Buy GUI with Animations

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Items to buy (update exactly as in-game)
local items = {"Grandmaster","Master","LevelUp","Lollipop","Godly","Elder","Strawberry","Giant","Pincoin","BurningBud","WateringCan"}

-- Function to find a working RemoteEvent
local function findBuyEvent()
    for _, obj in pairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("RemoteEvent") then
            local success = pcall(function() obj:FireServer(items[1]) end)
            if success then return obj end
        end
    end
    return nil
end

local buyEvent = findBuyEvent()
if not buyEvent then
    warn("No working RemoteEvent found!")
    return
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui", playerGui)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Rounded corners
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Text = "Auto-Buy Menu"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Scrolling frame for buttons
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,#items*40)
scroll.ScrollBarThickness = 6

-- Create buttons with hover animation
for i, itemName in ipairs(items) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, (i-1)*40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = itemName
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = false

    local cornerBtn = Instance.new("UICorner", btn)
    cornerBtn.CornerRadius = UDim.new(0,5)

    -- Hover animation
    btn.MouseEnter:Connect(function()
        btn:TweenSizeAndPosition(UDim2.new(1, -8, 0, 37), btn.Position - UDim2.new(0,0,0,1), "Out", "Quad", 0.2, true)
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end)
    btn.MouseLeave:Connect(function()
        btn:TweenSizeAndPosition(UDim2.new(1, -10, 0, 35), btn.Position + UDim2.new(0,0,0,1), "Out", "Quad", 0.2, true)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end)

    -- Click: auto-buy
    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            buyEvent:FireServer(itemName)
        end)
        if success then
            print("Bought:", itemName)
        else
            warn("Failed:", itemName, err)
        end
    end)
end
