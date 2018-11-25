Bullet = { x = 0, y = 0 }

function Bullet:new (o, x, y, size, trail)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        size = size or 5,
        trail = trail or false
    }, self)
end

function Bullet:draw(r, g, b)
    -- trail
    if self.trail then
        love.graphics.setColor(1, 1, 1)
        love.graphics.line(self.x, self.y, self.x + 10, self.y)
        love.graphics.setColor(.7, .7, .7)
        love.graphics.line(self.x, self.y - 1, self.x + 10, self.y - 1)
        love.graphics.line(self.x, self.y + 1, self.x + 10, self.y + 1)
        love.graphics.line(self.x + 11, self.y, self.x + 18, self.y)
    end

    -- bullet
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
    love.graphics.setColor(r, g, b)
    love.graphics.circle("fill", self.x, self.y, self.size - 1, 20)

    -- reset color to white
    love.graphics.setColor(1, 1, 1)
end

function Bullet:update(dt, velocity)
    self.x = self.x + velocity
end

return Bullet