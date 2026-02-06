--[[
    SCRIPT V4.0 - HITBOX EXPANDER (A SOLUÇÃO FINAL)
    Lógica: Se a moeda não vem, nós crescemos para tocar nela.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

_G.ModoColeta = false

-- --- INTERFACE LIMPA ---
if game.CoreGui:FindFirstChild("WerbertHitboxV4") then
    game.CoreGui.WerbertHitboxV4:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local RangeLabel = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "WerbertHitboxV4"
ScreenGui.Parent = game.CoreGui

-- Janela
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Título
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "COLETOR V4 (ALCANCE)"
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.TextSize = 14

-- Info
RangeLabel.Parent = MainFrame
RangeLabel.BackgroundTransparency = 1
RangeLabel.Position = UDim2.new(0, 0, 0.75, 0)
RangeLabel.Size = UDim2.new(1, 0, 0, 20)
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.Text = "Status: Normal"
RangeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
RangeLabel.TextSize = 12

-- Botão Ativar
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ATIVAR ALCANCE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Botão Fechar
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold

-- --- LÓGICA V4 ---

local originalSize = Vector3.new(2, 2, 1) -- Tamanho padrão do Roblox
local function ResetCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Size = originalSize
        LocalPlayer.Character.HumanoidRootPart.Transparency = 1
        LocalPlayer.Character.HumanoidRootPart.CanCollide = true
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.ModoColeta = not _G.ModoColeta
    if _G.ModoColeta then
        ToggleBtn.Text = "DESATIVAR"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        RangeLabel.Text = "Status: ALCANCE GIGANTE"
        RangeLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleBtn.Text = "ATIVAR ALCANCE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        RangeLabel.Text = "Status: Normal"
        RangeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        ResetCharacter()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    _G.ModoColeta = false
    ResetCharacter()
    ScreenGui:Destroy()
end)

-- Loop Infinito (RenderStepped roda antes de cada frame de vídeo)
RunService.RenderStepped:Connect(function()
    if _G.ModoColeta then
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- AQUI ESTÁ O SEGREDO V4:
            -- Em vez de mexer na moeda, aumentamos VOCÊ.
            -- 80 studds é um alcance enorme.
            hrp.Size = Vector3.new(80, 80, 80) 
            hrp.Transparency = 0.8 -- Levemente visível para você ver o tamanho
            hrp.CanCollide = false -- Para você não sair voando ao encostar em paredes
            
            -- Mantém o chão firme (opcional, para não afundar)
            if char:FindFirstChild("Humanoid") then
               char.Humanoid.HipHeight = 0 -- Evita pular alto demais por causa do tamanho
            end

            -- Busca as moedas apenas para tentar o toque extra
            local debris = Workspace:FindFirstChild("DebrisClient") or Workspace
            for _, item in pairs(debris:GetChildren()) do
                if string.find(item.Name, "Pickup") and item:FindFirstChild("HitDetect") then
                    -- Se a moeda estiver dentro do seu corpo gigante
                    if (item.HitDetect.Position - hrp.Position).Magnitude < 80 then
                        -- Força o toque
                        if firetouchinterest then
                            firetouchinterest(hrp, item.HitDetect, 0)
                            firetouchinterest(hrp, item.HitDetect, 1)
                        end
                    end
                end
            end
        end)
    end
end)
