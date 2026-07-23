-- ==========================================
-- FishHub - Game Scanner & Loader System
-- Author: DaoHuyLam
-- ==========================================

local SUPPORTED_GAMES = {
    [134381727982611] = "https://raw.githubusercontent.com/Cachuoine/DaoHuyLam/refs/heads/main/Evomon.lua",
    [2753915549] = "https://raw.githubusercontent.com/Cachuoine/DaoHuyLam/refs/heads/main/Bloxfruit.lua",
    [4442272183] = "https://raw.githubusercontent.com/Cachuoine/DaoHuyLam/refs/heads/main/Bloxfruit.lua",
    [7449423635] = "https://raw.githubusercontent.com/Cachuoine/DaoHuyLam/refs/heads/main/Bloxfruit.lua",
}

local currentPlaceId = game.PlaceId
local targetScriptUrl = SUPPORTED_GAMES[currentPlaceId]

if targetScriptUrl then
    print("[FishHub] Valid game detected! Loading UI...")
    
    local success, errorMessage = pcall(function()
        loadstring(game:HttpGet(targetScriptUrl))()
    end)
    
    if not success then
        warn("[FishHub] Script execution error: " .. tostring(errorMessage))
    end
else
    game.Players.LocalPlayer:Kick("[FishHub System]\nThis game is currently not supported by the system!")
end
