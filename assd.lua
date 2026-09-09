-- Помощник Survival v4.0 с динамическим обновлением экранов
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("NDSHelperMenu") then
    PlayerGui.NDSHelperMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NDSHelperMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- МЕНЮ СТАЛО В 2.5 РАЗА ШИРЕ (Ширина 650)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 310) 
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
Title.Text = "SURVIVAL ULTRA MENU v4.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Контейнер для динамического контента (чтобы очищать при обновлении)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -65)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ИМЯ ИГРОКА СНИЗУ СЛЕВА (Остается всегда)
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

-- Переменные состояний функций
local espEnabled = false
local speedEnabled = false
local jumpEnabled = false

-- Функции отрисовки экранов
local showMainMenu, showPlayerSettings

-- 1. ЭКРАН: ГЛАВНОЕ МЕНЮ
showMainMenu = function()
    ContentFrame:ClearAllChildren() -- Очищаем старые кнопки
    
    -- Кнопка создания элементов (подстроена под ширину 630)
    local function createBtn(text, posY, callback)
        local b = Instance.new("TextButton", ContentFrame)
        b.Size = UDim2.new(0, 630, 0, 35)
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
            showMainMenu() -- Обновляем текст
            task.spawn(function()
                while espEnabled do
                    for _, player in pairs(Players:GetPlayers()) do
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

    -- НАЖАТИЕ НА ЭТУ КНОПКУ ОБНОВЛЯЕТ МЕНЮ И ОТКРЫВАЕТ НАСТРОЙКИ БЕГА/ПРЫЖКА
    local playerTabBtn = createBtn("👤 PLAYER (Нажми для настроек)", 160, function()
        showPlayerSettings()
    end)
    playerTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    playerTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
end

-- 2. ЭКРАН: НАСТРОЙКИ ИГРОКА (PLAYER)
showPlayerSettings = function()
    ContentFrame:ClearAllChildren() -- Очищаем экран телепортов
    
    local function createPlayerBtn(text, posY, callback)
        local b = Instance.new("TextButton", ContentFrame)
        b.Size = UDim2.new(0, 630, 0, 35)
        b.Position = UDim2.new(0, 10, 0, posY)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- Настройка бега
    local speedBtn = createPlayerBtn(speedEnabled and "Быстрый бег (x2)" or "Обычный бег (x1)", 20, function()
        speedEnabled = not speedEnabled
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and 35 or 16
            showPlayerSettings() -- Перерисовываем экран настроек для обновления текста
        end
    end)
    if speedEnabled then speedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120) end

    -- Настройка прыжка
    local jumpBtn = createPlayerBtn(jumpEnabled and "Супер Прыжок (ВКЛ)" or "Обычный прыжок", 65, function()
        jumpEnabled = not jumpEnabled
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = jumpEnabled and 100 or 50
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            showPlayerSettings() -- Перерисовываем для обновления текста
        end
    end)
    if jumpEnabled then jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120) end

    -- Кнопка НАЗАД в главное меню
    local backBtn = createPlayerBtn("⬅️ Назад в Главное Меню", 150, function()
        showMainMenu()
    end)
    backBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
end

-- Инициализируем главный экран при старте
showMainMenu()

-- Авто-уведомления о бедствиях
pcall(function()
    local mainGui = PlayerGui:WaitForChild("MainGui", 5)
    if mainGui then
        local disasterAlert = mainGui:FindFirstChild("DisasterAlert")
        if disasterAlert then
            disasterAlert:GetPropertyChangedSignal("Text"):Connect(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "🚨 БЕДСТВИЕ!", Text = disasterAlert.Text, Duration = 6})
            end)
        end
    end
end)
