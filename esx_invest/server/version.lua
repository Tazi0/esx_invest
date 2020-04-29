-- Modified version of
-- https://github.com/Bluethefurry/FiveM-Resource-Version-Check-Thing

Citizen.CreateThread( function()
    updatePath = "Tazi0/esx_invest"
    resourceName = "ESX Invest ("..GetCurrentResourceName()..")" -- the resource name
    
    function checkVersion(err,responseText, headers)
        curVersion = LoadResourceFile(GetCurrentResourceName(), "version") -- make sure the "version" file actually exists in your resource root!
    
        if tonumber(curVersion) < tonumber(responseText) then
            print("\n------------------------------------")
            print("\n"..resourceName.." is outdated, should be:\n"..responseText.." but it is:\n"..curVersion.."\nplease update it from \nhttps://github.com/"..updatePath.."/releases/latest")
            print("\n------------------------------------")
        end
    end
    
    PerformHttpRequest("https://raw.githubusercontent.com/"..updatePath.."/master/version", checkVersion, "GET")
end)