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
  
  planet = Planet()
  output = io.output("out.txt")
  
  hitbox = {}
  hitbox.width = 60
  hitbox.height = 20
  hitbox.x = VIRTUAL_HEIGHT - hitbox.height - 20
  hitbox.y = VIRTUAL_WIDTH - hitbox.width
  
  math.randomseed(os.time())
  
  smallFont = love.graphics.newFont("DepartureMono-Regular.otf", 11)
  love.graphics.setFont(smallFont)
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
    love.graphics.clear(40/255, 45/255, 52/255, 255/255) -- RGBA
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill",hitbox.x,hitbox.y,hitbox.width,hitbox.height)
    planet:draw()
    --love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS( )), 10, VIRTUAL_HEIGHT-20)
  push:apply("end")
end