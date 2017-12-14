local Entity = require("lib.Entity")
local Anim = require("lib.Animation")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Transform = require("lib.components.Transform")
local Sprite = require("lib.components.Sprite")

local Missile = Entity:derive("Missile")

local missile
local sprite
local target_object

local idle = Anim(0, 0, 128, 80, 2, 2, 6)

local move_speed = 100
local rotation_speed = 200
local missile_speed = 50


function Missile:new(x, y)
    Missile.super.new(self)
    if missile == nil then
        missile = love.graphics.newImage("assets/sprites/missile.png")
    end

    local spr = Sprite(missile, 124, 80, 1, 1)
    spr:add_animations({ idle = idle })
    spr:animate("idle")

    self:add(Transform(x, y, 0))
    self:add(spr)

    self.vx = 0
end

function Missile:target(object)
    target_object = object
end

function Missile:update(dt)
    if target_object ~= nil then
        local missile_to_target = Vector2.subtract(target_object:center(), self.Sprite:center())
        missile_to_target:normalise()
        local missile_dir = Vector2(math.cos(self.Transform.rotation), math.sin(self.Transform.rotation))
        missile_dir:normalise()

        local cp = Vector3.cross(missile_dir, missile_to_target)
        
        self.Transform.rotation = self.Transform.rotation + cp.z * rotation_speed * dt * (math.pi / 180)
        self.Transform.x = self.Transform.x + (missile_dir.x * missile_speed * dt)
        self.Transform.y = self.Transform.y + (missile_dir.y * missile_speed * dt)
    end

    self.Sprite:update(dt)
end

function Missile:draw()
    self.Sprite:draw()
end

return Missile