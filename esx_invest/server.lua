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

  MySQL.Async.fetchAll('SELECT amount FROM invest WHERE identifier = @identifier',
  {
			['@identifier'] = identifier
	}, function(result)
	end)

  amount = tonumber(amount)
  base = player.getBank()

	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('chatMessage', _source, "Invalid Amount")
	else
		player.removeBank(amount)
    --adds amount into MYSQL
    if(result[1].amount = 0){
      -- if you haven't invested into this job
      MySQL.Async.execute("INSERT INTO invest (identifier, amount,job) VALUES (@identifier,@amount,@job)",
      {
        ['@identifier'] = identifier,
        ['@amount'] = amount,
        ['@job'] = --TODO get selected JOB where to invested in
      })
    } else {
        -- if you have more then 0 dollar invested into that job
        remainder = result[1].amount+amount
        MySQL.Async.execute("INSERT INTO invest (identifier, amount) VALUES (@identifier,@amount) WHERE job = @job",
        {
          ['@identifier'] = identifier,
          ['@amount'] = remainder,
          ['@job'] = --TODO get selected JOB where to invested in
        })
    }
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
    -- genRand = #.## This could be a 0.50 or a 1.53
		amount = amount*genRand(0, 1, 2);
		player.addBank(amount)
    --removes amount from the SQL
    MySQL.Async.execute("UPDATE invest SET amount = @amount WHERE identifier = @identifier AND job = @job",
    {
      ['@identifier'] = identifier,
      ['@amount'] = remainder
      ['@job'] = --TODO get selected JOB where to invested in
    })
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


-- version checker
local CurrentVersion = '0.1'
local GithubResourceName = 'esx_invest'
local githubacct = "Tazi0"
local resourceName = GetCurrentResourceName()
local versionurl = "https://raw.githubusercontent.com/"..githubacct.."/"..GithubResourceName.."/master/VERSION"
local changesurl = "https://raw.githubusercontent.com/"..githubacct.."/"..GithubResourceName.."/master/CHANGES"

PerformHttpRequest(versionurl, function(Error, NewestVersion, Header)
	PerformHttpRequest(changesurl, function(Error, Changes, Header)
		print('\n')
		print('====================================================================')
		print('')
		print('ESX Invest ('..resourceName..')')
		print('')
		print('Current Version: ' .. CurrentVersion)
		print('Newest Version: ' .. NewestVersion)
		print('you can download the newest version at: \n https://github.com/'..githubacct.."/"..GithubResourceName.."/")
		io.write("")
		print('Changelog: \n' .. Changes)
		print('')
		if CurrentVersion ~= NewestVersion then
			print('====================================================================')
		else
			print('===================')
			print('=== Up to date! ===')
			print('===================')
		end
		print('\n')
end)
end)
