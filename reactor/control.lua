-- control.lua v4
-- Author: Astru43
-- Date: 03/05/2022
local reactor = peripheral.find("BiggerReactors_Reactor")
local monitor = peripheral.find("monitor")
local reactor_battery = reactor.battery()
local capacity = reactor_battery.capacity()

peripheral.call("left", "setTextScale", 0.5)

function main()
    while true do
        stored = reactor_battery.stored()
        if capacity * 0.9998 < stored then
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
    local fuel = reactor.fuelTank()
    local fullness = stored / capacity * 100
    monitor.setCursorPos(1, 2)
    monitor.write(stored .. "/" .. capacity .. " : ")
    monitor.write(tonumber(string.format("%.3f", fullness)) .. "%")

    monitor.setCursorPos(1, 3)
    local fuel_percent = tonumber(string.format("%.2f", fuel.fuel() / fuel.capacity() * 100))
    monitor.write(fuel.fuel() .. "/" .. fuel.capacity() .. " : " .. fuel_percent)
    monitor.write("Waste: " .. fuel.waste())
end

function clear()
    monitor.clear()
end

main()
