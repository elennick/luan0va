EnemyShip = { x = 0, y = 0 }

function EnemyShip:new (o, x, y, graphic)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        graphic = graphic
    }, self)
end

function EnemyShip:draw()
    love.graphics.draw(self.graphic, self.x, self.y, math.rad(-90), 0.7, 0.7)
end

function EnemyShip:update(dt)
    -- do whatever
end

return EnemyShip