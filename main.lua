require("src.backgroundstar")
require("src.enemyship")
require("src.playership")
require("src.bullet")

local stars = {}
local enemyShips = {}
local enemyBullets = {}
local playerShip
local playerBullets = {}

local score = 0
local timeElapsedSinceLastEngineAnimation = 0
local timeSinceLastPlayerBulletFired = 0

-- debug/config constants
local audioEnabled = true
local drawCollisionHitboxes = false
local showMemoryUsage = true
local numberOfBackgroundStars = 50

function love.load()
    -- load images
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
    explosionSound = love.audio.newSource("audio/effects/explosion.wav", "static")
    explosionSound:setVolume(0.7)

    shotSound = love.audio.newSource("audio/effects/shot.wav", "static")
    shotSound:setVolume(0.4)

    local song = love.audio.newSource("audio/Religions.mp3", "stream")
    print("audioEnabled: " .. tostring(audioEnabled))
    if audioEnabled then
        song:play()
    end

    -- generate initial background stars
    print("numberOfBackgroundStars: " .. tostring(numberOfBackgroundStars))
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
    enemyShips[1] = EnemyShip:new(nil, 900, 300, enemyShipImg, 0.7)
    enemyShips[2] = EnemyShip:new(nil, 900, 375, enemyShipImg, 0.7)
    enemyShips[3] = EnemyShip:new(nil, 900, 450, enemyShipImg, 0.7)
    enemyShips[4] = EnemyShip:new(nil, 975, 300, enemyShipImg, 0.7)
    enemyShips[5] = EnemyShip:new(nil, 975, 375, enemyShipImg, 0.7)
    enemyShips[6] = EnemyShip:new(nil, 975, 450, enemyShipImg, 0.7)
    enemyShips[7] = EnemyShip:new(nil, 825, 375, enemyShipImg, 0.7)
    enemyShips[8] = EnemyShip:new(nil, 825, 300, enemyShipImg, 0.7)
    enemyShips[9] = EnemyShip:new(nil, 825, 450, enemyShipImg, 0.7)
    enemyShips[10] = EnemyShip:new(nil, 750, 375, enemyShipImg, 0.7)
    enemyShips[11] = EnemyShip:new(nil, 750, 300, enemyShipImg, 0.7)
    enemyShips[12] = EnemyShip:new(nil, 750, 450, enemyShipImg, 0.7)
end

function love.draw()
    -- background big red star
    love.graphics.draw(redStarImg, 400, 0, 0, 0.2, 0.2)

    -- background small stars
    for i, star in ipairs(stars) do
        star:draw()
    end

    -- background big blue stars
    love.graphics.draw(blueStarImg, 600, 400)

    -- player ship
    love.graphics.draw(playerShip.image, playerShip.x, playerShip.y, math.rad(90))
    love.graphics.draw(engineFlame_frames[currentFlameFrameIndex], 70, playerShip.y + 70, math.rad(180))
    for i, bullet in ipairs(playerBullets) do
        bullet:draw(255, 0, 0)
    end

    -- enemy ships
    for i, ship in ipairs(enemyShips) do
        ship:draw()
    end
    for i, bullet in ipairs(enemyBullets) do
        bullet:draw(0, 255, 0)
    end

    -- text displays
    love.graphics.print("Score: " .. score, 1000, 25)

    if showMemoryUsage then
        love.graphics.print('Memory used (kB): ' .. collectgarbage('count'), 950, 75)
    end

    -- draw collison hitboxes
    if drawCollisionHitboxes then
        for i, ship in ipairs(enemyShips) do
            love.graphics.rectangle("line",
                    ship:getTopLeftX(), ship:getTopLeftY(),
                    ship:getScaledWidth(), ship:getScaledHeight())
        end
    end
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
        if (timeSinceLastPlayerBulletFired > .12) then
            local newBullet = Bullet:new(nil, playerShip.x - 5, playerShip.y + 50, 4)
            table.insert(playerBullets, newBullet)
            timeSinceLastPlayerBulletFired = 0
            playSound("shot")
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
        bullet:update(dt, 10)
        if bullet.x > 1280 then
            table.remove(playerBullets, i)
        end
    end

    -- enemy ships and bullets
    for i, ship in ipairs(enemyShips) do
        ship:update(dt, enemyBullets)
    end

    for i, bullet in ipairs(enemyBullets) do
        bullet:update(dt, -5)
        if bullet.x > 1280 or bullet.x < 0 then
            table.remove(enemyBullets, i)
        end
    end

    -- check collisons
    for i, ship in ipairs(enemyShips) do
        for l, bullet in ipairs(playerBullets) do
            local collisionDectected = checkCollisionOfShipAndBullet(ship, bullet)
            if collisionDectected then
                print("collision detected")
                table.remove(enemyShips, i)
                table.remove(playerBullets, l)
                score = score + 25
                playSound("explosion")
            end
        end
    end
end

function checkCollisionOfShipAndBullet(ship, bullet)
    return checkCollision(
            ship:getTopLeftX(), ship:getTopLeftY(),
            ship:getScaledWidth(), ship:getScaledHeight(),
            bullet.x, bullet.y,
            5, 5)
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
            x2 < x1 + w1 and
            y1 < y2 + h2 and
            y2 < y1 + h1
end

function playSound(sound)
    if audioEnabled == false then
        return
    end

    if sound == "explosion" then
        local sfx = explosionSound:clone()
        sfx:play()
    elseif sound == "shot" then
        local sfx = shotSound:clone()
        sfx:play()
    else
        print("unknown sound: " .. tostring(sound))
    end

end