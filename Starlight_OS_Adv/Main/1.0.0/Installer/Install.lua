term.clear()
term.setCursorPos(1,1)
term.write("Welcome to ")
term.setTextColor(colors.blue)
term.write("Starlight OS")
term.setTextColor(colors.white)
term.write("!")
term.setCursorPos(1,2)
sleep(1.5)
print("formating FS")
sleep(.5)
print("SFS Formated")

local FS = http.get("https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/Starlight_OS_Adv/Main/1.0.0/Installer/FS.json")
local FS = FS.readAll()

root = FS[1]
l1 = FS[2]

for i,v in ipairs(l1) do
    FS.makeDir(v)
    term.write("[ ")
    term.setTextColor(colors.green)
    term.write("OK")
    term.setTextColor(colors.white)
    term.write(" ] "..v)
    term.setCursorPos(1,2)
end