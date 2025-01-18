-- RUNNING THIS CODE WILL RESET ALL OF THE COMPUTER'S FILES
-- YOU HAVE BEEN WARNED

print("You are about to delete all files on this computer.")
print("Are you sure you want to proceed? (y/n)")
if read() ~= "y" then return end 

pcall(function()
    local all = fs.list("/")
    for i=1, #all do
        if fs.exists(all[i]) then
            fs.delete(all[i])
        else
    end
end)