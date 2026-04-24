-- ================================================
-- BRAINROT DETECTOR PRO - by BranzZ
-- ================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- ================================================
-- CONFIG
-- ================================================

local WEBHOOK_1 = "https://discord.com/api/webhooks/1497275749105926485/lGDm09jvcD3SStD-lNRRsz5rMFXeKqsDfiHDYRuqgLqBx3NDqxPomSsK2h2THF1FnA9P"
local WEBHOOK_2 = "https://discord.com/api/webhooks/1497276666706264225/os39l7GeHlRfXaWXyRDqe6d0aZkrUFObNnZTLNRi9P81UhXRVDAQJ4pw-fpUAEvXDXg_"

local MIN_GEN   = 1000   -- 1M
local ULTRA_GEN = 5000000   -- 5M

local PLACE_ID = tostring(game.PlaceId)
local JOB_ID   = tostring(game.JobId)

-- ================================================
-- ESTADO
-- ================================================

local allAnimalsCache = {}
local lastAnimalData  = {}
local sentCache       = {}
local ESP_INSTANCES   = {}

-- ================================================
-- UTILS
-- ================================================

local function getJoinLink()
    return "https://v0-roblox-deep-link-app.vercel.app//?placeId="
        .. PLACE_ID
        .. "&gameInstanceId="
        .. JOB_ID
end

local function getPlayerCount()
    return #Players:GetPlayers()
end

local function formatGen(val)
    if val >= 1000000000 then
        return string.format("%.2fB/s", val / 1000000000)
    elseif val >= 1000000 then
        return string.format("%.2fM/s", val / 1000000)
    elseif val >= 1000 then
        return string.format("%.1fK/s", val / 1000)
    end
    return tostring(val) .. "/s"
end

local function httpPost(url, payload)
    pcall(function()
        HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
    end)
end

-- ================================================
-- WEBHOOKS
-- ================================================

local function sendWebhooks(detectedAnimals)
    if #detectedAnimals == 0 then return end

    local best        = detectedAnimals[1]
    local joinLink    = getJoinLink()
    local playerCount = getPlayerCount()

    -- Monta lista de brainrots (do maior pro menor)
    local brainrotList = ""
    for i, animal in ipairs(detectedAnimals) do
        local emoji = (animal.genValue >= ULTRA_GEN) and "🔥" or "🧠"
        brainrotList = brainrotList .. emoji .. " **" .. animal.name .. "** — `" .. formatGen(animal.genValue) .. "`\n"
    end

    -- ============================================================
    -- WEBHOOK 1 — Embed completo com botão de join
    -- ============================================================
    local embed1 = {
        title = "🔥 New Brainrot OP Detected",
        color = (best.genValue >= ULTRA_GEN) and 0xFF4500 or 0x9B59B6,
        fields = {
            {
                name   = "🔥 Best Brainrot",
                value  = "**" .. best.name .. "** — `" .. formatGen(best.genValue) .. "`",
                inline = false
            },
            {
                name   = "👥 Players in Server",
                value  = tostring(playerCount),
                inline = true
            },
            {
                name   = "🔥 Brainrots Detected",
                value  = brainrotList ~= "" and brainrotList or "N/A",
                inline = false
            },
            {
                name   = "🔗 Link do Servidor",
                value  = "[**Join in the Server for Brainrots**](" .. joinLink .. ")",
                inline = false
            },
        },
        footer = {
            text = "PlaceId: " .. PLACE_ID .. " | JobId: " .. JOB_ID
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload1 = {
        content  = "# New Brainrot OP Detected",
        embeds   = { embed1 }
    }

    -- ============================================================
    -- WEBHOOK 2 — Resumido
    -- ============================================================
    local otherList = ""
    for i = 2, #detectedAnimals do
        local animal = detectedAnimals[i]
        otherList = otherList .. "• **" .. animal.name .. "** — `" .. formatGen(animal.genValue) .. "`\n"
    end

    local embed2 = {
        title = "🧠 New Brainrot Found",
        color = 0x00BFFF,
        fields = {
            {
                name   = "🔥 Best Brainrot",
                value  = "**" .. best.name .. "** — `" .. formatGen(best.genValue) .. "`",
                inline = false
            },
            {
                name   = "🧠 Other Brainrots",
                value  = otherList ~= "" and otherList or "Nenhum outro detectado.",
                inline = false
            },
        },
        footer = {
            text = "PlaceId: " .. PLACE_ID .. " | JobId: " .. JOB_ID
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local payload2 = {
        content = "# New Brainrot Found",
        embeds  = { embed2 }
    }

    -- Envia os 2 ao mesmo tempo
    task.spawn(function() httpPost(WEBHOOK_1, payload1) end)
    task.spawn(function() httpPost(WEBHOOK_2, payload2) end)
end

-- ================================================
-- ESP
-- ================================================

local function getPodiumWorldPart(animal)
    if not animal.plot or not animal.slot then return nil end
    local plot = Workspace.Plots:FindFirstChild(animal.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animal.slot)
    if not podium then return nil end
    local base  = podium:FindFirstChild("Base")
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
            activeUIDs[animal.uid] = true
        end
    end
    for uid in pairs(ESP_INSTANCES) do
        if not activeUIDs[uid] then
            clearESPForUID(uid)
        end
    end
end

-- ================================================
-- SCAN
-- ================================================

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

        local animalList    = channel:Get("AnimalList")
        local currentHash   = getAnimalHash(animalList)

        if lastAnimalData[plot.Name] == currentHash then return end
        lastAnimalData[plot.Name] = currentHash

        -- Remove animais antigos desse plot
        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == plot.Name then
                table.remove(allAnimalsCache, i)
            end
        end

        -- Adiciona novos
        for slot, animalData in pairs(animalList or {}) do
            if type(animalData) ~= "table" then continue end

            local info = require(ReplicatedStorage.Datas.Animals)[animalData.Index]
            if not info then continue end

            local genValue = require(ReplicatedStorage.Shared.Animals):GetGeneration(
                animalData.Index,
                animalData.Mutation,
                animalData.Traits,
                nil
            )

            if genValue < MIN_GEN then continue end

            table.insert(allAnimalsCache, {
                name     = info.DisplayName or animalData.Index,
                genText  = formatGen(genValue),
                genValue = genValue,
                rarity   = info.Rarity,
                plot     = plot.Name,
                slot     = tostring(slot),
                uid      = plot.Name .. "_" .. tostring(slot),
            })
        end

        -- Ordena do maior pro menor
        table.sort(allAnimalsCache, function(a, b) return a.genValue > b.genValue end)
        refreshAllESP()

        -- Coleta novos pra enviar
        local toSend = {}
        for _, animal in ipairs(allAnimalsCache) do
            if not sentCache[animal.uid] then
                sentCache[animal.uid] = true
                table.insert(toSend, animal)
            end
        end

        -- Envia webhooks com TODOS os novos de uma vez
        if #toSend > 0 then
            sendWebhooks(toSend)
        end
    end)
end

-- ================================================
-- LOOP PRINCIPAL
-- ================================================

local function startScan()
    print("[BranzZ] Iniciando scan — MIN: " .. formatGen(MIN_GEN) .. " | ULTRA: " .. formatGen(ULTRA_GEN))
    print("[BranzZ] JobId: " .. JOB_ID)
    print("[BranzZ] Join: " .. getJoinLink())

    while true do
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                task.spawn(scanSinglePlot, plot)
            end
        end
        task.wait(3)
    end
end

startScan()
