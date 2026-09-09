-- Расширенный Помощник Survival с вкладками и инфо об игроке
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно запущено
if PlayerGui:FindFirstChild("NDSHelperMenu") then
    PlayerGui.NDSHelperMenu:Destroy()
end

-- Создаем интерфейс (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NDSHelperMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- УВЕЛИЧЕННОЕ ГЛАВНОЕ ОКНО МЕНЮ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 320) -- Размер увеличен в ширину и высоту
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
Title.Text = "SURVIVAL MENU v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- ФУНКЦИЯ ДЛЯ СОЗДАНИЯ КНОПОК
local function createButton(text, posY, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 200, 0, 32) -- Кнопки стали шире под новое окно
    Button.Position = UDim2.new(0, 10, 0, posY)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Button.BorderSizePixel = 1
    Button.BorderColor3 = Color3.fromRGB(65, 65, 70)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = MainFrame
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- =======================================================
-- РАЗДЕЛ: ГЛАВНЫЕ ФУНКЦИИ И ТЕЛЕПОРТЫ
-- =======================================================
local espEnabled = false
local espBtn = createButton("Включить ESP (Подсветка)", 50, function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "ESP: [АКТИВЕН]"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120)
        task.spawn(function()
            while espEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not player.Character:FindFirstChild("ESPHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.FillColor = Color3.fromRGB(0, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = player.Character
                        end
                    end
                end
                task.wait(2)
            end
        end)
    else
        espBtn.Text = "Включить ESP (Подсветка)"
        espBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

createButton("Телепорт на Остров", 90, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-32, 48, 0)
    end
end)

createButton("Телепорт в Лобби", 130, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-21, 181, 1)
    end
end)

-- =======================================================
-- РАЗДЕЛ: PLAYER (ИГРОК)
-- =======================================================
-- Создаем визуальную плашку-разделитель "Player"
local PlayerHeader = Instance.new("TextLabel")
PlayerHeader.Size = UDim2.new(0, 200, 0, 25)
PlayerHeader.Position = UDim2.new(0, 10, 0, 175)
PlayerHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
PlayerHeader.BorderSizePixel = 1
PlayerHeader.BorderColor3 = Color3.fromRGB(0, 255, 255)
PlayerHeader.Text = "⚙️ КНОПКА PLAYER"
PlayerHeader.TextColor3 = Color3.fromRGB(0, 255, 255)
PlayerHeader.Font = Enum.Font.SourceSansBold
PlayerHeader.TextSize = 14
PlayerHeader.Parent = MainFrame

-- Настройки функций внутри блока Player
local speedEnabled = false
local speedBtn = createButton("Обычный бег (x1)", 210, function()
    speedEnabled = not speedEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        -- Переключаем безопасную скорость, чтобы не убил античит
        LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and 35 or 16
        speedBtn.Text = speedEnabled and "Быстрый бег (x2)" or "Обычный бег (x1)"
        speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 120, 120) or Color3.fromRGB(45, 45, 50)
    end
end)

local jumpEnabled = false
local jumpBtn = createButton("Обычный прыжок", 250, function()
    jumpEnabled = not jumpEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        jumpBtn.Text = jumpEnabled and "Супер Прыжок (ВКЛ)" or "Обычный прыжок"
        jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 120, 120) or Color3.fromRGB(45, 45, 50)
    end
end)

-- =======================================================
-- ЭЛЕМЕНТ: ИМЯ ИГРОКА СНИЗУ СЛЕВА
-- =======================================================
local PlayerInfo = Instance.new("TextLabel")
PlayerInfo.Size = UDim2.new(0, 200, 0, 25)
PlayerInfo.Position = UDim2.new(0, 10, 1, -25) -- Жестко привязано снизу слева панели
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Text = "Игрок: " .. LocalPlayer.Name
PlayerInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
PlayerInfo.Font = Enum.Font.SourceSansItalic
PlayerInfo.TextSize = 13
PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left -- Выравнивание по левому краю
PlayerInfo.Parent = MainFrame

-- =======================================================
-- АВТО-УВЕДОМЛЕНИЯ О БЕДСТВИЯХ
-- =======================================================
pcall(function()
    local mainGui = PlayerGui:WaitForChild("MainGui", 5)
    if mainGui then
        local disasterAlert = mainGui:FindFirstChild("DisasterAlert")
        if disasterAlert then
            disasterAlert:GetPropertyChangedSignal("Text"):Connect(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "🚨 БЕДСТВИЕ!",
                    Text = disasterAlert.Text,
                    Duration = 6
                })
            end)
        end
    end
end)
