ESX = nil

Citizen.CreateThread(function()
    print("^7[^2UltimateAC^7] Anticheat iniciado.")
end)

TriggerEvent(Ultimate.GetTrigger("esx:getSharedObject"), function(obj)
    ESX = obj
end)

RegisterServerEvent("UltimateAC:ScreenshotLog")
AddEventHandler("UltimateAC:ScreenshotLog", function(link, player)
    local message = "[Click here](" .. link .. ") to see a Screenshot from Player " .. GetPlayerName(player) ..
        " with ID: " .. player .. " requested by " .. GetPlayerName(source) .. " with ID: " .. source ..
        "."
    local logembed = { {
        color = "15536915",
        title = "**UltimateAnticheat**",
        description = message,
        footer = {
            text = "UltimateAC - " .. Config.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    } }
    PerformHttpRequest(Config.WebhookScreenshotRequests, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Screenshot Requests",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end)

local BlockedExplosions = { 0, 1, 2, 4, 5, 18, 19, 32, 33, 37, 38 }

AddEventHandler("explosionEvent", function(sender, ev)
    if tonumber(SRC) then
        local HWID = GetPlayerToken(SRC, 0)
        if DATA ~= nil then
            local TABLE = Explosion[DATA.explosionType]
            if TABLE ~= nil then
                local NAME = TABLE.NAME
                if TABLE.Log then
                    FIREAC_SENDLOG(SRC, FIREAC.Log.Exoplosion, "EXPLOSION", NAME)
                end
                if TABLE.Punishment ~= nil and TABLE.Punishment ~= false then
                    if TABLE.Punishment == "WARN" then
                        FIREAC_ACTION(SRC, TABLE.Punishment, "Anti Explosion",
                            "Try For Create Black List Explosion : **" .. NAME .. "**")
                        CancelEvent()
                    elseif TABLE.Punishment == "KICK" then
                        FIREAC_ACTION(SRC, TABLE.Punishment, "Anti Explosion",
                            "Try For Create Black List Explosion : **" .. NAME .. "**")
                        CancelEvent()
                    elseif TABLE.Punishment == "BAN" then
                        FIREAC_ACTION(SRC, TABLE.Punishment, "Anti Explosion",
                            "Try For Create Black List Explosion : **" .. NAME .. "**")
                        CancelEvent()
                    end
                end
            end
            --【 𝗦𝗽𝗮𝗺 𝗖𝗵𝗲𝗰𝗸 】--
            if FIREAC.AntiExplosionSpam then
                if EXPLOSION[HWID] ~= nil then
                    EXPLOSION[HWID].COUNT = EXPLOSION[HWID].COUNT + 1
                    if os.time() - EXPLOSION[HWID].TIME <= 10 then
                        EXPLOSION[HWID] = nil
                    else
                        if EXPLOSION[HWID].COUNT >= FIREAC.MaxExplosion then
                            FIREAC_ACTION(SRC, FIREAC.ExplosionSpamPunishment, "Anti Spam Explosion",
                                "Try For Spam Explosion Type: " ..
                                DATA.explosionType .. " for " .. EXPLOSION[HWID].COUNT .. " times.")
                            CancelEvent()
                        end
                    end
                else
                    EXPLOSION[HWID] = {
                        COUNT = 1,
                        TIME  = os.time()
                    }
                end
            end
        else
            CancelEvent()
        end
    else
        CancelEvent()
    end
end)

RegisterServerEvent("UltimateAC:KickPlayer")
AddEventHandler("UltimateAC:KickPlayer", function(kickMessage, playerId)
    local uPlayer = Ultimate.GetPlayerFromId(playerId)
    uPlayer.kick(kickMessage, GetPlayerName(source))
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

function LogToDiscordBan(playerid, log, link)
    local message
    if link == nil then
        message = log
    else
        message = log .. "\n**Screenshot:** [Click here](" .. link .. ")"
    end
    local logembed = { {
        color = "15536915",
        title = "**Ultimate Anticheat**",
        description = message,
        footer = {
            text = "UltimateAC - " .. Config.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    } }
    PerformHttpRequest(Config.WebhookBans, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Ban Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(Config.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Ban Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function LogToDiscordTrigger(playerid, log)
    local logembed = { {
        color = "15536915",
        title = "**Ultimate Anticheat**",
        description = log,
        footer = {
            text = "UltimateAC - " .. Config.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    } }
    PerformHttpRequest(Config.WebhookTriggers, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Blacklist Triggers Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(Config.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Blacklist Triggers Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function LogToDiscordObjects(playerid, log)
    local logembed = { {
        color = "15536915",
        title = "**Ultimate Anticheat**",
        description = log,
        footer = {
            text = "UltimateAC - " .. Config.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    } }
    PerformHttpRequest(Config.WebhookProps, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Blacklist Objects Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(Config.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Blacklist Objects Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

AddEventHandler("giveWeaponEvent", function(sender, data)
    if Validated then
        local sender = tonumber(sender)
        if sender == nil or sender <= 0 then
            if sender == nil then
                sender = 'nil'
            end
            return
        end
        TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], string.format(
            Locale[Config.Locale]["EventInject"], "giveWeaponEvent")), "AntiCheat", sender,
            string.format(Locale[Config.Locale]["EventInject"], "giveWeaponEvent"))
        CancelEvent()
    end
end)

AddEventHandler('removeWeaponEvent', function(sender, data)
    if Validated then
        local sender = tonumber(sender)
        if sender == nil or sender <= 0 then
            if sender == nil then
                sender = 'nil'
            end
            return
        end
        TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], string.format(
            Locale[Config.Locale]["EventInject"], "removeWeaponEvent")), "AntiCheat", sender,
            string.format(Locale[Config.Locale]["EventInject"], "removeWeaponEvent"))
        CancelEvent()
    end
end)

AddEventHandler("clearPedTasksEvent", function(sender, data)
    if Validated then
        local sender = tonumber(sender)
        if sender == nil or sender <= 0 then
            if sender == nil then
                sender = 'nil'
            end
            return
        end
        TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], string.format(
            Locale[Config.Locale]["EventInject"], "clearPedTasksEvent")), "AntiCheat", sender,
            string.format(Locale[Config.Locale]["EventInject"], "clearPedTasksEvent"))
        CancelEvent()
    end
end)

AddEventHandler('ptFxEvent', function(sender, data)
    local sender = tonumber(sender)
    local model = tonumber(data.effectHash)
    if Validated then
        if sender == nil or sender <= 0 then
            return
        end
        for k, v in pairs(Blacklist["ptFx"]) do
            if model == GetHashKey(v) then
                TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], string.format(
                    Locale[Config.Locale]["Particles"], model)), "AntiCheat", sender,
                    string.format(Locale[Config.Locale]["Particles"], model))
                CancelEvent()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while not Validated do
        Citizen.Wait(100)
    end
    if Validated then
        Citizen.Wait(1000)

        for k, trigger in pairs(Blacklist["Events"]) do
            RegisterServerEvent(trigger)
            AddEventHandler(trigger, function()
                local _source = source
                local License = nil
                local PlayerIP = nil
                local DiscordID = nil
                local PlayerName = GetPlayerName(_source)
                local SteamID = nil

                for k, v in pairs(GetPlayerIdentifiers(_source)) do
                    if string.sub(v, 1, string.len("license:")) == "license:" then
                        License = v
                    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                        PlayerIP = v
                    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                        DiscordID = v
                    elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                        SteamID = v
                    end
                end

                if PlayerIP == nil then
                    PlayerIP = GetPlayerEndpoint(_source)
                    if PlayerIP == nil then
                        PlayerIP = 'IP NOT FOUND'
                    end
                end
                if DiscordID == nil then
                    DiscordID = 'DISCORD NOT FOUND'
                end
                local uPlayer = Ultimate.GetPlayerFromId(_source)
                if uPlayer.isAdmin() then
                    return
                end
                LogToDiscordTrigger(_source,
                    "**Player Name:** " ..
                    PlayerName .. "\n**ServerID:** " .. _source .. "\n**SteamID:** " .. SteamID ..
                    "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
                    DiscordID:gsub("discord:", "") ..
                    ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Trigger:** " ..
                    trigger)
                TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], string.format(
                    Locale[Config.Locale]["BlacklistTrigger"], trigger)), "AntiCheat", _source,
                    string.format(Locale[Config.Locale]["BlacklistTrigger"], trigger))
                CancelEvent()
            end)
        end
    end
end)

function notZero(model)
    return model ~= 0
end

AddEventHandler("entityCreating", function(entity)
    if Validated and Config.AntiBlacklistEntities then
        local _src = NetworkGetEntityOwner(entity)
        local model = GetEntityModel(entity)
        if model == 2116969379 then
            return
        end
        local _entitytype = GetEntityPopulationType(entity)
        ----- Start Verifications -----
        if not DoesEntityExist(entity) then
            return
        end
        if _src == nil then
            CancelEvent()
            return
        end
        local uPlayer = Ultimate.GetPlayerFromId(tonumber(_src))
        while uPlayer == nil do
            Citizen.Wait(100)
            uPlayer = Ultimate.GetPlayerFromId(tonumber(_src))
        end
        if uPlayer.isAdmin() then
            return
        end
        if not notZero(model) then
            return
        end
        ----- End Verifications -----
        ----- Start Unknown Entity -----
        if _entitytype == 0 then
            if inTableHash(Whitelist["Props"], model) then
                return
            end
            LogProps(_src, model)
            CancelEvent()
            otherEntitiesSpawned[_src] = (otherEntitiesSpawned[_src] or 0) + 1
            if otherEntitiesSpawned[_src] > Config.MaxPropSpawn then
                LogPropsMass(_src, otherEntitiesSpawned[_src], model)

                TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                    Locale[Config.Locale]["MassPropSpawn"]), "AntiCheat", _src, Locale[Config.Locale]["MassPropSpawn"])
            end
            ----- End Unknown Entity -----
        else
            ----- Start Entity Type Verification -----
            if _entitytype ~= 6 and _entitytype ~= 7 then
                return
            end
            ----- End Entity Type Verification -----
            ----- Start Prop Verification -----
            if GetEntityType(entity) == 3 then
                if inTableHash(Whitelist["Props"], model) then
                    return
                end
                if inTableHash(Blacklist["Props"], model) then
                    LogProps(_src, model)
                    TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        string.format(Locale[Config.Locale]["BlacklistProp"], model)), "AntiCheat", _src,
                        string.format(Locale[Config.Locale]["BlacklistProp"], model))
                    CancelEvent()
                end
                entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                if entitiesSpawned[_src] > Config.MaxPropSpawn then
                    LogPropsMass(_src, entitiesSpawned[_src], model)
                    TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["MassPropSpawn"]), "AntiCheat", _src,
                        Locale[Config.Locale]["MassPropSpawn"])
                end
                ----- End Prop Verification -----
                ----- Start Vehicle Verification -----
            elseif GetEntityType(entity) == 2 then
                if inTable(Blacklist["Vehicles"], model) then
                    LogProps(_src, model)
                    TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        string.format(Locale[Config.Locale]["BlacklistVehicle"], model)), "AntiCheat", _src,
                        string.format(Locale[Config.Locale]["BlacklistVehicle"], model))
                    CancelEvent()
                end
                vehiclesSpawned[_src] = (vehiclesSpawned[_src] or 0) + 1
                if vehiclesSpawned[_src] > Config.MaxVehicleSpawn then
                    LogPropsMass(_src, vehiclesSpawned[_src], model)
                    TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["MassVehicleSpawn"]), "AntiCheat", _src,
                        Locale[Config.Locale]["MassVehicleSpawn"])
                    CancelEvent()
                end
                ----- End Vehicle Verification -----
                ----- Start Peds Verification -----
            elseif GetEntityType(entity) == 1 then
                for k, v in pairs(Blacklist["Peds"]) do
                    if model == GetHashKey(v) then
                        print(v)
                        if GetSelectedPedWeapon(entity) == -1569615261 or GetSelectedPedWeapon(entity) == 1834241177 or
                            GetSelectedPedWeapon(entity) == -1312131151 or GetSelectedPedWeapon(entity) == 1119849093 or
                            GetSelectedPedWeapon(entity) == -1238556825 or GetSelectedPedWeapon(entity) == 1672152130 or
                            GetSelectedPedWeapon(entity) == -1074790547 then
                            TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                                string.format(Locale[Config.Locale]["BlacklistPeds"], v)), "AntiCheat", _src,
                                string.format(Locale[Config.Locale]["BlacklistPeds"], v))
                            CancelEvent()
                        end
                    end
                end
                if inTableHash(Whitelist["Peds"], model) then
                    return
                end
                pedsSpawned[_src] = (pedsSpawned[_src] or 0) + 1
                if pedsSpawned[_src] > Config.MaxPedsSpawn then
                    LogPropsMass(_src, pedsSpawned[_src], model)
                    TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["MassPedSpawn"]), "AntiCheat", _src, Locale[Config.Locale]["MassPedSpawn"])
                end
                ----- End Peds Verification -----
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        entitiesSpawned = {}
        pedsSpawned = {}
        vehiclesSpawned = {}
        otherEntitiesSpawned = {}
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

function LogPropsMass(src, quantity, model)
    local License = nil
    local PlayerIP = nil
    local DiscordID = nil
    local PlayerName = GetPlayerName(src)
    local SteamID = nil

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            License = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            PlayerIP = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            DiscordID = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            SteamID = v
        end
    end

    if PlayerIP == nil then
        PlayerIP = GetPlayerEndpoint(src)
        if PlayerIP == nil then
            PlayerIP = 'IP NOT FOUND'
        end
    end
    if DiscordID == nil then
        DiscordID = 'DISCORD NOT FOUND'
    end
    LogToDiscordObjects(src,
        "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. src .. "\n**SteamID:** " .. SteamID ..
        "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
        DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Object:** " .. model ..
        "\n**Quantity:** " .. quantity)
end

function LogProps(src, model)
    local License = nil
    local PlayerIP = nil
    local DiscordID = nil
    local PlayerName = GetPlayerName(src)
    local SteamID = nil

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            License = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            PlayerIP = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            DiscordID = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            SteamID = v
        end
    end

    if PlayerIP == nil then
        PlayerIP = GetPlayerEndpoint(src)
        if PlayerIP == nil then
            PlayerIP = 'IP NOT FOUND'
        end
    end
    if DiscordID == nil then
        DiscordID = 'DISCORD NOT FOUND'
    end
    LogToDiscordObjects(src,
        "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. src .. "\n**SteamID:** " .. SteamID ..
        "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
        DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Object:** " .. model)
end

RegisterServerEvent("UltimateAC:clearLoadout")
AddEventHandler("UltimateAC:clearLoadout", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    for i = #xPlayer.loadout, 1, -1 do
        xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
end)

RegisterServerEvent("UltimateAC:clearInventory")
AddEventHandler("UltimateAC:clearInventory", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    for k, v in ipairs(xPlayer.inventory) do
        if v.count > 0 then
            xPlayer.removeInventoryItem(v.name, v.count)
        end
    end
    xPlayer.setMoney(0)
end)

RegisterCommand("unoclip", function(source, args, rawCommand)
    if Validated then
        if source == 0 then
            return
        end
        local uPlayer = Ultimate.GetPlayerFromId(tonumber(source))
        if not uPlayer then return end
        if uPlayer.isAdmin() then
            TriggerClientEvent("UltimateAC:unoclip", source)
        end
    end
end)

RegisterCommand("ultimate", function(source, args, rawCommand)
    if Validated then
        if source == 0 then
            return
        end
        local uPlayer = Ultimate.GetPlayerFromId(tonumber(source))
        if uPlayer.isAdmin() then
            PerformHttpRequest("http://localhost/ACMenu", function(arg, request)
                TriggerClientEvent("UltimateAC:openMenu", source, request)
            end)
        end
    end
end)

RegisterCommand("print", function(source, args, rawCommand)
    if Validated then
        local _source = source
        if source ~= 0 then
            local uPlayer = Ultimate.GetPlayerFromId(tonumber(_source))
            if uPlayer.isAdmin() then
                if not args[1] then
                    return
                end
                local screenshot = TriggerClientCallback {
                    source = tonumber(args[1]),
                    eventName = 'UltimateAC:RequestScreenshot'
                }
                ScreenshotCommand(screenshot, _source, args[1])
            end
        else
            if not args[1] then
                return
            end
            local screenshot = TriggerClientCallback {
                source = tonumber(args[1]),
                eventName = 'UltimateAC:RequestScreenshot'
            }
            ScreenshotCommand(screenshot, "Console", args[1])
        end
    end
end)

function ScreenshotCommand(link, source, player)
    local message
    if source == "Console" then
        message = "[Click here](" .. link .. ") to see a Screenshot from Player " .. GetPlayerName(player) ..
            " with ID: " .. player .. " requested by Console."
    else
        message = "[Click here](" .. link .. ") to see a Screenshot from Player " .. GetPlayerName(player) ..
            " with ID: " .. player .. " requested by " .. GetPlayerName(source) .. " with ID: " .. source .. "."
    end
    local logembed = { {
        color = "15536915",
        title = "**UltimateAnticheat**",
        description = message,
        footer = {
            text = "UltimateAC - " .. Config.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    } }
    PerformHttpRequest(Config.WebhookScreenshotRequests, function(err, text, headers)
    end, 'POST', json.encode({
        username = "UltimateAC | Screenshot Requests",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

AddEventHandler("clearPedTasksEvent", function(source, data)
    if Validated then
        if Config.AntiClearPedTasksImmediately then
            local _source = source
            local uPlayer = Ultimate.GetPlayerFromId(tonumber(_source))
            if data.immediately and not uPlayer.isAdmin() then
                TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                    Locale[Config.Locale]["ClearPedTasks"]), "AntiCheat", source, Locale[Config.Locale]["ClearPedTasks"])
                CancelEvent()
            end
        end
    end
end)
