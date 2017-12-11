local Class = require("lib.Class")
local Anim = require("lib.Animation")
local Vector2 = require("lib.Vector2")

local Sprite = Class:derive("Sprite")

function Sprite:new(atlas, x, y, width, height, sx, sy, angle, colour)
    self.pos = Vector2(x or 0, y or 0)
    self.width = width
    self.height = height
    self.flip = Vector2(1, 1)
    self.scale = Vector2(sx or 1, sy or 1)    
    self.atlas = atlas
    self.animations = {}
    self.current_animation = ""
    self.angle = angle or 0
    self.quad = love.graphics.newQuad(0, 0, width, height, atlas:getDimensions())
    self.tintColour = colour or { 255, 255, 255, 255 }
end

function Sprite:animate(anim_name)
    if self.current_animation ~= anim_name and self.animations[anim_name] ~= nil then
        self.animations[anim_name]:reset()
        self.animations[anim_name]:set(self.quad)
        self.current_animation = anim_name
    elseif self.animations[anim_name] == nil then
        assert(false, anim_name .. " animation not found.")
    end
end

function Sprite:flip_h(flip)
    if flip then
        self.flip.x = -1
    else
        self.flip.x = 1
    end
end

function Sprite:flip_v(flip)
    if flip then
        self.flip.y = -1
    else
        self.flip.y = 1
    end
end

function Sprite:animation_finished()
    if self.animations[self.current_animation] ~= nil then
        return self.animations[self.current_animation].done
    end
    return true
end

function Sprite:add_animations(animations)
    assert(type(animations) == "table", "Add animations parameter must be a table")
    for k, v in pairs(animations) do
        self.animations[k] = v
    end
end

function Sprite:rect()
    local r = { w = self.width * self.scale.x, h = self.height * self.scale.y }
    r.x = self.pos.x - r.w / 2
    r.y = self.pos.y - r.h / 2
    return r
end

function Sprite:update(dt)
    if self.animations[self.current_animation] ~= nil then
        self.animations[self.current_animation]:update(dt, self.quad)
    end
end

function Sprite:draw()
    love.graphics.setColor(self.tintColour)
    love.graphics.draw(self.atlas, self.quad, self.pos.x, self.pos.y, self.angle, self.scale.x * self.flip.x, self.scale.y * self.flip.y, self.width / 2, self.height / 2)

    local r = self:rect()
    love.graphics.rectangle("line", r.x, r.y, r.w, r.h)
end

return Sprite