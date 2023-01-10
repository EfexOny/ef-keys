Citizen.CreateThread(function()
    -- PlayerData management
    local PlayerData = QBCore.Functions.GetPlayerData()

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerUnload")
    AddEventHandler("QBCore:Client:OnPlayerUnload", function()
        PlayerData = nil
    end)

    RegisterNetEvent("QBCore:Client:OnJobUpdate")
    AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
        if PlayerData then
            PlayerData.job = job
        else
            PlayerData = QBCore.Functions.GetPlayerData()
        end
    end)

    RegisterNetEvent("QBCore:Client:SetDuty")
    RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
        if PlayerData.job then
            PlayerData.job.onduty = duty
        else
            PlayerData = QBCore.Functions.GetPlayerData()
        end
    end)
end)

RegisterNetEvent('ef-keys:client:notify')
AddEventHandler('ef-keys:client:notify', function(msg, type)
    QBCore.Functions.Notify(msg,type)
end)


RegisterNetEvent("ef-keys:client:givekeys")
AddEventHandler("ef-keys:client:givekeys",function()
    local playerPed = GetPlayerPed(-1)

    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed , false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = GetClosestVehicle(coords.x , coords.y , coords.z , 7.0 ,0 , 70)
    end

    local plate =  GetVehicleNumberPlateText(vehicle)
    local vehicleprop = QBCore.Functions.GetVehicleProperties(vehicle)


    closestpl = QBCore.Functions.GetClosestPlayer(coords)

    -- debugging shit wtf
    print(plate)
    print(vehicleprop)
    print(coords)
    print(playerPed)
    print(closestpl)



    TriggerServerEvent("ef-keys:server:requestplayercars",function(isOwnedVehicle)
    if not isOwnedVehicle then
        TriggerEvent("ef-keys:client:notify","nu e masina ta golane","error")
    elseif isOwnedVehicle then
        local closestPlayer, distance = QBCore.Functions.GetClosestPlayer(coords)

    if closestPlayer == -1 or distance > 3.0 then
        TriggerEvent("ef-keys:client:notify","Nu este nimeni in jurul tau","error")
    else
        TriggerEvent("ef-keys:client:notify","Ti-ai dat cheia de la masina cu numarul de inmatriculare ~g~"..vehicleprop.plate.."","succes")
        TriggerEvent()
    end
        end
    end, GetVehicleNumberPlateText(vehicle))

end)

