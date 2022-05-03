-- control.lua v5
-- Author: Astru43
-- Date: 03/05/2022

local reactor = peripheral.find("BiggerReactors_Reactor")
local monitor = peripheral.find("monitor")
if (reactor == nil or monitor == nil) then 
    error "Can't find reactor or dispaly."
 end

local reactor_battery = reactor.battery()
local battery_capacity = reactor_battery.capacity()

peripheral.call("left", "setTextScale", 0.5)

function main()
    while true do
        stored = reactor_battery.stored()
        if battery_capacity * 0.9998 < stored then
            setState(false)
        elseif battery_capacity * 0.75 > stored then
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
    monitor.write("control.lua v5")
    newLine()
end

function info(stored_electricity)
    local fuel = reactor.fuelTank()
    local fullness = stored_electricity / battery_capacity * 100
    monitor.write(stored_electricity .. "/" .. battery_capacity .. " : ")
    monitor.write(tonumber(string.format("%.2f", fullness)) .. "%")
    newLine()

    local fuel_percent = tonumber(string.format("%.2f", fuel.fuel() / fuel.capacity() * 100))
    monitor.write(fuel.fuel() .. "/" .. fuel.capacity() .. " : " .. fuel_percent)
    newLine()
    monitor.write("Waste: " .. fuel.waste())
    newLine()
    
    monitor.write(reactor_battery.producedLastTick() .. "FE")

end

local line = 1

function newLine()
    line = line + 1
    monitor.setCursorPos(1, line)
end

function clear()
    monitor.clear()
    line = 1
    monitor.setCursorPos(1, 1)
end

main()
