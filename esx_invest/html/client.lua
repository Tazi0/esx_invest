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
