local class = require("class")
local Sprite = class:derive("Sprite")
local Anim = require("Animation")
local Vector2 = require("Vector2")

function Sprite:new(atlas, width, height, x, y, sx, sy, angle)
    self.width = width
    self.height = height
    self.pos = Vector2(x or 0, y or 0)
    self.scale = Vector2(sx or 1, sy or 1)    
    self.atlas = atlas
    self.animations = {}
    self.current_animation = ""
    self.angle = angle or 0
    self.quad = love.graphics.newQuad(0, 0, width, height, atlas:getDimensions())
end

function Sprite:animate(anim_name)
    if self.current_animation ~= anim_name and self.animations[anim_name] ~= nil then
        self.animations[anim_name]:reset()
        self.animations[anim_name]:set(self.quad)
        self.current_animation = anim_name
    end
end

function Sprite:animation_finished()
    if self.animations[self.current_animation] ~= nil then
        return self.animations[self.current_animation].done
    end
    return true
end

function Sprite:add_animation(name, anim)
    self.animations[name] = anim
end

function Sprite:update(dt)
    if self.animations[self.current_animation] ~= nil then
        self.animations[self.current_animation]:update(dt, self.quad)
    end
end

function Sprite:draw()
    love.graphics.draw(self.atlas, self.quad, self.pos.x, self.pos.y, self.angle, self.scale.x, self.scale.y, self.width / 2, self.height / 2)
end

return Sprite