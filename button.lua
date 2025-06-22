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
end

function Button:mousepressed()
  if self.dist < self.radius then
    self.isPressed = true
    buttonDown:play()
    self.pressFrame = 1
  end
end

function Button:mousereleased()
  if self.isPressed then
    self.isPressed = false
    buttonUp:play()
  end
end

function Button:draw()
  if self.isPressed == false then
    love.graphics.draw(self.sprite,self.x-self.radius,self.y-self.radius)
  end
end