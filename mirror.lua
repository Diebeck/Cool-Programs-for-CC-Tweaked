--------------------------------------------------------------------------------------
-- Wojbies Program 5.0 - Mirror - Program to mirror terminal contents onto monitor. --
--------------------------------------------------------------------------------------
--   Copyright (c) 2013-2021 Wojbie (wojbie@wojbie.net)
--   Redistribution and use in source and binary forms, with or without modification, are permitted (subject to the limitations in the disclaimer below) provided that the following conditions are met:
--   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--   3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
--   4. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--   5. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--   NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. YOU ACKNOWLEDGE THAT THIS SOFTWARE IS NOT DESIGNED, LICENSED OR INTENDED FOR USE IN THE DESIGN, CONSTRUCTION, OPERATION OR MAINTENANCE OF ANY NUCLEAR FACILITY.

-- If you are looking for older version it can be found under: http://pastebin.com/DW3LCC3L

local expect, field = require "cc.expect".expect, require "cc.expect".field
local completion = require "cc.shell.completion"

local function peripheralType(_, text, _, add_space, type_)
    expect(2, text, "string")
    expect(4, add_space, "boolean", "nil")
    expect(5, type_, "string")
    local names = {}
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == type_ then
            table.insert(names, name)
        end
    end
    return completion.choice(nil, text, nil, names, add_space)
end

shell.setCompletionFunction(shell.getRunningProgram(), completion.build(
    { peripheralType, true, "monitor" },
    completion.program
))

local function printUsage()
    print( "Usage: mirror <name> <program> <arguments>" )
    return
end
 
local tArgs = table.pack(...)
if #tArgs < 2 then
    printUsage()
    return
end

local sName = tArgs[1]
if peripheral.getType(sName) ~= "monitor" then
	print("No monitor named " .. sName)
	return
end

local sProgram = tArgs[2]
local sPath = shell.resolveProgram(sProgram)
if sPath == nil then
	print("No such program: " .. sProgram)
	return
end

local fMain = function()
    shell.run(sProgram, table.unpack(tArgs, 3, tArgs.n))
end 

--# Special table that will transfer all functions call to each and every sub table.
local function createMultitable(...)
    local output = {}
    local tab = {...}
    expect(1, tab[1], "table")
    if #tab == 1 and tab[1] and type(tab[1]) == "table" then tab = tab[1] end
    for num,t in pairs(tab) do
        expect(num, t, "table")
    end

    local function makeWrap(key)
        return function(...)
            local ret = {}
            local tArgs = table.pack(...)
            for _, k in ipairs(tab) do
                if k[key] then
                    if #ret == 0 then ret = table.pack(k[key](table.unpack(tArgs))) --ret contains returns from first table that returned anything.
                    else k[key](table.unpack(tArgs)) end
                end
            end
            return table.unpack(ret)
        end
    end

    local function repopulate()
        for key in pairs(tab[1]) do --create static table of multitable functions using first one as template
            rawset(output, key, makeWrap(key))
        end
    end
    local function clean()
        for key in pairs(output) do --remove all parts of static table that stopped existing.
            if not tab[1][key] then rawset(output, key, nil) end
        end
    end

    local manymeta = { --Anytime index is requested fist table is used as refference.
        __index = function(_, key)
            if tab and tab[1] and tab[1][key] then --If it has value it tested then
                if type(tab[1][key]) == "function" then --If its function then a function that calls all tables in row is made
                    local wrap = makeWrap(key)
                    rawset(output, key, wrap) --If for some reason called function don't exists add it to static table
                    return wrap
                else
                    return tab[1][key]  --If its not a function then its just given out.
                end
            else
                return nil --Of it not exist in first table give nothing
            end
        end,
        __newindex = function() end, --If someone wants to add anything to the table do nothing.
        __call = function(_, nTab) --If someone calls table like function give him direct acces to table list.
            if nTab then tab = nTab clean() repopulate() end --Allows swapping source table. WARNING If tab is changed using different method repopulate will fail. NO SANITY CHECKS!!
            return tab
        end,
        __len = function() --Not sure if it works but this is giving the leanght of first table or 0 if there is no first table.
            return tab[1] and #tab[1] or 0
        end,
        __metatable = false, --No touching the metatable.
    }
    repopulate()

    return setmetatable(output, manymeta) --create actual manymeta table and return it
end

--### FramedWindow - Creates on provided term object a framed window of specified size. If term object has setTermScale its used to get best size possible.
local tBor = {c = "+", h = "-", v = "|"}--{c="#",h="=",v="H"}
local function framedWindow(parent, nX, nY, sName)
    
    local nParentX, nParentY
    local offsetX, offsetY
    local tLines
    local win = window.create( parent, 1, 1, nX, nY, false )
    local winReposition = win.reposition
    win.reposition = nil
    
    local function build()
        if parent.setTextScale then
			local nCX, nCY
			for i = 5, 0.5, -0.5 do
				parent.setTextScale(i)
				nCX, nCY = parent.getSize()
				if nCX >= nX and nCY >= nY then break end
			end
		end
        nParentX, nParentY = parent.getSize()
        
        offsetX = math.max(math.floor((nParentX - nX) / 2), 0)
        offsetY = math.max(math.floor((nParentY - nY) / 2), 0)
        local leftoverX = math.max(nParentX - nX - offsetX, 0)
        --local leftoverY = math.max(nParentY-nY-offsetY,0)
        
        tLines = {}
		tLines.empty = string.rep(" ", nParentX)
        tLines.bottom = string.rep(" ", math.max(0, offsetX - 1)) .. (offsetX > 0 and tBor.c or "") .. string.rep(tBor.h, math.min(nParentX, nX)) .. (leftoverX > 0 and tBor.c or "") .. string.rep(" ", math.max(0, leftoverX - 1))
        tLines.middle = string.rep(" ", math.max(0, offsetX - 1)) .. (offsetX > 0 and tBor.v or "") .. string.rep(" ", math.min(nParentX, nX)) .. (leftoverX > 0 and tBor.v or "") .. string.rep(" ", math.max(0, leftoverX - 1))
        if sName then
            local nameOffset = math.max(math.floor((math.min(nParentX, nX) - #sName) / 2), 0)
            local nameLeftover = math.max(math.min(nParentX, nX) - #sName - nameOffset, 0)
            tLines.top = string.rep(" ", math.max(0, offsetX - 1)) .. (offsetX > 0 and tBor.c or "") .. string.rep(tBor.h, nameOffset) .. string.sub(sName, 1, math.min(nParentX, nX)) .. string.rep(tBor.h, nameLeftover) .. (leftoverX > 0 and tBor.c or "") .. string.rep(" ", math.max(0, leftoverX - 1))
        else
            tLines.top = tLines.bottom
        end
        tLines.front = string.rep("7", nParentX) --0
        tLines.back = string.rep("8", nParentX) --f
        
        for y = 1, nParentY, 1 do
            if y < offsetY then tLines[y] = tLines.empty --empty
            elseif y == offsetY then tLines[y] = tLines.top --top
            elseif y <= offsetY + nY then tLines[y] = tLines.middle --middle
            elseif y == offsetY + nY + 1 then tLines[y] = tLines.bottom --bottom
            else  tLines[y] = tLines.empty --empty
            end
        end
        
        winReposition(offsetX + 1, offsetY + 1, nX, nY)
        
    end
    
    local function frame()
        for y = 1, nParentY, 1 do
			parent.setCursorPos(1, y)
            parent.blit(tLines[y], tLines.front, tLines.back)
		end
        win.redraw()
    end
    
    win.resize = function(nNewX, nNewY)
        expect(1, nNewX, "number")
        expect(2, nNewY, "number")
        nX, nY = nNewX, nNewY
        build()
        frame()
    end
    
    win.rename = function(sNewName)
        expect(1, sNewName, "string", "nil")
        sName = sNewName
        build()
        frame()
    end
    
    win.loadState = function(tWindow)
        local _, inY = tWindow.getSize()
        local cX, xY = tWindow.getCursorPos()
        for i = 0, 15 do
            win.setPaletteColour(2 ^ i, tWindow.getPaletteColour(2 ^ i))
        end
        if tWindow.getLine then
            for y = 1, math.min(nParentY, inY) do
                win.setCursorPos(1, y)
                win.blit(tWindow.getLine(y))
            end
        end
        win.setCursorPos(cX, xY)
        win.setCursorBlink(tWindow.getCursorBlink())
        win.setTextColor(tWindow.getTextColor())
        win.setBackgroundColor(tWindow.getBackgroundColor())
        win.redraw()
    end
    
    win.getName = function()
        return sName
    end
    
    win.localizeCoords = function(nCoordX, nCoordY) --localizes the parent coordinates for inside of the window.
		local x, y = nCoordX - offsetX, nCoordY - offsetY
		if x > 0 and y > 0 and x <= nX and y <= nY then
			return x, y
		end
	end
    
    build()
    frame()
    win.setVisible(true)
    return win
end

local function mirrorToMonitors(fMain,tSides,sName) --tSides is table with monitor sides to write on. If empty or not defined it will take all possible sides.
	local parent = term.current()
	local x,y = parent.getSize()
	local tMirrorsSides = {}
	local tMirrors = {}
	
	if not tSides or #tSides == 0 then
		peripheral.find("monitor", function(name,wrap) tMirrorsSides[name] = framedWindow(wrap,x,y,sName) table.insert(tMirrors,tMirrorsSides[name]) end)
	else
		for i,k in pairs(tSides) do
			if peripheral.isPresent(k) and peripheral.getType(k) == "monitor" then
				tMirrorsSides[k] = framedWindow(peripheral.wrap(k),x,y,sName)
				table.insert(tMirrors,tMirrorsSides[k])
			end
		end
	end
	
	local mirr = createMultitable(tMirrors)
	local mix = createMultitable(parent,mirr)
    mirr.loadState(parent)
	term.redirect(mix)
    

	local co = coroutine.create(fMain)

	local function resume( ... )
		local ok, param = coroutine.resume( co, ... )
		if not ok then
			printError( param )
		end
		return param
	end

	local ok, param = pcall( function()
		local sFilter = resume()
		local TResizeLoop = {}
		while coroutine.status( co ) ~= "dead" do
			local tEvent = table.pack(os.pullEventRaw())
			if tEvent[1] == "term_resize" then
				mirr.resize(parent.getSize())
			elseif tEvent[1] == "monitor_resize" and tMirrorsSides[tEvent[2]] then
				if TResizeLoop[tEvent[2]] then
					TResizeLoop[tEvent[2]] = false
				else
					tMirrorsSides[tEvent[2]].resize(parent.getSize())
					TResizeLoop[tEvent[2]] = true
				end
			end
			if sFilter == nil or tEvent[1] == sFilter or tEvent[1] == "terminate" then
				sFilter = resume(table.unpack(tEvent, 1, tEvent.n))
			end
			if coroutine.status( co ) ~= "dead" and (sFilter == nil or sFilter == "mouse_click") then
				if tEvent[1] == "monitor_touch" and tMirrorsSides[tEvent[2]] then
					tEvent[3],tEvent[4] = tMirrorsSides[tEvent[2]].localizeCoords(tEvent[3],tEvent[4])
					if tEvent[3] then
						sFilter = resume("mouse_click", 1, table.unpack(tEvent, 3, tEvent.n))
						if coroutine.status(co) ~= "dead" and (sFilter == nil or sFilter == "mouse_up") then
							sFilter = resume("mouse_up", 1, table.unpack(tEvent, 3, tEvent.n))
						end
					end
				end
			end
		end
	end )	
	
	term.redirect(parent)
	if not ok then
		printError( param )
	end
end

mirrorToMonitors(fMain,{sName},sProgram)