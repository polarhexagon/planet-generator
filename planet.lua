Planet = Object:extend()
dice = require "dice"

function Planet:new()
  -- Blank values to be filled in later
  self.temp = 0
  self.radius = 0
  self.mass = 0
  self.gravity = 0
  self.moons = 0
  -- Graphics
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
  local minTemp = -275*10
  local maxTemp = 300*10
  -- Rolls three times and averages results
  self.temp = (math.random(minTemp, maxTemp)+
               math.random(minTemp, maxTemp)+
               math.random(minTemp, maxTemp))/30
  -- These measurements are all in comparison to Earth.
  -- ie. Earth radii, Earth masses, Earth gravity...
  self.radius = dice.countLowest(2, 3, 50)/10
  -- ideal range 0.0041 - 4134
  -- current range 0.001 - 200, avg 0.1-10
  self.mass = dice.logRand(6, -0.5)
  self.gravity = dice.gravity(self.radius, self.mass)
  self.moons = dice.countLowest(2,0,6)
  -- more graphics junk
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
  -- text
  love.graphics.setColor(0,1,0)
  love.graphics.print("temp:    " .. tostring(dice.round(self.temp, 10)) .. " C", 10, 7)
  love.graphics.print("radius:  " .. tostring(self.radius, 10) .. " RE", 10, 17)
  love.graphics.print("mass:    " .. tostring(dice.round(self.mass, 1000)) .. " ME", 10, 27)
  love.graphics.print("gravity: " .. tostring(dice.round(self.gravity, 100)) .. " G", 10, 37)
  love.graphics.print("moons:   " .. tostring(self.moons), 10, 47)
  -- temperature color
  love.graphics.setColor(dice.HSL(self.hue,1,0.5,1))
  -- sticker backing/border around planet
  love.graphics.draw(self.border, self.x-self.pixelRadius-2, self.y-self.pixelRadius-2)
  -- planet
  love.graphics.draw(self.ballSheet,
    self.balls[math.floor(self.currentBall)],
    self.x-self.pixelRadius,
    self.y-self.pixelRadius)
end