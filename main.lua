function love.load()
  Object = require "classic"
  push = require "push"
  dice = require "dice"
  require "planet"
  -- push
  local window_width   = 960
  local window_height  = 720
  VIRTUAL_WIDTH  = 320
  VIRTUAL_HEIGHT = 240
  love.graphics.setDefaultFilter("nearest","nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,window_width, window_height, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
  -- game/interactables
  planet = Planet()
  hitbox = {}
  hitbox.radius = 33
  hitbox.dist = 0
  hitbox.x = hitbox.radius + 7
  hitbox.y = VIRTUAL_HEIGHT - hitbox.radius - 7
  hitbox.originX = hitbox.x - hitbox.radius
  hitbox.originY = hitbox.y - hitbox.radius
  hitbox.isPressed = false
  math.randomseed(os.time())
  mouseX = nil
  mouseY = nil
  -- graphics
  bgImg = love.graphics.newImage("assets/bg.png")
  scanlines = love.graphics.newImage("assets/scanlines.png")
  button = love.graphics.newImage("assets/button.png")
  smallFont = love.graphics.newFont("assets/DepartureMono-Regular.otf", 11)
  love.graphics.setFont(smallFont)
  -- audio
  buttonDown = love.audio.newSource("assets/buttonDown.ogg", "static")
  buttonUp = love.audio.newSource("assets/buttonUp.ogg", "static")
end

function love.update(dt)
  mouseX, mouseY = love.mouse.getPosition()
  mouseX = mouseX / 3
  mouseY = mouseY / 3
  hitbox.dist = dice.getDistance(mouseX, mouseY, hitbox.x, hitbox.y)
end

function love.mousepressed()
  if hitbox.dist < hitbox.radius then
    hitbox.isPressed = true
    planet:generate()
    buttonDown:play()
  end
end

function love.mousereleased()
  if hitbox.isPressed then
    hitbox.isPressed = false
    buttonUp:play()
  end
end

function love.draw()
  push:apply("start")
    love.graphics.clear(0.1,0.1,0.1) -- RGBA
    planet:draw()
    planet:drawMoons()
    love.graphics.setColor(1,1,1,0.2)
    love.graphics.draw(scanlines)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(bgImg)
    love.graphics.setColor(1,1,1)
    if hitbox.isPressed == false then
      love.graphics.draw(button,hitbox.x-hitbox.radius,hitbox.y-hitbox.radius)
    end
    -- Debug
    --love.graphics.printf(hitbox.dist,100,100,999)
    --love.graphics.print("FPS: " .. tostring(love.timer.getFPS( )), 10, VIRTUAL_HEIGHT-20)
  push:apply("end")
end