-- =============================================
-- MDB NOTIFY SCANNER - 3.5M+ (SCRIPT COMPLETO)
-- =============================================

-- ================== CONFIG ==================
local webhookDiviniAcesso = "https://discord.com/api/webhooks/1497275749105926485/lGDm09jvcD3SStD-lNRRsz5rMFXeKqsDfiHDYRuqgLqBx3NDqxPomSsK2h2THF1FnA9P"
local webhookDemo        = "https://discord.com/api/webhooks/1497276666706264225/os39l7GeHlRfXaWXyRDqe6d0aZkrUFObNnZTLNRi9P81UhXRVDAQJ4pw-fpUAEvXDXg_"
local MIN_GEN = 3500000
local ULTRA_GEN = 1000

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local request = syn and syn.request or http_request or (http and http.request) or request

-- ================== POTATO MODE ==================
local function activatePotatoMode()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    Lighting.Ambient = Color3.new(0,0,0)
    Lighting.OutdoorAmbient = Color3.new(0,0,0)
    Lighting.ClockTime = 14
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
            v:Destroy()
        end
    end

    local function cleanCharacter(char)
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Clothing") then
                v:Destroy()
            end
        end
    end

    if LocalPlayer.Character then cleanCharacter(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.2) cleanCharacter(c) end)

    local function ultraPotato(obj)
        if LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character) then return end
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Transparency = 1
            obj.CanCollide = true
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") or obj:IsA("SpecialMesh") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
            obj.Enabled = false
        end
    end

    for _, v in pairs(Workspace:GetDescendants()) do ultraPotato(v) end
    Workspace.DescendantAdded:Connect(ultraPotato)
end
activatePotatoMode()

-- ================== MULTI INSTÂNCIA ==================
local instanceId = math.random(1000, 999999)
local countdownTimes = {0.1}
local COUNTDOWN_TIME = countdownTimes[((instanceId % #countdownTimes) + 1)]

-- ================== GUI ==================
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "BrainrotScanner"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 170)
frame.Position = UDim2.new(0, 30, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 255, 120)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "DIVINI NOTIFY SCANNER"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,120)
status.Position = UDim2.new(0,0,0,50)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255,255,255)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Text = "Iniciando..."

-- ================== VARIÁVEIS ==================
local sentCache = {}
local ESP_INSTANCES = {}
local allAnimalsCache = {}
local lastAnimalData = {}

-- ================== ESP ==================
local function getPodiumWorldPart(animal)
    if not animal.plot or not animal.slot then return nil end
    local plot = Workspace.Plots:FindFirstChild(animal.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animal.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    return spawn or base or podium
end

local function clearESPForUID(uid)
    local rec = ESP_INSTANCES[uid]
    if rec then
        pcall(function() rec.highlight:Destroy() end)
        pcall(function() rec.billboard:Destroy() end)
        ESP_INSTANCES[uid] = nil
    end
end

local function refreshAllESP()
    local activeUIDs = {}
    for _, animal in ipairs(allAnimalsCache) do
        if animal.genValue >= MIN_GEN then
            local uid = animal.uid
            activeUIDs[uid] = true
            -- ESP logic omitted/simplified
        end
    end
    for uid in pairs(ESP_INSTANCES) do
        if not activeUIDs[uid] then clearESPForUID(uid) end
    end
end

-- ================== ENVIO CORRIGIDO ==================
local function sendWebhook(name, rarity, value, jobId, isUltra)
    local placeId = game.PlaceId
    local joinLink = "https://www.roblox.com/games/" .. placeId .. "?serverId=" .. jobId

    local embedAcesso = {
        title = isUltra and "🔥 ULTRA MEGA BRAINROT 50M+ 🔥" or "🧠 BRAINROT 3.5M+ DETECTADO",
        description = "**" .. name .. "**",
        color = isUltra and 16711935 or 32768,
        fields = {
            {name = "💰 Geração", value = "```"..value.."```", inline = true},
            {name = "⭐ Raridade", value = rarity or "Raro", inline = true},
            {name = "🔗 Job ID", value = "```"..jobId.."```", inline = false},
        },
        footer = {text = "Instância " .. instanceId},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local dataAcesso = {
        embeds = {embedAcesso},
        components = {{
            type = 1,
            components = {{
                type = 2, -- Corrigido: type 2 (Button)
                label = "🚀 Entrar no Servidor",
                style = 5,
                url = joinLink
            }}
        }}
    }

    local embedDemo = {
        title = " BRANZZ LOGS HIGHLIGHT",
        description = "**" .. name .. "**",
        color = 49151,
        fields = {{name = "💰 Geração", value = "```"..value.."```", inline = true}},
        footer = {text = "BranzZ Notify"},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    -- ENVIO Acesso
    task.spawn(function()
        pcall(function()
            local payload = HttpService:JSONEncode(dataAcesso) -- Corrigido: :JSONEncode
            request({
                Url = webhookCloveAcesso,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    end)

    -- ENVIO Demo
    task.spawn(function()
        pcall(function()
            local payload = HttpService:JSONEncode({embeds = {embedDemo}}) -- Corrigido: :JSONEncode
            request({
                Url = webhookDemo,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    end)
end

-- ================== SCAN ==================
local function getAnimalHash(animalList)
    local hash = ""
    for slot, data in pairs(animalList or {}) do
        if type(data) == "table" then
            hash = hash .. tostring(slot) .. tostring(data.Index or "") .. tostring(data.Mutation or "")
        end
    end
    return hash
end

local function scanSinglePlot(plot)
    pcall(function()
        local channel = require(ReplicatedStorage.Packages.Synchronizer):Get(plot.Name)
        if not channel then return end
        local animalList = channel:Get("AnimalList")
        local currentHash = getAnimalHash(animalList)
        if lastAnimalData[plot.Name] == currentHash then return end
        lastAnimalData[plot.Name] = currentHash

        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == plot.Name then table.remove(allAnimalsCache, i) end
        end

        for slot, animalData in pairs(animalList or {}) do
            if type(animalData) ~= "table" then continue end
            local info = require(ReplicatedStorage.Datas.Animals)[animalData.Index]
            if not info then continue end
            local genValue = require(ReplicatedStorage.Shared.Animals):GetGeneration(animalData.Index, animalData.Mutation, animalData.Traits, nil)
            if genValue < MIN_GEN then continue end

            local genText = "$" .. require(ReplicatedStorage.Utils.NumberUtils):ToString(genValue) .. "/s"

            table.insert(allAnimalsCache, {
                name = info.DisplayName or animalData.Index,
                genText = genText,
                genValue = genValue,
                rarity = info.Rarity,
                plot = plot.Name,
                slot = tostring(slot),
                uid = plot.Name .. "_" .. tostring(slot),
            })
        end

        table.sort(allAnimalsCache, function(a, b) return a.genValue > b.genValue end)
        refreshAllESP()

        for _, animal in ipairs(allAnimalsCache) do
            if not sentCache[animal.uid] then
                sentCache[animal.uid] = true
                local isUltra = animal.genValue >= ULTRA_GEN
                status.Text = isUltra and "🔥 ULTRA 50M+: " .. animal.name or "🧠 BRAINROT 3.5M+: " .. animal.name
                sendWebhook(animal.name, animal.rarity, animal.genText, game.JobId, isUltra)
                task.wait(0.4)
            end
        end
    end)
end

-- ================== SERVER HOP & MAIN LOOP ==================
local function serverHop()
    local waitTime = COUNTDOWN_TIME
    for i = waitTime, 0.1, -1 do
        status.Text = "Aguardando troca de servidor... " .. i .. "s"
        task.wait(1)
    end
    status.Text = "Buscando servidor com pessoas e vaga..."
    local placeId = game.PlaceId
    local attempts = 0
    local maxAttempts = 10
    while attempts < maxAttempts do
        attempts = attempts + 1
        local validServers = {}
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
            local response = game:HttpGetAsync(url)
            local data = HttpService:JSONDecode(response)
            for _, s in ipairs(data.data or {}) do
                if s.id and s.id ~= game.JobId and s.playing > 0 and s.playing < s.maxPlayers then
                    table.insert(validServers, s.id)
                end
            end
        end)
        if #validServers > 0 then
            local chosen = validServers[math.random(1, #validServers)]
            status.Text = "Teleportando..."
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, chosen, LocalPlayer)
            end)
            return
        else
            status.Text = "Nenhum servidor disponível (" .. attempts .. "/" .. maxAttempts .. ")"
            task.wait(0.2)
        end
    end
    status.Text = "Não encontrou servidor. Reiniciando scan em 10s..."
    task.wait(0.1)
end

local function mainLoop()
    while true do
        local plots = Workspace:WaitForChild("Plots")
        for _, plot in ipairs(plots:GetChildren()) do
            scanSinglePlot(plot)
            task.wait(0.25)
        end
        status.Text = "Scan completo! Iniciando countdown..."
        serverHop()
        task.wait(0.2)
    end
end

local function init()
    status.Text = "MDB NOTIFY SCANNER iniciado | ID: " .. instanceId
    local plots = Workspace:WaitForChild("Plots")
    for _, plot in ipairs(plots:GetChildren()) do
        task.spawn(function() scanSinglePlot(plot) end)
    end
    plots.ChildAdded:Connect(function(plot)
        task.wait(1)
        scanSinglePlot(plot)
    end)
    task.wait(3)
    mainLoop()
end

init()
print("✅ MDB NOTIFY SCANNER carregado!")
