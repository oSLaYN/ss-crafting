fx_version 'cerulean'
game 'gta5'
lua54 'yes'
autor 'oSLaYN'
description 'Simple Crafting System - slayn-scripts.tebex.io'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/sh_*.lua'
}

client_scripts {
    'client/cl_*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_*.lua',
}