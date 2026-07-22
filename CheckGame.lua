-- ==========================================
-- FishHub - Game Scanner & Loader System
-- Author: DaoHuyLam
-- ==========================================

local SUPPORTED_GAMES = {
    [134381727982611] = "https://raw.githubusercontent.com/Cachuoine/DHL/refs/heads/main/Evomon.lua",
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
