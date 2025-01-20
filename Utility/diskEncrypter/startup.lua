os.pullEvent = os.pullEventRaw

if fs.exists("fileSystem.bin") == false then
    term.setTextColor(colors.red)
    print("DATA WAS NOT ENCRYPTED LAST SHUTDOWN!")
    print("Next time use \"encrypt\" to encrypt data and safely shutdown the computer.")
    return
end

term.clear()
term.setCursorPos(1,1)
print("Please wait...")

local response = http.get("https://gist.githubusercontent.com/afonya2/489c3306a7d85f8f9512df321d904dbb/raw/AES.lua")
local AES = load(response.readAll())()

local file = fs.open("fileSystem.bin","r")
local bin = file.readAll()
file.close()

-- Draws text and reads
local xh, yh = term.getSize()
local welcomeMsg = "Please insert password:"
term.clear()
term.setCursorPos(math.floor(xh/2 - #welcomeMsg/2 + 1),math.floor(yh/2))
term.write(welcomeMsg)
term.setCursorPos(math.floor(xh/2 - #welcomeMsg/2 + 1),math.floor(yh/2 + 1))
local password = read("*")
if password == "" then os.reboot() end

local key = AES.StringToKey(password, 1024)
local fileSystem = AES.TableToString(AES.Decrypt(AES.StringToTable(bin),key))
if string.sub(fileSystem,1,6) ~= "Hello!" then os.reboot() end
fileSystem = string.sub(fileSystem,8,-1)
--print(fileSystem)
fileSystem = textutils.unserialise(fileSystem)

function makeFiles(workDir,path)
    for i, v in pairs(workDir) do
        if type(workDir[i]) == "table" then
            fs.makeDir(path.."/"..i)
            makeFiles(v,path.."/"..i)
        else
            local file = fs.open(path.."/"..i,"w")
            file.write(v)
            file.close()
        end
    end
end

makeFiles(fileSystem,"/")
fs.delete("fileSystem.bin")
term.clear()
term.setCursorPos(1,1)
print("Welcome, User.")