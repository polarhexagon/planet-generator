function love.load()
  Object = require "classic"
  push = require "push"
  dice = require "dice"
  require "planet"
  require "button"
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
  buttonNew = Button(33, 40, VIRTUAL_HEIGHT - 40, "assets/button.png")
  math.randomseed(os.time())
  mouseX = nil
  mouseY = nil
  -- graphics
  bgImg = love.graphics.newImage("assets/bg.png")
  scanlines = love.graphics.newImage("assets/scanlines.png")
  smallFont = love.graphics.newFont("assets/DepartureMono-Regular.otf", 11)
  love.graphics.setFont(smallFont)
  -- audio
  buttonDown = love.audio.newSource("assets/sfx/buttonDown.ogg", "static")
  buttonUp = love.audio.newSource("assets/sfx/buttonUp.ogg", "static")
  ambient = love.audio.newSource("assets/sfx/ambLow.ogg", "stream")
  ambient:setLooping(true)
  ambient:play()
end

function love.mousepressed()
  buttonNew:mousepressed()
end

function love.mousereleased()
  buttonNew:mousereleased()
end

function love.update(dt)
  mouseX, mouseY = love.mouse.getPosition()
  mouseX = mouseX / 3
  mouseY = mouseY / 3
  buttonNew.dist = dice.getDistance(mouseX, mouseY, buttonNew.x, buttonNew.y)
  
  if buttonNew.pressFrame then
    buttonNew.pressFrame = false
    planet:generate()
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
    buttonNew:draw()
    -- Debug
    --love.graphics.printf(hitbox.dist,100,100,999)
    --love.graphics.print("FPS: " .. tostring(love.timer.getFPS( )), 10, VIRTUAL_HEIGHT-20)
  push:apply("end")
end