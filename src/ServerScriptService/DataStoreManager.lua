-- DataStoreManager.lua
-- Server script to handle DataStore operations and inventory management

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playerDataStore = DataStoreService:GetDataStore("PlayerData")

-- RemoteEvents
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local destroyItemEvent = remoteEvents:WaitForChild("DestroyItem")

-- Function to save player data
local function savePlayerData(player)
    local success, errorMessage = pcall(function()
        local playerData = {}
        local ownedLightSticks = player:FindFirstChild("OwnedLightSticks")
        
        if ownedLightSticks then
            local lightStickData = {}
            for _, stringValue in pairs(ownedLightSticks:GetChildren()) do
                if stringValue:IsA("StringValue") then
                    table.insert(lightStickData, stringValue.Value)
                end
            end
            playerData.OwnedLightSticks = lightStickData
        end
        
        playerDataStore:SetAsync(player.UserId, playerData)
    end)
    
    if not success then
        warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
    end
end

-- Function to load player data
local function loadPlayerData(player)
    local success, playerData = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and playerData then
        -- Create OwnedLightSticks folder if it doesn't exist
        local ownedLightSticks = player:FindFirstChild("OwnedLightSticks")
        if not ownedLightSticks then
            ownedLightSticks = Instance.new("Folder")
            ownedLightSticks.Name = "OwnedLightSticks"
            ownedLightSticks.Parent = player
        end
        
        -- Load light stick data
        if playerData.OwnedLightSticks then
            for _, lightStickName in pairs(playerData.OwnedLightSticks) do
                local stringValue = Instance.new("StringValue")
                stringValue.Value = lightStickName
                stringValue.Name = lightStickName
                stringValue.Parent = ownedLightSticks
            end
        end
    else
        -- Create empty OwnedLightSticks folder for new players
        local ownedLightSticks = Instance.new("Folder")
        ownedLightSticks.Name = "OwnedLightSticks"
        ownedLightSticks.Parent = player
    end
end

-- Handle item destruction from client
destroyItemEvent.OnServerEvent:Connect(function(player, itemName)
    local ownedLightSticks = player:FindFirstChild("OwnedLightSticks")
    if ownedLightSticks then
        local itemStringValue = ownedLightSticks:FindFirstChild(itemName)
        if itemStringValue then
            itemStringValue:Destroy()
            print("Server: Removed " .. itemName .. " from " .. player.Name .. "'s OwnedLightSticks")
            
            -- Immediately save the updated data
            savePlayerData(player)
        end
    end
end)

-- Player joined
Players.PlayerAdded:Connect(function(player)
    loadPlayerData(player)
end)

-- Player leaving
Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)

-- Auto-save every 5 minutes
while true do
    wait(300) -- 5 minutes
    for _, player in pairs(Players:GetPlayers()) do
        savePlayerData(player)
    end
    print("Auto-saved all player data")
end