local Class = require("lib.Class")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Missile = Class:derive("Missile")

local missile
local sprite
local target_object

local idle = Anim(0, 0, 128, 80, 2, 2, 6)

local move_speed = 100
local rotation_speed = 200
local missile_speed = 50


function Missile:new(x, y)
    if missile == nil then
        missile = love.graphics.newImage("assets/sprites/missile.png")
    end

    self.spr = Sprite(missile, x, y, 124, 80, 1, 1)
    self.spr:add_animations({ idle = idle })
    self.spr:animate("idle")
    self.vx = 0
end

function Missile:target(object)
    target_object = object
end

function Missile:update(dt)
    if target_object ~= nil then
        local missile_to_target = Vector2.subtract(target_object.pos, self.spr.pos)
        missile_to_target:normalise()
        local missile_dir = Vector2(math.cos(self.spr.angle), math.sin(self.spr.angle))
        missile_dir:normalise()

        local cp = Vector3.cross(missile_dir, missile_to_target)
        
        self.spr.angle = self.spr.angle + cp.z * rotation_speed * dt * (math.pi / 180)
        self.spr.pos.x = self.spr.pos.x + (missile_dir.x * missile_speed * dt)
        self.spr.pos.y = self.spr.pos.y + (missile_dir.y * missile_speed * dt)
    end

    self.spr:update(dt)
end

function Missile:draw()
    self.spr:draw()
end

return Missile