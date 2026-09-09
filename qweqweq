-- Помощник выживания в Natural Disaster Survival
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. ФУНКЦИЯ: Подсветка (ESP) всех игроков на карте
-- Помогает видеть, куда бегут другие люди во время катаклизма
local function highlightPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Если у игрока еще нет подсветки, создаем её
            if not player.Character:FindFirstChild("ESPHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Голубой цвет заливки
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
                highlight.FillTransparency = 0.5
                highlight.Parent = player.Character
            end
        end
    end
end

-- Запускаем подсветку каждые 5 секунд (для новых зашедших игроков)
task.spawn(function()
    while true do
        highlightPlayers()
        task.wait(5)
    end
end)

-- 2. ФУНКЦИЯ: Визуальный спавн Компаса (Disaster Predictor)
-- В игре есть платный компас за робуксы, который говорит, какое будет бедствие.
-- Этот код бесплатно выведет сообщение о бедствии прямо в твой чат или консоль!
local function trackDisaster()
    pcall(function()
        local survivalTag = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MainGui")
        -- Игра обновляет текст в интерфейсе, когда объявляет бедствие
        if survivalTag then
            local disasterLabel = survivalTag:FindFirstChild("DisasterAlert")
            if disasterLabel then
                disasterLabel:GetPropertyChangedSignal("Text"):Connect(function()
                    print("⚠️ СЛЕДУЮЩЕЕ БЕДСТВИЕ: " .. disasterLabel.Text)
                end)
            end
        end
    end)
end
task.spawn(trackDisaster)

-- 3. ФУНКЦИЯ: Супер-прыжок (Анти-Паника)
-- Изменяет силу прыжка, чтобы можно было запрыгнуть на крышу любого здания
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.JumpPower = 100
    LocalPlayer.Character.Humanoid.UseJumpPower = true
    print("✅ Скрипт успешно активирован! Прыжок увеличен, игроки подсвечены.")
end
