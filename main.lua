require("src.backgroundstar")
require("src.enemyship")
require("src.playership")
require("src.bullet")
require("src.engineanimation")
require("src.animationwrapper")

local anim8 = require("libs.anim8")
local Moan = require("libs.Moan")

local stars = {}
local enemyShips = {}
local enemyBullets = {}
local playerShip
local playerBullets = {}
local animations = {}

local score = 0
local timeSinceLastPlayerBulletFired = 0
local timeSinceLastShipSpawn = 0
local timeSinceLastEnergyGain = 0
local paused = false
local playerDead = false

-- debug
local audioEnabled = true
local drawCollisionHitboxes = false
local showMemoryUsage = false

-- config
local numberOfBackgroundStars = 30
local maxNumberOfEnemyShips = 20
local energyPerShot = 8
local maxEnergy = 200
local maxHealth = 10

function love.load()
    math.randomseed(os.time())

    font = love.graphics.newFont(15)
    love.graphics.setFont(font)

    -- load images
    playerShipImg = love.graphics.newImage("image/pixel_ship_red.png")
    enemyYellowShipImg = love.graphics.newImage("image/pixel_ship_yellow.png")
    enemyBlueShipImg = love.graphics.newImage("image/pixel_ship_blue.png")
    enemyGreenShipImg = love.graphics.newImage("image/pixel_ship_green.png")

    blueStarImg = love.graphics.newImage("image/stars/star_blue_giant01.png")
    redStarImg = love.graphics.newImage("image/stars/star_red_giant01.png")
    asteroidImg = love.graphics.newImage("image/pixel_asteroid.png")

    -- enemy ship explosion animation
    explosionSpriteSheet = love.graphics.newImage("image/explosions/explosion31.png")
    explosionGrid = anim8.newGrid(256, 256, explosionSpriteSheet:getWidth(), explosionSpriteSheet:getHeight())
    explosionAnimation = anim8.newAnimation(explosionGrid('1-4', 1, '1-4', 2, '1-4', 3, '1-4', 4), .04)

    -- player ship explosion animation
    playerExplosionSpriteSheet = love.graphics.newImage("image/explosions/explosion23.png")
    playerExplosionGrid = anim8.newGrid(256, 256, playerExplosionSpriteSheet:getWidth(), playerExplosionSpriteSheet:getHeight())
    playerExplosionAnimation = anim8.newAnimation(playerExplosionGrid('1-4', 1, '1-4', 2, '1-4', 3, '1-4', 4), .08)

    -- spawn animation
    spawnSpriteSheet = love.graphics.newImage("image/spawn.png")
    spawnGrid = anim8.newGrid(100, 100, spawnSpriteSheet:getWidth(), spawnSpriteSheet:getHeight())
    spawnAnimation = anim8.newAnimation(spawnGrid('1-6', 1), .025)

    -- player ship
    playerShip = PlayerShip:new(nil, 115, 200, playerShipImg, maxEnergy, maxHealth)

    -- engine animation
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
    engineAnimation = EngineAnimation:new(nil, engineFlame_frames, true, math.rad(180), .08)

    -- load audio
    explosionSound = love.audio.newSource("audio/effects/explosion.wav", "static")
    explosionSound:setVolume(0.7)

    shotSound = love.audio.newSource("audio/effects/shot.wav", "static")
    shotSound:setVolume(0.4)

    gameOverSound = love.audio.newSource("audio/effects/277403__landlucky__game-over-sfx-and-voice.wav", "static")
    gameOverSound:setVolume(1)

    local song = love.audio.newSource("audio/Religions.mp3", "stream")
    print("audioEnabled: " .. tostring(audioEnabled))
    if audioEnabled then
        song:setLooping(true)
        song:setVolume(0.7)
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

    -- enemy ships
    spawnEnemyShips(10)
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

    -- enemy ships
    for i, ship in ipairs(enemyShips) do
        ship:draw()
    end
    for i, bullet in ipairs(enemyBullets) do
        bullet:draw(0, 255, 0)
    end

    -- animations
    for i, animation in ipairs(animations) do
        animation:draw()
    end

    -- text displays
    love.graphics.print("Score: " .. score, 1000, 25)
    love.graphics.print("Health: " .. playerShip.health, 200, 25)
    love.graphics.print("Energy: " .. playerShip.energy, 200, 50)

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

    -- player ship
    if playerDead == false then
        playerShip:draw()
        engineAnimation:drawAtPosition(50, playerShip.y)
    else
        love.graphics.print("GAME OVER", 275, 300, 0, 8, 8)
    end

    for i, bullet in ipairs(playerBullets) do
        bullet:draw(255, 0, 0)
    end

    -- if paused
    if paused and playerDead == false then
        love.graphics.print("GAME PAUSED", 200, 300, 0, 8, 8)
        love.graphics.print("Press 'Q' to Quit", 425, 425, 0, 3, 3)
        love.graphics.print("Press 'Esc' to Keep Playing", 325, 475, 0, 3, 3)
    end

end

function love.update(dt)
    if paused == true then
        return
    end

    -- handle inputs
    handleUnpausedInput(dt)

    -- engine animation
    engineAnimation:update(dt)

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
    if playerDead == false then
        playerShip:update(dt)
    end

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

    -- other animations
    for i, animation in ipairs(animations) do
        animation:update(dt)
        if animation.elapsedDuration >= animation.expiresAfter then
            table.remove(animations, i)
        end
    end

    -- check collisions
    for i, ship in ipairs(enemyShips) do
        for l, bullet in ipairs(playerBullets) do
            local collisionDectected = checkCollisionOfShipAndBullet(ship, bullet)
            if collisionDectected then
                print("enemy ship collision detected")
                enemyShips[i].health = enemyShips[i].health - 1;
                table.remove(playerBullets, l)

                if enemyShips[i].health <= 0 then
                    score = score + enemyShips[i]:getScoreValue()
                    table.insert(animations,
                            AnimationWrapper:new(o,
                                    explosionSpriteSheet,
                                    explosionAnimation,
                                    enemyShips[i].x,
                                    enemyShips[i].y,
                                    .64,
                                    enemyShips[i].scale))
                    table.remove(enemyShips, i)
                    playSound("explosion")
                end
            end
        end
    end

    for i, bullet in ipairs(enemyBullets) do
        local collisionDectected = checkCollisionOfShipAndBullet(playerShip, bullet)
        if collisionDectected then
            print("player ship collision detected")
            playerShip.health = playerShip.health - 1
            table.remove(enemyBullets, i)
        end
    end

    -- spawn new ships
    timeSinceLastShipSpawn = timeSinceLastShipSpawn + dt
    if timeSinceLastShipSpawn > 3 then
        spawnEnemyShips(5)
        timeSinceLastShipSpawn = 0
    end

    -- update energy
    timeSinceLastEnergyGain = timeSinceLastEnergyGain + dt
    if playerShip.energy < maxEnergy and timeSinceLastEnergyGain > .03 then
        playerShip.energy = playerShip.energy + 1
        timeSinceLastEnergyGain = 0
    end

    -- check if player is dead
    if playerShip.health <= 0 and playerDead == false then
        playerDead = true
        love.audio.stop()
        playSound("gameover")
        table.insert(animations,
                AnimationWrapper:new(o,
                        playerExplosionSpriteSheet,
                        playerExplosionAnimation,
                        playerShip.x,
                        playerShip.y,
                        1.28,
                        playerShip.scale * 2.5))
    end
end

function love.keypressed(key)
    print("key pressed: " .. key)

    if key == "escape" and playerDead == false and paused == false then
        print("pausing game")
        paused = true
    elseif key == "escape" and playerDead == true then
        print("quitting game")
        love.event.quit()
    elseif key == "escape" and paused == true then
        print("unpausing game")
        paused = false
    elseif key == "q" and paused == true then
        print("quitting game")
        love.event.quit()
    end
end

function handleUnpausedInput(dt)
    if love.keyboard.isDown("up") then
        playerShip.y = playerShip.y - 8
        if playerShip.y < 45 then
            playerShip.y = 45
        end
    end

    if love.keyboard.isDown("down") then
        playerShip.y = playerShip.y + 8
        if playerShip.y > 670 then
            playerShip.y = 670
        end
    end

    if love.keyboard.isDown("space") and playerDead == false then
        if playerShip.energy >= energyPerShot then
            timeSinceLastPlayerBulletFired = timeSinceLastPlayerBulletFired + dt
            if timeSinceLastPlayerBulletFired > .10 then
                local newBullet = Bullet:new(nil, playerShip.x + 25, playerShip.y, 4)
                table.insert(playerBullets, newBullet)
                timeSinceLastPlayerBulletFired = 0
                playSound("shot")
                playerShip.energy = playerShip.energy - energyPerShot
            end
        end
    end
end

function spawnEnemyShips(numOfShips)
    for i = 0, numOfShips, 1 do
        if table.getn(enemyShips) >= maxNumberOfEnemyShips then
            print("Can't spawn more ships, already at max " .. table.getn(enemyShips))
            return
        end

        local startingX = math.random(575, 1200)
        local startingY = math.random(75, 650)
        local scale

        local shipToSpawn = math.random(1, 8)
        if shipToSpawn == 1 then
            scale = 0.55
            local newShip = EnemyShip:new(nil, startingX, startingY, enemyBlueShipImg, scale, 1)
            table.insert(enemyShips, newShip)
        elseif shipToSpawn == 2 then
            scale = 1.25
            local newShip = EnemyShip:new(nil, startingX, startingY, enemyGreenShipImg, scale, 2)
            table.insert(enemyShips, newShip)
        else
            scale = 0.7
            local newShip = EnemyShip:new(nil, startingX, startingY, enemyYellowShipImg, scale, 3)
            table.insert(enemyShips, newShip)
        end

        table.insert(animations,
                AnimationWrapper:new(o,
                        spawnSpriteSheet,
                        spawnAnimation,
                        startingX,
                        startingY,
                        .1,
                        scale))
    end
end

function checkCollisionOfShipAndBullet(ship, bullet)
    return checkCollision(
            ship:getTopLeftX(), ship:getTopLeftY(),
            ship:getScaledWidth(), ship:getScaledHeight(),
            bullet.x, bullet.y,
            5, 5) --todo make this variable based on the bullet size, not hard coded to a width of 5
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
    elseif sound == "gameover" then
        local sfx = gameOverSound:clone()
        sfx:play()
    else
        print("unknown sound: " .. tostring(sound))
    end
end