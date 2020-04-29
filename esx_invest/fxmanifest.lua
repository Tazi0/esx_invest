fx_version 'bodacious'
game 'gta5'

author 'Tazio de Bruin'
title 'ESX Invest'
description 'Invest in companies'
version '0.8.7'

ui_page 'client/html/UI.html'

provide 'mysql-async'
dependencies {
    'mysql-async',
    'es_extended'
}

client_scripts {
	'locales/main.lua',
	'locales/en.lua', 
    'config.lua',
    'client/client.lua'
}

server_scripts {
	'locales/main.lua',
	'locales/en.lua', 
    'config.lua',
    'server.lua',
    '@mysql-async/lib/MySQL.lua'
}

files {
    'client/html/UI.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/media/font/Futura-Bold.woff',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png',
}