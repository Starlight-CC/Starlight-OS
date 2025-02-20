local tArgs = { ... }
if #tArgs < 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <path>")
    print("shortcuts:")
    print("    ~ = user's home dir")
    print("    .. = previous dir")
    print("    / = root dir")
    return
end

local sNewDir = shell.resolve(tArgs[1])
if string.sub(tArgs[1],1,1) == "~" then
    if os.username() == "root" then
        shell.setDir("/root/"..string.sub(tArgs[1],2))
    else
        shell.setDir("/home/"..os.username()..string.sub(tArgs[1],2))
    end
elseif fs.isDir(sNewDir) then
    shell.setDir(sNewDir)
else
    term.setTextColor(colors.red)
    print("Not a directory")
    term.setTextColor(colors.white)
    return
end
