--[[
    COLETOR DE MOEDAS V3 - FORCE UPDATE
    Criado para: Werbert
    Método: RenderStepped Loop (Força Bruta)
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variáveis de Controle
_G.WerbertFarm = false

-- --- INTERFACE GRÁFICA (UI) ---
if game.CoreGui:FindFirstChild("WerbertHubV3") then
    game.CoreGui.WerbertHubV3:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local CountLabel = Instance.new("TextLabel") -- Mostra quantas moedas achou
local MinimizeBtn = Instance.new("TextButton")
local OpenBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "WerbertHubV3"
ScreenGui.Parent = game.CoreGui

-- Janela Principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -80)
MainFrame.Size = UDim2.new(0, 200, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 10)
MC.Parent = MainFrame

-- Título
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "FORCE COLLECTOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextSize = 16

-- Contador de Moedas (Diagnóstico)
CountLabel.Parent = MainFrame
CountLabel.BackgroundTransparency = 1
CountLabel.Position = UDim2.new(0, 0, 0, 30)
CountLabel.Size = UDim2.new(1, 0, 0, 20)
CountLabel.Font = Enum.Font.Code
CountLabel.Text = "Moedas encontradas: 0"
CountLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CountLabel.TextSize = 12

-- Botão Ligar/Desligar
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.35, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "DESATIVADO"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

local BC = Instance.new("UICorner")
BC.CornerRadius = UDim.new(0, 8)
BC.Parent = ToggleBtn

-- Botão Minimizar
MinimizeBtn.Parent = MainFrame
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Position = UDim2.new(0.8, 0, 0, 5)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
local MinC = Instance.new("UICorner")
MinC.Parent = MinimizeBtn

-- Botão Flutuante (Abrir)
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Text = "V3"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 20
OpenBtn.Draggable = true
local OC = Instance.new("UICorner")
OC.CornerRadius = UDim.new(1, 0)
OC.Parent = OpenBtn

-- --- FUNÇÕES DE CONTROLE ---

ToggleBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = not _G.WerbertFarm
    if _G.WerbertFarm then
        ToggleBtn.Text = "ATIVADO"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        ToggleBtn.Text = "DESATIVADO"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- --- LÓGICA PRINCIPAL (HEARTBEAT) ---

RunService.Heartbeat:Connect(function()
    if _G.WerbertFarm then
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Tenta achar a pasta DebrisClient, se não achar, usa o Workspace
            local targetFolder = Workspace:FindFirstChild("DebrisClient") or Workspace
            
            local moedasEncontradas = 0

            for _, item in pairs(targetFolder:GetChildren()) do
                -- Verifica se o nome começa com "Pickup"
                if string.sub(item.Name, 1, 6) == "Pickup" then
                    local hitPart = item:FindFirstChild("HitDetect")
                    
                    if hitPart then
                        moedasEncontradas = moedasEncontradas + 1
                        
                        -- Configurações da moeda
                        hitPart.CanCollide = false
                        hitPart.Anchored = true -- Ancorar perto de você evita que ela caia no void
                        hitPart.Transparency = 0.5
                        hitPart.Size = Vector3.new(15, 15, 15) -- Tamanho Grande
                        
                        -- Traz a moeda para o jogador CONSTANTEMENTE
                        hitPart.CFrame = hrp.CFrame
                        
                        -- Tenta coletar com firetouchinterest (se disponível)
                        if firetouchinterest then
                            firetouchinterest(hrp, hitPart, 0)
                            firetouchinterest(hrp, hitPart, 1)
                        end
                    end
                end
            end
            
            -- Atualiza o texto da UI
            CountLabel.Text = "Moedas Detectadas: " .. moedasEncontradas
        end)
    end
end)
