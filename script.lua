--[[
    SCRIPT V9.0 - GERADOR DE DINHEIRO (MANUAL INPUT)
    Criado para: Werbert
    Como usar: Coloque o ID e Valor que você descobriu no RemoteSpy.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- CONFIGURAÇÃO DO REMOTE (O caminho exato que você mandou)
local RemoteEvent = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remote"):WaitForChild("RemoteEvents"):WaitForChild("OrbPickupRequest")

_G.GeradorLigado = false

-- --- INTERFACE (UI) ---
if game.CoreGui:FindFirstChild("WerbertGeneratorV9") then
    game.CoreGui.WerbertGeneratorV9:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local IDBox = Instance.new("TextBox")
local ValueBox = Instance.new("TextBox")
local ToggleBtn = Instance.new("TextButton")
local ScanBtn = Instance.new("TextButton") -- Botão novo para ajudar a achar IDs
local CloseBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "WerbertGeneratorV9"
ScreenGui.Parent = game.CoreGui

-- Janela Principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -90)
MainFrame.Size = UDim2.new(0, 220, 0, 190)
MainFrame.Active = true
MainFrame.Draggable = true

-- Título
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "GERADOR DE MONEY V9"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextSize = 16

-- Caixa de Texto: ID
IDBox.Parent = MainFrame
IDBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
IDBox.Position = UDim2.new(0.1, 0, 0.25, 0)
IDBox.Size = UDim2.new(0.35, 0, 0, 30)
IDBox.Font = Enum.Font.Gotham
IDBox.PlaceholderText = "ID (Ex: 1476)"
IDBox.Text = "1476" -- Já vem preenchido com o seu código
IDBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IDBox.TextSize = 14
Instance.new("UICorner", IDBox).CornerRadius = UDim.new(0, 6)

-- Caixa de Texto: Valor
ValueBox.Parent = MainFrame
ValueBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ValueBox.Position = UDim2.new(0.55, 0, 0.25, 0)
ValueBox.Size = UDim2.new(0.35, 0, 0, 30)
ValueBox.Font = Enum.Font.Gotham
ValueBox.PlaceholderText = "Valor (Ex: 6)"
ValueBox.Text = "6" -- Já vem preenchido
ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ValueBox.TextSize = 14
Instance.new("UICorner", ValueBox).CornerRadius = UDim.new(0, 6)

-- Botão Ativar
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ATIVAR GERADOR"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Botão Scanner (Diagnóstico)
ScanBtn.Parent = MainFrame
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 100)
ScanBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
ScanBtn.Size = UDim2.new(0.8, 0, 0.15, 0)
ScanBtn.Font = Enum.Font.Gotham
ScanBtn.Text = "Escanear Moedas (F9)"
ScanBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
ScanBtn.TextSize = 12
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 15)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "Pronto."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 10

CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)

-- --- LÓGICA DO GERADOR ---

ToggleBtn.MouseButton1Click:Connect(function()
    _G.GeradorLigado = not _G.GeradorLigado
    if _G.GeradorLigado then
        ToggleBtn.Text = "GERANDO..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        StatusLabel.Text = "Enviando requests..."
    else
        ToggleBtn.Text = "ATIVAR GERADOR"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        StatusLabel.Text = "Parado"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    _G.GeradorLigado = false
    ScreenGui:Destroy()
end)

-- Loop Infinito (Spam do Remote)
task.spawn(function()
    while true do
        if _G.GeradorLigado then
            pcall(function()
                local id = IDBox.Text
                local val = tonumber(ValueBox.Text) or 1
                
                -- Monta o argumento EXATAMENTE como no seu exemplo
                local args = {
                    [id] = {
                        ["Coin"] = val
                    }
                }
                
                RemoteEvent:FireServer(args)
            end)
        end
        task.wait(0.1) -- Velocidade do Spam (0.1 = 10 vezes por segundo)
    end
end)

-- --- LÓGICA DO SCANNER (Para descobrir novos IDs) ---
ScanBtn.MouseButton1Click:Connect(function()
    print("--- INICIANDO SCAN DE MOEDAS ---")
    local folder = game.Workspace:FindFirstChild("DebrisClient") or game.Workspace
    
    local found = false
    for _, item in pairs(folder:GetChildren()) do
        if string.find(item.Name, "Pickup") then
            found = true
            print("MOEDA ENCONTRADA: " .. item.Name)
            print(" > Classe: " .. item.ClassName)
            
            -- Lista Atributos
            local atts = item:GetAttributes()
            for n, v in pairs(atts) do
                print(" > Atributo ["..n.."]: " .. tostring(v))
            end
            
            -- Lista Filhos (Valores escondidos)
            for _, child in pairs(item:GetChildren()) do
                if child:IsA("ValueBase") then
                     print(" > Valor ["..child.Name.."]: " .. tostring(child.Value))
                end
            end
            print("-----------------------------")
        end
    end
    
    if not found then
        print("Nenhuma moeda encontrada na pasta DebrisClient.")
        StatusLabel.Text = "Nada encontrado (veja F9)"
    else
        StatusLabel.Text = "Scan concluído (veja F9)"
    end
end)
