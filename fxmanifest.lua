fx_version "cerulean"
game "gta5"

shared_scripts {
    "config.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',	
    "server/functions.lua",
    "server/main.lua",
}

client_scripts {
    "client/functions.lua",
    "client/main.lua"
}