ESX = nil
Cache = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Get balance of invested companies
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

-- Get available companies
RegisterServerEvent("invest:list")
AddEventHandler("invest:list", function()
    TriggerClientEvent("invest:nui", source, {
        type = "list",
        cache = Cache
    })
end)

-- Get all invested companies
RegisterServerEvent("invest:all")
AddEventHandler("invest:all", function(special)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sql = 'SELECT * FROM `invest` '

    if(special) then
        sql = sql .. "INNER JOIN `companies` ON `invest`.`job` = `companies`.`label` "
    end

    sql = sql .. "WHERE `invest`.`identifier`= @id"

    if(special) then 
        sql = sql .. " AND `invest`.`active`=1"
    end

    local user = MySQL.Sync.fetchAll(sql, {["@id"] = xPlayer.getIdentifier()})

    for k, v in pairs(user) do
        print(k, v.identifier, v.amount, v.job, v.active, v.created, v.investRate)
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

    if(type(inf) == "table" and inf.job ~= nil) then
        if Config.Debug then
            print("[esx_invest] Adding money to an existing investment")
        end

        MySQL.Sync.execute("UPDATE `invest` SET amount=amount+@num WHERE `identifier`=@id AND active=1 AND job=@job", {["@id"] = xPlayer.getIdentifier(), ["@num"]=amount, ['@job'] = job})
    else
        if Config.Debug then
            print("[esx_invest] Creating a new investment")
        end

        MySQL.Sync.execute("INSERT INTO `invest` (identifier, job, amount, rate) VALUES (@id, @job, @amount, @rate)", {
            ["@id"] = id,
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

    MySQL.Sync.execute("UPDATE `invest` SET active=0, sold=now(), soldAmount=@money, rate=@rate WHERE `id`=@id", {["@id"] = investment.id, ["@money"] = addMoney, ["@rate"] =  sellRate})

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
        local companies = MySQL.Sync.fetchAll("SELECT * FROM `companies`")
        for k, v in pairs(companies) do
            if Config.GoodStock then
                newRate = genRand(1, 2, 2)
            else
                newRate = genRand(0, 2, 2)
            end

            local rate = "stale"
            if newRate > v.investRate then
                rate = "up"
            elseif newRate < v.investRate then
                rate = "down"
            end
            -- print(newRate)
            -- print(v.name)
            MySQL.Sync.execute("UPDATE companies SET investRate=@invest, rate=@rate WHERE label=@label", {
                ["@invest"] = newRate,
                ["@label"] = v.label,
                ["@rate"] = rate
            })
            Cache[v.label] = {stock = newRate, rate = rate, label = v.label, name = v.name}
        end
        loopUpdate()
    end
    local companies = MySQL.Sync.fetchAll("SELECT * FROM `companies`")
    for k, v in pairs(companies) do
        if(v.investRate == nil) then
            if Config.GoodStock then
                v.investRate = genRand(1, 2, 2)
            else
                v.investRate = genRand(0, 2, 2)
            end
            MySQL.Sync.execute("UPDATE companies SET investRate=@rate WHERE label=@label", {
                ["@rate"] = v.investRate,
                ["@label"] = v.label
            })
        end
        Cache[v.label] = {stock = v.investRate, rate = v.rate, label = v.label, name = v.name}
    end
    loopUpdate()
end)

-- print(genRand(0, 2, 2)) -- from 0.00 to 2.00
-- print(genRand(1, 2, 2)) -- from 1.00 to 2.00