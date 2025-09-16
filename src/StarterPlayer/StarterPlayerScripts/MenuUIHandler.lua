-- MenuUIHandler.lua
-- Client script to handle inventory menu and item destruction

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvents
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local destroyItemEvent = remoteEvents:WaitForChild("DestroyItem")

-- Function to destroy an item from inventory
local function destroyInventoryItem(itemName)
    -- Step 1: Remove the item from player's Tools (existing behavior)
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character
    
    -- Check in backpack
    local toolInBackpack = backpack:FindFirstChild(itemName)
    if toolInBackpack then
        toolInBackpack:Destroy()
        print("Client: Removed " .. itemName .. " from backpack")
    end
    
    -- Check if equipped (in character)
    if character then
        local equippedTool = character:FindFirstChild(itemName)
        if equippedTool and equippedTool:IsA("Tool") then
            equippedTool:Destroy()
            print("Client: Removed equipped " .. itemName .. " from character")
        end
    end
    
    -- Step 2: Find and remove the corresponding StringValue in OwnedLightSticks folder
    local ownedLightSticks = player:FindFirstChild("OwnedLightSticks")
    if ownedLightSticks then
        local itemStringValue = ownedLightSticks:FindFirstChild(itemName)
        if itemStringValue then
            itemStringValue:Destroy()
            print("Client: Removed " .. itemName .. " from OwnedLightSticks folder")
        end
    end
    
    -- Step 3: Communicate the deletion to the server for immediate DataStore sync
    destroyItemEvent:FireServer(itemName)
    print("Client: Sent destroy request to server for " .. itemName)
end

-- Example of how this would be connected to UI buttons
-- This function would be called when a destroy button is clicked in the inventory menu
local function setupInventoryMenu()
    -- Wait for the inventory GUI to be created
    local inventoryGui = playerGui:WaitForChild("InventoryGui", 10)
    if not inventoryGui then
        warn("InventoryGui not found in PlayerGui")
        return
    end
    
    local inventoryFrame = inventoryGui:WaitForChild("InventoryFrame", 5)
    if not inventoryFrame then
        warn("InventoryFrame not found in InventoryGui")
        return
    end
    
    -- Function to create destroy buttons for each item
    local function createDestroyButton(itemFrame, itemName)
        local destroyButton = Instance.new("TextButton")
        destroyButton.Name = "DestroyButton"
        destroyButton.Size = UDim2.new(0, 80, 0, 25)
        destroyButton.Position = UDim2.new(1, -85, 1, -30)
        destroyButton.Text = "Destroy"
        destroyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        destroyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        destroyButton.BorderSizePixel = 1
        destroyButton.BorderColor3 = Color3.fromRGB(200, 50, 50)
        destroyButton.Parent = itemFrame
        
        -- Connect the destroy functionality
        destroyButton.MouseButton1Click:Connect(function()
            -- Confirm dialog could be added here
            destroyInventoryItem(itemName)
            
            -- Remove the item frame from the UI
            itemFrame:Destroy()
        end)
    end
    
    -- Monitor for new item frames being added to the inventory
    local function onChildAdded(child)
        if child:IsA("Frame") and child.Name == "ItemFrame" then
            local itemNameLabel = child:FindFirstChild("ItemName")
            if itemNameLabel and itemNameLabel:IsA("TextLabel") then
                local itemName = itemNameLabel.Text
                
                -- Only add destroy button if one doesn't already exist
                if not child:FindFirstChild("DestroyButton") then
                    createDestroyButton(child, itemName)
                end
            end
        end
    end
    
    -- Connect to existing and future item frames
    for _, child in pairs(inventoryFrame:GetChildren()) do
        onChildAdded(child)
    end
    
    inventoryFrame.ChildAdded:Connect(onChildAdded)
end

-- Setup the inventory menu when the script loads
setupInventoryMenu()

-- Export the destroy function for external use if needed
return {
    destroyInventoryItem = destroyInventoryItem
}