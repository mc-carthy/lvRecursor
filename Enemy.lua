local Class = require("lib.Class")
local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local Enemy = Class:derive("Enemy")

local enemy_atlas
local sprite

local idle = Anim(0, 0, 128, 80, 2, 2, 6)

local move_speed = 100


function Enemy:new()
    if enemy_atlas == nil then
        enemy_atlas = love.graphics.newImage("assets/sprites/missile.png")
    end

    self.spr = Sprite(enemy_atlas, 0, 80, 124, 80, 1, 1)
    self.spr:add_animations({ idle = idle })
    self.spr:animate("idle")
    self.vx = 0
end

function Enemy:update(dt)
    self.spr:update(dt)
end

function Enemy:draw()
    self.spr:draw()
end

return Enemy