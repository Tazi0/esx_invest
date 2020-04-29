-- Modified version of
-- https://github.com/Bluethefurry/FiveM-Resource-Version-Check-Thing

Citizen.CreateThread( function()
    updatePath = "Tazi0/esx_invest"
    resourceName = "ESX Invest ("..GetCurrentResourceName()..")"
    
    function checkVersion(err,responseText, headers)
        curVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    
        if tonumber(curVersion) < tonumber(responseText) then
            print("\n------------------------------------")
            print("\n"..resourceName.." is outdated,\n"..curVersion.." -> "..responseText.."\nhttps://github.com/"..updatePath.."/releases/latest")
            print("\n------------------------------------")
        end
    end
    
    PerformHttpRequest("https://raw.githubusercontent.com/"..updatePath.."/master/version", checkVersion, "GET")
end)