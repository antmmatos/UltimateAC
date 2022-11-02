ESX = nil

Citizen.CreateThread(function()
    print("^7[^2UltimateAC^7] Anticheat iniciado.")
end)

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterServerEvent("UltimateAC:ban")
AddEventHandler("UltimateAC:ban", function(reason)
    local _source = source
    local identifiers = ExtractIdentifiers(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" then
        return
    end
    LogToDiscord(_source, "Ban", reason, screenshot)
    MySQL.query("INSERT INTO ultimateac (name, steam, license, discord, ip, xbl, liveid, fivem, hwid, reason) VALUES (@identifier, @reason)", {
        ['@identifier'] = identifiers.steam,
        ['@reason'] = reason
    })
    DropPlayer(_source, "UltimateAC\n\nVocê foi banido permamentemente do servidor.\nMotivo: " .. reason)
end)

local playersExplosion = {}
AddEventHandler("explosionEvent", function(sender, ev)
    if tonumber(sender) then
        local playerHWID = GetPlayerToken(sender, 0)
        if ev ~= nil then
            local explosionType = Table["Explosions"][ev.explosionType]
            if explosionType ~= nil then
                local explosionName = explosionType.Name
                -- TODO LOG, EXPLOSION
                if explosionType.Ban then
                    -- TODO BAN, EXPLOSION
                    CancelEvent()
                end
            end
            if playersExplosion[playerHWID] ~= nil then
                playersExplosion[playerHWID].count = playersExplosion[playerHWID].count + 1
                if os.time() - playersExplosion[playerHWID].time <= 10 then
                    playersExplosion[playerHWID] = nil
                else
                    if playersExplosion[playerHWID].count >= 10 then
                        -- TODO BAN, MASS EXPLOSION
                        CancelEvent()
                    end
                end
            else
                playersExplosion[playerHWID] = {
                    count = 1,
                    time  = os.time()
                }
            end
        else
            CancelEvent()
        end
    else
        CancelEvent()
    end
end)

RegisterServerEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function (playerId)
    TriggerClientEvent("UltimateAC:LoadTables", playerId, Table)
end)

RegisterServerEvent("UltimateAC:KickPlayer")
AddEventHandler("UltimateAC:KickPlayer", function(target, kickMessage)
    DropPlayer(target, kickMessage)
end)

RegisterServerEvent("UltimateAC:bring")
AddEventHandler("UltimateAC:bring", function(target, coords)
    TriggerClientEvent("UltimateAC:bring", target, coords)
end)

RegisterServerEvent("UltimateAC:goto")
AddEventHandler("UltimateAC:goto", function(target)
    local targetPed = GetEntityCoords(GetPlayerPed(target))
    TriggerClientEvent("UltimateAC:goto", source, targetPed)
end)

function LogToDiscord(source, category, reason)
    local playerName = GetPlayerName(source)
    local playerHWID = GetPlayerToken(source, 0)
    local identifiers = ExtractIdentifiers(source)
    local ISP = ""
    local City = ""
    local Country = ""
    local Proxy = ""
    local Hosting = ""
    PerformHttpRequest("http://ip-api.com/json/" .. identifiers.ip or GetPlayerEndpoint(source) .. "?fields=66846719",
        function(err, data, headers)
            if data ~= nil then
                local jsonData = json.decode(data)
                if jsonData ~= nil then
                    ISP = jsonData["isp"]
                    City = jsonData["city"]
                    Country = jsonData["country"]
                    Proxy = jsonData["proxy"]
                    Hosting = jsonData["hosting"]
                    local embed = {
                        {
                            footer = {
                                text = "UltimateAC | " .. os.date("%Y/%m/%d | %X") .. "",
                            },
                            title = "UltimateAC Logs - " .. category,
                            description =
                            "**Player Name:** " ..
                                playerName ..
                                "\n**Player HWID:** " ..
                                playerHWID ..
                                "\n**Steam Hex:** " ..
                                identifiers.steam ..
                                "\n**Discord ID:** " ..
                                identifiers.discordid ..
                                "\n**Discord Name:** " ..
                                identifiers.discord ..
                                "\n**License:** " ..
                                identifiers.license ..
                                "\n**Live:** " ..
                                identifiers.live ..
                                "\n**Xbox:** " ..
                                identifiers.xbl ..
                                "\n**ISP:** " ..
                                ISP ..
                                "\n**País:** " ..
                                Country ..
                                "\n**Cidade:** " ..
                                City .. "\n**IP:** " .. identifiers.ip or
                                GetPlayerEndpoint(source) .. "\n**VPN:** " .. Proxy ..
                                "\n**Hosting:** " .. Hosting .. "",
                            color = 1769216
                        }
                    }
                    if category == "Explosion" then
                        embed[1].description = embed[1].description .. "\n**Explosion:** " .. reason .. ""
                    elseif category == "Ban" then
                        embed[1].description = embed[1].description .. "\n**Ban:** " .. reason .. ""
                    elseif category == "Connecting" then
                        embed[1].color = 65280
                    elseif category == "Disconnecting" then
                        embed[1].color = 16711680
                    end
                    PerformHttpRequest(Webhooks[category], function(ERROR, DATA, RESULT)
                    end, "POST", json.encode({
                        embeds = embed,
                        username = "UltimateAC Logs - " .. category
                    }), {
                        ["Content-Type"] = "application/json"
                    })
                end
            end
        end
    )
end

AddEventHandler("giveWeaponEvent", function(sender, data)
    -- TODO BAN, GIVE WEAPON
    CancelEvent()
end)

AddEventHandler('removeWeaponEvent', function(sender, data)
    -- TODO BAN, REMOVE WEAPON
    CancelEvent()
end)

AddEventHandler("clearPedTasksEvent", function(sender, data)
    -- TODO BAN, CLEAR PED TASKS
    CancelEvent()
end)

AddEventHandler('ptFxEvent', function(sender, data)
    local model = tonumber(data.effectHash)
    for k, v in pairs(Table["ptFx"]) do
        if model == GetHashKey(v) then
            -- TODO BAN, PTFX
            CancelEvent()
        end
    end
end)

Citizen.CreateThread(function()
    for _, trigger in pairs(Table["Events"]) do
        RegisterServerEvent(trigger)
        AddEventHandler(trigger, function()
            -- TODO LOG, EVENT
            -- TODO BAN, EVENT
            CancelEvent()
        end)
    end
end)

local playersVehicles = {}
local playersPeds = {}
local playersObjects = {}
AddEventHandler("entityCreated", function(entity)
    if DoesEntityExist(entity) then
        local type = GetEntityType(entity)
        local owner = NetworkGetFirstEntityOwner(entity)
        local model = GetEntityModel(entity)
        local playerHWID = GetPlayerToken(owner, 0)
        if type == 3 then
            for _, value in ipairs(Table["Props"]) do
                if model == GetHashKey(value) then
                    if DoesEntityExist(entity) then
                        DeleteEntity(entity)
                        Wait(1000)
                        -- TODO BAN, BLACKLIST OBJECT
                    end
                end
            end
            if playersObjects[playerHWID] ~= nil then
                playersObjects[playerHWID].count = playersObjects[playerHWID].count + 1
                if os.time() - playersObjects[playerHWID].time >= 10 then
                    playersObjects[playerHWID] = nil
                else
                    if playersObjects[playerHWID].count >= 15 then
                        for _, objects in ipairs(GetAllObjects()) do
                            local entityOwner = NetworkGetFirstEntityOwner(objects)
                            if entityOwner == owner then
                                if DoesEntityExist(objects) then
                                    DeleteEntity(objects)
                                end
                            end
                        end
                        -- TODO BAN, MASS OBJECT SPAWN
                    end
                end
            else
                playersObjects[playerHWID] = {
                    count = 1,
                    time  = os.time()
                }
            end
        end
        if type == 1 then
            for _, value in ipairs(Table["Peds"]) do
                if model == GetHashKey(value) then
                    if DoesEntityExist(entity) then
                        DeleteEntity(entity)
                        Wait(1000)
                        -- TODO BAN, BLACKLIST PED
                    end
                end
            end
            if playersPeds[playerHWID] ~= nil then
                playersPeds[playerHWID].count = playersPeds[playerHWID].count + 1
                if os.time() - playersPeds[playerHWID].time >= 10 then
                    playersPeds[playerHWID] = nil
                else
                    for _, peds in ipairs(GetAllPeds()) do
                        local entityOwner = NetworkGetFirstEntityOwner(peds)
                        if entityOwner == owner then
                            if DoesEntityExist(peds) then
                                DeleteEntity(peds)
                            end
                        end
                    end
                    if playersPeds[playerHWID].count >= 4 then
                        -- TODO BAN, MASS PED SPAWN
                    end
                end
            else
                playersPeds[playerHWID] = {
                    count = 1,
                    time  = os.time()
                }
            end
        end
        if type == 2 then
            for _, value in ipairs(Table["Vehicles"]) do
                if model == GetHashKey(value) then
                    if DoesEntityExist(entity) then
                        DeleteEntity(entity)
                        Wait(1000)
                        -- TODO BAN, BLACKLIST VEHICLE
                    end
                end
            end
            if playersVehicles[playerHWID] ~= nil then
                playersVehicles[playerHWID].count = playersVehicles[playerHWID].count + 1
                if os.time() - playersVehicles[playerHWID].time >= 10 then
                    playersVehicles[playerHWID] = nil
                else
                    if playersVehicles[playerHWID].count >= 10 then
                        for _, vehicle in ipairs(GetAllVehicles()) do
                            local entityOwner = NetworkGetFirstEntityOwner(vehicle)
                            if entityOwner == owner then
                                if DoesEntityExist(vehicle) then
                                    DeleteEntity(vehicle)
                                end
                            end
                        end
                        -- TODO BAN, MASS VEHICLE SPAWN
                    end
                end
            else
                playersVehicles[playerHWID] = {
                    count = 1,
                    time  = os.time()
                }
            end
        end
    end
end)

inTable = function(table, item)
    for k, v in pairs(table) do
        if v == item then
            return true
        end
    end
    return false
end

function ExtractIdentifiers(src)

    local identifiers = {
        steam = "",
        ip = nil,
        discord = "",
        discordid = "",
        license = "",
        xbl = "",
        live = "",
        fivem = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.sub(id, 1, string.len("discord:")) == "discord:" then
            identifiers.discordid = string.sub(id, 9)
            identifiers.discord = "<@" .. discordid .. ">"
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        elseif string.find(id, "fivem") then
            identifiers.fivem = id
        end
    end

    return identifiers
end
