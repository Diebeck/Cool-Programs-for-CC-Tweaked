local p = peripheral.find("playerDetector")
if p == nil then
    error("No player detector found!")
end
peripheral.find("modem", rednet.open)

term.clear()
term.setCursorPos(1,1)
print("Running HoloPlayer Server")

while true do
    local players = p.getOnlinePlayers()
    for i=1, #players do
        local playerinfo = p.getPlayer(players[i])
        local x, y, z, user
        x = playerinfo.x
        y = playerinfo.y
        z = playerinfo.z
        user = players[i]
        local info = {x, y, z, user}
        rednet.broadcast(info,"holoplayer")
    end
end
