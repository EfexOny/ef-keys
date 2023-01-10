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


RegisterNetEvent('qb-vehiclekeys:client:GiveKeys', function(id)
    local targetVehicle = GetVehicle()

    if targetVehicle then
        local targetPlate = QBCore.Functions.GetPlate(targetVehicle)
        if HasKeys(targetPlate) then
            if id and type(id) == "number" then -- Give keys to specific ID
                GiveKeys(id, targetPlate)
            else
                if IsPedSittingInVehicle(PlayerPedId(), targetVehicle) then -- Give keys to everyone in vehicle
                    local otherOccupants = GetOtherPlayersInVehicle(targetVehicle)
                    for p=1,#otherOccupants do
                        TriggerServerEvent('qb-vehiclekeys:server:GiveVehicleKeys', GetPlayerServerId(NetworkGetPlayerIndexFromPed(otherOccupants[p])), targetPlate)
                    end
                else -- Give keys to closest player
                    GiveKeys(GetPlayerServerId(QBCore.Functions.GetClosestPlayer()), targetPlate)
                end
            end
        else
            QBCore.Functions.Notify(Lang:t("notify.ydhk"), 'error')
        end
    end
end)


function GiveKeys(id, plate)
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id))))
    if distance < 1.5 and distance > 0.0 then
        TriggerServerEvent('qb-vehiclekeys:server:GiveVehicleKeys', id, plate)
    else
        QBCore.Functions.Notify(("No one near you"),'error')
    end
end

function GetKeys()
    QBCore.Functions.TriggerCallback('qb-vehiclekeys:server:GetVehicleKeys', function(keysList)
        KeysList = keysList
    end)
end

function HasKeys(plate)
    return KeysList[plate]
end
exports('HasKeys', HasKeys)