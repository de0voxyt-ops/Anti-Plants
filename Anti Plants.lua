local Workspace = game:GetService("Workspace")

local function destroy(inst)
    if inst then
        pcall(function()
            inst:Destroy()
        end)
    end
end

-- =========================
-- Gardens (Delete Forever)
-- =========================

local Gardens = Workspace:FindFirstChild("Gardens")

if Gardens then
    local function wipePlot(plot)
        destroy(plot)
    end

    for _, plot in ipairs(Gardens:GetChildren()) do
        wipePlot(plot)
    end

    Gardens.ChildAdded:Connect(wipePlot)

    task.spawn(function()
        while Gardens.Parent do
            task.wait(0.1)
            for _, plot in ipairs(Gardens:GetChildren()) do
                wipePlot(plot)
            end
        end
    end)
end

-- =========================
-- Map Cleanup
-- =========================

local Map = Workspace:FindFirstChild("Map")

if Map then
    destroy(Map:FindFirstChild("Middle"))
    destroy(Map:FindFirstChild("Stands"))
    destroy(Map:FindFirstChild("SafeZones"))
end

-- =========================
-- NPCs
-- =========================
destroy(Workspace:FindFirstChild("AuctionStand"))
destroy(Workspace:FindFirstChild("ExplorerStand"))
destroy(Workspace:FindFirstChild("NPCS"))

-- =========================
-- Visual Folders
-- =========================

for _, name in ipairs({
    "BirdVisuals",
    "Birds",
    "BlizzardBeams",
    "DroppedItems",
    "Fences",
    "LightingEffects",
    "GnomeVisuals",
}) do
    destroy(Workspace:FindFirstChild(name))
    if Map then
        destroy(Map:FindFirstChild(name))
    end
end

-- =========================
-- Destroy ALL Visual Effects
-- =========================

local visualClasses = {
    ParticleEmitter = true,
    Trail = true,
    Beam = true,
    Smoke = true,
    Fire = true,
    Sparkles = true,
    Highlight = true,
    SelectionBox = true,
    BoxHandleAdornment = true,
    SphereHandleAdornment = true,
    PointLight = true,
    SpotLight = true,
    SurfaceLight = true,
    Explosion = true,
}

task.spawn(function()
    while true do
        for _, obj in ipairs(game:GetDescendants()) do
            if visualClasses[obj.ClassName] then
                destroy(obj)
            end
        end
        task.wait(1)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                pcall(function()
                    player.Character:Destroy()
                end)
            end
        end
        task.wait(0.2)
    end
end)
