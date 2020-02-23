-- Made by Tazio

-- Investments can only be made with bank money!


ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('investing:deposit')
AddEventHandler('investing:deposit', function(amount)
  local _source = source
  local base = 0
  local player = ESX.GetPlayerFromId(_source)
  local identifier = GetPlayerIdentifiers(_source)[1]
  local remainder = 0

  local result = MySQL.Async.fetchAll('SELECT amount FROM invest WHERE identifier = @identifier', {
			['@identifier'] = identifier
	})

  amount = tonumber(amount)
  base = player.getBank()

	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
		player.removeBank(amount)
    --adds amount into MYSQL
    if result[1].amount == 0 then
      -- if you haven't invested into this job
      MySQL.Async.execute("INSERT INTO invest (identifier, amount,job) VALUES ('@identifier','@amount','@job')", {
        ['@identifier'] = identifier,
        ['@amount'] = amount,
        ['@job'] = "todo"
      })
    else
        -- if you have more then 0 dollar invested into that job
        remainder = result[1].amount+amount
        MySQL.Async.execute("INSERT INTO invest (identifier, amount) VALUES (@identifier,@amount) WHERE job = @job", {
          ['@identifier'] = identifier,
          ['@amount'] = remainder,
          ['@job'] = "todo"
        })
    end
	end
end)

RegisterServerEvent('investing:withdraw')
AddEventHandler('investing:withdraw', function(amount)
  local _source = source
	local player = ESX.GetPlayerFromId(_source)
  local identifier = GetPlayerIdentifiers(_source)[1]
	local base = 0
  local remainder = 0

  MySQL.Async.fetchAll('SELECT amount FROM invest WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
	end)

  remainder = result[1].amount-amount
	amount = tonumber(amount)
	base = player.getBank()

	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
    if Config.Goodstock then
      realamount = amount*genRand(1, 2, 2);
    else
      -- genRand = #.## This could be a 0.50 or a 1.53
		  realamount = amount*genRand(0, 2, 2);
    end
		player.addBank(realamount)
    --removes amount from the SQL
    MySQL.Async.execute("UPDATE invest SET amount = @amount WHERE identifier = @identifier AND job = @job", {
      ['@identifier'] = identifier,
      ['@amount'] = remainder,
      ['@job'] = "todo"
    })
	end
end)

-- TODO add interest rates

RegisterServerEvent('investing:balance')
AddEventHandler('investing:balance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance', source, balance)

end)

-- Gives a random number
function genRand(min, max, decimalPlaces)
    math.randomseed(os.time())
    local rand = math.random()*(max-min) + min;
    local power = math.pow(10, decimalPlaces);
    return math.floor(rand*power) / power;
end
