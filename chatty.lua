os.pullEvent = os.pullEventRaw
local c = peripheral.find("chatBox")
local x, y = term.getSize()
local name, br = ...
local txtclr
term.clear()
term.setCursorPos(1,19)

if name == nil then
    name = "AI"
    c.sendMessage("AI has booted up.","AI")
end

if br == nil then
    br = "[]"
end

function listen()
    while true do
        local event, user, msg = os.pullEvent("chat")
        if event == "chat" then
            term.setCursorPos(1,18)
            term.scroll(1)
            term.clearLine()
            print("<"..user.."> "..msg)
        end
    end
end

function say()
    while true do
        local msg2 = read()
        if name == "AI" then
            txtclr = "dark_green"
        else
            txtclr = "white"
        end
        local msgfinal = {{
            text = msg2,
            color = txtclr
        }}
        c.sendFormattedMessage(textutils.serialiseJSON(msgfinal),name,br)
    end
end

function terminate()
    os.pullEventRaw("terminate")
    if name == "AI" then
        c.sendMessage("AI has shut down.","AI")
    end
    print("Ended!")
    error()
end

parallel.waitForAll(listen, say, terminate)
