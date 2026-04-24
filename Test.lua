-- ================================================
--   EXECUTOR DUPLO - BRANZZ SCANNER + MOONVEIL
--   Executa os dois scripts simultaneamente
-- ================================================

local function executeScripts()
    -- URLs dos scripts
    local url1 = "https://raw.githubusercontent.com/brenobrbranzz-bot/Finserv1/refs/heads/main/Test.lua"
    local url2 = "https://pastefy.app/e6nVSvX0/raw"
    
    print("[EXECUTOR] Iniciando carregamento dos 2 scripts...")
    
    -- Função para executar um script via loadstring
    local function loadAndExecute(url, name)
        task.spawn(function()
            local success, result = pcall(function()
                print("[EXECUTOR] Baixando " .. name .. "...")
                local content = game:HttpGet(url)
                print("[EXECUTOR] Baixado " .. name .. " (" .. string.len(content) .. " bytes)")
                
                local func = loadstring(content)
                if func then
                    print("[EXECUTOR] Executando " .. name .. "...")
                    return func()
                else
                    error("Falha ao compilar " .. name)
                end
            end)
            
            if not success then
                warn("[ERRO] " .. name .. ": " .. tostring(result))
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Erro no Script",
                        Text = name .. ": " .. tostring(result):sub(1, 100),
                        Duration = 5
                    })
                end)
            else
                print("[EXECUTOR] " .. name .. " executado com sucesso!")
            end
        end)
    end
    
    -- Executa os dois scripts EM PARALELO
    loadAndExecute(url1, "BRANZZ NOTIFY SCANNER")
    loadAndExecute(url2, "MOONVEIL SCRIPT (Ofuscado)")
    
    print("[EXECUTOR] Ambos os scripts iniciados em paralelo!")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Scripts Carregados",
            Text = "BRANZZ Scanner + MoonVeil executando",
            Duration = 3
        })
    end)
end

-- Executa
executeScripts()
