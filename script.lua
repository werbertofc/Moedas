--[[
    SCRIPT V6.0 - REMOTE FARM (GOD MODE)
    Criado para: Werbert
    Método: Dispara o evento de coleta sem precisar tocar na moeda.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- CONFIGURAÇÃO DO REMOTE (Baseado no seu código)
-- Caminho: ReplicatedStorage > Shared > Remote > RemoteEvents > OrbPickupRequest
local RemoteEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remote"):WaitForChild("RemoteEvents"):WaitForChild("OrbPickupRequest")

-- Variáveis de Controle
_G.WerbertFarm = false

-- --- INTERFACE GRÁFICA (UI) ---
if game.CoreGui:FindFirstChild("WerbertRemoteV6") then
    game.CoreGui.WerbertRemoteV6:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "WerbertRemoteV6"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.GothamBlack
Title.Text = "REMOTE COLLECTOR"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 18

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "Aguardando..."
StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
StatusLabel.TextSize = 11

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.35, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ATIVAR FARM"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 33, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold

-- --- LÓGICA DO REMOTE FARM ---

ToggleBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = not _G.WerbertFarm
    if _G.WerbertFarm then
        ToggleBtn.Text = "COLETANDO..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        StatusLabel.Text = "Escaneando IDs..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    else
        ToggleBtn.Text = "ATIVAR FARM"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        StatusLabel.Text = "Parado"
        StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = false
    ScreenGui:Destroy()
end)

-- Loop de Coleta
task.spawn(function()
    while true do
        if _G.WerbertFarm then
            pcall(function()
                -- Procura a pasta de moedas (DebrisClient ou Workspace)
                local folder = Workspace:FindFirstChild("DebrisClient") or Workspace
                
                local coinsCollected = 0
                
                for _, item in pairs(folder:GetChildren()) do
                    -- Verifica se o nome começa com "Pickup"
                    if string.sub(item.Name, 1, 6) == "Pickup" then
                        
                        -- Extrai SOMENTE O NÚMERO do nome (Ex: Pickup109484 -> "109484")
                        local coinID = string.match(item.Name, "%d+")
                        
                        if coinID then
                            -- Monta o argumento exatamente como você mandou
                            -- args = { { ["ID"] = { Coin = 1 } } }
                            -- O FireServer recebe o conteúdo de dentro
                            
                            local args = {
                                [coinID] = {
                                    ["Coin"] = 1
                                }
                            }
                            
                            -- Dispara o evento para o servidor
                            RemoteEvent:FireServer(args)
                            
                            -- Opcional: Destroi a moeda localmente para não tentar pegar de novo
                            -- item:Destroy() 
                            
                            coinsCollected = coinsCollected + 1
                        end
                    end
                end
                
                if coinsCollected > 0 then
                    StatusLabel.Text = "Enviado request para " .. coinsCollected .. " moedas"
                end
            end)
        end
        task.wait(0.5) -- Espera meio segundo para não crashar o jogo (pode diminuir se quiser mais rápido)
    end
end)
