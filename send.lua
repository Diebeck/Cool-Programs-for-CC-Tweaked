local message = {...}
print("Target Computer:")
local target = tonumber(read())
rednet.open("top")
rednet.send(target,message,"AI")