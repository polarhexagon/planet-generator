function love.load()
  Object = require "classic"
  push = require "push"
  require "planet"
  
  -- push
  WINDOW_WIDTH   = 960
  WINDOW_HEIGHT  = 720
  VIRTUAL_WIDTH  = 320
  VIRTUAL_HEIGHT = 240
  love.graphics.setDefaultFilter("nearest","nearest")
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
  
  -- game/interactables
  planet = Planet()
  --output = io.output("out.txt")
  
  hitbox = {}
  hitbox.radius = 33
  hitbox.x = hitbox.radius + 7
  hitbox.y = VIRTUAL_HEIGHT - hitbox.radius - 7
  
  math.randomseed(os.time())
  
  -- graphics
  smallFont = love.graphics.newFont("assets/DepartureMono-Regular.otf", 11)
  love.graphics.setFont(smallFont)
  
  bgImg = love.graphics.newImage("assets/bg.png")
  scanlines = love.graphics.newImage("assets/scanlines.png")
  
end

function love.keypressed(key)
  if key == "space" then
    planet:generate()
  end
end

function love.update(dt)
  --planet:generate() -- stress testing
  --output:write(planet.radius .. "\n")
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
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill",hitbox.x,hitbox.y,hitbox.radius)
  push:apply("end")
end