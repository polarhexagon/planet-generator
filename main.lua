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
  hitbox.x = hitbox.radius + 7
  hitbox.y = VIRTUAL_HEIGHT - hitbox.radius - 7
  hitbox.originX = hitbox.x - hitbox.radius
  hitbox.originY = hitbox.y - hitbox.radius
  hitbox.isPressed = false
  math.randomseed(os.time())
  -- graphics
  bgImg = love.graphics.newImage("assets/bg.png")
  scanlines = love.graphics.newImage("assets/scanlines.png")
  button = love.graphics.newImage("assets/button.png")
  smallFont = love.graphics.newFont("assets/DepartureMono-Regular.otf", 11)
  love.graphics.setFont(smallFont)
end

function love.keypressed(key)
  if key == "space" then
    hitbox.isPressed = true
  else
    hitbox.isPressed = false
  end
end

function love.update(dt)
  --planet:generate() -- stress testing
  --output:write(planet.radius .. "\n")
  mouse_x, mouse_y = love.mouse.getPosition()
  -- compensating for vwidth/vheight
  mouse_x = mouse_x / 3
  mouse_y = mouse_y / 3
  if dice.getDistance(mouse_x, mouse_y, hitbox.x, hitbox.y) < hitbox.radius then
    if love.mouse.isDown(1) then
      hitbox.isPressed = true
    else
      hitbox.isPressed = false
    end
  end
  -- make planet
  if hitbox.isPressed then
    planet:generate()
  end
end

function love.draw()
  push:apply("start")
    love.graphics.clear(0.1,0.1,0.1) -- RGBA
    planet:draw()
    planet:drawMoons()
    --love.graphics.print("FPS: " .. tostring(love.timer.getFPS( )), 10, VIRTUAL_HEIGHT-20)
    love.graphics.setColor(1,1,1,0.2)
    love.graphics.draw(scanlines)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(bgImg)
    love.graphics.setColor(1,1,1)
    if hitbox.isPressed == false then
      love.graphics.draw(button,hitbox.x-hitbox.radius,hitbox.y-hitbox.radius)
    end
    --love.graphics.circle("fill",hitbox.x,hitbox.y,hitbox.radius)
  push:apply("end")
end