-- Помощник выживания в Natural Disaster Survival с GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно уже запущено
if PlayerGui:FindFirstChild("NDSHelperMenu") then
    PlayerGui.NDSHelperMenu:Destroy()
end

-- Создаем интерфейс (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NDSHelperMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Главное окно меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0) -- Слева на экране
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- Циановая рамка
MainFrame.Active = true
MainFrame.Draggable = true -- Можно перетаскивать мышкой
MainFrame.Parent = ScreenGui

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Text = "NDS HELPER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Функция для легкого создания кнопок в столбик
local function createButton(text, posY, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 160, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, posY)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Button.BorderSizePixel = 1
    Button.BorderColor3 = Color3.fromRGB(60, 60, 65)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    
    Button.MouseButton1Click:Connect(callback)
    Button.Parent = MainFrame
    return Button
end

-- Переменные для отслеживания состояний кнопок
local espEnabled = false
local jumpEnabled = false

-- 1. КНОПКА: Переключатель ESP (Подсветка игроков)
local espBtn = createButton("Включить ESP", 40, function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "ESP: [ВКЛ]"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
        -- Поток подсветки игроков
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
        espBtn.Text = "Включить ESP"
        espBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        -- Удаляем подсветку со всех игроков
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

-- 2. КНОПКА: Переключатель Супер-прыжка
local jumpBtn = createButton("Супер Прыжок: ВЫКЛ", 80, function()
    jumpEnabled = not jumpEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if jumpEnabled then
            LocalPlayer.Character.Humanoid.JumpPower = 100
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            jumpBtn.Text = "Прыжок:"
            jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
        else
            LocalPlayer.Character.Humanoid.JumpPower = 50
            jumpBtn.Text = "Супер Прыжок: ВЫКЛ"
            jumpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
    end
end)

-- 3. КНОПКИ: Телепорты
createButton("ТП на Остров", 120, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-32, 48, 0)
    end
end)

createButton("ТП в Лобби", 160, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-21, 181, 1)
    end
end)

-- 4. АВТО-ФУНКЦИЯ: Чтение компаса и вывод уведомления на экран
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
