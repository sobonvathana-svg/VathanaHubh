-- Vathana Auto-Buy Menu Script
local plr = game.Players.LocalPlayer
local rs  = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

-- seeds/items
local items = {
    "Grandmaster","Master","LevelUp","Lollipop",
    "Godly","Elder","Strawberry","Giant",
    "Pincoin","BurningBud"
}

-- welcome gui
local gui = Instance.new("ScreenGui",plr.PlayerGui)
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,200,0,300)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = .1
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.Montserrat
title.Text = "🌱 Vathana Menu 🌱"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- scroll list
local scroll = Instance.new("ScrollingFrame",frame)
scroll.Size = UDim2.new(1,0,1,-40)
scroll.Position = UDim2.new(0,0,0,40)
scroll.CanvasSize = UDim2.new(0,0,#items*35,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

-- find remote
local remote
for _,v in ipairs(rs:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("buy") then
        remote = v break
    end
end

-- make buttons
for i,name in ipairs(items) do
    local b = Instance.new("TextButton",scroll)
    b.Size = UDim2.new(1,-10,0,30)
    b.Position = UDim2.new(0,5,0,(i-1)*35)
    b.Text = "Buy "..name
    b.Font = Enum.Font.Montserrat
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.MouseButton1Click:Connect(function()
        if remote then
            remote:FireServer(name,1)
            print("[AutoBuy] Bought "..name)
        else
            warn("No remote found!")
        end
    end)
end
