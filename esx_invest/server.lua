ESX = nil
Cache = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Get balance of invested jobs
RegisterServerEvent("invest:balance")
AddEventHandler("invest:balance", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local user = MySQL.Sync.fetchAll('SELECT `amount` FROM `invest` WHERE `identifier`=@id AND active=1', {["@id"] = xPlayer.getIdentifier()})
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

-- Get available jobs
RegisterServerEvent("invest:jobs")
AddEventHandler("invest:jobs", function()
    TriggerClientEvent("invest:nui", source, {
        type = "jobs",
        cache = Cache
    })
end)

-- Get all invested jobs
RegisterServerEvent("invest:all")
AddEventHandler("invest:all", function(special)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sql = 'SELECT * FROM `invest` '

    if(special) then
        sql = sql .. "INNER JOIN `jobs` ON `invest`.`job` = `jobs`.`name` "
    end

    sql = sql .. "WHERE `invest`.`identifier`= @id"

    if(special) then 
        sql = sql .. " AND `invest`.`active`=1"
    end

    local user = MySQL.Sync.fetchAll(sql, {["@id"] = xPlayer.getIdentifier()})

    for k, v in pairs(user) do
        -- print(k, v.identifier, v.amount, v.job, v.active, v.created, v.investRate)
        user[k].label = Cache[v.job].label
    end

    if(special) then
        TriggerClientEvent("invest:nui", _source, {
            type = "sell",
            cache = user
        })
    else 
        TriggerClientEvent("invest:nui", _source, {
            type = "all",
            cache = user
        })
    end
end)

-- Invest into a job
RegisterServerEvent("invest:buy")
AddEventHandler("invest:buy", function(job, amount, rate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local id = xPlayer.getIdentifier()

    local inf = MySQL.Sync.fetchAll('SELECT * FROM `invest` WHERE `identifier`=@id AND active=1 AND job=@job LIMIT 1', {["@id"] = id, ['@job'] = job})
    for k, v in pairs(inf) do inf = v end
    
    xPlayer.removeMoney(amount)

    if(type(inf) == "table") then
        print("[esx_invest] Adding money to an existing investment")
        MySQL.Sync.execute("UPDATE `invest` SET amount=amount+@num WHERE `identifier`=@id AND active=1 AND job=@job", {["@id"] = xPlayer.getIdentifier(), ["@num"]=amount, ['@job'] = job})
    else
        print("[esx_invest] Creating a new investment")
        print(job)
        print(amount)
        print(rate)
        MySQL.Sync.execute("INSERT INTO `invest` (identifier, job, amount, rate) VALUES (@id, @job, @amount, @rate)", {
            ["@id"] = xPlayer.getIdentifier(),
            ["@job"] = job,
            ["@amount"] = amount,
            ["@rate"] = rate
        })
    end
end)

-- Sell an investment
RegisterServerEvent("invest:sell")
AddEventHandler("invest:sell", function(job, sellRate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local id = xPlayer.getIdentifier()

    local investment = MySQL.Sync.fetchAll('SELECT * FROM `invest` WHERE `identifier`=@id AND active=1 AND job=@job', {["@id"] = id, ['@job'] = job})
    for k, v in pairs(investment) do investment = v end

    local amount = investment.amount
    local addMoney = amount + (sellRate * amount)

    MySQL.Sync.execute("UPDATE `invest` SET active=0, sold=now(), soldAmount=@money WHERE `id`=@id", {["@id"] = investment.id, ["@money"] = addMoney})

    if(addMoney > 0) then
        xPlayer.addMoney(addMoney)
    else
        xPlayer.removeMoney(addMoney)
    end
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
            Cache[v.name] = {stock = newRate, rate = rate, label = v.label, name = v.name}
        end
        loopUpdate()
    end
    local jobs = MySQL.Sync.fetchAll("SELECT name,label,investRate FROM jobs")
    for k, v in pairs(jobs) do
        Cache[v.name] = {stock = v.investRate, rate = "stale", label = v.label, name = v.name}
    end
    loopUpdate()
end)

-- print(genRand(0, 2, 2)) -- from 0.00 to 2.00
-- print(genRand(1, 2, 2)) -- from 1.00 to 2.00