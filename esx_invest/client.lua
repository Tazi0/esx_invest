-- Variables
ESX                 = nil
inMenu              = true

local wall_street = {
  {name="Stock Exchange", id=374, x=160.266, y=-1040.203, z=29.374}
}

-- Basic ESX function

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

print(ESX)

-- Opens menu
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if nearBLIP() then
				DisplayHelpText("Press ~INPUT_PICKUP~ to access account ~b~")

			if IsControlJustPressed(1, Config.Open) then
				inMenu = true
				SetNuiFocus(true, true)
				SendNUIMessage({type = 'openGeneral'})
				TriggerServerEvent('investing:balance')
				local ped = GetPlayerPed(-1)
			end
		end

		if IsControlJustPressed(1, Config.Close) then
			inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
end)

-- Map Blips
Citizen.CreateThread(function()
	if Config.ShowBlips then
	  for k,v in ipairs(wall_street)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite (blip, v.id)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Stock Exchange")
		EndTextCommandSetBlipName(blip)
	  end
	end
end)


-- Currentbalance
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

-- Job list
-- Send all jobs besides removed standerd
-- TODO remove unemployed

RegisterNetEvent('jobs')
AddEventHandler('jobs', function(job)

	local data = MySQL.Async.fetchAll('SELECT * FROM jobs')
	local jobs = {}
    local Counts = 0
	for k, v in pairs(data) do
		if v.name == 'unemployed' and Config.Removestanderdjob == true then
			jobs['unemployed'] = nil
		end
		Counts = Counts+1
		table.insert(jobs, {name = v.name, label = v.label, whitelisted = v.whitelist})
	end

	SendNUIMessage({
		type = "joblist",
		result = jobs,
		total = Counts
	})
end)

-- Invest(deposit) callback
-- Removes money from bank account

RegisterNUICallback('deposit_event', function(data)
	TriggerServerEvent('investing:deposit', tonumber(data.amount_deposit))
	TriggerServerEvent('investing:balance')
end)

-- Withdraw event
-- Adds money from bank account

RegisterNUICallback('withdraw_event', function(data)
	TriggerServerEvent('investing:withdraw', tonumber(data.amount_withdraw))
	TriggerServerEvent('investing:balance')
end)

-- Balance callback/event
-- Gives balance

RegisterNUICallback('balance', function()
	TriggerServerEvent('investing:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

-- NUIFocusOff
-- Closes everything

RegisterNUICallback('NUIFocusOff', function()
	closeUI()
end)

AddEventHandler('onResourceStop', function (resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	closeUI()
end)

AddEventHandler('onResourceStart', function (resourceName)
	if(GetCurrentResourceName() ~= resourceName) then
		return
	end
	closeUI()
end)

-- Register command

RegisterCommand("invest", function(source, args, raw)
  inMenu = true
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openGeneral'})
  TriggerServerEvent('investing:balance')
end)

-- Result Event

RegisterNetEvent('investing:result')
AddEventHandler('investing:result', function(type, message)
	SendNUIMessage({
    type = 'result',
    m = message,
    t = type
  })
end)

-- More

function nearBLIP()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

	for _, search in pairs(wall_street) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 3 then
			return true
		end
	end
end

function closeUI()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end

function openUI()
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
