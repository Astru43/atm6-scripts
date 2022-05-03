-- git.lua v2
-- Author: Astru43
-- Date: 03/05/2022

local git = "github.com/Astru43/atm6-scripts/raw/main"
local pwd = shell.dir()
 
if arg[1] == "update" then
    address = "https://" .. fs.combine(git, "git.lua")
    local res = http.get(address)
    fs.delete("/git.lua")
    local file = fs.open("/git.lua", "w")
    file.write(res.readAll())
    file.close()
elseif http.checkURL("https://" .. fs.combine(git, arg[1])) then
    address = "https://" .. fs.combine(git, arg[1])
    print(address)
    local res = http.get(address)
    fs.makeDir(fs.combine(pwd, fs.getDir(arg[1])))
    local file = fs.open(fs.combine(pwd, arg[1]), "w")
    file.write(res.readAll())
    file.close()
end