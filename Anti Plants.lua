--// Ultimate FPS Optimizer (Optimized)

repeat task.wait() until game:IsLoaded()
task.wait(10) -- Wait for everything to load

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function destroy(inst)
    if inst and inst.Parent then
        pcall(function()
            inst:Destroy()
        end)
    end
end

--========================--
-- Gardens
--========================--

local Gardens = Workspace:FindFirstChild("Gardens")

if Gardens then
    local function wipePlot(plot)
        destroy(plot)
    end

    -- Existing plots
    for _, plot in ipairs(Gardens:GetChildren()) do
        wipePlot(plot)
    end

    -- Future plots
    Gardens.ChildAdded:Connect(wipePlot)

    -- Occasionally check for recreated plots
    task.spawn(function()
        while Gardens.Parent do
            task.wait(0.5)
            for _, plot in ipairs(Gardens:GetChildren()) do
                wipePlot(plot)
            end
        end
    end)
end

task.wait(0.25)

--========================--
-- Map Cleanup
--========================--

local Map = Workspace:FindFirstChild("Map")

if Map then
    destroy(Map:FindFirstChild("Middle"))
    destroy(Map:FindFirstChild("Stands"))
    destroy(Map:FindFirstChild("SafeZones"))
end

task.wait(0.25)

--========================--
-- NPCs / Shops
--========================--

destroy(Workspace:FindFirstChild("AuctionStand"))
destroy(Workspace:FindFirstChild("ExplorerStand"))
destroy(Workspace:FindFirstChild("NPCS"))

task.wait(0.25)

--========================--
-- Visual Folders
--========================--

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

task.wait(0.25)

--========================--
-- Visual Effects
--========================--

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

local function cleanupVisual(obj)
    if visualClasses[obj.ClassName] then
        destroy(obj)
    end
end

-- Existing effects
for _, obj in ipairs(game:GetDescendants()) do
    cleanupVisual(obj)
end

-- Future effects
game.DescendantAdded:Connect(cleanupVisual)

task.wait(0.25)

--========================--
-- Remove Other Players
--========================--

local function removeCharacter(character)
    if character and character.Parent then
        destroy(character)
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then
        return
    end

    if player.Character then
        removeCharacter(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        removeCharacter(char)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)
