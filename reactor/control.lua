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

monitor.setTextScale(0.5)

function main()
    while true do
        local stored = reactor_battery.stored()
        if battery_capacity * 0.9998 < stored then
            reactor.setActive(false)
        elseif battery_capacity * 0.75 > stored then
            reactor.setActive(true)
        end

        if reactor.active() then
            if reactor.fuelTemperature() < 1900 then
                local level = reactor.getControlRod(0).level()
                level = level - 1
                reactor.setAllControlRodLevels(level)
            elseif reactor.fuelTemperature() > 1980 then
                local level = reactor.getControlRod(0).level()
                level = level + 1
                reactor.setAllControlRodLevels(level)
            end
        end

        clear()
        title()
        info(stored)

        sleep(1)
    end
end

function title()
    monitor.write("control.lua v5")
    newLine()
end

function info(stored_electricity)
    local fuel = reactor.fuelTank()
    local battery_percent = stored_electricity / battery_capacity * 100
    local fuel_percent = tonumber(string.format("%.2f", fuel.fuel() / fuel.capacity() * 100))

    if reactor.active() then
        monitor.write("State: Online")
    else
        monitor.write("State: Offline")
    end
    newLine()

    monitor.write("Battery: " .. capacity_format(stored_electricity, battery_capacity) .. " : ")
    monitor.write(tonumber(string.format("%.2f", battery_percent)) .. "%")
    newLine()

    monitor.write("Fuel: " .. capacity_format(fuel.fuel(), fuel.capacity()) .. " : " .. fuel_percent .. "%")
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

function capacity_format(sored, capacity)
    local setps = {
        {1, ""},
        {1e3, "k"},
        {1e6, "M"},
        {1e9, "G"},
        {1e12, "T"},
    }

    for _, v in ipairs(setps) do
        if v[1] <= capacity+1 then
            steps.use = _
        end
    end

    local stored_res = string.format("%.2f", stored / steps[steps.use][1])
    if tonumber(stored_res) >= 1e3 and steps.use < table.getn(steps) then
        steps.use = steps.use + 1
        stored_res = string.format("%.1f", tonumber(stored_res) / 1e3)
    end

    
    local capacity_res = string.format("%.2f", capacity / steps[steps.use][1])
    if tonumber(capacity_res) >= 1e3 and steps.use < table.getn(steps) then
        steps.use = steps.use + 1
        capacity_res = string.format("%.1f", tonumber(capacity_res) / 1e3)
    end

    stored_res = string.sub(stored_res, 0, string.sub(stored_res, -1) == "0" and -3 or -1)
    capacity_res = string.sub(capacity_res, 0, string.sub(capacity_res, -1) == "0" and -3 or -1)

    return stored_res .. "/" .. capacity_res .. steps[steps.use][2]
end

main()
