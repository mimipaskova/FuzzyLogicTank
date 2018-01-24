rules = {
    vshort = 'negative',
    short = 'low',
    medium = 'medium',
    large = 'high'
}

distance = {
    vshort = {0, 50, 100},
    short = {50, 150, 250},
    medium = {150, 300, 450},
    large = {400, 500, 500}
};

speed = {
    negative = {-2000, -1000, 0},
    low = {-400, 0, 400},
    medium = {300,500,700},
    high = {500, 1000,1500}
};

alfaSum = 0;

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
table.reduce = function (list, fn) 
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
  m = 0
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

function fuzzification(givenDistance, distanceObj)
  ms = {}
  for key, value in pairs(distanceObj) do
    ms[key] = calculateM(givenDistance, distance[key])
  end
  return ms
end

--tprint(fuzzification(200, distance))

function calculateAreaAlfaCut (alfaI, triangleVariable)
  sum = 0
  if(alfaI > 0) then
    for i=triangleVariable[1], triangleVariable[3], 100 do
      min = math.min(alfaI, calculateM(i, triangleVariable))
      alfaSum = alfaSum + min
      sum = sum + i * min
    end   
  end
  return sum
end

-- print(calculateAreaAlfaCut(0.5, speed.low))

function calculateZi(givenDistance, distanceObj)
  res = {}
  for key, value in pairs(fuzzification(givenDistance, distanceObj)) do
--    print(value, speed[rules[key]])
    x = calculateAreaAlfaCut(value, speed[rules[key]])
    table.insert(res , x)
  end
  return res
end

--tprint(calculateZi(200, distance))

function calculateZ(givenDistance, distanceObj)
    alfaSum = 0
    return table.reduce(
    calculateZi(givenDistance, distanceObj) ,
    function (a, b)
        return a + b
    end
  )/alfaSum
end

-- print("0", calculateZ(0, distance)) --nan
-- print("100", calculateZ(100, distance)) --0
-- print("150", calculateZ(150, distance)) --0
-- print("200", calculateZ(200, distance)) --125
-- print("300", calculateZ(300, distance)) --500
-- print("350", calculateZ(350, distance)) --500
-- print("400", calculateZ(400, distance)) --500
-- print("450", calculateZ(450, distance)) --1000
-- print("500", calculateZ(500, distance)) --1000
