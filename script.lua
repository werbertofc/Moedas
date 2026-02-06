--[[
    SCRIPT V10 - BRUTE FORCE COLLECTOR (A ÚLTIMA TENTATIVA)
    Criado para: Werbert
    Estratégia: "Shotgun" - Tenta todos os números encontrados dentro da moeda como ID.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- CONFIGURAÇÃO DO REMOTE (Exata do seu log)
local RemoteEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remote"):WaitForChild("RemoteEvents"):WaitForChild("OrbPickupRequest")

_G.WerbertFarm = false

-- --- UI ---
if game.CoreGui:FindFirstChild("WerbertV10") then game.CoreGui.WerbertV10:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertV10"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "FORCE BRUTE V10"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18

local Status = Instance.new("TextLabel")
Status.Parent = Frame
Status.Text = "Aguardando..."
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 0, 0.7, 0)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Font = Enum.Font.Code
Status.TextSize = 10

local Btn = Instance.new("TextButton")
Btn.Parent = Frame
Btn.Text = "INICIAR ATAQUE"
Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Position = UDim2.new(0.1, 0, 0.3, 0)
Btn.Size = UDim2.new(0.8, 0, 0.35, 0)
Btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

local Close = Instance.new("TextButton")
Close.Parent = Frame
Close.Text = "X"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Position = UDim2.new(0.85, 0, 0, 0)
Close.Size = UDim2.new(0, 30, 0, 30)

-- --- LÓGICA DE FORÇA BRUTA ---

local function TentarColetar(id, valor)
    -- Envia como String (Texto)
    local argsString = {
        [tostring(id)] = { ["Coin"] = valor }
    }
    RemoteEvent:FireServer(argsString)

    -- Envia como Número (se for possível converter)
    if tonumber(id) then
        local argsNumber = {
            [tonumber(id)] = { ["Coin"] = valor }
        }
        RemoteEvent:FireServer(argsNumber)
    end
end

Btn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = not _G.WerbertFarm
    if _G.WerbertFarm then
        Btn.Text = "ATACANDO..."
        Btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        Btn.Text = "INICIAR ATAQUE"
        Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Status.Text = "Parado"
    end
end)

Close.MouseButton1Click:Connect(function() _G.WerbertFarm = false ScreenGui:Destroy() end)

task.spawn(function()
    while true do
        if _G.WerbertFarm then
            pcall(function()
                local folder = Workspace:FindFirstChild("DebrisClient") or Workspace
                local attempts = 0
                
                for _, item in pairs(folder:GetChildren()) do
                    if string.sub(item.Name, 1, 6) == "Pickup" then
                        
                        -- 1. Descobrir o VALOR da moeda (Padrão 1, tenta achar 6 ou outro)
                        local coinValue = 1
                        -- Procura atributos de valor
                        local atts = item:GetAttributes()
                        for n, v in pairs(atts) do
                            if string.lower(n) == "coin" or string.lower(n) == "value" then
                                coinValue = tonumber(v) or 1
                            end
                        end
                        -- Procura objetos de valor dentro
                        for _, child in pairs(item:GetChildren()) do
                             if (child.Name == "Coin" or child.Name == "Value") and child:IsA("ValueBase") then
                                coinValue = child.Value
                             end
                        end
                        
                        -- 2. LISTA DE IDs POSSÍVEIS (Coleta tudo que achar)
                        local possibleIDs = {}
                        
                        -- Adiciona o número do nome (Ex: 109484)
                        local nameID = string.match(item.Name, "%d+")
                        if nameID then table.insert(possibleIDs, nameID) end
                        
                        -- Adiciona todos os valores de Atributos
                        for n, v in pairs(atts) do
                            table.insert(possibleIDs, v) -- Tenta usar o valor do atributo como ID
                        end
                        
                        -- Adiciona todos os valores de objetos filhos (IntValues)
                        for _, child in pairs(item:GetChildren()) do
                            if child:IsA("ValueBase") then
                                table.insert(possibleIDs, child.Value)
                            end
                        end
                        
                        -- 3. DISPARA O REMOTE COM TODAS AS POSSIBILIDADES
                        for _, id in pairs(possibleIDs) do
                            TentarColetar(id, coinValue)
                            TentarColetar(id, 6) -- Tenta forçar valor 6 (do seu log)
                        end
                        
                        attempts = attempts + 1
                        
                        -- (Opcional) Tenta remover visualmente se der certo
                        -- item:Destroy() 
                    end
                end
                
                if attempts > 0 then
                    Status.Text = "Tentativas enviadas: " .. attempts * 5
                end
            end)
        end
        task.wait(0.5) -- Pausa para não lagar o jogo com tantos disparos
    end
end)
