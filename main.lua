local shipY = 300
local score = 0
local audioEnabled = false
local currentFlameImg = nil
local engineAnimationTimer = 0
local backgroundStar1 = nil
local backgroundStar2 = nil
local backgroundStar3 = nil

function love.load()
    -- load image media
    love.window.setMode(1280, 720, { resizable = false, vsync = true, fullscreen = false, msaa = 1 })
    ship = love.graphics.newImage("image/pixel_ship_red.png")
    blueStar = love.graphics.newImage("image/stars/star_blue_giant01.png")

    engineFlame1 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-3.png")
    engineFlame2 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-1.png")
    currentFlameImg = engineFlame1

    -- load audio
    song = love.audio.newSource("audio/Religions.mp3", "stream")
    if audioEnabled then
        love.audio.play(song)
    end

    -- generate initial background stars
    x = math.random(0,1280)
    y = math.random(0, 720)
    backgroundStar1 = BackgroundStar:new(nil, x, y,3, 0, 0, 255)
    x = math.random(0,1280)
    y = math.random(0, 720)
    backgroundStar2 = BackgroundStar:new(nil, x, y,2, 255, 255, 255)
    x = math.random(0,1280)
    y = math.random(0, 720)
    backgroundStar3 = BackgroundStar:new(nil, x, y,1, 255, 255, 0)
end

function love.draw()
    love.graphics.print("Score: " .. score, 950, 25)
    love.graphics.draw(blueStar, 600, 400)
    love.graphics.draw(ship, 160, shipY, math.rad(90))

    love.graphics.draw(currentFlameImg, 70, shipY + 70, math.rad(180))

    backgroundStar1:draw()
    backgroundStar2:draw()
    backgroundStar3:draw()
end

function love.update(dt)
    -- handle input
    if love.keyboard.isDown("up") then
        shipY = shipY - 8
        if shipY < 10 then
            shipY = 10
        end
    end

    if love.keyboard.isDown("down") then
        shipY = shipY + 8
        if shipY > 610 then
            shipY = 610
        end
    end

    -- engine animation
    engineAnimationTimer = engineAnimationTimer + dt
    if engineAnimationTimer >= .2 then
        if currentFlameImg == engineFlame1 then
            currentFlameImg = engineFlame2
        else
            currentFlameImg = engineFlame1
        end
        engineAnimationTimer = 0
    end

    -- update background stars
    backgroundStar1.x = backgroundStar1.x - 5
    backgroundStar2.x = backgroundStar2.x - 5
    backgroundStar3.x = backgroundStar3.x - 5
end

--- background star stuff
BackgroundStar = { x = 0, y = 0, size = 2, r = 255, g = 255, b = 255 }

function BackgroundStar:new (o, x, y, size, r, g, b)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        size = size or 2,
        r = r or 255,
        g = g or 255,
        b = b or 255
    }, self)
end

function BackgroundStar:draw()
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
    love.graphics.setColor(255, 255, 255)
end