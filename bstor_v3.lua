-- BSTOR Program made by D.
-- Dont touch my shit unless you know what you're doing!!!

local blocks = {}
if fs.exists(".blockdata") then
  local file = fs.open(".blockdata","r")
  blocks = textutils.unserialize(file.readAll())
  file.close()
end

local turtledata = {
  x = 0,
  y = 0,
  z = 0,
  dir = "north"
}

if fs.exists(".turtledata") then
  local file = fs.open(".turtledata","r")
  turtledata = textutils.unserialize(file.readAll())
  file.close()
else
  print("turtledata file not found! Please enter:")
  print("The turtle's X position:")
  turtledata.x = read()
  print("The turtle's Y position:")
  turtledata.y = read()
  print("The turtle's z position:")
  turtledata.z = read()
  print("The turtle's angle (north/south/east/west):")
  turtledata.dir = read()
end

if gps.locate() then
    turtle.forward()
    local ox, _, oz = gps.locate()
    turtle.back()
    if turtledata.z - 1 == oz then
      turtledata.dir = "north"
    elseif turtledata.z + 1 == oz then
      turtledata.dir = "south"
    elseif turtledata.x + 1 == ox then
      turtledata.dir = "east"
    elseif turtledata.x - 1 == ox then
      turtledata.dir = "west"
    end
    turtledata.x, turtledata.y, turtledata.z = gps.locate()
end

local yview = 0
local info = "\187 Info will appear here"
local slotn = 0
local slotAmount = 1
local gettingAsked = 0
local detecting = true

-- Functions

--setBlock
local function setBlock(x,y,z,type)
  x = tonumber(x)
  y = tonumber(y)
  z = tonumber(z)

  if blocks[x] == nil then
    blocks[x] = {}
  end
  if blocks[x][y] == nil then
    blocks[x][y] = {}
  end
  if blocks[x][y][z] == nil then
    blocks[x][y][z] = {}
  end
  blocks[x][y][z] = type
end

--getBlock
local function getBlock(x,y,z)
  if blocks[x] and blocks[x][y] and blocks[x][y][z] then
    return blocks[x][y][z]
  end
end

--save
local function save()
  while true do
    local file = fs.open(".blockdata","w")
    file.write(textutils.serialize(blocks))
    file.close()
    local file = fs.open(".turtledata","w")
    file.write(textutils.serialize(turtledata))
    file.close()
    sleep(1)
  end
end

--ask
local function ask(question)
  gettingAsked = 1
  local x, y = term.getCursorPos()
  sleep(0)
  term.setCursorPos(15,11)
  term.write(question)
  term.setCursorPos(15,12)
  answer = read()
  term.setCursorPos(15,11)
  term.write("                          ")
  term.setCursorPos(15,12)
  term.write("                          ")
  term.setCursorPos(x,y)
  gettingAsked = 0
  return answer
end

--shorten
local function shorten(string)
  if string == nil then return "" end
  local ddpos = string.find(string,":")
  if ddpos == nil then ddpos = 0 end
  local newstring = string.sub(string,ddpos+1,-1)
  return newstring
end

--detect
local function detect()
  local relativex = turtledata.x
  local relativez = turtledata.z

  if turtledata.dir == "north" then
    relativez = turtledata.z - 1
  elseif turtledata.dir == "east" then
    relativex = turtledata.x + 1
  elseif turtledata.dir == "south" then
    relativez = turtledata.z + 1
  elseif turtledata.dir == "west" then
    relativex = turtledata.x - 1
  end

  local has_block, data = turtle.inspectUp()
  if has_block then
    setBlock(turtledata.x, turtledata.y + 1, turtledata.z, shorten(data.name))
  else
    setBlock(turtledata.x, turtledata.y + 1, turtledata.z, nil)
  end

  local has_block, data = turtle.inspectDown()
  if has_block then
    setBlock(turtledata.x, turtledata.y - 1, turtledata.z, shorten(data.name))
  else
    setBlock(turtledata.x, turtledata.y - 1, turtledata.z, nil)
  end

  local has_block, data = turtle.inspect()
  if has_block then
    setBlock(relativex, turtledata.y, relativez, shorten(data.name))
  else
    setBlock(relativex, turtledata.y, relativez, nil)
  end

  repeat sleep(0) until gettingAsked == 0
  term.setCursorPos(24,3)
  term.write("                      ")
  term.setCursorPos(24,3)
  term.setTextColor(colors.lightGray)
  term.write(shorten(data.name))
  term.setTextColor(colors.white)
end

--geoScan
local function geoScan()
  local geo = peripheral.find("geoScanner")

  if geo == nil then
    info = "No scanner detected!"
    return nil
  end

  local radius = tonumber(ask("Radius? Up to 8 is free"))
  if type(radius) ~= "number" then
    info = "ERROR: Must be number"
    return nil
  end

  if radius < 1 then radius = 1 end
  if radius > 16 then radius = 16 end
  info = "Scanned with radius of "..radius
  local scannedTable = geo.scan(radius)

  --sets all blocks to air
  for x=radius*-1, radius do
    for y=radius*-1, radius do
      for z=radius*-1, radius do
        setBlock(turtledata.x + x, turtledata.y + y, turtledata.z + z, nil)
      end
    end
  end

  for i=1, #scannedTable do
    local subtable = scannedTable[i]

    --records all blocks
    if subtable ~= nil then
      setBlock(turtledata.x + subtable.x, turtledata.y + subtable.y, turtledata.z + subtable.z, shorten(subtable.name))
    end

  end
  setBlock(turtledata.x, turtledata.y, turtledata.z, nil)
end

--move
local function move(movement)

  if movement == "turnLeft" then
    turtle.turnLeft()
    if turtledata.dir == "north" then
      turtledata.dir = "west"
    elseif turtledata.dir == "west" then
      turtledata.dir = "south"
    elseif turtledata.dir == "south" then
      turtledata.dir = "east"
    elseif turtledata.dir == "east" then
      turtledata.dir = "north"
    end
  end

  if movement == "turnRight" then
    turtle.turnRight()
    if turtledata.dir == "north" then
      turtledata.dir = "east"
    elseif turtledata.dir == "east" then
      turtledata.dir = "south"
    elseif turtledata.dir == "south" then
      turtledata.dir = "west"
    elseif turtledata.dir == "west" then
      turtledata.dir = "north"
    end
  end

  if movement == "forward" and turtle.forward() then
    if turtledata.dir == "north" then
      turtledata.z = turtledata.z - 1
    elseif turtledata.dir == "east" then
      turtledata.x = turtledata.x + 1
    elseif turtledata.dir == "south" then
      turtledata.z = turtledata.z + 1
    elseif turtledata.dir == "west" then
      turtledata.x = turtledata.x - 1
    end
  end

  if movement == "back" and turtle.back() then
    if turtledata.dir == "north" then
      turtledata.z = turtledata.z + 1
    elseif turtledata.dir == "east" then
      turtledata.x = turtledata.x - 1
    elseif turtledata.dir == "south" then
      turtledata.z = turtledata.z - 1
    elseif turtledata.dir == "west" then
      turtledata.x = turtledata.x + 1
    end
  end

  if movement == "up" and turtle.up() then
    turtledata.y = turtledata.y + 1
  end

  if movement == "down" and turtle.down() then
    turtledata.y = turtledata.y - 1
  end

  if movement == "dig" then
    turtle.dig()
  end

  if movement == "digUp" then
    turtle.digUp()
  end

  if movement == "digDown" then
    turtle.digDown()
  end

  if movement == "place" then
    if string.sub(turtle.getItemDetail().name,-4,-1) == "sign" then
      turtle.place(ask("Sign contents:"))
    else
    turtle.place()
    end
  end

  if movement == "placeUp" then
    turtle.placeUp()
  end

  if movement == "placeDown" then
    turtle.placeDown()
  end

  if detecting then
    detect()
  end
end

--checkClicks
local function checkClicks()
  while true do
    local _, _, x, y = os.pullEvent("mouse_click")
    if x == 15 and y == 2 then
      move("turnLeft")
    elseif x == 17 and y == 2 then
      move("turnRight")
    elseif x == 16 and y == 1 then
      move("forward")
    elseif x == 16 and y == 3 then
      move("back")
    elseif x == 15 and y == 1 then
      move("down")
    elseif x == 17 and y == 1 then
      move("up")
    elseif x == 19 and y == 1 then
      move("digUp")
    elseif x == 19 and y == 2 then
      move("dig")
    elseif x == 19 and y == 3 then
      move("digDown")
    elseif x == 21 and y == 1 then
      move("placeUp")
    elseif x == 21 and y == 2 then
      move("place")
    elseif x == 21 and y == 3 then
      move("placeDown")
    elseif x == 10 and y == 1 and yview < 9then
      yview = yview + 1
    elseif x == 13 and y == 1 and yview > -9then
      yview = yview - 1
    elseif x > 1 and x < 13 and y > 1 and y < 13 then
      info = getBlock(turtledata.x + x - 7, turtledata.y + yview, turtledata.z + y -7)
      if x == 7 and y == 7 and yview == 0 then info = "turtle" end
      if info == nil then info = "" end
    elseif x == 15 and y == 7 then
      slotn = (slotn - 1) % 16
    elseif x == 18 and y == 7 then
      slotn = (slotn + 1) % 16
    elseif x == 15 and y == 9 then
      turtle.drop(slotAmount)
    elseif x == 16 and y == 9 then
      turtle.suck(slotAmount)
    elseif x == 20 and y == 7 then
      if slotAmount == 1 then
        slotAmount = 64
      else
        slotAmount = 1
      end
    elseif x == 23 and y == 2 then
      turtle.refuel(slotAmount)
    elseif x == 23 and y == 3 then
      if peripheral.getType("front") == "computer" then
        local c = peripheral.wrap("front")
        info = "ID: "..c.getID()
        c.turnOn()
        if c.isOn then
          c.reboot()
        end
      end
    elseif x == 18 and y == 9 then
      turtle.equipLeft()
    elseif x == 19 and y == 9 then
      turtle.equipRight()
    elseif x == 21 and y == 9 then
      if detecting then
        detecting = false
      else
        detecting = true
      end
    elseif x == 22 and y == 9 then
      geoScan()
    end
  end
end

--checkKeys
local function checkKeys()
  while true do
    repeat sleep(0) until gettingAsked == 0
    local _, key = os.pullEvent("key")
    if gettingAsked == 1 then key = nil end

    if key == keys.w or key == keys.up then
      move("forward")
    elseif key == keys.s or key == keys.down then
      move("back")
    elseif key == keys.a or key == keys.left then
      move("turnLeft")
    elseif key == keys.d or key == keys.right then
      move("turnRight")
    elseif key == keys.e then
      move("up")
    elseif key == keys.q then
      move("down")
    end
  end
end

--drawData
local function drawData()
  while true do
    repeat sleep(0.1) until gettingAsked == 0

    term.setCursorPos(23,1)
    term.blit("XYZ: ","edb0f","fffff")

    term.setTextColor(colors.red)
    term.write(turtledata.x.." ")
    term.setTextColor(colors.green)
    term.write(turtledata.y.." ")
    term.setTextColor(colors.blue)
    term.write(turtledata.z.." ")

    term.setTextColor(colors.white)
    term.setCursorPos(24,2)
    term.write("Fuel: "..turtle.getFuelLevel().."       ")

    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.lightGray)
    term.setCursorPos(11,1)
    term.write("  ")
    term.setCursorPos(11,1)
    term.write(yview)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)

    term.setCursorPos(15,5)
    term.write("                                   ")
    term.setCursorPos(15,5)
    term.setTextColor(colors.cyan)
    term.write(info)
    term.setTextColor(colors.white)

    term.setCursorPos(16,7)
    term.write("  ")
    term.setCursorPos(16,7)
    term.write(slotn + 1)
    turtle.select(slotn + 1)
    term.setCursorPos(15,8)
    term.write("                                          ")
    term.setCursorPos(15,8)

    if turtle.getItemDetail() ~= nil then
      term.write(turtle.getItemDetail().count.." "..shorten(turtle.getItemDetail().name))
    else
      term.write("Empty")
    end

    term.setCursorPos(21,7)
    term.write("  ")
    term.setCursorPos(21,7)
    term.write(slotAmount)

    term.setCursorPos(21,9)
    if detecting then
      term.blit("D","7","d")
    else
      term.blit("D","7","e")
    end

    sleep(0)
  end
end

--getColorFromName
local function getColorFromName(input)
  if input == nil then return colors.black end
  local seed = ""
  for i = 1, string.len(input) do
      seed = seed .. string.byte(input, i)
  end
  math.randomseed(seed)
  local ti = math.random(1,13)
  local colortable = {2,4,8,16,32,64,256,512,1024,2048,4096,8192,16384}
  return colortable[ti]
end

--drawTurtle
local function drawTurtle()
  term.setCursorPos(7,7)
    if turtledata.dir == "north" then
      term.blit("\30","7","4")
    elseif turtledata.dir == "south" then
      term.blit("\31","7","4")
    elseif turtledata.dir == "east" then
      term.blit("\16","7","4")
    elseif turtledata.dir == "west" then
      term.blit("\17","7","4")
    end
end

--drawBlocks
local function drawBlocks()
  while true do
    repeat sleep(0) until gettingAsked == 0

    --cleans
    for ox=-5, 5 do
      for oz=-5, 5 do
        term.setCursorPos(ox+7, oz+7)
        term.blit(" ","f","f")
      end
    end

    --layer -2
    for ox=-5, 5 do
      for oz=-5, 5 do
        local gotblock = getBlock(turtledata.x + ox, turtledata.y + yview - 2, turtledata.z + oz)
        term.setCursorPos(ox+7, oz+7)
        if gotblock then
          term.blit("\127","7","f")
        end
      end
    end

    --layer -1
    for ox=-5, 5 do
      for oz=-5, 5 do
        local gotblock = getBlock(turtledata.x + ox, turtledata.y + yview - 1, turtledata.z + oz)
        term.setCursorPos(ox+7, oz+7)
        if gotblock then
          term.blit(" ","7","7")
        end
      end
    end

    --layer 0
    for ox=-5, 5 do
      for oz=-5, 5 do
        local gotblock = getBlock(turtledata.x + ox, turtledata.y + yview, turtledata.z + oz)
        term.setCursorPos(ox+7, oz+7)
        term.setBackgroundColor(getColorFromName(gotblock))
        if gotblock then
          term.write(string.sub(gotblock,1,1))
        end
      end
    end

    term.setBackgroundColor(colors.black)
    if yview == 0 then
      drawTurtle()
    end
  sleep(0)
  end
end

--coolName
local function coolName()
  while true do
    os.setComputerLabel("| AI."..os.computerID().." |")
    sleep(0.1)
    os.setComputerLabel("/ AI."..os.computerID().." \\")
    sleep(0.1)
    os.setComputerLabel("- AI."..os.computerID().." -")
    sleep(0.1)
    os.setComputerLabel("\\ AI."..os.computerID().." /")
    sleep(0.1)
  end
end

--autodetect
local function autodetect()
  while true do
    detect()
    sleep(1)
  end
end

--debug
local function debug()
  while true do
    local _, key = os.pullEvent("key")
    if key == keys.u then

    end
  end
end

-- Actual code

-- Draws the frame
term.clear()
term.setCursorPos(1,1)
term.blit("      N  \30  \31","8888888888888","0000000000880")
for i=2, 6 do
  term.setCursorPos(1,i)
  term.blit("             ","8fffffffffff8","0fffffffffff0")
end
term.setCursorPos(1,7)
term.blit("W           E","8fffffffffff8","0fffffffffff0")
for i=8, 15 do
  term.setCursorPos(1,i)
  term.blit("             ","8fffffffffff8","0fffffffffff0")
end
term.setCursorPos(1,13)
term.blit("      S      ","8888888888888","0000000000000")

-- Draws the buttons
term.setCursorPos(15,1)
term.blit("\31\24\30 \30 \30","fffffff","000fef5")
term.setCursorPos(15,2)
term.blit("\27 \26 \7 \7 \30","ffffffff1","000fef5ff")
term.setCursorPos(15,3)
term.blit(" \25  \31 \31 \187","ffffffff3","000fef5ff")
term.setCursorPos(15,7)
term.blit("\27  \26 x","000007","fffff0")
term.setCursorPos(15,9)
term.blit("\25\24 LR  G","77777777","00f00ff0")

parallel.waitForAll(save, drawData, drawBlocks, checkClicks, checkKeys, coolName, debug)