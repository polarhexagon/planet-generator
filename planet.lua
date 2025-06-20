Planet = Object:extend()

local newton_constant = 6.6743e-11

--[[
  Helper functions for random values and crunching numbers.
]]
-- roll numDice amount of random numbers in given bounds, return the lowest rolled number
local function countLowest(numDice, lowerBound, upperBound)
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
local function logRand(stdDev, mean)
  -- very rough approximate of a random Gaussian value
  local std_normal = (math.random()*2-1 + math.random()*2-1) / 2
  --print(std_normal) --debug
  local normal_value = stdDev * std_normal + mean
  return math.exp(normal_value)
end

-- calculate gravity of a given body from radius and mass
local function gravity(radius, mass)
  local earth_mass = 5.972168e24
  local earth_radius = 6371
  radius = radius * earth_radius
  mass = mass * earth_mass
  mass = ((newton_constant*(mass/(radius^2)))/1000000)*0.107
  return mass
end

-- should round numbers, only use this for prints at the end
local function round(value, decimals)
  value = value * decimals
  value = math.floor(value)
  value = value/decimals
  return value
end

--[[
  Functions for planets.
]]

function Planet:new()
  -- Blank values to be filled in later
  self.temp = 0
  self.radius = 0
  self.mass = 0
  self.gravity = 0
  self.moons = 0
end

-- Replace old planet values with new ones. Cool
function Planet:generate()
  
  -- Measured in Celsius.
  local min_temp = -275*10
  local max_temp = 500*10
  -- Rolls three times and averages results
  self.temp = (math.random(min_temp, max_temp)+
               math.random(min_temp, max_temp)+
               math.random(min_temp, max_temp))/30
  
  -- These measurements are all in comparison to Earth.
  -- ie. Earth radii, Earth masses, Earth gravity...
  self.radius = countLowest(2, 3, 50)/10
  -- ideal range 0.0041 - 4134
  -- current range 0.001 - 200, avg 0.1-10
  self.mass = logRand(6, -0.5)
  self.gravity = gravity(self.radius, self.mass)
  
  self.moons = countLowest(3,0,6)
  
end

function Planet:update(dt)
  
end

function Planet:draw()
  love.graphics.setColor(0,1,0)
  love.graphics.print("temp:    " .. tostring(round(self.temp, 10)) .. " C", 10, 10)
  love.graphics.print("radius:  " .. tostring(self.radius, 10) .. " RE", 10, 20)
  love.graphics.print("mass:    " .. tostring(round(self.mass, 1000)) .. " ME", 10, 30)
  love.graphics.print("gravity: " .. tostring(round(self.gravity, 100)) .. " GE", 10, 40)
  love.graphics.print("moons:   " .. tostring(self.moons), 10, 50)
end