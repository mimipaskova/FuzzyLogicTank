AUTOSPEED = {}

AUTOSPEED.auto = false

function changeSpeed()
    if (AUTOSPEED.auto) then
        local dist = DISTANCE.get()
        local speedLeft = FUZZY.calculateZ(dist[1] * 10)
        local speedRight = FUZZY.calculateZ(dist[2] * 10)
        --print('speed is:', speed, ' distance is: ', DISTANCE.get()*10)
        MOTORS.setPower(speedLeft, speedRight)
    end
end

local function init()
    mytimer = tmr.create()
    mytimer:register(10000, tmr.ALARM_AUTO, changeSpeed)
    mytimer:interval(100)
    mytimer:start()
end

init()
