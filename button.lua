Button = Object:extend()
require "planet"

function Button:new(rad,x,y,img)
  self.radius = rad
  self.dist = 0
  self.x = x
  self.y = y
  self.originX = self.x - self.radius
  self.originY = self.y - self.radius
  self.isPressed = false
  self.pressFrame = false
  self.sprite = love.graphics.newImage(img)
  self.sfx = 0
end

function Button:mousepressed()
  if self.dist < self.radius then
    self.isPressed = true
    self.sfx = math.random(80,115)
    self.sfx = self.sfx/100
    buttonDown:setPitch(self.sfx)
    buttonDown:clone():play()
    self.pressFrame = 1
  end
end

function Button:mousereleased()
  if self.isPressed then
    self.isPressed = false
    self.sfx = math.random(80,115)
    self.sfx = self.sfx/100
    buttonUp:setPitch(self.sfx)
    buttonUp:clone():play()
  end
end

function Button:draw()
  if self.isPressed == false then
    love.graphics.draw(self.sprite,self.x-self.radius,self.y-self.radius)
  end
end