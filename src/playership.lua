PlayerShip = { x = 0, y = 0 }

function PlayerShip:new (o, x, y, image)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        image = image
    }, self)
end

function PlayerShip:draw()
    love.graphics.draw(self.image, self.x, self.y, math.rad(-90), 1, 1)
end

function PlayerShip:update(dt)
    -- do whatever
end

return PlayerShip