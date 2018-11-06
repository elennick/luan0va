require("src.backgroundstar")
require("src.enemyship")
require("src.playership")
require("src.bullet")

local stars = {}
local enemyShips = {}
local playerShip
local playerBullets = {}

local score = 0
local timeElapsedSinceLastEngineAnimation = 0
local timeSinceLastPlayerBulletFired = 0
local numOfBullets = 0

-- config constants
local audioEnabled = true
local numberOfBackgroundStars = 50

function love.load()
    love.window.setMode(1280, 720, { resizable = false, vsync = true, fullscreen = false, msaa = 1 })

    -- load graphics
    playerShipImg = love.graphics.newImage("image/pixel_ship_red.png")
    enemyShipImg = love.graphics.newImage("image/pixel_ship_yellow.png")

    blueStarImg = love.graphics.newImage("image/stars/star_blue_giant01.png")
    redStarImg = love.graphics.newImage("image/stars/star_red_giant01.png")
    asteroidImg = love.graphics.newImage("image/pixel_asteroid.png")

    engineFlame_frame1Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-1.png")
    engineFlame_frame2Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-2.png")
    engineFlame_frame3Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame4-3.png")
    engineFlame_frame4Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame6-1.png")
    engineFlame_frame5Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame6-2.png")
    engineFlame_frame6Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame6-3.png")
    engineFlame_frame7Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-1.png")
    engineFlame_frame8Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-2.png")
    engineFlame_frame9Img = love.graphics.newImage("image/heavy_turret_prototype.fx.second.flame/flame7-3.png")
    engineFlame_frames = { engineFlame_frame1Img, engineFlame_frame2Img, engineFlame_frame3Img,
                           engineFlame_frame4Img, engineFlame_frame5Img, engineFlame_frame6Img,
                           engineFlame_frame7Img, engineFlame_frame8Img, engineFlame_frame9Img }
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

    -- player ship
    playerShip = PlayerShip:new(nil, 160, 300, playerShipImg)

    -- enemy ships
    enemyShips[1] = EnemyShip:new(nil, 900, 300, enemyShipImg)
    enemyShips[2] = EnemyShip:new(nil, 900, 375, enemyShipImg)
    enemyShips[3] = EnemyShip:new(nil, 900, 450, enemyShipImg)
    enemyShips[4] = EnemyShip:new(nil, 975, 300, enemyShipImg)
    enemyShips[5] = EnemyShip:new(nil, 975, 375, enemyShipImg)
    enemyShips[6] = EnemyShip:new(nil, 975, 450, enemyShipImg)
end

function love.draw()
    -- background big stars
    love.graphics.draw(blueStarImg, 600, 400)
    love.graphics.draw(redStarImg, 400, 0, 0, 0.2, 0.2)

    -- background small stars
    for i, star in ipairs(stars) do
        star:draw()
    end

    -- player ship
    love.graphics.draw(playerShip.graphic, playerShip.x, playerShip.y, math.rad(90))
    love.graphics.draw(engineFlame_frames[currentFlameFrameIndex], 70, playerShip.y + 70, math.rad(180))
    for i, bullet in ipairs(playerBullets) do
        bullet:draw()
    end

    -- enemy ships
    for i, ship in ipairs(enemyShips) do
        ship:draw()
    end

    -- text displays
    love.graphics.print("Score: " .. score, 1000, 25)
    love.graphics.print("Number of Bullets: " .. numOfBullets, 1000, 125)
end

function love.update(dt)
    -- handle input
    if love.keyboard.isDown("up") then
        playerShip.y = playerShip.y - 8
        if playerShip.y < 10 then
            playerShip.y = 10
        end
    end

    if love.keyboard.isDown("down") then
        playerShip.y = playerShip.y + 8
        if playerShip.y > 610 then
            playerShip.y = 610
        end
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("space") then
        timeSinceLastPlayerBulletFired = timeSinceLastPlayerBulletFired + dt
        if (timeSinceLastPlayerBulletFired > .15) then
            local newBullet = Bullet:new(nil, playerShip.x - 5, playerShip.y + 50)
            table.insert(playerBullets, newBullet)
            timeSinceLastPlayerBulletFired = 0
        end
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

    -- player ship and bullets
    playerShip:update(dt)
    for i, bullet in ipairs(playerBullets) do
        bullet:update(dt)
        if bullet.x > 1280 then
            table.remove(playerBullets, i)
        end
    end
    numOfBullets = table.table(bullet)

    -- enemy ships
    for i, ship in ipairs(enemyShips) do
        ship:update(dt)
    end
end