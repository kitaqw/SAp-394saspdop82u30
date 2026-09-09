-- ПОЛНОСТЬЮ ПОЧИНЕННЫЙ Помощник Survival v5.1 с ползунком
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ИСПРАВЛЕНО: Теперь старое меню ВСЕГДА жестко удаляется перед запуском
if PlayerGui:FindFirstChild("NDSHelperMenu") then
    PlayerGui.NDSHelperMenu:Destroy()
    task.wait(0.1)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NDSHelperMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Меню 320 пикселей в ширину
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 310) 
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Text = "SURVIVAL MENU v5.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Контейнер для кнопок
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -65)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Никнейм игрока снизу
local PlayerInfo = Instance.new("TextLabel")
PlayerInfo.Size = UDim2.new(0, 300, 0, 20)
PlayerInfo.Position = UDim2.new(0, 12, 1, -22)
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Text = "Игрок: " .. LocalPlayer.Name
PlayerInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
PlayerInfo.Font = Enum.Font.SourceSansItalic
PlayerInfo.TextSize = 13
PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left
PlayerInfo.Parent = MainFrame

-- Переменные функций
local espEnabled = false
local spdMult = 1
local jumpEnabled = false

-- Безопасный бег без убийства античитом
game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") and c:FindFirstChild("HumanoidRootPart") and c.Humanoid.MoveDirection.Magnitude > 0 and spdMult > 1 then
            c.Humanoid.WalkSpeed = 16
            c:TranslateBy(c.Humanoid.MoveDirection * (spdMult - 1) * 0.2)
        end
    end)
end)

local showMainMenu, showPlayerSettings

-- ЭКРАН 1: ГЛАВНОЕ МЕНЮ
showMainMenu = function()
    ContentFrame:ClearAllChildren()
    
    local function createBtn(text, posY, callback)
        local b = Instance.new("TextButton", ContentFrame)
        b.Size = UDim2.new(0, 300, 0, 35)
        b.Position = UDim2.new(0, 10, 0, posY)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        b.MouseButton1Click:Connect(callback)
        return b
    end

    local espBtn = createBtn(espEnabled and "ESP: [АКТИВЕН]" or "Включить ESP (Подсветка)", 15, function()
        espEnabled = not espEnabled
        if espEnabled then
            showMainMenu()
            task.spawn(function()
                while espEnabled do
                    for _, player in pairs(Players:GetPlayers()) do
                        -- ИСПРАВЛЕНО: Опечатка полностью удалена, код стабилен
                        if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESPHighlight") then
                            local h = Instance.new("Highlight", player.Character)
                            h.Name = "ESPHighlight"
                            h.FillColor = Color3.fromRGB(0, 255, 255)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.FillTransparency = 0.5
                        end
                    end
                    task.wait(2)
                end
            end)
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("ESPHighlight") then player.Character.ESPHighlight:Destroy() end
            end
            showMainMenu()
        end
    end)
    if espEnabled then espBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120) end

    createBtn("Телепорт на Остров", 60, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-32, 48, 0) end
    end)

    createBtn("Телепорт в Лобби", 105, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-21, 181, 1) end
    end)

    local playerTabBtn = createBtn("👤 PLAYER (Ползунок скорости)", 160, function()
        showPlayerSettings()
    end)
    playerTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    playerTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
end

-- ЭКРАН 2: НАСТРОЙКИ PLAYER
showPlayerSettings = function()
    ContentFrame:ClearAllChildren()
    
    local sliderTitle = Instance.new("TextLabel", ContentFrame)
    sliderTitle.Size = UDim2.new(0, 300, 0, 20)
    sliderTitle.Position = UDim2.new(0, 10, 0, 15)
    sliderTitle.Text = "Скорость бега: " .. math.floor(16 + (spdMult-1) * 33.5)
    sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderTitle.BackgroundTransparency = 1
    sliderTitle.Font = Enum.Font.SourceSansBold
    sliderTitle.TextSize = 14

    local sliderBg = Instance.new("Frame", ContentFrame)
    sliderBg.Size = UDim2.new(0, 300, 0, 10)
    sliderBg.Position = UDim2.new(0, 10, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)

    local mainBtn = Instance.new("TextButton", sliderBg)
    mainBtn.Size = UDim2.new(0, 16, 0, 20)
    local startX = ((spdMult - 1) / 4) * 284
    mainBtn.Position = UDim2.new(0, startX, 0, -5)
    mainBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    mainBtn.Text = ""

    local mouse = LocalPlayer:GetMouse()
    local active = false
    mainBtn.MouseButton1Down:Connect(function() active = true end)
    game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then active = false end end)
    
    mouse.Move:Connect(function()
        if active then
            local relX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            mainBtn.Position = UDim2.new(0, math.clamp(relX - 8, 0, 284), 0, -5)
            spdMult = 1 + (relX / sliderBg.AbsoluteSize.X) * 4
            sliderTitle.Text = "Скорость бега: " .. math.floor(16 + (relX / sliderBg.AbsoluteSize.X) * 134)
        end
    end)

    local function createPlayerBtn(text, posY, callback)
        local b = Instance.new("TextButton", ContentFrame)
        b.Size = UDim2.new(0, 300, 0, 35)
        b.Position = UDim2.new(0, 10, 0, posY)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        b.MouseButton1Click:Connect(callback)
        return b
    end

    local jumpBtn = createPlayerBtn(jumpEnabled and "Супер Прыжок (ВКЛ)" or "Обычный прыжок", 75, function()
        jumpEnabled = not jumpEnabled
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            showPlayerSettings()
        end
    end)
    if jumpEnabled then jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120) end

    local backBtn = createPlayerBtn("⬅️ Назад в Главное Меню", 150, function()
        showMainMenu()
    end)
    backBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
end

showMainMenu()
