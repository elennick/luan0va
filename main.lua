require("src.backgroundstar")

local shipY = 300
local score = 0
local audioEnabled = false
local currentFlameImg = nil
local engineAnimationTimer = 0
local stars = {}
local numberOfBackgroundStars = 75

function love.load()
    -- load graphics
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
    for i = 1, numberOfBackgroundStars do
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

    love.graphics.print("Score: " .. score, 1000, 25)
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

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("space") then
        --shoot
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

    -- background stars
    for i, star in ipairs(stars) do
        star.x = star.x - star.speed
        if star.x < 0 then
            star.x = 1280
            star.y = math.random(0, 720)
            star.speed = math.random(2, 8)
        end
    end
end