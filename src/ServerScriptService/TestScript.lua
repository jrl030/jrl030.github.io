-- TestScript.lua
-- A simple test script to demonstrate the inventory destruction functionality
-- Place this in ServerScriptService for testing purposes

local Players = game:GetService("Players")

-- Function to give a player a test light stick
local function giveTestLightStick(player, lightStickName)
    -- Create the tool
    local tool = Instance.new("Tool")
    tool.Name = lightStickName
    tool.RequiresHandle = true
    
    -- Create a simple handle
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.2, 1, 0.2)
    handle.Material = Enum.Material.Neon
    handle.BrickColor = BrickColor.new("Bright blue")
    handle.CanCollide = false
    handle.Parent = tool
    
    -- Add to player's backpack
    tool.Parent = player:WaitForChild("Backpack")
    
    -- Add to OwnedLightSticks folder
    local ownedLightSticks = player:WaitForChild("OwnedLightSticks")
    local stringValue = Instance.new("StringValue")
    stringValue.Value = lightStickName
    stringValue.Name = lightStickName
    stringValue.Parent = ownedLightSticks
    
    print("Gave " .. player.Name .. " a " .. lightStickName)
end

-- Give test items when players join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(2) -- Wait for everything to load
        
        -- Give some test light sticks
        giveTestLightStick(player, "BlueLightStick")
        giveTestLightStick(player, "RedLightStick")
        giveTestLightStick(player, "GreenLightStick")
        
        print("Test items given to " .. player.Name)
    end)
end)

print("Test script loaded - players will receive test light sticks when they spawn")