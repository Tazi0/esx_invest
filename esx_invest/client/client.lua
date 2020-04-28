-- Show notification
Citizen.CreateThread(function()
    while true do
        Wait(0)
        -- user is close to blip
        if near() then
            -- Show notification
            Notify("Press ~INPUT_PICKUP~ to open")
            if IsControlJustPressed(1, 38) then
                openUI()
				local ped = GetPlayerPed(-1)
				TriggerServerEvent("invest:balance")
                -- TODO get invested balance
            end
    
            if IsControlJustPressed(1, 322) then
                closeUI()
            end
        end
    end
end)

-- Events
RegisterNetEvent("invest:nui")
AddEventHandler("invest:nui", function (data)
	SendNUIMessage(data)
end)


-- Blips
Citizen.CreateThread(function()
	if Config.ShowBlips then
	  for k,v in ipairs(Config.WallStreet)do
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

-- UI callbacks
RegisterNUICallback('close', function(data, cb) 
    closeUI()
end)

RegisterNUICallback("newBanking", function()
	closeUI()
	exports.new_banking:openUI()
end)

RegisterNUICallback("list", function()
	TriggerServerEvent("invest:list")
end)

RegisterNUICallback("all", function()
	TriggerServerEvent("invest:all", false)
end)

RegisterNUICallback("sell", function()
	TriggerServerEvent("invest:all", true)
end)

RegisterNUICallback("sellInvestment", function(data, cb)
	TriggerServerEvent("invest:sell", data.job, data.sellRate)
end)

RegisterNUICallback("buyInvestment", function(data, cb)
	TriggerServerEvent("invest:buy", data.job, data.amount, data.boughtRate)
end)

RegisterNUICallback("balance", function(data, cb)
	TriggerServerEvent("invest:balance")
end)

-- Open UI
function openUI()
	inMenu = true
	SetNuiFocus(true, true)
    SendNUIMessage({type = "open"})
end

-- Close UI
function closeUI() 
	inMenu = false
	SetNuiFocus(false, false)
    SendNUIMessage({type = "close"})
end

-- Close menu on close
AddEventHandler('onResourceStop', function (resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
    end
    if inMenu then
        closeUI()
    end
end)

-- near a blip
function near()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

	for _, search in pairs(Config.WallStreet) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

		if distance <= 4 then
			return true
		end
	end
end

function Notify(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end