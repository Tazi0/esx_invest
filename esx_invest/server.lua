-- Made by Tazio

-- Investments can only be made with bank money!


ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('investing:deposit')
AddEventHandler('investing:deposit', function(amount)
  local _source = source
  local base = 0
  local player = ESX.GetPlayerFromId(_source)

  amount = tonumber(amount)
  base = player.getBank()

	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
		player.removeBank(amount)
		--TODO Add money to that job/business
	end
end)

RegisterServerEvent('investing:withdraw')
AddEventHandler('investing:withdraw', function(amount)
  local _source = source
	local player = ESX.GetPlayerFromId(_source)
	local base = 0


	amount = tonumber(amount)
	base = player.getBank()

	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
    -- genRand = #.## This could be a 0.50 or a 1.53
		amount = amount*genRand(0, 1, 2);
		player.addBank(amount)
	end
end)

RegisterServerEvent('investing:balance')
AddEventHandler('investing:balance', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getBank()
	TriggerClientEvent('currentbalance', _source, balance)

end)

-- Gives a random number
function genRand(min, max, decimalPlaces) {
    var rand = Math.random()*(max-min) + min;
    var power = Math.pow(10, decimalPlaces);
    return Math.floor(rand*power) / power;
}
