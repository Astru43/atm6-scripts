-- control.lua v7
-- Author: Astru43
-- Date: 03/05/2022
local turbine = peripheral.find("BiggerReactors_Turbine") or error("No turbine found")
local reactor = peripheral.find("BiggerReactors_Reactor") or errpr("No reactor found")
local monitor = peripheral.find("monitor") or error("No monitor found")

local battery = turbine.battery()
local battery_capacity = battery.capacity()

-- monitor.setTextScale(0.5)
monitor.setTextScale(1)

function main()
    while true do
        local stored = battery.stored()
        if battery_capacity * 0.9998 < stored then
            setActive(false)
        elseif battery_capacity * 0.5 > stored then
            setActive(true)
        end

        if turbine.active() and turbine.rotor().RPM() > 1300 then
            setCoil(true)
        elseif not turbine.active() then
            setCoil(false)
        end

        -- if reactor.active() then
        --     if reactor.fuelTemperature() < 1800 then
        --         local level = reactor.getControlRod(0).level()
        --         level = level - 1
        --         reactor.setAllControlRodLevels(level)
        --     elseif reactor.fuelTemperature() > 1910 then
        --         local level = reactor.getControlRod(0).level()
        --         level = level + 1
        --         reactor.setAllControlRodLevels(level)
        --     end
        -- end

        clear()
        title()
        info(stored)

        sleep(1)
    end
end

function setActive(state)
    reactor.setActive(state)
    turbine.setActive(state)
end

function setCoil(engaged)
    turbine.setCoilEngaged(engaged)
end

function title()
    monitor.write("control.lua v7")
    newLine()
end

function info(stored_electricity)
    local fuel = reactor.fuelTank()
    local battery_percent = percentFormat(stored_electricity / battery_capacity * 100)
    local fuel_percent = percentFormat(fuel.fuel() / fuel.capacity() * 100)

    if reactor.active() then
        monitor.write("State: Online")
    else
        monitor.write("State: Offline")
    end
    newLine()

    monitor.write("Battery: " .. capacityFormat(stored_electricity, battery_capacity) .. " : " .. battery_percent ..
                      "%")
    newLine()

    monitor.write("Fuel/Casing tmp: " .. truncateOneDecimal(reactor.fuelTemperature()) .. " / " ..
                      truncateOneDecimal(reactor.casingTemperature()))
    newLine()

    monitor.write("Fuel: " .. capacityFormat(fuel.fuel(), fuel.capacity()) .. " : " .. fuel_percent .. "%")
    newLine()
    monitor.write("Waste: " .. fuel.waste())
    newLine()

    monitor.write("Rotor speed: " .. truncateOneDecimal(turbine.rotor().RPM()))
    newLine()

    monitor.write(format(battery.producedLastTick()) .. "FE")

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

function truncateOneDecimal(value)
    return tonumber(string.format("%0.1f", value))
end

function percentFormat(value)
    return tonumber(string.format("%.2f", value))
end

function capacityFormat(stored, capacity)
    local steps = {{1, ""}, {1e3, "k"}, {1e6, "M"}, {1e9, "G"}, {1e12, "T"}}

    for _, v in ipairs(steps) do
        if v[1] <= capacity + 1 then
            steps.use_capacity = _
        end
        if v[1] <= stored + 1 then
            steps.use_stored = _
        end
    end

    local stored_res = string.format("%.2f", stored / steps[steps.use_stored][1])

    -- Check if value is unde 1000 and if step.use is not max
    if tonumber(stored_res) >= 1e3 and steps.use_stored < table.getn(steps) then
        steps.use_stored = steps.use_stored + 1
        stored_res = string.format("%.2f", tonumber(stored_res) / 1e3)
    end

    local capacity_res = string.format("%.2f", capacity / steps[steps.use_capacity][1])

    -- Check if value is unde 1000 and if step.use is not max
    if tonumber(capacity_res) >= 1e3 and steps.use_capacity < table.getn(steps) then
        steps.use_capacity = steps.use_capacity + 1
        capacity_res = string.format("%.2f", tonumber(capacity_res) / 1e3)
    end

    stored_res = string.sub(stored_res, 0, string.sub(stored_res, -2) == "00" and -4 or -1)
    capacity_res = string.sub(capacity_res, 0, string.sub(capacity_res, -2) == "00" and -4 or -1)

    return stored_res .. steps[steps.use_stored][2] .. "/" .. capacity_res .. steps[steps.use_capacity][2]
end

function format(value)
    local steps = {{1, ""}, {1e3, "k"}, {1e6, "M"}, {1e9, "G"}, {1e12, "T"}}

    for _, v in ipairs(steps) do
        if v[1] <= value + 1 then
            steps.use = _
        end
    end

    local res = string.format("%.2f", value / steps[steps.use][1])

    -- Check if value is unde 1000 and if step.use is not max
    if tonumber(res) >= 1e3 and steps.use < table.getn(steps) then
        steps.use = steps.use + 1
        res = string.format("%.2f", tonumber(res) / 1e3)
    end

    res = string.sub(res, 0, string.sub(res, -2) == "00" and -4 or -1)

    return res .. steps[steps.use][2]
end

main()
