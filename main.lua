local shipY = 300
local score = 0
local audioEnabled = false
local currentFlameImg = nil
local engineAnimationTimer = 0
local stars = {}

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

    --x = math.random(0, 1280)
    --y = math.random(0, 720)
    --stars[2] = BackgroundStar:new(nil, x, y, 2, 255, 255, 255)
    --x = math.random(0, 1280)
    --y = math.random(0, 720)
    --stars[3] = BackgroundStar:new(nil, x, y, 1, 255, 255, 0)

    for i = 1, 40 do
        size = math.random(1, 3)
        x = math.random(0, 1280)
        y = math.random(0, 720)
        speed = math.random(2, 8)
        stars[i] = BackgroundStar:new(nil, x, y, size, 255, 255, 255, speed)
    end
end

function love.draw()
    love.graphics.draw(blueStar, 600, 400)

    for i, star in ipairs(stars) do
        star:draw()
    end

    love.graphics.draw(ship, 160, shipY, math.rad(90))
    love.graphics.draw(currentFlameImg, 70, shipY + 70, math.rad(180))

    love.graphics.print("Score: " .. score, 950, 25)
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
    for i, star in ipairs(stars) do
        star.x = star.x - star.speed
        if star.x < 0 then
            star.x = 1280
            star.y = math.random(0, 720)
        end
    end
end

--- background star stuff
BackgroundStar = { x = 0, y = 0, size = 2, r = 255, g = 255, b = 255, speed = 5 }

function BackgroundStar:new (o, x, y, size, r, g, b, speed)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        size = size or 2,
        r = r or 255,
        g = g or 255,
        b = b or 255,
        speed = speed or 5
    }, self)
end

function BackgroundStar:draw()
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
    love.graphics.setColor(255, 255, 255)
end