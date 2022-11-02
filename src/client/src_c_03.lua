AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetInvokingResource() then
        VerifyResStop(resourceName)
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetInvokingResource() then
        VerifyResStop(resourceName)
    end
end)

_G.AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetInvokingResource() then
        VerifyResStop(resourceName)
    end
end)

_G.AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetInvokingResource() then
        VerifyResStop(resourceName)
    end
end)

function VerifyResStop(resourceName)
    -- TODO BAN, START/STOP/RESTART
    return CancelEvent()
end

local DarArma = GiveWeaponToPed
GiveWeaponToPed = function(ped, weaponhash, ...)
    TriggerServerEvent('UltimateAC:AddWeapon', weaponhash)
    return DarArma(ped, weaponhash, ...)
end

local RemoveArma = RemoveWeaponFromPed
RemoveWeaponFromPed = function(ped, weaponhash, ...)
    TriggerServerEvent('UltimateAC:RemoveWeapon', weaponhash)
    return RemoveArma(ped, weaponhash, ...)
end

local RemoveAllArma = RemoveAllPedWeapons
RemoveAllPedWeapons = function(ped, ...)
    TriggerServerEvent('UltimateAC:ClearWeapons')
    return RemoveAllArma(ped, ...)
end
