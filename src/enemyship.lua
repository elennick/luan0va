EnemyShip = {
    x = 0,
    y = 0,
    timeSinceLastBullet = 0,
    timeSinceLastDirChange = 0
}

function EnemyShip:new (o, x, y, image, scale)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        image = image,
        timeSinceLastBullet = timeSinceLastBullet or 0,
        timeSinceLastDirChange = timeSinceLastDirChange or 0,
        scale = scale or 0.7,
        velX = velX or math.random(-1, 1),
        velY = velY or math.random(-1, 1),
        firingRate = firingRate or math.random(2, 5)
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
        local newBullet = Bullet:new(nil, self.x - 25, self.y, 6)
        table.insert(enemyBullets, newBullet)
        self.timeSinceLastBullet = 0
    end

    self.timeSinceLastDirChange = self.timeSinceLastDirChange + dt
    if self.timeSinceLastDirChange > 10 then
        self.velX = math.random(-1, 1)
        self.velY = math.random(-1, 1)
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

return EnemyShip