-- RUNNING THIS CODE WILL RESET ALL OF THE COMPUTER'S FILES
-- YOU HAVE BEEN WARNED

print("You are about to delete all files on this computer.")
print("Are you sure you want to proceed? (y/n)")
if read() ~= "y" then return end 

local all = fs.list("/")
for i=1, #all do
    pcall(function()
        fs.delete("/"..all[i])
        print("Deleted "..all[i])
    end)
end

print("Goodbye!")
sleep(1)
os.reboot()