local wall_street = {
  {name="Stock Exchange", id=374, x=150.266, y=-1040.203, z=29.374},
}

-- Basic ESX function
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Map Blips

Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(wall_street)do
  		local blip = AddBlipForCoord(v.x, v.y, v.z)
  		SetBlipSprite(blip, v.id)
  		SetBlipDisplay(blip, 4)
  		SetBlipScale  (blip, 0.9)
  		SetBlipColour (blip, 2)
  		SetBlipAsShortRange(blip, true)
  		BeginTextCommandSetBlipName("STRING")
  		AddTextComponentString(tostring(v.name))
  		EndTextCommandSetBlipName(blip)
	  end
	end
end)

-- Sends there current balance
RegisterNetEvent('currentbalance')
AddEventHandler('currentbalance', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)

	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)

-- TODO get joblist and sends it

RegisterNetEvent('job')
AddEventHandler('jobs', function(job)

	MySQL.Async.fetchAll('SELECT * FROM jobs' function(result)
    Counts = 0
		for k, v in pairs(data) do
      if(v.name == 'unemployed' or Config.Removestanderdjob == true) {
        jobs['unemployed'] = nil
      }
			Counts = k
			jobs[] = {name = v.name, label = v.label, whitelisted = v.whitelist}
		end
	end)

	SendNUIMessage({
		type = "joblist",
		result = jobs,
    total = Counts
		})
end)

-- Invest(deposit) callback

RegisterNUICallback('deposit_event', function(data)
	TriggerServerEvent('investing:deposit', tonumber(data.amount_deposit))
	TriggerServerEvent('investing:balance')
end)

-- Withdraw event

RegisterNUICallback('withdraw_event', function(data)
	TriggerServerEvent('investing:withdraw', tonumber(data.amount_withdraw))
	TriggerServerEvent('investing:balance')
end)

-- Balance callback/event

RegisterNUICallback('balance', function()
	TriggerServerEvent('investing:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

-- Result Event

RegisterNetEvent('investing:result')
AddEventHandler('investing:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)
