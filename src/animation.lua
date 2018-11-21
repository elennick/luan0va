Animation = { x = 0, y = 0 }

function Animation:new (o, x, y, images, loop)
    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        images = images,
        loop = loop or false
    }, self)
end

function Animation:draw()

end

function Animation:update(dt)

end

return Bullet