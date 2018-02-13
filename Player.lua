local Entity = require("lib.Entity")
local StateMachine = require("lib.components.StateMachine")
local Anim = require("lib.Animation")
local Transform = require("lib.components.Transform")
local Sprite = require("lib.components.Sprite")

local P = Entity:derive("Player")

local hero_atlas
local snd


local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local walk = Anim(16, 32, 16, 16, { 1, 2, 3, 4, 5, 6 }, 6, 12)
-- local jump = Anim(16, 48, 16, 16, { 1, 2, 3}, 6, 10, false)
local jump = Anim(16, 48, 16, 16, 1, 1, 10, false)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 20, false)

local transform
local sprite
local machine

local move_speed = 100


function P:new()
    P.super.new(self)
    if hero_atlas == nil then
        hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    end

    if snd == nil then
        snd = love.audio.newSource("assets/sfx/hits/hit01.wav", "static")
    end

    sprite = Sprite(hero_atlas, 16, 16, 4, 4)
    sprite:add_animations({
        idle = idle, 
        walk = walk, 
        swim = swim, 
        jump = jump, 
        punch = punch
    })
    sprite:animate("idle")

    transform = Transform(100, 100, 0)
    machine = StateMachine(self, "idle")
    self:add(transform)
    self:add(sprite)
    self:add(machine)
    
    self.vx = 0
end

function P:idle_enter(dt)
    sprite:animate("idle")
end
    
function P:idle(dt)
    if Key:key("left") or Key:key("right") then
        machine:change("walk")
    elseif Key:key_down("space") then
        machine:change("punch")
    elseif Key:key_down("z") then
        machine:change("jump")
    end
end
    
function P:idle_exit(dt)

end

function P:punch_enter(dt)
    sprite:animate("punch")
    love.audio.stop(snd)        
    love.audio.play(snd)
end

function P:punch(dt)
    if sprite:animation_finished() then
        machine:change("idle")
    end
end

local jumping = false
local y_before_jump = nil
function P:jump_enter(dt)
    jumping = true
    sprite:animate("jump")
end

function P:jump(dt)
    if not jumping then
        machine:change("idle")
        y_before_jump = nil
    elseif Key:key_down("space") then
        machine:change("punch")
    end
end

function P:walk_enter(dt)
    sprite:animate("walk")
end

function P:walk(dt)
    if Key:key("left") and not Key:key("right") and vx ~= -1 then
        sprite:flip_h(true)
        self.vx = -1
    elseif Key:key("right") and not Key:key("left") and vx ~= 1 then
        sprite:flip_h()
        self.vx = 1
    elseif not Key:key("left") and not Key:key("right")then
        self.vx = 0
        machine:change("idle")
    end
        
    if Key:key_down("space") then
        self.vx = 0
        machine:change("punch")
    elseif Key:key_down("z") then
        machine:change("jump")
    end
end

local y_grav = 1000
local y_vel = 0
function P:update(dt)
    P.super.update(self, dt)

    if Key:key("up") then
        transform.y = transform.y - move_speed * dt
    elseif Key:key("down") then
        transform.y = transform.y + move_speed * dt
    end

    transform.x = transform.x + self.vx * move_speed * dt

    if jumping and y_before_jump == nil then
        y_vel = -400
        y_before_jump = transform.y
    elseif jumping then
        y_vel = y_vel + (y_grav * dt)
        transform.y = transform.y + y_vel * dt

        if transform.y >= y_before_jump then
            jumping = false
            transform.y = y_before_jump
            y_before_jump = nil
            self.vx = 0
            machine:change("idle")
        end
    end
end

function P:collided(top, bottom, left, right)
    if bottom then
        jumping = false
        y_before_jump = nil
        self.vx = 0
        machine:change("idle")
    end
end

function P:draw()
    sprite:draw()
end

return P