-- control.lua v3
-- Author: Astru43
-- Date: 03/05/2022

local reactor = peripheral.find("BiggerReactors_Reactor")
local monitor = peripheral.find("monitor")[0]
local reactor_battery = reactor.battery()
local capacity = reactor_battery.capacity()

peripheral.call("left", "setTextScale", 0.5)

function main()
    while true do
        stored = reactor_battery.stored()
        if capacity * 0 * 98 < stored then
            setState(false)
        elseif capacity * 0.75 > stored then
            setState(true)
        end

        clear()
        title()
        info(stored)

        sleep(1)
    end
end

function setState(state)
    reactor.setActive(state)
end

function title()
    monitor.setCursorPos(1, 1)
    monitor.write("control.lua v4")
end

function info(stored)
    peripheral.call("left", "setCursorPos", 1, 2)
    peripheral.call("left", "write", stored)
    peripheral.call("left", "write", "/")
    peripheral.call("left", "write", capacity)
    peripheral.call("left", "write", " : ")
    fullness = stored / capacity * 100
    peripheral.call("left", "write", tonumber(string.format("%.3f", fullness)))
    peripheral.call("left", "write", "%")
end

function clear()
    peripheral.call("left", "clear")
end

main()
