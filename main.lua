require("src.backgroundstar")
require("src.enemyship")

local playerShipY = 300
local score = 0
local audioEnabled = false
local stars = {}
local enemyShips = {}
local numberOfBackgroundStars = 50
local timeElapsedSinceLastEngineAnimation = 0

function love.load()
    love.window.setMode(1280, 720, { resizable = false, vsync = true, fullscreen = false, msaa = 1 })

    -- load graphics
    playerShip = love.graphics.newImage("image/pixel_ship_red.png")
    enemyShip = love.graphics.newImage("image/pixel_ship_yellow.png")

    blueStar = love.graphics.newImage("image/stars/star_blue_giant01.png")
    redStar = love.graphics.newImage("image/stars/star_red_giant01.png")
    asteroid = love.graphics.newImage("image/pixel_asteroid.png")

    engineFlame_frame1 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-1.png")
    engineFlame_frame2 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-2.png")
    engineFlame_frame3 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-3.png")
    engineFlame_frame4 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame6-1.png")
    engineFlame_frame5 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame6-2.png")
    engineFlame_frame6 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame6-3.png")
    engineFlame_frame7 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-1.png")
    engineFlame_frame8 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-2.png")
    engineFlame_frame9 = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-3.png")
    engineFlame_frames = { engineFlame_frame1, engineFlame_frame2, engineFlame_frame3,
                           engineFlame_frame4, engineFlame_frame5, engineFlame_frame6,
                           engineFlame_frame7, engineFlame_frame8, engineFlame_frame9 }
    currentFlameFrameIndex = 1;

    -- load audio
    local song = love.audio.newSource("audio/Religions.mp3", "stream")
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

    -- enemy ships
    enemyShips[1] = EnemyShip:new(nil, 900, 300, enemyShip)
    enemyShips[2] = EnemyShip:new(nil, 900, 375, enemyShip)
    enemyShips[3] = EnemyShip:new(nil, 900, 450, enemyShip)
end

function love.draw()
    -- background big stars
    love.graphics.draw(blueStar, 600, 400)
    love.graphics.draw(redStar, 400, 0, 0, 0.2, 0.2)

    -- background small stars
    for i, star in ipairs(stars) do
        star:draw()
    end

    -- player ship
    love.graphics.draw(playerShip, 160, playerShipY, math.rad(90))
    love.graphics.draw(engineFlame_frames[currentFlameFrameIndex], 70, playerShipY + 70, math.rad(180))

    -- enemy enemy ships
    for i, ship in ipairs(enemyShips) do
        ship:draw()
    end

    -- text displays
    love.graphics.print("Score: " .. score, 1000, 25)
end

function love.update(dt)
    -- handle input
    if love.keyboard.isDown("up") then
        playerShipY = playerShipY - 8
        if playerShipY < 10 then
            playerShipY = 10
        end
    end

    if love.keyboard.isDown("down") then
        playerShipY = playerShipY + 8
        if playerShipY > 610 then
            playerShipY = 610
        end
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("space") then
        --shoot
    end

    -- engine animation
    timeElapsedSinceLastEngineAnimation = timeElapsedSinceLastEngineAnimation + dt
    if timeElapsedSinceLastEngineAnimation > .08 then
        currentFlameFrameIndex = currentFlameFrameIndex + 1
        if currentFlameFrameIndex > table.getn(engineFlame_frames) then
            currentFlameFrameIndex = 1
        end
        timeElapsedSinceLastEngineAnimation = 0
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