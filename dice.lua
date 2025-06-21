local dice = {}

-- roll numDice amount of random numbers in given bounds, return the lowest rolled number
function dice.countLowest(numDice, lowerBound, upperBound)
  local lowestRoll = upperBound
  for i = 0,numDice do
    local currentRoll = math.random(lowerBound, upperBound)
    if lowestRoll > currentRoll then
      lowestRoll = currentRoll
    end
  end
  return lowestRoll
end

-- generate a random normal within a log-normal dist
function dice.logRand(stdDev, mean)
  -- very rough approximate of a random Gaussian value
  local std_normal = (math.random()*2-1 + math.random()*2-1) / 2
  --print(std_normal) --debug
  local normal_value = stdDev * std_normal + mean
  return math.exp(normal_value)
end

-- rounds numbers
function dice.round(value, decimals)
  value = value * decimals
  value = math.floor(value)
  value = value/decimals
  return value
end

-- calculate gravity of a given body from radius and mass
function dice.gravity(radius, mass)
  local newton_constant = 6.6743e-11
  local earth_mass = 5.972168e24
  local earth_radius = 6371
  radius = radius * earth_radius
  mass = mass * earth_mass
  mass = ((newton_constant*(mass/(radius^2)))/1000000)*0.107
  return mass
end

-- Converts HSL to RGB. (input and output range: 0 - 1)
-- copypasted from love2d docs
function dice.HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h*6, s, l
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return r+m, g+m, b+m, a
end

function dice.getDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
    --Both of these work
    local a = horizontal_distance * horizontal_distance
    local b = vertical_distance ^2

    local c = a + b
    local distance = math.sqrt(c)
    return distance
end

return dice