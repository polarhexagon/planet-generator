Planet = Object:extend()

function Planet:new()
  -- Blank values to be filled in later
  self.temp = 0
  self.radius = 0
  self.mass = 0
  self.gravity = 0
  self.moons = 0
  self.rings = 0
end

-- roll numDice amount of random numbers in given bounds, return the lowest rolled number
function countLowest(numDice, lowerBound, upperBound)
  local lowestRoll = lowerBound
  for i = 1,numDice do
    local currentRoll = math.random(lowerBound, upperBound)
    if lowestRoll > currentRoll then
      lowestRoll = currentRoll
    end
  end
  return lowestRoll
end

function Planet:generate()
  local minTemp = -275*10
  local maxTemp = 500*10
  -- Rolls twice and averages results
  self.temp = math.random(min_temp, max_temp)+math.random(min_temp, max_temp)/20
  
  -- Measured in Earth masses.
  local minMass = 0.0041
  local maxMass = 4134
  
end

function Planet:update(dt)
  
end

function Planet:draw()
  
end