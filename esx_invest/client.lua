-- Basic ESX function
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
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

-- Invest(deposit) callback

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('investing:deposit', tonumber(data.amount))
	TriggerServerEvent('investing:balance')
end)

-- Withdraw event

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('investing:withdraw', tonumber(data.amountw))
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

RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)
