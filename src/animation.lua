Animation = { x = 0, y = 0, done = false }

function Animation:newSpriteSheetAnimation(o, spriteSheet, loop, rotation, height, width)
    images = {}

    return self:newChoppedAnimation(o, images, loop, rotation)
end

function Animation:newChoppedAnimation (o, images, loop, rotation)
    local currentFrameIndex = 1
    local timeElapsedSinceLastFrameChange = 0
    local done = false

    self.__index = self
    return setmetatable({
        x = x or 0,
        y = y or 0,
        images = images,
        loop = loop or false,
        rotation = rotation or 0,
        currentFrameIndex = currentFrameIndex,
        timeElapsedSinceLastFrameChange = timeElapsedSinceLastFrameChange,
        done = done
    }, self)
end

function Animation:draw()
    if self.images == nil or table.getn(self.images) <= 0 then
        return
    end

    love.graphics.draw(
            self.images[self.currentFrameIndex],
            self.x,
            self.y,
            self.rotation,
            1,
            1,
            self.images[self.currentFrameIndex]:getWidth() / 2,
            self.images[self.currentFrameIndex]:getHeight() / 2)
end

function Animation:draw(x, y)
    if self.images == nil or table.getn(self.images) <= 0 then
        return
    end

    love.graphics.draw(
            self.images[self.currentFrameIndex],
            x,
            y,
            self.rotation,
            1,
            1,
            self.images[self.currentFrameIndex]:getWidth() / 2,
            self.images[self.currentFrameIndex]:getHeight() / 2)
end

function Animation:update(dt)
    self.timeElapsedSinceLastFrameChange = self.timeElapsedSinceLastFrameChange + dt
    if self.timeElapsedSinceLastFrameChange > .08 then
        if self.currentFrameIndex + 1 > table.getn(self.images) and self.loop == true then
            self.currentFrameIndex = 1
        elseif self.currentFrameIndex + 1 > table.getn(self.images) and self.loop == false then
            done = true
        else
            self.currentFrameIndex = self.currentFrameIndex + 1
        end

        self.timeElapsedSinceLastFrameChange = 0
    end
end

function Animation:getScaledWidth()
    return self.images[self.currentFrameIndex]:getWidth() * self.scale;
end

function Animation:getScaledHeight()
    return self.images[self.currentFrameIndex]:getHeight() * self.scale;
end

function Animation:getTopLeftX()
    return self.x - self:getScaledWidth() / 2;
end

function Animation:getTopLeftY()
    return self.y - self:getScaledHeight() / 2;
end

function Animation:getDone()
    return self.done
end

return Animation