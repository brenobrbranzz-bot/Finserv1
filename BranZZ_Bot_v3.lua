-- ================================================
--   BranZZ Bot v3.0 — Instant Hopper + Webhook
--   by BranZZ MetoDos
--   AUTO EXECUTE: deixa rodando, ele troca sozinho
-- ================================================

local Players         = game:GetService("Players")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui      = game:GetService("StarterGui")
local LocalPlayer     = Players.LocalPlayer

-- ================================================
-- CONFIG
-- ================================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1494852645742051439/A7xtEcqK3fZSsWzcI5eJtYbVoLSOqkz_Fw-zZm7ijQKXYhW3XwNTu63ayoIcMAWC2SnT"
local NOTIFY_HOST = "https://v0-roblox-deep-link-app.vercel.app/"
local PLACE_ID    = game.PlaceId
local MIN_GEN     = 0   -- mínimo k/s pra notificar (0 = qualquer)
local TOP_COUNT   = 60   -- top 4 no embed

-- ================================================
-- LISTA DE BRAINROTS
-- ================================================
local BRAZILROT_LIST = {
    "Burguerino Kingino","Coelhone Nesquikne","Cuscuzini Manteguini",
    "Dollyretti Guaranazzi","Fulecazzo Lutariny","Los Docitonitos",
    "Malandrini Dribladorini","Maquiteira serralheira","Orelhone Telefony",
    "Pacoquita","Ze Drippolini Vacinnaro","Urubini Flamenguini",
    "Toddynelli Turbochoco","Pudino Condensadoni","Goozini Cafezini",
    "Patino Aurudo","Nao Chorax","Chineleira Pregueira",
    "Negresconi Bombadony","Jakarate","Caramelo Filtrello",
}

-- ================================================
-- ESTADO
-- ================================================
local sentServers = {}
local serverList  = {}
local serverIndex = 1
local hopping     = false

-- ================================================
-- HELPERS
-- ================================================
local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification",{Title="BranZZ Bot",Text=msg,Duration=3})
    end)
end

local function isBrazilrotName(text)
    local tl = text:lower()
    for _, name in ipairs(BRAZILROT_LIST) do
        if tl:find(name:lower(),1,true) then return name end
    end
    return nil
end

local function parseGen(text)
    local b = text:match("([%d%.]+)%s*[Bb]")
    if b then return tonumber(b)*1000000 end
    local m = text:match("([%d%.]+)%s*[Mm]")
    if m then return tonumber(m)*1000 end
    local k = text:match("([%d%.]+)%s*[Kk]")
    if k then return tonumber(k) end
    return 0
end

local function formatGen(val)
    if val >= 1000000 then return string.format("%.2fb/s", val/1000000)
    elseif val >= 1000 then return string.format("%.2fm/s", val/1000)
    elseif val >= 1   then return string.format("%.1fk/s", val)
    else return "?" end
end

-- ================================================
-- SCAN (mesmo método do script original)
-- ================================================
local function scanLocalServer()
    local results = {}
    local seen    = {}
    local bases   = workspace:FindFirstChild("Bases")
    if not bases then return results end

    for _, base in ipairs(bases:GetChildren()) do
        local ownerName = "?"
        local ownerId   = 0

        local placa = base:FindFirstChild("Placa", true)
        if placa then
            for _, desc in ipairs(placa:GetDescendants()) do
                if desc:IsA("TextLabel") then
                    local t = (desc.Text or ""):match("^%s*(.-)%s*$")
                    if t and t ~= "" then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p.Name:lower()==t:lower() or (p.DisplayName or ""):lower()==t:lower() then
                                ownerName = p.DisplayName~="" and p.DisplayName or p.Name
                                ownerId   = p.UserId
                                break
                            end
                        end
                        if ownerId == 0 then ownerName = t end
                        break
                    end
                end
            end
        end

        local sf = base:FindFirstChild("Slots")
        if not sf then
            for _, d in ipairs(base:GetDescendants()) do
                if d.Name=="Slots" then sf=d break end
            end
        end
        if not sf then continue end

        for i = 1, 100 do
            local sObj = sf:FindFirstChild("s"..i)
            if not sObj then continue end

            for _, desc in ipairs(sObj:GetDescendants()) do
                if desc.Name == "BrainrotBillboard" then
                    pcall(function()
                        local labels = {}
                        for _, o in ipairs(desc:GetDescendants()) do
                            if o:IsA("TextLabel") then
                                local t = (o.Text or o.ContentText or ""):match("^%s*(.-)%s*$")
                                if t and t~="" and t~=" " then
                                    local dup=false
                                    for _,ex in ipairs(labels) do if ex==t then dup=true break end end
                                    if not dup then table.insert(labels,t) end
                                end
                            end
                        end
                        if #labels==0 then return end

                        local key = table.concat(labels,"|")
                        if seen[key] then return end
                        seen[key] = true

                        local foundName = nil
                        local genVal    = 0
                        local genText   = "?"

                        for _, lbl in ipairs(labels) do
                            if not foundName then
                                local n = isBrazilrotName(lbl)
                                if n then foundName = n end
                            end
                            if lbl:match("[%d%.]+%s*[BbMmKk]") then
                                local v = parseGen(lbl)
                                if v > genVal then
                                    genVal  = v
                                    genText = lbl:match("^%s*(.-)%s*$")
                                end
                            end
                        end

                        if not foundName then return end
                        if genVal < MIN_GEN then return end

                        table.insert(results, {
                            name      = foundName,
                            genVal    = genVal,
                            genText   = genText,
                            ownerName = ownerName,
                            ownerId   = ownerId,
                        })
                    end)
                end
            end
        end
    end

    table.sort(results, function(a,b) return a.genVal > b.genVal end)
    return results
end

local function groupByPlayer(results)
    local best = {}
    for _, item in ipairs(results) do
        if not best[item.ownerName] or item.genVal > best[item.ownerName].genVal then
            best[item.ownerName] = item
        end
    end
    local sorted = {}
    for _, v in pairs(best) do table.insert(sorted,v) end
    table.sort(sorted, function(a,b) return a.genVal > b.genVal end)
    return sorted
end

-- ================================================
-- ENVIA WEBHOOK — múltiplos métodos de fallback
-- ================================================
local function sendWebhook(jobId, grouped)
    if sentServers[jobId] then return end
    sentServers[jobId] = true

    local top4 = {}
    for i=1, math.min(TOP_COUNT, #grouped) do
        table.insert(top4, grouped[i])
    end

    local medals = {"🥇","🥈","🥉","⚡"}
    local bestLine = ""
    for i, item in ipairs(top4) do
        bestLine = bestLine..(medals[i] or "⚡").." `"..formatGen(item.genVal).."` — **"..item.name.."**\n"
    end
    if bestLine == "" then bestLine = "Nenhum detectado" end

    local nameLine = ""
    for _, item in ipairs(top4) do
        nameLine = nameLine.."**"..item.name.."** → "..item.ownerName.."\n"
    end
    if nameLine == "" then nameLine = "—" end

    local joinLink = NOTIFY_HOST.."/?placeId="..PLACE_ID.."&gameInstanceId="..jobId

    local thumb = nil
    if top4[1] and top4[1].ownerId and top4[1].ownerId ~= 0 then
        thumb = {url="https://thumbnails.roblox.com/v1/users/avatar-bust?userIds="..top4[1].ownerId.."&size=420x420&format=Png&isCircular=false"}
    end

    local embed = {
        title     = "New Brasilrot detected 🇧🇷🐐",
        color     = 9699539,
        thumbnail = thumb,
        fields    = {
            {name="👥 Players in server", value=tostring(#Players:GetPlayers()), inline=true},
            {name="🇧🇷 The Best Brainrots /s", value=bestLine, inline=false},
            {name="🧠 best Brasilrots !", value=nameLine, inline=false},
            {name="🔗 Link From Server", value="[**Entrar no Servidor**]("..joinLink..")", inline=false},
        },
        footer    = {text="BranZZ Finder V1.1 • Catch a Brasilrot"},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }

    local payload = HttpService:JSONEncode({
        username   = "BranZZ Notify 🇧🇷",
        avatar_url = "https://tr.rbxcdn.com/placeholder/420/420/Image/Png",
        content    = " <@&1494805969325003023> 🔥 **New Brasilrot detected!** 🔥",
        embeds     = {embed},
    })

    pcall(function()
        request({
            Url     = WEBHOOK_URL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = payload,
        })
    end)

    notify("✅ Enviado! "..(top4[1] and top4[1].name or ""))
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
        notify("🔄 Recarregando lista...")
        fetchServers(function(list)
            serverList  = list
            serverIndex = 1
            hopping     = false
            if #list > 0 then
                notify("📋 "..#list.." servidores")
            else
                notify("⚠️ Sem servidores disponíveis")
            end
        end)
        return
    end

    local jobId = serverList[serverIndex]
    serverIndex += 1
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
    notify("⚡ BranZZ Bot v3.0 ativado!")

    fetchServers(function(list)
        serverList  = list
        serverIndex = 1
        notify("📋 "..#list.." servidores na fila")
    end)

    while true do
        local data    = scanLocalServer()
        local grouped = groupByPlayer(data)
        local jobId   = tostring(game.JobId)

        if #grouped > 0 then
            sendWebhook(jobId, grouped)
        end

        hopNext()
        task.wait(3)
    end
end)

print("[BranZZ Bot v3.0] OK")
