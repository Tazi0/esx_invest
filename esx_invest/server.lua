ESX = nil
Cache = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("invest:balance")
AddEventHandler("invest:balance", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local user = MySQL.Sync.fetchAll('SELECT * FROM `invest` WHERE `identifier`=@id AND active=1', {["@id"] = xPlayer.getIdentifier()})
    local invested = 0
    for k, v in pairs(user) do
        -- print(k, v.identifier, v.amount, v.job)
        invested = invested + v.amount
    end
    TriggerClientEvent("invest:nui", _source, {
        type = "balance",
        player = xPlayer.getName(),
        balance = invested
    })
end)

RegisterServerEvent("invest:jobs")
AddEventHandler("invest:jobs", function()
    TriggerClientEvent("invest:nui", source, {
        type = "jobs",
        cache = Cache
    })
end)


RegisterServerEvent("invest:all")
AddEventHandler("invest:all", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local user = MySQL.Sync.fetchAll('SELECT * FROM `invest` WHERE `identifier`=@id', {["@id"] = xPlayer.getIdentifier()})
    for k, v in pairs(user) do
        print(k, v.identifier, v.amount, v.job, v.active, v.created)
        user[k].label = Cache[v.job].label
    end
    TriggerClientEvent("invest:nui", _source, {
        type = "all",
        cache = user
    })
end)

RegisterServerEvent("invest:buy")
AddEventHandler("invest:buy", function(job, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- TODO see if already is investend, if not then insert else update
    -- TODO delete bank money from invested
    MySQL.Sync.execute("INSERT INTO `invest` (identifier, job, amount) VALUES (@id, @job, @amount)", {
        ["@id"] = xPlayer.getIdentifier(),
        ["@job"] = job,
        ["@amount"] = amount
    })
end)

RegisterServerEvent("invest:sell")
AddEventHandler("invest:sell", function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- TODO add invested money + intrest
    MySQL.Sync.execute("UPDATE `invest` SET active=0 WHERE id=@id", {
        ["@id"] = xPlayer.getIdentifier()
    })
end)

-- Gives a random number
function genRand(min, max, decimalPlaces)
    local rand = math.random()*(max-min) + min;
    local power = math.pow(10, decimalPlaces);
    return math.floor(rand*power) / power;
end

-- Loop invest rates
AddEventHandler('onResourceStart', function()
    function loopUpdate()
        Citizen.Wait(60000*Config.InvestRateTime)
        if Config.Debug then
            print("[esx_invest] Creating new investments")
        end
        local jobs = MySQL.Sync.fetchAll("SELECT name,label,investRate FROM `jobs`")
        for k, v in pairs(jobs) do
            if Config.GoodStock then
                newRate = genRand(1, 2, 2)
            else
                newRate = genRand(0, 2, 2)
            end
            -- print(newRate)
            -- print(v.name)
            MySQL.Sync.execute("UPDATE jobs SET investRate=@rate WHERE name=@name", {
                ["@rate"] = newRate,
                ["@name"] = v.name
            })
            local rate = "stale"
            if newRate > v.investRate then
                rate = "up"
            elseif newRate < v.investRate then
                rate = "down"
            end
            Cache[v.name] = {stock = newRate, rate = rate, label = v.label}
        end
        loopUpdate()
    end
    local jobs = MySQL.Sync.fetchAll("SELECT name,label,investRate FROM jobs")
    for k, v in pairs(jobs) do
        Cache[v.name] = {stock = v.investRate, rate = "stale", label = v.label}
    end
    loopUpdate()
end)

-- print(genRand(0, 2, 2)) -- from 0.00 to 2.00
-- print(genRand(1, 2, 2)) -- from 1.00 to 2.00