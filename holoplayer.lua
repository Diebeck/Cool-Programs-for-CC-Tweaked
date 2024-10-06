if peripheral.find("modem") == nil then
  error("Pocket computer has no modem!")
end

rednet.open("back")

print("Enter your username:")
local user = tostring(read())
local x, y, z

term.clear()
term.setCursorPos(1,1)
print("Running HoloPlayer")

local function getPosition()
  while true do
    x, y, z = gps.locate()
    x = math.floor(x)
    y = math.floor(y) - 1
    z = math.floor(z)
    term.setCursorPos(1,2)
    term.write("                    ")
    term.setCursorPos(1,2)
    term.write("XYZ: "..x.." "..y.." "..z)
    sleep(0.5)
  end
end

local function sendPosition()
  while true do
    local info = {x, y, z, user}
    rednet.broadcast(info,"holoplayer")
    sleep(0)
  end
end

parallel.waitForAll(getPosition, sendPosition)