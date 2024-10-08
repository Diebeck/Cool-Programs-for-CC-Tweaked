term.clear()

local action = false
local amount = 64
local scrollN = 0
local inv

--shorten
local function shorten(string)
    if string == nil then return "" end
    local ddpos = string.find(string,":")
    if ddpos == nil then ddpos = 0 end
    local newstring = string.sub(string,ddpos+1,-1)
    return newstring
end

--getColorFromName
local function getColorFromName(input)
    if input == nil then return colors.black end
    local seed = ""
    for i = 1, string.len(input) do
        seed = seed .. string.byte(input, i)
    end
    math.randomseed(seed)
    local ti = math.random(1,12)
    local colortable = {4,8,16,32,64,256,512,1024,2048,4096,8192,16384}
    return colortable[ti]
  end

--drawSlots
local function drawSlots()
    while true do
        
        term.setBackgroundColour(colors.black)
        for i=1, 13 do
            term.setCursorPos(1,i)
            term.write("                 ")
        end

        for i=1, 16 do
            local x = ((i-1) % 4) + 1
            local y = math.ceil(i / 4)

            --draws border
            if i == turtle.getSelectedSlot() then
                local a, b, c, d, e
                if action then
                    a, b, c, d = "ffff1", "1111f", "1", "11111"
                else
                    a, b, c, d = "ffff0", "0000f", "0", "00000"
                end
                term.setCursorPos(x * 4 - 3, y * 3 - 2)
                term.blit("\159\143\143\143\144",a,b)
                term.setCursorPos(x * 4 - 3, y * 3 - 1)
                term.blit("\149","f",c)
                term.setCursorPos(x * 4 - 3, y * 3 - 0)
                term.blit("\149","f",c)
                term.setCursorPos(x * 4 + 1, y * 3 - 1)
                term.blit("\149",c,"f")
                term.setCursorPos(x * 4 + 1, y * 3 - 0)
                term.blit("\149",c,"f")
                term.setCursorPos(x * 4 - 3, y * 3 + 1)
                term.blit("\130\131\131\131\129",d,"fffff")
            end

            local item = turtle.getItemDetail(i)
            local name, count = "", ""
            term.setBackgroundColor(colors.gray)
            if item ~= nil then
                name = item.name
                count = item.count
                term.setBackgroundColor(getColorFromName(name))
            end

            term.setCursorPos(x * 4 - 2, y * 3 - 1)
            term.write("   ")
            term.setCursorPos(x * 4 - 2, y * 3)
            term.write("   ")

            local chars = 1
            --chars = (os.clock() % string.len(shorten(name))) + 1
            term.setCursorPos(x * 4 - 2, y * 3 - 1)
            term.write(string.sub(shorten(name),chars,chars + 2))
            term.setCursorPos(x * 4 - 2, y * 3)
            term.write(count)

        end
    sleep(0)
    end
end

--suckFromInventory
local function suckFromInventory(n)
    local invName = peripheral.getName(inv)
    local emptySlot
    for f=1, inv.size() do
        emptySlot = inv.getItemDetail(f)
        if emptySlot == nil then
            emptySlot = f
            break
        end
    end
    inv.pushItems(invName,1,64,emptySlot)
    inv.pushItems(invName,n,64,1)
    turtle.suck(amount)
    inv.pushItems(invName,1,64,n)
    inv.pushItems(invName,emptySlot,64,1)
end

--pushToInventory
local function pushToInventory(n)
    local invName = peripheral.getName(inv)
    local emptySlot
    for f=1, inv.size() do
        emptySlot = inv.getItemDetail(f)
        if emptySlot == nil then
            emptySlot = f
            break
        end
    end
    turtle.drop(amount)
    inv.pushItems(invName,emptySlot,64,n)
end

--checkClicks
local function checkClicks()
    while true do
        local _, _, clickx, clicky = os.pullEvent("mouse_click")
        
        for i=1, 16 do
            local x = (((i-1) % 4) + 1) * 4 - 2
            local y = (math.ceil(i / 4)) * 3 - 1
            if clickx >= x and clickx <= x+2 and clicky >= y and clicky <= y+1 then
                if i == turtle.getSelectedSlot() then
                    if action then
                        action = false
                    else
                        action = true
                    end
                else
                    if action then
                        local originalSlot = turtle.getSelectedSlot()
                        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name ~= turtle.getItemDetail(originalSlot).name then
                            local emptySlot
                            for f=1, 16 do
                                emptySlot = turtle.getItemDetail(f)
                                if emptySlot == nil then
                                    emptySlot = f
                                    break
                                end
                            end
                            turtle.select(i)
                            turtle.transferTo(emptySlot,64)
                            turtle.select(originalSlot)
                            turtle.transferTo(i,64)
                            turtle.select(emptySlot)
                            turtle.transferTo(originalSlot,64)
                        end
                        turtle.transferTo(i,amount)
                    end
                    action = false
                end
                turtle.select(i)
            end
        end

        if clickx == 19 and clicky < 13 and clicky > 6 then
            suckFromInventory(clicky - 6 - scrollN)
        end

        if clickx == 20 and clicky < 13 and clicky > 6 then
            pushToInventory(clicky - 6 - scrollN)
        end

        if clickx == 19 and clicky == 4 then
            amount = 64
        elseif clickx == 20 and clicky == 4 then
            amount = 1
        elseif clickx == 21 and clicky == 4 then
            if amount < 64 then
                amount = amount + 1
            end
        elseif clickx == 22 and clicky == 4 then
            if amount > 1 then
                amount = amount - 1
            end
        elseif clickx == 27 and clicky == 4 then
            turtle.craft(amount)
        elseif clickx == 29 and clicky == 4 then
            turtle.drop(amount)
        elseif clickx == 30 and clicky == 4 then
            turtle.suck(amount)
        elseif clickx == 32 and clicky == 4 then
            turtle.equipLeft()
        elseif clickx == 33 and clicky == 4 then
            turtle.equipRight()
        end

    end
end

--drawData
local function drawData()
    while true do
        local item = turtle.getItemDetail(turtle.getSelectedSlot)
        local name, count = "", ""
        if item ~= nil then
            name = item.name
            count = item.count
        end
        term.setTextColor(colors.white)
        term.setBackgroundColour(colors.black)
        term.setCursorPos(19,2)
        term.write("                                     ")
        term.setCursorPos(19,2)
        term.write(count.." "..shorten(name))
        term.setTextColor(colors.gray)
        term.setCursorPos(19,3)
        term.write("                                     ")
        term.setCursorPos(19,3)
        term.write(name)
        term.setTextColor(colors.white)
        term.setBackgroundColour(colors.black)

        term.setCursorPos(24,4)
        term.write("  ")
        term.setCursorPos(24,4)
        term.write(amount)

        sleep(0)
    end
end

--drawInventory
local function drawInventory()
    while true do
        inv = peripheral.wrap("front")
        local block, t = peripheral.getType(inv)
        if inv ~= nil and t == "inventory" then
            local contents = {}
            for i=math.max(1 - scrollN,1), math.min(6 - scrollN,inv.size()) do
                contents[i] = inv.getItemDetail(i)
            end

            term.setCursorPos(19,6)
            term.setBackgroundColor(colors.black)
            term.write("\187"..shorten(block))

            for i=1, inv.size() do
                if contents[i] == nil then
                    contents[i] = {
                        name = " ",
                        count = "-"
                    }
                end
                if i + 6 + scrollN > 6 and i + 6 + scrollN < 13 then
                    if contents[i].name == " " then
                        term.setBackgroundColor(colors.black)
                    else
                        term.setBackgroundColor(getColorFromName(contents[i].name))
                    end
                    term.setCursorPos(19,i + 6 + scrollN)
                    term.blit("ffffffffffffffffffffff","ffffffffffffffffffffff","ffffffffffffffffffffff")
                    term.setCursorPos(19,i + 6 + scrollN)
                    term.write("\27\26"..contents[i].count.." "..shorten(contents[i].name))
                end
            end
        end

    end
end

--getScroll
local function getScroll()
    while true do
        local _, dir = os.pullEvent("mouse_scroll")
        if inv.size() < 7 then
            scrollN = 0
        else
            scrollN = scrollN + dir * -1
            if scrollN > 0 then scrollN = 0 end
            if scrollN < (inv.size()-6) * -1 then scrollN = (inv.size()-6) * -1 end
        end
    end
end

--debug
local function debug()
    while true do
      local _, key = os.pullEvent("key")
      if key == keys.u then
        pushToInventory(3)
      end
    end
  end

--draws buttons
term.setCursorPos(19,4)
term.blit("M1+-x   C DP LR","000000000000000","7878ffff7f87f87")

parallel.waitForAll(drawSlots, checkClicks, drawData, drawInventory, getScroll, debug)
