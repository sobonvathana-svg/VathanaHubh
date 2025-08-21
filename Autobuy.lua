-- 🌱 Vathana Auto-Buy Hub with ThunderZ-style Animations ⚡
local plr = game.Players.LocalPlayer
local rs  = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- item list
local items = {
    "Grandmaster","Master","LevelUp","Lollipop",
    "Godly","Elder","Strawberry","Giant",
    "Pincoin","BurningBud","WateringCan"
}

-- gui base
local gui = Instance.new("ScreenGui",plr.PlayerGui)
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,0,0,0) -- start small for animation
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Visible = true

-- rounded corners + glow
local corner = Instance.new("UICorner",frame)
corner.CornerRadius = UDim.new(0,12)

local uiStroke = Instance.new("UIStroke",frame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0,200,255)

-- title
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.Montserrat
title.Text = "⚡ Vathana Hub ⚡"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- scrolling area
local scroll = Instance.new("ScrollingFrame",frame)
scroll.Size = UDim2.new(1,0,1,-40)
scroll.Position = UDim2.new(0,0,0,40)
scroll.CanvasSize = UDim2.new(0,0,#items*35,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

-- animate frame in (slide + grow)
TweenService:Create(frame,TweenInfo.new(0.7,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size = UDim2.new(0,220,0,350)
}):Play()

-- glowing stroke effect
task.spawn(function()
    while frame.Parent do
        TweenService:Create(uiStroke,TweenInfo.new(0.6),{Thickness=4,Color=Color3.fromRGB(0,255,180)}):Play()
        task.wait(0.6)
        TweenService:Create(uiStroke,TweenInfo.new(0.6),{Thickness=2,Color=Color3.fromRGB(0,150,255)}):Play()
        task.wait(0.6)
    end
end)

-- find remote
local remote
for _,v in ipairs(rs:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("buy") then
        remote=v break
    end
end

-- make buttons w/ hover effect
for i,name in ipairs(items) do
    local b = Instance.new("TextButton",scroll)
    b.Size = UDim2.new(1,-10,0,30)
    b.Position = UDim2.new(0,5,0,(i-1)*35)
    b.Text = "Buy "..name
    b.Font = Enum.Font.Montserrat
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local bc = Instance.new("UICorner",b)
    bc.CornerRadius = UDim.new(0,8)

    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(0,180,255)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(40,40,40)}):Play()
    end)

    b.MouseButton1Click:Connect(function()
        if remote then
            remote:FireServer(name,1)
            print("[AutoBuy] Bought "..name)
        else
            warn("No remote found!")
        end
    end)
end
