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
local ULTRA_GEN = 10000000

local PLACE_ID = tostring(game.PlaceId)
local JOB_ID   = tostring(game.JobId)

-- ================================================
-- ESTADO
-- ================================================

local allAnimalsCache  = {}
local lastAnimalData   = {}
local sentCache        = {}
local jaEnviouServidor = false

-- ================================================
-- FONTE BOLD UNICODE
-- ================================================

local function bold(text)
    local normal = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local boldU  = "𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵"
    local result = ""
    for i = 1, #text do
        local c = text:sub(i, i)
        local idx = normal:find(c, 1, true)
        if idx then
            -- cada char bold unicode ocupa 4 bytes
            local pos = (idx - 1) * 4 + 1
            result = result .. boldU:sub(pos, pos + 3)
        else
            result = result .. c
        end
    end
    return result
end

-- ================================================
-- HTTP
-- ================================================

local function httpPost(url, payload)
    local body    = HttpService:JSONEncode(payload)
    local headers = { ["Content-Type"] = "application/json" }
    local sent    = false

    if not sent then pcall(function()
        request({ Url = url, Method = "POST", Headers = headers, Body = body })
        sent = true
    end) end
    if not sent then pcall(function()
        http.request({ Url = url, Method = "POST", Headers = headers, Body = body })
        sent = true
    end) end
    if not sent then pcall(function()
        syn.request({ Url = url, Method = "POST", Headers = headers, Body = body })
        sent = true
    end) end
    if not sent then pcall(function()
        HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
        sent = true
    end) end

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

local function formatGen(val)
    if val >= 1000000000 then return string.format("%.2fB/s", val / 1000000000)
    elseif val >= 1000000 then return string.format("%.2fM/s", val / 1000000)
    elseif val >= 1000 then return string.format("%.1fK/s", val / 1000)
    end
    return tostring(val) .. "/s"
end

-- ================================================
-- RARIDADE
-- ================================================

local RARITY_EMOJI = {
    ["Common"]    = "🟢",
    ["Uncommon"]  = "🟤",
    ["Rare"]      = "🔵",
    ["Epic"]      = "🟣",
    ["Legendary"] = "🟠",
    ["Mythic"]    = "🔴",
    ["Good"]      = "👼",
    ["Secret"]    = "⚫",
    ["OG"]        = "🟡",
}

local function getRarityEmoji(r) return RARITY_EMOJI[r] or "❓" end

local function isOP(animals)
    for _, a in ipairs(animals) do
        if a.rarity == "OG" then return "OG" end
    end
    for _, a in ipairs(animals) do
        if a.rarity == "Secret" then return "Secret" end
    end
    return "Normal"
end

-- ================================================
-- WEBHOOKS
-- ================================================

local function buildAnimalLine(animal)
    local emoji    = getRarityEmoji(animal.rarity)
    local mutation = (animal.mutation and animal.mutation ~= "" and animal.mutation ~= "None")
                     and animal.mutation or "None"

    return emoji .. " " .. bold(animal.name) .. " — " .. bold(formatGen(animal.genValue)) .. "\n"
        .. "🧬 " .. bold("Mutation:") .. " " .. bold(mutation)
end

local function sendWebhooks(detectedAnimals)
    if #detectedAnimals == 0 then return end

    local best        = detectedAnimals[1]
    local joinLink    = getJoinLink()
    local playerCount = #Players:GetPlayers()
    local embedColor  = 0xC9A6F5
    local opType      = isOP(detectedAnimals)

    -- Mensagem principal
    local content = ""
    if opType == "OG" then
        content = "# 🚨 " .. bold("NEW OG DETECTED") .. " @everyone"
    elseif opType == "Secret" then
        content = "# 🚨 " .. bold("NEW OP SECRET DETECTED") .. " 🚨"
    else
        content = "** " .. bold("New Brainrot Op detected") .. " **"
    end

    -- Lista de brainrots
    local brainrotList = ""
    for _, animal in ipairs(detectedAnimals) do
        brainrotList = brainrotList .. buildAnimalLine(animal) .. "\n\n"
    end

    -- EMBED 1 — NOTIFY
    local embed1 = {
        title       = "𝗕𝗿𝗮𝗻𝘇𝗭 𝗡𝗼𝘁𝗶𝗳𝘆𝗲𝗿",
        color       = embedColor,
        description = "",
        fields      = {
            {
                name   = "👤 " .. bold("Players in Server"),
                value  = bold(tostring(playerCount)) .. "/" .. bold("8"),
                inline = true
            },
            {
                name   = "🧠 " .. bold("Best Brainrots"),
                value  = brainrotList,
                inline = false
            },
            {
                name   = "🔗 " .. bold("Link do Servidor"),
                value  = "[" .. bold("Join in the Server for Brainrots") .. "](" .. joinLink .. ")",
                inline = false
            },
        },
        footer = { text = "「🇧🇷」𝗯𝗿𝗮𝗻𝘇𝗭-𝗙𝗶𝗻𝗱𝗲𝗿-𝗕𝗿𝗮𝗶𝗻𝗿𝗼𝘁🧠" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    -- Lista resumida pra DEMO
    local otherList = ""
    for i = 2, #detectedAnimals do
        otherList = otherList .. buildAnimalLine(detectedAnimals[i]) .. "\n\n"
    end

    -- EMBED 2 — DEMO
    local embed2 = {
        title  = "𝗕𝗿𝗮𝗻𝘇𝗭 𝗡𝗼𝘁𝗶𝗳𝘆𝗲𝗿",
        color  = embedColor,
        fields = {
            {
                name   = "🔥 " .. bold("Best Brainrot"),
                value  = buildAnimalLine(best),
                inline = false
            },
            {
                name   = "🧠 " .. bold("Other Brainrots"),
                value  = otherList ~= "" and otherList or bold("Nenhum outro detectado."),
                inline = false
            },
        },
        footer = { text = "「🇧🇷」𝗯𝗿𝗮𝗻𝘇𝗭-𝗙𝗶𝗻𝗱𝗲𝗿-𝗕𝗿𝗮𝗶𝗻𝗿𝗼𝘁🧠" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    task.spawn(function()
        httpPost(WEBHOOK_NOTIFY, { content = content, embeds = { embed1 } })
    end)
    task.spawn(function()
        httpPost(WEBHOOK_DEMO, { content = content, embeds = { embed2 } })
    end)
end

-- ================================================
-- CONSOLE LOG
-- ================================================

local function logDetected(animals)
    print("╔══════════════════════════════════════╗")
    print("║     🧠 BRAINROTS DETECTADOS          ║")
    print("╠══════════════════════════════════════╣")
    for i, a in ipairs(animals) do
        local mutation = (a.mutation and a.mutation ~= "" and a.mutation ~= "None")
                         and a.mutation or "None"
        print(string.format("║ #%d %s | %s | %s | 🧬 %s",
            i, a.name, formatGen(a.genValue), a.rarity, mutation))
    end
    print("╠══════════════════════════════════════╣")
    print("║ Total: " .. #animals .. " detectados")
    print("╚══════════════════════════════════════╝")
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
                info     = info,
            })
        end

        table.sort(allAnimalsCache, function(a, b) return a.genValue > b.genValue end)

        if jaEnviouServidor then return end

        local toSend = {}
        for _, animal in ipairs(allAnimalsCache) do
            if not sentCache[animal.uid] then
                sentCache[animal.uid] = true
                table.insert(toSend, animal)
            end
        end

        if #toSend > 0 then
            jaEnviouServidor = true
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
        task.wait(3)
        print("[BranzZ] 🔄 Trocando de servidor...")

        allAnimalsCache    = {}
        lastAnimalData     = {}
        sentCache          = {}
        jaEnviouServidor   = false

        local servers = getServers()

        if #servers > 0 then
            local pick = servers[math.random(1, #servers)]
            print("[BranzZ] 🎯 Teleportando para: " .. tostring(pick.id))
            JOB_ID = pick.id

            local teleported = false
            if not teleported then pcall(function()
                TeleportService:TeleportToPlaceInstance(tonumber(PLACE_ID), pick.id, Players.LocalPlayer)
                teleported = true
            end) end
            if not teleported then pcall(function()
                teleport(tonumber(PLACE_ID))
                teleported = true
            end) end
            if not teleported then pcall(function()
                TeleportService:Teleport(tonumber(PLACE_ID), Players.LocalPlayer)
                teleported = true
            end) end

            if not teleported then
                print("[BranzZ] ⚠️ Todos os métodos de teleport falharam!")
            end
        else
            print("[BranzZ] ⚠️ Nenhum servidor encontrado, tentando em 9s...")
        end
    end
end

-- ================================================
-- INICIO
-- ================================================

print("[BranzZ] ✅ Iniciando...")
print("[BranzZ] MIN: " .. formatGen(MIN_GEN) .. " | ULTRA: " .. formatGen(ULTRA_GEN))

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
