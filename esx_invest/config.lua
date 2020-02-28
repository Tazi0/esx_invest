Config = {}

-- Show blips
Config.ShowBlips = true

-- Blip data/exact point
Config.WallStreet = {
    {name="Stock Exchange", id=374, x=160.266, y=-1040.203, z=29.374}
}

-- Loop for new stock rates 
Config.InvestRateTime = 10 -- Minutes

-- Good stock = more money geranteed or not
Config.GoodStock = false 
-- if *true* it will be from 1.00 to 2.00 *else* it can be 0.00 to 2.00 (so if it's true then they will 100% make money geranteed)