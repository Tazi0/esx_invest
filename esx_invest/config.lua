Config = {}

-- Language
Config.Locale = 'en'

-- Blips
Config.BlipCoords = {
    {x=-692.28, y=-587.52, z=31.55},
    {x=243.27, y=-1072.81, z=29.29},
    {x=-840.45, y=-334.11, z=38.68},
    {x=-59.98, y=-790.45, z=44.23}
}
Config.BlipName = "Stock Exchange"
Config.BlipID = 374
Config.BlipActive = true

-- Open & close key
Config.Keys = {
    Open = "E",
    Close = "ESC"
}

-- Loop for new stock rates 
Config.InvestRateTime = 10 -- Minutes

-- Stock settings
-- in %
Config.Stock = {
    Minimum = -5,
    Maximum = 5
}

-- Debug mode
Config.Debug = false