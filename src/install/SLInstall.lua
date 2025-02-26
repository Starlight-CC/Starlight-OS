--[[
Made for use in StarlightOS
filed under GNU General Public License.
    Copyright (C) 2025  StarlightOS

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

    contacts-
      <https://raw.githubusercontent.com/ASTRONAND/Starlight-OS/refs/heads/main/legal/contacts.md>
]]
term.setPaletteColor(colors.red,0xff0000)
term.setPaletteColor(colors.green,0x00ff00)
term.setPaletteColor(colors.blue,0x0000ff)
local pullEvent = os.pullEvent


local pgk_env = setmetatable({}, { __index = _ENV })
pgk_env.require = dofile("rom/modules/main/cc/require.lua").make(pgk_env, "rom/modules/main")
local require = pgk_env.require
_G.require = require
local VER = "src"
local Copyright = http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/legal/TOSPrint.txt")
local API = "https://api.github.com/repos/Starlight-CC/Starlight-OS/contents/"
local json = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/"..VER.."/install/json.la").readAll())()
local PrimeUI = load(http.get("https://raw.githubusercontent.com/Starlight-CC/Starlight-OS/refs/heads/main/"..VER.."/install/PrimeUI.la").readAll())()

local expect = require("cc.expect")
local expect, field = expect.expect, expect.field
local wrap = require("cc.strings").wrap

function err(s)
    term.blit("[ ERR ] ","77eee777","bbbbbbbb")
    print(s)
end

function info(s)
    term.blit("[ INFO ] ","771111777","bbbbbbbbb")
    print(s)
end
function ok(s)
    term.blit("[ OK ] ","7755777","bbbbbbb")
    print(s)
end
function getFolder(a,dir)
    local con = json.decode(http.get(a..dir).readAll())
    local mess = con["message"]
    if con["message"] ~= nil then
        err("API: "..mess)
    else
        for i,v in ipairs(con) do
            if v["type"] == "file" then
                info("LNK: "..API..string.sub(v["path"],#VER+7))
                local file = http.get(v["download_url"])
                local fh = fs.open(string.sub(v["path"],#VER+7), "w")
                info("DOWNLOAD: "..string.sub(v["path"],#VER+7))
                fh.write(file.readAll())
                fh.close()
                ok(string.sub(v["path"],#VER+7))
            elseif v["type"] == "dir" then
                getFolder(API,v["path"])
            else
                error("Install ERROR",0)
            end
        end
    end
end
local function deleteFiles(directory, exceptions)
    for _, entry in ipairs(fs.list(directory)) do
      local fullPath = fs.combine(directory, entry)
      if fs.isDir(fullPath) then
        if not exceptions[entry] then
          deleteFiles(fullPath, exceptions)
          fs.delete(fullPath) -- Delete the folder after deleting its contents
          print("Deleted "..fullPath)
        end
      elseif not exceptions[entry] then
        fs.delete(fullPath) -- Delete the file
        print("Deleted "..fullPath)
      end
    end
  end
  
  local exceptions = {
    ["rom"] = true,
    ["sbin/SLInstall.lua"] = true,
    ["sbin"] = true
  }
end
term.setTextColor(colors.white)
print("Connecting to "..API)
sleep(1.5)
term.setBackgroundColor(colors.blue)

PrimeUI.clear()
local x,y = term.getSize()
PrimeUI.borderBox(term.current(),2,y-2,x-2,2, colors.white, colors.blue)
PrimeUI.label(term.current(),2,y-2,"Do you accept?"..string.rep(" ",x-16), colors.white, colors.blue)
PrimeUI.label(term.current(),2,y-1,"Yes = Y | No = N"..string.rep(" ",x-18), colors.white, colors.blue)
local scroller = PrimeUI.scrollBox(term.current(), 1, 1, x, y-4, 9000, true, true, colors.white, colors.blue)
PrimeUI.drawText(scroller, Copyright.readAll(), true, colors.white, colors.blue)
PrimeUI.keyAction(keys.y, "done")
PrimeUI.keyAction(keys.n, "Terminate")
local _,ac = PrimeUI.run()
if ac == "Terminate" then
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    os.pullEvent = pullEvent
    error("Install terminated",0)
end

term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.white)
print("This will delete EVERYTHING on / are you sure you want to install")
print("(Y/N)")
while true do
    local _,k,_ = os.pullEvent("key")
    if k == keys.y then
        break
    elseif k == keys.n then
        term.setBackgroundColor(colors.blue)
        term.clear()
        term.setCursorPos(1,1)
        os.pullEvent = pullEvent
        error("Install terminated",0)
    else
    end
end
term.setTextColor(colors.purple)
print("cleaning drive")
deleteFiles("/",exceptions)
term.setTextColor(colors.white)
print("Installing")
getFolder(API,VER.."/root/")
term.setTextColor(colors.gray)
shell.run("tmp/shellSet.lua")
print("Rebooting ...")
sleep(1)
term.setTextColor(colors.green)
print("SL.reboot service started")
shell.run("sys/serv/reboot.lua")