-- ===================================================================
-- ULTRA FPS BOOST V9 - MODO SEPARADOR DE CLIENTE/SERVIDOR
-- ===================================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- 1. CONFIGURAÇÃO DE AMBIENTE (SEM NEBLINA + FULLBRIGHT)
lighting.GlobalShadows = false
lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
lighting.Ambient = Color3.fromRGB(255, 255, 255)
lighting.FogStart = 999999
lighting.FogEnd = 999999

-- 2. LIMPADOR DE EFEITOS E DETECTOR DE TIROS/EXPLOSÕES
local function LimparEfeitos(obj)
    if not obj or not obj.Parent then return end
    
    if obj:IsA("Explosion") or obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or 
       obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Trail") or 
       obj:IsA("Beam") or obj:IsA("LineHandleAdornment") then
        obj:Destroy()
        return
    end

    local nome = string.lower(obj.Name)
    if string.find(nome, "bullet") or string.find(nome, "tracer") or string.find(nome, "effect") or 
       string.find(nome, "muzzle") or string.find(nome, "tiro") then
        obj:Destroy()
    end
end

-- 3. INTERCEPTADOR FRAME POR FRAME
runService.RenderStepped:Connect(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Explosion") or obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj:Destroy()
        end
    end
end)

workspace.DescendantAdded:Connect(LimparEfeitos)

-- 4. O MILAGRE PARA DOIS JOGOS NO MESMO PC (DESATIVAR RENDERIZAÇÃO)
-- Quando você tira o foco da janela (clica no outro jogo), este desliga os gráficos 3D
userInputService.WindowFocusReleased:Connect(function()
    runService:Set3dRenderingEnabled(false) -- Desliga os gráficos 3D da tela de trás (Zera o uso da GPU/CPU)
    if setfpscap then setfpscap(10) end     -- Força a conta de trás a rodar em 10 FPS
end)

-- Quando você clica de volta na janela, os gráficos voltam na hora
userInputService.WindowFocused:Connect(function()
    runService:Set3dRenderingEnabled(true)  -- Liga os gráficos de volta instantaneamente
    if setfpscap then setfpscap(60) end     -- Devolve os 60 FPS normais
end)

print("[FPS BOOST V9] Pronto! Otimizado para rodar localmente sem estourar o PC.")
