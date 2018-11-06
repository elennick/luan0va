BackgroundStar = { x = 0, y = 0, size = 2, r = 255, g = 255, b = 255, speed = 5 }

function BackgroundStar:new (o, x, y, size, r, g, b, speed)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        size = size or 2,
        r = r or 255,
        g = g or 255,
        b = b or 255,
        speed = speed or 5
    }, self)
end

function BackgroundStar:draw()
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
    love.graphics.setColor(255, 255, 255)
end

return BackgroundStar