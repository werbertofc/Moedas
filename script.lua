--[[
    SCRIPT DE COLETAR MOEDAS V2.0 (COM FIRETOUCH & UNANCHOR)
    Criado para: Werbert
    Correção: Adicionado simulador de toque e desbloqueio de peças (Unanchor)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Configurações Globais
local _G = getgenv and getgenv() or _G
_G.ColetarMoedas = false 

-- Função para simular o toque (Método Infalível)
local function SimularToque(part)
    -- Tenta usar firetouchinterest (padrão da maioria dos executores)
    if firetouchinterest then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0) -- Toca
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1) -- Solta
        end
    end
end

-- Loop Principal
local function MagnetLoop()
    task.spawn(function()
        while true do
            if _G.ColetarMoedas then
                pcall(function()
                    local character = LocalPlayer.Character
                    if not character then return end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    -- Tenta encontrar a pasta. Se o nome estiver errado, ele avisa no F9
                    local debris = Workspace:FindFirstChild("DebrisClient")
                    
                    if debris then
                        local items = debris:GetChildren()
                        if #items == 0 then
                            -- print("Pasta DebrisClient vazia...") 
                        end

                        for _, item in pairs(items) do
                            -- Verifica se é uma moeda (Pickup...) e tem o HitDetect
                            if item.Name:match("Pickup") and item:FindFirstChild("HitDetect") then
                                local hitPart = item.HitDetect
                                
                                -- 1. TENTA DESANCORAR (Para ela poder se mover)
                                if hitPart.Anchored then
                                    hitPart.Anchored = false
                                end

                                -- 2. AUMENTA O TAMANHO (Como você pediu)
                                hitPart.Size = Vector3.new(30, 30, 30) -- Ainda maior
                                hitPart.CanCollide = false
                                hitPart.Transparency = 0.7 
                                
                                -- 3. TELA DE MENSAGEM (DEBUG)
                                -- Se for a primeira vez, avisa que achou
                                
                                -- 4. MAGNETISMO (Traz para você)
                                hitPart.CFrame = hrp.CFrame
                                
                                -- 5. SIMULAÇÃO DE TOQUE (Garante a coleta)
                                SimularToque(hitPart)
                            end
                        end
                    else
                        warn("ERRO: Não encontrei a pasta 'DebrisClient' no Workspace!")
                    end
                end)
            end
            task.wait(0.1) -- Velocidade do loop (rápido, mas não trava)
        end
    end)
end

MagnetLoop()

-- --- INTERFACE (UI) --- 
-- (Mesma UI bonita de antes, com ajustes)

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local OpenButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel") -- Novo: Mostra status
local UICorner = Instance.new("UICorner")

if game.CoreGui:FindFirstChild("WerbertCoinHubV2") then
    game.CoreGui.WerbertCoinHubV2:Destroy()
end

ScreenGui.Name = "WerbertCoinHubV2"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBlack
Title.Text = "COLETOR V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20.000

ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24.000

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- Novo Label de Status
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.7, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Aguardando..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12.000

ToggleButton.MouseButton1Click:Connect(function()
    _G.ColetarMoedas = not _G.ColetarMoedas
    if _G.ColetarMoedas then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
        StatusLabel.Text = "Procurando em DebrisClient..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        StatusLabel.Text = "Pausado"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(0.88, 0, -0.05, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBlack
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14.000

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    _G.ColetarMoedas = false
    ScreenGui:Destroy()
end)

MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Position = UDim2.new(0.72, 0, -0.05, 0)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Font = Enum.Font.GothamBlack
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14.000

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeButton

OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenButton.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Visible = false
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "W"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 22.000
OpenButton.Draggable = true

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)
