-- Threads
ESX = nil
Spawned = false
Table = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

AddEventHandler("playerSpawned", function()
    OriginalPed = GetEntityModel(PlayerPedId())
    Spawned = true
end)

RegisterNetEvent("UltimateAC:LoadTables")
AddEventHandler("UltimateAC:LoadTables", function(table)
    Table = table
end)

-- SpeedHack
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local speed = GetEntitySpeed(PlayerPedId())
        if not IsPedInAnyVehicle(PlayerPedId(), 0) then
            if speed > 100 then
                -- TODO BAN, SPEED HACK
            end
        end
    end
end)

-- Blacklist Weapon
Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    while true do
        Citizen.Wait(1000)
        for _, weapon in pairs(Table["Weapons"]) do
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
                -- TODO BAN, BLACKLIST WEAPON
            end
        end
    end
end)

-- PlayerBlips
local trackCounter = 0
Citizen.CreateThread(function()
    local targetPed
    local ped
    local allPlayers
    while true do
        Citizen.Wait(1000)
        allPlayers = GetActivePlayers()
        ped = PlayerPedId()
        for i = 1, #allPlayers do
            targetPed = GetPlayerPed(allPlayers[i])
            if targetPed ~= ped then
                if DoesBlipExist(targetPed) then
                    trackCounter = trackCounter + 1
                end
            end
        end
        if trackCounter >= 10 then
            -- TODO BAN, PLAYER TRACK
        end
    end
end)

-- Weapon Spawning
CreateThread(function()
    while true do
        local _ped = PlayerPedId()
        local weaponsHasGot = {}
        for _, v in ipairs(ListWeapons) do
            local weaponHash = GetHashKey(v)
            if HasPedGotWeapon(_ped, weaponHash, false) == 1 then
                table.insert(weaponsHasGot, weaponHash)
            end
        end
        TriggerServerEvent('UltimateAC:VerifyWeapon', weaponsHasGot)
        Wait(10000)
    end
end)

-- Blocked CMDS
Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    while true do
        Citizen.Wait(1000)
        for _, cmds in ipairs(GetRegisteredCommands()) do
            for _, blockedcmds in ipairs(Table["Commands"]) do
                if cmds.name == blockedcmds then
                    -- TODO BAN, BLACKLIST COMMAND
                end
            end
        end
    end
end)

-- Spectate
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if NetworkIsInSpectatorMode() then
            -- TODO BAN, SPECTATE
        end
    end
end)

-- Anti Infinite Ammo
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        SetPedInfiniteAmmoClip(PlayerPedId(), false)
    end
end)

-- Godmode
Citizen.CreateThread(function()
    local pedHealth
    while true do
        Citizen.Wait(5000)
        pedHealth = GetEntityHealth(PlayerPedId())
        if GetPlayerInvincible(PlayerId()) and Spawned then
            -- TODO BAN, GODMODE
        end
        SetEntityHealth(PlayerPedId(), pedHealth - 2)
        Wait(250)
        if not IsPlayerDead(PlayerPedId()) then
            if GetEntityHealth(PlayerPedId()) == pedHealth and GetEntityHealth(PlayerPedId()) ~= 0 then
                -- TODO BAN, GODMODE
            elseif GetEntityHealth(PlayerPedId()) == pedHealth - 2 then
                SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)
            end
        end
    end
end)

-- Plate Changer
Citizen.CreateThread(function()
    local ped
    local vehicle
    local plate
    local vehicleHash
    local rvehicle
    local rplate
    local rvehicleHash
    while true do
        ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            vehicle = GetVehiclePedIsIn(ped, false)
            plate = GetVehicleNumberPlateText(vehicle)
            vehicleHash = GetHashKey(vehicle)
        end
        if vehicle ~= nil then
            if plate ~= nil then
                if IsPedInAnyVehicle(ped, false) then
                    rvehicle = GetVehiclePedIsIn(ped, false)
                    rplate = GetVehicleNumberPlateText(rvehicle)
                    rvehicleHash = GetHashKey(rvehicle)
                    if rplate ~= plate and rvehicleHash == vehicleHash then
                        -- TODO BAN, PLATE CHANGER
                    else
                        Wait(0)
                    end
                else
                    Wait(0)
                end
            else
                Wait(0)
            end
        else
            Wait(0)
        end
    end
end)

-- Infinite Stamina
Citizen.CreateThread(function()
    local ped
    local staminalevel
    while true do
        Citizen.Wait(1000)
        ped = PlayerPedId()
        if GetEntitySpeed(ped) > 7 and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and
            not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and not IsPedRagdoll(ped) then
            staminalevel = GetPlayerSprintStaminaRemaining(PlayerId())
            if tonumber(staminalevel) == tonumber(0.0) then
                -- TODO BAN, INFINITE STAMINA
            end
        end
    end
end)

-- Anti Ragdoll
Citizen.CreateThread(function()
    local ped
    while true do
        Citizen.Wait(1000)
        ped = PlayerPedId()
        if not CanPedRagdoll(ped) and not IsPedInAnyVehicle(ped, true) and
            not IsEntityDead(ped) and not IsPedJumpingOutOfVehicle(ped) and
            not IsPedJacking(ped) and IsPedRagdoll(ped) then
            -- TODO BAN, ANTI RAGDOLL
        end
    end
end)

-- Blacklist Plate
Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    local ped
    local plate
    while true do
        Citizen.Wait(1000)
        ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            for _, blockedPlate in ipairs(Table["Plates"]) do
                plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(ped, false), false)
                if plate == blockedPlate then
                    -- TODO BAN, BLACKLIST PLATE
                end
            end
        end
    end
end)

-- Thermal Vision
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    if GetUsingseethrough() then
        -- TODO BAN, THERMAL VISION
    end
end)

-- Night Vision
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if GetUsingnightvision() then
            -- TODO BAN, NIGHT VISION
        end
    end
end)

-- Invisible
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local entityalpha = GetEntityAlpha(PlayerPedId())
        if not IsEntityVisible(PlayerPedId()) or not IsEntityVisibleToScript(PlayerPedId()) or
            entityalpha <= 150 and Spawned and not IsPlayerSwitchInProgress() then
            -- TODO BAN, INVISIBLE
        end
    end
end)

-- SuperJump
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsPedJumping(PlayerPedId()) then
            local firstCoord = GetEntityCoords(PlayerPedId())
            while IsPedJumping(PlayerPedId()) do
                Citizen.Wait(500)
            end
            local secondCoord = GetEntityCoords(PlayerPedId())
            local jumpLength = Vdist(firstCoord, secondCoord)
            if jumpLength > 30.0 then
                -- TODO BAN, SUPER JUMP
            end
        end
    end
end)

-- CheatEngine
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local PedVehicle = GetVehiclePedIsUsing(PlayerPedId())
        local PedVehicleModel = GetEntityModel(PedVehicle)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            if PedVehicle == TempVehicle and PedVehicleModel ~= TempVehicleModel and TempVehicleModel ~= nil and
                TempVehicleModel ~= 0 then
                SetEntityAsMissionEntity(PedVehicle, true, true)
                DeleteVehicle(PedVehicle)
                -- TODO BAN, CHEAT ENGINE
            end
        end
        TempVehicle = PedVehicle
        TempVehicleModel = PedVehicleModel
    end
end)

-- FreeCam
Citizen.CreateThread(function()
    local x, y, z
    while true do
        Citizen.Wait(500)
        if Spawned then
            x, y, z = table.unpack(GetEntityCoords(PlayerPedId()) - GetFinalRenderedCamCoord())
            if (x > 50) or (y > 50) or (z > 50) or (x < -50) or (y < -50) or (z < -50) then
                -- TODO BAN, FREECAM
            end
        end
    end
end)

-- Menyoo
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if Spawned then
            if IsPlayerCamControlDisabled() ~= false then
                -- TODO BAN, MENYOO
            end
        end
    end
end)

-- Armor
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local armor = GetPedArmour(PlayerPedId())
        if armor > 100 then
            -- TODO BAN, ARMOR HACK
        end
    end
end)

-- Weapon Damage Changer
Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    local weapon
    local damage
    while true do
        Citizen.Wait(1000)
        weapon = GetSelectedPedWeapon(PlayerPedId())
        damage = math.floor(GetWeaponDamage(weapon))
        local weapon = Table["Weapons"][weapon]
        if weapon and damage > weapon.damage then
            -- TODO BAN, WEAPON DAMAGE CHANGER
        end
    end
end)

-- AimAssist
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        SetPlayerTargetingMode(0)
    end
end)

-- Anti Aimbot
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsAimCamActive() then
            local isAiming, Entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if isAiming and Entity then
                if IsEntityAPed(Entity) and not IsEntityDead(Entity) and not IsPedStill(Entity) and
                    not IsPedStopped(Entity) and not IsPedInAnyVehicle(Entity, false) then
                    local EntityCoords = GetEntityCoords(Entity)
                    local retval, screenx, screeny = GetScreenCoordFromWorldCoord(EntityCoords.x, EntityCoords.y,
                        EntityCoords.z)
                    if screenx == lastcoordsx or screeny == lastcoordsy then
                        -- TODO BAN, AIMBOT
                    end
                    lastcoordsx = screenx
                    lastcoordsy = screeny
                end
            end
        end
    end
end)

-- Anti Explosive Ammo
Citizen.CreateThread(function()
    local weapon
    local damage
    while true do
        Citizen.Wait(1000)
        weapon = GetSelectedPedWeapon(PlayerPedId())
        damage = GetWeaponDamageType(weapon)
        SetWeaponDamageModifier(GetHashKey("WEAPON_EXPLOSION"), 0.0)
        if damage == 4 or damage == 5 or damage == 6 or damage == 13 then
            -- TODO BAN, EXPLOSIVE AMMO
        end
    end
end)

-- Anti Blacklist Tasks
Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    while true do
        Citizen.Wait(1000)
        for _, task in pairs(Table["Tasks"]) do
            if GetIsTaskActive(PlayerPedId(), task) then
                -- TODO BAN, BLACKLIST TASK
            end
        end
    end
end)

-- Anti Blacklist Animations
Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    while true do
        Citizen.Wait(1000)
        for _, anim in pairs(Table["Anims"]) do
            if IsEntityPlayingAnim(PlayerPedId(), anim[1], anim[2], 3) then
                -- TODO BAN, BLACKLIST ANIMATION
                ClearPedTasksImmediately(PlayerPedId())
                ClearPedTasks(PlayerPedId())
                ClearPedSecondaryTask(PlayerPedId())
            end
        end
    end
end)

-- Anti Tiny Ped
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local Tiny = GetPedConfigFlag(PlayerPedId(), 223, true)
        if Tiny then
            -- TODO BAN, TINY PED
        end
        Wait(100)
    end
end)

-- Ped Changed
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if Spawned then
            if OriginalPed ~= GetEntityModel(PlayerPedId()) then
                -- TODO BAN, PED CHANGER
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playercoords = GetEntityCoords(PlayerPedId())
        if (playercoords.x > 0 or playercoords.x < 0) then
            Citizen.Wait(500)
            local newplayercoords = GetEntityCoords(PlayerPedId())
            if GetEntityHeightAboveGround(playerPed) > 25 and not IsPedInAnyVehicle(playerPed, false) and
                not IsPedInParachuteFreeFall(playerPed) and not IsPedFalling(playerPed) and
                not IsPedJumpingOutOfVehicle(playerPed) and not IsEntityVisible(playerPed) and
                not IsPlayerDead(playerPed) and GetPedParachuteState(playerPed) == -1 then
                if (not IsPedInAnyVehicle(playerPed, 0) and not IsPedOnVehicle(playerPed) and
                    not IsPlayerRidingTrain(PlayerId())) then
                    if (GetDistanceBetweenCoords(playercoords.x, playercoords.y, playercoords.z, newplayercoords.x,
                        newplayercoords.y, newplayercoords.z, 0) > Config.MaxDistance) then
                        -- TODO BAN, TELEPORT/NOCLIP
                    end
                end
                playercoords = newplayercoords
            else
                playercoords = newplayercoords
            end
        end
        Citizen.Wait(2000)
    end
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #ListWeaponsHashes do
            local dmg_mod = GetWeaponComponentDamageModifier(ListWeaponsHashes[i])
            local accuracy_mod = GetWeaponComponentAccuracyModifier(ListWeaponsHashes[i])
            if dmg_mod > 1.1 or accuracy_mod > 1.2 then
                -- TODO BAN, AI FOLDER
            end
        end
        Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while not Table do
        Citizen.Wait(1000)
    end
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleModel = GetEntityModel(vehicle)
        local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
        for _, v in pairs(Table["Vehicles"]) do
            if vehicleModel == GetHashKey(v) then
                -- TODO BAN, BLACKLIST VEHICLES
            end
        end
        Citizen.Wait(5000)
    end
end)

-- AntiMenus
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        local DetectableTextures = {
            { txd = "HydroMenu", txt = "HydroMenuHeader", name = "HydroMenu" },
            { txd = "John", txt = "John2", name = "SugarMenu" },
            { txd = "darkside", txt = "logo", name = "Darkside" },
            { txd = "ISMMENU", txt = "ISMMENUHeader", name = "ISMMENU" },
            { txd = "dopatest", txt = "duiTex", name = "Copypaste Menu" },
            { txd = "fm", txt = "menu_bg", name = "Fallout Menu" },
            { txd = "wave", txt = "logo", name = "Wave" },
            { txd = "wave1", txt = "logo1", name = "Wave (alt.)" },
            { txd = "meow2", txt = "woof2", name = "Alokas66", x = 1000, y = 1000 },
            { txd = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86", txt = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6",
                name = "Guest Menu" },
            { txd = "hugev_gif_DSGUHSDGISDG", txt = "duiTex_DSIOGJSDG", name = "HugeV Menu" },
            { txd = "MM", txt = "menu_bg", name = "Metrix Mehtods" },
            { txd = "wm", txt = "wm2", name = "WM Menu" },
            { txd = "NeekerMan", txt = "NeekerMan1", name = "Lumia Menu" },
            { txd = "Blood-X", txt = "Blood-X", name = "Blood-X Menu" },
            { txd = "Dopamine", txt = "Dopameme", name = "Dopamine Menu" },
            { txd = "Fallout", txt = "FalloutMenu", name = "Fallout Menu" },
            { txd = "Luxmenu", txt = "Lux meme", name = "LuxMenu" },
            { txd = "Reaper", txt = "reaper", name = "Reaper Menu" },
            { txd = "absoluteeulen", txt = "Absolut", name = "Absolut Menu" },
            { txd = "KekHack", txt = "kekhack", name = "KekHack Menu" },
            { txd = "Maestro", txt = "maestro", name = "Maestro Menu" },
            { txd = "SkidMenu", txt = "skidmenu", name = "Skid Menu" },
            { txd = "Brutan", txt = "brutan", name = "Brutan Menu" },
            { txd = "FiveSense", txt = "fivesense", name = "Fivesense Menu" },
            { txd = "NeekerMan", txt = "NeekerMan1", name = "Lumia Menu" },
            { txd = "Auttaja", txt = "auttaja", name = "Auttaja Menu" },
            { txd = "BartowMenu", txt = "bartowmenu", name = "Bartow Menu" },
            { txd = "Hoax", txt = "hoaxmenu", name = "Hoax Menu" },
            { txd = "FendinX", txt = "fendin", name = "Fendinx Menu" },
            { txd = "Hammenu", txt = "Ham", name = "Ham Menu" },
            { txd = "Lynxmenu", txt = "Lynx", name = "Lynx Menu" },
            { txd = "Oblivious", txt = "oblivious", name = "Oblivious Menu" },
            { txd = "malossimenuv", txt = "malossimenu", name = "Malossi Menu" },
            { txd = "memeeee", txt = "Memeeee", name = "Memeeee Menu" },
            { txd = "tiago", txt = "Tiago", name = "Tiago Menu" },
            { txd = "Hydramenu", txt = "hydramenu", name = "Hydra Menu" },
            { txd = "dopamine", txt = "Swagamine", name = "Dopamine" },
            { txd = "HydroMenu", txt = "HydroMenuHeader", name = "Hydro Menu" },
            { txd = "HydroMenu", txt = "HydroMenuLogo", name = "Hydro Menu" },
            { txd = "HydroMenu", txt = "https://i.ibb.co/0GhPPL7/Hydro-New-Header.png", name = "Hydro Menu" },
            { txd = "test", txt = "Terror Menu", name = "Terror Menu" },
            { txd = "lynxmenu", txt = "lynxmenu", name = "Lynx Menu" },
            { txd = "Maestro 2.3", txt = "Maestro 2.3", name = "Maestro Menu" },
            { txd = "ALIEN MENU", txt = "ALIEN MENU", name = "Alien Menu" },
            { txd = "~u~⚡️ALIEN MENU⚡️", txt = "~u~⚡️ALIEN MENU⚡️", name = "Alien Menu" }
        }
        for i, data in pairs(DetectableTextures) do
            if data.x and data.y then
                if GetTextureResolution(data.txd, data.txt).x == data.x and
                    GetTextureResolution(data.txd, data.txt).y == data.y then
                    -- TODO BAN, MENU DETECTED
                end
            else
                if GetTextureResolution(data.txd, data.txt).x ~= 4.0 then
                    -- TODO BAN, MENU DETECTED
                end
            end
        end
    end
end)

AddEventHandler("gameEventTriggered", function(name, args)
    local entityOwner = GetPlayerServerId(NetworkGetEntityOwner(args[2]))
    while IsPlayerSwitchInProgress() do
        Citizen.Wait(5000)
    end
    if entityOwner == GetPlayerServerId(PlayerId()) or args[2] == -1 then
        if IsEntityAPed(args[1]) then
            if not IsEntityOnScreen(args[1]) then
                local entityCoords = GetEntityCoords(args[1])
                local distance = #(_entitycoords - GetEntityCoords(PlayerPedId()))
                -- TODO BAN, MAGIC BULLET
            end
        end
    end
    if name == "CEventNetworkEntityDamage" then
        if args[1] == PlayerPedId() and args[2] == -1 and args[3] == 0 and args[4] == 0 and args[5] == 0 and args[6] == 1
            and args[7] == GetHashKey('WEAPON_FALL') and args[8] == 0 and args[9] == 0 and args[10] == 0 and
            args[11] == 0 and args[12] == 0 and args[13] == 0 then
            -- TODO BAN, SUICIDE
        end
    end
    if name == 'CEventNetworkPlayerCollectedPickup' then
        -- TODO BAN, ANTI COLLECTED PICKUP
    end
end)
