-- ================================================
-- BRAINROT DETECTOR PRO - by BranzZ
-- ================================================

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")

-- ================================================
-- CONFIG
-- ================================================

local WEBHOOK_NOTIFY = "https://discord.com/api/webhooks/1497275749105926485/lGDm09jvcD3SStD-lNRRsz5rMFXeKqsDfiHDYRuqgLqBx3NDqxPomSsK2h2THF1FnA9P"
local WEBHOOK_DEMO   = "https://discord.com/api/webhooks/1497276666706264225/os39l7GeHlRfXaWXyRDqe6d0aZkrUFObNnZTLNRi9P81UhXRVDAQJ4pw-fpUAEvXDXg_"

local MIN_GEN   = 1000
local ULTRA_GEN = 5000000

local PLACE_ID = tostring(game.PlaceId)
local JOB_ID   = tostring(game.JobId)

-- ================================================
-- ESTADO
-- ================================================

local allAnimalsCache  = {}
local lastAnimalData   = {}
local sentCache        = {}
local ESP_INSTANCES    = {}
local jaEnviouServidor = false  -- bloqueia reenvio no mesmo servidor

-- ================================================
-- HTTP — TODOS OS MÉTODOS
-- ================================================

local function httpPost(url, payload)
    local body    = HttpService:JSONEncode(payload)
    local headers = { ["Content-Type"] = "application/json" }
    local sent    = false

    if not sent then
        pcall(function()
            request({ Url = url, Method = "POST", Headers = headers, Body = body })
            sent = true
        end)
    end
    if not sent then
        pcall(function()
            http.request({ Url = url, Method = "POST", Headers = headers, Body = body })
            sent = true
        end)
    end
    if not sent then
        pcall(function()
            syn.request({ Url = url, Method = "POST", Headers = headers, Body = body })
            sent = true
        end)
    end
    if not sent then
        pcall(function()
            HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
            sent = true
        end)
    end

    if not sent then warn("[BranzZ] FALHA em todos os métodos HTTP!") end
    return sent
end

-- ================================================
-- UTILS
-- ================================================

local function getJoinLink()
    return "https://v0-roblox-deep-link-app.vercel.app//?placeId="
        .. PLACE_ID .. "&gameInstanceId=" .. JOB_ID
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

-- ================================================
-- RARIDADE
-- ================================================

local RARITY_EMOJI = {
    ["Common"]    = "⚪",
    ["Uncommon"]  = "🟢",
    ["Rare"]      = "🔵",
    ["Epic"]      = "🟣",
    ["Legendary"] = "🟡",
    ["Mythic"]    = "🔴",
    ["Secret"]    = "✨",
    ["OG"]        = "👑",
}

local function getRarityEmoji(rarity)
    return RARITY_EMOJI[rarity] or "❓"
end

local function getEmbedColor()
    return 0xC9A6F5 -- roxo pastel em todas
end

-- ================================================
-- CONSOLE LOG
-- ================================================

local function logDetected(animals)
    print("╔══════════════════════════════════════╗")
    print("║     🧠 BRAINROTS DETECTADOS          ║")
    print("╠══════════════════════════════════════╣")
    for i, animal in ipairs(animals) do
        local mutation = (animal.mutation and animal.mutation ~= "" and animal.mutation ~= "None")
                         and animal.mutation or "None"
        print(string.format("║ #%d %s | %s | %s | 🧬 %s",
            i, animal.name, formatGen(animal.genValue), animal.rarity or "?", mutation))
    end
    print("╠══════════════════════════════════════╣")
    print("║ Total: " .. #animals .. " detectados")
    print("║ JobId: " .. JOB_ID)
    print("║ Link:  " .. getJoinLink())
    print("╚══════════════════════════════════════╝")
end

-- ================================================
-- WEBHOOKS
-- ================================================

local function buildAnimalLine(animal)
    local rarityEmoji = getRarityEmoji(animal.rarity)
    local mutation    = (animal.mutation and animal.mutation ~= "" and animal.mutation ~= "None")
                        and animal.mutation or "None"
    local genEmoji    = (animal.genValue >= ULTRA_GEN) and "🔥" or "🧠"

    return genEmoji .. " **" .. animal.name .. "**"
        .. " — `" .. formatGen(animal.genValue) .. "`"
        .. " | " .. rarityEmoji .. " " .. (animal.rarity or "?")
        .. " | 🧬 " .. mutation
end

local function sendWebhooks(detectedAnimals)
    if #detectedAnimals == 0 then return end

    local best        = detectedAnimals[1]
    local joinLink    = getJoinLink()
    local playerCount = getPlayerCount()
    local embedColor  = getEmbedColor()

    local brainrotList = ""
    for _, animal in ipairs(detectedAnimals) do
        brainrotList = brainrotList .. buildAnimalLine(animal) .. "\n"
    end

    local embed1 = {
        title  = "🔥 New Brainrot OP Detected",
        color  = embedColor,
        fields = {
            { name = "🔥 Best Brainrot",      value = buildAnimalLine(best), inline = false },
            { name = "👥 Players in Server",  value = tostring(playerCount), inline = true  },
            { name = "🔥 Brainrots Detected", value = brainrotList,          inline = false },
            { name = "🔗 Link do Servidor",
              value = "[**Join in the Server for Brainrots**](" .. joinLink .. ")",
              inline = false },
        },
        footer    = { text = "PlaceId: " .. PLACE_ID .. " | JobId: " .. JOB_ID },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local otherList = ""
    for i = 2, #detectedAnimals do
        otherList = otherList .. buildAnimalLine(detectedAnimals[i]) .. "\n"
    end

    local embed2 = {
        title  = "🧠 New Brainrot Found",
        color  = embedColor,
        fields = {
            { name = "🔥 Best Brainrot",   value = buildAnimalLine(best),                              inline = false },
            { name = "🧠 Other Brainrots", value = otherList ~= "" and otherList or "Nenhum outro.",   inline = false },
        },
        footer    = { text = "PlaceId: " .. PLACE_ID .. " | JobId: " .. JOB_ID },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    task.spawn(function()
        httpPost(WEBHOOK_NOTIFY, { content = "# New Brainrot OP Detected", embeds = { embed1 } })
    end)
    task.spawn(function()
        httpPost(WEBHOOK_DEMO, { content = "# New Brainrot Found", embeds = { embed2 } })
    end)
end

-- ================================================
-- ESP
-- ================================================

local function getPodiumWorldPart(animal)
    if not animal.plot or not animal.slot then return nil end
    local plot    = Workspace.Plots:FindFirstChild(animal.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium  = podiums:FindFirstChild(animal.slot)
    if not podium then return nil end
    local base    = podium:FindFirstChild("Base")
    local spawn   = base and base:FindFirstChild("Spawn")
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
        if animal.genValue >= MIN_GEN then activeUIDs[animal.uid] = true end
    end
    for uid in pairs(ESP_INSTANCES) do
        if not activeUIDs[uid] then clearESPForUID(uid) end
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

        local animalList  = channel:Get("AnimalList")
        local currentHash = getAnimalHash(animalList)
        if lastAnimalData[plot.Name] == currentHash then return end
        lastAnimalData[plot.Name] = currentHash

        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == plot.Name then
                table.remove(allAnimalsCache, i)
            end
        end

        for slot, animalData in pairs(animalList or {}) do
            if type(animalData) ~= "table" then continue end

            local info = require(ReplicatedStorage.Datas.Animals)[animalData.Index]
            if not info then continue end

            local genValue = require(ReplicatedStorage.Shared.Animals):GetGeneration(
                animalData.Index, animalData.Mutation, animalData.Traits, nil
            )

            if genValue < MIN_GEN then continue end

            table.insert(allAnimalsCache, {
                name     = info.DisplayName or animalData.Index,
                genValue = genValue,
                rarity   = info.Rarity or "Common",
                mutation = animalData.Mutation or "None",
                plot     = plot.Name,
                slot     = tostring(slot),
                uid      = plot.Name .. "_" .. tostring(slot),
            })
        end

        table.sort(allAnimalsCache, function(a, b) return a.genValue > b.genValue end)
        refreshAllESP()

        -- Só envia UMA VEZ por servidor
        if jaEnviouServidor then return end

        local toSend = {}
        for _, animal in ipairs(allAnimalsCache) do
            if not sentCache[animal.uid] then
                sentCache[animal.uid] = true
                table.insert(toSend, animal)
            end
        end

        if #toSend > 0 then
            jaEnviouServidor = true  -- trava envio pra esse servidor
            logDetected(toSend)
            sendWebhooks(toSend)
        end
    end)
end

-- ================================================
-- SERVER HOP
-- ================================================

local function getServers()
    local servers = {}
    pcall(function()
        local ok, result = pcall(function()
            return HttpService:JSONDecode(
                HttpService:GetAsync(
                    "https://games.roblox.com/v1/games/" .. PLACE_ID
                    .. "/servers/Public?sortOrder=Asc&limit=100"
                )
            )
        end)

        if not ok or not result then
            pcall(function()
                local res = request({
                    Url    = "https://games.roblox.com/v1/games/" .. PLACE_ID
                             .. "/servers/Public?sortOrder=Asc&limit=100",
                    Method = "GET",
                })
                if res and res.Body then
                    result = HttpService:JSONDecode(res.Body)
                    ok = true
                end
            end)
        end

        if ok and result and result.data then
            for _, server in ipairs(result.data) do
                if server.id ~= JOB_ID
                   and type(server.playing) == "number"
                   and type(server.maxPlayers) == "number"
                   and server.playing < server.maxPlayers then
                    table.insert(servers, server)
                end
            end
        end
    end)
    return servers
end

local function serverHop()
    while true do
        task.wait(2)
        print("[BranzZ] 🔄 Trocando de servidor...")

        -- Reseta tudo pro novo servidor
        allAnimalsCache    = {}
        lastAnimalData     = {}
        sentCache          = {}
        jaEnviouServidor   = false  -- libera envio pro próximo servidor

        local servers = getServers()

        if #servers > 0 then
            local pick = servers[math.random(1, #servers)]
            print("[BranzZ] 🎯 Teleportando para: " .. tostring(pick.id))
            JOB_ID = pick.id

            local teleported = false

            if not teleported then
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(
                        tonumber(PLACE_ID), pick.id, Players.LocalPlayer)
                    teleported = true
                end)
            end
            if not teleported then
                pcall(function()
                    teleport(tonumber(PLACE_ID))
                    teleported = true
                end)
            end
            if not teleported then
                pcall(function()
                    TeleportService:Teleport(tonumber(PLACE_ID), Players.LocalPlayer)
                    teleported = true
                end)
            end

            if not teleported then
                print("[BranzZ] ⚠️ Todos os métodos de teleport falharam!")
            end
        else
            print("[BranzZ] ⚠️ Nenhum servidor encontrado, tentando em 9s...")
        end
    end
end

-- ================================================
-- LOOP PRINCIPAL
-- ================================================

local function startScan()
    print("[BranzZ] ✅ Iniciando...")
    print("[BranzZ] MIN: " .. formatGen(MIN_GEN) .. " | ULTRA: " .. formatGen(ULTRA_GEN))
    print("[BranzZ] Join: " .. getJoinLink())

    task.spawn(serverHop)

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
