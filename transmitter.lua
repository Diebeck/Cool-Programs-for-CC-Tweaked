peripheral.find("modem", rednet.open)
rednet.broadcast("","discover")

local function listen()
  while true do
    local offer = rednet.receive("offer",0.1)
    if offer ~= nil then
      term.write(offer)
      term.write(" ")
    end
  end
end

local function timeout()
  sleep(0.1)
end

print("Available computers:")
parallel.waitForAny(listen, timeout)

print("")
print("Target:")
local target = tonumber(read())
print("Message:")
local message = tostring(read())

rednet.send(target,message,"run")
