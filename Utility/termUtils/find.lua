local args = {...}
local name = args[1]
local path = args[2]

if name == nil then
    print("Usage: find <file> [path]")
    return
end
if path == nil then
    path = shell.dir()
end

local foundFiles = {}

function searchDir(dir)
    local toAdd = fs.find(dir.."/"..name)
    for i=1, #toAdd do
        foundFiles[#foundFiles+1] = toAdd[i]
    end
    local list = fs.list(dir)
    for i=1, #list do
        if fs.isDir(dir.."/"..list[i]) then
            searchDir(dir.."/"..list[i])
        end
    end
end

searchDir(path)

for i=1, #foundFiles do
    print(foundFiles[i])
end