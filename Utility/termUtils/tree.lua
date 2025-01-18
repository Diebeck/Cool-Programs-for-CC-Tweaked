local args = {...}
local dir = args[1]
local depth = tonumber(args[2])
if dir == nil then
    dir = shell.dir()
end
if depth ~= nil and type(tonumber(depth)) ~= "number" then
    error("2nd argument must be a number")
end
if depth == nil then depth = 99999 end

print("")
if dir == "" then
    print("/")
else
    print(dir)
end

local level = 0
local offset = 0

function displayDirectory(workDir)
    local files = fs.list(workDir)
    -- Sort the table so directories come first
    table.sort(files, function(a, b)
        local isADir = fs.isDir(fs.combine(workDir, a))
        local isBDir = fs.isDir(fs.combine(workDir, b))

        -- If one is a directory and the other isn't, directories go first
        if isBDir and not isADir then
            return true
        elseif not isBDir and isADir then
            return false
        else
            -- Otherwise, sort alphabetically
            return a < b
        end
    end)

    for i=1, #files do
        local toprint = " "

        for i=1, level do
            toprint = toprint.."  "
        end

        if fs.isDir(workDir.."/"..files[i]) then
            toprint = toprint.." \16 "..files[i]
        else
            toprint = toprint.." \\ "..files[i]
        end

        term.setTextColor(colors.white)

        local _, height = term.getSize()
        if offset+2 >= height then
            term.setCursorPos(1,height)
            term.write("Press any key to continue")
            os.pullEvent("key")
            term.setCursorPos(1,height)
            term.write("                         ")
            term.setCursorPos(1,height)
        end

        if fs.isDir(workDir.."/"..files[i]) then
            term.setTextColor(colors.green)
        end

        print(toprint)
        offset = offset + 1

        if fs.isDir(workDir.."/"..files[i]) and level+2 <= depth then
            level = level + 1
            displayDirectory(workDir.."/"..files[i])
            level = level - 1
        end
    end
end

displayDirectory(dir)