local KeysList = {}


Citizen.CreateThread(function()
    -- PlayerData management
    local PlayerData = QBCore.Functions.GetPlayerData()

    AddEventHandler('onResourceStart', function(resourceName)
        if resourceName == GetCurrentResourceName() and QBCore.Functions.GetPlayerData() ~= {} then
            GetKeys()
        end
    end)
    

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        GetKeys()
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


RegisterNetEvent('ef-keys:client:closestveh')
AddEventHandler('ef-keys:client:closestveh', function()
    
    coords = GetEntityCoords(PlayerPedId())

    targetVehicle, distance = QBCore.Functions.GetClosestVehicle(coords)

    plateveh = GetVehicleNumberPlateText(targetVehicle)
end)



RegisterNetEvent('ef-keys:client:givekeys', function(id)
    local coords = GetEntityCoords(PlayerPedId())
    local targetVehicle, distance = QBCore.Functions.GetClosestVehicle(coords)
    local plateveh = GetVehicleNumberPlateText(targetVehicle)
    QBCore.Functions.TriggerCallback("ef-keys:requestPlayerCars", function(result)
        if targetVehicle and result then
            local targetPlate = QBCore.Functions.GetPlate(targetVehicle)
            if IsPedSittingInVehicle(PlayerPedId(), targetVehicle) then -- Give keys to everyone in vehicle
                local otherOccupants = GetOtherPlayersInVehicle(targetVehicle)
                for p = 1, #otherOccupants do
                    TriggerServerEvent('ef-keys:server:GiveVehicleKeys',
                        GetPlayerServerId(NetworkGetPlayerIndexFromPed(otherOccupants[p])), targetPlate)
                end
            else
                GiveKeys(GetPlayerServerId(QBCore.Functions.GetClosestPlayer()), targetPlate)
            end
        else
            QBCore.Functions.Notify(("Not your car homie"),'error')
        end
    end, plateveh)
end)
    



function GiveKeys(id, plate)
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id))))
    if distance < 1.5 and distance > 0.0 then
        TriggerServerEvent('ef-keys:server:GiveVehicleKeys', id, plate)
    else
        QBCore.Functions.Notify(("No one near you"),'error')
    end
end

function GetKeys()
    QBCore.Functions.TriggerCallback('ef-keys:server:getvehiclekeys', function(keysList)
        KeysList = keysList
    end)
end

function HasKeys(plate)
    return KeysList[plate]
end
exports('HasKeys', HasKeys)
