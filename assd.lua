local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("NDSHelperMenu") then
    PlayerGui.NDSHelperMenu:Destroy()
    task.wait(0.1)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NDSHelperMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Text = "SURVIVAL MENU v6.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -65)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

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

local espEnabled = false
local spdMult = 1
local jumpMult = 1
local flyEnabled = false
local flyBody

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") and c:FindFirstChild("HumanoidRootPart") then
            if c.Humanoid.MoveDirection.Magnitude > 0 and spdMult > 1 then
                c.Humanoid.WalkSpeed = 16
                c:TranslateBy(c.Humanoid.MoveDirection * (spdMult - 1) * 0.2)
            end
            if c.Humanoid.Jump and jumpMult > 1 and math.abs(c.HumanoidRootPart.Velocity.Y) < 1 then
                c.HumanoidRootPart.Velocity = Vector3.new(c.HumanoidRootPart.Velocity.X, 30 * jumpMult, c.HumanoidRootPart.Velocity.Z)
            end
            if flyEnabled and flyBody then
                local dir = c.Humanoid.MoveDirection
                local flyVel = Vector3.new(0,0,0)
                if dir.Magnitude > 0 then flyVel = dir * 50 end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    flyVel = flyVel + Vector3.new(0, 40, 0)
                end
                flyBody.Velocity = flyVel
            end
        end
    end)
end)

local showMainMenu, showPlayerSettings

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

    local playerTabBtn = createBtn("👤 PLAYER (Слайдеры и Флай)", 160, function() showPlayerSettings() end)
    playerTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    playerTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
end

showPlayerSettings = function()
    ContentFrame:ClearAllChildren()
    
    local spdTitle = Instance.new("TextLabel", ContentFrame)
    spdTitle.Size = UDim2.new(0, 300, 0, 15)
    spdTitle.Position = UDim2.new(0, 10, 0, 5)
    spdTitle.Text = "Скорость бега: " .. math.floor(16 + (spdMult-1) * 33.5)
    spdTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdTitle.BackgroundTransparency = 1
    spdTitle.Font = Enum.Font.SourceSansBold
    spdTitle.TextSize = 12

    local spdBg = Instance.new("Frame", ContentFrame)
    spdBg.Size = UDim2.new(0, 300, 0, 8)
    spdBg.Position = UDim2.new(0, 10, 0, 22)
    spdBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)

    local spdBtn = Instance.new("TextButton", spdBg)
    spdBtn.Size = UDim2.new(0, 14, 0, 16)
    spdBtn.Position = UDim2.new(0, ((spdMult - 1) / 4) * 286, 0, -4)
    spdBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    spdBtn.Text = ""

    local jmpTitle = Instance.new("TextLabel", ContentFrame)
    jmpTitle.Size = UDim2.new(0, 300, 0, 15)
    jmpTitle.Position = UDim2.new(0, 10, 0, 45)
    jmpTitle.Text = "Высота прыжка: " .. math.floor(50 + (jumpMult-1) * 50)
    jmpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    jmpTitle.BackgroundTransparency = 1
    jmpTitle.Font = Enum.Font.SourceSansBold
    jmpTitle.TextSize = 12

    local jmpBg = Instance.new("Frame", ContentFrame)
    jmpBg.Size = UDim2.new(0, 300, 0, 8)
    jmpBg.Position = UDim2.new(0, 10, 0, 62)
    jmpBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)

    local jmpBtn = Instance.new("TextButton", jmpBg)
    jmpBtn.Size = UDim2.new(0, 14, 0, 16)
    jmpBtn.Position = UDim2.new(0, ((jumpMult - 1) / 4) * 286, 0, -4)
    jmpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    jmpBtn.Text = ""

    local mouse = LocalPlayer:GetMouse()
    local activeSpd, activeJmp = false, false
    
    spdBtn.MouseButton1Down:Connect(function() activeSpd = true end)
    jmpBtn.MouseButton1Down:Connect(function() activeJmp = true end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then activeSpd = false activeJmp = false end 
    end)
    
    mouse.Move:Connect(function()
        if activeSpd then
            local relX = math.clamp(mouse.X - spdBg.AbsolutePosition.X, 0, spdBg.AbsoluteSize.X)
            spdBtn.Position = UDim2.new(0, math.clamp(relX - 7, 0, 286), 0, -4)
            spdMult = 1 + (relX / spdBg.AbsoluteSize.X) * 4
            spdTitle.Text = "Скорость бега: " .. math.floor(16 + (relX / spdBg.AbsoluteSize.X) * 134)
        elseif activeJmp then
            local relX = math.clamp(mouse.X - jmpBg.AbsolutePosition.X, 0, jmpBg.AbsoluteSize.X)
            jmpBtn.Position = UDim2.new(0, math.clamp(relX - 7, 0, 286), 0, -4)
            jumpMult = 1 + (relX / jmpBg.AbsoluteSize.X) * 4
            jmpTitle.Text = "Высота прыжка: " .. math.floor(50 + (relX / jmpBg.AbsoluteSize.X) * 200)
        end
    end)

    local function createPlayerBtn(text, posY, callback)
        local b = Instance.new("TextButton", ContentFrame)
        b.Size = UDim2.new(0, 300, 0, 32)
        b.Position = UDim2.new(0, 10, 0, posY)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        b.MouseButton1Click:Connect(callback)
        return b
    end

    local flyBtn = createPlayerBtn(flyEnabled and "Флай: [ВКЛ]" or "Включить Флай (Полет)", 95, function()
        flyEnabled = not flyEnabled
        local c = LocalPlayer.Character
        if flyEnabled then
            if c and c:FindFirstChild("HumanoidRootPart") then
                flyBody = Instance.new("BodyVelocity")
                flyBody.Name = "SafeFly"
                flyBody.Velocity = Vector3.new(0,0,0)
                flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyBody.Parent = c.HumanoidRootPart
            end
        else
            if c and c.HumanoidRootPart:FindFirstChild("SafeFly") then c.HumanoidRootPart.SafeFly:Destroy() end
        end
        showPlayerSettings()
    end)
    if flyEnabled then flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120) end

    local backBtn = createPlayerBtn("⬅️ Назад в Главное Меню", 150, function() showMainMenu() end)
    backBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
end

showMainMenu()
