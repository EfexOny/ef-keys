
local VehicleList = {}




RegisterNetEvent('ef-keys:server:GiveVehicleKeys', function(receiver, plate)
    local giver = source

    if HasKeys(giver, plate) then
        TriggerClientEvent('QBCore:Notify', giver, Lang:t("notify.vgkeys"), 'success')
        if type(receiver) == 'table' then
            for _,r in ipairs(receiver) do
                GiveKeys(receiver[r], plate)
            end
        else
            GiveKeys(receiver, plate)
        end
    else
        TriggerClientEvent('QBCore:Notify', giver, Lang:t("notify.ydhk"), "error")
    end
end)


QBCore.Functions.CreateCallback('ef-keys:server:getvehiclekeys', function(source, cb)
    local citizenid = QBCore.Functions.GetPlayer(source).PlayerData.citizenid
    local keysList = {}
    for plate, citizenids in pairs (VehicleList) do
        if citizenids[citizenid] then
            keysList[plate] = true
        end
    end
    cb(keysList)
end)

QBCore.Functions.CreateCallback('ef-keys:server:checkplayerowned', function(cb, plate)
    local playerOwned = false
    if VehicleList[plate] then
        playerOwned = true
    end
    cb(playerOwned)
end)

function HasKeys(id, plate)
    local citizenid = QBCore.Functions.GetPlayer(id).PlayerData.citizenid
    if VehicleList[plate] and VehicleList[plate][citizenid] then
        return true
    end
    return false
end


QBCore.Functions.CreateCallback('ef-keys:requestPlayerCars', function(source, cb, plateveh)
    local ply = QBCore.Functions.GetPlayer(source)

    MySQL.Async.fetchAll(
        'SELECT plate FROM player_vehicles WHERE citizenid = @citizenid AND plate = @plate',
        {
            ['@citizenid'] = ply.PlayerData.citizenid,
            ['@plate'] = plateveh,
        },
        function(result)
            print(#result)
            for i = 1, #result, 1 do
                print(result[i].plate, plateveh)
                if result[i].plate == plateveh then
                    print('found')
                    cb(true)
                    return
                end
            end

            print(plateveh, 'not found')
            cb(false)
        end
    )
end)