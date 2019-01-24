DISTANCE = {}

DISTANCE.config = { {t = 5, e = 1}, {t = 8, e = 1}}

local function get(t, e)
    gpio.mode(t, gpio.OUTPUT)
    gpio.mode(e, gpio.INPUT)
    gpio.write(t, gpio.HIGH)
    tmr.delay(100)
    gpio.write(t, gpio.LOW)
    while (gpio.read(e) == 0) do
    end
    local startTime = tmr.now()
    while (gpio.read(e) == 1) do
    end
    local endTime = tmr.now()
    if (endTime >= startTime) then
        return (endTime - startTime) / 58
    end
    return (endTime + 0x3fffffff - startTime) / 58
end

function DISTANCE.get()
    local result = {}
    for i, sensor in pairs(DISTANCE.config) do
        result[i] = get(sensor.t, sensor.e)
    end
    return result
end
