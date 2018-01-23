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

print(distance.vshort[4])
print(speed.medium[2])
print(alfaSum)
print(rules.large)


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
