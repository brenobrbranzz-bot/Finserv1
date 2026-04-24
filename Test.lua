-- ================================================
--   DIVINI NOTIFY SCANNER v4.0 — DeepLink + Hopper
--   by BranZZ MetoDos (Adaptado)
--   Notifica 1K+ como ULTRA 🔥
--   Embeds IDÊNTICAS ao script original
-- ================================================

local Players         = game:GetService("Players")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui      = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace       = game:GetService("Workspace")
local Lighting        = game:GetService("Lighting")
local LocalPlayer     = Players.LocalPlayer

-- ================================================
-- CONFIG (WEBHOOKS DO SEU SCRIPT)
-- ================================================
local webhookDiviniAcesso = "https://discord.com/api/webhooks/1497275749105926485/lGDm09jvcD3SStD-lNRRsz5rMFXeKqsDfiHDYRuqgLqBx3NDqxPomSsK2h2THF1FnA9P"
local webhookDemo        = "https://discord.com/api/webhooks/1497276666706264225/os39l7GeHlRfXaWXyRDqe6d0aZkrUFObNnZTLNRi9P81UhXRVDAQJ4pw-fpUAEvXDXg_"
local NOTIFY_HOST        = "https://v0-roblox-deep-link-app.vercel.app/"
local PLACE_ID           = game.PlaceId

-- 🔥 CONFIGURAÇÃO: 1K++ = ULTRA 🔥
local MIN_GEN     = 1000      -- 1K/s (mínimo pra notificar)
local ULTRA_GEN   = 1000      -- 1K++ = TUDO é ULTRA!
local TOP_COUNT   = 60        -- Top 60 (igual ao original)

-- ================================================
-- POTATO MODE (Performance)
-- ================================================
local function activatePotatoMode()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.new(0,0,0)
        Lighting.OutdoorAmbient = Color3.new(0,0,0)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy()
            end
        end
    end)
end
activatePotatoMode()

-- ================================================
-- ESTADO
-- ================================================
local sentCache    = {}
local sentServers  = {}
local serverList   = {}
local serverIndex  = 1
local hopping      = false
local instanceId   = math.random(1000, 999999)

-- ================================================
-- HELPERS
-- ================================================
local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification",{Title="Divini Scanner",Text=msg,Duration=3})
    end)
end

local function formatGen(value)
    if value >= 1000000 then
        return string.format("$%.2fM/s", value/1000000)
    elseif value >= 1000 then
        return string.format("$%.2fK/s", value/1000)
    else
        return string.format("$%.0f/s", value)
    end
end

-- ================================================
-- MÉTODO DE SCAN (DO SEU SCRIPT ORIGINAL)
-- ================================================
local function getAnimalGeneration(animalIndex, mutation, traits)
    pcall(function()
        local animalModule = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Animals")
        if animalModule and animalModule.GetGeneration then
            return animalModule.GetGeneration(animalIndex, mutation, traits, nil)
        end
    end)
    
    local baseGen = 0
    if type(animalIndex) == "number" then
        baseGen = animalIndex * 1000
    elseif type(animalIndex) == "string" then
        local num = animalIndex:match("%d+")
        baseGen = num and (tonumber(num) * 1000) or 1000
    end
    return baseGen
end

local function scanLocalServer()
    local results = {}
    local seenUID = {}
    
    -- Método principal (Synchronizer)
    pcall(function()
        local synchronizer = ReplicatedStorage:FindFirstChild("Packages") and 
                             ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
        local plots = Workspace:FindFirstChild("Plots")
        
        if synchronizer and plots then
            for _, plot in ipairs(plots:GetChildren()) do
                local channel = synchronizer:Get(plot.Name)
                if channel then
                    local animalList = channel:Get("AnimalList")
                    for slot, animalData in pairs(animalList or {}) do
                        if type(animalData) == "table" then
                            local animalInfo = ReplicatedStorage:FindFirstChild("Datas") and 
                                               ReplicatedStorage.Datas:FindFirstChild("Animals")
                            local info = animalInfo and animalInfo[animalData.Index]
                            
                            if info then
                                local genValue = getAnimalGeneration(animalData.Index, animalData.Mutation, animalData.Traits)
                                local uid = plot.Name .. "_" .. tostring(slot)
                                
                                if genValue >= MIN_GEN and not seenUID[uid] and not sentCache[uid] then
                                    seenUID[uid] = true
                                    table.insert(results, {
                                        name = info.DisplayName or tostring(animalData.Index),
                                        genValue = genValue,
                                        genText = formatGen(genValue),
                                        rarity = info.Rarity or "Raro",
                                        plot = plot.Name,
                                        slot = tostring(slot),
                                        uid = uid,
                                        isUltra = genValue >= ULTRA_GEN
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    table.sort(results, function(a,b) return a.genValue > b.genValue end)
    return results
end

-- ================================================
-- ENVIA WEBHOOK (MESMO ESTILO DO SCRIPT ORIGINAL)
-- ================================================
local function sendWebhooks(jobId, results)
    if #results == 0 then return end
    
    -- Pega cada animal individualmente e envia (igual ao original)
    for _, animal in ipairs(results) do
        if not sentCache[animal.uid] then
            sentCache[animal.uid] = true
            
            local joinLink = NOTIFY_HOST .. "/?placeId=" .. PLACE_ID .. "&gameInstanceId=" .. jobId
            local isUltra = animal.genValue >= ULTRA_GEN  -- SEMPRE TRUE pq ULTRA_GEN = 1000
            
            -- ===== EMBED IDÊNTICO AO SEU SCRIPT ORIGINAL =====
            local embedAcesso = {
                title = isUltra and "🔥 ULTRA BRAINROT DETECTED 🔥" or "🧠 BRAINROT 1K+ DETECTADO",
                description = "**" .. animal.name .. "**",
                color = isUltra and 16711935 or 32768,  -- Rosa ou Verde
                fields = {
                    {name = "💰 Geração", value = "```" .. animal.genText .. "```", inline = true},
                    {name = "⭐ Raridade", value = animal.rarity or "Raro", inline = true},
                    {name = "🔗 Job ID", value = "```" .. jobId .. "```", inline = false},
                },
                footer = {text = "Instância " .. instanceId},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
            
            -- ===== DADOS DO WEBHOOK COM BOTÃO (IGUAL ORIGINAL) =====
            local dataAcesso = {
                embeds = {embedAcesso},
                components = {{
                    type = 1,
                    components = {{
                        type = 2,
                        label = "🚀 Entrar no Servidor",
                        style = 5,
                        url = joinLink
                    }}
                }}
            }
            
            -- ===== EMBED DEMO (IGUAL ORIGINAL) =====
            local embedDemo = {
                title = "BRANZZ LOGS HIGHLIGHT",
                description = "**" .. animal.name .. "**",
                color = 49151,  -- Azul ciano
                fields = {
                    {name = "💰 Geração", value = "```" .. animal.genText .. "```", inline = true}
                },
                footer = {text = "BranZz Notify•"},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
            
            -- ===== ENVIO PARA WEBHOOK DIVINI ACESSO =====
            task.spawn(function()
                pcall(function()
                    local payload = HttpService:JSONEncode(dataAcesso)
                    request({
                        Url = webhookDiviniAcesso,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = payload
                    })
                end)
            end)
            
            -- ===== ENVIO PARA WEBHOOK DEMO =====
            task.spawn(function()
                pcall(function()
                    local payload = HttpService:JSONEncode({embeds = {embedDemo}})
                    request({
                        Url = webhookDemo,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = payload
                    })
                end)
            end)
            
            notify("🔥 " .. animal.name .. " - " .. animal.genText)
            task.wait(0.4)  -- Delay entre envios (igual original)
        end
    end
    
    sentServers[jobId] = true
end

-- ================================================
-- BUSCA LISTA DE SERVIDORES
-- ================================================
local function fetchServers(cb)
    task.spawn(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?sortOrder=Desc&limit=100")
            )
        end)
        local list = {}
        if ok and data and data.data then
            for _, srv in ipairs(data.data) do
                if srv.id and srv.id ~= tostring(game.JobId) then
                    table.insert(list, srv.id)
                end
            end
        end
        cb(list)
    end)
end

-- ================================================
-- HOP INSTANTÂNEO
-- ================================================
local function hopNext()
    if hopping then return end
    hopping = true
    
    if #serverList == 0 or serverIndex > #serverList then
        notify("🔄 Recarregando lista de servidores...")
        fetchServers(function(list)
            serverList = list
            serverIndex = 1
            hopping = false
            if #list > 0 then
                notify("📋 " .. #list .. " servidores encontrados")
                hopNext()
            else
                notify("⚠️ Nenhum servidor disponível, tentando novamente em 5s...")
                task.wait(5)
                hopping = false
                hopNext()
            end
        end)
        return
    end
    
    local jobId = serverList[serverIndex]
    serverIndex = serverIndex + 1
    hopping = false
    
    pcall(function()
        TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, LocalPlayer)
    end)
end

-- ================================================
-- LOOP PRINCIPAL
-- ================================================
task.spawn(function()
    task.wait(2)
    notify("⚡ Divini Notify Scanner v4.0 ativado!")
    notify("📊 Notificando animais com 1K/s ou mais")
    print("[Divini Scanner] Carregado! MIN_GEN: 1K/s")
    
    fetchServers(function(list)
        serverList = list
        serverIndex = 1
        notify("📋 " .. #list .. " servidores na fila")
    end)
    
    while true do
        local results = scanLocalServer()
        
        if #results > 0 then
            print("[Scan] Encontrado " .. #results .. " animais com 1K+")
            sendWebhooks(tostring(game.JobId), results)
        else
            print("[Scan] Nenhum animal 1K+ encontrado...")
        end
        
        task.wait(2)
        hopNext()
        task.wait(3)
    end
end)

print("[Divini Notify Scanner v4.0] ✅ Carregado!")
print("[Config] 1K++ = ULTRA | Embeds originais")
