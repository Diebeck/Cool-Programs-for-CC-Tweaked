local args = {...}
local pick = args[1]

if pick == nil then
    print("Options:")
    print("- default")
    print("- inverted")
    print("- rgb")
    print("- modern")
    print("- retro")
    print("- hacker")
    print("- random")
    return
end

-- Start of presets
local presets = {}
presets["default"] = {
    "colors.white, 0xf0f0f0",
    "colors.orange, 0xf2b233",
    "colors.magenta, 0xe57fd8",
    "colors.lightBlue, 0x99b2f2",
    "colors.yellow, 0xdede6c",
    "colors.lime, 0x7fcc19",
    "colors.pink, 0xf2b2cc",
    "colors.gray, 0x4c4c4c",
    "colors.lightGray, 0x999999",
    "colors.cyan, 0x4c99b2",
    "colors.purple, 0xb266e5",
    "colors.blue, 0x3366cc",
    "colors.brown, 0x7f664c",
    "colors.green, 0x57a64e",
    "colors.red, 0xcc4c4c",
    "colors.black, 0x111111"
}
presets["inverted"] = {
    "colors.white, 0x111111",
    "colors.black, 0xf0f0f0",
    "colors.gray, 0x999999",
    "colors.lightGray, 0x4c4c4c",
    "colors.orange, 0xf2b233",
    "colors.magenta, 0xe57fd8",
    "colors.lightBlue, 0x99b2f2",
    "colors.yellow, 0xdede6c",
    "colors.lime, 0x7fcc19",
    "colors.pink, 0xf2b2cc",
    "colors.cyan, 0x4c99b2",
    "colors.purple, 0xb266e5",
    "colors.blue, 0x3366cc",
    "colors.brown, 0x7f664c",
    "colors.green, 0x57a64e",
    "colors.red, 0xcc4c4c"
}
presets["rgb"] = {
    "colors.white, 0xffffff",
    "colors.orange, 0xff7f00",
    "colors.magenta, 0xbe00ff",
    "colors.lightBlue, 0x7f7fff",
    "colors.yellow, 0xffff00",
    "colors.lime, 0x00ff00",
    "colors.pink, 0xff00ff",
    "colors.gray, 0x555555",
    "colors.lightGray, 0xbebebe",
    "colors.cyan, 0x007fff",
    "colors.purple, 0x5500ff",
    "colors.blue, 0x0000ff",
    "colors.brown, 0x7f4000",
    "colors.green, 0x007f00",
    "colors.red, 0xff0000",
    "colors.black, 0x000000"
}
presets["retro"] = {
    "colors.white, 0xf4f4f4",
    "colors.orange, 0xef7d57",
    "colors.magenta, 0x566c86",
    "colors.lightBlue, 0x41a6f6",
    "colors.yellow, 0xffcd75",
    "colors.lime, 0xa7f070",
    "colors.pink, 0x94b0c2",
    "colors.gray, 0x505050",
    "colors.lightGray, 0xb0b0b0",
    "colors.cyan, 0x3E82E0",
    "colors.purple, 0x333c57",
    "colors.blue, 0x3b5dc9",
    "colors.brown, 0x7f664c",
    "colors.green, 0x38b764",
    "colors.red, 0xb13e53",
    "colors.black, 0x151515"
}
presets["hacker"] = {
    "colors.white, 0x00FF00",
    "colors.orange, 0x00FF00",
    "colors.magenta, 0x00EC05",
    "colors.lightBlue, 0x00DA09",
    "colors.yellow, 0x00FF00",
    "colors.lime, 0x00C70E",
    "colors.pink, 0x00B513",
    "colors.gray, 0x006000",
    "colors.lightGray, 0x00B000",
    "colors.cyan, 0x00A217",
    "colors.purple, 0x00901C",
    "colors.blue, 0x003333",
    "colors.brown, 0x007D20",
    "colors.green, 0x006B25",
    "colors.red, 0x00582A",
    "colors.black, 0x001100"
}
presets["random"] = {
    "colors.white, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.orange, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.magenta, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.lightBlue, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.yellow, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.lime, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.pink, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.gray, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.lightGray, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.cyan, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.purple, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.blue, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.brown, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.green, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.red, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))",
    "colors.black, tonumber(\"0x\"..string.format(\"%X\", math.random(0,16777216)))"
}
-- End of presets

if fs.exists("/startup/paletteSetter.lua") then
    fs.delete("/startup/paletteSetter.lua")
end

local file = fs.open("/startup/paletteSetter.lua","w")
for i=1, #presets[pick] do
    file.writeLine("term.setPaletteColor("..presets[pick][i]..")")
end
file.close()

shell.run("/startup/paletteSetter.lua")
term.blit("                ","ffffffffffffffff","087fe145d39b62ac")
print("")

if pick == "default" then
    fs.delete("/startup/paletteSetter.lua")
end