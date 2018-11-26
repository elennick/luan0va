PlayerShip = { x = 0, y = 0 }

function PlayerShip:new (o, x, y, image, startingEnergy, health)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        image = image,
        health = health or 10,
        energy = startingEnergy,
        scale = 0.8
    }, self)
end

function PlayerShip:draw()
    love.graphics.draw(
            self.image,
            self.x,
            self.y,
            math.rad(90),
            self.scale,
            self.scale,
            self.image:getWidth() / 2,
            self.image:getHeight() / 2)
end

function PlayerShip:update(dt)
    -- do whatever
end

function PlayerShip:getScaledWidth()
    return self.image:getWidth() * self.scale;
end

function PlayerShip:getScaledHeight()
    return self.image:getHeight() * self.scale;
end

function PlayerShip:getTopLeftX()
    return self.x - self:getScaledWidth() / 2;
end

function PlayerShip:getTopLeftY()
    return self.y - self:getScaledHeight() / 2;
end

function PlayerShip:getHitbox()
    return self:getTopLeftX(), self:getTopLeftY(), self:getScaledWidth(), self:getScaledHeight()
end

return PlayerShip