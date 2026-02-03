local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local COLOR = Color3.fromRGB(0,255,0)
local NAME = "ESP_Uncommon"
local RARITY = "Uncommon"

-- Only add ESP if the block matches the rarity
local function addESP(part)
    local function getRarity(p)
        if p.Parent and p.Parent.Name == "Common" then
            return "Common"
        end
        return nil
    end

    local rarity = getRarity(part)
    if not rarity then return end -- EXIT if not Common

    -- Create Highlight
    if part:FindFirstChild(NAME) then return end
    local h = Instance.new("Highlight")
    h.Name = NAME
    h.FillColor = COLOR
    h.OutlineColor = COLOR
    h.FillTransparency = 0.7
    h.Adornee = part
    h.Parent = part

    -- Create Billboard
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

    -- Update distance and label
    task.spawn(function()
        while part.Parent do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local d = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                t.Text = rarity.."\n"..math.floor(d).."m"
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
