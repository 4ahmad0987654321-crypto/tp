-- ============================================
-- MAD TELEPORT - STEAL AN EGG
-- Murni teleport, tanpa fly
-- ============================================

local Players = game:GetService("Players")
local P = Players.LocalPlayer
local PG = P:WaitForChild("PlayerGui")
local char = P.Character or P.CharacterAdded:Wait()

-- ============================================
-- CONFIG
-- ============================================
local CONFIG = {
    basePosition = Vector3.new(0, 10, 0),
    autoSteal = false,
    loopDelay = 0.5,
}

-- ============================================
-- HAPUS GUI LAMA
-- ============================================
local old = PG:FindFirstChild("MadTeleport")
if old then old:Destroy() end

-- ============================================
-- GUI
-- ============================================
local GUI = Instance.new("ScreenGui")
GUI.Name = "MadTeleport"
GUI.ResetOnSpawn = false
GUI.Parent = PG

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(300, 320)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(220, 38, 44)
stroke.Thickness = 2

-- Header
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
Header.Text = "⚡ MAD TELEPORT"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBlack
Header.TextSize = 16
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

-- Info
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, -20, 0, 18)
Info.Position = UDim2.fromOffset(10, 50)
Info.BackgroundTransparency = 1
Info.Text = "Teleport murni - tanpa fly"
Info.TextColor3 = Color3.fromRGB(150, 150, 160)
Info.Font = Enum.Font.Gotham
Info.TextSize = 10
Info.Parent = Main

-- ============================================
-- SET BASE
-- ============================================
local SetBase = Instance.new("TextButton", Main)
SetBase.Size = UDim2.new(1, -20, 0, 35)
SetBase.Position = UDim2.fromOffset(10, 78)
SetBase.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
SetBase.BorderSizePixel = 0
SetBase.Text = "📍 Set Base Position"
SetBase.TextColor3 = Color3.fromRGB(255, 255, 255)
SetBase.Font = Enum.Font.GothamBold
SetBase.TextSize = 12
SetBase.AutoButtonColor = false
Instance.new("UICorner", SetBase).CornerRadius = UDim.new(0, 8)

SetBase.MouseButton1Click:Connect(function()
    if char and char:FindFirstChild("HumanoidRootPart") then
        CONFIG.basePosition = char.HumanoidRootPart.Position
        SetBase.Text = "📍 Base Tersimpan!"
        task.wait(1)
        SetBase.Text = "📍 Set Base Position"
    end
end)

-- ============================================
-- TELEPORT KE BASE
-- ============================================
local ToBaseBtn = Instance.new("TextButton", Main)
ToBaseBtn.Size = UDim2.new(1, -20, 0, 35)
ToBaseBtn.Position = UDim2.fromOffset(10, 120)
ToBaseBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ToBaseBtn.BorderSizePixel = 0
ToBaseBtn.Text = "🏠 Teleport ke Base"
ToBaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToBaseBtn.Font = Enum.Font.GothamBold
ToBaseBtn.TextSize = 12
ToBaseBtn.AutoButtonColor = false
Instance.new("UICorner", ToBaseBtn).CornerRadius = UDim.new(0, 8)

ToBaseBtn.MouseButton1Click:Connect(function()
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(CONFIG.basePosition)
        print("[TELEPORT] Ke base!")
    end
end)

-- ============================================
-- TELEPORT KE TELUR TERDEKAT
-- ============================================
local ToEggBtn = Instance.new("TextButton", Main)
ToEggBtn.Size = UDim2.new(1, -20, 0, 35)
ToEggBtn.Position = UDim2.fromOffset(10, 162)
ToEggBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ToEggBtn.BorderSizePixel = 0
ToEggBtn.Text = "🥚 Teleport ke Telur"
ToEggBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToEggBtn.Font = Enum.Font.GothamBold
ToEggBtn.TextSize = 12
ToEggBtn.AutoButtonColor = false
Instance.new("UICorner", ToEggBtn).CornerRadius = UDim.new(0, 8)

-- Fungsi cari telur terdekat
local function findEgg()
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local nearest, nearestDist = nil, math.huge
    local myPos = char.HumanoidRootPart.Position
    
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
            local dist = (obj.Position - myPos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = obj
            end
        end
    end
    return nearest, nearestDist
end

ToEggBtn.MouseButton1Click:Connect(function()
    local egg = findEgg()
    if egg and char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(egg.Position)
        print("[TELEPORT] Ke telur:", egg.Name)
    else
        print("[TELEPORT] Gak ada telur!")
    end
end)

-- ============================================
-- AUTO STEAL (TELEPORT MURNI)
-- ============================================
local AutoBtn = Instance.new("TextButton", Main)
AutoBtn.Size = UDim2.new(1, -20, 0, 45)
AutoBtn.Position = UDim2.fromOffset(10, 210)
AutoBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
AutoBtn.BorderSizePixel = 0
AutoBtn.Text = "🔄 AUTO STEAL : OFF"
AutoBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
AutoBtn.Font = Enum.Font.GothamBlack
AutoBtn.TextSize = 13
AutoBtn.AutoButtonColor = false
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 8)

AutoBtn.MouseButton1Click:Connect(function()
    CONFIG.autoSteal = not CONFIG.autoSteal
    if CONFIG.autoSteal then
        AutoBtn.BackgroundColor3 = Color3.fromRGB(25, 145, 105)
        AutoBtn.Text = "🔄 AUTO STEAL : ON"
    else
        AutoBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        AutoBtn.Text = "🔄 AUTO STEAL : OFF"
    end
end)

-- ============================================
-- LOOP AUTO STEAL (MURNI TELEPORT)
-- ============================================
task.spawn(function()
    while task.wait(CONFIG.loopDelay) do
        if CONFIG.autoSteal and char and char:FindFirstChild("HumanoidRootPart") then
            local egg = findEgg()
            if egg then
                local hrp = char.HumanoidRootPart
                local basePos = CONFIG.basePosition
                
                -- Teleport ke telur
                hrp.CFrame = CFrame.new(egg.Position)
                task.wait(0.05)
                
                -- Grab
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(hrp, egg, 0)
                        task.wait(0.03)
                        firetouchinterest(hrp, egg, 1)
                    end
                end)
                
                -- Teleport balik ke base
                task.wait(0.05)
                hrp.CFrame = CFrame.new(basePos)
            end
        end
    end
end)

-- ============================================
-- CLOSE
-- ============================================
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(1, -20, 0, 30)
CloseBtn.Position = UDim2.new(0, 10, 1, -42)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "❌ Close"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- ============================================
-- UPDATE CHARACTER
-- ============================================
P.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    char = newChar
end)

print("[MAD TELEPORT] Loaded! Murni teleport, tanpa fly.")
