Bullet = { x = 0, y = 0 }

function Bullet:new (o, x, y, size)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        size = size or 5
    }, self)
end

function Bullet:draw(r, g, b)
    love.graphics.setColor(255, 255, 0)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
    love.graphics.setColor(r, g, b)
    love.graphics.circle("fill", self.x, self.y, self.size - 1, 20)
    love.graphics.setColor(255, 255, 255)
end

function Bullet:update(dt, velocity)
    self.x = self.x + velocity
end

return Bullet