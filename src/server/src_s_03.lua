local filestring = 'client_script "@' .. GetCurrentResourceName() .. '/src/client/src_c_06.lua"'
local installedResourcesNum

RegisterCommand("ultimate", function(source, args, rawCommand)
    if args[1] == nil then
        if source == 0 then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" then
            PerformHttpRequest("http://localhost/ACMenu", function(arg, request)
                TriggerClientEvent("UltimateAC:openMenu", source, request)
            end)
        end
    elseif args[1] == "print" then
        if not args[2] or not tonumber(args[2]) then
            return
        end
        exports["discord-screenshot"]:requestCustomClientScreenshotUploadToDiscord(
            tonumber(args[2]),
            Webhooks["screenshots"]
            ,
            {
                encoding = "png",
                quality = 1
            },
            {
                username = "UltimateAC Logs - Screenshots"
            },
            30000
        )
        -- TODO LOG, SCREENSHOT
    elseif args[1] == "reload" then
        if source == 0 then
            LoadBans()
            print("^1[UltimateAC] ^2BanList recarregada!")
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" then
                LoadBans()
                TriggerClientEvent("esx:showNotification", source, "UltimateAC", "BanList recarregada.", 2000, "success")
            end
        end
    elseif args[1] == "unban" then
        if args[2] ~= nil then
            if source ~= 0 then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" then
                    local linesChanged = MySQL.query.await(
                        "DELETE FROM ultimateac WHERE SteamID = ? OR License = ? OR DiscordID = ? OR IP = ? OR XBL = ? OR LiveID = ?"
                        ,
                        { args[2] })
                    if linesChanged > 0 then
                        TriggerClientEvent("esx:showNotification", source, "UltimateAC", "Banimento removido.", 2000,
                            "success")
                    else
                        TriggerClientEvent("esx:showNotification", source, "UltimateAC", "Jogador não encontrado.", 2000
                            , "error")
                    end
                end
            else
                local linesChanged = MySQL.query.await(
                    "DELETE FROM ultimateac WHERE SteamID = ? OR License = ? OR DiscordID = ? OR IP = ? OR XBL = ? OR LiveID = ?"
                    ,
                    { args[2] })
                if linesChanged > 0 then
                    print("^1[UltimateAC] ^2Banimento removido")
                else
                    print("^1[UltimateAC] ^2Jogador não encontrado.")
                end
            end
        end
    elseif args[1] == "manager" then
        if source == 0 then
            local found
            if not args[2] then
                print("^1[UltimateAC] ^1Use ^2/ultimate manager [install/uninstall] [none/fx].^7")
                return
            end
            if args[2] == "install" then
                installedResourcesNum = 0
                if args[3] == "fx" then
                    local resourcenumber = GetNumResources()
                    local installedResources = {}
                    for i = 0, resourcenumber - 1 do
                        found = false
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File1 = io.open(path .. "/fxmanifest.lua", "r")
                        if File1 then
                            if not string.find(path, GetCurrentResourceName()) then
                                if string.len(path) > 4 then
                                    local File2 = io.open(path .. "/fxmanifest.lua", "r")
                                    for line in io.lines(path .. "/fxmanifest.lua") do
                                        if line == filestring then
                                            found = true
                                        end
                                    end
                                    File2:close()
                                    if not found then
                                        local File3 = io.open(path .. "/fxmanifest.lua", "a+")
                                        File3:write("\n\n" .. filestring)
                                        File3:close()
                                        table.insert(installedResources, GetResourceByFindIndex(i))
                                        installedResourcesNum = installedResourcesNum + 1
                                    end
                                end
                            end
                            File1:close()
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^1[UltimateAC] ^1Installed on ^2" .. installedResourcesNum .. " ^1resources.^7")
                    if installedResourcesNum ~= 0 then
                        print("^1[UltimateAC] ^1List of resources: ^7")
                        for i = 1, #installedResources do
                            print("^1[UltimateAC] ^1 - ^2" .. installedResources[i])
                        end
                    end
                    print("^1[UltimateAC] ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                elseif args[3] == nil then
                    local resourcenumber = GetNumResources()
                    local installedResources = {}
                    for i = 0, resourcenumber - 1 do
                        found = false
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File1 = io.open(path .. "/__resource.lua", "r")
                        if File1 then
                            if not string.find(path, GetCurrentResourceName()) then
                                if string.len(path) > 4 then
                                    local File2 = io.open(path .. "/__resource.lua", "r")
                                    for line in io.lines(path .. "/__resource.lua") do
                                        if line == filestring then
                                            found = true
                                        end
                                    end
                                    File2:close()
                                    if not found then
                                        local File3 = io.open(path .. "/__resource.lua", "a+")
                                        File3:write("\n\n" .. filestring)
                                        File3:close()
                                        table.insert(installedResources, GetResourceByFindIndex(i))
                                        installedResourcesNum = installedResourcesNum + 1
                                    end
                                end
                            end
                            File1:close()
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^1[UltimateAC] ^1Installed on ^2" .. installedResourcesNum .. " ^1resources.^7")
                    if installedResourcesNum ~= 0 then
                        print("^1[UltimateAC] ^1List of resources: ^7")
                        for i = 1, #installedResources do
                            print("^1[UltimateAC] ^1 - ^2" .. installedResources[i])
                        end
                    end
                    print("^1[UltimateAC] ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                end
            elseif args[2] == "uninstall" then
                if args[3] == "fx" then
                    local resourcenumber = GetNumResources()
                    for i = 0, resourcenumber - 1 do
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File = io.open(path .. "/fxmanifest.lua", "r")
                        if File then
                            if string.len(path) > 4 then
                                File:seek("set", 0)
                                local read = File:read("*a")
                                File:close()
                                local splited = Ultimate.Split(read, "\n")
                                local stringmodified = ""
                                for _, v in ipairs(splited) do
                                    if v == filestring then
                                        local filetomodify = io.open(path .. "/fxmanifest.lua", "w")
                                        if filetomodify then
                                            filetomodify:seek("set", 0)
                                            filetomodify:write(stringmodified)
                                            filetomodify:close()
                                        end
                                    else
                                        stringmodified = stringmodified .. v .. "\n"
                                    end
                                end
                            end
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^1[UltimateAC] ^1Uninstalled from ^2fxmanifest.lua ^1with success.^7")
                    print("^1[UltimateAC] ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                elseif args[3] == nil then
                    local resourcenumber = GetNumResources()
                    for i = 0, resourcenumber - 1 do
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File = io.open(path .. "/__resource.lua", "r")
                        if File then
                            if string.len(path) > 4 then
                                File:seek("set", 0)
                                local read = File:read("*a")
                                File:close()
                                local splited = Ultimate.Split(read, "\n")
                                local stringmodified = ""
                                for _, v in ipairs(splited) do
                                    if v == filestring then
                                        local filetomodify = io.open(path .. "/__resource.lua", "w")
                                        if filetomodify then
                                            filetomodify:seek("set", 0)
                                            filetomodify:write(stringmodified)
                                            filetomodify:close()
                                        end
                                    else
                                        stringmodified = stringmodified .. v .. "\n"
                                    end
                                end
                            end
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^1[UltimateAC] ^1Uninstalled from ^2__resource.lua ^1with success.^7")
                    print("^1[UltimateAC] ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                end
            end
        else
            TriggerClientEvent("esx:showNotification", source, "UltimateAC",
                "Este comando só pode ser executado pela consola.", 2000, "error")
        end
    end
end)
