server_script {
  "server.lua",
  "config.lua",
  "@mysql-async/lib/MySQL.lua"
}
client_script "html/client.lua"
ui_page('html/UI.html')

files {
	  'html/UI.html',
    'html/style.css',
    'html/media/font/Bariol_Regular.otf',
    'html/media/font/Vision-Black.otf',
    'html/media/font/Vision-Bold.otf',
    'html/media/font/Vision-Heavy.otf',
    'html/media/img/bg.png',
    'html/media/img/circle.png',
    'html/media/img/curve.png',
    'html/media/img/fingerprint.png',
    'html/media/img/fingerprint.jpg',
    'html/media/img/graph.png',
    'html/media/img/logo-big.png',
    'html/media/img/logo-top.png'
}
