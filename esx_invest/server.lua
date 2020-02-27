ESX = nil

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