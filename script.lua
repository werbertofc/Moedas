--[[
    SCRIPT V5.0 - PIVOT MOVER (MÉTODO PROFISSIONAL)
    Criado para: Werbert
    Tática: Mover o Modelo (Model) inteiro usando PivotTo e forçar o toque.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Variáveis Globais
_G.WerbertFarm = false

-- --- INTERFACE LIMPA ---
if game.CoreGui:FindFirstChild("WerbertPivotV5") then
    game.CoreGui.WerbertPivotV5:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "WerbertPivotV5"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 170, 0) -- Borda Laranja
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
Title.Text = "ULTIMATE MAGNET V5"
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.TextSize = 16

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "Aguardando..."
StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
StatusLabel.TextSize = 11

ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.35, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ATIVAR MAGNET"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 33, 0, 20) -- Botãozinho no topo
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold

-- --- FUNÇÕES V5 (Pivot Logic) ---

ToggleBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = not _G.WerbertFarm
    if _G.WerbertFarm then
        ToggleBtn.Text = "ATIVADO (RODANDO)"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        StatusLabel.Text = "Tentando mover modelos..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleBtn.Text = "ATIVAR MAGNET"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        StatusLabel.Text = "Parado"
        StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    _G.WerbertFarm = false
    ScreenGui:Destroy()
end)

-- Loop Rápido (Heartbeat)
task.spawn(function()
    while true do
        if _G.WerbertFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                -- Procura no DebrisClient (Confirmado pelo seu print)
                local folder = Workspace:FindFirstChild("DebrisClient") or Workspace
                local count = 0

                for _, model in pairs(folder:GetChildren()) do
                    -- Verifica se é um MODELO e se tem o nome Pickup
                    -- E verifica se tem o HitDetect dentro dele
                    if model:IsA("Model") and string.find(model.Name, "Pickup") then
                        local hitDetect = model:FindFirstChild("HitDetect")
                        
                        if hitDetect then
                            count = count + 1
                            
                            -- 1. PREPARAÇÃO (Solta a moeda)
                            if hitDetect.Anchored then hitDetect.Anchored = false end
                            hitDetect.CanCollide = false
                            hitDetect.Size = Vector3.new(15, 15, 15) -- Tamanho Grande
                            hitDetect.Transparency = 0.5
                            
                            -- 2. MOVIMENTO PROFISSIONAL (PivotTo)
                            -- Traz o modelo INTEIRO para o seu HumanoidRootPart
                            model:PivotTo(hrp.CFrame)
                            
                            -- 3. FORÇA O TOQUE (FireTouchInterest)
                            if firetouchinterest then
                                firetouchinterest(hrp, hitDetect, 0) -- Toca
                                firetouchinterest(hrp, hitDetect, 1) -- Solta
                            end
                        end
                    end
                end
                
                if count > 0 then
                    StatusLabel.Text = "Puxando " .. count .. " moedas..."
                else
                    StatusLabel.Text = "Nenhuma moeda encontrada."
                end
            end)
        end
        task.wait(0.03) -- Loop super rápido (30ms)
    end
end)
