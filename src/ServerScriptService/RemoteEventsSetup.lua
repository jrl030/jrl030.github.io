-- RemoteEventsSetup.lua
-- Place this script in ServerScriptService to automatically create RemoteEvents

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvents folder if it doesn't exist
local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEventsFolder then
    remoteEventsFolder = Instance.new("Folder")
    remoteEventsFolder.Name = "RemoteEvents"
    remoteEventsFolder.Parent = ReplicatedStorage
end

-- Create DestroyItem RemoteEvent if it doesn't exist
local destroyItemEvent = remoteEventsFolder:FindFirstChild("DestroyItem")
if not destroyItemEvent then
    destroyItemEvent = Instance.new("RemoteEvent")
    destroyItemEvent.Name = "DestroyItem"
    destroyItemEvent.Parent = remoteEventsFolder
    print("Created DestroyItem RemoteEvent")
end

print("RemoteEvents setup complete")