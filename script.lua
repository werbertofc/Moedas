--[[
    SCRIPT V8.0 - AUTO REMOTE FARM (LEITOR DE ATRIBUTOS)
    Criado para: Werbert
    Lógica: Lê o ID e o Valor real escondidos dentro da moeda e envia pro servidor.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- CONFIGURAÇÃO DO REMOTE
local RemoteEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remote"):WaitForChild("RemoteEvents"):WaitForChild("OrbPickupRequest")

_G.WerbertFarm = false

-- --- UI ---
if game.CoreGui:FindFirstChild("WerbertV8") then game.CoreGui.WerbertV8:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertV8"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "AUTO FARM V8"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16

local Status = Instance.new("TextLabel")
Status.Parent = Frame
Status.Text = "Aguardando..."
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 0, 0.7, 0)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Font = Enum.Font.Code
Status.TextSize = 11

local Btn = Instance.new("TextButton")
Btn.Parent = Frame
Btn.Text = "LIGAR"
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

-- --- FUNÇÃO INTELIGENTE ---

local function GetHiddenData(model)
    local id = nil
    local value = 1 -- Valor padrão se não achar
    
    -- 1. PROCURA NOS ATRIBUTOS (Onde jogos modernos escondem IDs)
    local atts = model:GetAttributes()
    for name, val in pairs(atts) do
        -- Procura qualquer coisa que pareça ID
        if string.lower(name) == "id" or string.find(string.lower(name), "guid") then
            id = tostring(val) -- Converte para string pois o seu código usa ["1476"]
        end
        -- Procura o valor da moeda
        if string.lower(name) == "coin" or string.lower(name) == "value" or string.lower(name) == "amount" then
            value = tonumber(val)
        end
    end
    
    -- 2. SE NÃO ACHOU, PROCURA DENTRO DA PASTA DA MOEDA
    if not id then
        for _, child in pairs(model:GetChildren()) do
            if (child:IsA("IntValue") or child:IsA("StringValue")) and (child.Name == "ID" or child.Name == "id") then
                id = tostring(child.Value)
            end
            if (child:IsA("IntValue") or child:IsA("NumberValue")) and (child.Name == "Coin" or child.Name == "Value") then
                value = child.Value
            end
        end
    end

    -- 3. SE AINDA NÃO ACHOU, TENTA O NÚMERO DO NOME (Último recurso)
    if not id then
        id = string.match(model.Name, "%d+")
    end
    
    return id, value
end

-- --- LOOP DE FARM ---

Btn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = not _G.WerbertFarm
    if _G.WerbertFarm then
        Btn.Text = "COLETANDO..."
        Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        Btn.Text = "LIGAR"
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
                local collected = 0
                
                for _, item in pairs(folder:GetChildren()) do
                    if string.sub(item.Name, 1, 6) == "Pickup" then
                        
                        -- Extrai os dados reais
                        local realID, realValue = GetHiddenData(item)
                        
                        if realID then
                            -- Monta o argumento IGUAL AO SEU EXEMPLO
                            local args = {
                                [realID] = {
                                    ["Coin"] = realValue
                                }
                            }
                            
                            -- Envia pro servidor
                            RemoteEvent:FireServer(args)
                            
                            -- Deleta a moeda pra não travar o PC
                            item:Destroy()
                            
                            collected = collected + 1
                            Status.Text = "Último ID: " .. realID .. " | Valor: " .. realValue
                        end
                    end
                end
            end)
        end
        task.wait(0.2) -- Velocidade segura
    end
end)
