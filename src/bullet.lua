Bullet = { x = 0, y = 0 }

function Bullet:new (o, x, y)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
    }, self)
end

function Bullet:draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.circle("fill", self.x, self.y, 5, 20)
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", self.x, self.y, 4, 20)
    love.graphics.setColor(255, 255, 255)
end

function Bullet:update(dt)
    self.x = self.x + 10
end

return Bullet