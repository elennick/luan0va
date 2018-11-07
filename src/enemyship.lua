EnemyShip = { x = 0, y = 0 }

function EnemyShip:new (o, x, y, image, scale)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        image = image,
        scale = scale or 0.7
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

function EnemyShip:update(dt)
    -- do whatever
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