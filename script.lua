--[[
    SCRIPT V7.0 - REMOTE BRUTEFORCE & SCANNER
    Criado para: Werbert
    Função: Tenta todas as formas de ID e mostra o que tem dentro da moeda.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- CONFIGURAÇÃO DO REMOTE (Baseado no seu código)
local RemoteEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remote"):WaitForChild("RemoteEvents"):WaitForChild("OrbPickupRequest")

_G.WerbertFarm = false

-- --- INTERFACE (UI) ---
if game.CoreGui:FindFirstChild("WerbertV7") then
    game.CoreGui.WerbertV7:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "WerbertV7"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 255) -- Roxo
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.GothamBlack
Title.Text = "COLETOR INTELIGENTE V7"
Title.TextColor3 = Color3.fromRGB(255, 0, 255)
Title.TextSize = 14

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "Abra o F9 para ver logs"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 10
StatusLabel.TextWrapped = true

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ATIVAR"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- --- LÓGICA INTELIGENTE ---

ToggleBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = not _G.WerbertFarm
    if _G.WerbertFarm then
        ToggleBtn.Text = "RODANDO..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        StatusLabel.Text = "Escaneando IDs..."
    else
        ToggleBtn.Text = "ATIVAR"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        StatusLabel.Text = "Parado"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = false
    ScreenGui:Destroy()
end)

-- Função para scanear a moeda (DEBUG)
local function ScanCoin(model)
    print("--- ESCANEANDO: " .. model.Name .. " ---")
    
    -- Mostra atributos (ID escondido?)
    local attributes = model:GetAttributes()
    for name, value in pairs(attributes) do
        print("Atributo encontrado: ", name, " = ", value)
    end

    -- Mostra valores dentro
    for _, child in pairs(model:GetChildren()) do
        if child:IsA("IntValue") or child:IsA("StringValue") or child:IsA("NumberValue") then
            print("Valor encontrado: ", child.Name, " = ", child.Value)
        end
    end
    print("-------------------------")
end

task.spawn(function()
    while true do
        if _G.WerbertFarm then
            pcall(function()
                local folder = Workspace:FindFirstChild("DebrisClient") or Workspace
                local scannedOne = false
                
                for _, item in pairs(folder:GetChildren()) do
                    if string.sub(item.Name, 1, 6) == "Pickup" then
                        
                        -- Extrai o número do nome
                        local idString = string.match(item.Name, "%d+") -- Ex: "109484"
                        local idNumber = tonumber(idString)             -- Ex: 109484 (número)
                        
                        if idString then
                            -- DEBUG: Na primeira moeda encontrada, mostra o que tem dentro no F9
                            if not scannedOne then
                                ScanCoin(item)
                                scannedOne = true
                            end

                            -- TENTATIVA 1: Envia como TEXTO (String Key)
                            -- Ex: { ["109484"] = { Coin = 1 } }
                            local argsString = {
                                [idString] = {
                                    ["Coin"] = 1
                                }
                            }
                            RemoteEvent:FireServer(argsString)

                            -- TENTATIVA 2: Envia como NÚMERO (Number Key)
                            -- Ex: { [109484] = { Coin = 1 } }
                            if idNumber then
                                local argsNumber = {
                                    [idNumber] = {
                                        ["Coin"] = 1
                                    }
                                }
                                RemoteEvent:FireServer(argsNumber)
                            end
                            
                            -- TENTATIVA 3: Tenta achar um atributo "ID" real
                            local realID = item:GetAttribute("ID") or item:GetAttribute("id")
                            if realID then
                                local argsReal = {
                                    [realID] = {
                                        ["Coin"] = 1
                                    }
                                }
                                RemoteEvent:FireServer(argsReal)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2) -- Tenta coletar 5 vezes por segundo
    end
end)
