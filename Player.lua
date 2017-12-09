local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local P = StateMachine:derive("Player")

local hero_atlas
local sprite
local snd

local idle = Anim(16, 16, 16, 16, 4, 4, 6)
local walk = Anim(16, 32, 16, 16, { 1, 2, 3, 4, 5, 6 }, 6, 12)
-- local jump = Anim(16, 48, 16, 16, { 1, 2, 3, 4}, 6, 10)
local jump = Anim(16, 48, 16, 16, { 1 }, 6, 10)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 20, false)


function P:new(state)
    if hero_atlas == nil then
        hero_atlas = love.graphics.newImage("assets/sprites/hero.png")
    end

    if snd == nil then
        snd = love.audio.newSource("assets/sfx/hits/hit01.wav", "static")
    end

    self.spr = Sprite(hero_atlas, 100, 100, 16, 16, 4, 4)
    self.spr:add_animations({
        idle = idle, 
        walk = walk, 
        swim = swim, 
        jump = jump, 
        punch = punch
    })
    self.spr:animate("idle")

    self.super.new(self, state)
end

function P:update(dt)
    self.super.update(self, dt)
    self.spr:update(dt)
end

function P:draw()
    self.spr:draw()
end

function P:idle_enter(dt)
    self.spr:animate("idle")
end
    
function P:idle(dt)
    if Key:key_down("space") then
        self:change("punch")
    end
end
    
function P:idle_exit(dt)

end

function P:punch_enter(dt)
    self.spr:animate("punch")
    love.audio.stop(snd)        
    love.audio.play(snd)
end

function P:punch(dt)
    if self.spr:animation_finished() then
        self:change("idle")
    end
end

return P