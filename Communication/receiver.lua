peripheral.find("modem", rednet.open)

term.clear()
term.setCursorPos(1,1)
print("RECEIVING INSTRUCTIONS")
print("This is computer [ "..os.getComputerID().." ]")
print("Terminate the program for manual startup.")
print("Please wait...")

local command

local function getMessage()
  local _, message = rednet.receive("run")
  print("Running \""..message.."\"")
  command = message
end

local function offer()
  while true do
    local pinger = rednet.receive("discover",1)
    if pinger then
      rednet.send(pinger, os.getComputerID(), "offer")
    end
  end
end

local function anim()
  while true do
    term.setCursorPos(1,4)
    term.write("Please wait.  ")
    sleep(0.5)
    term.setCursorPos(1,4)
    term.write("Please wait.. ")
    sleep(0.5)
    term.setCursorPos(1,4)
    term.write("Please wait...")
    sleep(0.5)
  end
end

parallel.waitForAny(getMessage, anim, offer)
shell.run(command)
