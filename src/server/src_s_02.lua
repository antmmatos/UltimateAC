BanList = {}

ValidWeapons = {}
RegisterServerEvent('UltimateAC:AddWeapon', function(weaponhash)
    local hashWeapon = tonumber(weaponhash)
    if ValidWeapons[source] == nil then
        ValidWeapons[source] = {}
    end
    if not inTable(ValidWeapons[source], hashWeapon) then
        table.insert(ValidWeapons[source], hashWeapon)
    end
end)

RegisterServerEvent('UltimateAC:ClearWeapons', function()
    ValidWeapons[source] = {}
end)

RegisterServerEvent('UltimateAC:RemoveWeapon', function(weaponhash)
    local hashWeapon = tonumber(weaponhash)
    if hashWeapon == nil then
        return
    end
    if ValidWeapons[source] == nil then
        ValidWeapons[source] = {}
    end
    for i, v in ipairs(ValidWeapons[source]) do
        if v == hashWeapon then
            table.remove(ValidWeapons[source], i)
        end
    end
end)

RegisterServerEvent('UltimateAC:VerifyWeapon', function(listWeapons)
    if ValidWeapons[source] == nil then
        ValidWeapons[source] = {}
        return
    end
    if listWeapons == nil then
        return
    end
    local valid = TableCompare(ValidWeapons[source], listWeapons)
    if not valid then
        -- TODO BAN, WEAPON SPAWNING
    end
end)

RegisterNetEvent('UltimateAC:ClearVehicles', function()
    for _, v in pairs(GetAllVehicles()) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)

RegisterNetEvent('UltimateAC:ClearPeds', function()
    for _, v in pairs(GetAllPeds()) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)

RegisterNetEvent('UltimateAC:ClearObjects', function()
    for _, v in pairs(GetAllObjects()) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
end)

CreateThread(function()
    LoadBans()
end)

CreateThread(function()
    while true do
        Citizen.Wait(60 * 1000)
        LoadBans()
    end
end)

function LoadBans()
    MySQL.Async.fetchAll('SELECT * FROM UltimateAC', {}, function(identifiers)
        BanList = {}
        for i = 1, #identifiers, 1 do
            table.insert(BanList, {
                license = identifiers[i].license,
                steam = identifiers[i].steam,
                ip = identifiers[i].ip,
                discord = identifiers[i].discord,
                hwid = identifiers[i].hwid,
                fivem = identifiers[i].fivem,
                xbl = identifiers[i].xbl,
                liveid = identifiers[i].liveid,
                name = identifiers[i].name,
                date = identifiers[i].date,
                reason = identifiers[i].reason
            })
        end
    end)
end

MySQL.ready(function()
    LoadBans()
end)

function onPlayerConnecting(playerName, setKickReason, deferrals)
    local _source = source
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Bem-vindo %s. A verificar a sua identificação...", playerName))
    local identifiers = ExtractIdentifiers(_source)
    Wait(1500)

    for i = 1, #BanList, 1 do
        if (tostring(BanList[i].license)) == tostring(identifiers.license) or
            (tostring(BanList[i].ip)) == tostring(identifiers.ip) or
            (tostring(BanList[i].discord)) == tostring(identifiers.discordid) or
            (tostring(BanList[i].xbl)) == tostring(identifiers.xbl) or
            (tostring(BanList[i].liveid)) == tostring(identifiers.live) or
            (tostring(BanList[i].fivem)) == tostring(identifiers.fivem) or
            (tostring(BanList[i].hwid)) == tostring(GetPlayerToken(_source, 0)) or
            (tostring(BanList[i].steam)) == tostring(identifiers.steam) then
            deferrals.done() -- TODO REASON
        end
    end
    PerformHttpRequest("http://ip-api.com/json/" .. identifiers.ip .. "?fields=66846719", function(ERROR, DATA, RESULT)
        if DATA ~= nil then
            local jsonData = json.decode(DATA)
            if jsonData ~= nil then
                Proxy = jsonData["proxy"]
                Host = jsonData["hosting"]
                if Proxy or Host then
                    -- TODO LOG, VPN
                    deferrals.done("VPN detetada! Desligue a VPN e tente novamente. IP: "..identifiers.ip)
                else
                    local playerHWID = GetPlayerToken(_source, 0)
                    if playerHWID == nil then
                        deferrals.done("HWID não encontrado. Reinicie o seu FiveM e tente novamente.")
                    else
                        -- TODO LOG, CONNECTING
                        deferrals.done()
                    end
                end
            else
                deferrals.done("Ocorreu um erro ao tentar verificar o seu IP. Tente novamente mais tarde.")
            end
        else
            deferrals.done("Ocorreu um erro ao tentar verificar o seu IP. Tente novamente mais tarde.")
        end
    end)
end

AddEventHandler('playerConnecting', onPlayerConnecting)
