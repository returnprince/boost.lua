-- ====================================================================
-- INSTÂNCIA DE INTERFACE NATIVA - BYPASS EDITION
-- ====================================================================

-- Limpeza rigorosa de instâncias antigas para evitar sobreposição
for _, antigo in pairs(game:GetService("CoreGui"):GetChildren()) do
    if antigo.Name == "OrionMenuNativo" then 
        antigo:Destroy() 
    end
end

-- 1. ESTRUTURA BASE (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrionMenuNativo"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Estado do Menu (Aberto/Fechado)
local MenuAberto = true

-- ====================================================================
-- JANELA PRINCIPAL (MAIN FRAME)
-- ====================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Janela principal arrastável pelo usuário

-- Cantos arredondados para a janela principal
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Barra de Título (TopBar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "⚡ ORION UTILITY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Estado de Controle do Modificador
local Modos = {
    OneShot = false
}

-- ====================================================================
-- INTERCEPTAÇÃO DE METATABELAS (HOOK - ONE SHOT DO COPIADO)
-- ====================================================================
local RawMeta = getrawmetatable(game)
local OldNamecall = RawMeta.__namecall
setreadonly(RawMeta, false)

RawMeta.__namecall = newcclosure(function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Modos.OneShot and (Method == "FireServer" or Method == "InvokeServer") then
        for i, v in pairs(Args) do
            if type(v) == "number" and v > 0 and v < 500 then
                Args[i] = 999999 -- Força o valor de dano agressivo na memória do envio
                return OldNamecall(Self, unpack(Args))
            end
        end
    end
    
    return OldNamecall(Self, ...)
end)
setreadonly(RawMeta, true)

-- ====================================================================
-- CRIAÇÃO DOS BOTÕES OPERACIONAIS
-- ====================================================================

-- BOTÃO 1: MULTIPLICADOR DE DANO (ONE SHOT)
local BtnOneShot = Instance.new("TextButton")
BtnOneShot.Parent = MainFrame
BtnOneShot.Size = UDim2.new(1, -40, 0, 45)
BtnOneShot.Position = UDim2.new(0, 20, 0, 55)
BtnOneShot.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BtnOneShot.Text = "Multiplicador (One Shot): DESLIGADO"
BtnOneShot.TextColor3 = Color3.fromRGB(220, 220, 220)
BtnOneShot.Font = Enum.Font.SourceSansSemibold
BtnOneShot.TextSize = 14
BtnOneShot.BorderSizePixel = 0

local BtnCorner1 = Instance.new("UICorner")
BtnCorner1.CornerRadius = UDim.new(0, 6)
BtnCorner1.Parent = BtnOneShot

BtnOneShot.MouseButton1Click:Connect(function()
    Modos.OneShot = not Modos.OneShot
    if Modos.OneShot then
        BtnOneShot.BackgroundColor3 = Color3.fromRGB(0, 140, 60)
        BtnOneShot.Text = "Multiplicador (One Shot): LIGADO"
    else
        BtnOneShot.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        BtnOneShot.Text = "Multiplicador (One Shot): DESLIGADO"
    end
end)

-- BOTÃO 2: REJOIN (RECONEXÃO INTEGRADA)
local BtnRejoin = Instance.new("TextButton")
BtnRejoin.Parent = MainFrame
BtnRejoin.Size = UDim2.new(1, -40, 0, 45)
BtnRejoin.Position = UDim2.new(0, 20, 0, 115)
BtnRejoin.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BtnRejoin.Text = "🔄 Forçar Rejoin (Limpar Instância)"
BtnRejoin.TextColor3 = Color3.fromRGB(240, 240, 240)
BtnRejoin.Font = Enum.Font.SourceSansSemibold
BtnRejoin.TextSize = 14
BtnRejoin.BorderSizePixel = 0

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 6)
BtnCorner2.Parent = BtnRejoin

BtnRejoin.MouseButton1Click:Connect(function()
    BtnRejoin.Text = "Reconectando..."
    BtnRejoin.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
    task.wait(0.3)
    
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local placeId = game.PlaceId
    local serverId = game.JobId
    
    pcall(function()
        if serverId ~= "" then
            TeleportService:TeleportToPlaceInstance(placeId, serverId, Players.LocalPlayer)
         else
            TeleportService:Teleport(placeId, Players.LocalPlayer)
         end
    end)
end)

-- Rodapé de Status
local Footer = Instance.new("TextLabel")
Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.Text = "Ambiente Local Ativo"
Footer.TextColor3 = Color3.fromRGB(100, 100, 110)
Footer.Font = Enum.Font.SourceSansItalic
Footer.TextSize = 11
Footer.BackgroundTransparency = 1

-- ====================================================================
-- BOTÃO FLUTUANTE (MÓVEL / ALTERNADOR)
-- ====================================================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "BotaoFlutuante"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0) -- Posição inicial no canto superior esquerdo
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.BorderSizePixel = 0
ToggleButton.Active = true
ToggleButton.Draggable = true -- Torna a bolha livremente movível pela tela

-- Deixa o botão perfeitamente circular
local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleButton

-- Mecânica de abrir/fechar ao clicar na bolha flutuante
ToggleButton.MouseButton1Click:Connect(function()
    MenuAberto = not MenuAberto
    MainFrame.Visible = MenuAberto
end)
