-- Xeno Client-Side Visual Monitoring Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Clean up any previous trackers to avoid lag
for _, oldObj in ipairs(workspace:GetDescendants()) do
    if oldObj.Name == "XenoESPTracker" then
        oldObj:Destroy()
    end
end

-- Function to handle local tracking visuals
local function createESP(player)
    if player == LocalPlayer then return end

    local function applyVisuals(character)
        -- Wait for character parts to load safely
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        
        -- Remove old tracker instance if it exists
        if character:FindFirstChild("XenoESPTracker") then
            character.XenoESPTracker:Destroy()
        end

        -- Create Client-Side Highlight object
        local highlight = Instance.new("Highlight")
        highlight.Name = "XenoESPTracker"
        highlight.FillColor = Color3.fromRGB(255, 30, 30) -- Bright Red for opponents
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White border
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Force render through walls
        
        highlight.Parent = character
    end

    if player.Character then
        task.spawn(applyVisuals, player.Character)
    end
    player.CharacterAdded:Connect(applyVisuals)
end

-- Run loop for all active players in the lobby
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

-- Automatically catch new players connecting to the server
Players.PlayerAdded:Connect(createESP)




