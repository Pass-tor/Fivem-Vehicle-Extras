resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

name 'yakuza_extras'
description 'A simple menu to make changing vehicle extras easy with the ability to customize the names extras have within the menu for certain vehicles.'
author 'MYRICA#2250'
version 'v1.0.0'

client_scripts {
    "@NativeUI/NativeUI.lua",
    "config.lua",
    "keys.lua",
    "client/menu.lua"
}

server_scripts {
    "config.lua",
    "keys.lua",
}

dependency "NativeUI"