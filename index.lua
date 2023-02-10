-- Детектор игроков в зоне радара --
-- С оповещением в чат --

local cmp = require("component")
local term = require("term")
local chat = cmp.chat_box
local sensor = cmp.radar
local gpu = cmp.gpu

chat.setName("Дом")

cachedUsers = {}
users = {}
total = 0

function updateDistance()
    for i = 1, #cachedUsers do
        local username = cachedUsers[i].name
        local distance = math.floor(cachedUsers[i].distance)
        
        gpu.set(2, i + 1, "["..i.."] "..username.." | "..distance.." метров.")
    end
end

function updateCache()
    for i = 1, #users do
        cachedUsers[i] = users[i]
    end
end

while true do
   users = sensor.getPlayers()
   term.clear()
   
    if users ~= total then
        for i = 1, #users do
            local username = users[i].name
            local distance = math.floor(users[i].distance)
            
            if #cachedUsers == 0 or not username == cachedUsers[i].name then
                chat.say(username.." обнаружен в радиусе "..distance.." метра(-ов).")
            end
        end
        
        updateCache()
        updateDistance()
        total = #users
    else
        updateDistance()
    end
    
    os.sleep(5)
end
