Script Rayfield Check Staff : 

```
local staffRoles = {"mod", "admin", "staff", "dev", "founder", "owner", "manager", "director"}
local groupId = game.CreatorId


--// Détection de staff \\--

local function checkForStaff()
    local foundStaff = {}

    for _, player in pairs(game.Players:GetPlayers()) do
        local role = player:GetRoleInGroup(groupId):lower()
        for _, staffKeyword in ipairs(staffRoles) do
            if string.find(role, staffKeyword) then
                table.insert(foundStaff, player.Name .. " (" .. role .. ")")
                break
            end
        end
    end

    

--// La Notification \\--
    if #foundStaff > 0 then
        Rayfield:Notify({
            Title = "Staff détecté",
            Content = table.concat(foundStaff, "\n"),
            Duration = 5,
            Image = 4483362458, 
        })
    else
        Rayfield:Notify({
            Title = "Aucun staff trouvé",
            Content = "Aucun staff détecté.",
            Duration = 5,
        })
    end
end


utilTab:CreateButton({
    Name = "Vérifier les staff",
    Callback = function()
        checkForStaff()
    end,
})


--// Systeme quand une personne join \\--

game.Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Wait()

    local role = player:GetRoleInGroup(groupId):lower()
    for _, staffKeyword in ipairs(staffRoles) do
        if string.find(role, staffKeyword) then
        
            Rayfield:Notify({
                Title = "Staff rejoint",
                Content = player.Name .. " a rejoint avec le rôle : " .. role,
                Duration = 5,
                Image = 4483362458, 
            })
            break
        end
    end
end)```
