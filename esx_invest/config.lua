Config = {}

-- Show blips
Config.ShowBlips = true

-- Blip data/exact point
Config.WallStreet = {
    {id=374, x=-692.28, y=-587.52, z=31.55},
    {id=374, x=243.27, y=-1072.81, z=29.29},
    {id=374, x=-840.45, y=-334.11, z=38.68},
    {id=374, x=-59.98, y=-790.45, z=44.23}
}

-- Loop for new stock rates 
Config.InvestRateTime = 10 -- Minutes

-- Good stock = more money geranteed or not
Config.GoodStock = false 
-- if *true* it will be from 1.00 to 2.00 *else* it can be 0.00 to 2.00 (so if it's true then they will 100% make money geranteed)

Config.Debug = true