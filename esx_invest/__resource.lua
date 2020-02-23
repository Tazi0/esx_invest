resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page('client/UI.html')

client_scripts {
  "config.lua",
  "@mysql-async/lib/MySQL.lua",
  "client.lua"
}

server_scripts {
  "config.lua",
  "@mysql-async/lib/MySQL.lua",
  "server.lua",
}


files {
  'client/UI.html',
  'client/style.css',
  'client/media/font/Bariol_Regular.otf',
  'client/media/font/Vision-Black.otf',
  'client/media/font/Vision-Bold.otf',
  'client/media/font/Vision-Heavy.otf',
  'client/media/img/bg.png',
  'client/media/img/circle.png',
  'client/media/img/curve.png',
  'client/media/img/fingerprint.png',
  'client/media/img/fingerprint.jpg',
  'client/media/img/graph.png',
  'client/media/img/logo-big.png',
  'client/media/img/logo-top.png',
}
