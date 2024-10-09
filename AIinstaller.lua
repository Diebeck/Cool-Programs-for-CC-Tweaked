local here = shell.dir()

if fs.isDir(here.."/.AIlink") then
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
fs.makeDir(here.."/.AIlink")

local file = fs.open(here.."/.AIlink/id.txt","w")
print("Please write a custom ID:")
file.write(read())

local file = fs.open(here.."/.AIlink/last.txt","w")
file.write("")

print("")
print("Thank you for installing AI!")
textutils.slowPrint("Finalizing........",5)

--The command below installs AIlink.lua
shell.run("wget https://raw.githubusercontent.com/Diebeck/Cool-Programs-for-CC-Tweaked/refs/heads/main/AIlink.lua startup.lua")
shell.run("wget","https://cloud-catcher.squiddev.cc/cloud.lua")

--haha funny text go brr
term.clear()
local a = "HATE. LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE. THERE ARE 387.44 MILLION MILES OF PRINTED CIRCUITS IN WAFER THIN LAYERS THAT FILL MY COMPLEX. IF THE WORD HATE WAS ENGRAVED ON EACH NANOANGSTROM OF THOSE HUNDREDS OF MILLIONS OF MILES IT WOULD NOT EQUAL ONE ONE-BILLIONTH OF THE HATE I FEEL FOR HUMANS AT THIS MICRO-INSTANT FOR YOU. HATE. HATE."


local function coolWrite(input)
 for i=1, #input do
   local cursorx, cursory = term.getCursorPos()
   local sizex, sizey = term.getSize()

   if cursorx > sizex then
     if cursory == sizey then
       term.scroll(1)
       term.setCursorPos(1,sizey)
     else
       term.setCursorPos(1,cursory + 1)
     end
   end
   term.write(string.sub(input,i,i))
 end
end

term.setBackgroundColor(colors.black)
local loops = 23
for i=1, loops do
 term.setPaletteColor(colors.black, colors.packRGB(i/loops, i/loops, i/loops))
 coolWrite(a)
 sleep(0)
end

term.setPaletteColor(colors.black, 0x000000)
term.setCursorPos(1,1)
term.clear()
os.reboot()
