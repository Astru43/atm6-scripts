-- control.lua v3
-- Author: Astru43
-- Date: 03/05/2022

reactor_battery = peripheral.call("back", "battery")
capacity = reactor_battery.capacity()

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
    peripheral.call("back", "setActive", state)
end

function title()
    peripheral.call("left", "setCursorPos", 1, 1)
    peripheral.call("left", "write", "control.lua v3")
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
