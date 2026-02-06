--[[
    SCRIPT DE COLETAR MOEDAS (MAGNET + HITBOX)
    Criado para: Werbert
    Funcionalidade: Traz as moedas até você e aumenta o tamanho delas.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Configurações
local _G = getgenv and getgenv() or _G
_G.ColetarMoedas = false -- Começa desativado

-- Função Principal (Magnetismo e Tamanho)
local function MagnetLoop()
    task.spawn(function()
        while true do
            if _G.ColetarMoedas then
                pcall(function()
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local hrp = character.HumanoidRootPart
                        
                        -- Procura na pasta específica que você mandou
                        local debris = Workspace:FindFirstChild("DebrisClient")
                        
                        if debris then
                            for _, item in pairs(debris:GetChildren()) do
                                -- Verifica se o nome começa com "Pickup" e se tem o HitDetect
                                if item.Name:match("Pickup") and item:FindFirstChild("HitDetect") then
                                    local hitPart = item.HitDetect
                                    
                                    -- Aumenta o tamanho para facilitar o toque (Hitbox)
                                    hitPart.Size = Vector3.new(20, 20, 20)
                                    hitPart.CanCollide = false
                                    hitPart.Transparency = 0.8 -- Meio invisível para não poluir a tela
                                    
                                    -- Traz a moeda para o jogador (Magnetismo)
                                    hitPart.CFrame = hrp.CFrame
                                end
                            end
                        end
                    end
                end)
            end
            task.wait() -- Espera mínima para não travar o jogo
        end
    end)
end

-- Inicia o loop (mas só funciona se a variável for true)
MagnetLoop()

-- --- CRIAÇÃO DA INTERFACE (UI) ---

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local OpenButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Proteção contra múltiplas GUIs
if game.CoreGui:FindFirstChild("WerbertCoinHub") then
    game.CoreGui.WerbertCoinHub:Destroy()
end

ScreenGui.Name = "WerbertCoinHub"
ScreenGui.Parent = game.CoreGui

-- Janela Principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Centralizado
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Pode arrastar a janela

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Título
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "COIN SCRIPT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18.000

-- Botão de Ativar/Desativar
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Vermelho (Desligado)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "DESATIVADO"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14.000

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- Lógica do Botão Toggle
ToggleButton.MouseButton1Click:Connect(function()
    _G.ColetarMoedas = not _G.ColetarMoedas
    if _G.ColetarMoedas then
        ToggleButton.Text = "ATIVADO"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde
    else
        ToggleButton.Text = "DESATIVADO"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Vermelho
    end
end)

-- Botão de Fechar (X)
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Position = UDim2.new(0.85, 0, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14.000

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    _G.ColetarMoedas = false -- Para o script
    ScreenGui:Destroy()
end)

-- Botão de Minimizar (-)
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.Position = UDim2.new(0.70, 0, 0, 5)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14.000

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- Botão Flutuante (para abrir o menu)
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenButton.Position = UDim2.new(0.1, 0, 0.1, 0) -- Canto da tela
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Visible = false -- Começa invisível
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "M" -- M de Menu
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 24.000
OpenButton.Draggable = true -- Pode arrastar o botão flutuante

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0) -- Redondo
OpenCorner.Parent = OpenButton

-- Lógica Minimizar/Abrir
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)
