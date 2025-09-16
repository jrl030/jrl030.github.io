-- InventoryGUI.lua
-- Example inventory GUI creation script for demonstration purposes

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main inventory GUI
local inventoryGui = Instance.new("ScreenGui")
inventoryGui.Name = "InventoryGui"
inventoryGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
inventoryGui.Parent = playerGui

-- Main inventory frame
local inventoryFrame = Instance.new("Frame")
inventoryFrame.Name = "InventoryFrame"
inventoryFrame.Size = UDim2.new(0, 400, 0, 300)
inventoryFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
inventoryFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
inventoryFrame.BorderSizePixel = 2
inventoryFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
inventoryFrame.Visible = false
inventoryFrame.Parent = inventoryGui

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Inventory"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = inventoryFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = inventoryFrame

-- Scroll frame for items
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ItemsScrollFrame"
scrollFrame.Size = UDim2.new(1, -10, 1, -50)
scrollFrame.Position = UDim2.new(0, 5, 0, 45)
scrollFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
scrollFrame.BorderSizePixel = 1
scrollFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
scrollFrame.ScrollBarThickness = 12
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = inventoryFrame

-- Grid layout for items
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 80, 0, 80)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.SortOrder = Enum.SortOrder.Name
gridLayout.Parent = scrollFrame

-- Function to create an item frame
local function createItemFrame(itemName, imagePath)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "ItemFrame"
    itemFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    itemFrame.BorderSizePixel = 1
    itemFrame.BorderColor3 = Color3.fromRGB(120, 120, 120)
    
    -- Item image
    local itemImage = Instance.new("ImageLabel")
    itemImage.Name = "ItemImage"
    itemImage.Size = UDim2.new(1, -10, 1, -30)
    itemImage.Position = UDim2.new(0, 5, 0, 5)
    itemImage.BackgroundTransparency = 1
    itemImage.Image = imagePath or ""
    itemImage.ScaleType = Enum.ScaleType.Fit
    itemImage.Parent = itemFrame
    
    -- Item name label
    local itemNameLabel = Instance.new("TextLabel")
    itemNameLabel.Name = "ItemName"
    itemNameLabel.Size = UDim2.new(1, 0, 0, 20)
    itemNameLabel.Position = UDim2.new(0, 0, 1, -25)
    itemNameLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemNameLabel.BorderSizePixel = 0
    itemNameLabel.Text = itemName
    itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemNameLabel.TextScaled = true
    itemNameLabel.Font = Enum.Font.SourceSans
    itemNameLabel.Parent = itemFrame
    
    itemFrame.Parent = scrollFrame
    return itemFrame
end

-- Function to populate inventory with sample items
local function populateInventory()
    local ownedLightSticks = player:FindFirstChild("OwnedLightSticks")
    if ownedLightSticks then
        for _, stringValue in pairs(ownedLightSticks:GetChildren()) do
            if stringValue:IsA("StringValue") then
                createItemFrame(stringValue.Value, "rbxassetid://123456789") -- Placeholder image
            end
        end
    end
    
    -- Update canvas size
    local contentSize = gridLayout.AbsoluteContentSize
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
end

-- Function to toggle inventory visibility
local function toggleInventory()
    inventoryFrame.Visible = not inventoryFrame.Visible
    if inventoryFrame.Visible then
        populateInventory()
    else
        -- Clear items when closing
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end
end

-- Connect close button
closeButton.MouseButton1Click:Connect(function()
    inventoryFrame.Visible = false
    -- Clear items when closing
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end)

-- Example: Bind to a key to open inventory (E key)
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
        toggleInventory()
    end
end)

print("Inventory GUI loaded. Press E to open/close inventory.")