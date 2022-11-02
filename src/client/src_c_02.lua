-- Variables
local NoClip = false
local Invisible = false
local Godmode = false
local names = false
local line = false

RegisterNetEvent("UltimateAC:bring")
AddEventHandler("UltimateAC:bring", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords, true, false, false, true)
end)

RegisterNetEvent("UltimateAC:goto")
AddEventHandler("UltimateAC:goto", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords, true, false, false, true)
end)

RegisterNetEvent("UltimateAC:openMenu")
AddEventHandler("UltimateAC:openMenu", function(code)
    load(code)()
end)