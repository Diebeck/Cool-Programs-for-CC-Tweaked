--Program to fetch the text currently on the pastebin file "CC Link"

local id = fs.open("/.AIlink/id.txt","r").readLine()
local last = fs.open("/.AIlink/last.txt","r").readLine()

term.clear()
term.setCursorPos(1,1)

print("Searching for AI...")
print("This computer's ID is \""..id.."\"")
print()
print("To change the ID, go to /.AIlink and change id.txt")
print("To manually override AI search, simply terminate the program.")

while true do
  local link = http.get("https://pastebin.com/raw/XDXyGBBW")
  local target = link.readLine()
  local code = link.readLine()
  if id == target then
    if last ~= code then
      print("Found match!")
      local last = fs.open("/.AIlink/last.txt","w")
      last.write(code)
      sleep(0.75)
      print("Establishing connection...")
      sleep(1.5)
      shell.run("cloud.lua",code)
    end
  end
  sleep(30)
end
