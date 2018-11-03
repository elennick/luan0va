local y = 300
local score = 0
local audioEnabled = false
local currentFlameImg = null
local engineAnimationTimer = 0

function love.load()
    love.window.setMode(1280, 720, { resizable = false, vsync = true, fullscreen = false, msaa = 1 })
    ship = love.graphics.newImage("image/pixel_ship_red.png")
    blueStar = love.graphics.newImage("image/stars/star_blue_giant01.png")

    engineFlame1 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-3.png")
    engineFlame2 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-1.png")
    currentFlameImg = engineFlame1

    song = love.audio.newSource("audio/Religions.mp3", "stream")
    if audioEnabled then
        love.audio.play(song)
    end
end

function love.draw()
    love.graphics.print("Score: " .. score, 950, 25)
    love.graphics.draw(blueStar, 600, 400)
    love.graphics.draw(ship, 160, y, math.rad(90))

    love.graphics.draw(currentFlameImg, 70, y + 70, math.rad(180))
end

function love.update(dt)
    -- handle input
    if love.keyboard.isDown("up") then
        y = y - 8
        if y < 10 then
            y = 10
        end
    end

    if love.keyboard.isDown("down") then
        y = y + 8
        if y > 610 then
            y = 610
        end
    end

    -- timers
    engineAnimationTimer = engineAnimationTimer + dt
    if engineAnimationTimer >= .2 then
        if currentFlameImg == engineFlame1 then
            currentFlameImg = engineFlame2
        else
            currentFlameImg = engineFlame1
        end
        engineAnimationTimer = 0
    end
end