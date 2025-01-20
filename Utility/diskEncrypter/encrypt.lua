if fs.exists("password.txt") == false then
    print("Password is not set!")
    print("Please enter a new password:")
    local file = fs.open("password.txt","w")
    file.write(read())
    file.close()
    return
end

local passFile = fs.open("password.txt","r")

print("Please wait...")
local response = http.get("https://gist.githubusercontent.com/afonya2/489c3306a7d85f8f9512df321d904dbb/raw/AES.lua")
local AES = load(response.readAll())()

-- Gets the contents of a file
function getFile(path)
    local file = fs.open(path, "r")
    local contents = file.readAll()
    file.close()
    return contents
end

local noDelete = {}

-- Converts a directory into a table
function storeFileSystem(workDir,dirTable)
    local files = fs.list(workDir)
    for i=1, #files do
        local path = fs.combine(workDir, files[i])
        if path ~= "rom" and path ~= "encrypt.lua" and path ~= "startup.lua" and path ~= "fileSystem.bin" then
            --print(path)
            if fs.isDir(path) then
                dirTable[files[i]] = {}
                storeFileSystem(path, dirTable[files[i]])
            else
                dirTable[files[i]] = getFile(path)
            end
            fs.delete(path)
        end
    end
end

-- Sets "fileSystem" to the structure of the drive
local fileSystem = {}
storeFileSystem("/", fileSystem)

-- Encrypts the fileSystem into binary
local password = passFile.readAll()
local key = AES.StringToKey(password, 1024)
passFile.close()
local encryptedFileSystem = AES.Encrypt(AES.StringToTable("Hello!\n"..textutils.serialise(fileSystem)),key)

-- Writes the binary to "fileSystem.bin"
local file = fs.open("fileSystem.bin","w")
file.write(AES.TableToString(encryptedFileSystem))
file.close()
print("")
print("Generated fileSystem.bin")
print("Password: "..password)
print("Goodbye!")
sleep(2)
os.shutdown()