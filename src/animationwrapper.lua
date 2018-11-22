AnimationWrapper = {}

function AnimationWrapper:new (o, spriteSheet, anim8animation, x, y, expiresAfter, scale)
    self.__index = self
    return setmetatable({
        spriteSheet = spriteSheet,
        anim8animation = anim8animation:clone(),
        x = x,
        y = y,
        done = false,
        expiresAfter = expiresAfter or 1,
        elapsedDuration = 0,
        scale = scale or 1
    }, self)
end

function AnimationWrapper:update(dt)
    self.anim8animation:update(dt)
    self.elapsedDuration = self.elapsedDuration + dt
end

function AnimationWrapper:draw()
    width, height = self.anim8animation:getDimensions()
    self.anim8animation:draw(self.spriteSheet, self.x, self.y, 0, self.scale, self.scale, width / 2, height / 2)
end