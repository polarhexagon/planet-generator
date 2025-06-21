Planet = Object:extend()

local newton_constant = 6.6743e-11

local minTemp = -275*10
local maxTemp = 300*10

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

-- Converts HSL to RGB. (input and output range: 0 - 1)
-- copypasted from love2d docs
local function HSL(h, s, l, a)
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
  
  self.x = VIRTUAL_WIDTH - 100
  self.y = VIRTUAL_HEIGHT - 100
  self.pixelRadius = 80
  self.ballSheet = love.graphics.newImage("assets/ballSheet.png")
  self.border = love.graphics.newImage("assets/border.png")
  self.balls = {}
  self.hue = 0
  self.currentBall = 1
  
  -- Sprites :-)
  local height_width = 160
  for i=0,9 do
    for j=0,9 do
      table.insert(self.balls, love.graphics.newQuad(
        j * height_width, 
        i * height_width,
        height_width,
        height_width,
        self.ballSheet:getWidth(),
        self.ballSheet:getHeight()))
    end
  end
end

-- Replace old planet values with new ones. Cool
function Planet:generate()
  -- Rolls three times and averages results
  self.temp = (math.random(minTemp, maxTemp)+
               math.random(minTemp, maxTemp)+
               math.random(minTemp, maxTemp))/30
  
  -- These measurements are all in comparison to Earth.
  -- ie. Earth radii, Earth masses, Earth gravity...
  self.radius = countLowest(2, 3, 50)/10
  -- ideal range 0.0041 - 4134
  -- current range 0.001 - 200, avg 0.1-10
  self.mass = logRand(6, -0.5)
  self.gravity = gravity(self.radius, self.mass)
  
  self.moons = countLowest(5,0,19)
  
  self.hue = (self.temp - minTemp/10) / (maxTemp - minTemp/10) * 5 + 0.3
  self.hue = 1 - self.hue
  
  self.currentBall = math.random(1,100)
  
end

function Planet:drawMoons()
  for i = 1, self.moons do
    love.graphics.circle("fill",
            self.x + self.pixelRadius*1.3 * math.cos(i/3+3),
            self.y + self.pixelRadius*1.3 * math.sin(i/3+3), 
            self.pixelRadius/10)
  end
end

function Planet:update(dt)
end

function Planet:draw()
  love.graphics.setColor(0,1,0)
  love.graphics.print("temp:    " .. tostring(round(self.temp, 10)) .. " C", 10, 7)
  love.graphics.print("radius:  " .. tostring(self.radius, 10) .. " RE", 10, 17)
  love.graphics.print("mass:    " .. tostring(round(self.mass, 1000)) .. " ME", 10, 27)
  love.graphics.print("gravity: " .. tostring(round(self.gravity, 100)) .. " G", 10, 37)
  love.graphics.print("moons:   " .. tostring(self.moons), 10, 47)
  
  -- temperature color
  love.graphics.setColor(HSL(self.hue,1,0.5,1))
  -- sticker backing/border around planet
  love.graphics.draw(self.border, self.x-self.pixelRadius-2, self.y-self.pixelRadius-2)
  -- planet
  love.graphics.draw(self.ballSheet, 
    self.balls[math.floor(self.currentBall)],
    self.x-self.pixelRadius,
    self.y-self.pixelRadius)
end