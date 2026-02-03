local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- CONFIG: edit these only if needed
local COLOR = Color3.fromRGB(255,255,255) -- White
local RARITY = "Common"
local NAME = "ESP_"..RARITY

local function addESP(part)
    -- Only add ESP if the block matches the rarity
    if part:FindFirstChild(NAME) then return end
    if not (part.Parent and part.Parent.Name == RARITY) then return end

    -- Highlight
    local h = Instance.new("Highlight")
    h.Name = NAME
    h.FillColor = COLOR
    h.OutlineColor = COLOR
    h.FillTransparency = 0.7
    h.Adornee = part
    h.Parent = part

    -- Billboard
    local g = Instance.new("BillboardGui")
    g.Name = NAME.."_GUI"
    g.Size = UDim2.new(0,140,0,30)
    g.StudsOffset = Vector3.new(0,2.5,0)
    g.AlwaysOnTop = true
    g.Adornee = part
    g.Parent = part

    local t = Instance.new("TextLabel")
    t.Size = UDim2.fromScale(1,1)
    t.BackgroundTransparency = 1
    t.TextColor3 = COLOR
    t.TextStrokeTransparency = 0
    t.Font = Enum.Font.Arcade
    t.TextSize = 14
    t.Parent = g

    -- Update label with distance
    task.spawn(function()
        while part.Parent do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local d = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                t.Text = RARITY.."\n"..math.floor(d).."m"
            end
            task.wait(0.1)
        end
    end)
end

-- SCAN NORMAL BLOCKS
for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Name == "mark" then
        addESP(obj)
    end
end

-- SCAN MUTATIONS
local mutationsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Lighting"):WaitForChild("Mutations")
for _, obj in ipairs(mutationsFolder:GetDescendants()) do
    if obj:IsA("BasePart") then
        addESP(obj)
    end
end

-- AUTO-DETECT NEW BLOCKS
Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") and obj.Name == "mark" then
        task.wait()
        addESP(obj)
    end
end)

mutationsFolder.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") then
        task.wait()
        addESP(obj)
    end
end)
