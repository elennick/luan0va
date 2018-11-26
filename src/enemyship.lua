EnemyShip = {
    x = 0,
    y = 0,
    timeSinceLastBullet = 0,
    timeSinceLastDirChange = 0
}

function EnemyShip:new (o, x, y, image, scale, type)
    if type == 4 then
        -- type 4 = boss ship
        firingRate = 2
        movementMultiplier = 0
        directionChangeInterval = 500
        scoreValue = 1000
        health = 200
    elseif type == 1 then
        -- type 1 = elite, fast moving blue ships
        firingRate = 1
        movementMultiplier = 7
        directionChangeInterval = 2.5
        scoreValue = 50
        health = 1
    elseif type == 2 then
        -- type 2 = elite, large, stationary fast firing ships
        firingRate = 3
        movementMultiplier = 0
        directionChangeInterval = 500
        scoreValue = 100
        health = 3
    else
        -- type 3 = standard slow moving slow firing ships
        firingRate = math.random(4, 6)
        movementMultiplier = 1
        directionChangeInterval = 10
        scoreValue = 25
        health = 1
    end

    velX = math.random(-1 * movementMultiplier, 1 * movementMultiplier)
    velY = math.random(-1 * movementMultiplier, 1 * movementMultiplier)

    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        image = image,
        scale = scale or 0.7,
        type = type or 3,
        elite = elite or false,
        timeSinceLastBullet = timeSinceLastBullet or 0,
        timeSinceLastDirChange = timeSinceLastDirChange or 0,
        velX = velX,
        velY = velY,
        firingRate = firingRate,
        movementMultiplier = movementMultiplier,
        directionChangeInterval = directionChangeInterval,
        scoreValue = scoreValue,
        health = health
    }, self)
end

function EnemyShip:draw()
    love.graphics.draw(self.image,
            self.x,
            self.y,
            math.rad(270),
            self.scale,
            self.scale,
            self.image:getWidth() / 2,
            self.image:getHeight() / 2)
end

function EnemyShip:update(dt, enemyBullets)
    self.timeSinceLastBullet = self.timeSinceLastBullet + dt
    if self.timeSinceLastBullet > self.firingRate then
        if self.type == 4 then
            -- boss ship
            self:insertBossBullets(enemyBullets)
        else
            -- non boss ships
            local newBullet = Bullet:new(nil, self.x - 25, self.y, 6, true)
            table.insert(enemyBullets, newBullet)
        end
        self.timeSinceLastBullet = 0
    end

    self.timeSinceLastDirChange = self.timeSinceLastDirChange + dt
    if self.timeSinceLastDirChange > self.directionChangeInterval then
        self.velX = math.random(-1 * self.movementMultiplier, 1 * self.movementMultiplier)
        self.velY = math.random(-1 * self.movementMultiplier, 1 * self.movementMultiplier)
        self.timeSinceLastDirChange = 0
    end

    self.x = self.x + self.velX
    self.y = self.y + self.velY

    if self.x < 550 or self.x > 1225 then
        self.velX = self.velX * -1
    end

    if self.y < 50 or self.y > 675 then
        self.velY = self.velY * -1
    end
end

function EnemyShip:getScaledWidth()
    return self.image:getWidth() * self.scale;
end

function EnemyShip:getScaledHeight()
    return self.image:getHeight() * self.scale;
end

function EnemyShip:getTopLeftX()
    return self.x - self:getScaledWidth() / 2;
end

function EnemyShip:getTopLeftY()
    return self.y - self:getScaledHeight() / 2;
end

function EnemyShip:getScoreValue()
    return self.scoreValue
end

function EnemyShip:getHitbox()
    if self.type == 4 then
        return self:getTopLeftX() + (self:getScaledWidth() / 3),
        self:getTopLeftY(),
        self:getScaledWidth() / 2,
        self:getScaledHeight()
    else
        return self:getTopLeftX(), self:getTopLeftY(), self:getScaledWidth(), self:getScaledHeight()
    end
end

function EnemyShip:insertBossBullets(enemyBullets)
    local turrentDisabled = math.random(1, 5)

    if turrentDisabled ~= 1 then
        local newBullet1 = Bullet:new(nil, self.x + 50, self.y - 330, 6, true)
        local newBullet2 = Bullet:new(nil, self.x + 50, self.y - 280, 6, true)
        local newBullet3 = Bullet:new(nil, self.x + 50, self.y - 230, 6, true)
        table.insert(enemyBullets, newBullet1)
        table.insert(enemyBullets, newBullet2)
        table.insert(enemyBullets, newBullet3)
    end

    if turrentDisabled ~= 2 then
        local newBullet4 = Bullet:new(nil, self.x - 75, self.y - 190, 6, true)
        local newBullet5 = Bullet:new(nil, self.x - 75, self.y - 140, 6, true)
        local newBullet6 = Bullet:new(nil, self.x - 75, self.y - 90, 6, true)
        table.insert(enemyBullets, newBullet4)
        table.insert(enemyBullets, newBullet5)
        table.insert(enemyBullets, newBullet6)
    end

    if turrentDisabled ~= 3 then
        local newBullet7 = Bullet:new(nil, self.x - 225, self.y - 50, 6, true)
        local newBullet8 = Bullet:new(nil, self.x - 225, self.y + 50, 6, true)
        local newBullet9 = Bullet:new(nil, self.x - 225, self.y, 6, true)
        table.insert(enemyBullets, newBullet7)
        table.insert(enemyBullets, newBullet8)
        table.insert(enemyBullets, newBullet9)
    end

    if turrentDisabled ~= 4 then
        local newBullet10 = Bullet:new(nil, self.x - 75, self.y + 90, 6, true)
        local newBullet11 = Bullet:new(nil, self.x - 75, self.y + 140, 6, true)
        local newBullet12 = Bullet:new(nil, self.x - 75, self.y + 190, 6, true)
        table.insert(enemyBullets, newBullet10)
        table.insert(enemyBullets, newBullet11)
        table.insert(enemyBullets, newBullet12)
    end

    if turrentDisabled ~= 5 then
        local newBullet13 = Bullet:new(nil, self.x + 50, self.y + 230, 6, true)
        local newBullet14 = Bullet:new(nil, self.x + 50, self.y + 280, 6, true)
        local newBullet15 = Bullet:new(nil, self.x + 50, self.y + 330, 6, true)
        table.insert(enemyBullets, newBullet13)
        table.insert(enemyBullets, newBullet14)
        table.insert(enemyBullets, newBullet15)
    end
end

return EnemyShip