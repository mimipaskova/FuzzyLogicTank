FUZZY = {}

local alfaSum = 0;
local rules = {
    vshort = 'negative',
    short = 'low',
    medium = 'medium',
    large = 'high'
}

FUZZY.distance = {
    vshort = {0, 50, 100},
    short = {50, 150, 250},
    medium = {150, 300, 450},
    large = {400, 500, 500}
};

FUZZY.speed = {
    negative = {-2000, -1000, 0},
    low = {-400, 0, 400},
    medium = {300,500,700},
    high = {500, 1000,1500}
};

-- print(distance.vshort[4])
-- print(speed.medium[2])
-- print(alfaSum)
-- print(rules.large)


-- from https://gist.github.com/hashmal/874792
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
end

-- reduce function
function reduce(list, fn)
    local acc
    for k, v in ipairs(list) do
        if 1 == k then
            acc = v
        else
            acc = fn(acc, v)
        end 
    end 
    return acc 
end

function calculateM(x, triangleVariable)
  local m = 0
  if x < triangleVariable[1] then
    m = 0
  elseif (triangleVariable[1]  <= x and x <= triangleVariable[2]) then
     m = (x-triangleVariable[1])/(triangleVariable[2] - triangleVariable[1])
  elseif (triangleVariable[2]  < x and x <= triangleVariable[3]) then
    m = (triangleVariable[3] - x)/(triangleVariable[3] - triangleVariable[2]);
  else
    m = 0
  end
  return m
end

--print(calculateM(200, distance.medium))

function fuzzification(givenDistance)
  local ms = {}
  for key, value in pairs(FUZZY.distance) do
    ms[key] = calculateM(givenDistance, FUZZY.distance[key])
  end
  return ms
end

--tprint(fuzzification(200, distance))

function calculateAreaAlfaCut (alfaI, triangleVariable)
  local sum = 0
  if(alfaI > 0) then
    for i = triangleVariable[1], triangleVariable[3], 100 do
      min = math.min(alfaI, calculateM(i, triangleVariable))
      alfaSum = alfaSum + min
      sum = sum + i * min
    end   
  end
  return sum
end

-- print(calculateAreaAlfaCut(0.5, speed.low))

function calculateZi(givenDistance)
  local res = {}
  for key, value in pairs(fuzzification(givenDistance)) do
--    print(value, speed[rules[key]])
    x = calculateAreaAlfaCut(value, FUZZY.speed[rules[key]])
    table.insert(res , x)
  end
  return res
end

--tprint(calculateZi(200, distance))

function FUZZY.calculateZ(givenDistance)
    givenDistance = math.min(500, givenDistance)
    alfaSum = 0
    local x = reduce(
        calculateZi(givenDistance, FUZZY.distance) ,
        function (a, b)
            return a + b
        end)
    if alfaSum > 0 then
        return x/alfaSum
    else
        return x
    end
end

--print(FUZZY.calculateZ(200))
