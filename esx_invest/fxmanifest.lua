resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page('client/html/UI.html')

dependencies({
    'mysql-async',
    'es_extended'
})

client_scripts({
    'config.lua',
    'client/client.lua'
})

server_scripts({
    'config.lua',
    "server.lua",
    '@mysql-async/lib/MySQL.lua'
})

files({
    'client/html/UI.html',
    'client/html/script.js',
    'client/html/style.css',
    'client/html/media/font/Bariol_Regular.otf',
    'client/html/media/font/Vision-Black.otf',
    'client/html/media/font/Vision-Bold.otf',
    'client/html/media/font/Vision-Heavy.otf',
    'client/html/media/img/bg.png',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/graph.png',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png',
})