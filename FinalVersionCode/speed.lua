MOTORS = {}

local A1 = 4;
local A2 = 7;
local PWMA = 2;
local B1 = 3;
local B2 = 0;
local PWMB = 6;

function setup()
    gpio.mode(A1, gpio.OUTPUT);
    gpio.mode(A2, gpio.OUTPUT);
    gpio.mode(B1, gpio.OUTPUT);
    gpio.mode(B2, gpio.OUTPUT);
    pwm.setup(PWMA, 100, 0);
    pwm.setup(PWMB, 100, 0);
end

function adjustPower(p)
    if (p < 50) then
        return 0
    else
        return math.min(500 + p * 5 / 10, 1023)
    end
end

function setDuty(speed, in1, in2, pwmPin)
    if (speed >= 0) then
        gpio.write(in1, 0);
        gpio.write(in2, 1);
        pwm.setduty(pwmPin, adjustPower(speed));
    else
        gpio.write(in1, 1);
        gpio.write(in2, 0);
        pwm.setduty(pwmPin, adjustPower(-speed));
    end
end

function MOTORS.setPower(left, right)
    setDuty(right, A1, A2, PWMA);
    setDuty(left, B1, B2, PWMB);
end

setup();
