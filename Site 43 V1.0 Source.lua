```local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Site 43 Script By 1998",
    LoadingTitle = "Neptune Script",
    LoadingSubtitle = "by 1998",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Neptune Script"
    },
    Discord = {
        Enabled = true,
        Invite = "neptunescript",
        RememberJoins = false
    },
})


local Camera = workspace.CurrentCamera
local spectating = false
local originalCameraSubject = Camera.CameraSubject

local function spectatePlayer(player)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = player.Character.Humanoid
    end
end

local function stopSpectating()
    Camera.CameraSubject = originalCameraSubject
end





local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")


local function teleportPlayersInCircle()
    local LocalPlayer = Players.LocalPlayer
    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local startPosition = rootPart.Position
    local radius = 3 -- Radius of the circle
    local angleStep = math.rad(360 / (#Players:GetPlayers() - 1)) -- Angle between each player

    local currentAngle = 0

    for i, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local offsetX = math.cos(currentAngle) * radius
            local offsetZ = math.sin(currentAngle) * radius
            local newPosition = startPosition + Vector3.new(offsetX, 0, offsetZ)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition, startPosition)
            currentAngle = currentAngle + angleStep
        end
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Tab then
        teleportPlayersInCircle()
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport",
            Text = "All players have been teleported around you.",
            Duration = 5,
        })
    end
end)









































local CombatTab = Window:CreateTab("・Combat", nil)
local CombatSection = CombatTab:CreateSection("Combat Scripts")

local aimbot = CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/froceurdev/aimbot/main/aimkey"))()
        end
    end
})

local tpKillActive = false
local currentTarget = nil

local function tpKill()
    local LocalPlayer = Players.LocalPlayer

    while tpKillActive do
        if not currentTarget or not currentTarget.Character or not currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            currentTarget = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    currentTarget = player
                    break
                end
            end
        end

        if currentTarget then
            local character = currentTarget.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                local targetPosition = character.Head.Position + Vector3.new(0, 5, 0)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

                wait(0.001)

                while tpKillActive and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") do
                    wait(0.1)
                end

                currentTarget = nil
            end
        end

        wait(0.1)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F3 then
        tpKillActive = not tpKillActive
        if tpKillActive then
            tpKill()
            StarterGui:SetCore("SendNotification", {
                Title = "TP Kill",
                Text = "TP Kill Activé.",
                Duration = 5,
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "TP Kill",
                Text = "TP Kill Désactivé.",
                Duration = 5,
            })
        end
    end
end)

local function silentAim()
    local LocalPlayer = Players.LocalPlayer
    local mouse = LocalPlayer:GetMouse()

    local function getClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos = player.Character.Head.Position
                local screenPos = workspace.CurrentCamera:WorldToScreenPoint(pos)
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
        return closestPlayer
    end

    local function onRenderStep()
        local closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
            local aimPosition = closestPlayer.Character.Head.Position
            mouse.Hit = CFrame.new(aimPosition)
        end
    end

    RunService.RenderStepped:Connect(onRenderStep)
end

local silentAimToggle = CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "ToggleSilentAim",
    Callback = function(state)
        if state then
            silentAim()
        end
    end
})


local espTab = Window:CreateTab("・ESP", nil)
local espSection = espTab:CreateSection("Main")

local ESPEnabled = false
local ESP = nil

local function createESP(player)
    if player.Character then
        local highlight = Instance.new("BoxHandleAdornment")
        highlight.Size = player.Character:GetExtentsSize() * 1.1
        highlight.Adornee = player.Character
        highlight.AlwaysOnTop = true
        highlight.ZIndex = 5
        highlight.Transparency = 0.5
        highlight.Color3 = Color3.fromRGB(255, 255, 255)
        highlight.Parent = player.Character
    end
end

local function removeESP(player)
    if player.Character then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("BoxHandleAdornment") then
                v:Destroy()
            end
        end
    end
end

local function toggleESP(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Team ~= Players.LocalPlayer.Team then
                createESP(player)
            end
        end
        Players.PlayerAdded:Connect(function(player)
            if player.Team ~= Players.LocalPlayer.Team then
                player.CharacterAdded:Connect(function()
                    createESP(player)
                end)
            end
        end)
        Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            removeESP(player)
        end
    end
end

local Esp = espTab:CreateToggle({
    Name = "Box Blanche ESP",
    CurrentValue = false,
    Flag = "ToggleESP",
    Callback = function(state)
        ESPEnabled = state
        toggleESP(state)
    end
})


local utilTab = Window:CreateTab("・Utilitaires", nil)
local utilSection = utilTab:CreateSection("Utilitaires Scripts")

local infinityYieldActive = false
local dexExplorerActive = false

local InfinityYield = utilTab:CreateButton({
    Name = "Infinity Yield",
    Callback = function()
        if not infinityYieldActive then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            infinityYieldActive = true
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Infinity Yield",
                Text = "Infinity Yield déjà activé.",
                Duration = 5,
            })
        end
    end
})

local DexExplorer = utilTab:CreateButton({
    Name = "Dex Explorer",
    Callback = function()
        if not dexExplorerActive then
            loadstring(game:HttpGet('https://ithinkimandrew.site/scripts/tools/dark-dex.lua'))()
            dexExplorerActive = true
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Dex Explorer",
                Text = "Dex Explorer déjà activé.",
                Duration = 5,
            })
        end
    end
})


local TpKillButton = utilTab:CreateButton({
    Name = "TP Kill",
    Callback = function()
        tpKillActive = not tpKillActive
        if tpKillActive then
            StarterGui:SetCore("SendNotification", {
                Title = "TP Kill",
                Text = "Appuyez sur F3 pour commencer le TP Kill.",
                Duration = 5,
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "TP Kill",
                Text = "TP Kill désactivé.",
                Duration = 5,
            })
        end
    end
})


local flyActive = false
local flySpeed = 150
local flyConnection
local moveDirections = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then
        moveDirections.Forward = true
    elseif input.KeyCode == Enum.KeyCode.S then
        moveDirections.Backward = true
    elseif input.KeyCode == Enum.KeyCode.A then
        moveDirections.Left = true
    elseif input.KeyCode == Enum.KeyCode.D then
        moveDirections.Right = true
    elseif input.KeyCode == Enum.KeyCode.E then
        moveDirections.Up = true
    elseif input.KeyCode == Enum.KeyCode.Q then
        moveDirections.Down = true
    end
end

local function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then
        moveDirections.Forward = false
    elseif input.KeyCode == Enum.KeyCode.S then
        moveDirections.Backward = false
    elseif input.KeyCode == Enum.KeyCode.A then
        moveDirections.Left = false
    elseif input.KeyCode == Enum.KeyCode.D then
        moveDirections.Right = false
    elseif input.KeyCode == Enum.KeyCode.E then
        moveDirections.Up = false
    elseif input.KeyCode == Enum.KeyCode.Q then
        moveDirections.Down = false
    end
end

local function startFly()
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Parent = HumanoidRootPart

    flyConnection = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new()

        if moveDirections.Forward then
            moveDirection = moveDirection + (camera.CFrame.LookVector)
        end
        if moveDirections.Backward then
            moveDirection = moveDirection - (camera.CFrame.LookVector)
        end
        if moveDirections.Left then
            moveDirection = moveDirection - (camera.CFrame.RightVector)
        end
        if moveDirections.Right then
            moveDirection = moveDirection + (camera.CFrame.RightVector)
        end
        if moveDirections.Up then
            moveDirection = moveDirection + Vector3.new(0,1,0)
        end
        if moveDirections.Down then
            moveDirection = moveDirection - Vector3.new(0,1,0)
        end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end

        BodyVelocity.Velocity = moveDirection * flySpeed
    end)

    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
    end
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HumanoidRootPart = Character.HumanoidRootPart
        if HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
            HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
    end
end

local FlyButton = utilTab:CreateButton({
    Name = "Fly",
    Callback = function()
        flyActive = not flyActive
        if flyActive then
            startFly()
            StarterGui:SetCore("SendNotification", {
                Title = "Fly",
                Text = "Vol activé.",
                Duration = 5,
            })
        else
            stopFly()
            StarterGui:SetCore("SendNotification", {
                Title = "Fly",
                Text = "Vol désactivé.",
                Duration = 5,
            })
        end
    end
})


local noClipActive = false
local noClipConnection

local function startNoClip()
    noClipConnection = RunService.Stepped:Connect(function()
        local character = Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoClip()
    if noClipConnection then
        noClipConnection:Disconnect()
    end
end

local NoClipButton = utilTab:CreateButton({
    Name = "No Clip",
    Callback = function()
        noClipActive = not noClipActive
        if noClipActive then
            startNoClip()
            StarterGui:SetCore("SendNotification", {
                Title = "No Clip",
                Text = "No Clip activé.",
                Duration = 5,
            })
        else
            stopNoClip()
            StarterGui:SetCore("SendNotification", {
                Title = "No Clip",
                Text = "No Clip désactivé.",
                Duration = 5,
            })
        end
    end
})





local giveArmesTab = Window:CreateTab("・Give Armes", nil)
local giveArmesSection = giveArmesTab:CreateSection("Ajouter des Armes")

local function copyWeaponToInventory(weaponName)
    local LocalPlayer = Players.LocalPlayer
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team ~= LocalPlayer.Team and player.Backpack:FindFirstChild(weaponName) then
            local weapon = player.Backpack:FindFirstChild(weaponName):Clone()
            weapon.Parent = LocalPlayer.Backpack
            StarterGui:SetCore("SendNotification", {
                Title = "Arme Ajoutée",
                Text = weaponName .. " a été ajoutée à votre inventaire.",
                Duration = 5,
            })
            break
        end
    end
end

local ArmesUSP = giveArmesTab:CreateButton({
    Name = "USP",
    Callback = function()
        copyWeaponToInventory("USP")
    end
})

local ArmesMP5A3 = giveArmesTab:CreateButton({
    Name = "MP5A3",
    Callback = function()
        copyWeaponToInventory("MP5A3")
    end
})

local ArmesHK416Mod = giveArmesTab:CreateButton({
    Name = "HK416 Mod",
    Callback = function()
        copyWeaponToInventory("HK416 Mod")
    end
})

local ArmesSLR36C = giveArmesTab:CreateButton({
    Name = "SLR36C A",
    Callback = function()
        copyWeaponToInventory("SLR36C A")
    end
})

local ArmesDesertEagle = giveArmesTab:CreateButton({
    Name = "Desert Eagle",
    Callback = function()
        copyWeaponToInventory("Desert Eagle")
    end
})

local ArmesFalkorDefenseFG9 = giveArmesTab:CreateButton({
    Name = "Falkor Defense FG-9",
    Callback = function()
        copyWeaponToInventory("Falkor Defense FG-9")
    end
})

local ArmesIA2MOD = giveArmesTab:CreateButton({
    Name = "IA2 MOD",
    Callback = function()
        copyWeaponToInventory("IA2 MOD")
    end
})

local ArmesM40A5 = giveArmesTab:CreateButton({
    Name = "M40A5",
    Callback = function()
        copyWeaponToInventory("M40A5")
    end
})

local ArmesHK416F = giveArmesTab:CreateButton({
    Name = "HK416F",
    Callback = function()
        copyWeaponToInventory("HK416F")
    end
})

local ArmesG17Mod = giveArmesTab:CreateButton({
    Name = "G17",
    Callback = function()
        copyWeaponToInventory("G17 mod")
    end
})

local ArmesG19Mod = giveArmesTab:CreateButton({
    Name = "G19 mod",
    Callback = function()
        copyWeaponToInventory("G19 mod")
    end
})

local ArmesM9 = giveArmesTab:CreateButton({
    Name = "M9",
    Callback = function()
        copyWeaponToInventory("M9")
    end
})

local ArmesHK416D = giveArmesTab:CreateButton({
    Name = "HK416D",
    Callback = function()
        copyWeaponToInventory("HK416D")
    end
})

local ArmesM18 = giveArmesTab:CreateButton({
    Name = "M18",
    Callback = function()
        copyWeaponToInventory("M18")
    end
})

local ArmesM4Carbine = giveArmesTab:CreateButton({
    Name = "M4 Carbine",
    Callback = function()
        copyWeaponToInventory("M4 Carbine")
    end
})

local ArmesNorveske = giveArmesTab:CreateButton({
    Name = "Norveske 10.5",
    Callback = function()
        copyWeaponToInventory("Norveske 10.5")
    end
})

local ArmesMK18EO = giveArmesTab:CreateButton({
    Name = "MK18 EO",
    Callback = function()
        copyWeaponToInventory("MK18 EO")
    end
})

local ArmesTournevisClasseD = giveArmesTab:CreateButton({
    Name = "Tournevis Classe-D",
    Callback = function()
        copyWeaponToInventory("Tournevis Classe-D")
    end
})


local teleportTab = Window:CreateTab("・Téléportation", nil)
local teleportSection = teleportTab:CreateSection("Téléportation")

local tpButton1 = teleportTab:CreateButton({
    Name = "・Téléportation (IC)",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-561.77, -111.66, 2692.34))
    end
})

local tpButton2 = teleportTab:CreateButton({
    Name = "・Téléportation (CLASS D)",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-97.20, -0.77, 197.52))
    end
})

local tpButton3 = teleportTab:CreateButton({
    Name = "・Spawn Staff",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-886.73, 144.87, -7.67))
    end
})

local tpButton4 = teleportTab:CreateButton({
    Name = "・Salle Staff 1",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-57.44, 156.48, 150.56))
    end
})

local tpButton5 = teleportTab:CreateButton({
    Name = "・Salle Staff 2",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-189.25, 154.44, 161.16))
    end
})

local tpButton6 = teleportTab:CreateButton({
    Name = "・Salle Staff 3",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-328.34, 154.96, 147.62))
    end
})

local tpButton7 = teleportTab:CreateButton({
    Name = "・Salle Staff 4",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-478.59, 158.68, 157.45))
    end
})

local tpButton8 = teleportTab:CreateButton({
    Name = "・Salle Staff 5",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-603.16, 157.61, 156.85))
    end
})

local tpButton9 = teleportTab:CreateButton({
    Name = "・Base OL",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-2477.78, 29.16, 2175.33))
    end
})

local tpButton10 = teleportTab:CreateButton({
    Name = "・Easter Eggs",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-1375.48, 384.34, 569.81))
    end
})

local tpButton11 = teleportTab:CreateButton({
    Name = "・Teleport-ZD",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-321.95, -13.47, -54.64))
    end
})

local tpButton12 = teleportTab:CreateButton({
    Name = "・Teleporte E.Z",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-892.00, 4.72, 424.17))
    end
})

local tpButton13 = teleportTab:CreateButton({
    Name = "・Teleporte extérieur",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-426.97, -12.06, 1198.04))
    end
})

local tpButton14 = teleportTab:CreateButton({
    Name = "・Spawn UT",
    Callback = function()
        local LocalPlayer = Players.LocalPlayer
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-337.45, 12.63, 204.40))
    end
})


local function findPlayer(partialName)
    local lowerPartialName = partialName:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #partialName) == lowerPartialName then
            return player
        end
    end
    return nil
end

local teleportInput = utilTab:CreateInput({
    Name = "Téléportation par pseudo",
    PlaceholderText = "Tapez les 3 premières lettres...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local player = findPlayer(text)
        if player then
            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Téléportation réussie",
                Content = "Vous avez été téléporté à " .. player.Name .. ".",
                Duration = 5,
            })
        else
            Rayfield:Notify({
                Title = "Erreur",
                Content = "Aucun joueur trouvé avec ce pseudo.",
                Duration = 5,
            })
        end
    end
})




local teleportButton = utilTab:CreateButton({
    Name = "Teleport All Players (spam Tab)",
    Callback = function()
        teleportPlayersInFront()
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport",
            Text = "Tout les joueurs sont tp devant vous sale noir.",
            Duration = 5,
        })
    end
})





local spectateTab = utilTab:CreateSection("Spectate")


local spectateInput = utilTab:CreateInput({
    Name = "Entrer 3 premières lettres du pseudo",
    PlaceholderText = "Tapez ici...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if not spectating then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Name:sub(1, #text):lower() == text:lower() then
                    spectatePlayer(player)
                    spectating = true
                    Rayfield:Notify({
                        Title = "Spectate",
                        Content = "Vous spectate maintenant " .. player.Name,
                        Duration = 5,
                    })
                    break
                end
            end
        end
    end
})


local stopSpectateButton = utilTab:CreateButton({
    Name = "Arrêter Spectate",
    Callback = function()
        if spectating then
            stopSpectating()
            spectating = false
            Rayfield:Notify({
                Title = "Spectate",
                Content = "Spectate arrêté.",
                Duration = 5,
            })
        else
            Rayfield:Notify({
                Title = "Spectate",
                Content = "Vous ne spectate personne.",
                Duration = 5,
            })
        end
    end
})






Rayfield:LoadConfiguration()```
