RegisterNetEvent("ef-keys:server:requestplayercars",function(source,cb,plate)

    local player = QBCore.Functions.GetPlayers(source)





    MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @identifier',
		{
			['@identifier'] = player.identifier
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = json.decode(result[i].vehicle)

				if trim(vehicleProps.plate) == trim(plate) then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)

	print(player.identifier)
end)

RegisterNetEvent("ef-keys:server:setvehicleownedplayerid")
AddEventHandler("ef-keys:server:setvehicleownedplayerid",function(coords,vehicleprop) 

	local player = QBCore.Functions.GetPlayersFromCoords(coords, 3)

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
	{
		['@owner']   = player.identifier,
		['@plate']   = vehicleprop.plate
	},

	function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, 'You have got a new car with plate ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)
	end)
end)