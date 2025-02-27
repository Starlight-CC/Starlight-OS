local w,h = term.getSize()
term.setPaletteColor(colors.red,0xff0000)
term.setPaletteColor(colors.green,0x00ff00)
term.setPaletteColor(colors.blue,0x0000ff)
function printCentered( y,s )
    local x = math.floor((w - string.len(s)) / 2)
    term.setCursorPos(x,y)
    term.clearLine()
    term.write( s )
end
local table = {
    {
        "Install       ",
        "Configure     ",
        "Exit          "
    },
    {
        "Install OS",
        "Configure OS",
        "Exit to shell"
    }
}
local nOption = 1
local it = 1
 
local function drawMenu(t)
    term.clear()
    term.setCursorPos(1,1)
    term.write("STARLIGHT INSTALLER // ")
    term.setCursorPos(1,2)
    term.write(os.getComputerID())
    term.setCursorPos(1,h)
    for i,v in ipairs(t[2]) do
        if nOption == i then
            term.write(v)
        end
    end
end
 
--GUI
term.clear()
local function drawFrontend(t)
    printCentered(math.floor(h/2) - 3, "")
    printCentered(math.floor(h/2) - 2, "STARLIGHT BIOS" )
    printCentered(math.floor(h/2) - 1, "")
    for i,v in ipairs(t[1]) do
        printCentered(math.floor(h/2) + i-1, ((nOption == i) and "[  "..v.."]") or v)
        it = it + 1
    end
    printCentered(math.floor(h/2) + it, "")
end

--Display
drawMenu(table)
drawFrontend(table)

local function Menu(t)
    while true do
        local e,p = os.pullEvent()
        w,h = term.getSize()
        if e == "key" then
            local key = p
            if key == keys.up then
    
                if nOption > 1 then
                    nOption = nOption - 1
                    drawMenu(t)
                    drawFrontend(t)
                end
            elseif key == keys.down then
                if nOption < #t+1 then
                    nOption = nOption + 1
                    drawMenu(t)
                    drawFrontend(t)
                end
            elseif key == keys.enter then
                --when enter pressed
            break
            end
        end
    end
end
term.clear()
 
--Conditions
if nOption  == 1 then
    shell.run("wget run "..)
elseif nOption == 2 then
    
elseif nOption == 3 then
    
elseif nOption == 4 then
else
    os.shutdown()
end