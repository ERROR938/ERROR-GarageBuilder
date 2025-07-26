fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'error950'
description 'Fivem Society Garage Builder'
version '1.0'

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

dependency {
    "oxmysql",
    'ox_lib',
    "es_extended",
    "ox_target"
}